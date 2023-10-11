import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/lot_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/route_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/web_device.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';

class AppToWeb {
  String convertToEncodedParam({required Map<String, dynamic>? data}) {
    final encodeJson = json.encode(data);
    return Uri.encodeQueryComponent(encodeJson);
  }

  showCommonDialog(
      {required InAppWebViewController? controller,
      required CommonDialogType dialogType}) {
    controller?.evaluateJavascript(
        source: 'commonDialog("${dialogType.name}")');
  }

  moveToTestTypeList(
      {required InAppWebViewController? controller,
      required List<String> typeList}) {
    String types = BleUtils().arrayToJoinedString(testList: typeList);

    controller?.evaluateJavascript(
        source: 'go("${RouteConstants.typeList}?type=$types")');
  }

  moveToPreparation(
      {required InAppWebViewController? controller, required String testType}) {
    controller?.evaluateJavascript(
        source: 'push("${RouteConstants.preparation}?type=$testType")');
  }

  moveToWithLot(
      {required InAppWebViewController? controller,
      required LotResponse? lotResponse,
      required String testType,
      required String route}) {
    final lotJson = lotResponse?.data?.toJson();
    final encodeQuery = convertToEncodedParam(data: lotJson);
    controller?.evaluateJavascript(
        source: 'push("$route?type=$testType&data=$encodeQuery")');
  }

  moveToStickGuide(
      {required InAppWebViewController? controller,
      required StickGuide stickGuide, required String testType}) {
    controller?.evaluateJavascript(
        source:
            'go("${RouteConstants.insertStick}?type=${stickGuide.name}&testType=$testType")');
  }

  moveToConnectFail({required WidgetRef ref, required FailType type}) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    controller?.evaluateJavascript(
        source: 'push(\'${RouteConstants.connectFail}?type=${type.name}\')');
  }

  pushPage({required InAppWebViewController? controller, required String url}) {
    controller?.evaluateJavascript(source: 'push("$url")');
  }

  goPage({required InAppWebViewController? controller, required String url}) {
    controller?.evaluateJavascript(source: 'go("$url")');
  }

  setFindDevice({required WidgetRef ref, required List<WebDevice> list}) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    controller?.evaluateJavascript(
        source: 'setFindDevice(\'${json.encode(list)}\')');
  }

  setRecentDevice({required WidgetRef ref, required List<WebDevice> list}) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    controller?.evaluateJavascript(
        source: 'setRecentDevice(\'${json.encode(list)}\')');
  }

  showToastMessage(
      {required InAppWebViewController? controller,
      required ToastType toastType}) {
    controller?.evaluateJavascript(source: 'showToast("${toastType.name}")');
  }

  setProgressTimer(
      {required InAppWebViewController? controller, required int seconds}) {
    controller?.evaluateJavascript(source: 'setTimer("$seconds")');
  }

  goToResult(
      {required InAppWebViewController? controller,
      required TestResultResponse? resultResponse}) {
    final level = resultResponse?.data?.imageLevel ?? 9;
    final title = Uri.encodeComponent(resultResponse?.data?.summaryTitle ?? '');
    final message = Uri.encodeComponent(resultResponse?.data?.summaryContent ?? '');
    final query = "imageLevel=$level&title=$title&message=$message";

    controller?.evaluateJavascript(
        source: "go('${RouteConstants.analysisResults}?$query')");
  }

  showStickErrorAlertDialog({required InAppWebViewController? controller}) {
    controller?.evaluateJavascript(
        source: "stickErrorAlertDialog()");
  }

  lotMisMatch({required InAppWebViewController? controller, required WidgetRef ref}) {
    final lastLot = ref.read(selectedLastLot.notifier).state;
    controller?.evaluateJavascript(source: "lotErrorAlertDialog('${lastLot?.data?.testType}')");
  }
  
  setNotification({required InAppWebViewController? controller, required bool agree}) {
    controller?.evaluateJavascript(source: 'setNotification("$agree")');
  }

  getNotification({required InAppWebViewController? controller, required bool agree}) {
    controller?.evaluateJavascript(source: 'getNotification("$agree")');
  }
  
  showErrorDialog(
      {required InAppWebViewController? controller, required String code}) {
    controller?.evaluateJavascript(source: 'errorAlertDialog("$code")');
  }
}
