import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:ml_scanner_plugin/ml_scanner_plugin.dart';
import 'package:ml_scanner_plugin/qr_camera.dart';

class SDMLScreen extends StatefulWidget {
  @override
  _SDMLScreenState createState() => _SDMLScreenState();
}

class _SDMLScreenState extends State<SDMLScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Expanded(child: _buildScanBrCode())],
      ),
    );
  }

  Widget _buildScanBrCode() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 150.0,
        child: QrCamera(
          onError: (context, error) => Text(
            error.toString(),
            style: TextStyle(color: Colors.red),
          ),
          qrCodeCallback: (code) {
            // setState(() {
            MlScannerPlugin.stop();
            Navigator.pop(context, code);
            // });
          },
        ),
      ),
    );
  }
}
