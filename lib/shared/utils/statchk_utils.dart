import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/stat_chk.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';
import 'package:surearly_smart_sdk/shared/utils/device_check_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_check_timer.dart';

class StatChkUtils {
  //스틱의 에러상테 확인
  ViewState? checkStickErrorState(StatChk? statChk) {
    ViewState? viewState;

    if (statChk?.data?.stickState == StickState.err_eject.name) {
      viewState = ViewState.err_eject;
    } else if (statChk?.data?.stickState == StickState.err_content.name &&
        DeviceCheckUtils()
            .isUserErrorContent(color: statChk?.data?.stickColor ?? '')) {
      viewState = ViewState.err_content;
    } else if (statChk?.data?.stickState == StickState.err_used.name) {
      viewState = ViewState.err_used;
    }

    if (viewState != null) {
      BleManager().isRepeat = true;
    }
    return viewState;
  }

//기기의 테스트 상태 확인
  ViewState? checkTestState({required StatChk statChk, required WidgetRef ref, required bool isTypeMismatch}) {
    ViewState? viewState = ViewState.none;
    int step = statChk.data?.procStep ?? 0;

    if (step == 6 && statChk.data?.stickState == StickState.none.name) {
      //기기를 켜는 동시에 스틱을 삽입한 경우, 스틱제거 안내화면으로 이동해야 함
      viewState = ViewState.err_used;
    } else if (statChk.data?.procStep == 7 &&
        statChk.data?.stickState == StickState.norm.name) {
      viewState = ViewState.urine;
    } else if ((step == 8 || step == 9) &&
        statChk.data?.stickState == StickState.norm.name) {
      viewState = ViewState.progress;
    } else if (step == 10 && statChk.data?.reactChk == ReactChk.complete.name) {
      if (statChk.data?.testState != TestState.end.name) {
        StickCheckTimer().stopTimer();
        viewState = ViewState.waiting_result;
      } else {
        if(BleManager().isReset) {
          viewState = ViewState.err_used;
        } else {
          viewState = ViewState.complete;
        }
      }
    }

    if (viewState != ViewState.waiting_result && !isTypeMismatch) {
      if (!BleManager().isRepeat) {
        BleManager().writeCommandToDevice(command: DeviceCommand.STAT_CHK, ref: ref);
      }
      BleManager().isRepeat = true;
    } 
    return viewState;
  }
}
