part of 'package:rdservice/rdservice.dart';

class DeviceInfo {
  late final String srno;

  late final String dpId;

  late final String rdsId;

  late final String rdsVer;

  late final String dc;

  late final String mi;

  late final String mc;

  late final AdditionalInfo addInfo;

  DeviceInfo(this.srno, this.dpId, this.rdsId, this.rdsVer, this.dc, this.mi,
      this.mc, this.addInfo);

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    srno = json['srno'] ?? '';
    dpId = json['dpId'] ?? '';
    rdsId = json['rdsId'] ?? '';
    rdsVer = json['rdsVer'] ?? '';
    dc = json['dc'] ?? '';
    mi = json['mi'] ?? '';
    mc = json['mc'] ?? '';
    addInfo = AdditionalInfo.fromJson(json['additional_info'] ?? {});
  }
}

class AdditionalInfo {
  late final List<Param> params;

  AdditionalInfo(this.params);

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    params =
        ((json['Param'] ?? []) as List).map((e) => Param.fromJson(e)).toList();
  }
}

class Param {
  late final String name;

  late final String value;

  Param(this.name, this.value);

  Param.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    value = json['value'] ?? '';
  }
}
