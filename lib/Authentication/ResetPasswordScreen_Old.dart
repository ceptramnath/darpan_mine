// import 'dart:convert';
//
// import 'package:alt_sms_autofill/alt_sms_autofill.dart';
// import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
// import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:http/http.dart' as http;
// import 'APIEndPoints.dart';
// import 'LoginScreen.dart';
// import 'db/registrationdb.dart';
//
// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
// }
//
// class _ResetPasswordScreen extends State<ResetPasswordScreen> {
//   final facilityIDController = TextEditingController();
//   final pincodeController = TextEditingController();
//   final employeeNameController = TextEditingController();
//   final employeeIdController = TextEditingController();
//   final mobileController = TextEditingController();
//   final emailidController = TextEditingController();
//   final otpReceivedController = TextEditingController();
//   final digitalOTPController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmpasswordController = TextEditingController();
//   APIEndPoints apiEndPoints = new APIEndPoints();
//   late final otpsmsAPI = apiEndPoints.smsRequestAPI;
//   late final otpVerificaitonAPI = apiEndPoints.otpVerifyAPI;
//   late final getCredentialAPI = apiEndPoints.getCredAPI;
//   late final resetPasswordAPI = apiEndPoints.resetpassword;
//   late final loginAPI = apiEndPoints.tokenAPI;
//   bool visiblty = false;
//
//   String _comingSms = 'Unknown';
//   bool resetVisible = false;
//   String userid = '';
//   String password = '';
//   String access_token = "";
//   bool _obscureText1 = true;
//   bool _obscureText2 = true;
//
//   void _toggle1() {
//     setState(() {
//       _obscureText1 = !_obscureText1;
//     });
//   }
//
//   void _toggle2() {
//     setState(() {
//       _obscureText2 = !_obscureText2;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     facilityIDController.clear();
//     pincodeController.clear();
//     employeeNameController.clear();
//     employeeIdController.clear();
//     mobileController.clear();
//     emailidController.clear();
//     otpReceivedController.clear();
//     digitalOTPController.clear();
//     passwordController.clear();
//     confirmpasswordController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Image.asset("assets/images/background_screen_red.jpeg",
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//             colorBlendMode: BlendMode.lighten),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       top: 60.0, left: 18, bottom: 8, right: 5),
//                   child: Row(
//                     children: [
//                       Column(
//                         children: [
//                           Image.asset(
//                             'assets/images/ic_arrows.png',
//                             width: 100.w,
//                           ),
//                         ],
//                       ),
//                       Column(
//                         children: [
//                           Column(
//                             children: [
//                               // Text('Department of Posts', style: TextStyle(color: Colors.white, fontSize: 20.sp),),
//                               // const Text('Ministry of Communications', style: TextStyle(color: Colors.white),),
//                               // const Text('Government of India', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
//                               // SizedBox(height: 10,),
//                               Text(
//                                 'Password Reset',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 23.sp),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 80.h,
//                 ),
//                 Column(
//                   children: [
//                     //User ID TextBox
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * .75.w,
//                         child: TextFormField(
//                           controller: employeeIdController,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter Employee ID or Username';
//                             }
//                             return null;
//                           },
//
//                           style: TextStyle(color: Colors.amberAccent),
//                           keyboardType: TextInputType.number,
//                           // maxLength: 10,
//                           // maxLengthEnforced: true,
//                           // readOnly: true,
//                           decoration: InputDecoration(
//                             labelText: "Employee ID / Username",
//                             hintStyle: TextStyle(
//                               fontSize: 15,
//                               color: Colors.yellowAccent,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             border: InputBorder.none,
//                             enabledBorder: OutlineInputBorder(
//                                 borderSide:
//                                     BorderSide(color: Colors.white, width: 3)),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color: Colors.yellowAccent, width: 3)),
//                             contentPadding: EdgeInsets.only(
//                                 top: 20, bottom: 20, left: 20, right: 20),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     //Get OTP Button
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(top: 12.0, left: 10, right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FlatButton(
//                             onPressed: () async {
//                               bool netresult = await InternetConnectionChecker()
//                                   .hasConnection;
//                               if (netresult) {
//                                 print("Inside GET OTP Button");
//                                 bool functionRt = await sendSMS(
//                                     employeeIdController.text, "");
//                                 if (functionRt == true) {
//                                   initSmsListener(); //once OTP sent enable listener
//                                 } else {
//                                   UtilFs.showToast(
//                                       "User credential is wrong..!", context);
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text(
//                                       "Internet connection is not available..!"),
//                                 ));
//                               }
//                             },
//                             child: Text('GET OTP',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20)),
//                             textColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                                 side: BorderSide(
//                                     color: Colors.white,
//                                     width: 1,
//                                     style: BorderStyle.solid),
//                                 borderRadius: BorderRadius.circular(50)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//
//                     //OTP Input Field
//                     Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           PinCodeTextField(
//                             appContext: context,
//                             readOnly: true,
//                             pastedTextStyle: TextStyle(
//                               color: Colors.green.shade600,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             length: 6,
//                             obscureText: false,
//                             animationType: AnimationType.fade,
//                             pinTheme: PinTheme(
//                                 shape: PinCodeFieldShape.box,
//                                 borderRadius: BorderRadius.circular(10),
//                                 fieldHeight: 50,
//                                 fieldWidth: 40,
//                                 inactiveFillColor: Colors.white,
//                                 inactiveColor: Colors.blueGrey,
//                                 selectedColor: Colors.blueGrey,
//                                 selectedFillColor: Colors.white,
//                                 activeFillColor: Colors.white,
//                                 activeColor: Colors.blueGrey),
//                             cursorColor: Colors.black,
//                             animationDuration: Duration(milliseconds: 300),
//                             enableActiveFill: true,
//                             controller: otpReceivedController,
//                             keyboardType: TextInputType.text,
//                             boxShadows: [
//                               BoxShadow(
//                                 offset: Offset(0, 1),
//                                 color: Colors.black12,
//                                 blurRadius: 10,
//                               )
//                             ],
//                             onCompleted: (v) {
//                               //do something or move to next screen when code complete
//                             },
//                             onChanged: (value) {
//                               print(value);
//                               setState(() {
//                                 print('$value');
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     Visibility(
//                         visible: resetVisible,
//                         child: Column(
//                           children: [
//                             //New Password TextBox
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Container(
//                                 width:
//                                     MediaQuery.of(context).size.width * .75.w,
//                                 child: TextFormField(
//                                   obscureText: _obscureText1,
//                                   enableSuggestions: false,
//                                   autocorrect: false,
//                                   controller: passwordController,
//                                   style: TextStyle(color: Colors.amberAccent),
//                                   keyboardType: TextInputType.visiblePassword,
//                                   // maxLength: 10,
//                                   // maxLengthEnforced: true,
//                                   // readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: "New Password",
//                                     hintStyle: TextStyle(
//                                       fontSize: 15,
//                                       color: Color.fromARGB(255, 2, 40, 86),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.white, width: 3)),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.amberAccent,
//                                             width: 3)),
//                                     contentPadding: EdgeInsets.only(
//                                         top: 20,
//                                         bottom: 20,
//                                         left: 20,
//                                         right: 20),
//                                     suffixIcon: IconButton(
//                                       onPressed: _toggle1,
//                                       icon: _obscureText1
//                                           ? Icon(Icons.visibility)
//                                           : Icon(Icons.visibility_off),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             //Confirm Password TextBox
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Container(
//                                 width:
//                                     MediaQuery.of(context).size.width * .75.w,
//                                 child: TextFormField(
//                                   obscureText: _obscureText2,
//                                   enableSuggestions: false,
//                                   autocorrect: false,
//                                   controller: confirmpasswordController,
//                                   style: TextStyle(color: Colors.amberAccent),
//                                   keyboardType: TextInputType.visiblePassword,
//                                   // maxLength: 10,
//                                   // maxLengthEnforced: true,
//                                   // readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: "Confirm Password",
//                                     hintStyle: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.amberAccent,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                     border: InputBorder.none,
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.white, width: 3)),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: Colors.amberAccent,
//                                             width: 3)),
//                                     contentPadding: EdgeInsets.only(
//                                         top: 20,
//                                         bottom: 20,
//                                         left: 20,
//                                         right: 20),
//                                     suffixIcon: IconButton(
//                                       onPressed: _toggle2,
//                                       icon: _obscureText2
//                                           ? Icon(Icons.visibility)
//                                           : Icon(Icons.visibility_off),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             //Confirm Button
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 10,
//                                 right: 10,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Button(
//                                       buttonText: 'CONFIRM',
//                                       buttonFunction: () async {
//                                         if (passwordController.text !=
//                                             confirmpasswordController.text) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content:
//                                                 Text("Password doesn't match!"),
//                                           ));
//                                         } else if (confirmpasswordController
//                                                 .text ==
//                                             apiEndPoints.defaultPassword) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content: Text(
//                                                 "Defualt password can't be used."),
//                                           ));
//                                         } else {
//                                           setState(() {
//                                             visiblty = true;
//                                           });
//
//                                           bool netresult =
//                                               await InternetConnectionChecker()
//                                                   .hasConnection;
//                                           if (netresult) {
//                                             final returnValue =
//                                                 await resetPassword(
//                                                     employeeIdController.text,
//                                                     passwordController.text);
//                                             if (returnValue == true) {
//                                               UtilFs.showToast(
//                                                   "Password Reset Successful..!",
//                                                   context);
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           const LoginScreen()));
//                                             } else {
//                                               UtilFs.showToast(
//                                                   "Password Reset Failed..!",
//                                                   context);
//                                               Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           const LoginScreen()));
//                                             }
//                                           }
//
//                                           else{
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               content: Text(
//                                                   "Internet connection is not available..!"),
//                                             ));
//                                           }
//                                         }
//                                       }),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )),
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
//   Future<bool> sendSMS(String empid, String deviceid) async {
//     bool rtValue = false;
//     print("inside SMS API Function..!");
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse(otpsmsAPI));
//     request.body = json
//         .encode({"event": "Reset", "empid": "$empid", "deviceid": "$deviceid"});
//     request.headers.addAll(headers);
//     print('SMS API Request Body - ' + request.body);
//     http.StreamedResponse response = await request.send();
//
//     print("=======status code=======");
//     print(response.statusCode);
//     // print(await response.stream.bytesToString());
//
//     if (response.statusCode == 200 || response.statusCode == 208) {
//       print(await response.stream.bytesToString());
//       rtValue = true;
//     } else {
//       print(response.reasonPhrase);
//       rtValue = false;
//     }
//     return rtValue;
//   }
//
//   Future<void> initSmsListener() async {
//     String? comingSms;
//     try {
//       comingSms = await AltSmsAutofill().listenForSms;
//     } on PlatformException {
//       comingSms = 'Failed to get Sms.';
//     }
//     if (!mounted) return;
//     setState(() {
//       _comingSms = comingSms!;
//       print("====>Message: ${_comingSms}");
//       print("${_comingSms[16]}");
//
//       final split = _comingSms.split(',');
//       final Map<int, String> values = {
//         for (int i = 0; i < split.length; i++) i: split[i]
//       };
//       print(values); // {0: grubs, 1:  sheep}
//
//       final firstContent = values[0];
//       final secondContent = values[1];
//       // final thirdContent = values[2];
//       // int? l1 = firstContent?.length;
//       // int? l2 = secondContent?.length;
//       print("...............");
//
//       print(secondContent);
//       final otp = secondContent?.substring(1, 7);
//       print("otp is - " + otp.toString());
//       final smsSign = secondContent?.substring(
//           secondContent.length - 7, secondContent.length);
//       print("SMS Signature is -" + smsSign.toString());
//       if (smsSign.toString() == "INDPOST")
//         otpReceivedController.text = otp!; // added to read only INDPOST SMS
//       resetVisible = true;
//     });
//   }
//
//   Future<bool> resetPassword(String empid, String password) async {
//     bool rtValue = false;
//     print("inside Reset API Function..!");
//
//     final credAPI = await getCredentials(empid);
//
//     if (credAPI == true) //when credentials found
//     {
//       var headers = {
//         'Authorization': 'Bearer $access_token',
//         'Cookie': 'JSESSIONID=C6F188E61E3FC99CFBCDBDD9E0C46FFA'
//       };
//       var request = http.Request('GET',
//           Uri.parse('$resetPasswordAPI?userid=$userid&newPassword=$password'));
//       request.headers.addAll(headers);
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//         //Once password reset done in server update in local DB.
//         await USERLOGINDETAILS().select().EMPID.equals(empid).update({'Password':'$password'});
//         rtValue = true;
//       } else {
//         print(response.reasonPhrase);
//         rtValue = false;
//       }
//     } else {
//       print("Credential Not Found..!");
//       rtValue = false;
//     }
//     return rtValue;
//   }
//
//   Future<bool> getCredentials(String empid) async {
//     bool rtValue = false;
//     print("inside Credential API Function..!");
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse(getCredentialAPI));
//     request.body = empid;
//     request.headers.addAll(headers);
//
//     print(request.body);
//     print(request.headers);
//
//     http.StreamedResponse response = await request.send();
//     print("=======status code=======");
//     print(response.statusCode);
//     // print(await response.stream.bytesToString());
//
//     if (response.statusCode == 200) {
//       String responseContent = await response.stream.bytesToString();
//       print("Credential API response*******************************");
//       print(responseContent);
//       userid = jsonDecode(responseContent)["username"];
//       password = jsonDecode(responseContent)["password"];
//       print(userid + ' ' + password);
//       final loginReturn = await LoginAPI(userid, password);
//       if (loginReturn == true) {
//         rtValue = true;
//       } else {
//         rtValue = false;
//       }
//     } else {
//       print(response.reasonPhrase);
//       rtValue = false;
//     }
//     return rtValue;
//   }
//
//   Future<bool> LoginAPI(String username, String password) async {
//     print('Going to call token API');
//     bool rtValue = false;
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse(loginAPI));
//     request.body =
//         json.encode({"username": "$username", "password": "$password"});
//     request.headers.addAll(headers);
//     print(request.body);
//     print(request.headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       String responseContent = await response.stream.bytesToString();
//       print("Login API response*******************************");
//       print(responseContent);
//       access_token = jsonDecode(responseContent)["access_token"];
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
// }
