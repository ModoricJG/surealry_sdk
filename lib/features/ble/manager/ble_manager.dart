import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_info_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/device_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/script/app_to_web.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/command_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_check_timer.dart';

class BleManager {
  static final BleManager instance = BleManager._internal();
  factory BleManager() => instance;
  BleManager._internal();

  Timer? timer;
  Device? deviceInfo;
  String testStickColor = "";
  int dialogCount = 0;
  int errorCount = 0;
  int connectTimeOutCount = 0;
  String responsePiece = "";
  bool isRxCharacteristicCompleted = false;
  late StreamSubscription<List<int>>? stream;
  String lastCmd = '';
  late BluetoothCharacteristic? wxCharacteristic;
  late BluetoothCharacteristic? rxCharacteristic;
  String appVersion = "";
  bool isRepeat = false;
  bool isReset = false;

  void resetConnectStatus({required WidgetRef ref}) {
    dialogCount = 0;
    connectTimeOutCount = 0;
    isRepeat = false;

    ref.read(deviceConnectStateProvider.notifier).state = DeviceState.none;
    resetDeviceStatus(ref: ref);
  }

  void resetDeviceStatus({required WidgetRef ref}) {
    ref.read(discoverdDevice.notifier).state = null;
    ref.read(deviceNotifierProvider.notifier).state = null;
    ref.read(discoverdDeviceList.notifier).state = [];
    ref.read(discoverdRecentDeviceList.notifier).state = [];
  }

  void resetBleStatus({required WidgetRef ref}) {
    resetDeviceStatus(ref: ref);
    
    ref.read(devInfoResponse.notifier).state = null;
  }

  void disconnectDevice({required WidgetRef? ref, bool isGoToFail = true}) {
    if (!deviceIsConnected(ref: ref)) { return; }

    StickCheckTimer().stopTimer();
    isRepeat = false;
    ref?.read(moveToConnectFail.notifier).state = isGoToFail;
    BluetoothDevice? device = ref?.read(deviceNotifierProvider.notifier).state;
    device?.disconnect();
  }

