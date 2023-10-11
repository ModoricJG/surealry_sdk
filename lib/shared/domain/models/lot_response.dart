
class LotResponse {
  String? code;
  String? message;
  Data? data;

  LotResponse({this.code, this.message, this.data});

  LotResponse.fromJson(Map<String, dynamic> json) {
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
  List<Lots>? lots;
  List<RecentUsedLots>? recentUsedLots;

  Data({this.lots, this.recentUsedLots});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["lots"] is List) {
      lots = json["lots"] == null ? null : (json["lots"] as List).map((e) => Lots.fromJson(e)).toList();
    }
    if(json["recentUsedLots"] is List) {
      recentUsedLots = json["recentUsedLots"] == null ? null : (json["recentUsedLots"] as List).map((e) => RecentUsedLots.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(lots != null) {
      _data["lots"] = lots?.map((e) => e.toJson()).toList();
    }
    if(recentUsedLots != null) {
      _data["recentUsedLots"] = recentUsedLots?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class RecentUsedLots {
  int? id;
  String? number;
  int? version;
  String? expiredAt;

  RecentUsedLots({this.id, this.number, this.version, this.expiredAt});

  RecentUsedLots.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["number"] is String) {
      number = json["number"];
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
    _data["version"] = version;
    _data["expiredAt"] = expiredAt;
    return _data;
  }
}

class Lots {
  int? id;
  String? number;
  int? version;
  String? expiredAt;

  Lots({this.id, this.number, this.version, this.expiredAt});

  Lots.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["number"] is String) {
      number = json["number"];
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
    _data["version"] = version;
    _data["expiredAt"] = expiredAt;
    return _data;
  }
}