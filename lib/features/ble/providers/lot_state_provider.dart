import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/providers/lot_providers.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/state/lot_notifier.dart';
import 'package:surearly_smart_sdk/features/ble/providers/state/session_lot_notifier.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/save_lot_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

final lotListNotifierProvider = StateProvider<LotResponse?>(
  (ref) {
    return null;
  },
);

final requestLotsNotifierProvider = StateNotifierProvider.family<LotNotifier,
    CommonState<LotResponse>, String>((ref, testType) {
  final repository = ref.watch(lotRepositoryProvider);
  final sessionAlphaId = ref.read(sessionAlphaIdProvider.notifier).state ?? '';
  return LotNotifier(repository)..getLots(testType: testType, sessionAlphaId: sessionAlphaId);
});

final requestSaveLotNotifierProvider =
    StateNotifierProvider.family<
    SessionLotNotifier, CommonState<SessionLotResponse>, String>(
        (ref, lotNumber) {
  final repository = ref.watch(lotRepositoryProvider);
  final sessionAlphaId = ref.read(sessionAlphaIdProvider.notifier).state ?? '';
  final lotRequest = SaveLotRequest(sessionAlphaId: sessionAlphaId, lotNumber: lotNumber);
  return SessionLotNotifier(repository)..saveLot(lotRequest: lotRequest);
});

final requestLastLotNotifierProvider = StateNotifierProvider.family<
    SessionLotNotifier,
    CommonState<SessionLotResponse>, String>((ref, testType) {
  final repository = ref.watch(lotRepositoryProvider);
  final sessionAlphaId = ref.read(sessionAlphaIdProvider.notifier).state ?? '';
  return SessionLotNotifier(repository)..getLastLot(sessionId: sessionAlphaId, testType: testType);
});
