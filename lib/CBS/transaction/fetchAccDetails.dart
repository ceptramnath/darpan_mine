// import 'dart:io';
//
// import 'package:darpan_mine/CBS/screens/randomstring.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
//
// Future<File> fetchaccdetails(String accNum) async {
//   print("Reached writeContent");
//   final file=await File('$cachepath/fetchAccountDetails.txt');
//   file.writeAsStringSync('');
//   String text='{"2":"${accNum}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        60001700${accNum}","123":"SDP"}';
//   print(" fetch account details text");
//   print(text);
//   return file.writeAsString(text, mode: FileMode.append);
// }
//
// Future<File> fetchdepositdetails(String accnum,String amount) async {
//   print("Reached  Deposit writeContent");
//   // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
//   String tot=amount.padLeft(14,'0');
//   print(tot);
//   String padt=tot.padRight(16,'0');
//   print(padt);
//   final file=await File('$cachepath/fetchAccountDetails.txt');
//   file.writeAsStringSync('');
//   String text='{"2":"${accnum}","3":"490000","4":"$padt","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        50007504${accnum}","123":"SDP","126":"BO11202102003_50343458_BY CASH  "}';
//
//   print("deposit amount text");
//   print(text);
//   return file.writeAsString(text, mode: FileMode.append);
// }
