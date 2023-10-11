
class LogRequest {
  String? content;
  bool? isSuccess;
  String? sessionAlphaId;
  String? tag;

  LogRequest({this.content, this.isSuccess, this.sessionAlphaId, this.tag});

  LogRequest.fromJson(Map<String, dynamic> json) {
    if(json["content"] is String) {
      content = json["content"];
    }
    if(json["isSuccess"] is bool) {
      isSuccess = json["isSuccess"];
    }
    if(json["sessionAlphaId"] is String) {
      sessionAlphaId = json["sessionAlphaId"];
    }
    if(json["tag"] is String) {
      tag = json["tag"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["content"] = content;
    _data["isSuccess"] = isSuccess;
    _data["sessionAlphaId"] = sessionAlphaId;
    _data["tag"] = tag;
    return _data;
  }

  LogRequest copyWith({
    String? content,
    bool? isSuccess,
    String? sessionAlphaId,
    String? tag,
  }) {
    return LogRequest(
      content: content ?? this.content,
      isSuccess: isSuccess ?? this.isSuccess,
      sessionAlphaId: sessionAlphaId ?? this.sessionAlphaId,
      tag: tag ?? this.tag,
    );
  }

}