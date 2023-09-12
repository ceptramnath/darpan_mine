import 'dart:async';
import 'dart:convert';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/backgroundoperations.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../main.dart';
import './ResetPasswordScreen.dart';
import '../../HomeScreen.dart';
import '../AlertDialogChecker.dart';
import '../UtilitiesMainScreen.dart';
import 'APIEndPoints.dart';
import 'LoginScreen_new_aadhar_bio_otp.dart';
import 'db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/uidaiErrCodes.dart';

class CommonLoginScreen extends StatefulWidget {
  const CommonLoginScreen({Key? key}) : super(key: key);

  @override
  State<CommonLoginScreen> createState() => _CommonLoginScreenState();
}

int? validtimer;
StreamSubscription<int>? every3seconds;

class _CommonLoginScreenState extends State<CommonLoginScreen> {
  String? _currentRole;
  String _currentDeviceID = "DeviceID_1";

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String _usernameError = "";
  APIEndPoints apiEndPoints = new APIEndPoints();
  //late final loginuri = apiEndPoints.login;
  List<USERLOGINDETAILS> loginDetails = [];
  String access_token = "";
  String refresh_token = "";
  String validity = "";
  bool isLoadervisibltyOn = false;
  bool bpmRoleVisible = false;
  bool postManRoleVisible = false;
  bool isDeviceIdEnabled = false;
  String _comingSms = 'Unknown';
  final otpEditingController = TextEditingController();
  bool isLoginButtonVisible = false;
  String inactive_user="";
  String OtpFailText="";

  late final validationAPI = apiEndPoints.credCheckingAPI;
  late final otpsmsAPI = apiEndPoints.smsRequestAPI;
  late final otpVerificaitonAPI = apiEndPoints.otpVerifyAPI;
  String otpVerResponse="";


  // Initially password is obscure
  bool _obscureText = true;



  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    usernameController.clear();
    passwordController.clear();
    getAadharErrorCodes();

