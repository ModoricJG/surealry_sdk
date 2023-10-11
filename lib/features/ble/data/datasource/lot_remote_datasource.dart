import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/save_lot_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class LotDatasource {
  Future<Either<AppException, LotResponse>> getLots(
      {required String testType, required String sessionAlphaId});
  Future<Either<AppException, SessionLotResponse>> saveLot(
      {required SaveLotRequest lotRequest});
  Future<Either<AppException, SessionLotResponse>> getLastLot(
      {required String sessionAlphaId, required String testType});
}

class LotRemoteDatasource implements LotDatasource {
  final NetworkService networkService;

  LotRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, LotResponse>> getLots({required String testType, required String sessionAlphaId}) async {
    try {     
      final eitherType = await networkService.get(
        '${AppConfigs.lotUrl}?testType=$testType&sessionAlphaId=$sessionAlphaId',
      );

      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          LotResponse responseModel =
              LotResponse.fromJson(response.data);
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

  @override
  Future<Either<AppException, SessionLotResponse>> saveLot(
      {required SaveLotRequest lotRequest}) async {
    try {
      final eitherType = await networkService.post(
        '${AppConfigs.lastLotUrl}',
        data: lotRequest.toJson()
      );

      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          SessionLotResponse responseModel = SessionLotResponse.fromJson(response.data);
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

  @override
  Future<Either<AppException, SessionLotResponse>> getLastLot(
      {required String sessionAlphaId, required String testType}) async {
    try {
      final eitherType = await networkService.get(
        '${AppConfigs.lastLotUrl}?sessionAlphaId=$sessionAlphaId&testType=$testType',
      );

      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          SessionLotResponse responseModel = SessionLotResponse.fromJson(response.data);
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
