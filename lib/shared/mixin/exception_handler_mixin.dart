import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:surearly_smart_sdk/shared/exceptions/http_exception.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/models/response.dart' as response;

mixin ExceptionHandlerMixin on NetworkService {
  Future<Either<AppException, response.Response>>
      handleException<T extends Object>(
          Future<Response<dynamic>> Function() handler,
          {String endpoint = ''}) async {
    try {
      final res = await handler();
      return Right(
        response.Response(
          statusCode: res.statusCode ?? 200,
          data: res.data,
          statusMessage: res.statusMessage,
        ),
      );
    } catch (e) {
      String message = '';
      String code = '';
      int statusCode = 0;
      log(e.runtimeType.toString());
      switch (e.runtimeType) {
        case SocketException:
          e as SocketException;
          message = 'Unable to connect to the server.';
          statusCode = 0;
          code = 'Socket Exception ${e.message}\n at  $endpoint';
          break;

        case DioException:
          e as DioException;
          message = e.response?.data?['message'] ?? 'Internal Error occured';
          statusCode = 1;
          code = e.response?.data?['code'] ?? '9999';
          break;

        default:
          message = 'Unknown error occured';
          statusCode = 2;
          code = 'Unknown error ${e.toString()}\n at $endpoint';
      }
      return Left(
        AppException(
          message: message,
          statusCode: statusCode,
          code: code,
        ),
      );
    }
  }
}
