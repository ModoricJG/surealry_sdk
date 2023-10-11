import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/lot_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/repositories/lot_repository.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/lot_repository.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/providers/dio_newtork_service_provider.dart';

final lotDatasourceProvider =
    Provider.family<LotDatasource, NetworkService>(
  (_, networkService) => LotRemoteDatasource(networkService),
);

final lotRepositoryProvider = Provider<LotRepository>((ref) {
  final networkService = ref.watch(netwokServiceProvider);
  final datasource = ref.watch(lotDatasourceProvider(networkService));
  final respository = LotRepositoryImpl(datasource);

  return respository;
});
