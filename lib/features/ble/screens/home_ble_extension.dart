import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/log_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/lot_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/statchk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_info_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_result_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_screen.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_web_extension.dart';
import 'package:surearly_smart_sdk/shared/constants/app_constants.dart';
import 'package:surearly_smart_sdk/shared/constants/device_constants.dart';
import 'package:surearly_smart_sdk/shared/constants/route_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/web_device.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/script/app_to_web.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/log_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_check_timer.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_out_timer.dart';

extension HomeBleExtension on ConsumerState<HomeScreen> {
  setBleManagerConstants() {
    final InitializeResponse? response =
        ref.read(initializeNotifierProvider.notifier).state;
    BleManager().deviceInfo = response?.data?.device;
    AppConfigs.timerDeviceTestSeconds =
        response?.data?.device?.deviceTestSeconds ?? 300;
  }

  selectTestType(String type) {
    final InitializeResponse? response =
        ref.read(initializeNotifierProvider.notifier).state;

    BleManager().testStickColor =
        BleUtils().getStickColorByTestType(response: response, testType: type);
    ref.read(selectedTestType.notifier).state = type;

    final logData = LogUtils().webEventFormat(
        type: LogType.event, tagType: LogTag.SELECT_TYPE, content: type);
    ref.read(saveLogNotifierProvider(logData));
  }

  Future<void> startBleScan() async {
    Future.delayed(const Duration(seconds: 1)).then((_) async {
      await BleManager().startScan(
          ref: ref,
          controller: ref.read(webViewControllerProvider.notifier).state);
    });
  }

  deviceListState() {
    final deviceState = ref.watch(discoverdDevice);

    List<BluetoothDevice> deviceList =
        ref.read(discoverdDeviceList.notifier).state;
    List<BluetoothDevice> searchAndRecentDeviceList =
        ref.read(discoverdRecentDeviceList.notifier).state;
    List<WebDevice> recentDeviceList =
        BleUtils().getRecentTestDevices(ref: ref);

    if (deviceState == null) {
      return;
    }
    //최근사용 기기는 검색 리스트에 노출 안됨.
    if (!BleUtils().isDuplicateDevice(device: deviceState, list: deviceList) &&
        !BleUtils()
            .isRecentDevice(device: deviceState, list: recentDeviceList)) {
      deviceList.add(deviceState);
      Future.delayed(const Duration(microseconds: 500)).then((_) async {
        ref.read(discoverdDeviceList.notifier).state = deviceList;
      });

      List<WebDevice> webDevices =
          BleUtils().bluetoothListToWebDevice(deviceList: deviceList);
      AppToWeb().setFindDevice(ref: ref, list: webDevices);
    } else if (!BleUtils().isDuplicateDevice(
            device: deviceState, list: searchAndRecentDeviceList) &&
        BleUtils()
            .isRecentDevice(device: deviceState, list: recentDeviceList)) {
      searchAndRecentDeviceList.add(deviceState);
      Future.delayed(const Duration(microseconds: 500)).then((_) async {
        ref.read(discoverdRecentDeviceList.notifier).state =
            searchAndRecentDeviceList;
      });
    }
  }

  deviceConnect({required String selectedDevice}) {
    //연결 할 기기
    WebDevice webDevice = WebDevice.fromJson(json.decode(selectedDevice));

    //검색 리스트
    List<BluetoothDevice> deviceList =
        ref.read(discoverdDeviceList.notifier).state;
    List<BluetoothDevice> recentDeviceList =
        ref.read(discoverdRecentDeviceList.notifier).state;
    BluetoothDevice? connectDevice =
        BleUtils().searchSelectedDevice(ref: ref, webDevice: webDevice);

    if (deviceList.isEmpty && recentDeviceList.isEmpty) {
      changeRecentDevice(device: webDevice);
      Future.delayed(Duration(seconds: DeviceConstants.connectTimeout))
          .then((_) async {
        checkRecentDeviceSearched(webDevice: webDevice);
      });
    } else {
      BleManager().connectToSelectedDevice(ref: ref, device: connectDevice);
      changeStateDeviceList(
          searchList: deviceList,
          recentList: recentDeviceList,
          device: webDevice,
          status: DeviceStatus.connecting);
    }
  }

