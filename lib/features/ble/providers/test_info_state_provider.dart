//선택한 lotnumber
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedLotNumber = StateProvider<String?>(
  (ref) {
    return null;
  },
);

//선택한 테스트 타입
final selectedTestType = StateProvider<String?>(
  (ref) {
    return null;
  },
);

//선택한 테스트 타입
final moveToConnectFail = StateProvider<bool>(
  (ref) {
    return true;
  },
);
