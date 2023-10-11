import 'package:equatable/equatable.dart';

enum CommonBleConcreteState {
  initial,
  request,
  complete,
  failure,
}

class CommonBleState<T> extends Equatable {
  final T? response;
  final CommonBleConcreteState state;
  final String code;
  const CommonBleState({
    this.response,
    this.state = CommonBleConcreteState.initial,
    this.code = '',
  });

  const CommonBleState.initial({
    this.response,
    this.state = CommonBleConcreteState.request,
    this.code = '',
  });

  CommonBleState<T> copyWith({
    T? response,
    CommonBleConcreteState? state,
    String? message,
  }) {
    return CommonBleState(
      response: response ?? this.response,
      state: state ?? this.state,
      code: message ?? this.code,
    );
  }

  @override
  String toString() {
    return 'CommonConcreteState(event: $response, state: $state, message: $code)';
  }

  @override
  List<Object?> get props => [response, state, code];
}
