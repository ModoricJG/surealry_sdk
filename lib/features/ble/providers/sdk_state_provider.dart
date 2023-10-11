import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/domain/providers/sdk_providers.dart';
import 'package:surearly_smart_sdk/features/ble/providers/state/sdk_notifier.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_response.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';
import 'package:tuple/tuple.dart';

final initializeNotifierProvider = StateProvider<InitializeResponse?>(
  (ref) {
    return null;
  },
);

final sessionAlphaIdProvider = StateProvider<String?>(
  (ref) {
    return null;
  },
);

final webViewControllerProvider = StateProvider<InAppWebViewController?>(
  (ref) {
    return null;
  },
);

final requestSdkInitNotifierProvider = StateNotifierProvider.family<
    SdkNotifier, CommonState<InitializeResponse>, Tuple2<HeaderInfo, InitializeRequest>>((ref, info) {
  final repository = ref.watch(sdkRepositoryProvider);
  return SdkNotifier(repository)..sdkInitialize(headerInfo: info.item1, initializeRequest: info.item2);
});
