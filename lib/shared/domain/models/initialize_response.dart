
class InitializeResponse {
  String? code;
  String? message;
  Data? data;

  InitializeResponse({this.code, this.message, this.data});

  InitializeResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? sessionAlphaId;
  Device? device;
  List<TestableTypes>? testableTypes;

  Data({this.userId, this.sessionAlphaId, this.device, this.testableTypes});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["userId"] is int) {
      userId = json["userId"];
    }
    if(json["sessionAlphaId"] is String) {
      sessionAlphaId = json["sessionAlphaId"];
    }
    if(json["device"] is Map) {
      device = json["device"] == null ? null : Device.fromJson(json["device"]);
    }
    if(json["testableTypes"] is List) {
      testableTypes = json["testableTypes"] == null ? null : (json["testableTypes"] as List).map((e) => TestableTypes.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["userId"] = userId;
    _data["sessionAlphaId"] = sessionAlphaId;
    if(device != null) {
      _data["device"] = device?.toJson();
    }
    if(testableTypes != null) {
      _data["testableTypes"] = testableTypes?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class TestableTypes {
  String? testType;
  String? colorCode;

  TestableTypes({this.testType, this.colorCode});

  TestableTypes.fromJson(Map<String, dynamic> json) {
    if(json["testType"] is String) {
      testType = json["testType"];
    }
    if(json["colorCode"] is String) {
      colorCode = json["colorCode"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["testType"] = testType;
    _data["colorCode"] = colorCode;
    return _data;
  }
}

class Device {
  int? deviceSearchSeconds;
  int? stickInsertDelaySeconds;
  int? deviceTestSeconds;
  List<String>? deviceNamePrefix;
  List<String>? recentTestDevice;

  Device({this.deviceSearchSeconds, this.stickInsertDelaySeconds, this.deviceTestSeconds, this.deviceNamePrefix, this.recentTestDevice});

  Device.fromJson(Map<String, dynamic> json) {
    if(json["deviceSearchSeconds"] is int) {
      deviceSearchSeconds = json["deviceSearchSeconds"];
    }
    if(json["stickInsertDelaySeconds"] is int) {
      stickInsertDelaySeconds = json["stickInsertDelaySeconds"];
    }
    if(json["deviceTestSeconds"] is int) {
      deviceTestSeconds = json["deviceTestSeconds"];
    }
    if(json["deviceNamePrefix"] is List) {
      deviceNamePrefix = json["deviceNamePrefix"] == null ? null : List<String>.from(json["deviceNamePrefix"]);
    }
    if(json["recentTestDevice"] is List) {
      recentTestDevice = json["recentTestDevice"] == null ? null : List<String>.from(json["recentTestDevice"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["deviceSearchSeconds"] = deviceSearchSeconds;
    _data["stickInsertDelaySeconds"] = stickInsertDelaySeconds;
    _data["deviceTestSeconds"] = deviceTestSeconds;
    if(deviceNamePrefix != null) {
      _data["deviceNamePrefix"] = deviceNamePrefix;
    }
    if(recentTestDevice != null) {
      _data["recentTestDevice"] = recentTestDevice;
    }
    return _data;
  }
}