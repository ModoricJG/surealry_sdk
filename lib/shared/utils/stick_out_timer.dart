import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/device_constants.dart';

class StickOutTimer {
  static final StickOutTimer instance = StickOutTimer._internal();
  factory StickOutTimer() => instance;
  StickOutTimer._internal();
  late Timer? _timer;

  WidgetRef? ref;

  initTimer({required WidgetRef widgetRef}) {
    ref = widgetRef;
    _timer = Timer(Duration.zero, () {});
  }

  stickOutTimeCheckStart() {
    _timer = Timer.periodic(const Duration(seconds: DeviceConstants.stickOutTime), (timer) {
      ref?.read(stickOutTimeFinish.notifier).state = true;
    });
  }

  stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
