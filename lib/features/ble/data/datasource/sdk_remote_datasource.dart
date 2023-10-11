import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';

abstract class SdkDatasource {
  Future<Either<AppException, InitializeResponse>> sdkInitialize(
      {required HeaderInfo headerInfo,
      required InitializeRequest initializeRequest});
}

class SdkRemoteDatasource implements SdkDatasource {
  final NetworkService networkService;

  SdkRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, InitializeResponse>> sdkInitialize(
      {required HeaderInfo headerInfo,
      required InitializeRequest initializeRequest}) async {
    try {
      networkService.updateHeader(
        {
          'X-Client-Id': headerInfo.xClientId,
          'X-SDK-Secret': headerInfo.xSdkSecret,
          'X-Bundle-Id': headerInfo.xBundleId,
          'Accept-Language': headerInfo.acceptLanguage
        },
      );
      final eitherType = await networkService.post(
        AppConfigs.initUrl,
        data: initializeRequest.toJson()
      );

      return eitherType.fold(
        (exception) {
          return Left(exception);
        },
        (response) {
          InitializeResponse responseModel =
              InitializeResponse.fromJson(response.data);
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
