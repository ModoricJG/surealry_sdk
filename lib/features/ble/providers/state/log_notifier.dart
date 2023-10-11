import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/log_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';

class LogNotifier extends StateNotifier<CommonState<void>> {
  final LogRepository logRepository;

  LogNotifier(
    this.logRepository,
  ) : super(const CommonState.initial());

  bool get isFetching => state.state != CommonConcreteState.loading;

  Future<void> saveLog({required LogRequest logRequest}) async {
    await logRepository.saveLog(logRequest: logRequest);
  }

}
