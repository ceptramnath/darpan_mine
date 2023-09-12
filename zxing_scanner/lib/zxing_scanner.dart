
import 'dart:async';

import 'package:flutter/services.dart';

const CameraAccessDenied = 'PERMISSION_NOT_GRANTED';

  const MethodChannel _channel =  MethodChannel('zxing_scan');
  Future<String> scan() async => await _channel.invokeMethod('scan');

