import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class LogRepository {
  Future<void> saveLog({required LogRequest logRequest});
}
