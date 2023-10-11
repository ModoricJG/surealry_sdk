import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/sdk_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/sdk_repository.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

class SdkRepositoryImpl extends SdkRepository {
  final SdkDatasource sdkDatasource;
  SdkRepositoryImpl(this.sdkDatasource);

  @override
  Future<Either<AppException, InitializeResponse>> sdkInitialize(
      {required HeaderInfo headerInfo,
      required InitializeRequest initializeRequest}) {
    return sdkDatasource.sdkInitialize(
        headerInfo: headerInfo, initializeRequest: initializeRequest);
  }
}
