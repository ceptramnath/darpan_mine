import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Utils/Printing.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import 'PremiumCollection.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class proposalpaymentconfirmation extends StatefulWidget {
  String insName;
  String propamount;
  String amount;
  String policyNumber;
  String carr;
  String name;

  proposalpaymentconfirmation(this.insName, this.propamount, this.amount,
      this.policyNumber, this.carr, this.name);

  @override
  _proposalpaymentconfirmationState createState() =>
      _proposalpaymentconfirmationState();
}

class _proposalpaymentconfirmationState
    extends State<proposalpaymentconfirmation> {
  List<String> _services = ["Cash", "Cheque/DemandDraft"];
  late Directory d;
  late String cachepath;

  List<String> acctypes = ["POSB", "Non POSB"];

  // String _selectedacc = "POSB";
  String _selectedValue = "Cash";
  TextEditingController chequeno = TextEditingController();
  TextEditingController chequeDate = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController micr = TextEditingController();
  String? _selectedDate;
  String? _currentDate;
  Map mainProposal = {};
  bool calc = true;
  bool cash = true;
  bool cheque = false;
  bool posb = false;
  bool nonposb = false;
  bool chequedet = false;
  String? encheader;
  bool _isLoading = false;

  @override
  void initState() {
    getCacheDir();
    _selectedDate == ''
        ? _selectedDate = _currentDate
        : _selectedDate = _selectedDate;
    super.initState();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Confirmation")),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Payment Details",
                        style: TextStyle(
                            color: Colors.blueGrey[300], fontSize: 18),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 2.0),
                  // padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Amount Payable",
                              style: TextStyle(
                                  color: Colors.blueGrey[300], fontSize: 18),
                            ),
                            Text(
                              "\u{20B9} ${widget.amount}",
                              style: TextStyle(
                                  color: Colors.blueGrey[300], fontSize: 18),
                            ),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Mode of Payment",
                        style: TextStyle(
                            color: Colors.blueGrey[300], fontSize: 18),
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
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Cash",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.blueGrey),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                    value: cash,
                                    onChanged: (value) {
                                      cash = value;
                                      if (cash == true) {
                                        setState(() {
                                          cheque = false;
                                          chequedet = false;
                                          posb = false;
                                          nonposb = false;
                                        });
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Cheque/Demand Draft",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.blueGrey),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                    value: cheque,
                                    onChanged: (value) {
                                      cheque = value;
                                      if (cheque == true) {
                                        setState(() {
                                          chequedet = true;
                                          cash = false;
                                          posb = true;
                                          nonposb = false;
                                        });
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: cheque,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, bottom: 2.0, top: 8.0, right: 8.0),
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                ),
                Visibility(
                  visible: cheque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Cheque Details",
                          style: TextStyle(
                              color: Colors.blueGrey[300], fontSize: 18),
                        )),
                  ),
                ),
                Visibility(
                  visible: cheque,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: chequeno,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Cheque No.",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              child: GestureDetector(
                                  onTap: () => _selectDate,
                                  child: IgnorePointer(
                                    child: TextFormField(
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500),
                                      controller: chequeDate,
                                      decoration: const InputDecoration(
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Cheque Date",
                                        labelStyle:
                                            TextStyle(color: Color(0xFFCFB53B)),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "POSB",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: CupertinoSwitch(
                                          value: posb,
                                          onChanged: (value) {
                                            posb = value;
                                            if (posb == true) {
                                              setState(() {
                                                nonposb = false;
                                              });
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "NON-POSB",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: CupertinoSwitch(
                                          value: nonposb,
                                          onChanged: (value) {
                                            nonposb = value;
                                            if (nonposb == true) {
                                              setState(() {
                                                posb = false;
                                              });
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: chequedet,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: ifsc,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "IFSC Code",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: bank,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Drawee Bank/PO",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      nonposb == true
                          ? Container(
                              width: MediaQuery.of(context).size.width * .95,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.5, left: 15.0),
                                child: TextFormField(
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: micr,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "MICR Code",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                              // elevation:MaterialStateProperty.all(),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                      return Stack(
                                        children: [
                                          Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            "Do you want to proceed with payment of \n${widget.amount}. \n\n Please note that transaction once initiated cannot be reverted",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              TextButton(
                                                                child: Text(
                                                                  "YES",
                                                                  style: TextStyle(
                                                                      color:
                                                                          Colors.white),
                                                                ),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty
                                                                            .all(Colors
                                                                                .red)),
                                                                onPressed: () async {
                                                                  setState(() {
                                                                    _isLoading = true;
                                                                  });


                                                                  List<DAY_TRANSACTION_REPORT> pendcheck=await DAY_TRANSACTION_REPORT().select().PROPOSAL_NUM.equals(widget.policyNumber).and.startBlock.STATUS.equals("PENDING").endBlock.toList();
                                                                  var tranid;

                                                                  List<USERLOGINDETAILS>
                                                                      acctoken =
                                                                      await USERLOGINDETAILS()
                                                                          .select()
                                                                          .toList();
                                                                  var login =
                                                                      await USERDETAILS()
                                                                          .select()
                                                                          .toList();
                                                                  if(pendcheck.length==0) {
                                                                    tranid =
                                                                        GenerateRandomString()
                                                                            .randomString();
                                                                    final initpremsave = DAY_TRANSACTION_REPORT(
                                                                        STATUS: 'PENDING',
                                                                        TRAN_ID: tranid,
                                                                        TRAN_PAYMENT_TYPE:
                                                                        'IP',
                                                                        RECEIPT_NO:
                                                                        tranid,
                                                                        POLICY_TYPE:
                                                                        widget
                                                                            .carr,
                                                                        OPERATOR_ID:
                                                                        '${login[0]
                                                                            .EMPID}',
                                                                        AMOUNT:
                                                                        widget
                                                                            .amount,
                                                                        POLICY_NO: '',
                                                                        PROPOSAL_NUM: widget
                                                                            .policyNumber,
                                                                        TRAN_TYPE: 'I',
                                                                        TRAN_DATE:
                                                                        DateTimeDetails()
                                                                            .onlyExpDate(),
                                                                        R_CRE_TIME:
                                                                        DateTimeDetails()
                                                                            .oT(),
                                                                        PAYMENT_MODE:
                                                                        cash ==
                                                                            true
                                                                            ? "CASH"
                                                                            : "CHEQUE",
                                                                        CGST: '0',
                                                                        SGST: '0',
                                                                        UGST: '0',
                                                                        TOTAL_GST: '0',
                                                                        PAYMENT_CATEGORY:
                                                                        'F',
                                                                        GSTN_ID: '',
                                                                        DEFAULT_FEE: '',
                                                                        PREM_AMNT: widget
                                                                            .propamount);
                                                                    await initpremsave
                                                                        .save();
                                                                  }

                                                                  else{
                                                                  tranid=pendcheck[0].TRAN_ID;
                                                                  }
                                                                  print("In payment confirmation tranid");
                                                                  print(tranid);
                                                                  encheader =
                                                                      await encryptwriteContent(
                                                                          tranid);
                                                                  // var headers = {
                                                                  //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                                                  // };
                                                                  // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/payPremiumForProposal'));
                                                                  // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                                                  // request.headers.addAll(headers);
                                                                  //
                                                                  // http.StreamedResponse response = await request.send();



                                                                  try {
                                                                    var headers = {
                                                                      'Signature':
                                                                          '$encheader',
                                                                      'Uri':
                                                                          'payPremiumForProposal',
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
                                                                    request.headers
                                                                        .addAll(
                                                                            headers);
                                                                    http.StreamedResponse
                                                                        response =
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

                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                      print(
                                                                          "After paying premium");
                                                                      // print(await response.stream.bytesToString());
                                                                      var resheaders =
                                                                          response
                                                                              .headers;
                                                                      print(
                                                                          "Response Headers");
                                                                      print(resheaders[
                                                                          'authorization']);

                                                                      String res =
                                                                          await response
                                                                              .stream
                                                                              .bytesToString();
                                                                      print(res);
                                                                      String temp = resheaders['authorization']!;
                                                                      String decryptSignature = temp;

                                                                      String val =
                                                                      await decryption1(decryptSignature, res);

                                                                      if (val ==
                                                                          "Verified!") {
                                                                        await LogCat().writeContent(
                                                    '$res');
                                                                        setState(() {
                                                                          _isLoading =
                                                                              false;
                                                                        });
                                                                        print(res);
                                                                        print("\n\n");
                                                                        Map a =
                                                                            json.decode(
                                                                                res);
                                                                        print(
                                                                            "Map a: $a");
                                                                        print(a['JSONResponse']
                                                                            [
                                                                            'jsonContent']);
                                                                        String data = a[
                                                                                'JSONResponse']
                                                                            [
                                                                            'jsonContent'];
                                                                        print(data);
                                                                        mainProposal =
                                                                            json.decode(
                                                                                data);
                                                                        print(mainProposal[
                                                                            'responseNo']);
                                                                        if (mainProposal[
                                                                                'responseNo'] ==
                                                                            "0") {
                                                                          // String s =
                                                                          //     widget
                                                                          //         .amount;
                                                                          // String
                                                                          // result =
                                                                          // s.substring(
                                                                          //     0,
                                                                          //     s.indexOf(
                                                                          //         '.'));
                                                                          String
                                                                              result =
                                                                              widget
                                                                                  .amount;
                                                                          final addtran =
                                                                              Ins_transaction()
                                                                                ..tranTime =
                                                                                    DateTimeDetails().onlyTime()
                                                                                ..policyType =
                                                                                    widget.carr
                                                                                ..tranDate =
                                                                                    DateTimeDetails().currentDate()
                                                                                ..amount =
                                                                                    result
                                                                                ..policyNumber =
                                                                                    widget.policyNumber
                                                                                ..tranType =
                                                                                    "InitialPremium";
                                                                          addtran
                                                                              .save();
                                                                          final addCash =
                                                                              CashTable()
                                                                                ..Cash_ID =
                                                                                    widget.policyNumber
                                                                                ..Cash_Date =
                                                                                    DateTimeDetails().currentDate()
                                                                                ..Cash_Time =
                                                                                    DateTimeDetails().onlyTime()
                                                                                ..Cash_Type =
                                                                                    'Add'
                                                                                ..Cash_Amount =
                                                                                    double.parse(result)
                                                                                ..Cash_Description =
                                                                                    "${widget.carr} Initial Premium";
                                                                          if (cash ==
                                                                              true) {
                                                                            addCash
                                                                                .save();
                                                                          }
                                                                          final addTransaction =
                                                                              TransactionTable()
                                                                                ..tranid =
                                                                                    'INS${DateTimeDetails().filetimeformat()}'
                                                                                ..tranDescription =
                                                                                    "PremiumPayment- ${widget.policyNumber}"
                                                                                ..tranAmount =
                                                                                    double.parse(widget.amount)
                                                                                ..tranType =
                                                                                    "Insurance"
                                                                                ..tranDate =
                                                                                    DateTimeDetails().currentDate()
                                                                                ..tranTime =
                                                                                    DateTimeDetails().onlyTime()
                                                                                ..valuation =
                                                                                    "Add";

                                                                          addTransaction
                                                                              .save();
                                                                          // await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(tranid).update({'TRAN_ID':main['item'][0]});

                                                                          await DAY_TRANSACTION_REPORT()
                                                                              .select()
                                                                              .TRAN_ID
                                                                              .equals(
                                                                                  tranid)
                                                                              .update({
                                                                            'RECEIPT_NO':
                                                                                mainProposal[
                                                                                    'receiptNumber'],
                                                                            'STATUS':
                                                                                'SUCCESS'
                                                                          });

                                                                          return showDialog(
                                                                            barrierDismissible: false,
                                                                              context:
                                                                                  context,
                                                                              builder:
                                                                                  (BuildContext
                                                                                      context) {
                                                                                return WillPopScope(
                                                                                  onWillPop: () async => false,
                                                                                  child: Dialog(
                                                                                    child:
                                                                                        Padding(
                                                                                      padding:
                                                                                          const EdgeInsets.all(8.0),
                                                                                      child:
                                                                                          Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              child: Text("Payment Details"),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              child: Text("Transaction Submitted Successfully"),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                              children: [
                                                                                                Text("Receipt Number: "),
                                                                                                // Text(
                                                                                                //     new Random()
                                                                                                //         .nextInt(
                                                                                                //         99999999)
                                                                                                //         .toString())
                                                                                                Text(mainProposal['receiptNumber']),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              TextButton(
                                                                                                style: ButtonStyle(
                                                                                                    // elevation:MaterialStateProperty.all(),
                                                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                                                onPressed: () async {
                                                                                                  // print("Inside new premium");
                                                                                                  List<String> basicInformation = <String>[];
                                                                                                  List<String> DummyList = <String>[];
                                                                                                  List<DAY_TRANSACTION_REPORT> printData = await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(mainProposal['receiptNumber']).toList();
                                                                                                  List<OfficeDetail> office = await OfficeDetail().select().toList();
                                                                                                  List<OFCMASTERDATA> userDetails = await OFCMASTERDATA().select().toList();

                                                                                                  printData[0].BAL_AMT == null ? printData[0].BAL_AMT = "0" : printData[0].BAL_AMT;

                                                                                                  basicInformation.add('CSI BO ID');
                                                                                                  basicInformation.add('${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                                                                                                  basicInformation.add('Transaction Date');
                                                                                                  basicInformation.add(printData[0].TRAN_DATE!);
                                                                                                  basicInformation.add('Transaction Time');
                                                                                                  basicInformation.add(printData[0].R_CRE_TIME.toString());
                                                                                                  basicInformation.add('Operator ID & Name');
                                                                                                  basicInformation.add('${userDetails[0].EMPID!}' '${userDetails[0].EmployeeName!}');
                                                                                                  //basicInformation.add('GSTN Id');
                                                                                                  // basicInformation.add("------------------");
                                                                                                  // basicInformation.add("------------------");
                                                                                                  //basicInformation.add("${widget.gstnum}");
                                                                                                  basicInformation.add("Receipt Details:");
                                                                                                  basicInformation.add("");
                                                                                                  basicInformation.add("Proposal Number");
                                                                                                  basicInformation.add("${printData[0].PROPOSAL_NUM}");
                                                                                                  basicInformation.add("Insurant Name");
                                                                                                  basicInformation.add(widget.insName);
                                                                                                  basicInformation.add("Receipt Number");
                                                                                                  basicInformation.add("${printData[0].RECEIPT_NO}");
                                                                                                  basicInformation.add("Premium Due Amount");
                                                                                                  basicInformation.add("${printData[0].PREM_AMNT}");
                                                                                                  basicInformation.add("Premium Received");
                                                                                                  basicInformation.add("${printData[0].AMOUNT}");
                                                                                                  basicInformation.add("Total amount paid");
                                                                                                  basicInformation.add("${printData[0].AMOUNT}");
                                                                                                  basicInformation.add("Payment Mode");
                                                                                                  basicInformation.add("${printData[0].PAYMENT_MODE}");
                                                                                                  DummyList.clear();
                                                                                                  PrintingTelPO printer = new PrintingTelPO();
                                                                                                  bool value = await printer.printThroughUsbPrinter("Insurance", "${printData[0].POLICY_TYPE}" + "-" + "Initial Premium Collection", basicInformation, DummyList, 1);
                                                                                                },
                                                                                                child: Text("PRINT"),
                                                                                              ),
                                                                                              TextButton(
                                                                                                child: Text("CONTINUE"),
                                                                                                style: ButtonStyle(
                                                                                                    // elevation:MaterialStateProperty.all(),
                                                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                                                onPressed: () async {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumCollection()));
                                                                                                },
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        } else {
                                                                          print(
                                                                              "Entered else ");
                                                                          print(
                                                                              "fjaksjdlfjviluweoilskfnvioaslmdxcvusio");
                                                                          print(mainProposal[
                                                                              'responseNo']);

                                                                          List<INS_ERROR_CODES> t = await INS_ERROR_CODES()
                                                                              .select()
                                                                              .Error_code
                                                                              .equals(mainProposal[
                                                                                  'responseNo'])
                                                                              .toList();
                                                                          print(t[0]);
                                                                          // UtilFs.showToast("${t[0].Error_message}",context);
                                                                          return showDialog(
                                                                              context:
                                                                                  context,
                                                                              builder:
                                                                                  (BuildContext
                                                                                      context) {
                                                                                return Dialog(
                                                                                  child:
                                                                                      Padding(
                                                                                    padding:
                                                                                        const EdgeInsets.all(8.0),
                                                                                    child:
                                                                                        Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: Text("Transaction Failed"),
                                                                                          ),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                            children: [
                                                                                              Text(" ${t[0].Error_message}"),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                              });
                                                                        }
                                                                      } else {
                                                                        UtilFsNav.showToast(
                                                                            "Signature Verification Failed! Try Again",
                                                                            context,
                                                                            PremiumCollection());
                                                                        await LogCat()
                                                                            .writeContent(
                                                                                '${DateTimeDetails().currentDateTime()} :Proposal Payment Confirmation screen: Signature Verification Failed.\n\n');
                                                                      }
                                                                    } else {
                                                                      // UtilFsNav.showToast(
                                                                      //     "${await response.stream.bytesToString()}",
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
                                                                    if (_.toString() ==
                                                                        "TIMEOUT") {
                                                                      return UtilFsNav
                                                                          .showToast(
                                                                              "Request Timed Out",
                                                                              context,
                                                                              PremiumCollection());
                                                                    } else
                                                                      print(_);
                                                                  }
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text("CANCEL"),
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty
                                                                            .all(Colors
                                                                                .white)),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          _isLoading == true
                                              ? Loader(
                                              isCustom: true,
                                              loadingTxt:
                                              'Please Wait...Loading...')
                                              : Container()
                                        ],
                                      );
                                    }
                                  );
                                });
                          },
                        ),
                        TextButton(
                          child: Text("RESET",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          style: ButtonStyle(
                              // elevation:MaterialStateProperty.all(),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PremiumCollection()));
                          },
                        )
                      ]),
                )
              ],
            ),
            // Container(
            //     child: _isLoading
            //         ? Loader(
            //             isCustom: true, loadingTxt: 'Please Wait...Loading...')
            //         : Container()),
            // Container(
            //     child: _isLoading ? Loader(isCustom: true,loadingTxt: 'Please Wait...Loading...') : Container()
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          chequeDate.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
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
  //   String text;
  //   var login=await USERDETAILS().select().toList();
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //
  //   file.writeAsStringSync('');
  //   cash==true?
  //  text='{"m_addPrem":"","m_facilityId":"","m_agentID":"","m_payeeType":"indv","m_paymentChannel":"RICT","m_PremiumAmount":${widget.amount},"m_premiumInterest":"","m_insuredName":"${widget.name}","m_premiumRebate":"","m_remoteAddr":"","m_recieptIssuedBy":"${login[0].BOFacilityID}","m_totalAmount":"${widget.amount}","m_chequeNumber":"","m_micrFlag":"","m_carrId":"","m_accNo":"","m_username":"${login[0].EMPID}","m_paymentType":"I","m_proposalNumber":"${widget.policyNumber}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaidCheque":"","m_amountPaidCash":"${widget.amount}","m_paymentModeCash":true,"m_paymentModeCheque":false,"m_bankName":"","m_chequeDate":"","m_chequeType":"","m_ifscCode":"","m_isMicr":"","m_micrCode":"","responseParams":"amountPaid,proposalNumber,receiptNumber,responseNo","m_ServiceReqId":"initialCollection"}':
  //   text='{"m_addPrem":"","m_facilityId":"","m_agentID":"","m_payeeType":"indv","m_paymentChannel":"RICT","m_PremiumAmount":${widget.amount},"m_premiumInterest":"","m_insuredName":"${widget.name}","m_premiumRebate":"","m_remoteAddr":"","m_recieptIssuedBy":"${login[0].BOFacilityID}","m_totalAmount":"${widget.amount}","m_chequeNumber":"${chequeno.text}","m_micrFlag":"","m_carrId":"","m_accNo":"","m_username":"${login[0].EMPID}","m_paymentType":"I","m_proposalNumber":"${widget.policyNumber}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaidCheque":"${widget.amount}","m_amountPaidCash":"","m_paymentModeCash":false,"m_paymentModeCheque":true,"m_bankName":"","m_chequeDate":"${chequeDate.text}","m_chequeType":"","m_ifscCode":"${ifsc.text}","m_isMicr":"${ _selectedacc == "POSB"?"Y":"N"}","m_micrCode":"${_selectedacc == "POSB"?"":micr.text}","responseParams":"amountPaid,proposalNumber,receiptNumber,responseNo","m_ServiceReqId":"initialCollection"}';
  //   print("Proposal API: $text");
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteContent(String tranid) async {
    String text;
    var login = await USERDETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt",
        "payPremiumForProposal",
        "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    cash == true
        ? text = "$bound"
            "\nContent-Id: <requestPremiumXML>\n\n"
            '{"m_addPrem":"","m_facilityId":"","m_agentID":"","m_payeeType":"indv","m_paymentChannel":"RICT","m_PremiumAmount":${widget.propamount},"m_premiumInterest":"","m_insuredName":"${widget.name}","m_premiumRebate":"","m_remoteAddr":"","m_recieptIssuedBy":"${login[0].BOFacilityID}","m_totalAmount":"${widget.amount}","m_chequeNumber":"","m_micrFlag":"","m_carrId":"","m_accNo":"","m_username":"${login[0].EMPID}","m_paymentType":"I","m_proposalNumber":"${widget.policyNumber}","m_transactionNumber":"$tranid","m_amountPaidCheque":"","m_amountPaidCash":"${widget.amount}","m_paymentModeCash":true,"m_paymentModeCheque":false,"m_bankName":"","m_chequeDate":"","m_chequeType":"","m_ifscCode":"","m_isMicr":"","m_micrCode":"","responseParams":"amountPaid,proposalNumber,receiptNumber,responseNo","m_ServiceReqId":"initialCollection"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            ""
        : text = "$bound"
            "\nContent-Id: <requestPremiumXML>\n\n"
            '{"m_addPrem":"","m_facilityId":"","m_agentID":"","m_payeeType":"indv","m_paymentChannel":"RICT","m_PremiumAmount":${widget.propamount},"m_premiumInterest":"","m_insuredName":"${widget.name}","m_premiumRebate":"","m_remoteAddr":"","m_recieptIssuedBy":"${login[0].BOFacilityID}","m_totalAmount":"${widget.amount}","m_chequeNumber":"${chequeno.text}","m_micrFlag":"","m_carrId":"","m_accNo":"","m_username":"${login[0].EMPID}","m_paymentType":"I","m_proposalNumber":"${widget.policyNumber}","m_transactionNumber":"","m_amountPaidCheque":"${widget.amount}","m_amountPaidCash":"","m_paymentModeCash":false,"m_paymentModeCheque":true,"m_bankName":"${bank.text}","m_chequeDate":"2022-09-3","m_chequeType":"${posb == true ? "POSB" : "NON POSB"}","m_ifscCode":"${ifsc.text}","m_isMicr":${posb == "true" ? 0 : 1},"m_micrCode":"${posb == "true" ? "" : micr.text}","responseParams":"amountPaid,proposalNumber,receiptNumber,responseNo","m_ServiceReqId":"initialCollection"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            "";
    print("Proposal API: $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Proposal Payment ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
