import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? qrController;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 9, child: _buildQrView(context)),
          // Expanded(
          //   child: Column(
          //     children: [
          //       if(result!=null)
          //          Text(result!.code.toString())
          //
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    // var scanArea = (MediaQuery.of(context).size.width < 400 ||
    //     MediaQuery.of(context).size.height < 400)
    //     ? 150.0
    //     : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    var scanArea = 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.dispose();
        Navigator.pop(context, result!.code);
        // controller.pauseCamera();
      });
    });
  }

// Widget _buildQrView(BuildContext context) {
//   // var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
//   var scanArea = 300.0.w;
//   return QRView(
//     key: qrKey,
//     onQRViewCreated: _onQRViewCreated,
//     overlay: QrScannerOverlayShape(
//         borderColor: Colors.red,
//         borderRadius: 10.w,
//         borderLength: 30.h,
//         borderWidth: 10.w,
//         cutOutSize: scanArea),
//   );
// }
//
// void _onQRViewCreated(QRViewController controller) {
//   setState(() {
//     this.qrController = controller;
//   });
//   FlutterBeep.playSysSound(42);
//   controller.scannedDataStream.listen((scanData) {
//     setState(() {
//       result = scanData;
//     });
//   });
//   print("QR Result: ${result!.code}");
//   // qrController!.pauseCamera();
//
// }
}