  changeStateDeviceList(
      {required List<BluetoothDevice> searchList,
      required List<BluetoothDevice> recentList,
      required WebDevice device,
      required DeviceStatus status}) {
    final isSearchedDevice = BleUtils()
            .findDeviceByIdAndName(deviceList: searchList, device: device) !=
        null;

    List<WebDevice> webDevices = BleUtils().bluetoothListToWebDevice(
        deviceList: isSearchedDevice ? searchList : recentList,
        remoteId: device.id,
        status: status);

    if (isSearchedDevice) {
      AppToWeb().setFindDevice(ref: ref, list: webDevices);
    } else {
      AppToWeb().setRecentDevice(ref: ref, list: webDevices);
    }
  }

  changeRecentDevice({required WebDevice device, DeviceStatus? status}) {
    final deviceList = BleUtils().getRecentTestDevices(ref: ref);

    List<WebDevice> recentDevices = BleUtils().recentListToWebDevice(
        deviceList: deviceList,
        remoteId: device.id,
        status: (status == null)
            ? DeviceStatus.connecting
            : DeviceStatus.connectFail);
    AppToWeb().setRecentDevice(ref: ref, list: recentDevices);
  }

  checkRecentDeviceSearched({required WebDevice webDevice}) {
    BluetoothDevice? connectDevice =
        BleUtils().searchSelectedDevice(ref: ref, webDevice: webDevice);

    if (connectDevice == null) {
      changeRecentDevice(device: webDevice, status: DeviceStatus.connectFail);
      AppToWeb().showToastMessage(
          controller: ref.read(webViewControllerProvider.notifier).state,
          toastType: ToastType.connectFailDevice);
    } else {
      BleManager().connectToSelectedDevice(ref: ref, device: connectDevice);
    }
  }

  deviceConnectSuccess() {
    BluetoothDevice? device = ref.read(deviceNotifierProvider.notifier).state;
    updateDeviceStatusList(status: DeviceStatus.connected);
    
    AppToWeb().showToastMessage(
        controller: ref.read(webViewControllerProvider.notifier).state,
        toastType: ToastType.connectedDevice);
    LogUtils().saveLogEvent(
        ref: ref,
        type: LogType.event,
        tag: LogTag.CONNECT_DEVICE,
        content: device?.platformName);
  }

  updateDeviceStatusList({required DeviceStatus status}) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    List<BluetoothDevice> deviceList =
        ref.read(discoverdDeviceList.notifier).state;
    BluetoothDevice? connectedDevice =
        ref.read(deviceNotifierProvider.notifier).state;
    List<WebDevice> recentDeviceList =
        BleUtils().getRecentTestDevices(ref: ref);

    if (status == DeviceStatus.connectFail) {
      ref.read(discoverdDevice.notifier).state = null;
      AppToWeb().showToastMessage(
          controller: controller, toastType: ToastType.connectFailDevice);
    }

