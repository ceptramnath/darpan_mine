
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class AndroidBluetoothPrinter {
  static const MethodChannel _channel =
  const MethodChannel('android_bluetooth_printer');

  /// Print to the first connected bluetooth printer
  static Future<String?> print(String text) async {
    final String? version = await _channel.invokeMethod('print', {
      "text": text,
    });
    return version;
  }

  static Future<String?> USBprint(String text,String b) async {
    print("Text is $text");
    final String? version = await _channel.invokeMethod('USBPrint', {
      "text": text,"b":b
    });
    return version;
  }

}
