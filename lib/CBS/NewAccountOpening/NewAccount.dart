import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/NewAccountOpening/accopenMain.dart';
import 'package:darpan_mine/CBS/accdetails.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/CBS/screens/transactionsuccess.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../decryptHeader.dart';
import '../screens/my_cards_screen.dart';

class SBNewAccount extends StatefulWidget {
  String? name;
  String? CIFNumber;
  String? isminor;
  String? kycstatus;
  String? j1name;
  String? j2name;
  String? scheme;
  String rdinst;
  String tdvalue;
  String moop;

  SBNewAccount(this.name, this.CIFNumber, this.isminor, this.kycstatus,
      this.j1name, this.j2name, this.scheme, this.rdinst, this.tdvalue,this.moop);

  @override
  _SBNewAccountState createState() => _SBNewAccountState();
}

class _SBNewAccountState extends State<SBNewAccount> {
  final _formKey = GlobalKey<FormState>();
  String? tid;
  String? acrefnum;
  final amountTextController = TextEditingController();
  final rebatecalc = TextEditingController();
  final imagePicker = ImagePicker();
  File? _image;
  bool imgVisible = false;
  String? rdamtocollect;
  var rand;
  bool amountCollection = false;
  Map main = {};
  List<TBCBS_TRAN_DETAILS> cbsAcctOpenDetails = [];
  bool _isLoading = false;
  bool _rebateCalculate = false;
  var limits;
  late int minlimit;
  late int multiplier;
  List? bdetails = [];
  bool firstsubmitVisibility = true;
  String? encheader;
  late Directory d;
  late String cachepath;

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
        (route) => false);
  }

  @override
  void initState() {
    super.initState();
    getCacheDir();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  fetchlimits() async {
    print("Scheme Recevied");
    print(widget.scheme);
    if (widget.scheme == "SB")
      widget.scheme = "SBGEN";
    else if (widget.scheme == "RD") widget.scheme = "RD";

    limits = await CBS_LIMITS_CONFIG().select().toMapList();
    print("Limits in New Account");
    // print(limits['type']);
    return limits;
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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            title: Text("New Account Opening-Confirmation"),
            backgroundColor: const Color(0xFFB71C1C)),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: fetchlimits(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Account Opening Details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),

                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .90,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .111,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(90.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          readOnly: true,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: //Colors.white,
                                                  Color.fromARGB(
                                                      255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            labelText: "Account Holder Name",
                                            hintText: widget.name,
                                            labelStyle: TextStyle(
                                                color: Color(0xFFCFB53B)),
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,

                                            // contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.CIFNumber == ""
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                readOnly: true,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: //Colors.white,
                                                        Color.fromARGB(
                                                            255, 2, 40, 86),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelText: "CIF ID ",
                                                  hintText: widget.CIFNumber,
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              widget.CIFNumber == ""
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                readOnly: true,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: //Colors.white,
                                                        Color.fromARGB(
                                                            255, 2, 40, 86),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelText: "IsMinor",
                                                  hintText: widget.isminor,
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              // widget.CIFNumber==""?Container():Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //         width:
                              //         MediaQuery.of(context).size.width *
                              //             .90.w,
                              //         height: MediaQuery.of(context).size.height*.111.h,
                              //         decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             borderRadius: BorderRadius.circular(90.0)),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: TextFormField(
                              //             readOnly: true,
                              //             style:const TextStyle(fontSize: 17,
                              //                 color://Colors.white,
                              //                 Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                              //             decoration: InputDecoration(
                              //               hintStyle: TextStyle(fontSize: 15,
                              //                 color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                              //               border: InputBorder.none,
                              //               floatingLabelBehavior:FloatingLabelBehavior.always,
                              //               labelText: "IsMinor",
                              //               hintText: widget.isminor,
                              //               labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                              //
                              //
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              widget.j1name != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                readOnly: true,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: //Colors.white,
                                                        Color.fromARGB(
                                                            255, 2, 40, 86),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                  labelText: "Joint Holder 1",
                                                  hintText: widget.j1name,
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              widget.j2name != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                readOnly: true,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: //Colors.white,
                                                        Color.fromARGB(
                                                            255, 2, 40, 86),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelText:
                                                      "JointHolder2 Name",
                                                  hintText: widget.j2name,
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Visibility(
                                visible: imgVisible,
                                child: Container(
                                    child: _image == null
                                        ? const Text('Image Not Selected')
                                        : Image.file(_image!)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              widget.scheme == "RD"
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .90,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller: rebatecalc,
                                                validator: (value) {
                                                  if (int.parse(rebatecalc.text
                                                          .toString()) >
                                                      50000) {
                                                    return 'Enter the transaction amount less than or equal to 50000';
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: //Colors.white,
                                                        Color.fromARGB(
                                                            255, 2, 40, 86),
                                                    fontWeight:
                                                        FontWeight.w500),
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelText:
                                                      "Enter Amount to be collected",
                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          _rebateCalculate == false
                                              ? RaisedButton(
                                                  child: Text(
                                                      "Fetch Rebate details",
                                                      style: TextStyle(
                                                          fontSize: 18)),
                                                  color: Color(0xFFB71C1C),
                                                  //Colors.green,
                                                  textColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  onPressed: () async {
                                                    if(rebatecalc.text.length>0){
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    int am = int.parse(
                                                        rebatecalc.text
                                                            .toString());
                                                    int ins = int.parse(
                                                        widget.rdinst);

                                                    var installments =
                                                        am.remainder(ins);
                                                    print(
                                                        "RD Rebate: $installments");

                                                    String reqid =
                                                        DateTimeDetails()
                                                            .cbsdatetime();
                                                    if (installments == 0) {
                                                      List<USERLOGINDETAILS>
                                                          acctoken =
                                                          await USERLOGINDETAILS()
                                                              .select()
                                                              .toList();
                                                      var val = am / ins;
                                                      encheader =
                                                          await encryptfetchRdRebate(
                                                              reqid,
                                                              val.toInt());
                                                      // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                                                      // request.files.add(await http.MultipartFile.fromPath('','$cachepath/fetchAccountDetails.txt'));
                                                      var headers = {
                                                        'Signature':
                                                            '$encheader',
                                                        'Uri': 'requestSign',
                                                        // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                        'Authorization':
                                                            'Bearer ${acctoken[0].AccessToken}',
                                                        'Cookie':
                                                            'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                      };

                                                      try {
                                                        final File file = File('$cachepath/fetchAccountDetails.txt');
                                                        String tosendText = await file.readAsString();
                                                        var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                        request.body=tosendText;
                                                        request.headers
                                                            .addAll(headers);

                                                        http.StreamedResponse
                                                            response =
                                                            await request
                                                                .send();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          // print(await response.stream.bytesToString());
                                                          var resheaders =
                                                              await response
                                                                  .headers;
                                                          print(
                                                              "Result Headers");
                                                          print(resheaders);
                                                          String temp = resheaders['authorization']!;
                                                          String decryptSignature = temp;
                                                          String res =
                                                          await response
                                                              .stream
                                                              .bytesToString();
                                                          String val =
                                                          await decryption1(decryptSignature, res);

                                                          // String
                                                          //     decryptSignature =
                                                          //     await decryptHeader(
                                                          //         t[1]);
                                                          // String val =
                                                          //     await decryption1(
                                                          //         decryptSignature,
                                                          //         res);
                                                          if (val ==
                                                              "Verified!") {
                                                            await LogCat().writeContent(
                                                    '$res');

                                                            Map a = json
                                                                .decode(res);
                                                            print(a['JSONResponse']
                                                                [
                                                                'jsonContent']);
                                                            String data = a[
                                                                    'JSONResponse']
                                                                ['jsonContent'];
                                                            rand = json
                                                                .decode(data);
                                                            print(
                                                                rand['rebate']);
                                                            if (rand[
                                                                    'successOrFailure'] !=
                                                                'FAILURE') {
                                                              rdamtocollect = (int.parse(rebatecalc
                                                                          .text
                                                                          .toString()) -
                                                                      int.parse(rand[
                                                                              'rebate']
                                                                          .split(
                                                                              '.')[0]))
                                                                  .toString();
                                                              setState(() {
                                                                _rebateCalculate =
                                                                    true;
                                                              });
                                                            } else {
                                                              UtilFs.showToast(
                                                                  "No Rebate available",
                                                                  context);
                                                              setState(() {
                                                                _rebateCalculate =
                                                                    true;
                                                              });
                                                              rand['rebate'] =
                                                                  0;
                                                              rdamtocollect =
                                                                  rebatecalc
                                                                      .text
                                                                      .toString();
                                                            }
                                                          } else {
                                                            UtilFsNav.showToast(
                                                                "Signature Verification Failed! Try Again",
                                                                context,
                                                                AccountOpenMain());
                                                            await LogCat()
                                                                .writeContent(
                                                                    '${DateTimeDetails().currentDateTime()} :New A/c Rebate Calculation: Signature Verification Failed.\n\n');
                                                          }
                                                        } else {
                                                          print(response.statusCode);
                                                          List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                          if(response.statusCode==503 || response.statusCode==504){
                                                            UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                          }
                                                          else
                                                            UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                        }
                                                      } catch (_) {
                                                        if (_.toString() ==
                                                            "TIMEOUT") {
                                                          return UtilFsNav.showToast(
                                                              "Request Timed Out",
                                                              context,
                                                              AccountOpenMain());
                                                        }
                                                      }
                                                    } else {
                                                      UtilFs.showToast(
                                                          "Enter installment amount equal to ${widget.rdinst} or in multiples of ${widget.rdinst}",
                                                          context);
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  }
                                                    else{
                                                      UtilFs.showToast(
                                                          "Please Enter amount to be collected",
                                                          context);
                                                    }},
                                                )
                                              : Container(),
                                          _rebateCalculate == true
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          "Amount: ${rebatecalc.text}"),
                                                      Text(
                                                          "Rebate: ${rand['rebate']}"),
                                                      Text(
                                                          "Total Amount to Collect: $rdamtocollect"),
                                                      TextButton(
                                                          style: ButtonStyle(
                                                              // elevation:MaterialStateProperty.all(),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .grey)))),
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              var login =
                                                                  await USERDETAILS()
                                                                      .select()
                                                                      .toList();
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                              });
                                                              encheader =
                                                                  await encryptfetchsoldetails();
                                                              List<USERLOGINDETAILS>
                                                                  acctoken =
                                                                  await USERLOGINDETAILS()
                                                                      .select()
                                                                      .toList();

                                                              // var request = http.Request('POST',
                                                              //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
                                                              // request.files.add(await http.MultipartFile.fromPath(
                                                              //     '', '$cachepath/fetchAccountDetails.txt'));

                                                              try {
                                                                var headers = {
                                                                  'Signature':
                                                                      '$encheader',
                                                                  'Uri':
                                                                      'requestSOLDetails',
                                                                  // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                  'Authorization':
                                                                      'Bearer ${acctoken[0].AccessToken}',
                                                                  'Cookie':
                                                                      'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                };

                                                                final File file = File('$cachepath/fetchAccountDetails.txt');
                                                                String tosendText = await file.readAsString();
                                                                var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                request.body=tosendText;
                                                                request.headers
                                                                    .addAll(
                                                                        headers);

                                                                http.StreamedResponse
                                                                    bocodeResponse =
                                                                    await request.send().timeout(
                                                                        const Duration(
                                                                            seconds:
                                                                                65),
                                                                        onTimeout:
                                                                            () {
                                                                  // return UtilFs.showToast('The request Timeout',context);
                                                                  setState(() {
                                                                    _isLoading =
                                                                        false;
                                                                  });
                                                                  throw 'TIMEOUT';
                                                                });

                                                                if (bocodeResponse
                                                                        .statusCode ==
                                                                    200) {
                                                                  // print(await response.stream.bytesToString());

                                                                  var resheaders =
                                                                      await bocodeResponse
                                                                          .headers;
                                                                  print(
                                                                      "Result Headers");
                                                                  print(
                                                                      resheaders);
                                                                  List t = resheaders[
                                                                          'authorization']!
                                                                      .split(
                                                                          ", Signature:");
                                                                  String res =
                                                                      await bocodeResponse
                                                                          .stream
                                                                          .bytesToString();
                                                                  String temp = resheaders['authorization']!;
                                                                  String decryptSignature = temp;

                                                                  String val =
                                                                  await decryption1(decryptSignature, res);
                                                                  print(res);
                                                                  if (val ==
                                                                      "Verified!") {
                                                                    await LogCat().writeContent(
                                                    '$res');

                                                                    Map a = json
                                                                        .decode(
                                                                            res);
                                                                    String
                                                                        boData =
                                                                        a['JSONResponse']
                                                                            [
                                                                            'jsonContent'];
                                                                    Map tempmain =
                                                                        json.decode(
                                                                            boData);
                                                                    print(
                                                                        tempmain);
                                                                    bdetails = await fac
                                                                        .splitBODetails(
                                                                            tempmain['M_ADD_PARAMS']);
                                                                    print(
                                                                        bdetails![
                                                                            4]);
                                                                    try {
                                                                      print(
                                                                          "IN RD Acc");
                                                                      encheader =
                                                                          await encryptOAPDetails();
                                                                    } catch (e) {
                                                                      print(
                                                                          "FIle error: $e");
                                                                    }

                                                                    try {
                                                                      print(
                                                                          "Reached for sending request");
                                                                      print(
                                                                          encheader);
                                                                      var headers =
                                                                          {
                                                                        'Signature':
                                                                            '$encheader',
                                                                        'Uri':
                                                                            'requestJson',
                                                                        // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                        'Authorization':
                                                                            'Bearer ${acctoken[0].AccessToken}',
                                                                        'Cookie':
                                                                            'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                      };
                                                                      final File file = File('$cachepath/acct_opening.txt');
                                                                      String tosendText = await file.readAsString();
                                                                      var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                      request.body=tosendText;

                                                                      request
                                                                          .headers
                                                                          .addAll(
                                                                              headers);
                                                                      http.StreamedResponse
                                                                          oapresponse =
                                                                          await request.send().timeout(
                                                                              const Duration(seconds: 65),
                                                                              onTimeout: () {
                                                                        // return UtilFs.showToast('The request Timeout',context);
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              false;
                                                                        });
                                                                        throw 'TIMEOUT';
                                                                      });
                                                                      print(
                                                                          "Request: $request");
                                                                      // setState(
                                                                      //     () {
                                                                      //   _isLoading =
                                                                      //       false;
                                                                      // });
                                                                      print(oapresponse
                                                                          .statusCode);
                                                                      if (oapresponse
                                                                              .statusCode ==
                                                                          200) {
                                                                        var resheaders =
                                                                            await oapresponse.headers;
                                                                        print(
                                                                            "Result Headers");
                                                                        print(
                                                                            resheaders);
                                                                         // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;

                                                                        String
                                                                            res =
                                                                            await oapresponse.stream.bytesToString();
                                                                       

                                                                        String val = await decryption1(
                                                                            decryptSignature,
                                                                            res);
                                                                        if (val ==
                                                                            "Verified!") {
                                                                          await LogCat().writeContent(
                                                    '$res');

                                                                          Map a =
                                                                              json.decode(res);
                                                                          print(a['JSONResponse']
                                                                              [
                                                                              'jsonContent']);
                                                                          String
                                                                              data =
                                                                              a['JSONResponse']['jsonContent'];
                                                                          Map oapmain =
                                                                              json.decode(data);
                                                                          print(
                                                                              "Values");
                                                                          print(
                                                                              oapmain);

                                                                          if (oapmain['39'] !=
                                                                              "000") {
                                                                            var ec =
                                                                                await CBS_ERROR_CODES().select().Error_code.equals(oapmain['39']).toList();
                                                                            UtilFsNav.showToast(
                                                                                '${ec[0].Error_message}',
                                                                                context,
                                                                                AccountOpenMain());
                                                                            // Navigator.pushAndRemoveUntil(
                                                                            //     context,
                                                                            //     MaterialPageRoute(builder: (context) => AccountOpenMain()),
                                                                            //     (route) => false);
                                                                          } else {
                                                                            String
                                                                                circlecode =
                                                                                oapmain['M_ADD_PARAMS'].toString().split("|")[6];
                                                                            tid =
                                                                                GenerateRandomString().randomString();
                                                                            acrefnum =
                                                                                GenerateRandomString().newaccrefnum(circlecode);

                                                                            await TBCBS_TRAN_DETAILS(
                                                                              DEVICE_TRAN_ID: tid,
                                                                              TRANSACTION_ID: tid,
                                                                              REFERENCE_NO: '$acrefnum',
                                                                              OFFICE_ACC_NUM: '${bdetails![4]}',
                                                                              ACCOUNT_TYPE: '${widget.scheme}',
                                                                              SCHEME_TYPE: '',
                                                                              MAIN_HOLDER_NAME: '${widget.name}',
                                                                              MAIN_HOLDER_CIFID: '${widget.CIFNumber}',
                                                                              JOINT_HOLDER1_NAME: '${widget.j1name}',
                                                                              JOINT_HOLDER1_CIFID: '',
                                                                              JOINT_HOLDER2_NAME: '${widget.j2name}',
                                                                              JOINT_HOLDER2_CIFID: '',
                                                                              TRANSACTION_AMT: '${rebatecalc.text.toString()}',
                                                                              CURRENCY: 'INR',
                                                                              TRAN_TYPE: 'O',
                                                                              DEVICE_TRAN_TYPE: 'AO',
                                                                              TRAN_DATE: '${DateTimeDetails().currentDate()}',
                                                                              TRAN_TIME: '${DateTimeDetails().onlyTime()}',
                                                                              FIN_SOLBOD_DATE: '',
                                                                              MODE_OF_TRAN: 'cash',
                                                                              INSTALMENT_AMT: '${widget.rdinst}',
                                                                              APPR_STATUS: 's',
                                                                              TENURE_INW: '',
                                                                              OPERATOR_ID: '${login[0].EMPID}',
                                                                              MINOR_FLAG: '',
                                                                              TENURE: '5 YEARS',
                                                                              REBATE_AMT: '${rand['rebate']}',
                                                                              GUARDIAN_NAME: '',
                                                                              STATUS: 'PENDING',
                                                                              MINOR_DOB: '',
                                                                            ).upsert();

                                                                            encheader =
                                                                                await encyrptfetchaccOpengdetails(tid!, acrefnum!);
                                                                            // var request = http
                                                                            //     .Request(
                                                                            //     'POST',
                                                                            //     Uri.parse(
                                                                            //         'https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                                            // request.files.add(
                                                                            //     await http.MultipartFile
                                                                            //         .fromPath(
                                                                            //         '',
                                                                            //         '$cachepath/acct_opening.txt'));
                                                                            try {
                                                                              var headers = {
                                                                                'Signature': '$encheader',
                                                                                'Uri': 'requestJson',
                                                                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                                'Authorization': 'Bearer ${acctoken[0].AccessToken}',
                                                                                'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                              };

                                                                              final File file = File('$cachepath/fetchAccountDetails.txt');
                                                                              String tosendText = await file.readAsString();
                                                                              var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                              request.body=tosendText;

                                                                              request.headers.addAll(headers);
                                                                              http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 65), onTimeout: () {
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
                                                                                var resheaders = await response.headers;
                                                                                print("Result Headers");
                                                                                print(resheaders);
                                                                                 // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;
                                                                                String res = await response.stream.bytesToString();
                                                                                
                                                                                String val = await decryption1(decryptSignature, res);
                                                                                if (val == "Verified!") {
                                                                                  await LogCat().writeContent(
                                                    '$res');

                                                                                  Map a = json.decode(res);
                                                                                  print(a['JSONResponse']['jsonContent']);
                                                                                  String data = a['JSONResponse']['jsonContent'];
                                                                                  main = json.decode(data);
                                                                                  print("Values");
                                                                                  print(main);
                                                                                  if (main['Status'] == "Failure") {
                                                                                    UtilFsNav.showToast("Mismatch in OAP Office Account SOLID and BOCode mapping ", context, AccountOpenMain());
                                                                                  } else {
                                                                                    if (main['39'] != "000") {
                                                                                      UtilFsNav.showToast(main['127'], context, AccountOpenMain());
                                                                                      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AccountOpenMain()), (route) => false);
                                                                                    } else {
                                                                                      var currentDate = DateTimeDetails().onlyDatewithFormat();
                                                                                      var currentTime = DateTimeDetails().onlyTime();
                                                                                      var balance = main['48'].split('+')[2];
                                                                                      balance = int.parse(balance) > 0 ? (int.parse(balance) / 100).toStringAsFixed(2).toString() : "0.00";
                                                                                      var TranID = main['126'].split('_')[0].toString().trim();
                                                                                      print(TranID);
                                                                                      print("this is get data");
                                                                                      //   var officedata1 = await OfficeDetail().select().toList();
                                                                                      //   var soldata1 = await TBCBS_SOL_DETAILS().select().toList();
                                                                                      //   final tranDetails = TBCBS_TRAN_DETAILS()
                                                                                      //    ..TRANSACTION_ID=TranID
                                                                                      //     ..REFERENCE_NO=GenerateRandomString().newaccrefnum()
                                                                                      //      // ..REFERENCE_NO="F"+DateTimeDetails().cbsRefdatetime()+officedata1[0].OFFICECODE_3!.substring(0,5)+officedata1[0].COOFFICECODE!.substring(0,2)
                                                                                      // //  ..OFFICE_ACC_NUM=soldata1[0].SOL_ID!+soldata1[0].BO_ID!+"N"
                                                                                      //     ..OFFICE_ACC_NUM="57144201K1037N"
                                                                                      //     ..TRANSACTION_AMT=amountTextController.text
                                                                                      //   ..MODE_OF_TRAN="BYCASH"
                                                                                      //   ..OPERATOR_ID="10101"
                                                                                      //     ..TRAN_DATE = currentDate
                                                                                      //     ..TRAN_TIME = currentTime
                                                                                      //  ..TRAN_TYPE="Deposit";
                                                                                      //   tranDetails.save();

                                                                                      // await TBCBS_TRAN_DETAILS(
                                                                                      //   DEVICE_TRAN_ID: tid,
                                                                                      //   TRANSACTION_ID: '$TranID',
                                                                                      //   REFERENCE_NO: '$acrefnum',
                                                                                      //   OFFICE_ACC_NUM: '${bdetails![4]}',
                                                                                      //   ACCOUNT_TYPE: '${widget.scheme}',
                                                                                      //   SCHEME_TYPE: '',
                                                                                      //   MAIN_HOLDER_NAME: '${widget.name}',
                                                                                      //   MAIN_HOLDER_CIFID: '${widget.CIFNumber}',
                                                                                      //   JOINT_HOLDER1_NAME: '${widget.j1name}',
                                                                                      //   JOINT_HOLDER1_CIFID: '',
                                                                                      //   JOINT_HOLDER2_NAME: '${widget.j2name}',
                                                                                      //   JOINT_HOLDER2_CIFID: '',
                                                                                      //   TRANSACTION_AMT: '${rebatecalc.text.toString()}',
                                                                                      //   CURRENCY: 'INR',
                                                                                      //   TRAN_TYPE: 'O',
                                                                                      //   DEVICE_TRAN_TYPE: 'AO',
                                                                                      //   TRAN_DATE: '${DateTimeDetails().currentDate()}',
                                                                                      //   TRAN_TIME: '${DateTimeDetails().onlyTime()}',
                                                                                      //   FIN_SOLBOD_DATE: '',
                                                                                      //   MODE_OF_TRAN: 'cash',
                                                                                      //   INSTALMENT_AMT: '${widget.rdinst}',
                                                                                      //   APPR_STATUS: 's',
                                                                                      //   TENURE_INW: '',
                                                                                      //   OPERATOR_ID: '${login[0].EMPID}',
                                                                                      //   MINOR_FLAG: '',
                                                                                      //   TENURE: '5 YEARS',
                                                                                      //   REBATE_AMT: '${rand['rebate']}',
                                                                                      //   GUARDIAN_NAME: '',
                                                                                      //   STATUS: 'SUCCESS',
                                                                                      //   MINOR_DOB: '',
                                                                                      // ).upsert();


                                                                                      await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                                        'TRANSACTION_ID': '$TranID',
                                                                                        'STATUS': 'SUCCESS',
                                                                                      });
                                                                                      final addCash =  CashTable()
                                                                                        ..Cash_ID = '$acrefnum'
                                                                                        ..Cash_Date = DateTimeDetails().currentDate()
                                                                                        ..Cash_Time = DateTimeDetails().onlyTime()
                                                                                        ..Cash_Type = 'Add'
                                                                                        ..Cash_Amount = double.parse('${rdamtocollect.toString()}')
                                                                                        ..Cash_Description = "${widget.scheme} A/c Opening";
                                                                                      await addCash.save();
                                                                                      final addTransaction = TransactionTable()
                                                                                        ..tranid = '$TranID'
                                                                                        ..tranDescription = "RD A/c Opening"
                                                                                        ..tranAmount = double.parse('${rdamtocollect.toString()}')
                                                                                        ..tranType = "CBS"
                                                                                        ..tranDate = DateTimeDetails().currentDate()
                                                                                        ..tranTime = DateTimeDetails().onlyTime()
                                                                                        ..valuation = "Add";

                                                                                      await addTransaction.save();
                                                                                      cbsAcctOpenDetails = await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                                                                                      print("Reference Number is");
                                                                                      // print(cbsAcctOpenDetails[0].REFERENCE_NO);
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(builder: (context) => TransSuccess(cbsAcctOpenDetails[0].TRANSACTION_ID, cbsAcctOpenDetails[0].REFERENCE_NO, cbsAcctOpenDetails[0].OFFICE_ACC_NUM, cbsAcctOpenDetails[0].TRANSACTION_AMT, cbsAcctOpenDetails[0].TRANSACTION_AMT, cbsAcctOpenDetails[0].MODE_OF_TRAN, cbsAcctOpenDetails[0].OPERATOR_ID, cbsAcctOpenDetails[0].TRAN_DATE, cbsAcctOpenDetails[0].TRAN_TIME, cbsAcctOpenDetails[0].TRAN_TYPE, cbsAcctOpenDetails[0].TENURE,widget.moop)),
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }
                                                                              } else {
                                                                                // print(response.reasonPhrase!);
                                                                                // UtilFsNav.showToast(response.reasonPhrase!, context, AccountOpenMain());
                                                                                print(response.statusCode);
                                                                                List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                                                if(response.statusCode==503 || response.statusCode==504){
                                                                                  UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                                                }
                                                                                else
                                                                                  UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                                              }
                                                                            } catch (_) {
                                                                              if (_.toString() == "TIMEOUT") {
                                                                                return UtilFsNav.showToast("Request Timed Out", context, AccountOpenMain());
                                                                              }
                                                                            }
                                                                          }
                                                                        }
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _isLoading =
                                                                              false;
                                                                        });

                                                                        print(oapresponse.statusCode);
                                                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(oapresponse.statusCode).toList();
                                                                        if(oapresponse.statusCode==503 || oapresponse.statusCode==504){
                                                                          UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                                        }
                                                                        else
                                                                          UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                                      }
                                                                    } catch (_) {
                                                                      if (_.toString() ==
                                                                          "TIMEOUT") {
                                                                        return UtilFsNav.showToast(
                                                                            "Request Timed Out",
                                                                            context,
                                                                            AccountOpenMain());
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  setState(() {
                                                                    _isLoading =
                                                                        false;
                                                                  });
                                                                  print(bocodeResponse
                                                                      .reasonPhrase);
                                                                  print(bocodeResponse
                                                                      .statusCode);
                                                                  print(await bocodeResponse
                                                                      .stream
                                                                      .bytesToString());

                                                                  print(bocodeResponse.statusCode);
                                                                  List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(bocodeResponse.statusCode).toList();
                                                                  if(bocodeResponse.statusCode==503 || bocodeResponse.statusCode==504){
                                                                    UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                                  }
                                                                  else
                                                                    UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());

                                                                }
                                                              } catch (_) {
                                                                if (_.toString() ==
                                                                    "TIMEOUT") {
                                                                  return UtilFsNav.showToast(
                                                                      "Request Timed Out",
                                                                      context,
                                                                      AccountOpenMain());
                                                                }
                                                              }
                                                            }
                                                          },
                                                          child: Text('SUBMIT',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)))
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                          // RaisedButton(
                                          //     child: const Text('SUBMIT',
                                          //         style: TextStyle(fontSize: 18)),
                                          //     color: Color(0xFFB71C1C),
                                          //     //Colors.green,
                                          //     textColor: Colors.white,
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(20),
                                          //     ),
                                          //     onPressed: (){
                                          //       showDialog(context: context,
                                          //           builder: (BuildContext context){
                                          //             return AlertDialog(
                                          //               title: Text('Amount Collected'),
                                          //               content:
                                          //               TextField(
                                          //                 controller: amountTextController,
                                          //                 decoration: const InputDecoration(
                                          //                   hintText: 'Amount in Rupees',
                                          //                   labelText: 'Amount Collected',
                                          //                   enabledBorder: OutlineInputBorder(
                                          //                       borderSide: BorderSide(
                                          //                           color: Colors.blueGrey, width: 3)
                                          //                   ),
                                          //                   focusedBorder: OutlineInputBorder(
                                          //                       borderSide: BorderSide(
                                          //                           color: Colors.green, width: 3)
                                          //                   ),
                                          //                 ),
                                          //                 keyboardType: TextInputType.number,
                                          //               ),
                                          //               actions: [
                                          //
                                          //                 OutlineButton(onPressed: ()async {
                                          //                   setState(() {
                                          //                     _isLoading=true;
                                          //                   });
                                          //                   await fetchsoldetails();
                                          //
                                          //
                                          //                   var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
                                          //                   request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                          //
                                          //                   http.StreamedResponse bocodeResponse = await request.send();
                                          //
                                          //                   if (bocodeResponse.statusCode == 200) {
                                          //                     // print(await response.stream.bytesToString());
                                          //
                                          //                     String res=await bocodeResponse.stream.bytesToString();
                                          //                     print(res);
                                          //                     Map a=json.decode(res);
                                          //                     String boData=a['JSONResponse']['jsonContent'];
                                          //                     Map tempmain=json.decode(boData);
                                          //                     print(tempmain);
                                          //                     bdetails = await fac.splitBODetails(tempmain['M_ADD_PARAMS']);
                                          //                     print(bdetails![4]);
                                          //                     tid= GenerateRandomString().randomString();
                                          //                     acrefnum=GenerateRandomString().newaccrefnum();
                                          //                     await fetchaccOpengdetails(tid!,acrefnum!);
                                          //                     var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                                          //                     request.files.add(await http.MultipartFile.fromPath('', '$cachepath/acct_opening.txt'));
                                          //                     http.StreamedResponse response = await request.send();
                                          //                     setState(() {
                                          //                       _isLoading=false;
                                          //                     });
                                          //                     if (response.statusCode == 200) {
                                          //                       String res=await response.stream.bytesToString();
                                          //                       Map a=json.decode(res);
                                          //                       print(a['JSONResponse']['jsonContent']);
                                          //                       String data=a['JSONResponse']['jsonContent'];
                                          //                       main=json.decode(data);
                                          //                       print("Values");
                                          //                       print(main);
                                          //                       if(main['Status']=="Failure"){
                                          //                         UtilFs.showToast("Mismatch in OAP Office Account SOLID and BOCode mapping ",context);
                                          //                       }
                                          //                       else {
                                          //                         if(main['39']!="000"){
                                          //                           UtilFs.showToast(main['127'], context);
                                          //                           Navigator.pushAndRemoveUntil(
                                          //                               context,
                                          //                               MaterialPageRoute(
                                          //                                   builder:
                                          //                                       (context) =>
                                          //                                       AccountOpenMain()),
                                          //                                   (route) => false);
                                          //                         }
                                          //                         else{
                                          //                           var currentDate= DateTimeDetails().onlyDatewithFormat();
                                          //                           var currentTime=  DateTimeDetails().onlyTime();
                                          //                           var balance = main['48'].split('+')[2];
                                          //                           balance = int.parse(balance)> 0?  (int.parse(balance)/100).toStringAsFixed(2).toString() : "0.00";
                                          //                           var TranID=main['126'].split('_')[0];
                                          //                           print(TranID);
                                          //                           print("this is get data");
                                          //                           //   var officedata1 = await OfficeDetail().select().toList();
                                          //                           //   var soldata1 = await TBCBS_SOL_DETAILS().select().toList();
                                          //                           //   final tranDetails = TBCBS_TRAN_DETAILS()
                                          //                           //    ..TRANSACTION_ID=TranID
                                          //                           //     ..REFERENCE_NO=GenerateRandomString().newaccrefnum()
                                          //                           //      // ..REFERENCE_NO="F"+DateTimeDetails().cbsRefdatetime()+officedata1[0].OFFICECODE_3!.substring(0,5)+officedata1[0].COOFFICECODE!.substring(0,2)
                                          //                           // //  ..OFFICE_ACC_NUM=soldata1[0].SOL_ID!+soldata1[0].BO_ID!+"N"
                                          //                           //     ..OFFICE_ACC_NUM="57144201K1037N"
                                          //                           //     ..TRANSACTION_AMT=amountTextController.text
                                          //                           //   ..MODE_OF_TRAN="BYCASH"
                                          //                           //   ..OPERATOR_ID="10101"
                                          //                           //     ..TRAN_DATE = currentDate
                                          //                           //     ..TRAN_TIME = currentTime
                                          //                           //  ..TRAN_TYPE="Deposit";
                                          //                           //   tranDetails.save();
                                          //
                                          //                           await TBCBS_TRAN_DETAILS(
                                          //                             DEVICE_TRAN_ID:tid,
                                          //                             TRANSACTION_ID:'$TranID',
                                          //                             REFERENCE_NO:'$acrefnum',
                                          //                             OFFICE_ACC_NUM:'undefined',
                                          //                             ACCOUNT_TYPE:'${widget.scheme}',
                                          //                             SCHEME_TYPE:'',
                                          //                             MAIN_HOLDER_NAME:'${widget.name}',
                                          //                             MAIN_HOLDER_CIFID:'${widget.CIFNumber}',
                                          //                             JOINT_HOLDER1_NAME:'${widget.j1name}',
                                          //                             JOINT_HOLDER1_CIFID:'',
                                          //                             JOINT_HOLDER2_NAME:'${widget.j2name}',
                                          //                             JOINT_HOLDER2_CIFID:'',
                                          //                             TRANSACTION_AMT:'${amountTextController.text.toString()}',
                                          //                             CURRENCY:'INR',
                                          //                             TRAN_TYPE:'o',
                                          //                             DEVICE_TRAN_TYPE:'AO',
                                          //                             TRAN_DATE:'${DateTimeDetails().onlyDate()}',
                                          //                             TRAN_TIME:'${DateTimeDetails().onlyTime()}',
                                          //                             FIN_SOLBOD_DATE:'',
                                          //                             MODE_OF_TRAN:'cash',
                                          //                             INSTALMENT_AMT:'0',
                                          //                             APPR_STATUS:'s',
                                          //                             TENURE_INW:'',
                                          //                             OPERATOR_ID:'',
                                          //                             MINOR_FLAG:'',
                                          //                             REBATE_AMT:'',
                                          //                             GUARDIAN_NAME:'',
                                          //                             STATUS:'SUCCESS',
                                          //                             MINOR_DOB:'',
                                          //                           ).upsert();
                                          //
                                          //                           cbsAcctOpenDetails = await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                                          //                           print("Reference Number is");
                                          //                           // print(cbsAcctOpenDetails[0].REFERENCE_NO);
                                          //                           Navigator.push(
                                          //                             context,
                                          //                             MaterialPageRoute(builder: (context) => TransSuccess(
                                          //                                 cbsAcctOpenDetails[0].REFERENCE_NO,cbsAcctOpenDetails[0].REFERENCE_NO, cbsAcctOpenDetails[0].OFFICE_ACC_NUM, cbsAcctOpenDetails[0].TRANSACTION_AMT,balance, cbsAcctOpenDetails[0].MODE_OF_TRAN, cbsAcctOpenDetails[0].OPERATOR_ID,cbsAcctOpenDetails[0].TRAN_DATE, cbsAcctOpenDetails[0].TRAN_TIME, cbsAcctOpenDetails[0].TRAN_TYPE,cbsAcctOpenDetails[0].TENURE
                                          //                             )
                                          //                             ),
                                          //                           );
                                          //                         }
                                          //                       }
                                          //                     }
                                          //                     else {
                                          //                       print(response.reasonPhrase!);
                                          //                       UtilFs.showToast(response.reasonPhrase!,context);
                                          //                     }
                                          //                   }
                                          //                   else {
                                          //                     print(bocodeResponse.reasonPhrase);
                                          //                   }
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //
                                          //                 },
                                          //                     child: Text('SUBMIT',style: TextStyle(color: Colors.red))
                                          //                 )
                                          //               ],
                                          //             );
                                          //           });
                                          //     }
                                          // ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      child: firstsubmitVisibility == true
                                          ? RaisedButton(
                                              child: const Text('SUBMIT',
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              color: Color(0xFFB71C1C),
                                              //Colors.green,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  amountCollection = true;
                                                  firstsubmitVisibility = false;
                                                });

                                                // showDialog(context: context,
                                                //     builder: (BuildContext context){
                                                //       return AlertDialog(
                                                //         title: Text('Amount Collected'),
                                                //         content:
                                                //         TextFormField(
                                                //           controller: amountTextController,
                                                //           validator: (value){
                                                //             for(int i=0;i<limits.length;i++) {
                                                //               if(widget.scheme=="SB") {
                                                //                 if (limits[i]['type'] ==
                                                //                     "SB_ACCOPEN_minLimit") {
                                                //                   minlimit = int.parse(limits[i]['tranlimits']);
                                                //                 }
                                                //               }
                                                //               else if(widget.scheme=="SSA"){
                                                //                 if (limits[i]['type'] ==
                                                //                     "SSA_ACCOPEN_minLimit") {
                                                //                   minlimit = int.parse(limits[i]['tranlimits']);
                                                //
                                                //                 }
                                                //                 if(limits[i]['type']=='SSA_Deposit_Multiplier'){
                                                //                   multiplier=int.parse(limits[i]['tranlimits']);
                                                //                 }
                                                //               }
                                                //               else if(widget.scheme=="TD"){
                                                //                 if (limits[i]['type'] ==
                                                //                     "TD_ACCOPEN_minLimit") {
                                                //                   minlimit = int.parse(limits[i]['tranlimits']);
                                                //                 }
                                                //                 if(limits[i]['type']=='TD_Deposit_Multiplier'){
                                                //                   multiplier=int.parse(limits[i]['tranlimits']);
                                                //                 }
                                                //               }
                                                //             }
                                                //             print("Multiplier: $multiplier");
                                                //
                                                //             if(int.parse(amountTextController.text.toString())>50000){
                                                //               return 'Enter the transaction amount less than or equal to 50000';
                                                //             }
                                                //             else if(int.parse(amountTextController.text.toString())<minlimit && widget.scheme=="SB" ){
                                                //               return 'SB Account opening Limit is $minlimit';
                                                //             }
                                                //             else if(int.parse(amountTextController.text.toString())<minlimit && widget.scheme=="SSA" ){
                                                //               return 'SSA Account opening Limit is $minlimit';
                                                //             }
                                                //             else if(int.parse(amountTextController.text.toString())<minlimit && widget.scheme=="TD" ){
                                                //               return 'TD Account opening Limit is $minlimit';
                                                //             }
                                                //             // else if(int.parse(amountTextController.text.toString())<minlimit && widget.scheme=="SB" ){
                                                //             //   return 'SB Account opening Limit is $minlimit';
                                                //             // }
                                                //
                                                //             return null;
                                                //
                                                //           },
                                                //           decoration: const InputDecoration(
                                                //             hintText: 'Amount in Rupees',
                                                //             labelText: 'Amount Collected',
                                                //             enabledBorder: OutlineInputBorder(
                                                //                 borderSide: BorderSide(
                                                //                     color: Colors.blueGrey, width: 3)
                                                //             ),
                                                //             focusedBorder: OutlineInputBorder(
                                                //                 borderSide: BorderSide(
                                                //                     color: Colors.green, width: 3)
                                                //             ),
                                                //           ),
                                                //           keyboardType: TextInputType.number,
                                                //         ),
                                                //         actions: [
                                                //
                                                //           TextButton(
                                                //               style: ButtonStyle(
                                                //                 // elevation:MaterialStateProperty.all(),
                                                //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                //                       RoundedRectangleBorder(
                                                //                           borderRadius: BorderRadius.circular(18.0),
                                                //                           side: BorderSide(color: Colors.grey)
                                                //                       )
                                                //                   )
                                                //               ),
                                                //               onPressed: ()async {
                                                //           if (_formKey.currentState!.validate()) {
                                                //             // setState(() {
                                                //             //   _isLoading = true;
                                                //             // });
                                                //             // await fetchsoldetails();
                                                //             //
                                                //             //
                                                //             // var request = http.Request('POST',
                                                //             //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
                                                //             // request.files.add(await http.MultipartFile.fromPath(
                                                //             //     '', '$cachepath/fetchAccountDetails.txt'));
                                                //             //
                                                //             // http.StreamedResponse bocodeResponse = await request.send();
                                                //             //
                                                //             // if (bocodeResponse.statusCode == 200) {
                                                //             //   // print(await response.stream.bytesToString());
                                                //             //
                                                //             //   String res = await bocodeResponse.stream.bytesToString();
                                                //             //   print(res);
                                                //             //   Map a = json.decode(res);
                                                //             //   String boData = a['JSONResponse']['jsonContent'];
                                                //             //   Map tempmain = json.decode(boData);
                                                //             //   print(tempmain);
                                                //             //   bdetails = await fac.splitBODetails(tempmain['M_ADD_PARAMS']);
                                                //             //   print(bdetails![4]);
                                                //             //   tid = GenerateRandomString().randomString();
                                                //             //   acrefnum = GenerateRandomString().newaccrefnum();
                                                //             //   await fetchaccOpengdetails(tid!, acrefnum!);
                                                //             //   var request = http.Request('POST',
                                                //             //       Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                //             //   request.files.add(await http.MultipartFile.fromPath(
                                                //             //       '', '$cachepath/acct_opening.txt'));
                                                //             //   http.StreamedResponse response = await request.send();
                                                //             //   setState(() {
                                                //             //     _isLoading = false;
                                                //             //   });
                                                //             //   if (response.statusCode == 200) {
                                                //             //     String res = await response.stream.bytesToString();
                                                //             //     Map a = json.decode(res);
                                                //             //     print(a['JSONResponse']['jsonContent']);
                                                //             //     String data = a['JSONResponse']['jsonContent'];
                                                //             //     main = json.decode(data);
                                                //             //     print("Values");
                                                //             //     print(main);
                                                //             //     if (main['Status'] == "Failure") {
                                                //             //       UtilFs.showToast(
                                                //             //           "Mismatch in OAP Office Account SOLID and BOCode mapping ",
                                                //             //           context);
                                                //             //     }
                                                //             //     else {
                                                //             //       if (main['39'] != "000") {
                                                //             //         UtilFs.showToast(main['127'], context);
                                                //             //         Navigator.pushAndRemoveUntil(
                                                //             //             context,
                                                //             //             MaterialPageRoute(
                                                //             //                 builder:
                                                //             //                     (context) =>
                                                //             //                     AccountOpenMain()),
                                                //             //                 (route) => false);
                                                //             //       }
                                                //             //       else {
                                                //             //         var currentDate = DateTimeDetails().onlyDatewithFormat();
                                                //             //         var currentTime = DateTimeDetails().onlyTime();
                                                //             //         var balance = main['48'].split('+')[2];
                                                //             //         balance = int.parse(balance) > 0 ? (int.parse(balance) / 100)
                                                //             //             .toStringAsFixed(2)
                                                //             //             .toString() : "0.00";
                                                //             //         var TranID = main['126'].split('_')[0];
                                                //             //         print(TranID);
                                                //             //         print("this is get data");
                                                //             //         //   var officedata1 = await OfficeDetail().select().toList();
                                                //             //         //   var soldata1 = await TBCBS_SOL_DETAILS().select().toList();
                                                //             //         //   final tranDetails = TBCBS_TRAN_DETAILS()
                                                //             //         //    ..TRANSACTION_ID=TranID
                                                //             //         //     ..REFERENCE_NO=GenerateRandomString().newaccrefnum()
                                                //             //         //      // ..REFERENCE_NO="F"+DateTimeDetails().cbsRefdatetime()+officedata1[0].OFFICECODE_3!.substring(0,5)+officedata1[0].COOFFICECODE!.substring(0,2)
                                                //             //         // //  ..OFFICE_ACC_NUM=soldata1[0].SOL_ID!+soldata1[0].BO_ID!+"N"
                                                //             //         //     ..OFFICE_ACC_NUM="57144201K1037N"
                                                //             //         //     ..TRANSACTION_AMT=amountTextController.text
                                                //             //         //   ..MODE_OF_TRAN="BYCASH"
                                                //             //         //   ..OPERATOR_ID="10101"
                                                //             //         //     ..TRAN_DATE = currentDate
                                                //             //         //     ..TRAN_TIME = currentTime
                                                //             //         //  ..TRAN_TYPE="Deposit";
                                                //             //         //   tranDetails.save();
                                                //             //
                                                //             //         await TBCBS_TRAN_DETAILS(
                                                //             //           DEVICE_TRAN_ID: tid,
                                                //             //           TRANSACTION_ID: '$TranID',
                                                //             //           REFERENCE_NO: '$acrefnum',
                                                //             //           OFFICE_ACC_NUM: ' ',
                                                //             //           ACCOUNT_TYPE: '${widget.scheme}',
                                                //             //           SCHEME_TYPE: '${widget.scheme}',
                                                //             //           MAIN_HOLDER_NAME: '${widget.name}',
                                                //             //           MAIN_HOLDER_CIFID: '${widget.CIFNumber}',
                                                //             //           JOINT_HOLDER1_NAME: '${widget.j1name}',
                                                //             //           JOINT_HOLDER1_CIFID: '',
                                                //             //           JOINT_HOLDER2_NAME: '${widget.j2name}',
                                                //             //           JOINT_HOLDER2_CIFID: '',
                                                //             //           TRANSACTION_AMT: '${amountTextController.text.toString()}',
                                                //             //           CURRENCY: 'INR',
                                                //             //           TRAN_TYPE: 'O',
                                                //             //           DEVICE_TRAN_TYPE: 'AO',
                                                //             //           TRAN_DATE: '${DateTimeDetails().onlyDate()}',
                                                //             //           TRAN_TIME: '${DateTimeDetails().onlyTime()}',
                                                //             //           FIN_SOLBOD_DATE: '',
                                                //             //           MODE_OF_TRAN: 'cash',
                                                //             //           INSTALMENT_AMT: '0',
                                                //             //           APPR_STATUS: 's',
                                                //             //           TENURE_INW: '',
                                                //             //           OPERATOR_ID: '',
                                                //             //           MINOR_FLAG: '',
                                                //             //           REBATE_AMT: '',
                                                //             //           GUARDIAN_NAME: '',
                                                //             //           STATUS: 'SUCCESS',
                                                //             //           MINOR_DOB: '',
                                                //             //         ).upsert();
                                                //             //
                                                //             //         cbsAcctOpenDetails = await TBCBS_TRAN_DETAILS()
                                                //             //             .select()
                                                //             //             .TRANSACTION_ID
                                                //             //             .equals(TranID)
                                                //             //             .toList();
                                                //             //         print("Reference Number is");
                                                //             //         // print(cbsAcctOpenDetails[0].REFERENCE_NO);
                                                //             //         Navigator.push(
                                                //             //           context,
                                                //             //           MaterialPageRoute(builder: (context) =>
                                                //             //               TransSuccess(
                                                //             //                   cbsAcctOpenDetails[0].TRANSACTION_ID,
                                                //             //                   cbsAcctOpenDetails[0].REFERENCE_NO,
                                                //             //                   cbsAcctOpenDetails[0].OFFICE_ACC_NUM,
                                                //             //                   cbsAcctOpenDetails[0].TRANSACTION_AMT,
                                                //             //                   cbsAcctOpenDetails[0].TRANSACTION_AMT,
                                                //             //                   cbsAcctOpenDetails[0].MODE_OF_TRAN,
                                                //             //                   cbsAcctOpenDetails[0].OPERATOR_ID,
                                                //             //                   cbsAcctOpenDetails[0].TRAN_DATE,
                                                //             //                   cbsAcctOpenDetails[0].TRAN_TIME,
                                                //             //                   cbsAcctOpenDetails[0].TRAN_TYPE,
                                                //             //                   cbsAcctOpenDetails[0].TENURE
                                                //             //               )
                                                //             //           ),
                                                //             //         );
                                                //             //       }
                                                //             //     }
                                                //             //   }
                                                //             //   else {
                                                //             //     print(response.reasonPhrase!);
                                                //             //     UtilFs.showToast(response.reasonPhrase!, context);
                                                //             //   }
                                                //             // }
                                                //             // else {
                                                //             //   print(bocodeResponse.reasonPhrase);
                                                //             // }
                                                //           }
                                                //           },
                                                //               child: Text('SUBMIT',style: TextStyle(color: Colors.red))
                                                //           )
                                                //         ],
                                                //       );
                                                //     });
                                              })
                                          : Container(),
                                    ),

                              // _rebateCalculate==true?  Container(
                              //     child: Row(
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: Row(
                              //             mainAxisAlignment: MainAxisAlignment.start,
                              //             children: [
                              //               Container(
                              //                 width:
                              //                 MediaQuery.of(context).size.width *
                              //                     .90.w,
                              //                 height: MediaQuery.of(context).size.height*.111.h,
                              //                 decoration: BoxDecoration(
                              //                     color: Colors.white,
                              //                     borderRadius: BorderRadius.circular(90.0)),
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.all(8.0),
                              //                   child: TextFormField(
                              //                     readOnly: true,
                              //                     controller: rebatecalc,
                              //                     style:const TextStyle(fontSize: 17,
                              //                         color://Colors.white,
                              //                         Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                              //                     decoration: InputDecoration(
                              //                       floatingLabelBehavior:FloatingLabelBehavior.always,
                              //
                              //                       labelText: "Enter Amount to be collected",
                              //
                              //                       labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                              //                       hintStyle: TextStyle(fontSize: 15,
                              //                         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                              //                       border: InputBorder.none,
                              //
                              //
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               RaisedButton(
                              //                 child: Text("Fetch Rebate details",
                              //                     style: TextStyle(fontSize: 18)),
                              //                     color: Color(0xFFB71C1C),
                              //                     //Colors.green,
                              //                     textColor: Colors.white,
                              //                     shape: RoundedRectangleBorder(
                              //                       borderRadius: BorderRadius.circular(20),),
                              //                 onPressed: ()async{
                              //                   String reqid=DateTimeDetails().cbsdatetime();
                              //                     await fetchRdRebate(reqid);
                              //                 },
                              //               )
                              //               // RaisedButton(
                              //               //     child: const Text('SUBMIT',
                              //               //         style: TextStyle(fontSize: 18)),
                              //               //     color: Color(0xFFB71C1C),
                              //               //     //Colors.green,
                              //               //     textColor: Colors.white,
                              //               //     shape: RoundedRectangleBorder(
                              //               //       borderRadius: BorderRadius.circular(20),
                              //               //     ),
                              //               //     onPressed: (){
                              //               //       showDialog(context: context,
                              //               //           builder: (BuildContext context){
                              //               //             return AlertDialog(
                              //               //               title: Text('Amount Collected'),
                              //               //               content:
                              //               //               TextField(
                              //               //                 controller: amountTextController,
                              //               //                 decoration: const InputDecoration(
                              //               //                   hintText: 'Amount in Rupees',
                              //               //                   labelText: 'Amount Collected',
                              //               //                   enabledBorder: OutlineInputBorder(
                              //               //                       borderSide: BorderSide(
                              //               //                           color: Colors.blueGrey, width: 3)
                              //               //                   ),
                              //               //                   focusedBorder: OutlineInputBorder(
                              //               //                       borderSide: BorderSide(
                              //               //                           color: Colors.green, width: 3)
                              //               //                   ),
                              //               //                 ),
                              //               //                 keyboardType: TextInputType.number,
                              //               //               ),
                              //               //               actions: [
                              //               //
                              //               //                 OutlineButton(onPressed: ()async {
                              //               //                   setState(() {
                              //               //                     _isLoading=true;
                              //               //                   });
                              //               //                   await fetchsoldetails();
                              //               //
                              //               //
                              //               //                   var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
                              //               //                   request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                              //               //
                              //               //                   http.StreamedResponse bocodeResponse = await request.send();
                              //               //
                              //               //                   if (bocodeResponse.statusCode == 200) {
                              //               //                     // print(await response.stream.bytesToString());
                              //               //
                              //               //                     String res=await bocodeResponse.stream.bytesToString();
                              //               //                     print(res);
                              //               //                     Map a=json.decode(res);
                              //               //                     String boData=a['JSONResponse']['jsonContent'];
                              //               //                     Map tempmain=json.decode(boData);
                              //               //                     print(tempmain);
                              //               //                     bdetails = await fac.splitBODetails(tempmain['M_ADD_PARAMS']);
                              //               //                     print(bdetails![4]);
                              //               //                     tid= GenerateRandomString().randomString();
                              //               //                     acrefnum=GenerateRandomString().newaccrefnum();
                              //               //                     await fetchaccOpengdetails(tid!,acrefnum!);
                              //               //                     var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                              //               //                     request.files.add(await http.MultipartFile.fromPath('', '$cachepath/acct_opening.txt'));
                              //               //                     http.StreamedResponse response = await request.send();
                              //               //                     setState(() {
                              //               //                       _isLoading=false;
                              //               //                     });
                              //               //                     if (response.statusCode == 200) {
                              //               //                       String res=await response.stream.bytesToString();
                              //               //                       Map a=json.decode(res);
                              //               //                       print(a['JSONResponse']['jsonContent']);
                              //               //                       String data=a['JSONResponse']['jsonContent'];
                              //               //                       main=json.decode(data);
                              //               //                       print("Values");
                              //               //                       print(main);
                              //               //                       if(main['Status']=="Failure"){
                              //               //                         UtilFs.showToast("Mismatch in OAP Office Account SOLID and BOCode mapping ",context);
                              //               //                       }
                              //               //                       else {
                              //               //                         if(main['39']!="000"){
                              //               //                           UtilFs.showToast(main['127'], context);
                              //               //                           Navigator.pushAndRemoveUntil(
                              //               //                               context,
                              //               //                               MaterialPageRoute(
                              //               //                                   builder:
                              //               //                                       (context) =>
                              //               //                                       AccountOpenMain()),
                              //               //                                   (route) => false);
                              //               //                         }
                              //               //                         else{
                              //               //                           var currentDate= DateTimeDetails().onlyDatewithFormat();
                              //               //                           var currentTime=  DateTimeDetails().onlyTime();
                              //               //                           var balance = main['48'].split('+')[2];
                              //               //                           balance = int.parse(balance)> 0?  (int.parse(balance)/100).toStringAsFixed(2).toString() : "0.00";
                              //               //                           var TranID=main['126'].split('_')[0];
                              //               //                           print(TranID);
                              //               //                           print("this is get data");
                              //               //                           //   var officedata1 = await OfficeDetail().select().toList();
                              //               //                           //   var soldata1 = await TBCBS_SOL_DETAILS().select().toList();
                              //               //                           //   final tranDetails = TBCBS_TRAN_DETAILS()
                              //               //                           //    ..TRANSACTION_ID=TranID
                              //               //                           //     ..REFERENCE_NO=GenerateRandomString().newaccrefnum()
                              //               //                           //      // ..REFERENCE_NO="F"+DateTimeDetails().cbsRefdatetime()+officedata1[0].OFFICECODE_3!.substring(0,5)+officedata1[0].COOFFICECODE!.substring(0,2)
                              //               //                           // //  ..OFFICE_ACC_NUM=soldata1[0].SOL_ID!+soldata1[0].BO_ID!+"N"
                              //               //                           //     ..OFFICE_ACC_NUM="57144201K1037N"
                              //               //                           //     ..TRANSACTION_AMT=amountTextController.text
                              //               //                           //   ..MODE_OF_TRAN="BYCASH"
                              //               //                           //   ..OPERATOR_ID="10101"
                              //               //                           //     ..TRAN_DATE = currentDate
                              //               //                           //     ..TRAN_TIME = currentTime
                              //               //                           //  ..TRAN_TYPE="Deposit";
                              //               //                           //   tranDetails.save();
                              //               //
                              //               //                           await TBCBS_TRAN_DETAILS(
                              //               //                             DEVICE_TRAN_ID:tid,
                              //               //                             TRANSACTION_ID:'$TranID',
                              //               //                             REFERENCE_NO:'$acrefnum',
                              //               //                             OFFICE_ACC_NUM:'undefined',
                              //               //                             ACCOUNT_TYPE:'${widget.scheme}',
                              //               //                             SCHEME_TYPE:'',
                              //               //                             MAIN_HOLDER_NAME:'${widget.name}',
                              //               //                             MAIN_HOLDER_CIFID:'${widget.CIFNumber}',
                              //               //                             JOINT_HOLDER1_NAME:'${widget.j1name}',
                              //               //                             JOINT_HOLDER1_CIFID:'',
                              //               //                             JOINT_HOLDER2_NAME:'${widget.j2name}',
                              //               //                             JOINT_HOLDER2_CIFID:'',
                              //               //                             TRANSACTION_AMT:'${amountTextController.text.toString()}',
                              //               //                             CURRENCY:'INR',
                              //               //                             TRAN_TYPE:'o',
                              //               //                             DEVICE_TRAN_TYPE:'AO',
                              //               //                             TRAN_DATE:'${DateTimeDetails().onlyDate()}',
                              //               //                             TRAN_TIME:'${DateTimeDetails().onlyTime()}',
                              //               //                             FIN_SOLBOD_DATE:'',
                              //               //                             MODE_OF_TRAN:'cash',
                              //               //                             INSTALMENT_AMT:'0',
                              //               //                             APPR_STATUS:'s',
                              //               //                             TENURE_INW:'',
                              //               //                             OPERATOR_ID:'',
                              //               //                             MINOR_FLAG:'',
                              //               //                             REBATE_AMT:'',
                              //               //                             GUARDIAN_NAME:'',
                              //               //                             STATUS:'SUCCESS',
                              //               //                             MINOR_DOB:'',
                              //               //                           ).upsert();
                              //               //
                              //               //                           cbsAcctOpenDetails = await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                              //               //                           print("Reference Number is");
                              //               //                           // print(cbsAcctOpenDetails[0].REFERENCE_NO);
                              //               //                           Navigator.push(
                              //               //                             context,
                              //               //                             MaterialPageRoute(builder: (context) => TransSuccess(
                              //               //                                 cbsAcctOpenDetails[0].REFERENCE_NO,cbsAcctOpenDetails[0].REFERENCE_NO, cbsAcctOpenDetails[0].OFFICE_ACC_NUM, cbsAcctOpenDetails[0].TRANSACTION_AMT,balance, cbsAcctOpenDetails[0].MODE_OF_TRAN, cbsAcctOpenDetails[0].OPERATOR_ID,cbsAcctOpenDetails[0].TRAN_DATE, cbsAcctOpenDetails[0].TRAN_TIME, cbsAcctOpenDetails[0].TRAN_TYPE,cbsAcctOpenDetails[0].TENURE
                              //               //                             )
                              //               //                             ),
                              //               //                           );
                              //               //                         }
                              //               //                       }
                              //               //                     }
                              //               //                     else {
                              //               //                       print(response.reasonPhrase!);
                              //               //                       UtilFs.showToast(response.reasonPhrase!,context);
                              //               //                     }
                              //               //                   }
                              //               //                   else {
                              //               //                     print(bocodeResponse.reasonPhrase);
                              //               //                   }
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //
                              //               //                 },
                              //               //                     child: Text('SUBMIT',style: TextStyle(color: Colors.red))
                              //               //                 )
                              //               //               ],
                              //               //             );
                              //               //           });
                              //               //     }
                              //               // ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ):Container(),
                              // Visibility(
                              //   visible: _isLoading,
                              //   child: Container(
                              //       alignment: Alignment.center,
                              //       margin: const EdgeInsets.only(top: 100.0),
                              //       child: const CircularProgressIndicator(
                              //         color: Colors.blueGrey,
                              //         value: null,
                              //
                              //         //  strokeWidth: 2.0,
                              //       )),
                              // ),
                              SizedBox(
                                width: 10,
                              ),
                              amountCollection == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .90,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .111,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          90.0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: //Colors.white,
                                                          Color.fromARGB(
                                                              255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  controller:
                                                      amountTextController,
                                                  validator: (value) {
                                                    for (int i = 0;
                                                        i < limits.length;
                                                        i++) {
                                                      if (widget.scheme ==
                                                          "SBGEN") {
                                                        if (limits[i]['type'] ==
                                                            "SB_ACCOPEN_minLimit") {
                                                          minlimit = int.parse(
                                                              limits[i][
                                                                  'tranlimits']);
                                                        }
                                                      } else if (widget
                                                              .scheme ==
                                                          "SSA") {
                                                        if (limits[i]['type'] ==
                                                            "SSA_ACCOPEN_minLimit") {
                                                          minlimit = int.parse(
                                                              limits[i][
                                                                  'tranlimits']);
                                                        }
                                                        if (limits[i]['type'] ==
                                                            'SSA_Deposit_Multiplier') {
                                                          multiplier = int
                                                              .parse(limits[i][
                                                                  'tranlimits']);
                                                        }
                                                      } else if (widget
                                                              .scheme ==
                                                          "TD") {
                                                        if (limits[i]['type'] ==
                                                            "TD_ACCOPEN_minLimit") {
                                                          minlimit = int.parse(
                                                              limits[i][
                                                                  'tranlimits']);
                                                        }
                                                        if (limits[i]['type'] ==
                                                            'TD_Deposit_Multiplier') {
                                                          multiplier = int
                                                              .parse(limits[i][
                                                                  'tranlimits']);
                                                        }
                                                      }
                                                    }
                                                    // print("Multiplier: $multiplier");

                                                    if (int.parse(
                                                            amountTextController
                                                                .text
                                                                .toString()) >
                                                        50000) {
                                                      return 'Enter the transaction amount less than or equal to 50000';
                                                    }
                                                    if (widget.scheme ==
                                                            "SBGEN" &&
                                                        int.parse(amountTextController
                                                                .text
                                                                .toString()) <
                                                            minlimit) {
                                                      return 'SB Account opening Limit is $minlimit';
                                                    } else if (int.parse(
                                                                amountTextController
                                                                    .text
                                                                    .toString()) <
                                                            minlimit &&
                                                        widget.scheme ==
                                                            "SSA") {
                                                      return 'SSA Account opening Limit is $minlimit';
                                                    } else if (int.parse(
                                                                amountTextController
                                                                    .text
                                                                    .toString()) <
                                                            minlimit &&
                                                        widget.scheme == "TD") {
                                                      return 'TD Account opening Limit is $minlimit';
                                                    } else if (widget.scheme ==
                                                            "TD" &&
                                                        int.parse(amountTextController
                                                                    .text
                                                                    .toString())
                                                                .remainder(
                                                                    multiplier) !=
                                                            0) {
                                                      return 'TD Account value should be in multiples of $multiplier';
                                                    } else if (widget.scheme ==
                                                            "SSA" &&
                                                        int.parse(amountTextController
                                                                    .text
                                                                    .toString())
                                                                .remainder(
                                                                    multiplier) !=
                                                            0) {
                                                      return 'SSA Account value should be in multiples of $multiplier';
                                                    }
                                                    // else if(int.parse(amountTextController.text.toString())<minlimit && widget.scheme=="SB" ){
                                                    //   return 'SB Account opening Limit is $minlimit';
                                                    // }

                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Amount in Rupees',
                                                    labelText:
                                                        'Amount Collected',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                                style: ButtonStyle(
                                                    // elevation:MaterialStateProperty.all(),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .grey)))),
                                                onPressed: () async {
                                                  var login =
                                                      await USERDETAILS()
                                                          .select()
                                                          .toList();
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    encheader =
                                                        await encryptfetchsoldetails();
                                                    List<USERLOGINDETAILS>
                                                        acctoken =
                                                        await USERLOGINDETAILS()
                                                            .select()
                                                            .toList();

                                                    // var request = http.Request(
                                                    //     'POST',
                                                    //     Uri.parse(
                                                    //         'https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
                                                    // request.files.add(await http
                                                    //         .MultipartFile
                                                    //     .fromPath('',
                                                    //         '$cachepath/fetchAccountDetails.txt'));
                                                    try {
                                                      var headers = {
                                                        'Signature':
                                                            '$encheader',
                                                        'Uri':
                                                            'requestSOLDetails',
                                                        // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                        'Authorization':
                                                            'Bearer ${acctoken[0].AccessToken}',
                                                        'Cookie':
                                                            'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                      };

                                                      final File file = File('$cachepath/fetchAccountDetails.txt');
                                                      String tosendText = await file.readAsString();
                                                      var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                      request.body=tosendText;

                                                      request.headers
                                                          .addAll(headers);

                                                      http.StreamedResponse
                                                          bocodeResponse =
                                                          await request
                                                              .send()
                                                              .timeout(
                                                                  const Duration(
                                                                      seconds:
                                                                          65),
                                                                  onTimeout:
                                                                      () {
                                                        // return UtilFs.showToast('The request Timeout',context);
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        throw 'TIMEOUT';
                                                      });

                                                      if (bocodeResponse
                                                              .statusCode ==
                                                          200) {
                                                        // print(await response.stream.bytesToString());

                                                        var resheaders =
                                                            await bocodeResponse
                                                                .headers;
                                                        print("Result Headers");
                                                        print(resheaders);
                                                        String temp = resheaders['authorization']!;
                                                        String decryptSignature = temp;
                                                        String res =
                                                            await bocodeResponse
                                                                .stream
                                                                .bytesToString();
                                                        String temp1 = resheaders['authorization']!;
                                                        String decryptSignature1 = temp1;

                                                        String val =
                                                        await decryption1(decryptSignature1, res);
                                                        print(res);
                                                        if (val ==
                                                            "Verified!") {
                                                          await LogCat().writeContent(
                                                    '$res');

                                                          Map a =
                                                              json.decode(res);
                                                          String boData = a[
                                                                  'JSONResponse']
                                                              ['jsonContent'];
                                                          Map tempmain = json
                                                              .decode(boData);
                                                          print(tempmain);
                                                          bdetails = await fac
                                                              .splitBODetails(
                                                                  tempmain[
                                                                      'M_ADD_PARAMS']);
                                                          print(bdetails![4]);
                                                          try {
                                                            encheader =
                                                                await encryptOAPDetails();
                                                          } catch (e) {
                                                            print(e);
                                                          }
                                                          try {
                                                            print("IN SB Acc");
                                                            print(
                                                                "Reached for sending request");
                                                            print("$cachepath");
                                                            print(await File(
                                                                    "$cachepath/acct_opening.txt")
                                                                .readAsStringSync());
                                                            print(encheader);
                                                            var headers = {
                                                              'Signature':
                                                                  '$encheader',
                                                              'Uri':
                                                                  'requestJson',
                                                              // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                              'Authorization':
                                                                  'Bearer ${acctoken[0].AccessToken}',
                                                              'Cookie':
                                                                  'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                            };

                                                            final File file = File('$cachepath/acct_opening.txt');
                                                            String tosendText = await file.readAsString();
                                                            var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                            request.body=tosendText;
                                                            request.headers
                                                                .addAll(
                                                                    headers);
                                                            print(
                                                                "Request before sending: $request");
                                                            http.StreamedResponse
                                                                oapresponse =
                                                                await request.send().timeout(
                                                                    const Duration(
                                                                        seconds:
                                                                            65),
                                                                    onTimeout:
                                                                        () {
                                                              // return UtilFs.showToast('The request Timeout',context);
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              throw 'TIMEOUT';
                                                            });
                                                            print(
                                                                "Request after sending: $request");
                                                            // setState(() {
                                                            //   _isLoading =
                                                            //       false;
                                                            // });
                                                            print(oapresponse
                                                                .statusCode);
                                                            if (oapresponse
                                                                    .statusCode ==
                                                                200) {
                                                              var resheaders =
                                                                  await oapresponse
                                                                      .headers;
                                                              print(
                                                                  "Result Headers");
                                                              print(resheaders);

                                                              String res =
                                                                  await oapresponse
                                                                      .stream
                                                                      .bytesToString();
                                                              String temp = resheaders['authorization']!;
                                                              String decryptSignature = temp;

                                                              String val =
                                                              await decryption1(decryptSignature, res);
                                                              if (val ==
                                                                  "Verified!") {
                                                                await LogCat().writeContent(
                                                    '$res');

                                                                Map a =
                                                                    json.decode(
                                                                        res);
                                                                print(a['JSONResponse']
                                                                    [
                                                                    'jsonContent']);
                                                                String data = a[
                                                                        'JSONResponse']
                                                                    [
                                                                    'jsonContent'];
                                                                Map oapmain =
                                                                    json.decode(
                                                                        data);
                                                                print("Values");
                                                                print(oapmain);

                                                                if (oapmain[
                                                                        '39'] !=
                                                                    "000") {
                                                                  var ec = await CBS_ERROR_CODES()
                                                                      .select()
                                                                      .Error_code
                                                                      .equals(oapmain[
                                                                          '39'])
                                                                      .toList();
                                                                  UtilFsNav.showToast(
                                                                      '${ec[0].Error_message}',
                                                                      context,
                                                                      AccountOpenMain());
                                                                  // Navigator.pushAndRemoveUntil(
                                                                  //     context,
                                                                  //     MaterialPageRoute(
                                                                  //         builder: (context) =>
                                                                  //             AccountOpenMain()),
                                                                  //     (route) =>
                                                                  //         false);
                                                                } else {
                                                                  String circlecode = oapmain[
                                                                          'M_ADD_PARAMS']
                                                                      .toString()
                                                                      .split(
                                                                          "|")[6];
                                                                  tid = GenerateRandomString()
                                                                      .randomString();
                                                                  acrefnum = GenerateRandomString()
                                                                      .newaccrefnum(
                                                                          circlecode);

                                                                  String?
                                                                  tdtenure;


                                                                  if (widget.tdvalue ==
                                                                      "1 Yr") {
                                                                    tdtenure = "1 Year";
                                                                  }
                                                                  if (widget.tdvalue ==
                                                                      "2 Yr") {
                                                                    tdtenure = "2 Years";
                                                                  }
                                                                  if (widget.tdvalue ==
                                                                      "3 Yr") {
                                                                    tdtenure = "3 Years";
                                                                  }
                                                                  if (widget.tdvalue ==
                                                                      "5 Yr") {
                                                                    tdtenure = "5 Years";
                                                                  }
                                                                  await TBCBS_TRAN_DETAILS(DEVICE_TRAN_ID: tid, TRANSACTION_ID: tid, REFERENCE_NO: '$acrefnum', OFFICE_ACC_NUM: '${bdetails![4]}', ACCOUNT_TYPE: '${widget.scheme}', SCHEME_TYPE: '${widget.scheme}', MAIN_HOLDER_NAME: '${widget.name}', MAIN_HOLDER_CIFID: '${widget.CIFNumber}', JOINT_HOLDER1_NAME: '${widget.j1name}', JOINT_HOLDER1_CIFID: '', JOINT_HOLDER2_NAME: '${widget.j2name}', JOINT_HOLDER2_CIFID: '', TRANSACTION_AMT: '${amountTextController.text.toString()}', CURRENCY: 'INR', TRAN_TYPE: 'O', DEVICE_TRAN_TYPE: 'AO', TRAN_DATE: '${DateTimeDetails().currentDate()}', TRAN_TIME: '${DateTimeDetails().onlyTime()}', FIN_SOLBOD_DATE: '', MODE_OF_TRAN: 'cash', INSTALMENT_AMT: '0', APPR_STATUS: 's', TENURE_INW: '', OPERATOR_ID: '${login[0].EMPID}', MINOR_FLAG: '', REBATE_AMT: '', GUARDIAN_NAME: '', STATUS: 'PENDING', MINOR_DOB: '', TENURE: widget.scheme == "TD" ? tdtenure : 'Not Applicable').upsert();


                                                                  encheader =
                                                                      await encyrptfetchaccOpengdetails(
                                                                          tid!,
                                                                          acrefnum!);
                                                                  // var request =
                                                                  // http.Request(
                                                                  // 'POST',
                                                                  // Uri.parse(
                                                                  // 'https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                                  // request.files.add(await http
                                                                  //     .MultipartFile
                                                                  //     .fromPath('',
                                                                  // '$cachepath/acct_opening.txt'));
                                                                  try {
                                                                    var headers =
                                                                        {
                                                                      'Signature':
                                                                          '$encheader',
                                                                      'Uri':
                                                                          'requestJson',
                                                                      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                      'Authorization':
                                                                          'Bearer ${acctoken[0].AccessToken}',
                                                                      'Cookie':
                                                                          'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                    };

                                                                    final File file = File('$cachepath/fetchAccountDetails.txt');
                                                                    String tosendText = await file.readAsString();
                                                                    var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                    request.body=tosendText;

                                                                    request
                                                                        .headers
                                                                        .addAll(
                                                                            headers);
                                                                    http.StreamedResponse
                                                                        response =
                                                                        await request.send().timeout(
                                                                            const Duration(seconds: 65),
                                                                            onTimeout:
                                                                                () {
                                                                      // return UtilFs.showToast('The request Timeout',context);
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                      throw 'TIMEOUT';
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      _isLoading =
                                                                          false;
                                                                    });
                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      var resheaders =
                                                                          await response
                                                                              .headers;
                                                                      print(
                                                                          "Result Headers");
                                                                      print(
                                                                          resheaders);

                                                                      String
                                                                          res =
                                                                          await response
                                                                              .stream
                                                                              .bytesToString();
                                                                      String temp = resheaders['authorization']!;
                                                                      String decryptSignature = temp;

                                                                      String val =
                                                                      await decryption1(decryptSignature, res);
                                                                      if (val ==
                                                                          "Verified!") {
                                                                        await LogCat().writeContent(
                                                    '$res');

                                                                        Map a =
                                                                            json.decode(res);
                                                                        print(a['JSONResponse']
                                                                            [
                                                                            'jsonContent']);
                                                                        String
                                                                            data =
                                                                            a['JSONResponse']['jsonContent'];
                                                                        main = json
                                                                            .decode(data);
                                                                        print(
                                                                            "Values");
                                                                        print(
                                                                            main);
                                                                        if (main['Status'] ==
                                                                            "Failure") {
                                                                          UtilFsNav.showToast(
                                                                              "Mismatch in OAP Office Account SOLID and BOCode mapping ",
                                                                              context,
                                                                              AccountOpenMain());
                                                                        } else {
                                                                          if (main['39'] !=
                                                                              "000") {
                                                                            var ec =
                                                                                await CBS_ERROR_CODES().select().Error_code.equals(main['39']).toList();
                                                                            UtilFsNav.showToast(
                                                                                '${ec[0].Error_message}',
                                                                                context,
                                                                                AccountOpenMain());
                                                                            // Navigator.pushAndRemoveUntil(
                                                                            //     context,
                                                                            //     MaterialPageRoute(builder: (context) => AccountOpenMain()),
                                                                            //     (route) => false);
                                                                          } else {

                                                                            var currentDate =
                                                                                DateTimeDetails().onlyDatewithFormat();
                                                                            var currentTime =
                                                                                DateTimeDetails().onlyTime();
                                                                            var balance =
                                                                                main['48'].split('+')[2];
                                                                            balance = int.parse(balance) > 0
                                                                                ? (int.parse(balance) / 100).toStringAsFixed(2).toString()
                                                                                : "0.00";
                                                                            var TranID =
                                                                                main['126'].split('_')[0].toString().trim();
                                                                            print(TranID);
                                                                            print("this is get data");
                                                                            //   var officedata1 = await OfficeDetail().select().toList();
                                                                            //   var soldata1 = await TBCBS_SOL_DETAILS().select().toList();
                                                                            //   final tranDetails = TBCBS_TRAN_DETAILS()
                                                                            //    ..TRANSACTION_ID=TranID
                                                                            //     ..REFERENCE_NO=GenerateRandomString().newaccrefnum()
                                                                            //      // ..REFERENCE_NO="F"+DateTimeDetails().cbsRefdatetime()+officedata1[0].OFFICECODE_3!.substring(0,5)+officedata1[0].COOFFICECODE!.substring(0,2)
                                                                            // //  ..OFFICE_ACC_NUM=soldata1[0].SOL_ID!+soldata1[0].BO_ID!+"N"
                                                                            //     ..OFFICE_ACC_NUM="57144201K1037N"
                                                                            //     ..TRANSACTION_AMT=amountTextController.text
                                                                            //   ..MODE_OF_TRAN="BYCASH"
                                                                            //   ..OPERATOR_ID="10101"
                                                                            //     ..TRAN_DATE = currentDate
                                                                            //     ..TRAN_TIME = currentTime
                                                                            //  ..TRAN_TYPE="Deposit";
                                                                            //   tranDetails.save();


                                                                            await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                              'TRANSACTION_ID': '$TranID',
                                                                              'STATUS': 'SUCCESS',
                                                                            });

                                                                                   final addCash =  CashTable()
                                                                              ..Cash_ID = '$acrefnum'
                                                                              ..Cash_Date = DateTimeDetails().currentDate()
                                                                              ..Cash_Time = DateTimeDetails().onlyTime()
                                                                              ..Cash_Type = 'Add'
                                                                              ..Cash_Amount = double.parse('${amountTextController.text.toString()}')
                                                                              ..Cash_Description = "${widget.scheme} A/c Opening";
                                                                            await addCash.save();

                                                                            final addTransaction = TransactionTable()
                                                                              ..tranid = '$TranID'
                                                                              ..tranDescription = "${widget.scheme} A/c Opening"
                                                                              ..tranAmount = double.parse('${amountTextController.text.toString()}')
                                                                              ..tranType = "CBS"
                                                                              ..tranDate = DateTimeDetails().currentDate()
                                                                              ..tranTime = DateTimeDetails().onlyTime()
                                                                              ..valuation = "Add";
                                                                            await addTransaction.save();
                                                                            cbsAcctOpenDetails =
                                                                                await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                                                                            print("Reference Number is");
                                                                            // print(cbsAcctOpenDetails[0].REFERENCE_NO);
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => TransSuccess(cbsAcctOpenDetails[0].TRANSACTION_ID, cbsAcctOpenDetails[0].REFERENCE_NO, cbsAcctOpenDetails[0].OFFICE_ACC_NUM, cbsAcctOpenDetails[0].TRANSACTION_AMT, cbsAcctOpenDetails[0].TRANSACTION_AMT, cbsAcctOpenDetails[0].MODE_OF_TRAN, cbsAcctOpenDetails[0].OPERATOR_ID, cbsAcctOpenDetails[0].TRAN_DATE, cbsAcctOpenDetails[0].TRAN_TIME, cbsAcctOpenDetails[0].TRAN_TYPE, cbsAcctOpenDetails[0].TENURE,widget.moop)),
                                                                            );
                                                                          }
                                                                        }
                                                                      }
                                                                    } else {
                                                                      // print(await response
                                                                      //     .stream
                                                                      //     .bytesToString());
                                                                      // UtilFsNav.showToast(
                                                                      //     "${response.statusCode}",
                                                                      //     context,
                                                                      //     AccountOpenMain());

                                                                      print(response.statusCode);
                                                                      List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                                      if(response.statusCode==503 || response.statusCode==504){
                                                                        UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                                      }
                                                                      else
                                                                        UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                                    }
                                                                  } catch (_) {
                                                                    if (_.toString() ==
                                                                        "TIMEOUT") {
                                                                      return UtilFsNav.showToast(
                                                                          "Request Timed Out",
                                                                          context,
                                                                          AccountOpenMain());
                                                                    }
                                                                  }
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                                print(await oapresponse
                                                                    .stream
                                                                    .bytesToString());
                                                                UtilFsNav.showToast(
                                                                    "${oapresponse.statusCode}",
                                                                    context,
                                                                    AccountOpenMain());
                                                              }
                                                            } else {
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              // print(await oapresponse
                                                              //     .stream
                                                              //     .bytesToString());
                                                              // UtilFsNav.showToast(
                                                              //     "${oapresponse.statusCode}",
                                                              //     context,
                                                              //     AccountOpenMain());
                                                              print(oapresponse.statusCode);
                                                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(oapresponse.statusCode).toList();
                                                              if(oapresponse.statusCode==503 || oapresponse.statusCode==504){
                                                                UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                              }
                                                              else
                                                                UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                            }
                                                          } catch (_) {
                                                            if (_.toString() ==
                                                                "TIMEOUT") {
                                                              return UtilFsNav
                                                                  .showToast(
                                                                      "Request Timed Out",
                                                                      context,
                                                                      AccountOpenMain());
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        print(bocodeResponse
                                                            .reasonPhrase);
                                                        print(await bocodeResponse
                                                            .stream
                                                            .bytesToString());
                                                        print(bocodeResponse
                                                            .statusCode);

                                                        print(bocodeResponse.statusCode);
                                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(bocodeResponse.statusCode).toList();
                                                        if(bocodeResponse.statusCode==503 || bocodeResponse.statusCode==504){
                                                          UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                        }
                                                        else
                                                          UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());

                                                      }
                                                    } catch (_) {
                                                      if (_.toString() ==
                                                          "TIMEOUT") {
                                                        return UtilFsNav.showToast(
                                                            "Request Timed Out",
                                                            context,
                                                            AccountOpenMain());
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Text('SUBMIT',
                                                    style: TextStyle(
                                                        color: Colors.red)))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      }
                    }),
              ),
            ),
            Container(
                child: _isLoading
                    ? Loader(
                        isCustom: true, loadingTxt: 'Please Wait...Loading...')
                    : Container()),
          ],
        ),
      ),
    );
  }

  //
  // Future<File> fetchaccOpengdetails(String tid,String refnum) async {
  //   var login=await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached writeContent");
  //   String tot=widget.scheme=="RDIPN"?rdamtocollect!.padLeft(14,'0').toString():amountTextController.text.padLeft(14,'0');
  //   print(tot);
  //   String padt=tot.padRight(16,'0');
  //   print(padt);
  //   Directory directory = Directory('$cachepath');
  //   final file=await  File('$cachepath/acct_Opening.txt');
  //   file.writeAsStringSync('');
  //   String text='{"2":"${bdetails![4]}","3":"490000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        ${login[0].SOL_ID}${bdetails![4]}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  ","127":"$refnum"}';
  //   print("selfopenacct$text");
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptOAPDetails() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached writeContent");
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/acct_opening.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/acct_opening.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text ="$bound""\nContent-Id: <jsonInStream>\n\n"'{"2":"${bdetails![4]}","3":"490000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        ${login[0].SOL_ID}${bdetails![4]}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  ","127":"$refnum"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${bdetails![4]}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${bdetails![4]}","123":"SDP"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";

    print("selfopenacct");
    print(text.trim());
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New account Opening ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    print(await File('$cachepath/acct_opening.txt').readAsStringSync());
    return test;
  }

  Future<String> encyrptfetchaccOpengdetails(String tid, String refnum) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached writeContent");
    String tot = widget.scheme == "RD"
        ? rdamtocollect!.padLeft(14, '0').toString()
        : amountTextController.text.padLeft(14, '0');
    print(tot);
    String padt = tot.padRight(16, '0');
    print(padt);
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/acct_opening.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${bdetails![4]}","3":"490000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        ${login[0].SOL_ID}${bdetails![4]}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  ","127":"$refnum"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("selfopenacct");
    print(text.trim());
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("New Account Opening acc Ref Num ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchsoldetails() async {
  //   var login=await USERDETAILS().select().toList();
  //   Directory directory = Directory('$cachepath');
  //   final file=await  File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   String text='{"BO_ID":"${login[0].BOFacilityID}"}';
  //   print("selfopenacct$text");
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchsoldetails() async {
    var login = await USERDETAILS().select().toList();
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSOLDetails", "postBOID");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text = "$bound""\nContent-Id: <postBOID>\n\n"
    //     '{"BO_ID":"${login[0].BOFacilityID}"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";

    String text = "$bound"
        "\nContent-Id: <postBOID>\n\n"
        '{"BO_ID":"${login[0].BOFacilityID}"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("selfopenacct$text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("ACCCCCFile Contents: " + text);
   LogCat().writeContent(" New account opening SOL Details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    print(await File('$cachepath/fetchAccountDetails.txt').readAsStringSync());
    return test;
  }

  // Future<File> fetchRdRebate(String rid,int val) async {
  //
  //
  //
  //     Directory directory = Directory('$cachepath');
  //     final file=await  File('$cachepath/fetchAccountDetails.txt');
  //     file.writeAsStringSync('');
  //     String text='{"m_ServiceReqId":"calculateRebate","m_ReqUUID":"Req_$rid","m_installNum":$val,"m_monInstall":"${widget.rdinst}","responseParams":"successOrFailure,rebate"}';
  //     print("selfopenacct$text");
  //     return file.writeAsString(text, mode: FileMode.append);
  //
  //
  // }

  Future<String> encryptfetchRdRebate(String rid, int val) async {
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ServiceReqId":"calculateRebate","m_ReqUUID":"Req_$rid","m_installNum":$val,"m_monInstall":"${widget.rdinst}","responseParams":"successOrFailure,rebate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("selfopenacct$text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New account RD Rebate ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
