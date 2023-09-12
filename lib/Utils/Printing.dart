
import 'package:android_bluetooth_printer/android_bluetooth_printer.dart';
import 'package:flutter/material.dart';
import 'package:quick_usb/quick_usb.dart';

import '../main.dart';
import 'DisplayUSBDevices.dart';

class PrintingTelPO {
  // FlutterTelpo _printer = new FlutterTelpo();
  List<Map<String, dynamic>> devices = [];


  printThroughUsbPrinter(String reportType, String heading,
      List<String> reportData, List<String> secondData, int count) async {
    var init = await QuickUsb.init();
    print(init);
    List<UsbDevice>? _deviceList;
    UsbDevice _selectedDeviceList;
    _deviceList = await QuickUsb.getDeviceList();
    print("Devices");
    print(_deviceList);
    for(int i=0;i<_deviceList.length;i++){
      print(_deviceList[i].manufacturer);
      print(_deviceList[i].product);
    }
    // _selectedDeviceList=await DisplayUSBDevices( devices:_deviceList);
    // print(_selectedDeviceList);

    if(_deviceList.length>0){
      _selectedDeviceList= await  showDialog(
        barrierDismissible: true,
        context: navigatorKey.currentContext!,
        builder:
            (BuildContext dialogContext) {
          return WillPopScope(
            onWillPop: () async => false,
            child: DisplayUSBDevices(
                devices:_deviceList!
            ),
          );
        },);
      // var hasPermission = await QuickUsb.hasPermission(_deviceList.first);
      var hasPermission = await QuickUsb.hasPermission(_selectedDeviceList);
    print(_selectedDeviceList);
      print("Permission");
      print(hasPermission);
      if(hasPermission==false)
        await QuickUsb.requestPermission(_selectedDeviceList);
      var openDevice = await QuickUsb.openDevice(_selectedDeviceList);
      print("Device Opened");
      print(openDevice);
      print(_selectedDeviceList.productId);
      print("inside Print function..!");
      String str1 = "";
      String str2 = "";
      String dup = "DUPLICATE";
      print("Printing via Usb Connection");
      if (reportType == "DUP") {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);
        // for (int i =0;i<count;i++) {
        await AndroidBluetoothPrinter.USBprint(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]$heading\n" +
                "[C]--------------------------------\n" +
                "[C] <font size='big'>$dup</font> \n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n",_selectedDeviceList.product);
        // }

        print('Second Report Length -');
        print(secondData.length);
        if (secondData.length != 0) {
          for (int i = 0; i < secondData.length; i = i + 2) {
            str2 = str2 + "[L]${secondData[i]}[R]${secondData[i + 1]}\n";
          }
          print(str2);

          await AndroidBluetoothPrinter.USBprint(
            // str);
              "[C]<u>Department of Posts</u>\n" +
                  "[L]\n" +
                  "[C]$heading\n" +
                  "[C]--------------------------------\n" +
                  "[C] <font size='big'>$dup</font> \n" +
                  "[L]\n" +
                  str2 +
                  "[C]================================\n" +
                  "[C]\n" +
                  "[C]\n" +
                  "[C]\n",_selectedDeviceList.product);
        }
      }

      else if (reportType == "BODA") {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);

        await AndroidBluetoothPrinter.USBprint(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]Office Daily Account\n" +
                "[C]--------------------------------\n" +
                "[C]<barcode type='128' height='10'>$heading</barcode>\n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n",_selectedDeviceList.product);
      }
      else {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);
        // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
        // final Uint8List bytes = data.buffer.asUint8List();
        // final Image image = decodeImage(bytes);
        // printer.image(image);
        //printer
        // for (int i =0;i<count;i++) {
        await AndroidBluetoothPrinter.USBprint(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]$heading\n" +
                "[C]--------------------------------\n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n",_selectedDeviceList.product);
        // }

        print('Second Report Length -');
        print(secondData.length);
        if (secondData.length != 0) {
          for (int i = 0; i < secondData.length; i = i + 2) {
            str2 = str2 + "[L]${secondData[i]}[R]${secondData[i + 1]}\n";
          }
          print(str2);
          //
          await AndroidBluetoothPrinter.USBprint(
            // str);
              "[C]<u>Department of Posts</u>\n" +
                  "[L]\n" +
                  "[C]$heading\n" +
                  "[C]--------------------------------\n" +
                  "[L]\n" +
                  str2 +
                  "[C]================================\n" +
                  "[C]\n" +
                  "[C]\n" +
                  "[C]\n",_selectedDeviceList.product);
        }
      }
    }

    else {
      print("Printing via Bluetooth Connection");
      print("inside Print function..!");
      String str1 = "";
      String str2 = "";
      String dup = "DUPLICATE";
      if (reportType == "DUP") {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);
        // for (int i =0;i<count;i++) {
        await AndroidBluetoothPrinter.print(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]$heading\n" +



                "[C]--------------------------------\n" +
                "[C] <font size='big'>$dup</font> \n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n");
        // }

        print('Second Report Length -');
        print(secondData.length);
        if (secondData.length != 0) {
          for (int i = 0; i < secondData.length; i = i + 2) {
            str2 = str2 + "[L]${secondData[i]}[R]${secondData[i + 1]}\n";
          }
          print(str2);

          await AndroidBluetoothPrinter.print(
            // str);
              "[C]<u>Department of Posts</u>\n" +
                  "[L]\n" +
                  "[C]$heading\n" +
                  "[C]--------------------------------\n" +
                  "[C] <font size='big'>$dup</font> \n" +
                  "[L]\n" +
                  str2 +
                  "[C]================================\n" +
                  "[C]\n" +
                  "[C]\n" +
                  "[C]\n");
        }
      }

      else if (reportType == "BODA") {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);

        await AndroidBluetoothPrinter.print(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]Office Daily Account\n" +
                "[C]--------------------------------\n" +
                "[C]<barcode type='128' height='10'>$heading</barcode>\n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n");
      }
      else {
        print(reportData.length);
        for (int i = 0; i < reportData.length; i = i + 2) {
          // print("step $i - "+ str);
          str1 = str1 + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
          // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
          // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
        }

        print('Thermal Printing : ');
        print(str1);
        // final ByteData data = await rootBundle.load('assets/rabbit_black.jpg');
        // final Uint8List bytes = data.buffer.asUint8List();
        // final Image image = decodeImage(bytes);
        // printer.image(image);
        //printer
        // for (int i =0;i<count;i++) {
        await AndroidBluetoothPrinter.print(
          // str);
            "[C]<u>Department of Posts</u>\n" +
                "[L]\n" +
                "[C]$heading\n" +
                "[C]--------------------------------\n" +
                "[L]\n" +
                str1 +
                "[C]================================\n" +
                "[C]\n" +
                "[C]\n" +
                "[C]\n");
        // }

        print('Second Report Length -');
        print(secondData.length);
        if (secondData.length != 0) {
          for (int i = 0; i < secondData.length; i = i + 2) {
            str2 = str2 + "[L]${secondData[i]}[R]${secondData[i + 1]}\n";
          }
          print(str2);

          await AndroidBluetoothPrinter.print(
            // str);
              "[C]<u>Department of Posts</u>\n" +
                  "[L]\n" +
                  "[C]$heading\n" +
                  "[C]--------------------------------\n" +
                  "[L]\n" +
                  str2 +
                  "[C]================================\n" +
                  "[C]\n" +
                  "[C]\n" +
                  "[C]\n");
        }
      }
    }

  }
}
