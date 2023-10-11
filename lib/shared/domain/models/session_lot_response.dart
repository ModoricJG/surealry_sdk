
class SessionLotResponse {
  String? code;
  String? message;
  Data? data;

  SessionLotResponse({this.code, this.message, this.data});

  SessionLotResponse.fromJson(Map<String, dynamic> json) {
    if(json["code"] is String) {
      code = json["code"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["code"] = code;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? id;
  String? number;
  String? testType;
  int? version;
  String? expiredAt;

  Data({this.id, this.number, this.testType, this.version, this.expiredAt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["number"] is String) {
      number = json["number"];
    }
    if(json["testType"] is String) {
      testType = json["testType"];
    }
    if(json["version"] is int) {
      version = json["version"];
    }
    if(json["expiredAt"] is String) {
      expiredAt = json["expiredAt"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["number"] = number;
    _data["testType"] = testType;
    _data["version"] = version;
    _data["expiredAt"] = expiredAt;
    return _data;
  }
}