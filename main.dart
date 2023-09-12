// import 'dart:io';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:darpan_mine/Authentication/LoginScreen.dart';
// import 'package:darpan_mine/Authentication/RegistrationScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:darpan_mine/Constants/Color.dart';
//
//
//
// import 'DatabaseModel/PostOfficeModel.dart';
//
// import 'Delivery/Screens/SplashScreen.dart';
//
// import 'Delivery/Screens/shared_preference_service.dart';
//
// import 'Mails/MailsMainScreen.dart';
// import 'Mails/backgroundoperations.dart';
// import 'package:logger/logger.dart';
//
//
//
// void main() async{
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   ByteData data = await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
//
//   SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
//
//   final int helloAlarmID=0;
//   await AndroidAlarmManager.cancel(0);
//
//
//   await AndroidAlarmManager.initialize();
//   var timer=await sharedPreferenceService.getAccessTime();
//   // await AndroidAlarmManager.periodic(Duration(seconds: int.parse(timer!)), helloAlarmID, iRunPeriodically)
//   await AndroidAlarmManager.periodic(Duration(hours: 01) ,helloAlarmID, iRunPeriodically);
//
//   // await AndroidAlarmManager.periodic(Duration(minutes: 3), helloAlarmID, iRunPeriodically,exact: true);
// //   // DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
// //    var parsedvalue=DateTime.parse("2022-02-10 15:40:36.795175");
// //
// //
// //
// // var now=DateTime.now();
// // // print(now);
// // print("Time Difference");
// //    print("${now.difference(parsedvalue).inMinutes}");
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
//     runApp(MyApp());
//   });
//   checkdb();
// }
//
// // iRunPeriodically() async{
// //   String? deviceID=await SharedPreferenceService().getDevID();
// //
// //   final String _onlyDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
// //   final logpath=File('storage/emulated/0/Postman/Logs/$_onlyDate.txt');
// //   if(logpath.existsSync()){}
// //   else {
// //     logpath.create();
// //
// //
// //   }
// //
// // }
//
//
//
//
// iRunPeriodically() async{
//   await dataSync.download();
//   await dataSync.upload();
//
//   String? initialtime=await SharedPreferenceService().getAccessTime();
//
//   var parsedvalue=DateTime.parse(initialtime!);
//   print("ParsedValue: $parsedvalue");
//   var now=DateTime.now();
//   print("NowValue: $now");
//   if(now.difference(parsedvalue).inSeconds>=60){
//     print("Entered");
//     mms.invoke();
//   }
// }
//
// checkdb() async{
//   var length=await Vpp().select().toCount();
//   print("length of VPP: $length");
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       builder: (_) => MaterialApp(
//         builder: (context,child){
//           return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95.w), child: child!);
//         },
//         title: 'Darpan',
//         theme: ThemeData(
//             primarySwatch: Colors.red,
//             visualDensity: VisualDensity.adaptivePlatformDensity,
//             scrollbarTheme: ScrollbarThemeData(
//               radius: Radius.circular(10),
//               thickness: MaterialStateProperty.all(5),
//               thumbColor: MaterialStateProperty.all(ColorConstants.kPrimaryAccent),
//
//             )
//         ),
//         // home: PostInfoReplicaHomeScreen(),
//         // home: MainHomeScreen(),
//         home: SplashScreen(),
//         // initialRoute: '/',
//         // routes: {
//         //   '/': (context) => SplashScreen(),
//         //   '/main': (context) => MainScreen(),
//         //   '/registerLetterBooking' : (context) => RegisterLetterBookingScreen1(),
//         //   '/emoBooking' : (context) => EMOMainScreen(),
//         // },
//       ),
//       designSize: const Size(360, 640),
//       minTextAdapt: true,
//     );
//   }
// }
//
