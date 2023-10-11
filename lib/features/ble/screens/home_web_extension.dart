import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/providers/log_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/lot_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_info_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_screen.dart';
import 'package:surearly_smart_sdk/shared/constants/route_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/script/app_to_web.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/log_utils.dart';

extension HomeWebExtension on ConsumerState<HomeScreen> {
  moveToTestListPage({required InAppWebViewController? controller}) {
    final InitializeResponse? response =
        ref.read(initializeNotifierProvider.notifier).state;
    AppToWeb().moveToTestTypeList(
        controller: controller,
        typeList: BleUtils().getTestableTypeList(response: response));
  }

  setSessionInfo({required String sessionId}) {
    ref.read(sessionAlphaIdProvider.notifier).state = sessionId;
  }

  selectLot({required WidgetRef ref, required String lotNumber}) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    ref.read(requestSaveLotNotifierProvider(lotNumber));
    ref.read(selectedLotNumber.notifier).state = lotNumber;
    AppToWeb()
        .pushPage(controller: controller, url: RouteConstants.startConnect);
    LogUtils().saveLogEvent(ref: ref, type: LogType.event, tag: LogTag.SELECT_LOT, content: lotNumber);
  }

  setRecentDeviceList({required WidgetRef ref}){
    final webDevices = BleUtils().getRecentTestDevices(ref: ref);
    AppToWeb().setRecentDevice(ref: ref, list: webDevices);
  }

}
