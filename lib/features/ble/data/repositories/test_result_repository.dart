import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/test_result_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/test_result_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

class TestResultRepositoryImpl extends TestResultRepository {
  final TestResultDatasource testResultDatasource;
  TestResultRepositoryImpl(this.testResultDatasource);

  @override
  Future<Either<AppException, TestResultResponse>> createTestResult(
      {required TestResultRequest testResultRequest}) {
    return testResultDatasource.createTestResult(
        testResultRequest: testResultRequest);
  }
}
