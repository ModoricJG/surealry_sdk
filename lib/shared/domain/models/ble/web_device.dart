
class WebDevice {
  String? id;
  String? name;
  String? state;

  WebDevice({this.id, this.name, this.state});

  WebDevice.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["state"] is String) {
      state = json["state"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["state"] = state;
    return _data;
  }

  WebDevice copyWith({
    String? id,
    String? name,
    String? state,
  }) {
    return WebDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
    );
  }

}