class StatChk {
  String? cmd;
  int? code;
  Data? data;

  StatChk({this.cmd, this.code, this.data});

  StatChk.fromJson(Map<String, dynamic> json) {
    if (json["cmd"] is String) {
      cmd = json["cmd"];
    }
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["data"] is Map<String, dynamic>) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["cmd"] = cmd;
    _data["code"] = code;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? procStep;
  String? testState;
  String? stickColor;
  String? stickState;
  int? finTime;
  int? reactTime;
  String? reactChk;
  List<double>? rsltRawdata;

  Data(
      {this.procStep,
      this.testState,
      this.stickColor,
      this.stickState,
      this.finTime,
      this.reactTime,
      this.reactChk,
      this.rsltRawdata});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["proc_step"] is int) {
      procStep = json["proc_step"];
    }
    if (json["test_state"] is String) {
      testState = json["test_state"];
    }
    if (json["stick_color"] is String) {
      stickColor = json["stick_color"];
    }
    if (json["stick_state"] is String) {
      stickState = json["stick_state"];
    }
    if (json["fin_time"] is int) {
      finTime = json["fin_time"];
    }
    if (json["react_time"] is int) {
      reactTime = json["react_time"];
    }
    if (json["react_chk"] is String) {
      reactChk = json["react_chk"];
    }
    if (json["rslt_rawdata"] is List) {
      rsltRawdata = json["rslt_rawdata"] == null
          ? null
          : List<double>.from(json["rslt_rawdata"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["proc_step"] = procStep;
    _data["test_state"] = testState;
    _data["stick_color"] = stickColor;
    _data["stick_state"] = stickState;
    _data["fin_time"] = finTime;
    _data["react_time"] = reactTime;
    _data["react_chk"] = reactChk;
    if (rsltRawdata != null) {
      _data["rslt_rawdata"] = rsltRawdata;
    }
    return _data;
  }
}
