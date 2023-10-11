import 'package:equatable/equatable.dart';

enum CommonConcreteState {
  initial,
  loading,
  loaded,
  failure,
}

class CommonState<T> extends Equatable {
  final T? response;
  final CommonConcreteState state;
  final String code;
  final bool isLoading;
  const CommonState({
    this.response,
    this.isLoading = false,
    this.state = CommonConcreteState.initial,
    this.code = '',
  });

  const CommonState.initial({
    this.response,
    this.isLoading = false,
    this.state = CommonConcreteState.initial,
    this.code = '',
  });

  CommonState<T> copyWith({
    T? response,
    CommonConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return CommonState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      state: state ?? this.state,
      code: message ?? this.code,
    );
  }

  @override
  String toString() {
    return 'CommonConcreteState(isLoading:$isLoading, event: $response, state: $state, message: $code)';
  }

  @override
  List<Object?> get props => [response, state, code];
}
