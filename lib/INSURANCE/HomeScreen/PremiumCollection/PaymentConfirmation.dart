import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Utils/Printing.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../CBS/decryptHeader.dart';
import '../../../LogCat.dart';
import 'PremiumCollection.dart';

class paymentconfirmation extends StatefulWidget {
  String insName;
  String paymentCategory;
  String carr;
  String amount;
  String paidto;
  String billto;
  String premint;
  String premreb;
  String agentid;
  String rencgst;
  String rensgst;
  String gstnum;
  String rencgstper;
  String rensgstper;
  String gstrenyr;
  String srvtaxtot;
  String polnum;
  String renamount;
  String balamount;
  String premdue;

  paymentconfirmation(
    this.insName,
    this.paymentCategory,
    this.carr,
    this.amount,
    this.paidto,
    this.billto,
    this.premint,
    this.premreb,
    this.agentid,
    this.rencgst,
    this.rensgst,
    this.gstnum,
    this.rencgstper,
    this.rensgstper,
    this.gstrenyr,
    this.srvtaxtot,
    this.polnum,
    this.renamount,
    this.balamount,
    this.premdue,
  );

  @override
  _paymentconfirmationState createState() => _paymentconfirmationState();
}

class _paymentconfirmationState extends State<paymentconfirmation> {
  List<String> _services = ["Cash", "Cheque/DemandDraft"];
  List<String> acctypes = ["POSB", "Non POSB"];
  String _selectedacc = "POSB";
  String _selectedValue = "Cash";
  TextEditingController chequeno = TextEditingController();
  TextEditingController chequeDate = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController micr = TextEditingController();
  String? _selectedDate;
  String? _currentDate;
  bool calc = true;
  bool cash = true;
  bool cheque = false;
  bool posb = false;
  bool nonposb = false;
  bool chequedet = false;
  Map main = {};
  String? encheader;
  bool _isLoading = false;
  bool _isNewLoading = false;
  late Directory d;
  late String cachepath;

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  @override
  void initState() {
    getCacheDir();
    _selectedDate == ''
        ? _selectedDate = _currentDate
        : _selectedDate = _selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor:  Color(0xFFEEEEEE),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Payment Confirmation"),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
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
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
                                            fontWeight: FontWeight.w500),
                                        controller: chequeDate,
                                        decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          border: InputBorder.none,
                                          labelText: "Cheque Date",
                                          labelStyle: TextStyle(
                                              color: Color(0xFFCFB53B)),
                                        ),
                                      ),
                                    ))),
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          elevation: 0,
                                          backgroundColor: Colors.white,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .red)),
                                                          onPressed: () async {
                                                            setState(() {
                                                              _isNewLoading =
                                                                  true;
                                                            });

                                                            List<DAY_TRANSACTION_REPORT>
                                                                pendcheck =
                                                                await DAY_TRANSACTION_REPORT()
                                                                    .select()
                                                                    .POLICY_NO
                                                                    .equals(widget
                                                                        .polnum)
                                                                    .and
                                                                    .startBlock
                                                                    .STATUS
                                                                    .equals(
                                                                        "PENDING")
                                                                    .endBlock
                                                                    .toList();
                                                            var tranid;
                                                            List<USERLOGINDETAILS>
                                                                acctoken =
                                                                await USERLOGINDETAILS()
                                                                    .select()
                                                                    .toList();
                                                            if (pendcheck
                                                                    .length ==
                                                                0) {
                                                              tranid =
                                                                  GenerateRandomString()
                                                                      .randomString();
                                                              var login =
                                                                  await USERDETAILS()
                                                                      .select()
                                                                      .toList();
                                                              final renprem =
                                                                  DAY_TRANSACTION_REPORT(
                                                                RECEIPT_NO:
                                                                    '$tranid',
                                                                STATUS:
                                                                    'PENDING',
                                                                TRAN_ID:
                                                                    '$tranid',
                                                                FROM_DATE:
                                                                    '${widget.paidto}',
                                                                TO_DATE:
                                                                    '${widget.billto}',
                                                                TRAN_PAYMENT_TYPE:
                                                                    'RP',
                                                                POLICY_NO:
                                                                    '${widget.polnum}',
                                                                POLICY_TYPE:
                                                                    widget.carr,
                                                                TRAN_TYPE: 'P',
                                                                TRAN_DATE:
                                                                    '${DateTimeDetails().onlyExpDate()}',
                                                                R_CRE_TIME:
                                                                    '${DateTimeDetails().oT()}',
                                                                OPERATOR_ID:
                                                                    '${login[0].EMPID}',
                                                                AMOUNT:
                                                                    '${widget.amount}',
                                                                R_CGST:
                                                                    '${widget.rencgstper == "0.0" ? "0.0" : '${widget.rencgst}'}',
                                                                R_SGST:
                                                                    '${widget.rencgstper == "0.0" ? "0.0" : '${widget.rensgst}'}',
                                                                I_CGST:
                                                                    '${widget.rencgstper == "0.0" ? '${widget.rencgst}' : "0.0"}',
                                                                I_SGST:
                                                                    '${widget.rencgstper == "0.0" ? '${widget.rensgst}' : "0.0"}',
                                                                REBATE:
                                                                    '${widget.premreb}',
                                                                PAYMENT_MODE:
                                                                    cash == true
                                                                        ? "CASH"
                                                                        : "CHEQUE",
                                                                CGST:
                                                                    '${widget.rencgst}',
                                                                SGST:
                                                                    '${widget.rensgst}',
                                                                TOTAL_GST:
                                                                    '${widget.srvtaxtot}',
                                                                GSTN_ID:
                                                                    '${widget.gstnum}',
                                                                PAYMENT_CATEGORY:
                                                                    '${widget.paymentCategory}',
                                                                PREM_AMNT:
                                                                    '${widget.premdue}',
                                                                DEFAULT_FEE:
                                                                    '${widget.premint}',
                                                              );
                                                              await renprem
                                                                  .save();
                                                            } else {
                                                              tranid =
                                                                  pendcheck[0]
                                                                      .TRAN_ID;
                                                            }
                                                            print(
                                                                "In payment confirmation tranid");
                                                            print(tranid);
                                                            encheader =
                                                                await encryptwriteContent();
                                                            // var headers = {
                                                            //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                                            // };
                                                            // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/payPremium'));
                                                            // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                                            // request.headers.addAll(headers);

                                                            try {
                                                              var headers = {
                                                                'Signature':
                                                                    '$encheader',
                                                                'Uri':
                                                                    'payPremium',
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
                                                                  _isNewLoading =
                                                                      false;
                                                                });
                                                                throw 'TIMEOUT';
                                                              });

                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                // print(await response.stream.bytesToString());
                                                                var resheaders =
                                                                    response
                                                                        .headers;
                                                                print(
                                                                    "Response Headers");
                                                                print(resheaders[
                                                                    'authorization']);
                                                                List t = resheaders[
                                                                        'authorization']!
                                                                    .split(
                                                                        ", Signature:");

                                                                String res =
                                                                    await response
                                                                        .stream
                                                                        .bytesToString();
                                                                print(res);
                                                                String temp = resheaders['authorization']!;
                                                                String decryptSignature = temp;

                                                                String val =
                                                                await decryption1(decryptSignature, res);
                                                                print("\n\n");
                                                                if (val ==
                                                                    "Verified!") {
                                                                  await LogCat().writeContent(
                                                    '$res');
                                                                  setState(() {
                                                                    _isNewLoading =
                                                                        false;
                                                                  });
                                                                  Map a = json
                                                                      .decode(
                                                                          res);
                                                                  print(
                                                                      "Map a: $a");
                                                                  print(a['JSONResponse']
                                                                      [
                                                                      'jsonContent']);
                                                                  String data =
                                                                      a['JSONResponse']
                                                                          [
                                                                          'jsonContent'];
                                                                  main = json
                                                                      .decode(
                                                                          data);
                                                                  print(main);
                                                                  print(main[
                                                                          'item']
                                                                      [0]);
                                                                  if (main['item']
                                                                          [0] ==
                                                                      "${main['item'][0]}") {
                                                                    print(
                                                                        "True as String");
                                                                  }
                                                                  if (main['item']
                                                                          [0] ==
                                                                      main['item']
                                                                          [0]) {
                                                                    print(
                                                                        "True as Numerical");
                                                                  }
                                                                  if (main[
                                                                          'Status'] ==
                                                                      "SUCCESS" ) {
                                                                    if (main['item'][0] ==
                                                                            0 ||
                                                                        main['item'][0] ==
                                                                            '0') {
                                                                      UtilFsNav.showToast(
                                                                          "Transaction Failed",
                                                                          context,
                                                                          PremiumCollection());
                                                                    }
                                                                    else {
                                                                      String s =
                                                                          widget
                                                                              .amount;
                                                                      String
                                                                          result =
                                                                          s.substring(
                                                                              0,
                                                                              s.indexOf('.'));
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
                                                                                widget.polnum
                                                                            ..tranType =
                                                                                "RevivalPremium";
                                                                      addtran
                                                                          .save();
                                                                      final addCash =
                                                                          CashTable()
                                                                            ..Cash_ID =
                                                                                widget.polnum
                                                                            ..Cash_Date =
                                                                                DateTimeDetails().currentDate()
                                                                            ..Cash_Time =
                                                                                DateTimeDetails().onlyTime()
                                                                            ..Cash_Type =
                                                                                'Add'
                                                                            ..Cash_Amount =
                                                                                double.parse(result)
                                                                            ..Cash_Description =
                                                                                "${widget.carr} Renewal Premium";
                                                                      if (cash ==
                                                                          true) {
                                                                        addCash
                                                                            .save();
                                                                      }
                                                                      final addTransaction =
                                                                          TransactionTable()
                                                                            ..tranid =
                                                                                'INS${main['item'][0]}'
                                                                            ..tranDescription =
                                                                                "PremiumPayment- ${widget.polnum}"
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
                                                                      await DAY_TRANSACTION_REPORT()
                                                                          .select()
                                                                          .TRAN_ID
                                                                          .equals(
                                                                              tranid)
                                                                          .update({
                                                                        'RECEIPT_NO':
                                                                            main['item'][0],
                                                                        'STATUS':
                                                                            'SUCCESS'
                                                                      });

                                                                      return showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible: false,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return WillPopScope(
                                                                              onWillPop: () async => false,
                                                                              child: Dialog(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Column(
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
                                                                                            Text(main['item'][0]),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          Text("GSTN id: "),
                                                                                          Text("${widget.gstnum}"),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                        children: [
                                                                                          TextButton(
                                                                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                                                                                            onPressed: () async {
                                                                                              List<String> basicInformation = <String>[];
                                                                                              List<String> DummyList = <String>[];
                                                                                              List<DAY_TRANSACTION_REPORT> printData = await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(main['item'][0]).toList();
                                                                                              List<OfficeDetail> office = await OfficeDetail().select().toList();
                                                                                              List<OFCMASTERDATA> userDetails = await OFCMASTERDATA().select().toList();

                                                                                              basicInformation.add('CSI BO ID');
                                                                                              basicInformation.add('${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                                                                                              basicInformation.add('Transaction Date');
                                                                                              basicInformation.add(printData[0].TRAN_DATE!);
                                                                                              basicInformation.add('Transaction Time');
                                                                                              basicInformation.add(printData[0].R_CRE_TIME.toString());
                                                                                              basicInformation.add('Operator ID');
                                                                                              basicInformation.add('${userDetails[0].EMPID!}');
                                                                                              basicInformation.add('Operator Name');
                                                                                              basicInformation.add('${userDetails[0].EmployeeName!}');
                                                                                              basicInformation.add('GSTN Id');
                                                                                              //   basicInformation.add("------------------");
                                                                                              //       basicInformation.add("------------------");
                                                                                              basicInformation.add("${widget.gstnum}");
                                                                                              basicInformation.add("Receipt Details:");
                                                                                              basicInformation.add("");
                                                                                              basicInformation.add("Policy Number");
                                                                                              basicInformation.add("${printData[0].POLICY_NO}");
                                                                                              basicInformation.add("Insurant Name");
                                                                                              basicInformation.add(widget.insName);
                                                                                              // basicInformation.add("Product Name");
                                                                                              // basicInformation.add("${printData[0].}");
                                                                                              basicInformation.add("Receipt Number");
                                                                                              basicInformation.add("${printData[0].RECEIPT_NO}");
                                                                                              basicInformation.add("Agent ID");
                                                                                              basicInformation.add("${widget.agentid}");
                                                                                              basicInformation.add("From date");
                                                                                              basicInformation.add("${printData[0].FROM_DATE}");
                                                                                              basicInformation.add("To date");
                                                                                              basicInformation.add("${printData[0].TO_DATE}");
                                                                                              basicInformation.add("Premium Due Amount");
                                                                                              basicInformation.add("${printData[0].PREM_AMNT}");
                                                                                              basicInformation.add("Default");
                                                                                              basicInformation.add("${printData[0].DEFAULT_FEE}");
                                                                                              basicInformation.add("Rebate");
                                                                                              basicInformation.add("${printData[0].REBATE}");
                                                                                              // basicInformation.add("Balance Amount");
                                                                                              // basicInformation.add("${printData[0].BAL_AMT}");
                                                                                              basicInformation.add("CGST");
                                                                                              basicInformation.add("${printData[0].CGST}");
                                                                                              basicInformation.add("SGST/UGST");
                                                                                              basicInformation.add("${printData[0].SGST}");
                                                                                              basicInformation.add("Total GST");
                                                                                              basicInformation.add("${printData[0].TOTAL_GST}");
                                                                                              basicInformation.add("Total Amount");
                                                                                              basicInformation.add("${printData[0].AMOUNT}");
                                                                                              basicInformation.add("Payment Mode");
                                                                                              cash == true ? basicInformation.add("Cash") : basicInformation.add("Cheque");
                                                                                              DummyList.clear();
                                                                                              PrintingTelPO printer = new PrintingTelPO();
                                                                                              bool value = await printer.printThroughUsbPrinter("Insurance", "${printData[0].POLICY_TYPE}" + "-" + "Renewal Premium Collection", basicInformation, DummyList, 1);
                                                                                              //if(value==true){
                                                                                              //Navigator.pushAndRemoveUntil(context,
                                                                                              // MaterialPageRoute(builder: (context) => MainHomeScreen(UserPage(false),3)), (route) => false);
                                                                                              //}
                                                                                              // else{
                                                                                              // UtilFs.showToast("Printing Failed, Try Again",context);
                                                                                              //}
                                                                                            },
                                                                                            child: Text("PRINT"),
                                                                                          ),
                                                                                          TextButton(
                                                                                            child: Text("CONTINUE"),
                                                                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
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
                                                                    }
                                                                  } else {
                                                                    await DAY_TRANSACTION_REPORT()
                                                                        .select()
                                                                        .RECEIPT_NO
                                                                        .equals(
                                                                            tranid)
                                                                        .update({
                                                                      'STATUS':
                                                                          'FAILED'
                                                                    });
                                                                  }
                                                                } else {
                                                                  UtilFsNav.showToast(
                                                                      "Signature Verification Failed! Try Again",
                                                                      context,
                                                                      PremiumCollection());
                                                                  await LogCat()
                                                                      .writeContent(
                                                                          '${DateTimeDetails().currentDateTime()} :Payment Confirmation screen: Signature Verification Failed.\n\n');
                                                                }
                                                              } else {
                                                                setState(() {
                                                                  _isNewLoading =
                                                                      false;
                                                                });
                                                                // UtilFsNav.showToast(
                                                                //     "${await response.stream.bytesToString()}",
                                                                //     context,
                                                                //     PremiumCollection());
                                                                print(response
                                                                    .statusCode);
                                                                List<API_Error_code>
                                                                    error =
                                                                    await API_Error_code()
                                                                        .select()
                                                                        .API_Err_code
                                                                        .equals(
                                                                            response.statusCode)
                                                                        .toList();
                                                                if (response.statusCode ==
                                                                        503 ||
                                                                    response.statusCode ==
                                                                        504) {
                                                                  UtilFsNav.showToast(
                                                                      "Insurance " +
                                                                          error[0]
                                                                              .Description
                                                                              .toString(),
                                                                      context,
                                                                      PremiumCollection());
                                                                } else
                                                                  UtilFsNav.showToast(
                                                                      error[0]
                                                                          .Description
                                                                          .toString(),
                                                                      context,
                                                                      PremiumCollection());
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
                                          ),
                                        ),
                                        _isNewLoading == true
                                            ? Loader(
                                                isCustom: true,
                                                loadingTxt:
                                                    'Please Wait...Loading...')
                                            : Container()
                                      ],
                                    );
                                  });
                                });
                          },
                        ),
                        TextButton(
                          child: Text("RESET",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
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

  //   Future<File> writeContent() async {
  //     var login=await USERDETAILS().select().toList();
  //     var db=await OfficeDetail().select().toList();
  // String text;
  //     final file=await _localFile;
  //
  //     file.writeAsStringSync('');
  //     _selectedValue == "Cash"?
  //     text='{"m_premiumAmount":"${widget.amount}","m_officeCode":"${db[0].POCode}","m_fromDate":"${widget.paidto}","m_toDate":"${widget.billto}","m_premiumInterest":"${widget.premint}","m_premiumrebate":"${widget.premreb}","m_agentId":"${widget.agentid}","m_Init_SGST":"${widget.rencgstper=="0.0"?'${widget.rensgst}':"0.0"}","m_Init_UGST":"0.0","m_Init_CGST":"${widget.rencgstper=="0.0"?'${widget.rensgst}':"0.0"}","m_Renewal_SGST":"${widget.rencgstper=="0.0"?"0.0":'${widget.rensgst}'}","m_Renewal_UGST":"0.0","m_Renewal_CGST":"${widget.rencgstper=="0.0"?"0.0":'${widget.rencgst}'}","m_Gstnumber":"${widget.gstnum}","m_INIT_CGSTPER":"0.0","m_INIT_SGSTPER":"0.0","m_INIT_UGSTPER":"0.0","m_RENEWAL_CGSTPER":"${widget.rencgstper}","m_RENEWAL_SGSTPER":"${widget.rensgstper}","m_RENEWAL_UGSTPER":"0.0","m_op_GSTinityr":"${widget.gstrenyr=="0.0"?'${widget.gstrenyr}':"0.0"}","m_op_GSTrenewalyr":"${widget.gstrenyr=="0.0"?"0.0":'${widget.gstrenyr}'}","m_totalGST":"${widget.srvtaxtot}","m_paymentType":"${widget.paymentCategory}","m_policyNumber":"${widget.polnum}","m_totalAmount":"${widget.amount}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaid":"${widget.amount}","m_paymentMode":"CASH","m_bankName":"","m_chequeDate":"","m_chequeType":"","m_ifscCode":"","m_isMicr":"","m_micrCode":"","m_chequeNumber":"","m_taxType":"2","responseParams":"item","m_ServiceReqId":"saveCollection","m_createdBy":"${login[0].EMPID}","m_receiptDate":"${DateTimeDetails().renDateTime()}"}':
  //     text='{"m_premiumAmount":"${widget.amount}","m_officeCode":"${db[0].POCode}","m_fromDate":"${widget.paidto}","m_toDate":"${widget.billto}","m_premiumInterest":"${widget.premint}","m_premiumrebate":"${widget.premreb}","m_agentId":"${widget.agentid}","m_Init_SGST":"${widget.rencgstper=="0.0"?'${widget.rensgst}':"0.0"}","m_Init_UGST":"0.0","m_Init_CGST":"${widget.rencgstper=="0.0"?'${widget.rensgst}':"0.0"}","m_Renewal_SGST":"${widget.rencgstper=="0.0"?"0.0":'${widget.rensgst}'}","m_Renewal_UGST":"0.0","m_Renewal_CGST":"${widget.rencgstper=="0.0"?"0.0":'${widget.rencgst}'}","m_Gstnumber":"${widget.gstnum}","m_INIT_CGSTPER":"0.0","m_INIT_SGSTPER":"0.0","m_INIT_UGSTPER":"0.0","m_RENEWAL_CGSTPER":"${widget.rencgstper}","m_RENEWAL_SGSTPER":"${widget.rensgstper}","m_RENEWAL_UGSTPER":"0.0","m_op_GSTinityr":"${widget.gstrenyr=="0.0"?'${widget.gstrenyr}':"0.0"}","m_op_GSTrenewalyr":"${widget.gstrenyr=="0.0"?"0.0":'${widget.gstrenyr}'}","m_totalGST":"${widget.srvtaxtot}","m_paymentType":"${widget.paymentCategory}","m_policyNumber":"${widget.polnum}","m_totalAmount":"${widget.amount}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaid":"${widget.amount}","m_paymentMode":"CHEQUE","m_bankName":"","m_chequeDate":"${chequeDate.text}","m_chequeType":"","m_ifscCode":"${ifsc.text}","m_isMicr":"${ _selectedacc == "POSB"?"Y":"N"}","m_micrCode":"${_selectedacc == "POSB"?"":micr.text}","m_chequeNumber":"${chequeno.text}","m_taxType":"2","responseParams":"item","m_ServiceReqId":"saveCollection","m_createdBy":"${login[0].EMPID}","m_receiptDate":"${DateTimeDetails().renDateTime()}"}';
  //     print(text);
  //     return file.writeAsString(text, mode: FileMode.append);
  //
  //   }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    var db = await OfficeDetail().select().toList();
    String text;
    final file = await _localFile;
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt",
        "payPremium",
        "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    file.writeAsStringSync('');
    cash == true
        ? text = "$bound"
            "\nContent-Id: <requestPremiumXML>\n\n"
            '{"m_premiumAmount":"${widget.premdue}","m_officeCode":"${db[0].POCode}","m_fromDate":"${widget.paidto}","m_toDate":"${widget.billto}","m_premiumInterest":"${widget.premint}","m_premiumrebate":"${widget.premreb}","m_agentId":"${widget.agentid}","m_Init_SGST":"${widget.rencgstper == "0.0" ? '${widget.rensgst}' : "0.0"}","m_Init_UGST":"0.0","m_Init_CGST":"${widget.rencgstper == "0.0" ? '${widget.rensgst}' : "0.0"}","m_Renewal_SGST":"${widget.rencgstper == "0.0" ? "0.0" : '${widget.rensgst}'}","m_Renewal_UGST":"0.0","m_Renewal_CGST":"${widget.rencgstper == "0.0" ? "0.0" : '${widget.rencgst}'}","m_Gstnumber":"${widget.gstnum}","m_INIT_CGSTPER":"0.0","m_INIT_SGSTPER":"0.0","m_INIT_UGSTPER":"0.0","m_RENEWAL_CGSTPER":"${widget.rencgstper}","m_RENEWAL_SGSTPER":"${widget.rensgstper}","m_RENEWAL_UGSTPER":"0.0","m_op_GSTinityr":"${widget.gstrenyr == "0.0" ? '${widget.gstrenyr}' : "0.0"}","m_op_GSTrenewalyr":"${widget.gstrenyr == "0.0" ? "0.0" : '${widget.gstrenyr}'}","m_totalGST":"${widget.srvtaxtot}","m_paymentType":"${widget.paymentCategory}","m_policyNumber":"${widget.polnum}","m_totalAmount":"${widget.amount}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaid":"${widget.amount}","m_paymentMode":"CASH","m_bankName":"","m_chequeDate":"","m_chequeType":"","m_ifscCode":"","m_isMicr":"","m_micrCode":"","m_chequeNumber":"","m_taxType":"2","responseParams":"item","m_ServiceReqId":"saveCollection","m_createdBy":"${login[0].EMPID}","m_receiptDate":"${DateTimeDetails().renDateTime()}"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            ""
        : text = "$bound"
            "\nContent-Id: <requestPremiumXML>\n\n"
            '{"m_premiumAmount":"${widget.premdue}","m_officeCode":"${db[0].POCode}","m_fromDate":"${widget.paidto}","m_toDate":"${widget.billto}","m_premiumInterest":"${widget.premint}","m_premiumrebate":"${widget.premreb}","m_agentId":"${widget.agentid}","m_Init_SGST":"${widget.rencgstper == "0.0" ? '${widget.rensgst}' : "0.0"}","m_Init_UGST":"0.0","m_Init_CGST":"${widget.rencgstper == "0.0" ? '${widget.rensgst}' : "0.0"}","m_Renewal_SGST":"${widget.rencgstper == "0.0" ? "0.0" : '${widget.rensgst}'}","m_Renewal_UGST":"0.0","m_Renewal_CGST":"${widget.rencgstper == "0.0" ? "0.0" : '${widget.rencgst}'}","m_Gstnumber":"${widget.gstnum}","m_INIT_CGSTPER":"0.0","m_INIT_SGSTPER":"0.0","m_INIT_UGSTPER":"0.0","m_RENEWAL_CGSTPER":"${widget.rencgstper}","m_RENEWAL_SGSTPER":"${widget.rensgstper}","m_RENEWAL_UGSTPER":"0.0","m_op_GSTinityr":"${widget.gstrenyr == "0.0" ? '${widget.gstrenyr}' : "0.0"}","m_op_GSTrenewalyr":"${widget.gstrenyr == "0.0" ? "0.0" : '${widget.gstrenyr}'}","m_totalGST":"${widget.srvtaxtot}","m_paymentType":"${widget.paymentCategory}","m_policyNumber":"${widget.polnum}","m_totalAmount":"${widget.amount}","m_transactionNumber":"${GenerateRandomString().random12Number()}","m_amountPaid":"${widget.amount}","m_paymentMode":"CHEQUE","m_bankName":"","m_chequeDate":"${chequeDate.text}","m_chequeType":"","m_ifscCode":"${ifsc.text}","m_isMicr":"${_selectedacc == "POSB" ? "Y" : "N"}","m_micrCode":"${_selectedacc == "POSB" ? "" : micr.text}","m_chequeNumber":"${chequeno.text}","m_taxType":"2","responseParams":"item","m_ServiceReqId":"saveCollection","m_createdBy":"${login[0].EMPID}","m_receiptDate":"${DateTimeDetails().renDateTime()}"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Premium Payment Renewal ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
