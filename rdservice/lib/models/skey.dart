part of 'package:rdservice/rdservice.dart';

class Skey {
  late final String ci;

  late final String value;

  Skey(this.ci, this.value);

  Skey.fromJson(Map<String, dynamic> json) {
    ci = json['ci'] ?? '';
    value = json['\$t'] ?? '';
  }
}
