import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/shared/domain/models/lot_response.dart';
import 'package:surearly_smart_sdk/shared/domain/models/save_lot_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class LotRepository {
  Future<Either<AppException, LotResponse>> getLots(
      {required String testType, required String sessionAlphaId});
  Future<Either<AppException, SessionLotResponse>> saveLot(
      {required SaveLotRequest lotRequest});
  Future<Either<AppException, SessionLotResponse>> getLastLot(
      {required String sessionAlphaId, required String testType});
}
