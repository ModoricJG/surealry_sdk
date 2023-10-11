import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/providers/test_result_providers.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/state/test_result_notifier.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_info_state_provider.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/web_device.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';
import 'package:surearly_smart_sdk/shared/utils/common_utils.dart';

final testResultNotifierProvider = StateProvider<TestResultResponse?>(
  (ref) {
    return null;
  },
);

final requestTestResultNotifierProvider = StateNotifierProvider.family<
    TestResultNotifier,
    CommonState<TestResultResponse>,
    List<double>>((ref, result) {
  String sessionId = ref.read(sessionAlphaIdProvider.notifier).state ?? '';
  BluetoothDevice? device = ref.read(deviceNotifierProvider.notifier).state;
  WebDevice webDevice = WebDevice(
      id: device?.remoteId.str,
      name: device?.platformName ?? '',
      state: DeviceStatus.none.name);
  DevInfo? devInfo = ref.read(devInfoResponse.notifier).state;

  final data = TestResultRequest(
      appType: CommonUtils().currentOsType(),
      appVersion: BleManager().appVersion,
      bleName: device?.platformName,
      deviceId: devInfo?.data?.devId,
      firmwareVersion: devInfo?.data?.fwVer,
      lotNumber: ref.read(selectedLotNumber.notifier).state ?? '',
      serializedDeviceObject: jsonEncode(webDevice.toJson()),
      testOneValue: result[0],
      testTwoValue: result[1],
      testThreeValue: result[2],
      sessionAlphaId: sessionId);
  print("data = $data");
  final repository = ref.watch(testResultRepositoryProvider);
  return TestResultNotifier(repository)
    ..createTestResult(testResultRequest: data);
});
