
class SaveLotRequest {
  String? sessionAlphaId;
  String? lotNumber;

  SaveLotRequest({this.sessionAlphaId, this.lotNumber});

  SaveLotRequest.fromJson(Map<String, dynamic> json) {
    if(json["sessionAlphaId"] is String) {
      sessionAlphaId = json["sessionAlphaId"];
    }
    if(json["lotNumber"] is String) {
      lotNumber = json["lotNumber"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["sessionAlphaId"] = sessionAlphaId;
    _data["lotNumber"] = lotNumber;
    return _data;
  }
}