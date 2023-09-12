import 'dart:convert';
import 'dart:io';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:darpan_mine/Delivery/Screens/shared_preference_service.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'LoginScreen_old.dart';
import 'db/registrationdb.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final facilityIDController = TextEditingController();
  final pincodeController = TextEditingController();
  final employeeNameController = TextEditingController();
  final employeeIdController = TextEditingController();
  final mobileController = TextEditingController();
  final emailidController = TextEditingController();
  final otpReceivedController = TextEditingController();
  final digitalOTPController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  APIEndPoints apiEndPoints = new APIEndPoints();

  late final registrationuri = apiEndPoints.registration;
  late final smsapiuri = apiEndPoints.smsAPI;
  late final otpverifyuri = apiEndPoints.otpVerificationAPI;

  final textEditingController1 = TextEditingController();
  String _comingSms = 'Unknown';

  String _current = '';
  late List<String> platformImei;
  List<String> wantedId = [];
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool display = true;
  bool cpi = false;

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms!;
      print("====>Message: ${_comingSms}");
      print("${_comingSms[16]}");

      final split = _comingSms.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      print(values); // {0: grubs, 1:  sheep}

      final firstContent = values[0];
      final secondContent = values[1];
      final thirdContent = values[2];
      // int? l1 = firstContent?.length;
      // int? l2 = secondContent?.length;
      print("...............");

      print(secondContent);
      final otp = secondContent?.substring(
          secondContent.length - 6, secondContent.length);
      print("otp is - " + otp.toString());
      final smsSign =
          thirdContent?.substring(thirdContent.length - 7, thirdContent.length);
      print("SMS Signature is -" + smsSign.toString());
      if (smsSign.toString() == "INDPOST")
        textEditingController1.text = otp!; // added to read only INDPOST SMS
    });
  }

  @override
  void initState() {
    super.initState();
    facilityIDController.clear();
    pincodeController.clear();
    employeeNameController.clear();
    employeeIdController.clear();
    mobileController.clear();
    emailidController.clear();
    otpReceivedController.clear();
    digitalOTPController.clear();
    passwordController.clear();
    confirmpasswordController.clear();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  //Check for type of device
  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = Map<String, dynamic>();

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        /*platformImei =
        await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);*/
        platformImei = (await ImeiPlugin.getImeiMulti(
            shouldShowRequestPermissionRationale: false))!;
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
      if (_deviceData["version.sdkInt"] > 28) {
        wantedId.add(_deviceData["androidId"]);
        _current = _deviceData["androidId"];
      } else {
        /*wantedId.add(platformImei);
        _current=platformImei;*/
        wantedId = platformImei;
        _current = platformImei[0];
      }
    });
    SharedPreferenceService().setDevID(_current);
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      // fetchdetails(_current);
      print('API call to fetch based on IMEI number. not required now.');
    }
  }

  //Android Info
  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    print(build.androidId); // Android device Id

    return <String, dynamic>{
      'version.release': build.version.release,
      'androidId': build.androidId,
      'version.sdkInt': build.version.sdkInt,
    };
  }

  //IOS Info
  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/background_screen_red.jpeg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.lighten),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 60.0, left: 18, bottom: 8, right: 5),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/ic_arrows.png',
                            width: 100,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              // Text('Department of Posts', style: TextStyle(color: Colors.white, fontSize: 20.sp),),
                              // const Text('Ministry of Communications', style: TextStyle(color: Colors.white),),
                              // const Text('Government of India', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                              // SizedBox(height: 10,),
                              Text(
                                'User Registration',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 23),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // SizedBox(height: 20,),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          onChanged: (text) {
                            if (text.length > 7) ValidateUser(text);
                          },

                          controller: employeeIdController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Employee ID or Username';
                            }
                            return null;
                          },

                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.number,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Employee ID / Username",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.yellowAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.yellowAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: employeeNameController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.text,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Employee Name",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: facilityIDController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.text,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "BO Facility ID",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: mobileController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.number,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Mobile Number",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: emailidController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.emailAddress,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "EMAIL ID",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: pincodeController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.number,
                          // maxLength: 6,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Pincode",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.visiblePassword,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Prefered Password",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: confirmpasswordController,
                          style: TextStyle(color: Colors.amberAccent),
                          keyboardType: TextInputType.visiblePassword,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, left: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              print("Inside GET OTP Button");
                              int value = await userInductionAndOTP(
                                  registrationuri,
                                  smsapiuri,
                                  employeeIdController.text,
                                  "9999999999",
                                  "9999999999",
                                  //IMEI and Device ID are hardcoded  testing
                                  mobileController.text,
                                  emailidController.text,
                                  employeeNameController.text,
                                  pincodeController.text,
                                  facilityIDController.text,
                                  passwordController.text,
                                  passwordController.text);
                              switch (value) {
                                case 1: //Get SMS
                                  initSmsListener();
                                  break;
                                case 2: //OTP Not Verified
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('User Registration'),
                                      content:
                                          const Text('User OTP not verified.'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              sendSMS(
                                                  smsapiuri,
                                                  mobileController.text,
                                                  _current);
                                              initSmsListener();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK')),
                                      ],
                                    ),
                                  );
                                  break;

                                case 3: //User exists redirect to Login screen
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('User Registration'),
                                      content: const Text(
                                          'User Already Registered..!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const LoginScreen())),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );

                                  break;
                              }
                            },
                            child: Text('GET OTP',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(10),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    inactiveFillColor: Colors.white,
                                    inactiveColor: Colors.blueGrey,
                                    selectedColor: Colors.blueGrey,
                                    selectedFillColor: Colors.white,
                                    activeFillColor: Colors.white,
                                    activeColor: Colors.blueGrey),
                                cursorColor: Colors.black,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: textEditingController1,
                                keyboardType: TextInputType.text,
                                boxShadows: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  //do something or move to next screen when code complete
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    print('$value');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, right: 10, left: 55),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Button(
                              buttonText: 'REGISTER',
                              buttonFunction: () async {
                                if (passwordController.text !=
                                    confirmpasswordController.text) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Password doesn't match!"),
                                  ));
                                }
                                print("Going to verify OTP - " +
                                    textEditingController1.text +
                                    " for Mobile No. -" +
                                    mobileController.text);
                                bool functionRt = await otpVerification(
                                    textEditingController1.text,
                                    mobileController.text,
                                    otpverifyuri,
                                    employeeIdController.text);
                                if (functionRt) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("User Registration Completed..!"),
                                  ));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const LoginScreen()));
                                }
                              }),
                          Button(
                              buttonText: 'CLEAR',
                              buttonFunction: () {
                                facilityIDController.clear();
                                pincodeController.clear();
                                employeeNameController.clear();
                                employeeIdController.clear();
                                mobileController.clear();
                                emailidController.clear();
                                otpReceivedController.clear();
                                digitalOTPController.clear();
                                passwordController.clear();
                                confirmpasswordController.clear();
                              }),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

