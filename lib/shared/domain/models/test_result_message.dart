
class TestResultMessage {
  int? imageLevel;
  String? title;
  String? message;

  TestResultMessage({this.imageLevel, this.title, this.message});

  TestResultMessage.fromJson(Map<String, dynamic> json) {
    if(json["imageLevel"] is int) {
      imageLevel = json["imageLevel"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["imageLevel"] = imageLevel;
    _data["title"] = title;
    _data["message"] = message;
    return _data;
  }
}