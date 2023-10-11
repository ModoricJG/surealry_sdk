import 'package:surearly_smart_sdk/features/ble/data/datasource/log_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/log_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';

class LogRepositoryImpl extends LogRepository {
  final LogDatasource logDatasource;
  LogRepositoryImpl(this.logDatasource);

  @override
  Future<void> saveLog(
      {required LogRequest logRequest}) {
    return logDatasource.saveLog(logRequest: logRequest);
  }
}
