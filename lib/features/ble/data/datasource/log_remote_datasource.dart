import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';

abstract class LogDatasource {
  Future<void> saveLog({required LogRequest logRequest});
}

class LogRemoteDatasource implements LogDatasource {
  final NetworkService networkService;

  LogRemoteDatasource(this.networkService);

  @override
  Future<void> saveLog({required LogRequest logRequest}) async {
    try {
      await networkService.post(
        AppConfigs.logUrl,
        data: logRequest.toJson()
      );
    } catch (e) {
    }
  }
}
