import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/device_check_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/statchk_utils.dart';

final stickStateProvider =
    StateProvider.family<ViewState?, WidgetRef>((ref, widgetRef) {
  final statChkState = ref.watch(statChkResponse);
  final devInfoState = ref.watch(devInfoResponse);

  if (statChkState == null) {
    return null;
  }

  //기기 리셋
  if (!BleManager().isReset &&
      DeviceCheckUtils().isDeviceResetRequired(statChk: statChkState)) {
    BleManager()
        .writeCommandToDevice(command: DeviceCommand.DEV_RST, ref: widgetRef);
    return null;
  }

  bool isDevInfoRequired = DeviceCheckUtils()
      .isDevInfoRequired(statChk: statChkState, devInfo: devInfoState);
  if (isDevInfoRequired) {
    BleManager().writeCommandToDevice(
        command: DeviceCommand.DEV_INFO, ref: widgetRef, delayTime: 500);
    return null;
  }

  print("============== statChkState 111111 = ${statChkState.toJson()}");

  //기기가 에러상태인지 확인
  ViewState? stickState = StatChkUtils().checkStickErrorState(statChkState);
  if (stickState != null) {
    return stickState;
  }

  bool isTypeMismatch = BleUtils().isStickTypeMismatch(statChkState: statChkState);
  //테스트 상태 확인
  ViewState? testState = StatChkUtils().checkTestState(
      statChk: statChkState, ref: widgetRef, isTypeMismatch: isTypeMismatch);
  if (testState != null) {
    //처음 선택한 테스트 타입과 재진입 후 선택한 타입이 일치하지 않는 경우
    if (isTypeMismatch && !BleManager().isReset) {
      return ViewState.type_mismatch;
    }  
    return testState;
  }

  return null;
});

final progressReactTimeProvider =
    StateProvider.family<int, WidgetRef>((ref, widgetRef) {
  final stickState = ref.watch(stickStateProvider(widgetRef));
  final statChkState = ref.watch(statChkResponse);

  if (stickState == ViewState.progress) {
    return statChkState?.data?.reactTime ?? 0;
  }

  return 0;
});
