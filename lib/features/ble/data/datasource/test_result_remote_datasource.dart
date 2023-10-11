import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/test_result_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class TestResultDatasource {
  Future<Either<AppException, TestResultResponse>> createTestResult(
      {required TestResultRequest testResultRequest});
}

class TestResultRemoteDatasource implements TestResultDatasource {
  final NetworkService networkService;

  TestResultRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, TestResultResponse>> createTestResult(
      {required TestResultRequest testResultRequest}) async {
    try {
      final eitherType = await networkService.post(AppConfigs.testResultUrl,
          data: testResultRequest.toJson());

      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          TestResultResponse responseModel =
              TestResultResponse.fromJson(response.data);
          return Right(responseModel);
        },
      );
    } catch (e) {
      return Left(
        AppException(
          message: 'Unknown error occured',
          statusCode: 1,
          code: '$e.toString()',
        ),
      );
    }
  }
}
