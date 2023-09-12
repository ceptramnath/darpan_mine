// import 'package:flutter/services.dart';
// import 'package:flutter_telpo/flutter_telpo.dart';
//
// class PrintingTelPO {
//   FlutterTelpo _printer = new FlutterTelpo();
//
//   printThroughUsbPrinter(String reportType, String heading,List<String> reportData,List<String> secondData,int count) {
//     print('Inside Print Function..!');
//     for(int i =0;i<reportData.length;i++)
//       {
//         print(reportData[i]);
//       }
//
//     try {
//
//
//       _printer.connect();
//       _printer.isConnected().then((bool? isConneted) {
//         List<dynamic> _printables = [];
//
//         if (isConneted!) {
//           switch (reportType) {
//             case "BOOKING":
//               break;
//             case "PLI":
//               break;
//             case "CBS":
//               break;
//           }
//           _printables.addAll([
//             PrintRow(text: "Department of Posts-India",fontSize: 2,position: 1,),
//             PrintRow(text: "---------------------------",fontSize: 2,position: 1,)
//           ]);
//           _printables.addAll([
//             PrintRow(text: heading,fontSize: 2,position: 1,),
//             PrintRow(text: "---------------------------",fontSize: 2,position: 1,)
//           ]);
//
//           for (int i=0;i<reportData.length;i=i+2)
//             {
//               // print(i);
//               _printables.addAll([
//                 PrintRow(text: "${reportData[i].toString()}:${reportData[i+1].toString()}",fontSize: 2,position: 0,),
//                 // PrintRow(text: reportData[i+1].toString(),fontSize: 2,position: 1,),
//               ]);
//             }
//
//           _printables.addAll([
//             PrintRow(text: "***************************",fontSize: 2,position: 1,),
//             PrintRow(text: "===========================",fontSize: 2,position: 1,)
//           ]);
//           //second receipt
//
//           _printables.addAll([
//             PrintRow(text: "Department of Posts-India",fontSize: 2,position: 1,),
//             PrintRow(text: "---------------------------",fontSize: 2,position: 1,)
//           ]);
//           _printables.addAll([
//             PrintRow(text: heading,fontSize: 2,position: 1,),
//             PrintRow(text: "---------------------------",fontSize: 2,position: 1,)
//           ]);
//
//           for (int i=0;i<secondData.length;i=i+2)
//           {
//             // print(i);
//             _printables.addAll([
//               PrintRow(text: "${secondData[i].toString()}:${secondData[i+1].toString()}",fontSize: 2,position: 0,),
//               // PrintRow(text: reportData[i+1].toString(),fontSize: 2,position: 1,),
//             ]);
//           }
//
//
//
//
//           _printables.add(WalkPaper(step: 10));
//           for(int j=0;j<count;j++) {
//             _printer.print(_printables.toList());
//           }
//         }
//       });
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
// }
