import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/dev_rst.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/rslt_data.dart';
import 'package:surearly_smart_sdk/shared/domain/models/ble/stat_chk.dart';
import 'package:surearly_smart_sdk/shared/domain/models/log_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/session_lot_response.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';

final permissionChecked = StateProvider<bool?>(
  (ref) {
    return null;
  },
);

final firstConnected = StateProvider<bool>(
  (ref) {
    return true;
  },
);

//연결한 기기
final deviceNotifierProvider = StateProvider<BluetoothDevice?>(
  (ref) {
    return null;
  },
);

//검색된 기기
final discoverdDevice = StateProvider<BluetoothDevice?>(
  (ref) {
    return;
  },
);

//검색된 기기의 리스트
final discoverdDeviceList = StateProvider<List<BluetoothDevice>>(
  (ref) {
    return [];
  },
);

//검색된 사용내역이 있는 기기의 리스트
final discoverdRecentDeviceList = StateProvider<List<BluetoothDevice>>(
  (ref) {
    return [];
  },
);

//기기의 상태
final deviceConnectStateProvider = StateProvider<DeviceState>(
  (ref) {
    return DeviceState.none;
  },
);

//기기의 응답
final statChkResponse = StateProvider<StatChk?>(
  (ref) {
    return null;
  },
);

//기기의 응답
final devInfoResponse = StateProvider<DevInfo?>(
  (ref) {
    return null;
  },
);

//기기의 응답
final rsltDataResponse = StateProvider<RsltData?>(
  (ref) {
    return null;
  },
);

//기기의 응답
final devRstResponse = StateProvider<DevRst?>(
  (ref) {
    return null;
  },
);

//기기의 stick out timer 끝남
final stickOutTimeFinish = StateProvider<bool?>(
  (ref) {
    return null;
  },
);

//저장한 로그 데이터
final savedLogRequest = StateProvider<LogRequest?>(
  (ref) {
    return null;
  },
);

//사용자가 선택했던 마지막 lot
final selectedLastLot = StateProvider<SessionLotResponse?>(
  (ref) {
    return null;
  },
);

