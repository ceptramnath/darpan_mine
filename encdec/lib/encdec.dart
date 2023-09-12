
import 'dart:async';

import 'package:flutter/services.dart';

class Encdec {
  static const MethodChannel _channel = MethodChannel('encdec');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> encrypt(String a) async {
    final String version = await _channel.invokeMethod('encrypt',<String,dynamic>{
      'a':a,
    });
    return version;
  }
  static Future<String> decrypt(String a,String b) async {
    final String version = await _channel.invokeMethod('decrypt',<String,dynamic>{
      'a':a, 'b':b,
    });
    return version;
  }

}
