import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/stat_chk.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/utils/ble_utils.dart';

class DeviceCheckUtils {
  bool isDevInfoRequired(
      {required StatChk? statChk, required DevInfo? devInfo}) {
    int step = statChk?.data?.procStep ?? 0;

    if (((devInfo?.data?.fwVer == null) &&
            (statChk?.data?.stickState == StickState.none.name) &&
            (step <= 5 || step == 7) &&
            BleUtils()
                .isStickCorrect(color: statChk?.data?.stickColor ?? "")) ||
        (devInfo?.data?.fwVer == null && step == 10 && statChk?.data?.testState != TestState.end.name) ||
        (devInfo?.data?.fwVer == null && step < 10)) {
        // ||
        // (devInfo?.data?.fwVer == null && BleManager().isReset)) {
      return true;
    }

    return false;
  }

  bool isDeviceResetRequired({required StatChk? statChk}) {
    int step = statChk?.data?.procStep ?? 0;
    if (step == 10 && statChk?.data?.testState == TestState.end.name) {
      return true;
    } else if (step == 7 &&
        ((statChk?.data?.stickState != StickState.norm.name) ||
            (statChk?.data?.stickColor == StickColor.U.name ||
                statChk?.data?.stickColor == StickColor.N.name))) {
      return true;
    }
    return false;
  }

  bool isUserErrorContent({required String color}) {
    return (color != StickColor.U.name && color != StickColor.N.name);
  }
}
