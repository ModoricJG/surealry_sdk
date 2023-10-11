import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/data/datasource/sdk_remote_datasource.dart';
import 'package:surearly_smart_sdk/features/ble/data/repositories/sdk_repository.dart';
import 'package:surearly_smart_sdk/features/ble/domain/repositories/sdk_repository.dart';
import 'package:surearly_smart_sdk/shared/data/remote/network_service.dart';
import 'package:surearly_smart_sdk/shared/domain/providers/dio_newtork_service_provider.dart';

final sdkDatasourceProvider =
    Provider.family<SdkDatasource, NetworkService>(
  (_, networkService) => SdkRemoteDatasource(networkService),
);

final sdkRepositoryProvider = Provider<SdkRepository>((ref) {
  final networkService = ref.watch(netwokServiceProvider);
  final datasource = ref.watch(sdkDatasourceProvider(networkService));
  final respository = SdkRepositoryImpl(datasource);

  return respository;
});
