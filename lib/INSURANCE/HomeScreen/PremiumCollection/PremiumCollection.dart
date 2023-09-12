import 'dart:convert';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:path_provider/path_provider.dart';
import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import '../HomeScreen.dart';
import 'InitialPremiumCollection.dart';

import 'PremiumCollectionpolicyDetails.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

import 'dupreceipt.dart';

class PremiumCollection extends StatefulWidget {
  @override
  _PremiumCollectionState createState() => _PremiumCollectionState();
}

class _PremiumCollectionState extends State<PremiumCollection> {
  final List<String> _services = [
    "Collection",
    "Receipt Cancellation",
    "Print Duplicate"
  ];
  final List<String> _receiptservices = [
    "Renewal",
    "Loan",
    "Initial Premium",
    "Miscellaneous"
  ];
  String _selectedValue = "Collection";
  String _selectedservice = "Renewal";
  bool collection = true;
  bool nextcollection = false;
  bool premiumCollection = false;
  TextEditingController policyno = new TextEditingController();
  TextEditingController proposalno = new TextEditingController();
  Map main = {};
  Map mainProposal = {};
  int _selectedIndex = 0;
  int _selectedreceipt = 0;
  bool firstDivider = true;
  bool secondDivider = true;
  bool _isLoading = false;
  bool dupprint = false;
  bool displaydupPrint = false;
  bool renewPrem = true;
  bool initPrem = false;
  List receipts = [];
  String? selectedReceipt;
  String? encheader;
  List dupprintlist = [];
  int id = 1;
  late Directory d;
  late String cachepath;

