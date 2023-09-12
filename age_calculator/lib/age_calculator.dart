
import 'dart:async';

import 'package:flutter/services.dart';

class AgeCalculator {
  static const MethodChannel _channel = MethodChannel('age_calculator');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String?> calculate(String a) async {
    final String? version = await _channel.invokeMethod('calc',<String,dynamic>{
      'a':a
    });
    return version;
  }
}