Future<bool> otpVerification(
    String otp, String mobile, String uri, String empid) async {
  bool rtValue = false;

  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse(uri));
  request.body = json.encode({
    "clientid": "f99d85be-f198-48f0-96be-dce2722c6179",
    "apptoken": "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
    "mobilenumber": "$mobile",
    "otp": "$otp"
  });

  print('body in otp verification');
  print(request.body);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    rtValue = true;
    print('OTP Verification Successful, details will be updated in local DB');
    final sql = "UPDATE product set isActive=1 where isActive=1";
    final result = await USERVALIDATION()
        .select()
        .EMPID
        .contains(empid)
        .update({"OTPVerified": "1"});

    // final updateUserLogin = await USERDETAILS().
    print(result);
  } else {
    print(response.reasonPhrase);
    rtValue = false;
  }
  return rtValue;
}

//function to Register User and Generate an OTP
/* rtValue
0 = Failed
1 = Success
2 = OTP not verified
3 = User exist with OTP Verified. redirect to Login Screen
 */
Future<int> userInductionAndOTP(
    String reguri,
    String smsuri,
    String empid,
    String imei,
    String deviceid,
    String mobile,
    String email,
    String name,
    String pincode,
    String fid,
    String prefpwd,
    String conpwd) async {
  int rtValue = 0;

  //first check in local DB if user Details not available then hit APIs for registration.
  var userid = await USERVALIDATION().getById(empid);
  print("User ID in local DB -" + userid.toString());
  if (userid == null) {
    print('User is not available in Local DB..!');

    final userValidation = await USERVALIDATION(
            EMPID: empid,
            MobileNumber: mobile,
            IMEINumber: imei,
            DeviceID: deviceid,
            EmployeeEmail: empid,
            EmployeeName: name,
            Password: prefpwd,
            Pincode: pincode,
            OTPVerified: '0',
            Active: false)
        .save();

    if (userValidation.success)
      print('Inserted into User Validation Table..!');
    else
      print(userValidation.errorMessage);

    final userLoginDetails = await USERLOGINDETAILS(
            EMPID: empid,
            MobileNumber: mobile,
            IMEINumber: deviceid,
            DeviceID: deviceid,
            EmployeeEmail: email,
            EmployeeName: name,
            Password: prefpwd,
            AccessToken: null,
            RefreshToken: null,
            Validity: null,
            DOVerified: null,
            Active: true,
            ClientID: "f99d85be-f198-48f0-96be-dce2722c6179",
            AppToken: "57aed7f6-8765-467e-bf7b-d52b4743d3c8")
        .save();

    if (userLoginDetails.success)
      print('Inserted into USERLOGINDETAILS Table..!');
    else
      print(userLoginDetails.errorMessage);

    final userDetails = await USERDETAILS(
            EMPID: empid,
            MobileNumber: mobile,
            IMEINumber: deviceid,
            DeviceID: deviceid,
            EmployeeEmail: email,
            EmployeeName: name,
            DOB: "",
            BOFacilityID: fid,
            BOName: "",
            Pincode: pincode,
            DOName: "",
            DOCode: "",
            ClientID: "f99d85be-f198-48f0-96be-dce2722c6179",
            AppToken: "57aed7f6-8765-467e-bf7b-d52b4743d3c8")
        .save();

    if (userDetails.success)
      print('Inserted into USERDETAILS Table..!');
    else
      print(userDetails.errorMessage);

    print("going to call APIs >>>");

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(reguri));
    request.body = json.encode({
      "mobileno": "$mobile",
      "imei": "$imei",
      "clientid": "f99d85be-f198-48f0-96be-dce2722c6179",
      "apptoken": "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
      "empid": "$empid",
      "name": "$name",
      "pincode": "$pincode",
      "bofacilityid": "$fid",
      "deviceid": "$deviceid",
      "preferredpassword": "$prefpwd",
      "confirmpassword": "$conpwd"
    });
    request.headers.addAll(headers);
    print("Body -" + request.body);
    http.StreamedResponse response = await request.send();
    print("=======status code=======");
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      sendSMS(smsuri, mobile, deviceid);
      rtValue = 1;
    } else {
      print(response.reasonPhrase);
      rtValue = 0;
    }
  } else {
    print('User details for -' +
        userid.EMPID.toString() +
        ' is available in local DB..!');
    if (userid.OTPVerified.toString() == "0") {
      print('XXX OTP is not verified XXX');
      //sendSMS(smsuri, mobile, deviceid);
      rtValue = 2;
    } else {
      print('User Details available with OTP Verified..!'
          'Redirecting to Login Screen.');
      rtValue = 3;
    }
  }
  return rtValue;
}

Future<bool> sendSMS(String smsuri, String mobile, String deviceid) async {
  bool rtValue = false;
  print("inside SMS API Function..!");
  var headers = {'Content-Type': 'application/json'};
  var request = http.Request('POST', Uri.parse(smsuri));
  request.body = json.encode({
    "clientid": "f99d85be-f198-48f0-96be-dce2722c6179",
    "apptoken": "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
    "mobilenumber": "$mobile",
    "deviceid": "$deviceid"
  });
  request.headers.addAll(headers);
  print('SMS API Request Body - ' + request.body);
  http.StreamedResponse response = await request.send();

  print("=======status code=======");
  print(response.statusCode);
  print(await response.stream.bytesToString());

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    rtValue = true;
  } else {
    print(response.reasonPhrase);
    rtValue = false;
  }
  return rtValue;
}

void ValidateUser(String text) {
  var userid = USERVALIDATION().getById(text);
  print(userid);
}
