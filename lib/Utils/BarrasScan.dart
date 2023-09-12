import 'package:darpan_mine/barras/barras2.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

class BarrasScan extends StatefulWidget {
  @override
  _BarrasScanState createState() => _BarrasScanState();
}

class _BarrasScanState extends State<BarrasScan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scanBarCode();
    });
  }

  scanBarCode() async {
    await Future.delayed(Duration(milliseconds: 500));
    final data = await Barras.scan(
      context,
      viewfinderHeight: 120,
      viewfinderWidth: 300,
      borderColor: Colors.red,
      borderRadius: 24,
      borderStrokeWidth: 2,
      buttonColor: Colors.white,
      borderFlashDuration: 250,
      successBeep: false,
    );
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
