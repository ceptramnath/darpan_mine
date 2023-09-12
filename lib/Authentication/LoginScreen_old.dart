// import 'dart:async';
// import 'dart:convert';
// import '../UtilitiesMainScreen.dart';
// import 'package:darpan_mine/Authentication/db/registrationdb.dart';
// import 'package:darpan_mine/DatabaseModel/transtable.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
// import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Mails/MailsMainScreen.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
//
// import './RegistrationScreen.dart';
// import './ResetPasswordScreen.dart';
// import '../../HomeScreen.dart';
// import '../AlertDialogChecker.dart';
// import 'APIEndPoints.dart';
// import 'db/registrationdb.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// int? validtimer;
// StreamSubscription<int>? every3seconds;
//
// class _LoginScreenState extends State<LoginScreen> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   String _usernameError = "";
//   APIEndPoints apiEndPoints = new APIEndPoints();
//   late final loginuri = apiEndPoints.login;
//   List<USERLOGINDETAILS> loginDetails = [];
//   String access_token = "";
//   String refresh_token = "";
//   String validity = "";
//   bool visiblty = false;
//
//   @override
//   void initState() {
//     usernameController.clear();
//     passwordController.clear();
//
//     super.initState();
//   }
//
//   bool validatePassword(String value) {
//     String pattern =
//         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
//     RegExp regExp = new RegExp(pattern);
//     return regExp.hasMatch(value);
//   }
//
//   String? validatePasswordString(String value) {
//     RegExp regex =
//         RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
//     if (value.isEmpty) {
//       return 'Please enter password';
//     } else {
//       if (!regex.hasMatch(value)) {
//         return 'Enter valid password';
//       } else {
//         return null;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Image.asset(
//           "assets/images/background_screen.jpeg",
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.cover,
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                     padding: EdgeInsets.only(
//                         top: 150.h, left: 18.w, bottom: 8.h, right: 5.w),
//                     child: SizedBox.shrink()),
//                 SizedBox(
//                   height: 180.h,
//                 ),
//                 Column(
//                   children: [
//                     // AuthForm(title: 'Employee ID/Username', controller: usernameController, icon: MdiIcons.idCard,),
//                     // AuthForm(title: 'Password', controller: passwordController, icon: Icons.lock_outline,),
//                     //Center(child: Button(buttonText: 'LOGIN', buttonFunction: (){})),
//
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * .75.w,
//                         child: TextFormField(
//                           controller: usernameController,
//                           style: TextStyle(color: Colors.amberAccent),
//                           keyboardType: TextInputType.number,
//                           // maxLength: 10,
//                           // maxLengthEnforced: true,
//                           // readOnly: true,
//                           decoration: InputDecoration(
//                             labelText: "Employee ID / Username",
//                             hintStyle: TextStyle(
//                               fontSize: 15,
//                               color: Color.fromARGB(255, 2, 40, 86),
//                               fontWeight: FontWeight.w500,
//                             ),
//                             border: InputBorder.none,
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.blueGrey, width: 3)),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                     BorderSide(color: Colors.green, width: 3)),
//                             contentPadding: EdgeInsets.only(
//                                 top: 20, bottom: 20, left: 20, right: 20),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * .75.w,
//                         child: TextFormField(
//                           obscureText: true,
//                           enableSuggestions: false,
//                           autocorrect: false,
//                           controller: passwordController,
//                           style: TextStyle(color: Colors.amberAccent),
//                           keyboardType: TextInputType.visiblePassword,
//                           // maxLength: 10,
//                           // maxLengthEnforced: true,
//                           // readOnly: true,
//                           decoration: InputDecoration(
//                             labelText: "Password",
//                             hintStyle: TextStyle(
//                               fontSize: 15,
//                               color: Color.fromARGB(255, 2, 40, 86),
//                               fontWeight: FontWeight.w500,
//                             ),
//                             border: InputBorder.none,
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.blueGrey, width: 3)),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide:
//                                     BorderSide(color: Colors.green, width: 3)),
//                             contentPadding: EdgeInsets.only(
//                                 top: 20, bottom: 20, left: 20, right: 20),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) => const ResetPasswordScreen()));
//
//                           // Navigator.push(context,
//                           //     MaterialPageRoute(builder: (_) => const PdfGenerationScreen()));
//                         },
//                         child: const Text(
//                           "Forgot Password?",
//                           style: TextStyle(color: Colors.amberAccent),
//                         ),
//                       ),
//                     ),
//                     Center(
//                       child: Button(
//                           buttonText: 'LOGIN',
//                           buttonFunction: () async {
//                             setState(() {
//                               visiblty = true;
//                             });
//
//                             //1. Check all validations
//                             if (usernameController.text.isEmpty ||
//                                 passwordController.text.isEmpty)
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text("Enter UserID/Password."),
//                               ));
//                             else if (!validatePassword(
//                                 passwordController.text)) {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text("Invalid Password"),
//                               ));
//                             }
//                             //2. check whether user detail is available in local DB.
//                             // If available perform local JWT validation else hit Login API.
//                             final loginDetails = await USERLOGINDETAILS()
//                                 .select()
//                                 .EMPID
//                                 .contains(usernameController.text)
//                                 .toList();
//
//                             //when user details available in local DB.
//                             if (loginDetails.length > 0 &&
//                                 loginDetails[0].AccessToken.toString() !=
//                                     null) {
//                               if (loginDetails[0].Password !=
//                                   passwordController.text) {
//                                 setState(() {
//                                   visiblty = false;
//                                 });
//                                 UtilFs.showToast(
//                                     "User Credentials is wrong", context);
//                               } else {
//                                 print(
//                                     'User details with Access token is available in local db.');
//                                 bool rtValue = JwtCheck(loginDetails);
//                                 print('JWT Function return value - ' +
//                                     rtValue.toString());
//
//                                 //when token is not valid
//                                 if (!rtValue) {
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(SnackBar(
//                                     content: Text("Access Token Expired..!"),
//                                   ));
//                                   bool value = false;
//                                   bool netresult =
//                                       await InternetConnectionChecker()
//                                           .hasConnection;
//                                   if (netresult) {
//                                     value = await LoginAPI(
//                                         loginuri,
//                                         usernameController.text,
//                                         passwordController.text);
//                                   } else {
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(SnackBar(
//                                       content: Text(
//                                           "Internet connection is not available..!"),
//                                     ));
//                                   }
//
//                                   if (value) {
//                                     //commented by Rohit for testing, later has to be uncommented
//                                     /*
//                                 loginDetails[0].EMPID = usernameController.text;
//                                 loginDetails[0].Password =
//                                     passwordController.text;
//                                 loginDetails[0].AccessToken = "";
//                                 loginDetails[0].RefreshToken = "";
//                                 loginDetails[0].Validity = "";
//
//                                 final accessSave = await USERLOGINDETAILS()
//                                     .upsertAll(loginDetails);
//                                 if (accessSave.success)
//                                   print("Access details stored into local db.");
//                                 else
//                                   print(accessSave.errorMessage);
//
//                                  */
//
//                                     // await USERDETAILS().select().delete();
//                                     // final sql =
//                                     //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
//                                     // final result = await UserDB().execSQL(sql);
//                                     // print(result);
//                                     //
//                                     // //Inserting Master Data as API is pending
//                                     // await OFCMASTERDATA().select().delete();
//                                     // final sql1 =
//                                     //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','049213','570010')";
//                                     // final result1 =
//                                     // await UserDB().execSQL(sql1);
//                                     // print(result);
//                                     // print('Office Master Data');
//                                     // final ofcMaster =
//                                     // await OFCMASTERDATA().select().toList();
//                                     // print(ofcMaster[0].EMOCODE);
//
//                                     print(
//                                         "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
//                                     final loginDetails =
//                                         await USERLOGINDETAILS()
//                                             .select()
//                                             .toList();
//
//                                     final ofcMaster1 = await OFCMASTERDATA()
//                                         .select()
//                                         .toCount();
//                                     print(ofcMaster1.toString());
//
//                                     await fetchUserDetails(
//                                         loginDetails[0].AccessToken.toString(),
//                                         apiEndPoints.fetchUserDetailsAPI,
//                                         usernameController.text);
//
//                                     final ofcMaster2 =
//                                         await OFCMASTERDATA().select().toList();
//                                     print(ofcMaster2.length.toString());
//                                     if (ofcMaster2.length > 0) {
//                                       for (int i = 0;
//                                           i < ofcMaster2.length;
//                                           i++) {
//                                         print(ofcMaster2[i].toString());
//                                       }
//                                     }
//
//                                     bool netresult =
//                                         await InternetConnectionChecker()
//                                             .hasConnection;
//                                     if (netresult) {
//                                       //await dataSync.download();
//                                     } else {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         content: Text(
//                                             "Internet connection is not available..!"),
//                                       ));
//                                     }
//
//                                     // loginDetails=await USERLOGINDETAILS().select().toList();
//
//                                     int validtimer = DateTime.parse(
//                                             loginDetails[0].Validity!)
//                                         .difference(DateTime.now())
//                                         .inSeconds;
//                                     print("Timer validity: $validtimer");
//                                     every3seconds = Stream<int>.periodic(
//                                         Duration(seconds: validtimer),
//                                         (t) => t).listen((t) {
//                                       showDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (BuildContext dialogContext) {
//                                           return WillPopScope(
//                                             onWillPop: () async => false,
//                                             child: MyAlertDialog(
//                                               title: 'Title $t',
//                                               content: 'Dialog content',
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     });
//
//                                     // Navigator.push(
//                                     //   context,
//                                     //   MaterialPageRoute(
//                                     //       builder: (context) => MainHomeScreen(
//                                     //           MailsMainScreen(), 0)),
//                                     // );
//
//                                     Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     MainHomeScreen(
//                                                         UtilitiesMainScreen(),
//                                                         0)),
//                                           );
//                                   } else {
//                                     print(
//                                         "User ID -" + usernameController.text);
//                                     print(
//                                         "Password -" + passwordController.text);
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(SnackBar(
//                                       content:
//                                           Text("Invalid User ID or Password"),
//                                     ));
//                                   }
//                                 }
//
//                                 //when token is valid
//                                 else {
//                                   // await USERDETAILS().select().delete();
//                                   // final sql =
//                                   //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
//                                   // final result = await UserDB().execSQL(sql);
//                                   // print(result);
//                                   //
//                                   // //Inserting Master Data as API is pending
//                                   // await OFCMASTERDATA().select().delete();
//                                   // final sql1 =
//                                   //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','123456','570010')";
//                                   // final result1 = await UserDB().execSQL(sql1);
//                                   // print(result);
//                                   //
//                                   // print('Office Master Data');
//                                   // final ofcMaster =
//                                   // await OFCMASTERDATA().select().toList();
//                                   // print(ofcMaster[0].EMOCODE);
//
//                                   //Checking Internet Connectivity before calling API.
//                                   bool netresult = false;
//                                   netresult = await InternetConnectionChecker()
//                                       .hasConnection;
//                                   if (netresult) {
//                                     print(
//                                         "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
//                                     final loginDetails =
//                                         await USERLOGINDETAILS()
//                                             .select()
//                                             .toList();
//
//                                     final ofcMaster1 = await OFCMASTERDATA()
//                                         .select()
//                                         .toCount();
//                                     print(ofcMaster1.toString());
//                                     if (ofcMaster1 == 0) {
//                                       await fetchUserDetails(
//                                           loginDetails[0]
//                                               .AccessToken
//                                               .toString(),
//                                           apiEndPoints.fetchUserDetailsAPI,
//                                           usernameController.text);
//                                     }
//                                     final ofcMaster2 =
//                                         await OFCMASTERDATA().select().toList();
//                                     print(ofcMaster2.length.toString());
//                                     if (ofcMaster2.length > 0) {
//                                       for (int i = 0;
//                                           i < ofcMaster2.length;
//                                           i++) {
//                                         print(ofcMaster2[i].toString());
//                                       }
//                                     }
//
//                                     //await dataSync.download();
//                                   } else {
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(SnackBar(
//                                       content: Text(
//                                           "Internet connection is not available..!"),
//                                     ));
//                                   }
//                                   // loginDetails=await USERLOGINDETAILS().select().toList();
//
//                                   int validtimer =
//                                       DateTime.parse(loginDetails[0].Validity!)
//                                           .difference(DateTime.now())
//                                           .inSeconds;
//                                   print("Timer validity: $validtimer");
//                                   every3seconds = Stream<int>.periodic(
//                                       Duration(seconds: validtimer),
//                                       (t) => t).listen((t) {
//                                     showDialog(
//                                       barrierDismissible: false,
//                                       context: context,
//                                       builder: (BuildContext dialogContext) {
//                                         return WillPopScope(
//                                           onWillPop: () async => false,
//                                           child: MyAlertDialog(
//                                             title: 'Title $t',
//                                             content: 'Dialog content',
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   });
//
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => MainHomeScreen(
//                                             MailsMainScreen(), 0)),
//                                   );
//                                 }
//                               }
//                             }
//                             //when user details not available in the local db.
//                             else {
//                               bool value = false;
//                               bool netresult = await InternetConnectionChecker()
//                                   .hasConnection;
//                               if (netresult) {
//                                 value = await LoginAPI(
//                                     loginuri,
//                                     usernameController.text,
//                                     passwordController.text);
//                                 // //await dataSync.download();
//                               } else {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text(
//                                       "Internet connection is not available..!"),
//                                 ));
//                               }
//
//                               if (value) {
//                                 //commented by Rohit for testing, later has to be uncommented
//                                 /*
//                                 loginDetails[0].EMPID = usernameController.text;
//                                 loginDetails[0].Password =
//                                     passwordController.text;
//                                 loginDetails[0].AccessToken = "";
//                                 loginDetails[0].RefreshToken = "";
//                                 loginDetails[0].Validity = "";
//
//                                 final accessSave = await USERLOGINDETAILS()
//                                     .upsertAll(loginDetails);
//                                 if (accessSave.success)
//                                   print("Access details stored into local db.");
//                                 else
//                                   print(accessSave.errorMessage);
//
//                                  */
//
//                                 //commented below hardcoded code and added API call to fetch master data by Rohit
//                                 // await USERDETAILS().select().delete();
//                                 // final sql =
//                                 //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
//                                 // final result = await UserDB().execSQL(sql);
//                                 // print(result);
//                                 //
//                                 // //Inserting Master Data as API is pending
//                                 // await OFCMASTERDATA().select().delete();
//                                 // final sql1 =
//                                 //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','123456','570010')";
//                                 // final result1 = await UserDB().execSQL(sql1);
//                                 // print(result);
//                                 // print('Office Master Data');
//                                 // final ofcMaster =
//                                 // await OFCMASTERDATA().select().toList();
//                                 // print(ofcMaster[0].EMOCODE);
//
//                                 print(
//                                     "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
//                                 final loginDetails =
//                                     await USERLOGINDETAILS().select().toList();
//
//                                 final ofcMaster1 =
//                                     await OFCMASTERDATA().select().toCount();
//                                 print(ofcMaster1.toString());
//
//                                 await fetchUserDetails(
//                                     loginDetails[0].AccessToken.toString(),
//                                     apiEndPoints.fetchUserDetailsAPI,
//                                     usernameController.text);
//
//                                 final ofcMaster2 =
//                                     await OFCMASTERDATA().select().toList();
//                                 print(ofcMaster2.length.toString());
//                                 if (ofcMaster2.length > 0) {
//                                   for (int i = 0; i < ofcMaster2.length; i++) {
//                                     print(ofcMaster2[i].toString());
//                                   }
//                                 }
//
//                                 //Checking Internet Connectivity before calling API.
//                                 bool netresult =
//                                     await InternetConnectionChecker()
//                                         .hasConnection;
//                                 if (netresult) {
//                                   //await dataSync.download();
//                                 } else {
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(SnackBar(
//                                     content: Text(
//                                         "Internet connection is not available..!"),
//                                   ));
//                                 }
//                                 // loginDetails=await USERLOGINDETAILS().select().toList();
//
//                                 int validtimer =
//                                     DateTime.parse(loginDetails[0].Validity!)
//                                         .difference(DateTime.now())
//                                         .inSeconds;
//                                 print("Timer validity: $validtimer");
//                                 every3seconds = Stream<int>.periodic(
//                                         Duration(seconds: validtimer), (t) => t)
//                                     .listen((t) {
//                                   showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (BuildContext dialogContext) {
//                                       return WillPopScope(
//                                         onWillPop: () async => false,
//                                         child: MyAlertDialog(
//                                           title: 'Title $t',
//                                           content: 'Dialog content',
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 });
//
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           MainHomeScreen(MailsMainScreen(), 0)),
//                                 );
//                               } else {
//                                 print("User ID -" + usernameController.text);
//                                 print("Password -" + passwordController.text);
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text("Invalid User ID or Password"),
//                                 ));
//                               }
//                             }
//                           }),
//                     ),
//
//                     TextButton(
//                         onPressed: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (_) => const RegistrationScreen())),
//                         child: RichText(
//                           text: const TextSpan(
//                               text: "I'm a new user,",
//                               style: TextStyle(color: Colors.amberAccent),
//                               children: [
//                                 TextSpan(
//                                     text: "Sign Up",
//                                     style: TextStyle(
//                                       color: Colors.amberAccent,
//                                       fontWeight: FontWeight.bold,
//                                     ))
//                               ]),
//                         )),
//
//                     // Align(
//                     //   alignment: Alignment.centerRight,
//                     //   child: TextButton(
//                     //     onPressed: () async {
//                     //       setState(() {
//                     //         visiblty=true;
//                     //       });
//                     //       await USERDETAILS().select().delete();
//                     //       final sql="insert or replace into USERDETAILS (EMPID,BOFacilityID) values('50001657','BO21309110004')";
//                     //       final result = await UserDB().execSQL(sql);
//                     //       print(result);
//                     //
//                     //       //await dataSync.download();
//                     //
//                     //       Navigator.pushAndRemoveUntil(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //               builder: (context) =>
//                     //                   MainHomeScreen(MailsMainScreen(), 0)),
//                     //           (route) => false);
//                     //     },
//                     //     child: Text(
//                     //       'Skip Login',
//                     //       style: TextStyle(
//                     //           color: Colors.amberAccent, fontSize: 15),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//         visiblty == true
//             ? Center(
//                 child: Loader(
//                     isCustom: true, loadingTxt: 'Please Wait...Loading...'))
//             : const SizedBox.shrink()
//       ],
//     );
//   }
//
//   Future<bool> LoginAPI(
//       String loginuri, String username, String password) async {
//     bool rtValue = false;
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse(loginuri));
//     request.body =
//         json.encode({"username": "$username", "password": "$password"});
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       String responseContent = await response.stream.bytesToString();
//       print("Login response*******************************");
//       print(responseContent);
//       var validityTimer = jsonDecode(responseContent)['expires_in'];
//       print(jsonDecode(responseContent)['expires_in']);
//       print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
//       print(responseContent);
//       access_token = jsonDecode(responseContent)["access_token"];
//       refresh_token = jsonDecode(responseContent)["refresh_token"];
//
//       //Storing Access token in local DB.
//       if (access_token.isNotEmpty || access_token != null) {
//         await USERLOGINDETAILS().select().delete();
//
//         final logindetails = USERLOGINDETAILS()
//           ..EMPID = username
//           ..AccessToken = access_token
//           // ..Validity =
//           //     DateTime.now().add(Duration(seconds: validityTimer)).toString
//           ..Active = true
//           ..Validity =
//               DateTime.now().add(Duration(seconds: validityTimer)).toString()
//           // ..DeviceID="891904928556"
//           ..Password = password;
//         logindetails.save();
//       }
//       /*
//       String validityTime = jsonDecode(responseContent)["expires_in"].toString();
//       DateTime now = DateTime.now();
//       validity = DateFormat('yyyy-MM-dd – kk:mm').format(now) + validity;
//
//        */
//       String error = " ";
//       try {
//         error = jsonDecode(responseContent)["error"];
//       } catch (e) {
//         print("Error DKSjf");
//         print(e);
//       }
//
//       print("Response is - " + responseContent);
//       print(access_token);
//       print(error);
//
//       if (error == "invalid_grant")
//         rtValue = false;
//       else if (access_token.isNotEmpty) rtValue = true;
//     } else {
//       print(response.reasonPhrase);
//       rtValue = false;
//     }
//
//     return rtValue;
//   }
//
//   bool JwtCheck(List<USERLOGINDETAILS> loginDetails) {
//     print('JWT Checking..!');
//     bool rtValue = false;
//     String accessToken = loginDetails[0].AccessToken.toString();
//     // print(accessToken.isNotEmpty.toString());
//
//     if (accessToken != "null") {
//       bool hasExpired = JwtDecoder.isExpired(accessToken);
//
//       if (!hasExpired) {
//         rtValue = true;
//       } else
//         rtValue = false;
//     }
//     print(accessToken);
//     print(rtValue.toString());
//     return rtValue;
//   }
//
//   fetchUserDetails(String token, String uri, String empid) async {
//     print('inside Fetch User Details');
//     String requestURI = uri + empid;
//     print(token);
//     print(requestURI);
//     var headers = {'Authorization': 'Bearer $token'};
//     var request = http.Request('GET', Uri.parse(requestURI));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final res = await response.stream.bytesToString();
//       print(res);
//       print('====================================');
//
//       List<dynamic> list = json.decode(res);
//       print(list[0]['bo_id'].toString());
//       print(json.decode(res)[0]['bpm_name']);
//
//       print(res.toString());
//
//       // when Office rolled out for 1st time the OfcMaster Count will be 0
//       int ofccount = await OFCMASTERDATA().select().toCount();
//
//       // when data is available delete existing data
//
//       // await OFCMASTERDATA().select().delete();
//
//       // await USERDETAILS().select().EMPID.equals(empid).update({'BOFacilityID':'${list[0]['bo_id']}'});
//       await USERDETAILS(EMPID: empid, BOFacilityID: list[0]['bo_id']).upsert();
//
//       print('Ofc Count is ---- ');
//       print(ofccount);
//       if (ofccount == 0) {
//         final ofcMaster = OFCMASTERDATA()
//           ..EMPID = empid
//           ..MobileNumber = list[0]['phone']
//           ..EmployeeEmail = list[0]['email']
//           ..EmployeeName = list[0]['bpm_name']
//           ..DOB = list[0]['dob']
//           ..BOFacilityID = list[0]['bo_id']
//           ..BOName = list[0]['bo_name']
//           ..Pincode = list[0]['pincode']
//           ..AOName = list[0]['so_name']
//           ..AOCode = list[0]['so_id']
//           ..DOName = list[0]['do_name']
//           ..DOCode = list[0]['do_id'];
//
//         ofcMaster.save();
//
//         //fetching BO Balance
//
//         await fetchBOBalanceDetails(token, apiEndPoints.fetchBOBALAPI,
//             list[0]['bo_id'].toString(), empid);
//
//         // //fetching Stamp Balance
//         // await fetchStampBalanceDetails(token, apiEndPoints.fetchStampBalanceAPI,
//         //     list[0]['bo_id'].toString());
//       } else {
//         print('BO is already rolled out..!');
//       }
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   fetchBOBalanceDetails(
//       String token, String uri, String boid, String empid) async {
//     print('inside BO Balance Details..!');
//     String requestURI = uri + boid;
//     var headers = {'Authorization': 'Bearer $token'};
//     var request = http.Request('GET', Uri.parse(requestURI));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     print('response from BO Balance API' + response.statusCode.toString());
//
//     if (response.statusCode == 200) {
//       String res = await response.stream.bytesToString();
//       print(res);
//
//       //
//       // final bobal = OFCMASTERDATA().select().EMPID.equals(empid).
//       // update({'OB':'${json.decode(res)[0]['bo_opening_balance']}',
//       //   'CASHINHAND':'bo_cashinhand','MINBAL':'bo_authorisedminbal',
//       //   'MAXBAL':'bo_authorisedmaxbal','POSTAMPBAL':'bo_authorisedstampbal',
//       //   'REVSTAMPBAL':'bo_authorisedrevenuebal','CRFSTAMPBAL':'bo_authorisedcrfbal',
//       //   'MAILSCHEDULE':'bo_mail_sheduled','EMOCODE':'${json.decode(res)[0]['emocode']}'
//       //   ,'PAIDLEAVE':'emp_paid_leave',
//       //   'MATERNITYLEAVE':'emp_meternity_leave','EMGLEAVE':'emp_el_leave'});
//
//       final bobal = await OFCMASTERDATA().select().EMPID.equals(empid).update({
//         'OB': '${json.decode(res)[0]['bo_opening_balance']}',
//         'CASHINHAND': '${json.decode(res)[0]['bo_cashinhand']}',
//         'MINBAL': '${json.decode(res)[0]['bo_authorisedminbal']}',
//         'MAXBAL': '${json.decode(res)[0]['bo_authorisedmaxbal']}',
//         'POSTAMPBAL': '${json.decode(res)[0]['bo_authorisedstampbal']}',
//         'REVSTAMPBAL': '${json.decode(res)[0]['bo_authorisedrevenuebal']}',
//         'CRFSTAMPBAL': '${json.decode(res)[0]['bo_authorisedcrfbal']}',
//         'MAILSCHEDULE': '${json.decode(res)[0]['bo_mail_sheduled']}',
//         'EMOCODE': '${json.decode(res)[0]['emocode']}',
//         'PAIDLEAVE': '${json.decode(res)[0]['emp_paid_leave']}',
//         'MATERNITYLEAVE': '${json.decode(res)[0]['emp_meternity_leave']}',
//         'EMGLEAVE': '${json.decode(res)[0]['emp_el_leave']}'
//       });
//
//       final bobalance = await OFCMASTERDATA().select().toList();
//       //
//       // print('inserting BO Details from API..!');
//       // //Only when BO Rolled out
//       // if (bobalance.length == 0) {
//       //   print('when BO details are empty');
//       final addCash =  CashTable()
//         ..Cash_ID = DateTimeDetails().dateCharacter() +
//             DateTimeDetails().timeCharacter()
//         ..Cash_Date = DateTimeDetails().currentDate()
//         ..Cash_Time = DateTimeDetails().onlyTime()
//         ..Cash_Type = 'Add'
//         ..Cash_Amount = double.parse(bobalance[0].CASHINHAND!)
//         ..Cash_Description = 'Opening Balance';
//       await addCash.save();
//       // }
//
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
//
//   fetchStampBalanceDetails(String token, String uri, String boid) async {
//     print('inside Stamp Balance API');
//     String requestURI = uri + boid;
//     var headers = {'Authorization': 'Bearer $token'};
//     var request = http.Request('GET', Uri.parse(requestURI));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       String res = await response.stream.bytesToString();
//       print(res);
//
//       List<dynamic> expansionInventoryName = json.decode(res);
//
//       final stampTable = await BagStampsTable().select().toList();
//       final productTable = await ProductsTable().select().toList();
//
//       //when there is no data available then only inventory will be added
//       //code by Rohit on 03-08-2022
//       if (stampTable.length == 0 && productTable.length == 0) {
//         if (expansionInventoryName.isNotEmpty) {
//           for (int i = 0; i < expansionInventoryName.length; i++) {
//             await BaggingDBService().addInventoryFromBagToDB(
//                 expansionInventoryName[i]['stamp_name'],
//                 expansionInventoryName[i]['denomination'].toString(),
//                 expansionInventoryName[i]['quantity'].toString(),
//                 expansionInventoryName[i]['total_amount'].toString(),
//                 expansionInventoryName[i]['boid'],
//                 'Received');
//
//             await BaggingDBService().addProductsMain(
//                 expansionInventoryName[i]['stamp_name'],
//                 expansionInventoryName[i]['denomination'],
//                 expansionInventoryName[i]['quantity']);
//           }
//         }
//       }
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
// }
// _LoginScreenState ls=new _LoginScreenState();