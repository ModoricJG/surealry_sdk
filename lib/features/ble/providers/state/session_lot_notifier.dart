import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/lot_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/save_lot_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

class SessionLotNotifier extends StateNotifier<CommonState<SessionLotResponse>> {
  final LotRepository lotRepository;

  SessionLotNotifier(
    this.lotRepository,
  ) : super(const CommonState.initial());

  bool get isFetching => state.state != CommonConcreteState.loading;

  Future<void> saveLot({required SaveLotRequest lotRequest}) async {
    if (isFetching) {
      state = state.copyWith(
        state: CommonConcreteState.loading,
        isLoading: true,
      );

      final response = await lotRepository.saveLot(lotRequest: lotRequest);
      updateEventStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: CommonConcreteState.loaded,
        message: 'finish loading',
        isLoading: false,
      );
    }
  }

  Future<void> getLastLot({required String sessionId, required String testType}) async {
    if (isFetching) {
      state = state.copyWith(
        state: CommonConcreteState.loading,
        isLoading: true,
      );

      final response = await lotRepository.getLastLot(sessionAlphaId: sessionId, testType: testType);
      updateEventStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: CommonConcreteState.loaded,
        message: 'finish loading',
        isLoading: false,
      );
    }
  }

  void updateEventStateFromResponse(
      Either<AppException, SessionLotResponse> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: CommonConcreteState.failure,
        message: failure.code,
        isLoading: false,
      );
    }, (data) {
      state = state.copyWith(
        response: data,
        state: CommonConcreteState.loaded,
        isLoading: false,
      );
    });
  }

  void resetState() {
    state = const CommonState.initial();
  }
}
