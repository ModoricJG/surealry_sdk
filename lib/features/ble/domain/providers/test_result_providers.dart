import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/sdk_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/test_result_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/repositories/test_result_repository.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/test_result_repository.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/providers/dio_newtork_service_provider.dart';

final testResultDatasourceProvider = Provider.family<TestResultDatasource, NetworkService>(
  (_, networkService) => TestResultRemoteDatasource(networkService),
);

final testResultRepositoryProvider = Provider<TestResultRepository>((ref) {
  final networkService = ref.watch(netwokServiceProvider);
  final datasource = ref.watch(testResultDatasourceProvider(networkService));
  final respository = TestResultRepositoryImpl(datasource);

  return respository;
});
