
class HeaderInfo {
  String? xClientId;
  String? xSdkSecret;
  String? xBundleId;
  String? acceptLanguage;

  HeaderInfo({this.xClientId, this.xSdkSecret, this.xBundleId, this.acceptLanguage});

  HeaderInfo.fromJson(Map<String, dynamic> json) {
    if(json["xClientId"] is String) {
      xClientId = json["xClientId"];
    }
    if(json["xSdkSecret"] is String) {
      xSdkSecret = json["xSdkSecret"];
    }
    if(json["xBundleId"] is String) {
      xBundleId = json["xBundleId"];
    }
    if(json["xBundleId"] is String) {
      xBundleId = json["xBundleId"];
    }
    if (json["acceptLanguage"] is String) {
      xBundleId = json["acceptLanguage"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["xClientId"] = xClientId;
    _data["xSdkSecret"] = xSdkSecret;
    _data["xBundleId"] = xBundleId;
    _data["acceptLanguage"] = acceptLanguage;
    return _data;
  }
}