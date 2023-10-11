
class BleError {
  String? cmd;
  int? code;

  BleError({this.cmd, this.code});

  BleError.fromJson(Map<String, dynamic> json) {
    if(json["cmd"] is String) {
      cmd = json["cmd"];
    }
    if(json["code"] is int) {
      code = json["code"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cmd"] = cmd;
    _data["code"] = code;
    return _data;
  }
}