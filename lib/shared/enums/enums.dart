enum DeviceState {
  none,
  select,
  connecting,
  connected,
  disconnected,
  timeout,
  pairingCancel
}

enum DeviceCommand { STAT_CHK, DEV_RST, DEV_INFO, RSLT_DATA, ERROR }

enum StickState { none, norm, err_content, err_used, err_eject, err_ctrl }

enum TestState { none, start, end }

enum ReactChk { none, doing, complete }

enum ViewState {
  none,
  err_content,
  err_used,
  err_eject,
  urine,
  progress,
  waiting_result,
  complete,
  type_mismatch
}

enum StickColor { U, N, R, G, Y, W }

enum OsType { AOS, IOS }
