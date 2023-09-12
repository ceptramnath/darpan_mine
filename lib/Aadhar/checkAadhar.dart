import 'dart:async';
import 'dart:convert';

import 'package:darpan_mine/DatabaseModel/uidaiErrCodes.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rdservice/rdservice.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

import 'AuthReqnew.dart';
import 'BsnlAuaReq.dart';
import 'Device.dart';
import 'Uses.dart';
import 'Validation.dart';

Future<void> initDevice() async {
  RDService? result;
  try {
    result = await Msf100.getDeviceInfo();
  } on PlatformException catch (e) {
    // if (mounted) {
    //   setState(() {
    //     _platformVersion = e.message ?? 'Unknown exception';
    //   });
    // }
    return;
  }
  // if (!mounted) return;
  //
  // setState(() {
  //   _platformVersion = result?.status ?? "Unknown";
  // });
}

Future<String> captureFromDevice(String UID) async {
  RDService? rdsresult;
  rdsresult = await Msf100.getDeviceInfo();

  print("RDS Result");
  print(rdsresult?.isReady);
  // await initDevice();
  PidData? result;

  var now = DateTime.now();

  if (rdsresult?.isReady == true) {
    try {
      result = await Msf100.capture();
      print(result);
      print(result!.deviceInfo.rdsVer);
      DeviceInfo deviceInfo = result.deviceInfo;

      ValidationData validationData = new ValidationData();
      validationData.param1 = "NA";
      validationData.param2 = "NA";
      validationData.param3 = "NA";
      validationData.param4 = "NA";

      Uses uses = new Uses();
      uses.bio = "y";
      // uses.bt = "FMR"; // “FMR”, “FIR”, “IIR” and “FID”.
      uses.bt = "FIR,FMR";
      uses.otp = "n";
      uses.pi = "n";
      uses.pa = "n";
      uses.pfa = "n";
      uses.pin = "n";

      Device device = new Device();
      device.dc = deviceInfo.dc;
      device.dpId = deviceInfo.dpId;
      device.mc = deviceInfo.mc;
      device.mi = deviceInfo.mi;
      device.rdsId = deviceInfo.rdsId;
      device.rdsVer = deviceInfo.rdsVer;

      AuthReqNew authReqNew = new AuthReqNew();
      authReqNew.ac = "0000140000";
      // authReqNew.lk = "MG02Qtqiq2xV7X872eBM_ygiArYevvb0Hgbe35kmY_Mk6KcDK5JqwwU";
      authReqNew.lk = "MFiARCxlmxNoAD_93D01hf_Ads187_Ra92yzEs81mFjRx2T-QiGKFKQ";
      authReqNew.rc = "Y";
      authReqNew.sa = "0000140000";
      authReqNew.tid =
          "registered"; // In UIDAI 2.5, should be "registered" , in previous it is "public"
      authReqNew.txn = DateFormat("yyyyMMddHHmmss").format(now);
      authReqNew.uid = "$UID";
      // authReqNew.uid       = "809668373823";
      authReqNew.ver = "2.5";
      authReqNew.uses = uses;
      authReqNew.device = device;
      authReqNew.sKey = result.skey;
      authReqNew.data = result.data;
      authReqNew.Hmac = result.hmac;

      BsnlAuaReq bsnlAuaReq = new BsnlAuaReq();
      bsnlAuaReq.validationData = validationData;
      bsnlAuaReq.authReqNew = authReqNew;

      final builder = XmlBuilder();
      builder.element('BsnlAuaRequest', nest: () {
        builder.element('Auth', nest: () {
          builder.attribute('uid', "${authReqNew.uid}");
          builder.attribute('rc', "${authReqNew.rc}");
          builder.attribute('tid', "${authReqNew.tid}");
          builder.attribute('ac', "${authReqNew.ac}");
          builder.attribute('sa', "${authReqNew.sa}");
          builder.attribute('ver', "${authReqNew.ver}");
          builder.attribute('txn', "${authReqNew.txn}");
          builder.attribute('lk', "${authReqNew.lk}");
          builder.element('Hmac', nest: () {
            builder.text(result!.hmac);
          });
          builder.element('Data', nest: () {
            builder.attribute('type', "${result!.data.type}");
            builder.text(result.data.value);
          });
          builder.element('Device', nest: () {
            builder.attribute('rdsId', "${device.rdsId}");
            builder.attribute('rdsVer', "${device.rdsVer}");
            builder.attribute('dpId', "${device.dpId}");
            builder.attribute('dc', "${device.dc}");
            builder.attribute('mi', "${device.mi}");
            builder.attribute('mc', "${device.mc}");
          });
          builder.element('Skey', nest: () {
            builder.attribute('ci', "${result!.skey.ci}");
            builder.text(result.skey.value);
          });
          builder.element('Uses', nest: () {
            builder.attribute('pi', "${uses.pi}");
            builder.attribute('pa', "${uses.pa}");
            builder.attribute('pfa', "${uses.pfa}");
            builder.attribute('bio', "${uses.bio}");
            builder.attribute('bt', "${uses.bt}");
            builder.attribute('pin', "${uses.pin}");
            builder.attribute('otp', "${uses.otp}");
          });
        });
        builder.element('ValidationData', nest: () {
          builder.element('param1', nest: () {
            builder.text("NA");
          });
          builder.element('param2', nest: () {
            builder.text("NA");
          });
          builder.element('param3', nest: () {
            builder.text("NA");
          });
          builder.element('param4', nest: () {
            builder.text("NA");
          });
        });
      });

      final document = builder.buildDocument();

      var headers = {
        'KEY':
            'ch242e1d7d75818da955ee525903a69a84132280e43e8ff2efa500a43a83dc14',
        'Content-Type': 'application/xml',
        'Accept': 'application/xml',
      };

      var request = http.Request(
          'POST',
          Uri.parse(
              'https://dopauth.in/EcafRestService/AUA_Authenticate_Remote/'));
      request.headers.addAll(headers);
      request.body = '''${document.toXmlString(pretty: true)}''';

      print("Aadhar Bio-metric Request");
      print(request.toString());
      print("==============");
      print(request.body.toString());
      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        print(res);

        Xml2Json xml2json = new Xml2Json();
        xml2json.parse(res);

        String a = xml2json.toBadgerfish();
        Map t = json.decode(a);
        print(t);
        print(t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@ret']);

        String AUAResponse =
            t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@ret'];
        String AUATxnResponse =
            t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@txn'];

        if (AUAResponse == "n" || AUAResponse == 'N') {
          String AUAErrorResponse =
              t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@err'];
          print("Failed with error code: $AUAErrorResponse");
          if(AUAErrorResponse=="565"){
            print("Hit API for fetching new License Key");
          }
          var errorresp = await API_Errcode()
              .select()
              .API_Err_code
              .equals(AUAErrorResponse)
              .toList();
          print(errorresp.length);
          print("${errorresp[0].Description} ${errorresp[0].Suggestion}");
          return "${errorresp[0].Description} ${errorresp[0].Suggestion}";
        } else if ((AUAResponse == "y" || AUAResponse == 'Y') &&
            AUATxnResponse == authReqNew.txn) {
          print("Success");
          return 'y';
        } else {
          String AUAErrorResponse =
              t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@err'];
          print("Failed with error code: $AUAErrorResponse");
          var errorresp = await API_Errcode()
              .select()
              .API_Err_code
              .equals(AUAErrorResponse)
              .toList();
          return "${errorresp[0].Description} ${errorresp[0].Suggestion}";
        }
      } else {
        String res = await response.stream.bytesToString();
        var ares = res.split("<h1>");
        var ares1 = ares[1].split("</h1>");
        String r1 = ares1[0];
        var ares2 = ares1[1].split("</body>");
        String r2 = ares2[0];

        print("r1");
        print(r1);
        print("r2");
        print(r2);

        return "$r1\n$r2";
      }
    } on PlatformException catch (e) {
      // if (mounted) {
      //   setState(() {
      //     _platformVersion = e.message ?? 'Unknown exception';
      //   });
      // }
      return "";
    }
  } else {
    // UtilFs.showToast("Device is not Ready. Please check the Connected device or Proceed with other mode of payment",context);
    return "Bio-metric Device is not Ready. Please check the Connected device or Proceed with other mode of payment";
  }
  // if (!mounted) return;

  // setState(() {
  //   _platformVersion = result?.resp.errInfo ?? 'Unknown Error';
  // });
}
