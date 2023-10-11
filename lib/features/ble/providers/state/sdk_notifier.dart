import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/sdk_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

class SdkNotifier extends StateNotifier<CommonState<InitializeResponse>> {
  final SdkRepository sdkRepository;

  SdkNotifier(
    this.sdkRepository,
  ) : super(const CommonState.initial());

  bool get isFetching => state.state != CommonConcreteState.loading;

  Future<void> sdkInitialize({required HeaderInfo headerInfo, required InitializeRequest initializeRequest}) async {
    if (isFetching) {
      state = state.copyWith(
        state: CommonConcreteState.loading,
        isLoading: true,
      );

      final response = await sdkRepository.sdkInitialize(headerInfo: headerInfo, initializeRequest: initializeRequest);
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
      Either<AppException, InitializeResponse> response) {
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