    if (deviceList.isEmpty) {
      List<WebDevice> webDevices = BleUtils().recentListToWebDevice(
          deviceList: recentDeviceList,
          remoteId: connectedDevice?.remoteId.str,
          status: status);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
      AppToWeb().setRecentDevice(ref: ref, list: webDevices);
    } else {
      List<WebDevice> webDevices = BleUtils().bluetoothListToWebDevice(
          deviceList: deviceList,
          remoteId: connectedDevice?.remoteId.str,
          status: status);

      AppToWeb().setFindDevice(ref: ref, list: webDevices);
    }
  }

  deviceState() {
    ref.listen(
      deviceConnectStateProvider.select((value) => value),
      ((previous, next) {
        if (previous != next) {
          StickCheckTimer().stopTimer;
          print("================connectState $next");
          if (next == DeviceState.disconnected) {
            if (previous == DeviceState.connecting) {
              updateDeviceStatusList(status: DeviceStatus.connectFail);
            } else {
              if (ref.read(moveToConnectFail.notifier).state) {
                BleManager().resetDeviceStatus(ref: ref);
                LogUtils().saveLogEvent(
                    ref: ref,
                    type: LogType.view,
                    tag: LogTag.RE_SEARCH_DEVICE);
                AppToWeb().moveToConnectFail(
                    ref: ref, type: FailType.deviceDisconnected);
              }
            }
          } else if (next == DeviceState.connecting) {
          } else if (next == DeviceState.connected) {
            deviceConnectSuccess();
          } else if (next == DeviceState.pairingCancel ||
              next == DeviceState.timeout) {
            BleManager().stopScan();
            BleManager().resetDeviceStatus(ref: ref);
            AppToWeb().setFindDevice(ref: ref, list: []);

            LogUtils().saveLogEvent(
                ref: ref,
                type: LogType.view,
                tag: (next == DeviceState.pairingCancel)
                    ? LogTag.PAIRING_FAIL
                    : LogTag.NOT_FOUND_DEVICE);
            AppToWeb().moveToConnectFail(
                ref: ref,
                type: (next == DeviceState.pairingCancel)
                    ? FailType.fairing
                    : FailType.deviceNotFound);
          }
        }
      }),
    );
  }

  statChkState() {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    final testType = ref.read(selectedTestType.notifier).state ?? '';

    ref.listen(
      stickStateProvider(ref).select((value) => value),
      ((previous, next) {
        bool isFirst = ref.read(firstConnected.notifier).state;
        if (isFirst) {
          sleep(const Duration(seconds: 1));
          ref.read(firstConnected.notifier).state = false;
        }

        if (previous != next) {
          if (previous == ViewState.err_eject) {
            StickOutTimer().stopTimer();
          }

          if (next == ViewState.none) {
            AppToWeb().moveToStickGuide(
                controller: controller,
                stickGuide: StickGuide.beforeInsert,
                testType: testType);
          } else if (next == ViewState.err_content) {
            AppToWeb().moveToStickGuide(
                controller: controller,
                stickGuide: StickGuide.otherStick,
                testType: testType);
          } else if (next == ViewState.err_used) {
            AppToWeb().moveToStickGuide(
                controller: controller,
                stickGuide: StickGuide.usedStick,
                testType: testType);
          } else if (next == ViewState.err_eject) {
            //분석진행 중에 스틱이 빠진경우만 30초 체크 함
            if (previous == ViewState.progress) {
              StickOutTimer().stickOutTimeCheckStart();
              AppToWeb().goPage(
                  controller: controller, url: RouteConstants.stickDetached);
            } else {
              AppToWeb().moveToStickGuide(
                  controller: controller,
                  stickGuide: StickGuide.beforeInsert,
                  testType: testType);
            }
          } else if (next == ViewState.urine) {
            AppToWeb().showToastMessage(
                controller: controller, toastType: ToastType.normalStick);
            Future.delayed(const Duration(milliseconds: 500)).then((_) async {
              AppToWeb()
                  .goPage(controller: controller, url: RouteConstants.dripPee);
            });
          } else if (next == ViewState.progress) {
            if (previous == ViewState.err_eject) {
              AppToWeb().showToastMessage(
                  controller: controller, toastType: ToastType.normalStick);
            }
            final reactTime =
                ref.watch(statChkResponse.notifier).state?.data?.reactTime ??
                    BleManager().deviceInfo?.deviceTestSeconds ??
                    300;
            AppToWeb().goPage(
                controller: controller,
                url: '${RouteConstants.startAnalysis}?defaultTime=$reactTime');
          } else if (next == ViewState.type_mismatch) {
            testProgressTypeMismatch(ref: ref);
          } else if (next == ViewState.waiting_result) {
          } else if (next == ViewState.complete) {}
        }
      }),
    );
  }

  progressTimeState() {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    ref.listen(
      progressReactTimeProvider(ref).select((value) => value),
      ((previous, next) {
        if (previous != next) {
          if (next > 0) {
            if (Platform.isAndroid) {
              _showProgressNotification(
                  id: AppConfigs.progressNotificationChannelId,
                  time: next,
                  simulatedStep: AppConfigs.timerDeviceTestSeconds - next,
                  maxStep: AppConfigs.timerDeviceTestSeconds);
            }
          } else {
            if (Platform.isAndroid) {
              AwesomeNotifications()
                  .cancel(AppConfigs.progressNotificationChannelId);
            }
            _showCompleteTestNotification();
          }
          AppToWeb().setProgressTimer(controller: controller, seconds: next);
        }
      }),
    );
  }

  String toMMSS(int time) =>
      '${(time ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}';

  void _showProgressNotification({
    required int id,
    required int time,
    required int simulatedStep,
    required int maxStep,
  }) {
    int progress = min((simulatedStep / maxStep * 100).round(), 100);
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: AppConfigs.progressNotificationChannelKey,
            title: '분석 완료까지 (${toMMSS(time)})',
            body: '',
            category: NotificationCategory.Progress,
            notificationLayout: NotificationLayout.ProgressBar,
            progress: progress,
            autoDismissible: true,
            locked: true));
  }

  void _showCompleteTestNotification() {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: AppConfigs.testCompleteNotificationChannelId,
            channelKey: AppConfigs.testCompleteNotificationChannelKey,
            title: '분석 완료',
            body: '',
            category: NotificationCategory.Message,
            notificationLayout: NotificationLayout.Default,
            autoDismissible: true,
            locked: false));
  }

  testResultState() {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    ref.listen(
      testResultNotifierProvider.select((value) => value),
      ((previous, next) {
        if (next != null && previous != next) {
          AppToWeb().goToResult(controller: controller, resultResponse: next);
        }
      }),
    );
  }

  testResultToDeviceResponse() {
    ref.listen(
      rsltDataResponse.select((value) => value),
      ((previous, next) {
        if (next != null && previous != next) {
          BleManager().disconnectDevice(ref: ref, isGoToFail: false);
        }
      }),
    );
  }

  stickOutedProcess() {
    ref.watch(stickOutTimeFinish.select((states) {
      if (states ?? false) {
        BleManager().disconnectDevice(ref: ref, isGoToFail: false);
        StickOutTimer().stopTimer();
        StickCheckTimer().stopTimer();

        AppToWeb().showStickErrorAlertDialog(
            controller: ref.read(webViewControllerProvider.notifier).state);
      }
    }));
  }

  lotMismatchConfirm({required WidgetRef ref}) {
    final statChkState = ref.read(statChkResponse);
    //진행중인 테스트를 스틱이 꽂혀있는 테스트 타입으로 변경
    BleManager().writeCommandToDevice(
        command: DeviceCommand.STAT_CHK, ref: ref, delayTime: 0);
    BleManager().testStickColor =
        statChkState?.data?.stickColor ?? BleManager().testStickColor;
    final savedLot = ref.read(selectedLastLot.notifier).state;
    ref.read(selectedLotNumber.notifier).state = savedLot?.data?.number;
  }

  testProgressTypeMismatch({required WidgetRef ref}) {
    getLastSelectedLotNumber(ref: ref);

    final controller = ref.read(webViewControllerProvider.notifier).state;
    Future.delayed(const Duration(seconds: 1)).then(
      (value) {
        AppToWeb().lotMisMatch(controller: controller, ref: ref);
      },
    );
  }

  getLastSelectedLotNumber({required WidgetRef ref}) {
    final testType = BleUtils().getTestTypeByStickColor(ref: ref);
    ref.watch(requestLastLotNotifierProvider(testType).select((states) {
      if (states.state == CommonConcreteState.loaded) {
        if (states.response?.code == AppConstants.successCode) {
          ref.read(selectedLastLot.notifier).state = states.response;
        }
      }
    }));
  }
}
