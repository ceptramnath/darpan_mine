import 'dart:async';
import 'dart:convert';
import 'package:darpan_mine/Aadhar/AadharOTP.dart';
import 'package:darpan_mine/Aadhar/checkAadhar.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/Mails/backgroundoperations.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:darpan_mine/DatabaseModel/uidaiErrCodes.dart';
import '../UtilitiesMainScreen.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import './RegistrationScreen.dart';
import './ResetPasswordScreen.dart';
import '../../HomeScreen.dart';
import '../AlertDialogChecker.dart';
import 'APIEndPoints.dart';
import 'LoginScreen.dart';
import 'LoginScreen_old.dart';
import 'db/registrationdb.dart';

class AadharLoginScreen extends StatefulWidget {
  const AadharLoginScreen({Key? key}) : super(key: key);

  @override
  State<AadharLoginScreen> createState() => _AadharLoginScreenState();
}

int? validtimer;
StreamSubscription<int>? every3seconds;

class _AadharLoginScreenState extends State<AadharLoginScreen> {
  var aadharnum="";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String _usernameError = "";
  String _selectedPaymentMode = 'bio';
  APIEndPoints apiEndPoints = new APIEndPoints();
 // late final loginuri = apiEndPoints.login;
  List<USERLOGINDETAILS> loginDetails = [];
  String access_token = "";
  String refresh_token = "";
  String validity = "";
  bool visiblty = false;
  String aadharresponse="";
  final otpEditingController = TextEditingController();
  bool otpvisibility=false;
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
 (570,'Invalid key info in digital signature (this means that certificate used for signing the OTP request is not valid
it is either expired, or does not belong to the AUA or is not created by a CA).'),
 (940,'Unauthorized ASA channel.'),
 (941,'Unspecified ASA channel.'),
 (400,'"OTP" validation failed.Resident must ensure that the correct OTP value is provided for authentication .'),
 (402,'Technical Issue with AUA Application. AUA Application must follow the'), (950,'Could not generate and/or send OTP.'),
 (952,'OTP Flooding error.'),
 (999,'Unknown error.');""";

      final aadharinsert = await UIDAIErrorCodes().execSQL(resultaadhar);
      print(aadharinsert);
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
                Padding(
                    padding: EdgeInsets.only(
                        top: 150.h, left: 18.w, bottom: 8.h, right: 5.w),
                    child: SizedBox.shrink()),
                SizedBox(
                  height: 180.h,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75.w,
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
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * .75.w,
                    //     child: TextFormField(
                    //       obscureText: true,
                    //       enableSuggestions: false,
                    //       autocorrect: false,
                    //       controller: passwordController,
                    //       style: TextStyle(color: Colors.amberAccent),
                    //       keyboardType: TextInputType.visiblePassword,
                    //       decoration: InputDecoration(
                    //         labelText: "Password",
                    //         hintStyle: TextStyle(
                    //           fontSize: 15,
                    //           color: Color.fromARGB(255, 2, 40, 86),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         border: InputBorder.none,
                    //         enabledBorder: OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 color: Colors.blueGrey, width: 3)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderSide:
                    //             BorderSide(color: Colors.green, width: 3)),
                    //         contentPadding: EdgeInsets.only(
                    //             top: 20, bottom: 20, left: 20, right: 20),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const Space(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Radio<String>(
                              value: 'bio',
                              groupValue: _selectedPaymentMode,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMode = value!;
                                  // otpvisibility=false;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            title: const Text('Bio-Metric',style: TextStyle(color:Colors.white,fontSize: 16)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: Radio<String>(
                              value: 'otp',
                              groupValue: _selectedPaymentMode,
                              onChanged: (value) {
                                setState(() {
                                  // otpvisibility=true;
                                  _selectedPaymentMode = value!;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            title: const Text('Aadhar OTP',style: TextStyle(color:Colors.white,fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => const PdfGenerationScreen()));
                        },
                        child: const Text(
                          "Login using password",
                          style: TextStyle(color: Colors.amberAccent),
                        ),
                      ),
                    ),

                    _selectedPaymentMode=="bio"? Center(
                      child: Button(
                          buttonText: 'LOGIN',
                          buttonFunction: () async{
                            bool netresult =
                            await InternetConnectionChecker()
                                .hasConnection;
    if (netresult) {
      setState(() {
        visiblty = true;
      });
      aadharnum = await getUserDetails();

      // if(_selectedPaymentMode=="bio"){
      aadharresponse =
      // await captureFromDevice(
      //     "891904928556");
      await captureFromDevice(
          aadharnum);
      print(aadharresponse);
      setState(() {
        visiblty = false;
      });

      if (aadharresponse !=
          "y") {
        UtilFsNav.showToast(
            aadharresponse,
            context,
            AadharLoginScreen());
      }
      else {
        bool netresult =
        await InternetConnectionChecker()
            .hasConnection;
        if (netresult) {
          await dataSync.download();
          setState(() {
            visiblty=true;
          });
        }
        else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
            content: Text(
                "Internet connection is not available..!"),
          ));
        }
        final loginDetails = await USERLOGINDETAILS()
            .select()
            .EMPID
            .contains(usernameController.text)
            .toList();
        int validtimer = DateTime.parse(
            loginDetails[0].Validity!)
            .difference(DateTime.now())
            .inSeconds;
        print("Timer validity: $validtimer");
        // every3seconds = Stream<int>.periodic(
        //     Duration(seconds: validtimer),
        //         (t) => t).listen((t) {
        //   showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder:
        //         (BuildContext dialogContext) {
        //       return WillPopScope(
        //         onWillPop: () async => false,
        //         child: MyAlertDialog(
        //           title: 'Title $t',
        //           content: 'Dialog content',
        //         ),
        //       );
        //     },
        //   );
        // });

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainHomeScreen(
                      UtilitiesMainScreen(),
                      0)),
        );


      }
      // }
      // else{
      //   aadharresponse= await aadharOTP().getOTP("891904928556");
      // }

    }
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(
            "Internet connection is not available..!"),
      ));
    }
                          }
                          ),
                    ):Center(
                      child: Button(
                          buttonText: 'Get OTP',
                          buttonFunction: () async {
                            bool netresult =
                            await InternetConnectionChecker()
                                .hasConnection;
                            if (netresult) {
                              setState(() {
                                visiblty = true;
                              });
                              aadharnum = await getUserDetails();
                              // aadharnum='89190492';
                              print("Aadhar Number received: $aadharnum");
                              List aresponse = await aadharOTP().getOTP(
                                  aadharnum);
                              setState(() {
                                visiblty = false;
                              });
                              aadharresponse = aresponse[1];
                              if (aresponse[0] == "y") {
                                setState(() {
                                  otpvisibility = true;
                                });
                              }
                              else if (aresponse[0] == "n"){
                                print(aresponse[2]);
                                  List<Aadhar_OTP_ErrCode> errresponse=await Aadhar_OTP_ErrCode().select().API_Err_code.equals(aresponse[2]).toList();
                                  UtilFsNav.showToast(
                                      errresponse[0].Description!,
                                      context,
                                      AadharLoginScreen());
                              }
                            }
                            else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Internet connection is not available..!"),
                              ));
                            }
                          }
                      ),
                    ),


                    Visibility(
                      visible: otpvisibility,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PinCodeTextField(
                              appContext: context,
                              // readOnly: true,
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
                    ),
                    Visibility(
                      visible: otpvisibility,
                      child: Center(
                        child: Button(
                            buttonText: 'Login',
                            buttonFunction: () async{

                              // // if(_selectedPaymentMode=="bio"){
                              // aadharresponse =
                              // await captureFromDevice(
                              //     "891904928556");
                              // print(aadharresponse);
                              // }
                              // else{
                              setState(() {
                                visiblty=true;
                              });
                              List otpResponse= await aadharOTP().verifyOTP(otpEditingController.text,aadharresponse,aadharnum);
                              setState(() {
                                visiblty=false;
                              });
                              if(otpResponse[0]=="y"){

                                bool netresult =
                                await InternetConnectionChecker()
                                    .hasConnection;
                                if (netresult) {
                                  await dataSync.download();
                                  setState(() {
                                    visiblty=true;
                                  });
                                }
                                else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Internet connection is not available..!"),
                                  ));
                                }
                                final loginDetails = await USERLOGINDETAILS()
                                    .select()
                                    .EMPID
                                    .contains(usernameController.text)
                                    .toList();
                                int validtimer = DateTime.parse(
                                    loginDetails[0].Validity!)
                                    .difference(DateTime.now())
                                    .inSeconds;
                                print("Timer validity: $validtimer");
                                // every3seconds = Stream<int>.periodic(
                                //     Duration(seconds: validtimer),
                                //         (t) => t).listen((t) {
                                //   showDialog(
                                //     barrierDismissible: false,
                                //     context: context,
                                //     builder:
                                //         (BuildContext dialogContext) {
                                //       return WillPopScope(
                                //         onWillPop: () async => false,
                                //         child: MyAlertDialog(
                                //           title: 'Title $t',
                                //           content: 'Dialog content',
                                //         ),
                                //       );
                                //     },
                                //   );
                                // });
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainHomeScreen(
                                                        UtilitiesMainScreen(),
                                                        0)),
                                          );
                              }

                              // if (otpResponse[0] == "y") {
                              //   setState(() {
                              //     otpvisibility = true;
                              //   });
                              // }
                              else if (otpResponse[0] == "n"){
                                print(otpResponse[2]);
                                List<Aadhar_OTP_ErrCode> errresponse=await Aadhar_OTP_ErrCode().select().API_Err_code.equals(otpResponse[2]).toList();
                                UtilFsNav.showToast(
                                    errresponse[0].Description!,
                                    context,
                                    AadharLoginScreen());
                              }
                              // }

                            }
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        visiblty == true
            ? Center(
            child: Loader(
                isCustom: true, loadingTxt: 'Please Wait...Loading...'))
            : const SizedBox.shrink()
      ],
    );
  }

  Future<String> getUserDetails() async{
    final loginDetails =
    await USERLOGINDETAILS()
        .select()
        .toList();
    var aadhar=await LoginAPI("",
        loginDetails[0].EMPID!,
        loginDetails[0].Password!);
    print(aadhar);
    return aadhar;
  }
  Future<String> LoginAPI(String loginuri, String username, String password) async {
    String aadhar="";
   //bool rtValue = false;
    // var headers = {'Content-Type': 'application/json'};
    // var request = http.Request('POST', Uri.parse(loginuri));
    // request.body =
    //     json.encode({"username": "$username", "password": "$password"});
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   String responseContent = await response.stream.bytesToString();
    //   print("Login response*******************************");
    //   print(responseContent);
    //   var validityTimer = jsonDecode(responseContent)['expires_in'];
    //   print(jsonDecode(responseContent)['expires_in']);
    //   print(DateTime.now().add(Duration(seconds: validityTimer)).toString());
    //   print(responseContent);
    //   access_token = jsonDecode(responseContent)["access_token"];
    //   refresh_token = jsonDecode(responseContent)["refresh_token"];
    //
    //   //Storing Access token in local DB.
    //   if (access_token.isNotEmpty || access_token != null) {
    //     await USERLOGINDETAILS().select().delete();
    //
    //     final logindetails = USERLOGINDETAILS()
    //       ..EMPID = username
    //       ..AccessToken = access_token
    //     // ..Validity =
    //     //     DateTime.now().add(Duration(seconds: validityTimer)).toString
    //       ..Active = true
    //       ..Validity =
    //       DateTime.now().add(Duration(seconds: validityTimer)).toString()
    //     // ..DeviceID="891904928556"
    //       ..Password = password;
    //     logindetails.save();
    //   }
      /*
      String validityTime = jsonDecode(responseContent)["expires_in"].toString();
      DateTime now = DateTime.now();
      validity = DateFormat('yyyy-MM-dd – kk:mm').format(now) + validity;

       */
      // String error = " ";
      // try {
      //   error = jsonDecode(responseContent)["error"];
      // } catch (e) {
      //   print("Error DKSjf");
      //   print(e);
      // }

      // print("Response is - " + responseContent);
      // print(access_token);
      // print(error);
      //
      // if (error == "invalid_grant")
      //   rtValue = false;
      // else if (access_token.isNotEmpty) {
        // rtValue = true;
    final loginDetail = await USERLOGINDETAILS().select().toList();
    bool rtValue = ls.JwtCheck(loginDetail);
    print('JWT Function return value - ' +
        rtValue.toString());
    //when token is not valid getting token using refresh token
    bool value = false;
    if (!rtValue) {
      var ret= ls.Token_RefreshToken();
    }
        final loginDetails =  await USERLOGINDETAILS().select().toList();

        final ofcMaster1 = await OFCMASTERDATA()
            .select()
            .toCount();

       aadhar= await fetchUserDetails(loginDetails[0].AccessToken.toString(),
            apiEndPoints.fetchUserDetailsAPI,
           loginDetails[0].EMPID!);
       print("Aadhar is : $aadhar");
       return aadhar;
     // }
    // } else {
    //   print(response.reasonPhrase);
    //   rtValue = false;
    // }

    //return aadhar;
  }

  fetchUserDetails(String token, String uri, String empid) async {
    print('inside Fetch User Details');
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


      // when data is available delete existing data

      // await OFCMASTERDATA().select().delete();

      // await USERDETAILS().select().EMPID.equals(empid).update({'BOFacilityID':'${list[0]['bo_id']}'});
      await USERDETAILS(EMPID: empid, BOFacilityID: list[0]['bo_id']).upsert();
      int ofccount = await OFCMASTERDATA().select().toCount();
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

        await ofcMaster.save();

        final ofcMaster1 =
        await OFCMASTERDATA()
            .select()
            .toCount();

          // fetching BO Balance

          await fetchBOBalanceDetails(token, apiEndPoints.fetchBOBALAPI,
              list[0]['bo_id'].toString(), empid);

          //fetching Stamp Balance
          await fetchStampBalanceDetails(
              token, apiEndPoints.fetchStampBalanceAPI,
              list[0]['bo_id'].toString());


      } else {
        print('BO is already rolled out..!');
      }
      return list[0]['id_proof_no'];
    } else {
      print(response.reasonPhrase);
    }
  }

  fetchBOBalanceDetails(
      String token, String uri, String boid, String empid) async {
    print('inside BO Balance Details..!');
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


    } else {
      print(response.reasonPhrase);
    }
  }


}

// _AadharLoginScreenState ls=new _AadharLoginScreenState();