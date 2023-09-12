
import 'dart:async';

import 'package:flutter/services.dart';

class Newenc {
  static const MethodChannel _channel = MethodChannel('newenc');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> signString(String a) async {
    final String version = await _channel.invokeMethod('signString',<String,dynamic>{
      'a':a,
    });
    return version;
  }
  static Future<String> verifyString(String a,String b) async {
    final String version = await _channel.invokeMethod('verifyString',<String,dynamic>{
      'a':a, 'b':b,
    });
    return version;
  }


  static Future<String> signfiles(String a) async {
    final String version = await _channel.invokeMethod('signFiles',<String,dynamic>{
      'a':a,
    });
    return version;
  }


  static Future<String> verifyfiles(String a,String b) async {
    final String version = await _channel.invokeMethod('verifyFiles',<String,dynamic>{
      'a':a, 'b':b,
    });
    return version;
  }

  static Future<String> tester(String path,String endpoint,String contentid) async {
    final String v = await _channel.invokeMethod('Test',<String, dynamic>{
      'a':path,'b':endpoint,'c':contentid,
    });
    return v;
  }

}
