import 'dart:convert';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/log_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_result_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/app_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_rst.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/rslt_data.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/stat_chk.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/web_device.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/script/app_to_web.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';
import 'package:surearly_smart_sdk/shared/utils/device_check_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/log_utils.dart';

class BleUtils {
  bool isSurearlyDeivce({required String deviceName}) {
    List<String> prefixList = BleManager().deviceInfo?.deviceNamePrefix ??
        [AppConstants.prefixDefaultName];
    return prefixList
            .firstWhereOrNull((element) => deviceName.startsWith(element)) !=
        null;
  }

  bool isDuplicateDevice(
      {required BluetoothDevice device, required List<BluetoothDevice> list}) {
    return (list.firstWhereOrNull(
            (element) => element.platformName == device.platformName) !=
        null);
  }

  bool isRecentDevice(
      {required BluetoothDevice device, required List<WebDevice> list}) {
    return (list.firstWhereOrNull(
            (element) => element.name == device.platformName) !=
        null);
  }

  bool isValidCommandResponse({required String resultText}) {
    return (resultText != "" &&
        resultText.length >= 18 &&
        resultText[0] == "|" &&
        resultText[resultText.length - 1] == "#");
  }

  void getJsonStringFromReceiveData(
      {required String receiveString, required WidgetRef ref}) {
    int startIndex = receiveString.indexOf('{');
    int endIndex = receiveString.lastIndexOf('}') + 1;
    StatChk? statChk;
    String cmd = '';
    LogRequest? logData;

    if (startIndex != -1 && endIndex != -1) {
      String jsonData = receiveString.substring(startIndex, endIndex);
      Map<String, dynamic> receiveMap = json.decode(jsonData);
      cmd = receiveMap['cmd'] as String;

      print(receiveString);
      print("===== ${BleManager().lastCmd}");

      if (cmd != DeviceCommand.ERROR.name) {
        BleManager().errorCount = 0;
      }

      if (cmd == DeviceCommand.STAT_CHK.name) {
        statChk = StatChk.fromJson(receiveMap);
        ref.read(statChkResponse.notifier).state = statChk;
        getTestResult(statChk: statChk, ref: ref);
      } else if (cmd == DeviceCommand.DEV_INFO.name) {
        ref.read(devInfoResponse.notifier).state = DevInfo.fromJson(receiveMap);
      } else if (cmd == DeviceCommand.RSLT_DATA.name) {
        ref.read(rsltDataResponse.notifier).state =
            RsltData.fromJson(receiveMap);
      } else if (cmd == DeviceCommand.DEV_RST.name) {
        devResetProcess(ref: ref, receiveMap: receiveMap);
      } else if (cmd == DeviceCommand.ERROR.name) {
        BleManager().writeCommandError(ref: ref);
      }

      BleManager().responsePiece = '';
      bool isRequiredSave = LogUtils().isRequiredSaveLog(
          lastLog: ref.read(savedLogRequest.notifier).state,
          cmd: cmd,
          statChk: statChk);
      if (isRequiredSave) {
        logData = LogUtils().convertDeviceSuccessLogFormat(
            requestStr: BleManager().lastCmd,
            responseStr: jsonData,
            cmdName: cmd);
      }
    } else {
      logData =
          LogUtils().convertDeviceErrorLogFormat(responseStr: receiveString);
    }

    if (BleManager().isRepeat && cmd != DeviceCommand.ERROR.name) {
      BleManager()
          .writeCommandToDevice(command: DeviceCommand.STAT_CHK, ref: ref);
    }

    if (logData != null) {
      ref.read(savedLogRequest.notifier).state = logData;
      ref.read(saveLogNotifierProvider(logData));
    }
  }

  devResetProcess(
      {required WidgetRef ref, required Map<String, dynamic> receiveMap}) {
    BleManager().isReset = true;
    ref.read(devRstResponse.notifier).state = DevRst.fromJson(receiveMap);
    ref.read(devInfoResponse.notifier).state = null;
    BleManager().writeCommandToDevice(
        command: DeviceCommand.STAT_CHK, ref: ref, delayTime: 1);
  }

  bool isStickCorrect({required String color}) {
    //스틱이 꽂혀있지 않거나, 스틱이 꽂혀있다면 꽂힌색상과 선택한테스트타입이 동일해야 함
    if (color == "N" || color == BleManager().testStickColor) {
      return true;
    }
    return false;
  }

  String arrayToJoinedString({required List<String> testList}) {
    return testList.join(",");
  }

  List<WebDevice> bluetoothListToWebDevice(
      {required List<BluetoothDevice> deviceList,
      String? remoteId,
      DeviceStatus? status}) {
    DeviceStatus deviceStatus = DeviceStatus.none;

    return deviceList.map((element) {
      if (element.remoteId.str == remoteId) {
        deviceStatus = status ?? DeviceStatus.none;
      } else {
        deviceStatus = DeviceStatus.none;
      }
      return BleUtils()
          .convertToWebDeviceModel(device: element, status: deviceStatus);
    }).toList();
  }

