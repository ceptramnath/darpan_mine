import 'package:android_bluetooth_printer/android_bluetooth_printer.dart';
// import 'package:flutter_telpo/flutter_telpo.dart';

class PrintingTelPO {
  // FlutterTelpo _printer = new FlutterTelpo();

  printThroughUsbPrinter(String reportType, String heading,
      List<String> reportData, List<String> secondData, int count) async {
    print("inside Print function..!");
    String str = "";

    print(reportData.length);
    for (int i = 0; i < reportData.length; i = i + 2) {
      // print("step $i - "+ str);
      str = str + "[L]${reportData[i]}[R]${reportData[i + 1]}\n";
      // str = str + "[L]${reportData[2]}[R]${reportData[3]}\n";
      // str = str + "[L]${reportData[4]}[R]${reportData[5]}\n";
    }

    print('Thermal Printing : ');
    print(str);
    await AndroidBluetoothPrinter.print(
        // str);
        "[C]<u>Department of Posts</u>\n" +
            "[L]\n" +
            "[C]$heading\n" +
            "[C]--------------------------------\n" +
            "[L]\n" +
            str +
            "[C]================================\n" +
            "[C]\n" +
            "[C]\n" +
            "[C]\n");
  }
}
