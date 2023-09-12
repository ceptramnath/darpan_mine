import 'package:darpan_mine/Delivery/Screens/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_plugin/scanner_plugin.dart';
import 'package:zxing_scanner/zxing_scanner.dart' as scanner;

import '../main.dart';
import 'BarrasScan.dart';
import 'MlScan.dart';
import 'QRScan.dart';

class Scan {

  scanBag() async {
    int scannerValue=await SharedPreferenceService().getScannerValue();
    // int scannerValue = 2;
    String? barcodeResult;
    try {
      // barcodeResult = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (scannerValue == 4) {
        barcodeResult = await scanner.scan();
      } else if (scannerValue == 0) {
        barcodeResult = await ScannerPlugin.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      } else if (scannerValue == 1) {
        barcodeResult = await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => SDMLScreen()),
        );
        print("Barcode Value: $barcodeResult");
      } else if (scannerValue == 2) {
        barcodeResult = await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => QRScreen()),
        );
        print("Barcode Value: $barcodeResult");
      } else if (scannerValue == 3) {
        barcodeResult = await Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => BarrasScan()),
        );
        print("Barcode Value: $barcodeResult");
      }
    } on PlatformException {
      barcodeResult = 'Failed to get platform version.';
    }

    return barcodeResult;
  }

  // scanArticle() async {
  //
  //   int scannerValue=await SharedPreferenceService().getScannerValue();
  //   // int scannerValue = 2;
  //   String? barcodeResult;
  //
  //   try {
  //     // barcodeResult = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     if (scannerValue == 4)
  //       barcodeResult = await scanner.scan();
  //     else if (scannerValue == 0)
  //       barcodeResult = await ScannerPlugin.scanBarcode(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     else if (scannerValue == 1) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => SDMLScreen()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     } else if (scannerValue == 2) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => QRScreen()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     } else if (scannerValue == 3) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => BarrasScan()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     }
  //   } on PlatformException {
  //     barcodeResult = 'Failed to get platform version.';
  //   }
  //
  //   return barcodeResult;
  // }
  //
  // scanBarCode() async {
  //   int scannerValue=await SharedPreferenceService().getScannerValue();
  //   // int scannerValue = 2;
  //   String? barcodeResult;
  //   try {
  //     // barcodeResult = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     if (scannerValue == 4)
  //       barcodeResult = await scanner.scan();
  //     else if (scannerValue == 0)
  //       barcodeResult = await ScannerPlugin.scanBarcode(
  //           '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //     else if (scannerValue == 1) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => SDMLScreen()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     } else if (scannerValue == 2) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => QRScreen()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     } else if (scannerValue == 3) {
  //       barcodeResult = await Navigator.push(
  //         navigatorKey.currentContext!,
  //         MaterialPageRoute(builder: (context) => BarrasScan()),
  //       );
  //       print("Barcode Value: $barcodeResult");
  //     }
  //   } on PlatformException {
  //     barcodeResult = 'Failed to get platform version.';
  //   }
  //   return barcodeResult;
  // }
}