  @override
  void initState() {
    super.initState();
    getCacheDir();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
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
            resizeToAvoidBottomInset: false,

            // backgroundColor: Colors.transparent,
            backgroundColor: Color(0xFFEEEEEE),
            appBar: AppBar(
              title: Text("Premium Collection"),

              backgroundColor: ColorConstants.kPrimaryColor,
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 15.0),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Collection Mode",
                                  style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 7,
                              child: Column(
                                children: [
                                  Padding(
                                    // padding: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 2.0),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(width: 0.5,),
                                        Text(
                                          "Collection",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.blueGrey),
                                        ),
                                        CupertinoSwitch(
                                            // thumbColor: Colors.yellow,
                                            //   activeColor: Colors.redAccent,
                                            value: collection,
                                            onChanged: (value) {
                                              collection = value;
                                              if (collection == true) {
                                                setState(() {
                                                  dupprint = false;
                                                  renewPrem = true;
                                                  initPrem = false;
                                                });
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.8,
                                  ),
                                  Padding(
                                    // padding: const EdgeInsets.all(5.0),
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 5.0,
                                        right: 5.0,
                                        bottom: 2.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Print Duplicate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                              color: Colors.blueGrey),
                                        ),
                                        CupertinoSwitch(
                                            value: dupprint,
                                            onChanged: (value) {
                                              dupprint = value;
                                              if (dupprint == true) {
                                                setState(() {
                                                  policyno.text = "";
                                                  collection = false;
                                                  renewPrem = false;
                                                  initPrem = false;
                                                });
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: collection,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: collection,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 2.0, left: 15.0),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Collection Type",
                                    style: TextStyle(
                                        color: Colors.blueGrey[300],
                                        fontSize: 18),
                                  )),
                            ),
                          ),
                          Visibility(
                            visible: collection,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 7,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Renewal Premium",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                                color: Colors.blueGrey),
                                          ),
                                          CupertinoSwitch(
                                              value: renewPrem,
                                              onChanged: (value) {
                                                renewPrem = value;
                                                if (renewPrem == true) {
                                                  setState(() {
                                                    policyno.text = "";
                                                    initPrem = false;
                                                  });
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Initial Premium",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17,
                                                color: Colors.blueGrey),
                                          ),
                                          CupertinoSwitch(
                                              value: initPrem,
                                              onChanged: (value) {
                                                initPrem = value;
                                                if (initPrem == true) {
                                                  setState(() {
                                                    policyno.text = "";
                                                    renewPrem = false;
                                                  });
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 1.0,
                            ),
                          ),
                          SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                renewPrem == true
                                    ? Container(
                                  width:
                                  MediaQuery.of(context).size.width * .95,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(90.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0.5, left: 15.0),
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500),
                                      controller: policyno,
                                      textCapitalization:
                                      TextCapitalization.characters,
                                      decoration: const InputDecoration(
                                        // fillColor: Colors.white,
                                        // filled: true,
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        // border: OutlineInputBorder(
                                        //
                                        //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        //   borderSide: BorderSide.none,
                                        // ),
                                        border: InputBorder.none,
                                        labelText: "Enter Policy No.",
                                        labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(),
                                initPrem == true
                                    ? Container(
                                  width:
                                  MediaQuery.of(context).size.width * .95,
                                  child: TextFormField(
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: //Colors.white,
                                        Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: proposalno,
                                    textCapitalization:
                                    TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(90.0)),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelText: "Enter Proposal No.",
                                      labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                )
                                    : Container(),
                                dupprint == true
                                    ? Container(
                                  width:
                                  MediaQuery.of(context).size.width * .95,
                                  child: TextFormField(
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: //Colors.white,
                                        Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: policyno,
                                    textCapitalization:
                                    TextCapitalization.characters,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(90.0)),
                                        borderSide: BorderSide.none,
                                      ),
                                      labelText: "Enter Policy/Proposal No.",
                                      labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    thickness: 1.0,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    style: ButtonStyle(
                                      // elevation:MaterialStateProperty.all(),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(18.0),
                                                side:
                                                BorderSide(color: Colors.red)))),
                                    child: Text(
                                      "Search",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                      print("Renew Prem;$renewPrem");
                                      print("DUP PRINT: $dupprint");
                                      if (renewPrem == true) {
                                        if (policyno.text.length != 0) {
                                          _showLoadingIndicator();
                                          var fetchpendingstatus=await DAY_TRANSACTION_REPORT().select().POLICY_NO.equals(policyno.text).and.startBlock.STATUS.equals("PENDING").endBlock.toList();
                                          if(fetchpendingstatus.length==0){
                                          encheader = await encryptwriteContent();
                                          // var headers = {
                                          //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                          // };
                                          // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/searchPolicy'));
                                          // request.files.add(await http.MultipartFile.fromPath('','$cachepath/fetchAccountDetails.txt'));
                                          // request.headers.addAll(headers);
                                          // print("request: ");
                                          // print(request);
                                          try {
                                            var headers = {
                                              'Signature': '$encheader',
                                              'Uri': 'searchPolicy',
                                              // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                              'Authorization':
                                              'Bearer ${acctoken[0].AccessToken}',
                                              'Cookie':
                                              'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                            };


                                            final File file = File('$cachepath/fetchAccountDetails.txt');
                                            String tosendText = await file.readAsString();
                                            var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
                                            request.body=tosendText;
                                            request.headers.addAll(headers);
                                            http.StreamedResponse response =
                                            await request.send().timeout(
                                                const Duration(seconds: 65),
                                                onTimeout: () {
                                                  // return UtilFs.showToast('The request Timeout',context);
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  throw 'TIMEOUT';
                                                });
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            if (response.statusCode == 200) {
                                              // print(await response.stream.bytesToString());
                                              var resheaders = response.headers;
                                              print("Response Headers");
                                              print(resheaders['authorization']);
                                              // List t = resheaders['authorization']!
                                              //     .split(", Signature:");
                                              String temp = resheaders['authorization']!;
                                              String decryptSignature = temp;

                                              String res = await response.stream
                                                  .bytesToString();
                                              print(res);
                                              String val = await decryption1(
                                                  decryptSignature, res);
                                              if (val == "Verified!") {
                                                await LogCat().writeContent(
                                                    '$res');
                                                print(res);
                                                print("\n\n");
                                                Map a = json.decode(res);
                                                print("Map a: $a");
                                                print(
                                                    a['JSONResponse']['jsonContent']);
                                                String data =
                                                a['JSONResponse']['jsonContent'];
                                                main = json.decode(data);
                                                print("Values");
                                                // print(main['renewalAmount']);
                                                print(main['Response_No']);
                                                // Map data=json.decode(a);
                                                // print("JSON: ${data}");

                                                if (main['Status'] == "FAILURE") {
                                                  if(main['Response_No']!=null) {
                                                    List<INS_ERROR_CODES> res =
                                                    await INS_ERROR_CODES()
                                                        .select()
                                                        .Error_code
                                                        .startsWith(
                                                        main['Response_No'])
                                                        .toList();
                                                    UtilFsNav.showToast(
                                                        "${res[0]
                                                            .Error_message}",
                                                        context,
                                                        PremiumCollection());
                                                  }
                                                  else{
                                                    UtilFsNav.showToast(
                                                        main['errorMsg'],
                                                        context,
                                                        PremiumCollection());
                                                  }
                                                } else {
                                                  if (main['Response_No'] != null) {
                                                    List<INS_ERROR_CODES> res =
                                                    await INS_ERROR_CODES()
                                                        .select()
                                                        .Error_code
                                                        .startsWith(
                                                        main['Response_No'])
                                                        .toList();
                                                    UtilFsNav.showToast(
                                                        "${res[0].Error_message}",
                                                        context,
                                                        PremiumCollection());
                                                  } else
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                RenewalPremiumCollection(
                                                                    main[
                                                                    'RISKCOMMENCEMENTDATE'],
                                                                    main[
                                                                    'PAYMENTCATEGORY'],
                                                                    policyno.text,
                                                                    main[
                                                                    'policyname'],
                                                                    main[
                                                                    'paidtodate'],
                                                                    main[
                                                                    'billtodate'],
                                                                    main['freq'],
                                                                    main[
                                                                    'premiumdueamt'],
                                                                    main['carrid'])));
                                                }
                                              } else {
                                                UtilFsNav.showToast(
                                                    "Signature Verification Failed! Try Again",
                                                    context,
                                                    PremiumCollection());
                                                await LogCat().writeContent(
                                                    'Renewal Premium Collection Search: Signature Verification Failed.');
                                              }
                                            } else {
                                              print("Error is");
                                              print(response.statusCode);
                                              print(await response.stream
                                                  .bytesToString());
                                              // UtilFsNav.showToast(
                                              //     response.reasonPhrase!,
                                              //     context,
                                              //     PremiumCollection());
                                              print(response.statusCode);
                                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                              if(response.statusCode==503 || response.statusCode==504){
                                                UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,PremiumCollection());
                                              }
                                              else
                                                UtilFsNav.showToast(error[0].Description.toString(), context,PremiumCollection());
                                            }
                                          } catch (_) {
                                            if (_.toString() == "TIMEOUT") {
                                              return UtilFsNav.showToast(
                                                  "Request Timed Out",
                                                  context,
                                                  PremiumCollection());
                                            }
                                          }
                                          }
                                          else{
                                            UtilFsNav.showToast("For the policy number entered, previous transaction performed is in pending state. Please perform Transaction update on the policy and proceed further", context, PremiumCollection());
                                          }
                                        } else
                                          UtilFs.showToast(
                                              "Please Enter Policy No.", context);
                                      } else if (initPrem == true) {
                                        if (proposalno.text.length != 0) {
                                          var fetchpendingstatus=await DAY_TRANSACTION_REPORT().select().PROPOSAL_NUM.equals(proposalno.text).and.startBlock.STATUS.equals("PENDING").endBlock.toList();
                                          if(fetchpendingstatus.length==0){
                                            encheader =
                                            await writeProposalContent();
                                            _showLoadingIndicator();
                                            // var headers = {
                                            //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                            // };
                                            // var request = http.Request('POST', Uri.parse('http://gateway.cept.gov.in:8080/pli/getProposalDetails'));
                                            // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                            // request.headers.addAll(headers);
                                            try {
                                              var headers = {
                                                'Signature': '$encheader',
                                                'Uri': 'getProposalDetails',
                                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                'Authorization':
                                                'Bearer ${acctoken[0]
                                                    .AccessToken}',
                                                'Cookie':
                                                'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                              };


                                              final File file = File('$cachepath/fetchAccountDetails.txt');
                                              String tosendText = await file.readAsString();
                                              var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
                                              request.body=tosendText;
                                              request.headers.addAll(headers);

                                              http.StreamedResponse response =
                                              await request.send().timeout(
                                                  const Duration(seconds: 65),
                                                  onTimeout: () {
                                                    // return UtilFs.showToast('The request Timeout',context);
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    throw 'TIMEOUT';
                                                  });
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              if (response.statusCode == 200) {
                                                // print(await response.stream.bytesToString());
                                                var resheaders = response
                                                    .headers;
                                                print("Response Headers");
                                                print(
                                                    resheaders['authorization']);
                                                // List t = resheaders['authorization']!
                                                //     .split(", Signature:");
    String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                                String res = await response
                                                    .stream
                                                    .bytesToString();
                                                print(res);
                                                String val = await decryption1(
                                                    decryptSignature, res);
                                                if (val == "Verified!") {
                                                  await LogCat().writeContent(
                                                    '$res');
                                                  print(res);
                                                  print("\n\n");
                                                  Map a = json.decode(res);
                                                  print("Map a: $a");
                                                  print(
                                                      a['JSONResponse']['jsonContent']);
                                                  String data =
                                                  a['JSONResponse']['jsonContent'];
                                                  mainProposal =
                                                      json.decode(data);
                                                  print("Values");
                                                  print(mainProposal[
                                                  'planned_initial_premium']);
                                                  if (mainProposal['Status'] ==
                                                      "FAILURE") {
                                                    UtilFsNav.showToast(
                                                        "No Records Found",
                                                        context,
                                                        PremiumCollection());
                                                  }
                                                  // else if(mainProposal['policy_number']!=""){
                                                  //   UtilFs.showToast("")
                                                  // }
                                                  else {
                                                    if (mainProposal['responseCode'] != null) {
                                                      List<INS_ERROR_CODES> res =
                                                      await INS_ERROR_CODES()
                                                          .select()
                                                          .Error_code
                                                          .startsWith(
                                                          mainProposal['responseCode'])
                                                          .toList();
                                                      UtilFsNav.showToast(
                                                          "${res[0].Error_message}",
                                                          context,
                                                          PremiumCollection());
                                                    }
                                                    else
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                InitialPremiumCollection(
                                                                    proposalno
                                                                        .text,
                                                                    mainProposal[
                                                                    'full_NAME'],
                                                                    mainProposal[
                                                                    'checkin_date'],
                                                                    mainProposal[
                                                                    'planned_initial_premium']
                                                                        .toString(),
                                                                    mainProposal[
                                                                    'carrier_CODE'])));
                                                  }
                                                } else {
                                                  UtilFsNav.showToast(
                                                      "Signature Verification Failed! Try Again",
                                                      context,
                                                      PremiumCollection());
                                                  await LogCat().writeContent(
                                                      '${DateTimeDetails()
                                                          .currentDateTime()} :Initial Premium Collection Search Screen: Signature Verification Failed.\n\n');
                                                }
                                              } else {
                                                // UtilFsNav.showToast(
                                                //     "${response
                                                //         .reasonPhrase} \n ${await response
                                                //         .stream
                                                //         .bytesToString()}",
                                                //     context,
                                                //     PremiumCollection());
                                                // UtilFs.showToast(
                                                //     "${response.reasonPhrase}",
                                                //     context);
                                                print(response.statusCode);
                                                List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                if(response.statusCode==503 || response.statusCode==504){
                                                  UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,PremiumCollection());
                                                }
                                                else
                                                  UtilFsNav.showToast(error[0].Description.toString(), context,PremiumCollection());
                                              }
                                            } catch (_) {
                                              if (_.toString() == "TIMEOUT") {
                                                return UtilFsNav.showToast(
                                                    "Request Timed Out",
                                                    context,
                                                    PremiumCollection());
                                              } else
                                                print(_);
                                            }
                                          }
                                          else{
                                          UtilFsNav.showToast("For the Proposal number entered, previous transaction performed is in pending state. Please perform Transaction update on the policy and proceed further", context, PremiumCollection());
                                        }
                                        } else
                                          UtilFs.showToast(
                                              "Please Enter Proposal No.", context);
                                      } else if (dupprint == true) {
                                        receipts.clear();
                                        dupprintlist.clear();
                                        if (policyno.text.length > 0) {
                                          setState(() {
                                            displaydupPrint = false;
                                          });
                                          _showLoadingIndicator();
                                          encheader = await encryptwriteDupContent();
                                          // var headers = {
                                          //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                          // };
                                          // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/fetchRecieptList'));
                                          // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                          // request.headers.addAll(headers);
                                          // print("request: ");
                                          // print(request);
                                          try {
                                            var headers = {
                                              'Signature': '$encheader',
                                              'Uri': 'fetchRecieptList',
                                              // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                              'Authorization':
                                              'Bearer ${acctoken[0].AccessToken}',
                                              'Cookie':
                                              'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                            };


                                            final File file = File('$cachepath/fetchAccountDetails.txt');
                                            String tosendText = await file.readAsString();
                                            var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
                                            request.body=tosendText;
                                            request.headers.addAll(headers);
                                            http.StreamedResponse response =
                                            await request.send().timeout(
                                                const Duration(seconds: 65),
                                                onTimeout: () {
                                                  // return UtilFs.showToast('The request Timeout',context);
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  throw 'TIMEOUT';
                                                });
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            if (response.statusCode == 200) {
                                              // print(await response.stream.bytesToString());
                                              var resheaders = response.headers;
                                              print("Response Headers");
                                              print(resheaders['authorization']);
                                              // List t = resheaders['authorization']!
                                              //     .split(", Signature:");
                                              String temp = resheaders['authorization']!;
                                              String decryptSignature = temp;

                                              String res = await response.stream
                                                  .bytesToString();
                                              print(res);
                                              String val = await decryption1(
                                                  decryptSignature, res);
                                              if (val == "Verified!") {
                                                await LogCat().writeContent(
                                                    '$res');
                                                Map a = json.decode(res);
                                                print(
                                                    a['JSONResponse']['jsonContent']);
                                                String data =
                                                a['JSONResponse']['jsonContent'];
                                                main = json.decode(data);
                                                print("Values");
                                                print(main);
                                                print(main['responseCode']);
                                                if (main['Status'] == "FAILURE") {
                                                  UtilFsNav.showToast(
                                                      "${main['errorMsg']}",
                                                      context,
                                                      PremiumCollection());
                                                } else {
                                                  if (main['responseCode'] == null) {
                                                    receipts = main['receiptDetails'];
                                                    print(receipts.length);
                                                    for (int i = 0;
                                                    i < receipts.length;
                                                    i++) {
                                                      print(receipts[i]
                                                      ['receiptNumber']);
                                                      // dupprintlist.add(receipts[i]['receiptNumber']);
                                                    }
                                                    setState(() {
                                                      displaydupPrint = true;
                                                    });
                                                  } else {
                                                    List<INS_ERROR_CODES> res =
                                                    await INS_ERROR_CODES()
                                                        .select()
                                                        .Error_code
                                                        .startsWith(
                                                        main['responseCode'])
                                                        .toList();
                                                    print(res.length);
                                                    // print(res[0]);
                                                    UtilFsNav.showToast(
                                                        "${res[0].Error_message}",
                                                        context,
                                                        PremiumCollection());
                                                  }
                                                }
                                              } else {
                                                UtilFsNav.showToast(
                                                    "Signature Verification Failed! Try Again",
                                                    context,
                                                    PremiumCollection());
                                                await LogCat().writeContent(
                                                    'Duplicate Receipt Print Sceen Policy search: Signature Verification Failed.');
                                              }
                                            } else {
                                              // UtilFsNav.showToast(
                                              //     "${await response.stream.bytesToString()}",
                                              //     context,
                                              //     PremiumCollection());
                                              // print(await response.stream
                                              //     .bytesToString());\
                                              print(response.statusCode);
                                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                              if(response.statusCode==503 || response.statusCode==504){
                                                UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,PremiumCollection());
                                              }
                                              else
                                                UtilFsNav.showToast(error[0].Description.toString(), context,PremiumCollection());
                                            }
                                          } catch (_) {
                                            if (_.toString() == "TIMEOUT") {
                                              return UtilFsNav.showToast(
                                                  "Request Timed Out",
                                                  context,
                                                  PremiumCollection());
                                            } else
                                              print(_);
                                          }
                                        } else {
                                          UtilFs.showToast(
                                              "Please Enter Policy Number", context);
                                        }
                                      }
                                    },
                                    // style: ButtonStyle( foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFCC0000))),
                                  ),
                                ),
                                // dupprint==true?Container(
                                //   child: Column(
                                //     children:
                                //     // receipts.map((data) => RadioGroup<dynamic>.builder(
                                //     //   direction: Axis.horizontal,
                                //     //   groupValue: receipts,
                                //     //   onChanged: (value) => setState(() {
                                //     //     selectedReceipt = value!;
                                //     //   }),
                                //     //   items: receipts,
                                //     //   itemBuilder: (item) => RadioButtonBuilder(
                                //     //     item,
                                //     //   ),
                                //     // )).toList(),
                                //
                                //   ),
                                // ):Container()
                                displaydupPrint == true
                                    ? Container(
                                    height:
                                    MediaQuery.of(context).size.height * .5,
                                    child: Column(
                                        children: List<Widget>.generate(
                                            receipts.length, (index) {
                                          return RadioListTile<String>(
                                            // title: Text("${receipts[index]['receiptNumber'].toString()}""${receipts[index]['receiptDate'].toString()}""${receipts[index]['totalAmount'].toString()}"),
                                            title: Table(
                                              border: TableBorder.all(),
                                              columnWidths: const {
                                                0: FlexColumnWidth(1.1),
                                                1: FlexColumnWidth(1.1),
                                                2: FlexColumnWidth(0.6)
                                              },
                                              children: [
                                                TableRow(children: [
                                                  Center(
                                                      child: Text(
                                                          "${receipts[index]['receiptNumber'].toString()}")),
                                                  Center(
                                                      child: Text(
                                                          "${receipts[index]['receiptDate'].toString()}")),
                                                  Center(
                                                      child: Text(
                                                          "${receipts[index]['totalAmount'].toString()}")),
                                                ])
                                              ],
                                            ),
                                            value: receipts[index]['receiptNumber']
                                                .toString(),
                                            groupValue: selectedReceipt,
                                            onChanged: (value) {
                                              dupprintlist.clear();
                                              dupprintlist.add(
                                                  receipts[index]['premiumRebate']);
                                              dupprintlist
                                                  .add(receipts[index]['agentID']);
                                              receipts[index]['policyName']!=null? dupprintlist
                                                  .add(receipts[index]['policyName']):dupprintlist
                                                  .add(receipts[index]['proposalName']);
                                              dupprintlist.add(
                                                  receipts[index]['cGSTforrenewal']);
                                              dupprintlist.add(
                                                  receipts[index]['paymentMode']);
                                              dupprintlist.add(
                                                  receipts[index]['proposalNumber']);
                                              receipts[index]['policyNumber']!=null? dupprintlist
                                                  .add(receipts[index]['policyNumber']):dupprintlist
                                                  .add(receipts[index]['proposalNumber']);
                                              // dupprintlist.add(
                                              //     receipts[index]['policyNumber']);
                                              dupprintlist.add(
                                                  receipts[index]['uGSTforrenewal']);
                                              dupprintlist.add(
                                                  receipts[index]['receiptDate']);
                                              dupprintlist.add(
                                                  receipts[index]['sGSTforrenewal']);
                                              dupprintlist.add(
                                                  receipts[index]['balanceAmount']);
                                              dupprintlist
                                                  .add(receipts[index]['gstin']);
                                              receipts[index]['policyName']!=null?  dupprintlist
                                                  .add(receipts[index]['billtoDate']):dupprintlist.add("");
                                              dupprintlist.add(
                                                  receipts[index]['totalAmount']);
                                              dupprintlist.add(
                                                  receipts[index]['premiumInterest']);
                                              dupprintlist.add(
                                                  receipts[index]['receiptTime']);
                                              dupprintlist.add(receipts[index]
                                              ['premiumDueAmount']);
                                              dupprintlist.add(
                                                  receipts[index]['proposalName']);
                                              receipts[index]['policyName']!=null?  dupprintlist
                                                  .add(receipts[index]['paidtoDate']):dupprintlist.add("");
                                              dupprintlist.add(receipts[index]
                                              ['serviceTaxTotalAmount']);
                                              dupprintlist.add(
                                                  receipts[index]['receiptNumber']);
                                              setState(() {
                                                selectedReceipt = value;
                                              });
                                            },
                                          );
                                        })

                                      // ListView.builder(
                                      //   itemCount: receipts.length,
                                      //     itemBuilder: (context,index){
                                      //     return Radio<String>(
                                      //       value: receipts[index]['receiptNumber'].toString(),
                                      //             groupValue: selectedReceipt,
                                      //             onChanged: (value){
                                      //               setState(() {
                                      //                 selectedReceipt=value;
                                      //               });
                                      //             },
                                      //     );
                                      //     })
                                    ))
                                    : Container(),
                                displaydupPrint == true
                                    ? Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      // elevation:MaterialStateProperty.all(),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red)))),
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  dupReceipt(dupprintlist)));
                                    },
                                    child: Text("Submit"),
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Container(
                      child: _isLoading
                          ? Loader(
                              isCustom: true,
                              loadingTxt: 'Please Wait...Loading...')
                          : Container()),
                ],
              ),
            )));
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
  }

  Future<String> get _localPath async {
    Directory directory = Directory('$cachepath');
    // print("Path is -"+directory.path.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fetchAccountDetails.txt');
  }

  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   final file=await _localFile;
  //
  //   file.writeAsStringSync('');
  //   String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    // String? goResponse=await Newenc.tester("$cachepath/fetchAccountDetails.txt","requestJson","jsonInStream");
    // String bound=goResponse.replaceAll("{","").replaceAll("}","").split("\n")[0];

    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "searchPolicy", "getTransactionXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    // String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";

    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Search Proposal ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  //
  // Future<File> writeDupContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   final file=await _localFile;
  //   String text;
  //
  //   file.writeAsStringSync('');
  //   // String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   policyno.text.startsWith("N-")?text='{"policyNumber":"","proposalNumber":"${policyno.text}","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}':text='{"policyNumber":"${policyno.text}","proposalNumber":"","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteDupContent() async {
    var login = await USERDETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');
    String text;

    file.writeAsStringSync('');

    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "fetchRecieptList", "requestReceiptList");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
    policyno.text.startsWith("N-")
        ? text = "$bound"
            "\nContent-Id: <requestReceiptList>\n\n"
            '{"policyNumber":"","proposalNumber":"${policyno.text}","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            ""
        : text = "$bound"
            "\nContent-Id: <requestReceiptList>\n\n"
            '{"policyNumber":"${policyno.text}","proposalNumber":"","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            "";

    // policyno.text.startsWith("N-")?
    // text='{"policyNumber":"","proposalNumber":"${policyno.text}","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}':
    // text='{"policyNumber":"${policyno.text}","proposalNumber":"","addPrem":1,"facilityId":"${login[0].BOFacilityID}","channelType":"RICT","reqType":"DuplicateReceipt"}';

    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Duplicate ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> writeProposalContent() async {
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');

    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt",
        "requestJson",
        "getTransactionXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"proposal_number":"${proposalno.text}"}';
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Proposal  ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      _isLoading = true;
    });
  }
}
