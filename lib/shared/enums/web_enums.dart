enum ConnectFail { deviceNotFound, fairing }

enum InsertStick { beforeInsert, usedStick, otherStick }

enum CommonDialogType { permissionBluetooth, permissionLocation, finish }

enum PermissionType { bluetooth, camera }

enum HandlerType {
  permission,
  permissionSetting,
  finish,
  selectType,
  startTest,
  selectLot,
  startSearch,
  selectDevice,
  lotTypeDifferent,
  notificationSet,
  notificationGet,
  sendLog,
}

enum DeviceStatus {
  none,
  connecting,
  connected,
  connectFail,
}

enum ToastType {
  normalStick,
  connectedStick,
  connectedDevice,
  connectFailDevice,
}

enum StickGuide {
  beforeInsert,
  usedStick,
  otherStick,
}

enum FailType { deviceNotFound, fairing, deviceDisconnected }
  
enum SendLogType { cancel, finish, lotDirect }

enum LogType { event, view }

enum LogTag {
  SELECT_TYPE,
  MOVE_LOT_QR,
  MOVE_LOT_DIRECT,
  SELECT_LOT,
  SEARCH_DEVICE,
  CONNECT_DEVICE,
  RE_CONNECT_DEVICE,
  NOT_FOUND_DEVICE,
  PAIRING_FAIL,
  RE_SEARCH_DEVICE,
  END_ANALYSIS,
  CANCEL_TEST,
  END_TEST,
  SDK_END
}