
class TestResultRequest {
  String? appType;
  String? appVersion;
  String? bleName;
  String? deviceId;
  String? firmwareVersion;
  String? lotNumber;
  String? serializedDeviceObject;
  double? testOneValue;
  double? testThreeValue;
  double? testTwoValue;
  String? sessionAlphaId;

  TestResultRequest({this.appType, this.appVersion, this.bleName, this.deviceId, this.firmwareVersion, this.lotNumber, this.serializedDeviceObject, this.testOneValue, this.testThreeValue, this.testTwoValue, this.sessionAlphaId});

  TestResultRequest.fromJson(Map<String, dynamic> json) {
    if(json["appType"] is String) {
      appType = json["appType"];
    }
    if(json["appVersion"] is String) {
      appVersion = json["appVersion"];
    }
    if(json["bleName"] is String) {
      bleName = json["bleName"];
    }
    if(json["deviceId"] is String) {
      deviceId = json["deviceId"];
    }
    if(json["firmwareVersion"] is String) {
      firmwareVersion = json["firmwareVersion"];
    }
    if(json["lotNumber"] is String) {
      lotNumber = json["lotNumber"];
    }
    if(json["serializedDeviceObject"] is String) {
      serializedDeviceObject = json["serializedDeviceObject"];
    }
    if(json["testOneValue"] is double) {
      testOneValue = json["testOneValue"];
    }
    if(json["testThreeValue"] is double) {
      testThreeValue = json["testThreeValue"];
    }
    if(json["testTwoValue"] is double) {
      testTwoValue = json["testTwoValue"];
    }
    if(json["sessionAlphaId"] is String) {
      sessionAlphaId = json["sessionAlphaId"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["appType"] = appType;
    _data["appVersion"] = appVersion;
    _data["bleName"] = bleName;
    _data["deviceId"] = deviceId;
    _data["firmwareVersion"] = firmwareVersion;
    _data["lotNumber"] = lotNumber;
    _data["serializedDeviceObject"] = serializedDeviceObject;
    _data["testOneValue"] = testOneValue;
    _data["testThreeValue"] = testThreeValue;
    _data["testTwoValue"] = testTwoValue;
    _data["sessionAlphaId"] = sessionAlphaId;
    return _data;
  }
}