  Future<void> startScan(
      {required WidgetRef ref, InAppWebViewController? controller}) async {
    resetConnectStatus(ref: ref);

    FlutterBluePlus.setLogLevel(LogLevel.debug, color: true);
     
    await FlutterBluePlus.startScan();
    _checkTimeOut(ref: ref);

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.localName.isNotEmpty &&
            BleUtils().isSurearlyDeivce(deviceName: r.device.localName)) {
          ref.read(discoverdDevice.notifier).state = r.device;
        }
      }
    });
  }

  void stopScan() async {
    timer?.cancel();
    await FlutterBluePlus.stopScan();
  }

  void _checkTimeOut({required WidgetRef ref}) {
    timer = Timer(
        Duration(
            seconds: deviceInfo?.deviceSearchSeconds ??
                DeviceConstants.searchTimeout), () {
      final deviceList = ref.read(discoverdDeviceList.notifier).state;
      final recentList = BleUtils().getRecentTestDevices(ref: ref);
      if (deviceList.isEmpty && recentList.isEmpty) {
        stopScan();
        ref.read(deviceConnectStateProvider.notifier).state =
            DeviceState.timeout;
      }
    });
  }

  void connectToSelectedDevice(
      {required WidgetRef ref, BluetoothDevice? device}) async {
    if (device != null) {
      BleManager().stopScan();
      bool isTimeOut = false;
      final errorCode = (Platform.isAndroid) ? '0133' : '0001';

      ref.read(deviceNotifierProvider.notifier).state = device;
      ref.read(deviceConnectStateProvider.notifier).state =
          DeviceState.connecting;
      await device
          .connect(timeout: Duration(seconds: DeviceConstants.connectTimeout))
          .timeout(Duration(seconds: DeviceConstants.connectTimeout), onTimeout: () {
        isTimeOut = true;
        connectTimeOutCount += 1;
      }).then((data) async {  
        if (isTimeOut && connectTimeOutCount <= 1) {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            await device.connect(timeout: Duration(seconds: DeviceConstants.connectTimeout))
            .timeout(Duration(seconds: DeviceConstants.connectTimeout), onTimeout: () {
              ref.read(deviceConnectStateProvider.notifier).state =
                  DeviceState.disconnected;
            }).onError((error, stackTrace) {
              deviceErrorEnd(ref: ref, code: errorCode);
            });
          });
        }
      }).onError((error, stackTrace) {
        deviceErrorEnd(ref: ref, code: errorCode);
      });

      if (Platform.isAndroid) {
        device.bondState.listen((event) {
          if (event == BluetoothBondState.failed && dialogCount > 0) {
            ref.read(deviceConnectStateProvider.notifier).state =
                DeviceState.pairingCancel;
          }
        });
      }

      device.connectionState.listen((BluetoothConnectionState state) async {
        final currentDeviceViewState = ref.read(deviceConnectStateProvider.notifier).state;
        if (state == BluetoothConnectionState.disconnected) {
          StickCheckTimer().stopTimer();

          if (currentDeviceViewState != DeviceState.pairingCancel && !isTimeOut) {
            ref.read(deviceConnectStateProvider.notifier).state =
                DeviceState.disconnected;
          }
        } else if (state == BluetoothConnectionState.connected) {
          setBleServices(ref: ref);
        }
      });
    }
  }

  void setBleServices({required WidgetRef ref}) async {
    if (!deviceIsConnected(ref: ref)) {
      return;
    }

    final device = ref.read(deviceNotifierProvider);
    List<BluetoothService> services = await device!.discoverServices();

    for (BluetoothService service in services) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.writeWithoutResponse) {
          wxCharacteristic = c;
        } else {
          rxCharacteristic = c;
        }
      }
    }

    if (Platform.isAndroid) {
      await device.requestMtu(512);
    }

    if ((Platform.isAndroid && dialogCount <= 0) || Platform.isIOS) {
      receivedData(ref: ref);
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        connectStatChk(ref: ref);
      });
    }
  }

  void connectStatChk({required WidgetRef ref}) async {
    responsePiece = '';
    if (ref.read(deviceConnectStateProvider) == DeviceState.connecting) {
      await Future.delayed(const Duration(seconds: 1)).then((_) {
        wxCharacteristic
            ?.write(CommandUtils().statkChkCommand(), withoutResponse: false)
            .catchError((dynamic error) {
          if (ref.read(deviceConnectStateProvider.notifier).state !=
              DeviceState.pairingCancel) {
            ref.read(deviceConnectStateProvider.notifier).state =
                DeviceState.disconnected;
          }
        }).whenComplete(() {
          if (ref.read(deviceConnectStateProvider) == DeviceState.connecting) {
            if (Platform.isIOS && dialogCount >= 1) {
              Future.delayed(const Duration(milliseconds: 1500))
                  .then((_) async {
                await wxCharacteristic
                    ?.write(CommandUtils().statkChkCommand(),
                        withoutResponse: false)
                    .whenComplete(() {
                  ref.read(deviceConnectStateProvider.notifier).state =
                      DeviceState.connected;
                });
              });
            } else {
              ref.read(deviceConnectStateProvider.notifier).state =
                  DeviceState.connected;
            }
          }
        }).timeout(Duration(seconds: DeviceConstants.searchTimeout),onTimeout: () {});
      });
    }
  }

  void receivedData({required WidgetRef ref}) async {
    if (isRxCharacteristicCompleted) {
      return;
    }

    await rxCharacteristic?.setNotifyValue(true).then((value) {
      isRxCharacteristicCompleted = true;
      stream = rxCharacteristic?.onValueReceived.listen((value) {
        StickCheckTimer().stopTimer();
        onNewReceivedData(data: value, ref: ref);
      });
    }).catchError((dynamic error) {
      if (error.toString().contains("code: 15") && Platform.isIOS) {
        ref.read(deviceConnectStateProvider.notifier).state =
            DeviceState.pairingCancel;
      }
    });
  }

  void writeCommandToDevice(
      {required DeviceCommand command,
      required WidgetRef? ref,
      int delayTime = DeviceConstants.commandDelayTime,
      int? level,
      List<int>? cmdList}) async {
    responsePiece = '';
    List<int> cmd = (cmdList == null) ?
        CommandUtils().getCommandString(command: command, level: level) : cmdList;

    print("writee!!!!!!!!!!!!! = ${command.name}");

    Future.delayed(Duration(milliseconds: delayTime)).then((_) async {
      if (ref?.read(deviceConnectStateProvider.notifier).state ==
          DeviceState.disconnected) {
        return;
      }

      await wxCharacteristic
          ?.write(cmd, withoutResponse: false)
          .catchError((dynamic error) {
      }).then((value) {
        StickCheckTimer().startCheckResponse();
      });
    });
  }

  void retryWritCommandToDevice({required WidgetRef? ref}) async {
    if (!deviceIsConnected(ref: ref)) { return; }
    final cmdList = CommandUtils().makeCodeUnits(lastCmd);
    writeCommandToDevice(command: DeviceCommand.ERROR, ref: ref, cmdList: cmdList);
  }

  void writeCommandError({required WidgetRef? ref}) {
    if (errorCount < 3) {
      errorCount += 1;
      retryWritCommandToDevice(ref: ref);
    } else {
      deviceErrorEnd(ref: ref, code: '0003');
    }
  }

  void onNewReceivedData({required List<int> data, required WidgetRef ref}) {
    responsePiece += String.fromCharCodes(data).trim();
    checkReceiveString(resultText: responsePiece, ref: ref);
  }

  void checkReceiveString(
      {required String resultText, required WidgetRef ref}) {
    if (BleUtils().isValidCommandResponse(resultText: resultText)) {
      BleUtils()
          .getJsonStringFromReceiveData(receiveString: resultText, ref: ref);
    }
  }

  bool deviceIsConnected({required WidgetRef? ref}) {
    final device = ref?.read(deviceNotifierProvider);
    final deviceConnectState = ref?.read(deviceConnectStateProvider.notifier).state;
    if (device == null || deviceConnectState == DeviceState.disconnected) {
      return false;
    }
    return true;
  }

  deviceErrorEnd({required WidgetRef? ref, required String code}) {
    BleManager().disconnectDevice(ref: ref, isGoToFail: false);

    if (deviceIsConnected(ref: ref)) {
      final controller = ref?.read(webViewControllerProvider.notifier).state;
      AppToWeb().showErrorDialog(controller: controller, code: "D-$code");
    }
  }
}