    super.initState();
  }

  getAadharErrorCodes() async{
    final aadharerrormaster = await API_Errcode().select().toCount();
    if (aadharerrormaster == 0) {
      final resultaadhar =
      """INSERT INTO "API_Errcodes" VALUES (100,'"Pi" (basic) attributes of demographic data did not match','The provided Personal Identity information didn''t match. Please re-enter your'),
 (200,'"Pa" (address) attributes of demographic data did not match','The provided Personal Address information didn''t match.Please re-enter your <co (care of), house, street, lm (land mark), loc (locality), vtc, subdist, dist, state, pc (postal pin code), po (post office)>.'),
 (300,'Biometric data did not match','Ensure correct aadhaar number is entered for authentication'),
 (310,'Duplicate fingers used','Resident should provide distinct fingers (two different fingers) for two'),
 (311,'Duplicate Iris used','Resident should provide distinct fingers (two different Iris) for two Iris'),
 (312,'FMR and FIR ( Finger Image Record) cannot be used in same transaction','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (313,'Single FIR ( Finger Image Record)record contains more than one finger','Technical Issue with AUA Application. AUA Application must follow the'),
 (314,'Number of FMR(Finger Minutiae Record )/FIR ( Finger Image Record) should not exceed 10','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (315,'Number of IIR ( Iris Image Record) should not exceed 2','Technical Issue with AUA Application. AUA Application must follow the'),
 (316,'Number of FID ( Face Image Data )should not exceed 1.','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (330,'Biometrics locked by Aadhaar holder','Resident must unlock his biometrics'),
 (400,'"OTP" validation failed','Resident must ensure that the correct OTP value is provided for authentication .'),
 (402,'“txn” value did not match with “txn” value used in Request OTP API.','Technical Issue with AUA Application. AUA Application must follow the'),
 (500,'Invalid Skeyencryption','Technical Issue with AUA Application. AUA Application must follow the'),
 (501,'Invalid value for "ci" attribute in "Skey" element','Technical Issue with AUA Application. AUA Application must follow the'),
 (502,'Invalid Pid Encryption','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (503,'Invalid HMac encryption','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (504,'Session key re-initiation required due to expiry or key out of sync','Technical Issue with AUA Application. AUA Application must follow the'),
 (505,'Synchronized Skey usage is not allowed','Technical Issue with AUA Application. AUA Application must follow the'),
 (510,'Invalid Auth XML format','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (511,'Invalid PID XML format','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (512,'Invalid Aadhaar holder consent in “rc” attribute of “Auth”','Resident concent to do aadhaar based authentication must be mandatorily taken by the AUA application.'),
 (513,'Invalid Protobuf Format','Technical Issue with AUA Application. AUA Application must follow the'),
 (520,'Invalid “tid” value','Technical Issue with AUA Application. AUA Application must follow the'),
 (521,'Invalid “dc” code under Meta tag','Technical Issue with AUA Application. AUA Application must follow the'),
 (524,'Invalid “mi” code under Meta tag','Technical Issue with AUA Application. AUA Application must follow the'),
 (527,'Invalid “mc” code under Meta tag.','Technical Issue with AUA Application. AUA Application must follow the'),
 (528,'Device - Key Rotation policy','Technical Issue with AUA Application. AUA Application must follow the'),
 (530,'Invalid authenticator code','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (540,'Invalid Auth XML version','Technical Issue with AUA Application. AUA Application must follow the'),
 (541,'Invalid PID XML version','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (542,'AUA not authorized for ASA.','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (543,'Sub-AUA not associated with "AUA"','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (550,'Invalid "Uses" element attributes','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (552,'WADH Validation failed','Technical Issue with AUA Application. AUA Application must follow the'),
 (553,'Registered devices currently not supported. This feature is being implemented in a phased manner.','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (554,'Public devices are not allowed to be used','Technical Issue with AUA Application. AUA Application must follow the'),
 (555,'rdsId is invalid and not part of certification registry','Technical Issue with AUA Application. AUA Application must follow the'),
 (556,'rdsVer is invalid and not part of certification registry.','Technical Issue with AUA Application. AUA Application must follow the'),
 (557,'dpId is invalid and not part of certification registry.','Technical Issue with AUA Application. AUA Application must follow the'),
 (558,'Invalid dih','Technical Issue with AUA Application. AUA Application must follow the'),
 (559,'Device Certificate has expired','Technical Issue with AUA Application. AUA Application must follow the'),
 (560,'DP Master Certificate has expired','Technical Issue with AUA Application. AUA Application must follow the'),
 (561,'Request expired ("Pid- >ts" value is older than N hours where N is a configured threshold in authentication server)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (562,'Timestamp value is future time (value specified "Pid->ts" is ahead of authentication server time beyond acceptable threshold)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (563,'Duplicate request (this error occurs when exactly same authentication request was re-sent by AUA)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (564,'HMAC Validation failed','Technical Issue with AUA Application. AUA Application must follow the'),
 (565,'AUA License key has expired','Technical Issue with AUA Application. AUA Application must follow the'),
 (566,'Invalid non-decryptable license key','Technical Issue with AUA Application. AUA Application must follow the'),
 (567,'Invalid input (this error occurs when some unsupported characters were found in Indian language values, "lname" or "lav")','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (568,'Unsupported Language','Technical Issue with AUA Application. AUA Application must follow the'),
 (569,'Digital signature verification failed (this means that authentication request XML was modified after it was signed)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (570,'Invalid key info in digital signature (this means that certificate used for signing the authentication request is not valid – it is either expired, or does not belong to the AUA or is not created by an approved Certification Authority)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (572,'Invalid biometric position (This error is returned if biometric position value - "pos" attribute in "Bio" element - is not applicable for a given biometric type - "type" attribute in "Bio" element.)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (573,'Pi usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (574,'Pa usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (575,'Pfa usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (576,'FMR usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (577,'FIR usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (578,'IIR usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (579,'OTP usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (580,'PIN usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (581,'Fuzzy matching usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (582,'Local language usage not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (586,'FID usage not allowed as per license.','Technical Issue with AUA Application. AUA Application must follow the'),
 (587,'Name space not allowed.','Technical Issue with AUA Application. AUA Application must follow the'),
 (588,'Registered device not allowed as per license','Technical Issue with AUA Application. AUA Application must follow the'),
 (590,'Public device not allowed as per license.','Technical Issue with AUA Application. AUA Application must follow the'),
 (710,'Missing "Pi" data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (720,'Missing "Pa" data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (721,'Missing "Pfa" data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (730,'Missing PIN data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (740,'Missing OTP data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (800,'Invalid biometric data','Technical Issue with AUA Application. AUA Application must follow the'),
 (810,'Missing biometric data as specified in "Uses"','Technical Issue with AUA Application. AUA Application must follow the'),
 (811,'Missing biometric data in CIDR for the given Aadhaar number','Your Biometric data is not available in CIDR.'),
 (812,'Resident has not done "Best Finger Detection". Application should initiate BFD application to help resident identify their best fingers. See Aadhaar Best Finger Detection API specification.','You have not done best finger detection so kindly proceed with the BFD process for successful authentication.'),
 (820,'Missing or empty value for "bt" attribute in "Uses" element','Technical Issue with AUA Application. AUA Application must follow the'),
 (821,'Invalid value in the "bt" attribute of "Uses" element','Technical Issue with AUA Application. AUA Application must follow the'),
 (822,'Invalid value in the “bs” attribute of “Bio” element within “Pid”','Technical Issue with AUA Application. AUA Application must follow the'),
 (901,'No authentication data found in the request (this corresponds to a scenario wherein none of the auth data – Demo, Pv, or Bios – is present)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (902,'Invalid "dob" value in the "Pi" element (this corresponds to a scenarios wherein "dob" attribute is not of the format "YYYY" or "YYYY-MM-DD", or the age of resident is not in valid range)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (910,'Invalid "mv" value in the "Pi" element','Technical Issue with AUA Application. AUA Application must follow the'),
 (911,'Invalid "mv" value in the "Pfa" element','Technical Issue with AUA Application. AUA Application must follow the'),
 (912,'Invalid "ms" value','Technical Issue with AUA Application. AUA Application must follow the'),
 (913,'Both "Pa" and "Pfa" are present in the authentication request (Pa and Pfa are mutually exclusive)','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (940,'Unauthorized ASA channel','Technical Issue with AUA Application. AUA Application must follow the UIDAI API Specification.'),
 (941,'Unspecified ASA channel','Technical Issue with AUA Application. AUA Application must follow the'),
 (950,'OTP store related technical error','Technical Issue at UIDAI end . AUA/Resident can reach UIDAI contact center for more details.'),
 (951,'Biometric lock related technical error','Technical Issue at UIDAI end . AUA/Resident can reach UIDAI contact center for more details.'),
 (995,'Aadhaar suspended by competent authority','Your Aadhaar number is suspended .AUA/Resident can reach UIDAI contact center for more details.'),
 (996,'Aadhaar Cancelled','Your Aadhaar is cancelled , Resident shall visit Permanent Enrolment Centre with document proofs and follow the re-enrollment process.. AUA/Resident can reach UIDAI contact center for more details.'),
 (997,'Aadhaar Suspended','Your Aadhaar is suspended, Resident shall visit Permanent Enrolment Centre with document proofs and follow the enrolment update process.'),
 (998,'Invalid Aadhaar Number 0r Non Availability of Aadhaar data','Ensure you have entered correct Aadhaar number. Please retry with correct Aadhaar number after sometime.');""";

      final aadharinsert = await UIDAIErrorCodes().execSQL(resultaadhar);
    }

    final aadharopierrormaster=await Aadhar_OTP_ErrCode().select().toCount();
    if(aadharopierrormaster==0){
      final resultaadhar="""INSERT INTO "Aadhar_OTP_ErrCodes" VALUES (110,'Aadhaar number does not have email ID'),
 (111,'Aadhaar number does not have mobile number'),
 (112,'Aadhaar number does not have both email ID and mobile number'),
 (113,'Aadhaar Number doesn''t have verified email ID.'),
 (114,'Aadhaar Number doesn''t have verified Mobile Number'),
 (115,'Aadhaar Number doesn''t have verified email and Mobile'),
 (510,'Invalid OtpXML format.'),
 (515,'Invalid VID Number in input.'),
 (517,'Expired VID is used in input.'),
 (520,'Invalid device'),
 (521,'Invalid mobile number.'),
 (522,'Invalid typeattribute'),
 (523,'Invalid tsattribute. Either it is not in correct format or is older than 20 min'),
 (530,'Invalid AUA code.'),
 (540,'Invalid OTP XML version'),
 (542,'Technical Exception'),
 (543,'Technical Exception'),
 (565,'AUA License key has expired or is invalid.'),
 (566,'ASA license key has expired or is invalid.'),
 (569,'Digital signature verification failed.'),
  (400,'"OTP" validation failed.Resident must ensure that the correct OTP value is provided for authentication .'),
 (402,'Technical Issue with AUA Application. AUA Application must follow the'),
 (570,'Invalid key info in digital signature (this means that certificate used for signing the OTP request is not valid
it is either expired, or does not belong to the AUA or is not created by a CA).'),
 (940,'Unauthorized ASA channel.'),
 (941,'Unspecified ASA channel.'),
 (950,'Could not generate and/or send OTP.'),
 (952,'OTP Flooding error.'),
 (999,'Unknown error.');""";

      final aadharinsert = await UIDAIErrorCodes().execSQL(resultaadhar);
    }
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  String? validatePasswordString(String value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/images/background_screen.jpeg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height*.3,
                // ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*.3, left: 18, bottom: 8, right: 5),
                    child: SizedBox.shrink()),
                SizedBox(
                  height: 80,
                ),
                Column(
                  children: [
                    // AuthForm(title: 'Employee ID/Username', controller: usernameController, icon: MdiIcons.idCard,),
                    // AuthForm(title: 'Password', controller: passwordController, icon: Icons.lock_outline,),
                    //Center(child: Button(buttonText: 'LOGIN', buttonFunction: (){})),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: DropdownButtonFormField<String>(
                        value: _currentRole, // Initial value
                          //dropdownColor: Color.fromRGBO(255, 255, 255, 0.5), // Transparent white background,
                          dropdownColor: Color.fromRGBO(255, 0, 0, 0.5), // Transparent Red background,
                          onChanged: (String? newValue) {
                          setState(() {
                          _currentRole = newValue!;
                          if(_currentRole == "BPM" || _currentRole == "Substitute" ){
                          bpmRoleVisible = true;
                          postManRoleVisible = false;
                          isDeviceIdEnabled = false;
                          usernameController.text='';
                          passwordController.text='';
                          otpEditingController.text='';
                          }else if(_currentRole == "PostMan/PostWomen" || _currentRole == "Delivery Agent" || _currentRole == "Pickup Agent" || _currentRole == "LB Peon" ){
                          postManRoleVisible = true;
                          isDeviceIdEnabled = true;
                          bpmRoleVisible = false;
                          usernameController.text='';
                          passwordController.text='';
                          otpEditingController.text='';
                          }
                          else{
                          bpmRoleVisible = false;
                          postManRoleVisible = false;
                          }

                          print("_currentRole : $_currentRole");
                          });
                          // Handle dropdown value change
                          print(newValue);
                          },
                          items: <String>[
                          'BPM',
                          'PostMan/PostWomen',
                          'Delivery Agent',
                          'Pickup Agent',
                          'LB Peon',
                          'Substitute',
                          ].map((String dropValue) {
                          return DropdownMenuItem<String>(
                          value: dropValue,
                          child: Text(dropValue),
                          );
                          }).toList(),

                          style: TextStyle(color: Colors.amberAccent),
                          //keyboardType: TextInputType.number,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Select Your Role",
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
                    //visible: true,
                    visible: isDeviceIdEnabled, // intitally false
                    child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: DropdownButtonFormField<String>(
                          value: _currentDeviceID, // Initial value
                          onChanged: (String? newValue2) {
                            setState(() {
                              _currentDeviceID = newValue2!;
                              /*if(_currentRole == "BPM" || _currentRole == "Substitute" ){
                                bpmRoleVisible = true;
                                postManRoleVisible = false;
                                isDeviceIdEnabled = false;
                              }else if(_currentRole == "PostMan/PostWomen" || _currentRole == "Delivery Agent" || _currentRole == "Pickup Agent" || _currentRole == "LB Peon" ){
                                postManRoleVisible = true;
                                isDeviceIdEnabled = true;
                                bpmRoleVisible = false;
                              }
                              else{
                                bpmRoleVisible = false;
                                postManRoleVisible = false;
                              }*/

                              print("_currentDeviceID : $_currentDeviceID");
                            });
                            // Handle dropdown value change
                            print(newValue2);
                          },
                          items: <String>[
                            'DeviceID_1',
                            'DeviceID_2',
                          ].map((String dropValue) {
                            return DropdownMenuItem<String>(
                              value: dropValue,
                              child: Text(dropValue),
                            );
                          }).toList(),

                          //controller: usernameController,
                          style: TextStyle(color: Colors.amberAccent),
                          //keyboardType: TextInputType.number,
                          // maxLength: 10,
                          // maxLengthEnforced: true,
                          // readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Select Your Device ID",
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
                    ),
                    Visibility(
                    //visible: true,
                    visible: bpmRoleVisible, // intitally false
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .75,
                              child: TextFormField(
                                controller: usernameController,
                                style: TextStyle(color: Colors.amberAccent),
                                keyboardType: TextInputType.number,
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                // readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Employee ID / Username",
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
                          //Password Textbox
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .75,
                              child: TextFormField(
                                obscureText: _obscureText,
                                enableSuggestions: false,
                                autocorrect: false,
                                controller: passwordController,
                                style: TextStyle(color: Colors.amberAccent),
                                keyboardType: TextInputType.visiblePassword,
                                // maxLength: 10,
                                // maxLengthEnforced: true,
                                // readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
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
                                  suffixIcon: IconButton(
                                    onPressed: _toggle,
                                    icon: _obscureText
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                  ),

                                  // Align(
                                  //   widthFactor: 1.0,
                                  //   heightFactor: 1.0,
                                  //   child: Icon(
                                  //     Icons.remove_red_eye,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          //Forgot Password Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ResetPasswordScreen()));

                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (_) => const PdfGenerationScreen()));
                              },
                              child: const Text(
                                "Change Password?",
                                style: TextStyle(color: Colors.amberAccent),
                              ),
                            ),
                          ),
                          // Link to Aadhar Login Screen
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (_) => const AadharLoginScreen()));
                          //
                          //       // Navigator.push(context,
                          //       //     MaterialPageRoute(builder: (_) => const PdfGenerationScreen()));
                          //     },
                          //     child: const Text(
                          //       "Login using Aadhar",
                          //       style: TextStyle(color: Colors.amberAccent),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () async {
                            setState(() {
                              isLoadervisibltyOn =true;
                            });

                            /*Future.delayed(Duration(milliseconds: 30000), () {
                              setState(() {
                                isLoadervisibltyOn =false;
                              });
                            });*/
                            print("Inside GET OTP Button");
                            bool isInternetConnectionAvailable = await InternetConnectionChecker()
                                .hasConnection;
                            if(isInternetConnectionAvailable){
                              Future.delayed(Duration(milliseconds: 30000), () {
                                setState(() {
                                  isLoadervisibltyOn =false;
                                });
                              });
                              print("Inside GET OTP Button");
                            bool functionRt = await validateAndSendOTP(
                                usernameController.text,
                                passwordController.text);

                            if (functionRt == true) {
                              initSmsListener(); //once OTP sent enable listener
                            } else {
                              setState(() {
                                isLoadervisibltyOn = false;
                              });
                              if(inactive_user=="")
                                UtilFs.showToast(
                                    "User Credentials are wrong..!", context);
                              else
                                UtilFs.showToast(
                                    "Inactive User", context);

                            }
                            }else{
                              isLoadervisibltyOn =false;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Check Internet Connection and retry to GET OTP"),
                              ));
                            }
                          },
                          child: Text('GET OTP',
                              style:
                              TextStyle(color: Colors.white, fontSize: 20)),
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
                    //OTP Input
                       Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                         PinCodeTextField(
                              appContext: context,
                              readOnly: true,
                              //readOnly: true,
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
                              controller: otpEditingController,
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


                    //Login Button
                    Visibility(
                      //visible: true,
                      visible: isLoginButtonVisible, // intitally false
                      child: Center(
                        child: Button(
                            buttonText: 'LOGIN',
                            buttonFunction: () async {
                              setState(() {
                                isLoadervisibltyOn = true;
                              });
                              bool netresult = await InternetConnectionChecker()
                                  .hasConnection;
                              if (netresult) {
                                final returnValue = await otpVerification(
                                    usernameController.text,
                                    otpEditingController.text,
                                    "");

                                if (returnValue == true &&
                                    passwordController.text ==
                                        apiEndPoints.defaultPassword) {

                                  final insertDefault = await USERLOGINDETAILS()
                                    ..EMPID=usernameController.text
                                    ..Password = apiEndPoints.defaultPassword;
                                  await insertDefault.save();
                                  print("Befor Reset Password");

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                          const ResetPasswordScreen()));
                                }
                                else if (returnValue == true)
                                  //OTP Verification Successful.
                                    {
                                  //1. Check all validations
                                  if (usernameController.text.isEmpty ||
                                      passwordController.text.isEmpty)
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Enter UserID/Password."),
                                    ));
                                  else if (!validatePassword(
                                      passwordController.text)) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Invalid Password"),
                                    ));
                                  }
                                  //2. check whether user detail is available in local DB.
                                  // If available perform local JWT validation else hit Login API.
                                  final loginDetails = await USERLOGINDETAILS()
                                      .select()
                                      .EMPID
                                      .contains(usernameController.text)
                                      .toList();

                                  //when user details available in local DB.
                                  if (loginDetails.length > 0 &&
                                      loginDetails[0].AccessToken.toString() !=
                                          null) {
                                    if (loginDetails[0].Password !=
                                        passwordController.text) {
                                      setState(() {
                                        isLoadervisibltyOn = false;
                                      });
                                      UtilFs.showToast(
                                          "User Credentials is wrong", context);
                                    } else {
                                      print(
                                          'User details with Access token is available in local db.');
                                      bool rtValue = JwtCheck(loginDetails);
                                      print('JWT Function return value - ' +
                                          rtValue.toString());

                                      //when token is not valid
                                      if (!rtValue) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                          Text("Access Token Expired..!"),
                                        ));
                                        bool value = false;
                                        bool netresult =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                        if (netresult) {

                                          // value = await LoginAPI(
                                          //     loginuri,
                                          //     usernameController.text,
                                          //     passwordController.text);
                                          value = await LoginAPI(usernameController.text,passwordController.text );
                                        } else {

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Internet connection is not available..!"),
                                          ));
                                        }

                                        if (value) {
                                          //commented by Rohit for testing, later has to be uncommented
                                          /*
                                  loginDetails[0].EMPID = usernameController.text;
                                  loginDetails[0].Password =
                                      passwordController.text;
                                  loginDetails[0].AccessToken = "";
                                  loginDetails[0].RefreshToken = "";
                                  loginDetails[0].Validity = "";

                                  final accessSave = await USERLOGINDETAILS()
                                      .upsertAll(loginDetails);
                                  if (accessSave.success)
                                    print("Access details stored into local db.");
                                  else
                                    print(accessSave.errorMessage);

                                   */

                                          // await USERDETAILS().select().delete();
                                          // final sql =
                                          //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
                                          // final result = await UserDB().execSQL(sql);
                                          // print(result);
                                          //
                                          // //Inserting Master Data as API is pending
                                          // await OFCMASTERDATA().select().delete();
                                          // final sql1 =
                                          //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','049213','570010')";
                                          // final result1 =
                                          // await UserDB().execSQL(sql1);
                                          // print(result);
                                          // print('Office Master Data');
                                          // final ofcMaster =
                                          // await OFCMASTERDATA().select().toList();
                                          // print(ofcMaster[0].EMOCODE);

                                          print(
                                              "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
                                          final loginDetails =
                                          await USERLOGINDETAILS()
                                              .select().Active.equals(true)
                                              .toList();

                                          final ofcMaster1 =
                                          await OFCMASTERDATA()
                                              .select()
                                              .toCount();
                                          print(ofcMaster1.toString());

                                          await fetchUserDetails(
                                              loginDetails[0]
                                                  .AccessToken
                                                  .toString(),
                                              apiEndPoints.fetchUserDetailsAPI,
                                              usernameController.text);

                                          final ofcMaster2 =
                                          await OFCMASTERDATA()
                                              .select()
                                              .toList();
                                          print(ofcMaster2.length.toString());
                                          if (ofcMaster2.length > 0) {
                                            for (int i = 0;
                                            i < ofcMaster2.length;
                                            i++) {
                                              print(ofcMaster2[i].toString());
                                            }
                                          }

                                          bool netresult =
                                          await InternetConnectionChecker()
                                              .hasConnection;
                                          if (netresult) {
                                            await dataSync.download();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Internet connection is not available..!"),
                                            ));
                                          }

                                          // loginDetails=await USERLOGINDETAILS().select().toList();

                                          int validtimer = DateTime.parse(
                                              loginDetails[0].Validity!)
                                              .difference(DateTime.now())
                                              .inSeconds;
                                          print("Timer validity: $validtimer");
                                          every3seconds = Stream<int>.periodic(
                                              Duration(seconds: validtimer),
                                                  (t) => t).listen((t) {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder:
                                                  (BuildContext dialogContext) {
                                                return WillPopScope(
                                                  onWillPop: () async => false,
                                                  child: MyAlertDialog(
                                                    title: 'Title $t',
                                                    content: 'Dialog content',
                                                  ),
                                                );
                                              },
                                            );
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainHomeScreen(
                                                        UtilitiesMainScreen(),
                                                        0)),
                                          );
                                        } else {
                                          print("User ID -" +
                                              usernameController.text);
                                          print("Password -" +
                                              passwordController.text);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Invalid User ID or Password"),
                                          ));
                                        }
                                      }

                                      //when token is valid
                                      else {
                                        // await USERDETAILS().select().delete();
                                        // final sql =
                                        //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
                                        // final result = await UserDB().execSQL(sql);
                                        // print(result);
                                        //
                                        // //Inserting Master Data as API is pending
                                        // await OFCMASTERDATA().select().delete();
                                        // final sql1 =
                                        //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','123456','570010')";
                                        // final result1 = await UserDB().execSQL(sql1);
                                        // print(result);
                                        //
                                        // print('Office Master Data');
                                        // final ofcMaster =
                                        // await OFCMASTERDATA().select().toList();
                                        // print(ofcMaster[0].EMOCODE);

                                        //Checking Internet Connectivity before calling API.
                                        bool netresult = false;
                                        netresult =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                        if (netresult) {
                                          print(
                                              "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
                                          final loginDetails =
                                          await USERLOGINDETAILS()
                                              .select().Active.equals(true)
                                              .toList();

                                          final ofcMaster1 =
                                          await OFCMASTERDATA()
                                              .select()
                                              .toCount();
                                          print(ofcMaster1.toString());
                                          if (ofcMaster1 == 0) {
                                            await fetchUserDetails(
                                                loginDetails[0]
                                                    .AccessToken
                                                    .toString(),
                                                apiEndPoints
                                                    .fetchUserDetailsAPI,
                                                usernameController.text);
                                          }
                                          final ofcMaster2 =
                                          await OFCMASTERDATA()
                                              .select()
                                              .toList();
                                          print(ofcMaster2.length.toString());
                                          if (ofcMaster2.length > 0) {
                                            for (int i = 0;
                                            i < ofcMaster2.length;
                                            i++) {
                                              print(ofcMaster2[i].toString());
                                            }
                                          }

                                          await dataSync.download();
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Internet connection is not available..!"),
                                          ));
                                        }
                                        // loginDetails=await USERLOGINDETAILS().select().toList();

                                        int validtimer = DateTime.parse(
                                            loginDetails[0].Validity!)
                                            .difference(DateTime.now())
                                            .inSeconds;
                                        print("Timer validity: $validtimer");
                                        every3seconds = Stream<int>.periodic(
                                            Duration(seconds: validtimer),
                                                (t) => t).listen((t) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return WillPopScope(
                                                onWillPop: () async => false,
                                                child: MyAlertDialog(
                                                  title: 'Title $t',
                                                  content: 'Dialog content',
                                                ),
                                              );
                                            },
                                          );
                                        });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainHomeScreen(
                                                      UtilitiesMainScreen(),
                                                      0)),
                                        );
                                      }
                                    }
                                  }
                                  //when user details not available in the local db.
                                  else {
                                    bool value = false;
                                    bool netresult =
                                    await InternetConnectionChecker()
                                        .hasConnection;
                                    if (netresult) {
                                      // value = await LoginAPI(
                                      //     loginuri,
                                      //     usernameController.text,
                                      //     passwordController.text);
                                      value = await LoginAPI(usernameController.text,passwordController.text);
                                      // await dataSync.download();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Internet connection is not available..!"),
                                      ));
                                    }

                                    if (value) {
                                      //commented by Rohit for testing, later has to be uncommented
                                      /*
                                  loginDetails[0].EMPID = usernameController.text;
                                  loginDetails[0].Password =
                                      passwordController.text;
                                  loginDetails[0].AccessToken = "";
                                  loginDetails[0].RefreshToken = "";
                                  loginDetails[0].Validity = "";

                                  final accessSave = await USERLOGINDETAILS()
                                      .upsertAll(loginDetails);
                                  if (accessSave.success)
                                    print("Access details stored into local db.");
                                  else
                                    print(accessSave.errorMessage);

                                   */

                                      //commented below hardcoded code and added API call to fetch master data by Rohit
                                      // await USERDETAILS().select().delete();
                                      // final sql =
                                      //     "insert or replace into USERDETAILS (EMPID,BOFacilityID,BOName,EmployeeName) values('50001657','BO21309110004','Hosamalangi B.O','Test User')";
                                      // final result = await UserDB().execSQL(sql);
                                      // print(result);
                                      //
                                      // //Inserting Master Data as API is pending
                                      // await OFCMASTERDATA().select().delete();
                                      // final sql1 =
                                      //     "insert or replace into OFCMASTERDATA (EMPID,BOFacilityID,BOName,EMOCODE,Pincode) values('50001657','BO21309110004','TEST OFFICE','123456','570010')";
                                      // final result1 = await UserDB().execSQL(sql1);
                                      // print(result);
                                      // print('Office Master Data');
                                      // final ofcMaster =
                                      // await OFCMASTERDATA().select().toList();
                                      // print(ofcMaster[0].EMOCODE);

                                      print(
                                          "<<<<<<<<<<<<OFFICE MASTER DATA FETCHING>>>>>>>>>>>>>");
                                      final loginDetails =
                                      await USERLOGINDETAILS()
                                          .select().Active.equals(true)
                                          .toList();

                                      final ofcMaster1 = await OFCMASTERDATA()
                                          .select()
                                          .toCount();
                                      print(ofcMaster1.toString());

                                      await fetchUserDetails(
                                          loginDetails[0]
                                              .AccessToken
                                              .toString(),
                                          apiEndPoints.fetchUserDetailsAPI,
                                          usernameController.text);

                                      final ofcMaster2 = await OFCMASTERDATA()
                                          .select()
                                          .toList();
                                      print(ofcMaster2.length.toString());
                                      if (ofcMaster2.length > 0) {
                                        for (int i = 0;
                                        i < ofcMaster2.length;
                                        i++) {
                                          print(ofcMaster2[i].toString());
                                        }
                                      }

                                      //Checking Internet Connectivity before calling API.
                                      bool netresult =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                      if (netresult) {
                                        await dataSync.download();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "Internet connection is not available..!"),
                                        ));
                                      }
                                      // loginDetails=await USERLOGINDETAILS().select().toList();

                                      int validtimer = DateTime.parse(
                                          loginDetails[0].Validity!)
                                          .difference(DateTime.now())
                                          .inSeconds;
                                      print("Timer validity: $validtimer");
                                      every3seconds = Stream<int>.periodic(
                                          Duration(seconds: validtimer),
                                              (t) => t).listen((t) {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return WillPopScope(
                                              onWillPop: () async => false,
                                              child: MyAlertDialog(
                                                title: 'Title $t',
                                                content: 'Dialog content',
                                              ),
                                            );
                                          },
                                        );
                                      });

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainHomeScreen(
                                                    UtilitiesMainScreen(), 0)),
                                      );
                                    } else {
                                      print("User ID -" +
                                          usernameController.text);
                                      print("Password -" +
                                          passwordController.text);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                        Text("Invalid User ID or Password"),
                                      ));
                                    }
                                  }
                                }
                                else {
                                  // UtilFs.showToast(
                                  //     "OTP Verification Failed!", context);
                                  UtilFs.showToast(
                                      OtpFailText, context);

                                  setState(() {
                                    isLoadervisibltyOn = false;
                                  });
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Internet connection is not available..!"),
                                ));
                              }
                            }),
                      ),
                    ),

                    /* Commented Signup Button
                    //Signup Button
                    TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegistrationScreen())),
                        child: RichText(
                          text: const TextSpan(
                              text: "I'm a new user,",
                              style: TextStyle(color: Colors.amberAccent),
                              children: [
                                TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ]),
                        )),
*/

                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //     onPressed: () async {
                    //       setState(() {
                    //         isLoadervisibltyOn=true;
                    //       });
                    //       await USERDETAILS().select().delete();
                    //       final sql="insert or replace into USERDETAILS (EMPID,BOFacilityID) values('50001657','BO21309110004')";
                    //       final result = await UserDB().execSQL(sql);
                    //       print(result);
                    //
                    //       await dataSync.download();
                    //
                    //       Navigator.pushAndRemoveUntil(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) =>
                    //                   MainHomeScreen(MailsMainScreen(), 1)),
                    //           (route) => false);
                    //     },
                    //     child: Text(
                    //       'Skip Login',
                    //       style: TextStyle(
                    //           color: Colors.amberAccent, fontSize: 15),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
        isLoadervisibltyOn == true
            ? Center(
            child: Loader(
                isCustom: true, loadingTxt: 'Please Wait...Loading...'))
            : const SizedBox.shrink()
      ],
    );
  }

  // Future<bool> LoginAPI(String loginuri, String username, String password) async {
  //   bool rtValue = false;
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request('POST', Uri.parse(loginuri));
  //   request.body =
  //       json.encode({"username": "$username", "password": "$password"});
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     String responseContent = await response.stream.bytesToString();
  //     print("Login response*******************************");
  //     var validityTimer = jsonDecode(responseContent)['expires_in'];
  //     // var validityTimer = 100;
  //     print(jsonDecode(responseContent)['expires_in']);
  //     // print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
  //     print(responseContent);
  //     // print('BEFORE - Assigning to local variable');
  //     access_token = jsonDecode(responseContent)["access_token"];
  //     refresh_token = jsonDecode(responseContent)["refresh_token"];
  //
  //     // print('AFTER - Assigning to local variable');
  //
  //     //Storing Access token in local DB.
  //     if (access_token.isNotEmpty || access_token != null) {
  //
  //       print('Storing Access token in local DB.' + DateTime.now().add(Duration(seconds: validityTimer)).toString());
  //       print(validityTimer);
  //       // await USERLOGINDETAILS().select().delete();
  //       //added below code by Rohit on 28.08.2022 to Update already existing User to Inactive.
  //       final result = await USERLOGINDETAILS()
  //           .select()
  //           .EMPID
  //           .not
  //           .contains(username)
  //           .update({"Active": false});
  //       print(result.successMessage);
  //
  //       // print();
  //        print("Username is $username");
  //        var count = await USERLOGINDETAILS().select().EMPID.contains(username).toCount();
  //        print("count value is $count ");
  //       //if user details exist update else insert.
  //       if(await USERLOGINDETAILS().select().EMPID.contains(username).toCount()>0)
  //       {
  //         print("inside Login API if");
  //         final loginupdate =
  //         await USERLOGINDETAILS().select().EMPID.contains(username).update({
  //           "Active": true,
  //           "AccessToken": access_token,
  //           "Validity":
  //           DateTime.now().add(Duration(seconds: validityTimer)).toString(),
  //           "Password": password
  //         });
  //         print(loginupdate.successMessage);
  //         print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
  //
  //       }
  //       else
  //         {
  //           print("inside Login API else");
  //           final logindetails = USERLOGINDETAILS()
  //             ..EMPID = username
  //             ..AccessToken = access_token
  //             ..Validity =
  //                 DateTime.now().add(Duration(seconds: validityTimer)).toString()
  //             ..Password = password
  //             ..Active = true;
  //           logindetails.save();
  //           print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
  //           // Check whether new Substitute logged in other than BPM. Do changes  in else part below
  //           // User is made inactive already
  //           //Delete row in the USERLOGINDETAILS table
  //           final result = await USERLOGINDETAILS()
  //               .select()
  //               .EMPID
  //               .not
  //               .contains(username)
  //               .delete();
  //           print(" Old user deletion in USERLOGINDETAILS ");
  //           print(result.successMessage);
  //           //Update EMPID in USERDETAILS
  //           final result1 = await USERDETAILS()
  //               .select()
  //               .EMPID
  //               .not
  //               .contains(username)
  //               .update({"EMPID": username});
  //           print(" Old user updation in USERDETAILS ");
  //           print(result.successMessage);
  //           //get the Master data using EMPID
  //
  //             print('Inside Fetch User Details substitute');
  //             // empid = "50465276";
  //             String requestURI = apiEndPoints.fetchUserDetailsAPI + username;
  //             print(access_token);
  //             print(requestURI);
  //             var headers = {'Authorization': 'Bearer $access_token'};
  //             var request = http.Request('GET', Uri.parse(requestURI));
  //
  //             request.headers.addAll(headers);
  //
  //             http.StreamedResponse response = await request.send();
  //             print(response.statusCode);
  //             if (response.statusCode == 200) {
  //               final res = await response.stream.bytesToString();
  //               print(res);
  //               print('====================================');
  //
  //               List<dynamic> list = json.decode(res);
  //               print(list[0]['bo_id'].toString());
  //               print(json.decode(res)[0]['bpm_name']);
  //
  //               print(res.toString());
  //
  //               // when Office rolled out for 1st time the OfcMaster Count will be 0
  //               int ofccount = await OFCMASTERDATA().select().toCount();
  //
  //               // when data is available delete existing data
  //
  //               // await OFCMASTERDATA().select().delete();
  //
  //               // await USERDETAILS().select().EMPID.equals(empid).update({'BOFacilityID':'${list[0]['bo_id']}'});
  //               //await USERDETAILS(EMPID: empid, BOFacilityID: list[0]['bo_id']).upsert();
  //
  //               print('Ofc Count is ---- ');
  //               print(ofccount);
  //               //When data is available update EMPID and EmployeeName
  //               if (ofccount > 0) {
  //                 final result2 = await OFCMASTERDATA()
  //                     .select()
  //                     .EMPID
  //                     .not
  //                     .contains(username)
  //                     .update({
  //                   "EMPID": username,
  //                   "EmployeeName": json.decode(res)[0]['bpm_name'],
  //                 });
  //
  //                 print(" Old user updation in OFCMASTERDATA ");
  //                 print(result2.successMessage);
  //               }
  //             } else {
  //               print(response.reasonPhrase);
  //             }
  //
  //
  //           // Changes ended
  //         }
  //
  //
  //
  //       // final logindetails = USERLOGINDETAILS()
  //       //   ..EMPID = username
  //       //   ..AccessToken = access_token
  //       //   ..Validity =
  //       //       DateTime.now().add(Duration(seconds: validityTimer)).toString()
  //       //   ..Password = password
  //       //   ..Active = true;
  //       // logindetails.save();
  //
  //     }
  //
  //     /*
  //     String validityTime = jsonDecode(responseContent)["expires_in"].toString();
  //     DateTime now = DateTime.now();
  //     validity = DateFormat('yyyy-MM-dd – kk:mm').format(now) + validity;
  //
  //      */
  //
  //     String error = " ";
  //     try {
  //       error = jsonDecode(responseContent)["error"];
  //     } catch (e) {
  //       print("Error DKSjf");
  //       print(e);
  //     }
  //     print("Response is - " + responseContent);
  //     print(access_token);
  //     print(error);
  //
  //     if (error == "invalid_grant")
  //       rtValue = false;
  //     else if (access_token.isNotEmpty) rtValue = true;
  //   } else {
  //     print(response.reasonPhrase);
  //     rtValue = false;
  //   }
  //
  //   return rtValue;
  // }
  // Token is being supplied after successfu verification of OTP Hence changes 25072023
  Future<bool> LoginAPI(String username, String password) async {
    bool rtValue = false;
    // var headers = {'Content-Type': 'application/json'};
    // var request = http.Request('POST', Uri.parse(loginuri));
    // request.body =
    //     json.encode({"username": "$username", "password": "$password"});
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //String responseContent = await response.stream.bytesToString();
    String responseContent = otpVerResponse;
    print("otpVerResponse is $otpVerResponse");
    print("Login response*******************************");
    int validityTimer = int.parse(jsonDecode(responseContent)['expires_in']);
    // var validityTimer = 100;
    print(jsonDecode(responseContent)['expires_in']);
    // print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
    print(responseContent);
    // print('BEFORE - Assigning to local variable');
    access_token = jsonDecode(responseContent)["access_token"];
    refresh_token = jsonDecode(responseContent)["refresh_token"];

    // print('AFTER - Assigning to local variable');

    //Storing Access token in local DB.
    if (access_token.isNotEmpty || access_token != null) {

      print('Storing Access token in local DB.' + DateTime.now().add(Duration(seconds:validityTimer)).toString());
      print(validityTimer);
      // await USERLOGINDETAILS().select().delete();
      //added below code by Rohit on 28.08.2022 to Update already existing User to Inactive.
      final result = await USERLOGINDETAILS()
          .select()
          .EMPID
          .not
          .contains(username)
          .update({"Active": false});
      print(result.successMessage);

      // print();
      print("Username is $username");
      var count = await USERLOGINDETAILS().select().EMPID.contains(username).toCount();
      print("count value is $count ");
      //if user details exist update else insert.
      if(await USERLOGINDETAILS().select().EMPID.contains(username).toCount()>0)
      {
        print("inside Login API if");
        final loginupdate =
        await USERLOGINDETAILS().select().EMPID.contains(username).update({
          "Active": true,
          "AccessToken": access_token,
          "RefreshToken": refresh_token,
          "Validity":
          DateTime.now().add(Duration(seconds: validityTimer)).toString(),
          "Password": password
        });
        print(loginupdate.successMessage);
        print(DateTime.now().add(Duration(seconds: validityTimer)).toString());

      }
      else
      {
        print("inside Login API else");
        final logindetails = USERLOGINDETAILS()
          ..EMPID = username
          ..AccessToken = access_token
          ..RefreshToken=refresh_token
          ..Validity =
          DateTime.now().add(Duration(seconds: validityTimer)).toString()
          ..Password = password
          ..Active = true;
        logindetails.save();
        print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
        // Check whether new Substitute logged in other than BPM. Do changes  in else part below
        // User is made inactive already
        //Delete row in the USERLOGINDETAILS table
        final result = await USERLOGINDETAILS()
            .select()
            .EMPID
            .not
            .contains(username)
            .delete();
        print(" Old user deletion in USERLOGINDETAILS ");
        print(result.successMessage);
        //Update EMPID in USERDETAILS
        final result1 = await USERDETAILS()
            .select()
            .EMPID
            .not
            .contains(username)
            .update({"EMPID": username});
        print(" Old user updation in USERDETAILS ");
        print(result.successMessage);
        //get the Master data using EMPID

        print('Inside Fetch User Details substitute');
        // empid = "50465276";
        String requestURI = apiEndPoints.fetchUserDetailsAPI + username;
        print(access_token);
        print(requestURI);
        var headers = {'Authorization': 'Bearer $access_token'};
        var request = http.Request('GET', Uri.parse(requestURI));

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          final res = await response.stream.bytesToString();
          print(res);
          print('====================================');

          List<dynamic> list = json.decode(res);
          print(list[0]['bo_id'].toString());
          print(json.decode(res)[0]['bpm_name']);

          print(res.toString());

          // when Office rolled out for 1st time the OfcMaster Count will be 0
          int ofccount = await OFCMASTERDATA().select().toCount();

          // when data is available delete existing data

          // await OFCMASTERDATA().select().delete();

          // await USERDETAILS().select().EMPID.equals(empid).update({'BOFacilityID':'${list[0]['bo_id']}'});
          //await USERDETAILS(EMPID: empid, BOFacilityID: list[0]['bo_id']).upsert();

          print('Ofc Count is ---- ');
          print(ofccount);
          //When data is available update EMPID and EmployeeName
          if (ofccount > 0) {
            final result2 = await OFCMASTERDATA()
                .select()
                .EMPID
                .not
                .contains(username)
                .update({
              "EMPID": username,
              "EmployeeName": json.decode(res)[0]['bpm_name'],
            });

            print(" Old user updation in OFCMASTERDATA ");
            print(result2.successMessage);
          }
        } else {
          print(response.reasonPhrase);
        }


        // Changes ended
      }



      // final logindetails = USERLOGINDETAILS()
      //   ..EMPID = username
      //   ..AccessToken = access_token
      //   ..Validity =
      //       DateTime.now().add(Duration(seconds: validityTimer)).toString()
      //   ..Password = password
      //   ..Active = true;
      // logindetails.save();

    }

    /*
      String validityTime = jsonDecode(responseContent)["expires_in"].toString();
      DateTime now = DateTime.now();
      validity = DateFormat('yyyy-MM-dd – kk:mm').format(now) + validity;

       */

    String error = " ";
    try {
      error = jsonDecode(responseContent)["error"];
    } catch (e) {
      print("Error DKSjf");
      print(e);
    }
    print("Response is - " + responseContent);
    print(access_token);
    print(error);

    if (error == "invalid_grant")
      rtValue = false;
    else if (access_token.isNotEmpty) rtValue = true;
    // }
    // else {
    //   print(response.reasonPhrase);
    //   rtValue = false;
    // }

    return rtValue;
  }
  //Getting Token using Refresh Token 27072023
  Future<bool> Token_RefreshToken() async {
    print("trying to get token using refresh token");
    bool rtValue = false;
    bool value= false;
    final userdata= await USERLOGINDETAILS().select().toMapList();
    print("Refresh Token is : ${userdata[0]["RefreshToken"]}");
    refresh_token=userdata[0]["RefreshToken"].toString();
    // print(refresh_token);
    var headers = {
      'RefreshToken':refresh_token
    };
    var request = http.Request('GET', Uri.parse(APIEndPoints().refreshToken));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      otpVerResponse=  await response.stream.bytesToString();
      print(otpVerResponse);
      value = await LoginAPI(userdata[0]["EMPID"].toString(), userdata[0]["Password"].toString());
      rtValue=true;
    }
    else {
      print(response.reasonPhrase);
    }
    return rtValue;
  }

  bool JwtCheck(List<USERLOGINDETAILS> loginDetails) {
    print('JWT Checking..!');
    bool rtValue = false;
    String accessToken = loginDetails[0].AccessToken.toString();
    // print(accessToken.isNotEmpty.toString());

    if (accessToken != "null") {
      bool hasExpired = JwtDecoder.isExpired(accessToken);

      if (!hasExpired) {
        rtValue = true;
      } else
        rtValue = false;
    }
    print(accessToken);
    print(rtValue.toString());
    return rtValue;
  }

  fetchUserDetails(String token, String uri, String empid) async {
    print('Inside Fetch User Details');
    // empid = "50465276";
    String requestURI = uri + empid;
    print(token);
    print(requestURI);
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(requestURI));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      print(res);
      print('====================================');

      List<dynamic> list = json.decode(res);
      print(list[0]['bo_id'].toString());
      print(json.decode(res)[0]['bpm_name']);

      print(res.toString());

      // when Office rolled out for 1st time the OfcMaster Count will be 0
      int ofccount = await OFCMASTERDATA().select().toCount();

      // when data is available delete existing data

      // await OFCMASTERDATA().select().delete();

      // await USERDETAILS().select().EMPID.equals(empid).update({'BOFacilityID':'${list[0]['bo_id']}'});
      await USERDETAILS(EMPID: empid, BOFacilityID: list[0]['bo_id']).upsert();

      print('Ofc Count is ---- ');
      print(ofccount);
      if (ofccount == 0) {
        final ofcMaster = OFCMASTERDATA()
          ..EMPID = empid
          ..MobileNumber = list[0]['phone']
          ..EmployeeEmail = list[0]['email']
          ..EmployeeName = list[0]['bpm_name']
          ..DOB = list[0]['dob']
          ..BOFacilityID = list[0]['bo_id']
          ..BOName = list[0]['bo_name']
          ..Pincode = list[0]['pincode']
          ..AOName = list[0]['so_name']
          ..AOCode = list[0]['so_id']
          ..DOName = list[0]['do_name']
          ..DOCode = list[0]['do_id'];

        ofcMaster.save();

        //fetching BO Balance

        await fetchBOBalanceDetails(token, apiEndPoints.fetchBOBALAPI,
            list[0]['bo_id'].toString(), empid);

        // //fetching Stamp Balance
        await fetchStampBalanceDetails(token, apiEndPoints.fetchStampBalanceAPI,
            list[0]['bo_id'].toString());
      }

      else {
        print('BO is already rolled out..!');
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  fetchBOBalanceDetails(
      String token, String uri, String boid, String empid) async {
    print('inside BO Balance Details..!');
    // boid="BO26106106003";
    // empid="50465276";
    String requestURI = uri + boid;
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(requestURI));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('response from BO Balance API' + response.statusCode.toString());

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print(res);

      //
      // final bobal = OFCMASTERDATA().select().EMPID.equals(empid).
      // update({'OB':'${json.decode(res)[0]['bo_opening_balance']}',
      //   'CASHINHAND':'bo_cashinhand','MINBAL':'bo_authorisedminbal',
      //   'MAXBAL':'bo_authorisedmaxbal','POSTAMPBAL':'bo_authorisedstampbal',
      //   'REVSTAMPBAL':'bo_authorisedrevenuebal','CRFSTAMPBAL':'bo_authorisedcrfbal',
      //   'MAILSCHEDULE':'bo_mail_sheduled','EMOCODE':'${json.decode(res)[0]['emocode']}'
      //   ,'PAIDLEAVE':'emp_paid_leave',
      //   'MATERNITYLEAVE':'emp_meternity_leave','EMGLEAVE':'emp_el_leave'});

      final bobal = await OFCMASTERDATA().select().EMPID.equals(empid).update({
        'OB': '${json.decode(res)[0]['bo_opening_balance']}',
        'CASHINHAND': '${json.decode(res)[0]['bo_cashinhand']}',
        'MINBAL': '${json.decode(res)[0]['bo_authorisedminbal']}',
        'MAXBAL': '${json.decode(res)[0]['bo_authorisedmaxbal']}',
        'POSTAMPBAL': '${json.decode(res)[0]['bo_authorisedstampbal']}',
        'REVSTAMPBAL': '${json.decode(res)[0]['bo_authorisedrevenuebal']}',
        'CRFSTAMPBAL': '${json.decode(res)[0]['bo_authorisedcrfbal']}',
        'MAILSCHEDULE': '${json.decode(res)[0]['bo_mail_sheduled']}',
        'EMOCODE': '${json.decode(res)[0]['emocode']}',
        'PAIDLEAVE': '${json.decode(res)[0]['emp_paid_leave']}',
        'MATERNITYLEAVE': '${json.decode(res)[0]['emp_meternity_leave']}',
        'EMGLEAVE': '${json.decode(res)[0]['emp_el_leave']}',
        'ONETIMECUSTCODE' : '${json.decode(res)[0]['customer_code']}'
      });

      final bobalance = await OFCMASTERDATA().select().toList();
      //
      // print('inserting BO Details from API..!');
      // //Only when BO Rolled out
      // if (bobalance.length == 0) {
      //   print('when BO details are empty');
      final addCash =  CashTable()
        ..Cash_ID = DateTimeDetails().dateCharacter() +
            DateTimeDetails().timeCharacter()
        ..Cash_Date = DateTimeDetails().currentDate()
        ..Cash_Time = DateTimeDetails().onlyTime()
        ..Cash_Type = 'Add'
        ..Cash_Amount = double.parse(bobalance[0].CASHINHAND!)
        ..Cash_Description = 'Opening Balance';
      await addCash.save();
      // }

    } else {
      print(response.reasonPhrase);
    }
  }

  fetchStampBalanceDetails(String token, String uri, String boid) async {
    print('inside Stamp Balance API');
    // boid="BO26106106003";
    String requestURI = uri + boid;
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(requestURI));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print(res);

      List<dynamic> expansionInventoryName = json.decode(res);

      final stampTable = await BagStampsTable().select().toList();
      final productTable = await ProductsTable().select().toList();
      final invtable = await InventoryDailyTable().select().toList();

      //when there is no data available then only inventory will be added
      //code by Rohit on 03-08-2022
      if (productTable.length == 0) {
        if (expansionInventoryName.isNotEmpty) {
          for (int i = 0; i < expansionInventoryName.length; i++) {
            var total = double.parse(expansionInventoryName[i]['denomination'].toString()) * expansionInventoryName[i]['quantity'];

            final addProduct = ProductsTable()
              ..ProductID = expansionInventoryName[i]['item_code']
              ..Name = expansionInventoryName[i]['stamp_name']
              ..Price = double.parse(expansionInventoryName[i]['denomination'].toString()).toString()
              ..Quantity = expansionInventoryName[i]['quantity'].toString()
              ..Value = total.toString();
            addProduct.save();

            // await BaggingDBService().addProductsMain(
            //     expansionInventoryName[i]['stamp_name'],
            //     double.parse(expansionInventoryName[i]['denomination'].toString()),
            //     expansionInventoryName[i]['quantity']);
          }
        }
      }
      if (stampTable.length == 0) {
        if (expansionInventoryName.isNotEmpty) {
          for (int i = 0; i < expansionInventoryName.length; i++) {
            await BaggingDBService().addInventoryFromBagToDB(
                expansionInventoryName[i]['stamp_name'],
                expansionInventoryName[i]['denomination'].toString(),
                expansionInventoryName[i]['quantity'].toString(),
                expansionInventoryName[i]['total_amount'].toString(),
                expansionInventoryName[i]['boid'],
                'Received');
          }
        }
      }
      if (invtable.length == 0) {
        if (expansionInventoryName.isNotEmpty) {
          for (int i = 0; i < expansionInventoryName.length; i++) {
            var total = double.parse(expansionInventoryName[i]['denomination'].toString()) * expansionInventoryName[i]['quantity'];

            final addinv = InventoryDailyTable()
              ..InventoryId = expansionInventoryName[i]['item_code']
              ..StampName = expansionInventoryName[i]['stamp_name']
              ..Price = double.parse(expansionInventoryName[i]['denomination'].toString()).toString()
              ..OpeningQuantity = expansionInventoryName[i]['quantity'].toString()
              ..OpeningValue = total.toString()
              ..ClosingQuantity = expansionInventoryName[i]['quantity'].toString()
              ..ClosingValue = total.toString();
            addinv.save();
          }
        }
      }

    } else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> sendSMS(String empid, String deviceid) async {
    bool rtValue = false;
    print("inside SMS API Function..!");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(otpsmsAPI));
    request.body = json
        .encode({"event": "Login", "empid": "$empid", "deviceid": "$deviceid"});
    request.headers.addAll(headers);
    print('SMS API End Point - '+ otpsmsAPI);
    print('SMS API Request Body - ' + request.body);
    print('SMS API Request Headers - ' + request.headers.toString());
    // print('SMS API End Point - '+ otpsmsAPI);
    http.StreamedResponse response = await request.send();

    print("=======status code=======");
    // print(await response.stream.bytesToString());
    print(response.statusCode);
    // print(await response.stream.bytesToString());

    if (response.statusCode == 200 || response.statusCode == 208) {
      print(await response.stream.bytesToString());
      rtValue = true;
    } else {
      print(response.reasonPhrase);
      rtValue = false;
    }
    return rtValue;
  }

  Future<bool> validateAndSendOTP(String userid, String password) async {
    inactive_user="";
    bool rtValue = false;
    print("inside Validate Credentials API Function..!");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(validationAPI));
    request.body =
        json.encode({"username": "$userid", "password": "$password"});
    request.headers.addAll(headers);
    print('API Request Body - ' + request.body);
    http.StreamedResponse response = await request.send();

    print("=======status code=======");
    print(response.statusCode);
    print(validationAPI);
    // print(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      sendSMS(userid, ""); //Once user is validated send OTP.
      rtValue = true;
    }else if(response.statusCode == 400){
      inactive_user=await response.stream.bytesToString();
      rtValue = false;
    }
    else  {
      print(response.reasonPhrase);
      rtValue = false;
    }
    return rtValue;
  }

  Future<bool> otpVerification(
      String empid, String otp, String deviceid) async {
    bool rtValue = false;
    print("inside SMS API Function..!");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(otpVerificaitonAPI));
    request.body = json.encode({
      "event": "Login",
      "empid": "$empid",
      // "deviceid": "$deviceid",
      "otp": "$otp"
    });
    request.headers.addAll(headers);
    print('SMS API Request Body - ' + request.body);
    http.StreamedResponse response = await request.send();

    print("=======status code=======");
    print(response.statusCode);
    // print(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      // print(await response.stream.bytesToString());
      // copying the response stream to a string and providing to the login function....
      otpVerResponse= await response.stream.bytesToString();
      rtValue = true;
      print(otpVerResponse);
    } else {
      // print(response.reasonPhrase);
      rtValue = false;
      OtpFailText=await response.stream.bytesToString();
      print(OtpFailText);
    }
    print(rtValue);
    return rtValue;
  }

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
      // final thirdContent = values[2];
      // int? l1 = firstContent?.length;
      // int? l2 = secondContent?.length;
      print("...............");

      print(secondContent);
      final otp = secondContent?.substring(1, 7);
      print("otp is - " + otp.toString());
      final smsSign = secondContent?.substring(
          secondContent.length - 7, secondContent.length);
      print("SMS Signature is -" + smsSign.toString());
      if (smsSign.toString() == "INDPOST")
        otpEditingController.text = otp!; // added to read only INDPOST SMS
      setState(() {
        isLoginButtonVisible = true;
        isLoadervisibltyOn = false;
      });
    });
  }
}


_CommonLoginScreenState ls=new _CommonLoginScreenState();
