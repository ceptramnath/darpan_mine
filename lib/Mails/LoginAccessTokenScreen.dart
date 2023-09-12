import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/AlertDigitalOTP.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/Delivery/Screens/shared_preference_service.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:imei_plugin/imei_plugin.dart';

import '../HomeScreen.dart';
import 'MailsMainScreen.dart';

class LoginAccessTokenScreen extends StatefulWidget {
  @override
  _LoginAccessTokenScreenState createState() => _LoginAccessTokenScreenState();
}

class _LoginAccessTokenScreenState extends State<LoginAccessTokenScreen> {
  TextEditingController facilityID = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController empName = TextEditingController();
  TextEditingController empId = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController otpreceived = TextEditingController();
  TextEditingController digitalOTP = TextEditingController();
  String _current = '';
  bool getSMS = false;
  bool otp = false;
  bool verifysms = false;
  bool digitalOtp = false;
  String _code = "";
  String digitOTP = "";
  late List<String> platformImei;
  List<String> wantedId = [];
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  List tokens = [];

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
        (route) => false);
  }

  @override
  void initState() {
    initPlatformState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          elevation: 0,
          backgroundColor: ColorConstants.kPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => MainHomeScreen(MailsMainScreen(), 1)),
                (route) => false),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: ColorConstants.kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFCFB53B),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DropdownButton<String?>(
                              iconEnabledColor: Colors.white,
                              dropdownColor: Colors.grey,
                              underline: Container(),
                              items: wantedId.map((String dropdownStringItem) {
                                return DropdownMenuItem<String>(
                                  value: dropdownStringItem,
                                  child: Text(dropdownStringItem,
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1)),
                                );
                              }).toList(),
                              onChanged: (String? newValueSelected) async {
                                setState(() {
                                  this._current = newValueSelected!;
                                  print(_current);
                                });
                              },
                              value: _current.toString(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 18.0),
                        child: Text(
                          'Supports IMEI on Android 9.0 (Pie) & Below',
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: empName,
                          style: TextStyle(color: Colors.blueGrey),
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter Employee Name",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: empId,
                          style: TextStyle(color: Colors.blueGrey),
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter Employee ID",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: facilityID,
                          style: TextStyle(color: Colors.blueGrey),
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter BO Facility ID",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: mobile,
                          style: TextStyle(color: Colors.blueGrey),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter Mobile Number",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: TextFormField(
                          controller: pincode,
                          maxLength: 6,
                          maxLengthEnforced: true,
                          style: TextStyle(color: Colors.blueGrey),
                          keyboardType: TextInputType.number,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter Pincode",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                child: Text("Register User"),
                                onPressed: () async {
                                  List<Login> temp =
                                      await Login().select().toList();
                                  if (temp.length > 0) {
                                    await Login()
                                        .select()
                                        .empName
                                        .equals(temp[0].empName)
                                        .delete();
                                  }
                                  await Login(
                                          empName: empName.text.toString(),
                                          empId: empId.text.toString(),
                                          mobile: mobile.text.toString(),
                                          pincode: pincode.text.toString(),
                                          IMEI: wantedId.toString(),
                                          facilityID:
                                              facilityID.text.toString())
                                      .upsert();
                                  print("Inserted");

                                  List<Login> emp =
                                      await Login().select().toList();
                                  print(emp.length);
                                  if (emp.length > 0) {
                                    var headers = {
                                      'Content-Type': 'application/json'
                                    };
                                    var request = http.Request(
                                        'POST',
                                        Uri.parse(
                                            'http://rictapi.cept.gov.in:8080/api/registration'));
                                    request.body = json.encode({
                                      "mobileno": emp[0].mobile,
                                      "imei": emp[0].IMEI,
                                      "clientid":
                                          "f99d85be-f198-48f0-96be-dce2722c6179",
                                      "apptoken":
                                          "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
                                      "empid": emp[0].empId,
                                      "name": emp[0].empName,
                                      "pincode": emp[0].pincode,
                                      "divautherization": "Y"
                                    });
                                    request.headers.addAll(headers);

                                    http.StreamedResponse response =
                                        await request.send();

                                    if (response.statusCode == 201) {
                                      print(await response.stream
                                          .bytesToString());
                                      setState(() {
                                        getSMS = true;
                                      });
                                    } else {
                                      print(response.reasonPhrase);
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFCC0000),
                                  primary: Colors.white,
                                )),
                            TextButton(
                                child: Text("CLEAR"),
                                onPressed: () async {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginAccessTokenScreen()),
                                      (route) => false);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFCC0000),
                                  primary: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: getSMS,
                      child: TextButton(
                          child: Text("Get SMS"),
                          onPressed: () async {
                            List<Login> emp = await Login().select().toList();
                            print(emp[0].mobile);
                            var headers = {'Content-Type': 'application/json'};
                            var request = http.Request(
                                'POST',
                                Uri.parse(
                                    'http://rictapi.cept.gov.in:8080/api/smsotp'));
                            request.body = json.encode({
                              "clientid":
                                  "f99d85be-f198-48f0-96be-dce2722c6179",
                              "apptoken":
                                  "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
                              "mobilenumber": "${emp[0].mobile}",
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              print(await response.stream.bytesToString());

                              setState(() {
                                otp = true;
                                verifysms = true;
                              });
                            } else {
                              print(response.reasonPhrase);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFCC0000),
                            primary: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: otp,
                        child: TextFormField(
                          controller: otpreceived,
                          style: TextStyle(color: Colors.blueGrey),
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Enter OTP Received",
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 3)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 3)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: verifysms,
                      child: TextButton(
                          child: Text("Verify SMS"),
                          onPressed: () async {
                            List<Login> emp = await Login().select().toList();
                            var headers = {'Content-Type': 'application/json'};
                            var request = http.Request(
                                'POST',
                                Uri.parse(
                                    'http://rictapi.cept.gov.in:8080/api/verifysmsotp'));
                            request.body = json.encode({
                              "clientid":
                                  "f99d85be-f198-48f0-96be-dce2722c6179",
                              "apptoken":
                                  "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
                              "mobilenumber": "${emp[0].mobile}",
                              "otp": "${otpreceived.text}"
                            });
                            request.headers.addAll(headers);

                            http.StreamedResponse response =
                                await request.send();

                            if (response.statusCode == 200) {
                              // print(await response.stream.bytesToString());
                              String res =
                                  await response.stream.bytesToString();
                              print("Tokens response");
                              print(res);
                              String atoken = json.decode(res)['access_token'];
                              String rtoken = json.decode(res)['refresh_token'];
                              int time = json.decode(res)['expires_in'];
                              print("Access token is: " + atoken);
                              print("Refresh token is: " + rtoken);
                              print("Time is: " + time.toString());
                              tokens = [atoken, rtoken, time];
                              await sharedPreferenceService
                                  .setAccessToken(atoken.toString());
                              await sharedPreferenceService
                                  .setRefreshToken(rtoken.toString());
                              await sharedPreferenceService
                                  .setTimer(time.toString());
                              var s = DateTime.now().toString();
                              await sharedPreferenceService.setAccessTime(s);
                              setState(() {
                                digitalOtp = true;
                                // digitalOTP.text=digitOTP;
                              });
                            } else {
                              print(response.reasonPhrase);
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFFCC0000),
                            primary: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: digitalOtp,
                        child: Column(
                          children: [
                            TextButton(
                                child: Text("Get Digital OTP"),
                                onPressed: () async {
                                  List<Login> emp =
                                      await Login().select().toList();
                                  var headers = {
                                    'Content-Type': 'application/json'
                                  };
                                  var request = http.Request(
                                      'POST',
                                      Uri.parse(
                                          'http://rictapi.cept.gov.in:8080/api/getdigitalcode'));
                                  request.body = json.encode({
                                    "clientid":
                                        "f99d85be-f198-48f0-96be-dce2722c6179",
                                    "apptoken":
                                        "57aed7f6-8765-467e-bf7b-d52b4743d3c8",
                                    "mobileno": "${emp[0].mobile}"
                                  });
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response =
                                      await request.send();

                                  if (response.statusCode == 200) {
                                    // print(await response.stream.bytesToString());
                                    digitOTP =
                                        await response.stream.bytesToString();
                                    // setState(() {
                                    //   digitalOtp=true;
                                    //   digitalOTP.text=digitOTP;
                                    // });
                                    await Login()
                                        .select()
                                        .update({"digitalToken": digitOTP});
                                    AlertDigitalOTPState()
                                        .showDialogBox(context, digitOTP);
                                  } else {
                                    print(response.reasonPhrase);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFFCC0000),
                                  primary: Colors.white,
                                )),
                            // TextFormField(
                            //   controller: digitalOTP,
                            //   style: TextStyle(color: Colors.blueGrey),
                            //    readOnly: true,
                            //   decoration: InputDecoration(
                            //     labelText: "DigitalOTP",
                            //     hintStyle: TextStyle(fontSize: 15,
                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                            //     border: InputBorder.none,
                            //
                            //     enabledBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.blueGrey,width: 3)
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.green,width: 3)
                            //     ),
                            //
                            //     contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic>? deviceData;

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
      _deviceData = deviceData!;
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
}
