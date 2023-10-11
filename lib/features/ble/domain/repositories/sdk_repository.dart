import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class SdkRepository {
  Future<Either<AppException, InitializeResponse>> sdkInitialize(
      {required HeaderInfo headerInfo, required InitializeRequest initializeRequest});
}