  List<WebDevice> recentListToWebDevice(
      {required List<WebDevice> deviceList,
      String? remoteId,
      DeviceStatus? status}) {
    DeviceStatus deviceStatus = DeviceStatus.none;

    return deviceList.map((element) {
      if (element.id == remoteId) {
        deviceStatus = status ?? DeviceStatus.none;
      } else {
        deviceStatus = DeviceStatus.none;
      }
      return element.copyWith(state: deviceStatus.name);
    }).toList();
  }

  WebDevice convertToWebDeviceModel(
      {required BluetoothDevice device, required DeviceStatus status}) {
    return WebDevice(
        id: device.remoteId.str, name: device.localName, state: status.name);
  }

  BluetoothDevice? findDeviceByIdAndName(
      {required List<BluetoothDevice> deviceList, required WebDevice device}) {
    return deviceList.firstWhereOrNull((element) =>
        (element.remoteId.str == device.id) &&
        (element.platformName == device.name));
  }

  WebDevice? findWebDeviceByIdAndName(
      {required List<WebDevice> deviceList, required WebDevice webDevice}) {
    return deviceList.firstWhereOrNull((element) =>
        (element.id == webDevice.id) && (element.name == webDevice.name));
  }

  getTestResult({required StatChk? statChk, required WidgetRef ref}) async {
    final devInfoState = ref.read(devInfoResponse);
    if (statChk == null) {
      return;
    }

    if (statChk.data?.procStep == 10 &&
        statChk.data?.reactChk == ReactChk.complete.name &&
        statChk.data?.testState != TestState.end.name &&
        !BleUtils().isStickTypeMismatch(statChkState: statChk)) {
      ////재접속을 했는데 결과를 생성하지 않은 경우
      if (devInfoState?.data?.fwVer == null) {
        BleManager()
            .writeCommandToDevice(command: DeviceCommand.STAT_CHK, ref: ref);
        return;
      }

      BleManager().isRepeat = false;
      ref.watch(requestTestResultNotifierProvider(
              statChk.data?.rsltRawdata ?? [0.0, 0.0, 0.0])
          .select((states) {
        if (states.state == CommonConcreteState.loaded) {
          if (states.response?.code == AppConstants.successCode) {
            final level = states.response?.data?.imageLevel ?? 9;
            BleManager().writeCommandToDevice(
                command: DeviceCommand.RSLT_DATA, ref: ref, level: level);

            ref.read(testResultNotifierProvider.notifier).state =
                states.response;
            LogUtils().saveLogEvent(
                ref: ref,
                type: LogType.view,
                tag: LogTag.END_ANALYSIS,
                content: '$level');
          }
        } else if (states.state == CommonConcreteState.failure) {
          AppToWeb().showErrorDialog(
              controller: ref.read(webViewControllerProvider.notifier).state,
              code: "S-${states.code}");
        }
      }));
    }
  }

  List<String> getTestableTypeList({required InitializeResponse? response}) {
    return response?.data?.testableTypes
            ?.map((e) => e.testType.toString())
            .toList() ??
        [];
  }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

  String getStickColorByTestType(
      {required InitializeResponse? response, required String testType}) {
    List<TestableTypes> testableTypes = response?.data?.testableTypes ?? [];
    TestableTypes? types = testableTypes
        .firstWhereOrNull((element) => element.testType == testType);
    return types?.colorCode ?? '';
  }

  String getTestTypeByStickColor({required WidgetRef ref}) {
    final InitializeResponse? response =
        ref.read(initializeNotifierProvider.notifier).state;
    final statChkState = ref.read(statChkResponse);
    final colorCode = statChkState?.data?.stickColor ?? '';

    List<TestableTypes> testableTypes = response?.data?.testableTypes ?? [];
    TestableTypes? types = testableTypes
        .firstWhereOrNull((element) => element.colorCode == colorCode);
    return types?.testType ?? '';
  }

  List<WebDevice> getRecentTestDevices({required WidgetRef ref}) {
    final InitializeResponse? response =
        ref.read(initializeNotifierProvider.notifier).state;

    final deviceList = response?.data?.device?.recentTestDevice ?? [];
    return deviceList.map((e) => WebDevice.fromJson(jsonDecode(e))).toList();
  }

  BluetoothDevice? searchSelectedDevice(
      {required WidgetRef ref, required WebDevice webDevice}) {
    List<BluetoothDevice> deviceList =
        ref.read(discoverdDeviceList.notifier).state;
    List<BluetoothDevice> recentDeviceList =
        ref.read(discoverdRecentDeviceList.notifier).state;
    return findDeviceByIdAndName(
        deviceList: deviceList + recentDeviceList, device: webDevice);
  }

  bool isStickTypeMismatch({required StatChk? statChkState}) {
    final stickColor = statChkState?.data?.stickColor ?? '';
    final testState = statChkState?.data?.testState;
    return DeviceCheckUtils().isUserErrorContent(color: stickColor) &&
        stickColor != BleManager().testStickColor &&
        testState != TestState.end.name;
  }
}
