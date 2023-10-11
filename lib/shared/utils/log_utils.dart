
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/providers/log_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/device_constants.dart';
import 'package:surearly_smart_sdk/shared/constants/web_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/stat_chk.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';

class LogUtils {
  bool isRequiredSaveLog({LogRequest? lastLog, required String cmd, StatChk? statChk}) {
    if (cmd != DeviceCommand.STAT_CHK.name) {
      return true;
    }

    final checkCmd = "${DeviceConstants.logPrefix}$cmd";
    if ((lastLog?.tag ?? '') != checkCmd) {
      return true;
    }

    final previousLog = (lastLog?.content ?? '').split(DeviceConstants.logDivider);
    if (previousLog.length >= 2 && statChk != null) {

      Map<String, dynamic> receiveMap = json.decode(previousLog[1]);
      StatChk lastStatChk = StatChk.fromJson(receiveMap);
      return isStatChkChanged(before: lastStatChk, after: statChk);
    }

    return true;
  }

  bool isStatChkChanged({required StatChk before, required StatChk after}) {
    return ((before.data?.procStep != after.data?.procStep) 
      || (before.data?.stickColor != after.data?.stickColor)
      || (before.data?.testState != after.data?.testState)
      || (before.data?.stickState != after.data?.stickState) 
      || (before.data?.reactChk != after.data?.reactChk));
  }

  LogRequest convertDeviceErrorLogFormat({required String responseStr}) {
    return LogRequest(
        content: responseStr,
        tag: '${DeviceConstants.logPrefix}ERROR',
        isSuccess: false);
  }

  LogRequest convertDeviceSuccessLogFormat({required String requestStr, required String responseStr, required String cmdName}) {    
    return LogRequest(
      content: makeDeviceContentLog(requestStr: requestStr, responseStr: responseStr),
      tag: '${DeviceConstants.logPrefix}$cmdName',
      isSuccess: true
    );  
  }

  LogRequest webEventFormat(
      {required LogType type,
      required LogTag tagType,
      String? content}) {
    final tagPrefix = (type == LogType.event) ? WebConstants.logEventPrefix : WebConstants.logViewPrefix;
    final tag = '$tagPrefix${tagType.name}';
    return LogRequest(
        content: content ?? tag,
        tag: tag,
        isSuccess: true);
  }

  String makeDeviceContentLog({required String requestStr, required String responseStr}) {
    return '$requestStr${DeviceConstants.logDivider}$responseStr';
  }

  saveLogEvent(
      {required WidgetRef ref,
      required LogType type,
      required LogTag tag,
      String? content}) {
    final logData =
        LogUtils().webEventFormat(type: type, tagType: tag, content: content);
    ref.read(saveLogNotifierProvider(logData));
  }
}