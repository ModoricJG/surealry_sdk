import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/shared/constants/device_constants.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';

class StickCheckTimer {
  static final StickCheckTimer instance = StickCheckTimer._internal();
  factory StickCheckTimer() => instance;
  StickCheckTimer._internal();
  late Timer? _timer;

  DeviceCommand? cmd;
  WidgetRef? ref;

  initTimer({required WidgetRef widgetRef}) {
    ref = widgetRef;
    _timer = Timer(Duration.zero, () {});
  }

  startCheckResponse() {
    stopTimer();
    _timer = Timer.periodic(
        const Duration(seconds: DeviceConstants.errorCheckTime), (timer) {
      BleManager().writeCommandError(ref: ref);
    });
  }

  stopTimer() {
    if (_timer != null) {
      print("stop!");
      _timer?.cancel();
      _timer = null;
    }
  }
}
