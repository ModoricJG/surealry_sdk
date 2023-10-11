import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/shared/data/remote/dio_newtork_service.dart';

final netwokServiceProvider = Provider<DioNetworkService>(
  (ref) {
    final Dio dio = Dio();
    return DioNetworkService(dio);
  },
);
