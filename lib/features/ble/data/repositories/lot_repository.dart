import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/lot_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/lot_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/save_lot_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

class LotRepositoryImpl extends LotRepository {
  final LotDatasource lotDatasource;
  LotRepositoryImpl(this.lotDatasource);

  @override
  Future<Either<AppException, LotResponse>> getLots(
      {required String testType, required String sessionAlphaId}) {
    return lotDatasource.getLots(testType: testType, sessionAlphaId: sessionAlphaId);
  }

  @override
  Future<Either<AppException, SessionLotResponse>> saveLot(
      {required SaveLotRequest lotRequest}) {
    return lotDatasource.saveLot(lotRequest: lotRequest);
  }

  @override
  Future<Either<AppException, SessionLotResponse>> getLastLot(
      {required String sessionAlphaId, required String testType}) {
    return lotDatasource.getLastLot(sessionAlphaId: sessionAlphaId, testType: testType);
  }

}
