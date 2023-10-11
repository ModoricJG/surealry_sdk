
class RsltData {
  String? cmd;
  Data? data;

  RsltData({this.cmd, this.data});

  RsltData.fromJson(Map<String, dynamic> json) {
    if(json["cmd"] is String) {
      cmd = json["cmd"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cmd"] = cmd;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? rsltLevel;

  Data({this.rsltLevel});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["rslt_level"] is int) {
      rsltLevel = json["rslt_level"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["rslt_level"] = rsltLevel;
    return _data;
  }
}