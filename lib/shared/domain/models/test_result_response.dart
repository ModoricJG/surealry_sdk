
class TestResultResponse {
  String? code;
  String? message;
  Data? data;

  TestResultResponse({this.code, this.message, this.data});

  TestResultResponse.fromJson(Map<String, dynamic> json) {
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
  String? hormoneId;
  String? testType;
  int? lotInfoId;
  String? summaryTitle;
  String? summaryContent;
  String? detailTitle;
  String? detailContent;
  int? testOneLevel;
  int? testTwoLevel;
  int? testThreeLevel;
  bool? testSuccessful;
  int? imageLevel;
  String? createdAt;

  Data({this.id, this.hormoneId, this.testType, this.lotInfoId, this.summaryTitle, this.summaryContent, this.detailTitle, this.detailContent, this.testOneLevel, this.testTwoLevel, this.testThreeLevel, this.testSuccessful, this.imageLevel, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["hormoneId"] is String) {
      hormoneId = json["hormoneId"];
    }
    if(json["testType"] is String) {
      testType = json["testType"];
    }
    if(json["lotInfoId"] is int) {
      lotInfoId = json["lotInfoId"];
    }
    if(json["summaryTitle"] is String) {
      summaryTitle = json["summaryTitle"];
    }
    if(json["summaryContent"] is String) {
      summaryContent = json["summaryContent"];
    }
    if(json["detailTitle"] is String) {
      detailTitle = json["detailTitle"];
    }
    if(json["detailContent"] is String) {
      detailContent = json["detailContent"];
    }
    if(json["testOneLevel"] is int) {
      testOneLevel = json["testOneLevel"];
    }
    if(json["testTwoLevel"] is int) {
      testTwoLevel = json["testTwoLevel"];
    }
    if(json["testThreeLevel"] is int) {
      testThreeLevel = json["testThreeLevel"];
    }
    if(json["testSuccessful"] is bool) {
      testSuccessful = json["testSuccessful"];
    }
    if(json["imageLevel"] is int) {
      imageLevel = json["imageLevel"];
    }
    if(json["createdAt"] is String) {
      createdAt = json["createdAt"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["hormoneId"] = hormoneId;
    _data["testType"] = testType;
    _data["lotInfoId"] = lotInfoId;
    _data["summaryTitle"] = summaryTitle;
    _data["summaryContent"] = summaryContent;
    _data["detailTitle"] = detailTitle;
    _data["detailContent"] = detailContent;
    _data["testOneLevel"] = testOneLevel;
    _data["testTwoLevel"] = testTwoLevel;
    _data["testThreeLevel"] = testThreeLevel;
    _data["testSuccessful"] = testSuccessful;
    _data["imageLevel"] = imageLevel;
    _data["createdAt"] = createdAt;
    return _data;
  }
}