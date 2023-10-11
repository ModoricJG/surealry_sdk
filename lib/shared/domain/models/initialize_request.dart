
class InitializeRequest {
  String? identifier;
  MobilePhone? mobilePhone;
  Profile? profile;

  InitializeRequest({this.identifier, this.mobilePhone, this.profile});

  InitializeRequest.fromJson(Map<String, dynamic> json) {
    if(json["identifier"] is String) {
      identifier = json["identifier"];
    }
    if(json["mobilePhone"] is Map) {
      mobilePhone = json["mobilePhone"] == null ? null : MobilePhone.fromJson(json["mobilePhone"]);
    }
    if(json["profile"] is Map) {
      profile = json["profile"] == null ? null : Profile.fromJson(json["profile"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["identifier"] = identifier;
    if(mobilePhone != null) {
      _data["mobilePhone"] = mobilePhone?.toJson();
    }
    if(profile != null) {
      _data["profile"] = profile?.toJson();
    }
    return _data;
  }
}

class Profile {
  int? birth;
  String? gender;
  String? name;

  Profile({this.birth, this.gender, this.name});

  Profile.fromJson(Map<String, dynamic> json) {
    if(json["birth"] is int) {
      birth = json["birth"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["birth"] = birth;
    _data["gender"] = gender;
    _data["name"] = name;
    return _data;
  }
}

class MobilePhone {
  String? appOs;
  String? appOsVersion;
  String? phoneModel;
  String? phoneUid;
  String? sdkVersion;

  MobilePhone({this.appOs, this.appOsVersion, this.phoneModel, this.phoneUid, this.sdkVersion});

  MobilePhone.fromJson(Map<String, dynamic> json) {
    if(json["appOs"] is String) {
      appOs = json["appOs"];
    }
    if(json["appOsVersion"] is String) {
      appOsVersion = json["appOsVersion"];
    }
    if(json["phoneModel"] is String) {
      phoneModel = json["phoneModel"];
    }
    if(json["phoneUid"] is String) {
      phoneUid = json["phoneUid"];
    }
    if(json["sdkVersion"] is String) {
      sdkVersion = json["sdkVersion"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["appOs"] = appOs;
    _data["appOsVersion"] = appOsVersion;
    _data["phoneModel"] = phoneModel;
    _data["phoneUid"] = phoneUid;
    _data["sdkVersion"] = sdkVersion;
    return _data;
  }
}