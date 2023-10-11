import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class TestResultRepository {
  Future<Either<AppException, TestResultResponse>> createTestResult(
      {required TestResultRequest testResultRequest});
}
