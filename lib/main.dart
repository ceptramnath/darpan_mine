import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:darpan_mine/Authentication/LoginScreen_new_aadhar_bio_otp.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'Delivery/Screens/SplashScreen.dart';
import 'Delivery/Screens/shared_preference_service.dart';
import 'HomeScreen.dart';
import 'INSURANCE/Utils/DateTimeDetails.dart';
import 'LogCat.dart';
import 'Mails/MailsMainScreen.dart';
import 'Mails/backgroundoperations.dart';
import 'UtilitiesMainScreen.dart';
import 'Utils/ThemeManager.dart';
import 'Utils/ThemeTesting.dart';
import 'Utils/delete.dart';
import 'Authentication/CommonMainScreen.dart';

final navigatorKey = GlobalKey<NavigatorState>();
// BuildContext? alertDialogContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Main function");


  // int? y = int.tryParse(abc.toString().split('.').toString());
  // print(y);


  ByteData data =
      await PlatformAssetBundle().load('assets/certificate/star_cept.crt');

  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  final int helloAlarmID = 0;
  await AndroidAlarmManager.cancel(0);

  await AndroidAlarmManager.initialize();
  var timer = await sharedPreferenceService.getAccessTime();
  // await AndroidAlarmManager.periodic(Duration(seconds: int.parse(timer!)), helloAlarmID, iRunPeriodically)
  // await AndroidAlarmManager.periodic(Duration(minutes: 30) ,helloAlarmID, iRunPeriodically);
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 30), helloAlarmID, iRunPeriodically);

  // await AndroidAlarmManager.periodic(Duration(minutes: 3), helloAlarmID, iRunPeriodically,exact: true);
//   // DateFormat dateFormat=DateFormat("dd-MM-yyyy HH:mm:ss");
//    var parsedvalue=DateTime.parse("2022-02-10 15:40:36.795175");
//
//
//
// var now=DateTime.now();
// // print(now);
// print("Time Difference");
//    print("${now.difference(parsedvalue).inMinutes}");

  FlutterError.onError = (FlutterErrorDetails details) async{
    await LogCat().writeContent('${DateTimeDetails().currentDateTime()} : ${details.exception}\n\n');
    await LogCat().writeContent('${DateTimeDetails().currentDateTime()} : ${details.stack}\n\n');
  };

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // runApp(MyApp());
    runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => new ThemeNotifier(),
      child: MyApp(),
    ));
  });
  // checkdb();
}

// iRunPeriodically() async{
//   String? deviceID=await SharedPreferenceService().getDevID();
//
//   final String _onlyDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
//   final logpath=File('storage/emulated/0/Postman/Logs/$_onlyDate.txt');
//   if(logpath.existsSync()){}
//   else {
//     logpath.create();
//
//
//   }
//
// }

iRunPeriodically() async {
  await dataSync.download();
  await dataSync.upload();

  // String? initialtime=await SharedPreferenceService().getAccessTime();
  //
  // var parsedvalue=DateTime.parse(initialtime!);
  // print("ParsedValue: $parsedvalue");
  // var now=DateTime.now();
  // print("NowValue: $now");
  // if(now.difference(parsedvalue).inSeconds>=60){
  //   print("Entered");
  //   mms.invoke();
  // }

  //dBdelete.delete();// commented on 30-11-2022

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        builder: (context, child) {
          // return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 0.95.w),
          //     child: child!);
          return ResponsiveWrapper.builder(
              child!,
              maxWidth: MediaQuery.of(context).size.width,
              minWidth: MediaQuery.of(context).size.width,
              defaultScale: true,
              // defaultScaleFactor: 0.95.w,
            useShortestSide: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(MediaQuery.of(context).size.width, name: MOBILE),
                ResponsiveBreakpoint.autoScale(MediaQuery.of(context).size.width, name: TABLET),
                ResponsiveBreakpoint.resize(MediaQuery.of(context).size.width, name: DESKTOP),
              ],
              // background: Container(color: Color(0xFFF5F5F5))
          );

        },
        title: 'Darpan',
        theme: ThemeData(
            primarySwatch: Colors.red,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(10),
              thickness: MaterialStateProperty.all(5),
              thumbColor:
                  MaterialStateProperty.all(ColorConstants.kPrimaryAccent),
            )),
        // home: PostInfoReplicaHomeScreen(),
        // home: MainHomeScreen(),
        home:
             //MailsMainScreen(),
            // PdfGenerationScreen(),
            // themeManagement(),
        // leaveManagement(),
       SplashScreen(),
         //CommonMainScreen(),
       //MainHomeScreen( UtilitiesMainScreen(),  0),
        // LoginScreen(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => SplashScreen(),
        //   '/main': (context) => MainScreen(),
        //   '/registerLetterBooking' : (context) => RegisterLetterBookingScreen1(),
        //   '/emoBooking' : (context) => EMOMainScreen(),
        // },
      ),
      designSize: const Size(360, 640),
      minTextAdapt: true,
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//       builder: (context, theme, _) => MaterialApp(
//         theme: theme.getTheme(),
//         home: Scaffold(
//           appBar: AppBar(
//             title: Text('Hybrid Theme'),
//           ),
//           body: Row(
//             children: [
//               Container(
//                 child: FlatButton(
//                   onPressed: () => {
//                     print('Set Light Theme'),
//                     theme.setLightMode(),
//                   },
//                   child: Text('Set Light Theme'),
//                 ),
//               ),
//               Container(
//                 child: FlatButton(
//                   onPressed: () => {
//                     print('Set Dark theme'),
//                     theme.setDarkMode(),
//                   },
//                   child: Text('Set Dark theme'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
