import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/lot_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

class LotNotifier extends StateNotifier<CommonState<LotResponse>> {
  final LotRepository lotRepository;

  LotNotifier(
    this.lotRepository,
  ) : super(const CommonState.initial());

  bool get isFetching => state.state != CommonConcreteState.loading;

  Future<void> getLots({required String testType, required String sessionAlphaId}) async {
    if (isFetching) {
      state = state.copyWith(
        state: CommonConcreteState.loading,
        isLoading: true,
      );

      final response = await lotRepository.getLots(testType: testType, sessionAlphaId: sessionAlphaId);
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
      Either<AppException, LotResponse> response) {
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
