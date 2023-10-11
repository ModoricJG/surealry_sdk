import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/test_result_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

class TestResultNotifier extends StateNotifier<CommonState<TestResultResponse>> {
  final TestResultRepository testResultRepository;

  TestResultNotifier(
    this.testResultRepository,
  ) : super(const CommonState.initial());

  bool get isFetching => state.state != CommonConcreteState.loading;

  Future<void> createTestResult(
      {required TestResultRequest testResultRequest}) async {
    if (isFetching) {
      state = state.copyWith(
        state: CommonConcreteState.loading,
        isLoading: true,
      );

      final response = await testResultRepository.createTestResult(testResultRequest: testResultRequest);
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
      Either<AppException, TestResultResponse> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: CommonConcreteState.failure,
        message: failure.code,
        isLoading: false,
      );
    }, (data) {
      print("data ======= $data");
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
