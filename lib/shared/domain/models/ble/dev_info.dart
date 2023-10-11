class DevInfo {
  String? cmd;
  int? code;
  Data? data;

  DevInfo({this.cmd, this.code, this.data});

  DevInfo.fromJson(Map<String, dynamic> json) {
    if (json["cmd"] is String) {
      cmd = json["cmd"];
    }
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cmd"] = cmd;
    _data["code"] = code;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? stickColor;
  int? reactTime;
  int? insertTime;
  String? devId;
  String? fwVer;

  Data(
      {this.stickColor,
      this.reactTime,
      this.insertTime,
      this.devId,
      this.fwVer});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["stick_color"] is String) {
      stickColor = json["stick_color"];
    }
    if (json["react_time"] is int) {
      reactTime = json["react_time"];
    }
    if (json["insert_time"] is int) {
      insertTime = json["insert_time"];
    }
    if (json["dev_id"] is String) {
      devId = json["dev_id"];
    }
    if (json["fw_ver"] is String) {
      fwVer = json["fw_ver"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["stick_color"] = stickColor;
    _data["react_time"] = reactTime;
    _data["insert_time"] = insertTime;
    _data["dev_id"] = devId;
    _data["fw_ver"] = fwVer;
    return _data;
  }
}
