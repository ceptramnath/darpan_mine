import 'package:darpan_mine/Aadhar/AadharOTP.dart';

class APIEndPoints {
  var gatewayURL = "https://gateway.cept.gov.in";
  // Used in Registration Page URLS not in Live
  var registration = "https://gateway.cept.gov.in/darpan/api/v1/registration";

  final smsAPI = "https://gateway.cept.gov.in/darpan/api/v1/smsotp";
  final otpVerificationAPI =
      "https://gateway.cept.gov.in/darpan/api/v1/verifysmsotp";
// Registration URLS ended

  //final login = "https://gateway.cept.gov.in/darpan/api/v2/token";// Discontinued 27072023

  final refreshToken =
      //"https://gateway.cept.gov.in/darpan/api/v2/refreshtoken";
  "https://gateway.cept.gov.in/darpanprodv3/api/v3/newredisrefreshtoken";
  final fetchUserDetailsAPI =
      //'https://gateway.cept.gov.in/user_registration_details?bpm_id=eq.';
  "https://gateway.cept.gov.in/darpanprodv4/user_registration_details?active_status@@'Active'&bpm_id=eq.";
  final fetchBOBALAPI =
      //'https://gateway.cept.gov.in/bo_balance?bo_id=eq.';
  "https://gateway.cept.gov.in/darpanprodv4/bo_balance?bo_id=eq.";
  final fetchStampBalanceAPI =
      //'https://gateway.cept.gov.in/bo_stamp?boid=eq.';
  "https://gateway.cept.gov.in/darpanprodv4/bo_stamp?boid=eq.";

  // //PRODUCTION URL OLD
  // final cbsURL = "https://gateway.cept.gov.in/darpanenc/api/v1/cbswo";
  // final insURL = "https://gateway.cept.gov.in/darpanenc/api/v1/insurancewo";
  // final fileUpload = "https://gateway.cept.gov.in/signewlive/upload";
  // final fileDownload = "https://gateway.cept.gov.in/signewlive/download";
  // final fileAck ="https://gateway.cept.gov.in/signewlive/ack";


  //UAT URL OLD
  // final cbsURL = "https://gateway.cept.gov.in/cbs/api/v1/cbswo";
  // final cbsURL1 = "https://gateway.cept.gov.in/dcubeuat/api/v2/cbs";

  // final cbsURL = "https://gateway.cept.gov.in/cbs/api/v1/cbswo";
  // final insURL = "https://gateway.cept.gov.in/pli/api/v1/insurancewo";
  // final insURL1 = "https://gateway.cept.gov.in/dcubeuat/api/v2/cbs";
  // final insURL = "https://gateway.cept.gov.in/pli/api/v1/insurancewo";

  //UAT URL New
  final cbsURL = "https://gateway.cept.gov.in/cbs/api/v2/cbswo";
  final insURL = "https://gateway.cept.gov.in/pli/api/v2/insurancewo";
  final fileUpload = "https://gateway.cept.gov.in/signewtest/upload";
  final fileDownload = "https://gateway.cept.gov.in/signewtest/download";
  final fileAck ="https://gateway.cept.gov.in/signewtest/ack";

  //PRODUCTION URL New
  // final cbsURL = "https://gateway.cept.gov.in/cbsp/api/v2/cbswo";
  // final insURL = "https://gateway.cept.gov.in/plip/api/v2/insurancewo";
  // final fileUpload = "https://gateway.cept.gov.in/signewlive/upload";
  // final fileDownload = "https://gateway.cept.gov.in/signewlive/download";
  // final fileAck ="https://gateway.cept.gov.in/signewlive/ack";


  //New API Endpoints for OTP based login and reset password functionality
  final credCheckingAPI =
    //  "https://gateway.cept.gov.in/darpan/api/v1/login"; //API to check Credentials only old
  "https://gateway.cept.gov.in/darpanprodv3/api/v3/login";
  final smsRequestAPI =
     //"https://gateway.cept.gov.in/darpan/api/v1/smsrequest"; //Generic API to send OTP
       "https://gateway.cept.gov.in/darpanprodv3/api/v3/smsrequest";

  final otpVerifyAPI =
     // "https://gateway.cept.gov.in/darpan/api/v1/verifyotp";
  "https://gateway.cept.gov.in/darpanprodv3/api/v3/verifyotp";

  //final tokenAPI = "https://gateway.cept.gov.in/darpan/api/v2/token";//Discontinued on 26072023


  // final getCredAPI =
  //     "https://gateway.cept.gov.in/darpan/api/v1/getcred"; //API to get Credentials
  final resetpassword =
      //"https://gateway.cept.gov.in/darpan/api/v1/resetpassword"; //API to reset Password
  "https://gateway.cept.gov.in/darpanprodv3/api/v3/reset/password";
  final defaultPassword = "Dop@123"; //Default Password for User

  // API for sending Booking SMS
  final bookingSMS =
      "https://gateway.cept.gov.in/darpanprodv3/api/v3/bookingsms";

}
