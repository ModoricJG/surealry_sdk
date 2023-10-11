import 'dart:convert';
/// xClientId : "xClientId"
/// xSdkSecret : "xSdkSecret"
/// xBundleId : "xBundleId"
/// identifier : "test"
/// birth : 1990
/// gender : "male"
/// name : "안녕하세유"

StartParam startParamFromJson(String str) => StartParam.fromJson(json.decode(str));
String startParamToJson(StartParam data) => json.encode(data.toJson());
class StartParam {
  StartParam({
      String? xClientId, 
      String? xSdkSecret, 
      String? xBundleId, 
      String? identifier,
      String? birth,
      String? gender, 
      String? name,}){
    _xClientId = xClientId;
    _xSdkSecret = xSdkSecret;
    _xBundleId = xBundleId;
    _identifier = identifier;
    _birth = birth;
    _gender = gender;
    _name = name;
}

  StartParam.fromJson(dynamic json) {
    _xClientId = json['xClientId'];
    _xSdkSecret = json['xSdkSecret'];
    _xBundleId = json['xBundleId'];
    _identifier = json['identifier'];
    _birth = json['birth'];
    _gender = json['gender'];
    _name = json['name'];
  }
  String? _xClientId;
  String? _xSdkSecret;
  String? _xBundleId;
  String? _identifier;
  String? _birth;
  String? _gender;
  String? _name;
StartParam copyWith({  String? xClientId,
  String? xSdkSecret,
  String? xBundleId,
  String? identifier,
  String? birth,
  String? gender,
  String? name,
}) => StartParam(  xClientId: xClientId ?? _xClientId,
  xSdkSecret: xSdkSecret ?? _xSdkSecret,
  xBundleId: xBundleId ?? _xBundleId,
  identifier: identifier ?? _identifier,
  birth: birth ?? _birth,
  gender: gender ?? _gender,
  name: name ?? _name,
);
  String? get xClientId => _xClientId;
  String? get xSdkSecret => _xSdkSecret;
  String? get xBundleId => _xBundleId;
  String? get identifier => _identifier;
  String? get birth => _birth;
  String? get gender => _gender;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['xClientId'] = _xClientId;
    map['xSdkSecret'] = _xSdkSecret;
    map['xBundleId'] = _xBundleId;
    map['identifier'] = _identifier;
    map['birth'] = _birth;
    map['gender'] = _gender;
    map['name'] = _name;
    return map;
  }

}