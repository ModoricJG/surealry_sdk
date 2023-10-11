import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/providers/log_providers.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/state/log_notifier.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

final saveLogNotifierProvider =
    StateNotifierProvider.family<LogNotifier, CommonState<void>, LogRequest>(
        (ref, logRequest) {
  final sessionId = ref.read(sessionAlphaIdProvider.notifier).state ?? '';
  final logRequestData = logRequest.copyWith(sessionAlphaId: sessionId);
  final repository = ref.watch(logRepositoryProvider);
  return LogNotifier(repository)..saveLog(logRequest: logRequestData);
});
