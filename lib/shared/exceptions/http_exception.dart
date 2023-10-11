import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:surearly_smart_sdk/shared/domain/models/response.dart';

class AppException implements Exception {
  final String? message;
  final int? statusCode;
  final String? code;

  AppException({
    required this.message,
    required this.statusCode,
    required this.code,
  });
  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$code';
  }
}

class CacheFailureException extends Equatable implements AppException {
  @override
  String? get code => 'Cache failure exception';

  @override
  String? get message => 'Unable to save user';

  @override
  int? get statusCode => 100;

  @override
  List<Object?> get props => [message, statusCode, code];
}

//  extension

extension HttpExceptionExtension on AppException {
  Left<AppException, Response> get toLeft => Left<AppException, Response>(this);
}
