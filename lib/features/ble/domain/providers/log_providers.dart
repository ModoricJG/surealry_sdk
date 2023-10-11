import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/log_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/lot_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/repositories/log_repository.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/log_repository.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/providers/dio_newtork_service_provider.dart';

final logDatasourceProvider = Provider.family<LogDatasource, NetworkService>(
  (_, networkService) => LogRemoteDatasource(networkService),
);

final logRepositoryProvider = Provider<LogRepository>((ref) {
  final networkService = ref.watch(netwokServiceProvider);
  final datasource = ref.watch(logDatasourceProvider(networkService));
  final respository = LogRepositoryImpl(datasource);

  return respository;
});
