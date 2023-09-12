import 'dart:io';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/decryptHeader.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../HomeScreen.dart';

class TransactionUpdate extends StatefulWidget {
  @override
  _TransactionUpdateState createState() => _TransactionUpdateState();
}

class _TransactionUpdateState extends State<TransactionUpdate> {
  List<String> accounts = ["Renewal Premium", "Initial Premium"];
  bool _isLoading = false;
  List<DAY_TRANSACTION_REPORT> rp = [];
  List<DAY_TRANSACTION_REPORT> ip = [];
  var _currentDate = DateTimeDetails().currentDate();
  var _selectedDate = " ";
  String _selectedAccount = "Renewal Premium";
  bool rpvisible = false;
  bool ipvisible = false;
  String? encheader;
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

  TextEditingController date = TextEditingController();

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
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
          title: Text(
            "Transaction Update",
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: date
                          ..text = _selectedDate == " "
                              ? _currentDate
                              : _selectedDate,
                        style: TextStyle(color: Colors.blueGrey),
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                            ),
                            onPressed: () {
                              _selectDailyTranReportDate(context);
                            },
                          ),
                          labelText: "Enter Date",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 3)),
                          // contentPadding: EdgeInsets.only(
                          //     top: 20, bottom: 20, left: 20, right: 20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(children: <Widget>[
                      Row(children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Select Transaction Type:',
                          style: TextStyle(
                              color: Colors.blueGrey, fontSize: 20),
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: _selectedAccount,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Transaction Type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              print(_selectedAccount);
                              _selectedAccount = newValue!;
                              ipvisible=false;
                              rpvisible=false;
                            });
                          },
                          items: accounts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        // elevation:MaterialStateProperty.all(),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                    child: Text(
                      "Fetch",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () async {
                      rp.clear();
                      ip.clear();
                      rp = await DAY_TRANSACTION_REPORT()
                          .select()
                          .TRAN_PAYMENT_TYPE
                          .equals("RP")
                          .and
                          .startBlock
                          .and
                          .TRAN_DATE
                          .equals(date.text).and.STATUS.equals("PENDING")
                          .endBlock
                          .toList();
                      ip = await DAY_TRANSACTION_REPORT()
                          .select()
                          .TRAN_PAYMENT_TYPE
                          .equals("IP")
                          .and
                          .startBlock
                          .and
                          .TRAN_DATE
                          .equals(date.text).and.STATUS.equals("PENDING")
                          .endBlock
                          .toList();
                      for (int i = 0; i < rp.length; i++) {
                        print(rp[i]);
                      }
                      if (rp.length > 0 &&
                          _selectedAccount == "Renewal Premium") {
                        setState(() {
                          rpvisible = true;
                        });
                      }
                      if (ip.length > 0 &&
                          _selectedAccount == "Initial Premium") {
                        setState(() {
                          ipvisible = true;
                        });
                      }
                    },
                  ),
                  rpvisible == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                child: Table(
                              defaultColumnWidth: IntrinsicColumnWidth(),
                              border: TableBorder.all(),
                              children: [
                                TableRow(children: [
                                  // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Policy Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('From Date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('To Date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Fetch Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                ]),
                                for (int i = 0; i < rp.length; i++)
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${rp[i].POLICY_NO}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            '${(rp[i].FROM_DATE).toString().split("-").reversed.join("-")}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            '${(rp[i].TO_DATE).toString().split("-").reversed.join("-")}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${rp[i].AMOUNT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${rp[i].STATUS}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      TextButton(
                                        style: ButtonStyle(
                                            // elevation:MaterialStateProperty.all(),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red)))),
                                        child: Text("Fetch Status"),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading=true;
                                          });

                                          var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                            '${rp[i].TRAN_DATE} ${rp[i].R_CRE_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                          );print(result);
                                          print(DateTime.now().difference( result).inMinutes);
                                          var diftimer=DateTime.now().difference( result).inMinutes;
                                          if(diftimer<5){
                                            UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionUpdate());

                                          }
                                          else {
                                            List<DAY_TRANSACTION_REPORT> main =
                                            [];
                                            main.add(rp[i]);
                                            List<USERLOGINDETAILS> acctoken =
                                            await USERLOGINDETAILS()
                                                .select()
                                                .Active
                                                .equals(true)
                                                .toList();
                                            encheader =
                                            await encryptTransDetails(main);
                                            try {
                                              var headers = {
                                                'Signature': '$encheader',
                                                'Uri': 'getTransactionDetails',
                                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                'Authorization':
                                                'Bearer ${acctoken[0]
                                                    .AccessToken}',
                                                'Cookie':
                                                'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                              };


                                              final File file = File(
                                                  '$cachepath/fetchAccountDetails.txt');
                                              String tosendText = await file
                                                  .readAsString();
                                              var request = http.Request('POST',
                                                  Uri.parse(
                                                      APIEndPoints().insURL));
                                              request.body = tosendText;
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
                                                var resheaders = response
                                                    .headers;
                                                print("Response Headers");
                                                print(
                                                    resheaders['authorization']);
                                                // List t =
                                                //     resheaders['authorization']!
                                                //         .split(", Signature:");
                                                String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;

                                                String res = await response
                                                    .stream
                                                    .bytesToString();
                                                print(res);
                                                String val = await decryption1(
                                                    decryptSignature, res);
                                                print(res);
                                                print("\n\n");
                                                if (val == "Verified!") {
                                                  await LogCat().writeContent(
                                                      '$res');

                                                  Map a = json.decode(res);
                                                  print("Map a: $a");
                                                  print(a['JSONResponse']
                                                  ['jsonContent']);
                                                  String data = a['JSONResponse']
                                                  ['jsonContent'];
                                                  Map temp = json.decode(data);
                                                  print(temp);
                                                  print(temp['payment_status']);

                                                  if (temp['payment_status'] ==
                                                      "Success") {
                                                    await DAY_TRANSACTION_REPORT()
                                                        .select()
                                                        .TRAN_ID
                                                        .equals(rp[i].TRAN_ID)
                                                        .update({
                                                      'STATUS': 'SUCCESS',
                                                      'RECEIPT_NO':
                                                      '${temp['Receipt_num']}'
                                                    });
                                                    final addCash =  CashTable()
                                                      ..Cash_ID = rp[i]
                                                          .POLICY_NO
                                                      ..Cash_Date = DateTimeDetails()
                                                          .currentDate()
                                                      ..Cash_Time = DateTimeDetails()
                                                          .onlyTime()
                                                      ..Cash_Type = 'Add'
                                                      ..Cash_Amount = double
                                                          .parse(rp[i].AMOUNT!)
                                                      ..Cash_Description = "${rp[i]
                                                          .TRAN_TYPE} deposit";
                                                    await addCash.save();
                                                    final addTransaction = TransactionTable()
                                                      ..tranid = '${rp[i]
                                                          .TRAN_ID}'
                                                      ..tranDescription = "${rp[i]
                                                          .TRAN_TYPE} deposit"
                                                      ..tranAmount = double
                                                          .parse(rp[i].AMOUNT!)
                                                      ..tranType = "Insurance"
                                                      ..tranDate = DateTimeDetails()
                                                          .currentDate()
                                                      ..tranTime = DateTimeDetails()
                                                          .onlyTime()
                                                      ..valuation = "Add";
                                                    await addTransaction.save();
                                                    UtilFsNav.showToast(
                                                        "Transaction Successfull",
                                                        context,
                                                        TransactionUpdate());
                                                  }
                                                  else {
                                                    await DAY_TRANSACTION_REPORT()
                                                        .select()
                                                        .TRAN_ID
                                                        .equals(rp[i].TRAN_ID)
                                                        .update({
                                                      'STATUS': 'FAILED'
                                                    });
                                                    UtilFsNav.showToast(
                                                        "Transaction Failed",
                                                        context,
                                                        TransactionUpdate());
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              TransactionUpdate()));
                                                } else {
                                                  UtilFsNav.showToast(
                                                      "Signature Verification Failed! Try Again",
                                                      context,
                                                      TransactionUpdate());
                                                  await LogCat().writeContent(
                                                      'Payment Confirmation screen: Signature Verification Failed.');
                                                }
                                              }
                                              else {
                                                // UtilFsNav.showToast(
                                                //     "${await response.stream.bytesToString()}",
                                                //     context,
                                                //     TransactionUpdate());
                                                print(response.statusCode);
                                                List<
                                                    API_Error_code> error = await API_Error_code()
                                                    .select()
                                                    .API_Err_code
                                                    .equals(response.statusCode)
                                                    .toList();
                                                if (response.statusCode ==
                                                    503 ||
                                                    response.statusCode ==
                                                        504) {
                                                  UtilFsNav.showToast(
                                                      "Insurance " +
                                                          error[0].Description
                                                              .toString(),
                                                      context,
                                                      TransactionUpdate());
                                                }
                                                else
                                                  UtilFsNav.showToast(
                                                      error[0].Description
                                                          .toString(), context,
                                                      TransactionUpdate());
                                              }
                                            } catch (_) {
                                              if (_.toString() == "TIMEOUT") {
                                                return UtilFsNav.showToast(
                                                    "Request Timed Out",
                                                    context,
                                                    TransactionUpdate());
                                              } else
                                                print(_);
                                            }
                                          }
                                        },
                                      )
                                    ]),
                                  ]),
                              ],
                            )),
                          ),
                        )
                      : Container(
                  ),
                  ipvisible == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                                child: Table(
                              defaultColumnWidth: IntrinsicColumnWidth(),
                              border: TableBorder.all(),
                              children: [
                                TableRow(children: [
                                  // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Proposal Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Tran Date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                  Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    )
                                  ]),
                                ]),
                                for (int i = 0; i < ip.length; i++)
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${ip[i].PROPOSAL_NUM}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${ip[i].AMOUNT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${ip[i].TRAN_DATE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600])),
                                      )
                                    ]),
                                    Column(children: [
                                      TextButton(
                                        style: ButtonStyle(
                                            // elevation:MaterialStateProperty.all(),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red)))),
                                        child: Text("Fetch Status"),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading=true;
                                          });

                                          var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                            '${ip[i].TRAN_DATE} ${ip[i].R_CRE_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                          );print(result);
                                          print(DateTime.now().difference( result).inMinutes);
                                          var diftimer=DateTime.now().difference( result).inMinutes;
                                          if(diftimer<5){
                                            UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionUpdate());

                                          }
                                          else {
                                            List<DAY_TRANSACTION_REPORT> main =
                                            [];
                                            List<USERLOGINDETAILS> acctoken =
                                            await USERLOGINDETAILS()
                                                .select()
                                                .Active
                                                .equals(true)
                                                .toList();
                                            main.add(ip[i]);
                                            encheader =
                                            await encryptTransDetails(main);
                                            try {
                                              var headers = {
                                                'Signature': '$encheader',
                                                'Uri': 'getTransactionDetails',
                                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                'Authorization':
                                                'Bearer ${acctoken[0]
                                                    .AccessToken}',
                                                'Cookie':
                                                'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                              };


                                              final File file = File(
                                                  '$cachepath/fetchAccountDetails.txt');
                                              String tosendText = await file
                                                  .readAsString();
                                              var request = http.Request('POST',
                                                  Uri.parse(
                                                      APIEndPoints().insURL));
                                              request.body = tosendText;
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
                                                var resheaders = response
                                                    .headers;
                                                print("Response Headers");
                                                print(
                                                    resheaders['authorization']);
                                                // List t =
                                                //     resheaders['authorization']!
                                                //         .split(", Signature:");
                                                String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                                String res = await response
                                                    .stream
                                                    .bytesToString();
                                                print(res);
                                                String val = await decryption1(
                                                    decryptSignature, res);
                                                print(res);
                                                print("\n\n");
                                                if (val == "Verified!") {
                                                  await LogCat().writeContent(
                                                      '$res');
                                                  Map a = json.decode(res);
                                                  print("Map a: $a");
                                                  print(a['JSONResponse']
                                                  ['jsonContent']);
                                                  String data = a['JSONResponse']
                                                  ['jsonContent'];
                                                  Map temp = json.decode(data);
                                                  print(temp);

                                                  if (temp['payment_status'] ==
                                                      "Success") {
                                                    await DAY_TRANSACTION_REPORT()
                                                        .select()
                                                        .TRAN_ID
                                                        .equals(ip[i].TRAN_ID)
                                                        .update({
                                                      'STATUS': 'SUCCESS',
                                                      'RECEIPT_NO':
                                                      '${temp['Receipt_num']}'
                                                    });
                                                    final addCash =  CashTable()
                                                      ..Cash_ID = ip[i]
                                                          .PROPOSAL_NUM
                                                      ..Cash_Date = DateTimeDetails()
                                                          .currentDate()
                                                      ..Cash_Time = DateTimeDetails()
                                                          .onlyTime()
                                                      ..Cash_Type = 'Add'
                                                      ..Cash_Amount = double
                                                          .parse(ip[i].AMOUNT!)
                                                      ..Cash_Description = "${ip[i]
                                                          .TRAN_TYPE} deposit";
                                                    await addCash.save();
                                                    final addTransaction = TransactionTable()
                                                      ..tranid = '${ip[i]
                                                          .TRAN_ID}'
                                                      ..tranDescription = "${ip[i]
                                                          .TRAN_TYPE} deposit"
                                                      ..tranAmount = double
                                                          .parse(ip[i].AMOUNT!)
                                                      ..tranType = "Insurance"
                                                      ..tranDate = DateTimeDetails()
                                                          .currentDate()
                                                      ..tranTime = DateTimeDetails()
                                                          .onlyTime()
                                                      ..valuation = "Add";
                                                    await addTransaction.save();
                                                    UtilFsNav.showToast(
                                                        "Transaction Successfull",
                                                        context,
                                                        TransactionUpdate());
                                                  } else {
                                                    await DAY_TRANSACTION_REPORT()
                                                        .select()
                                                        .TRAN_ID
                                                        .equals(ip[i].TRAN_ID)
                                                        .update({
                                                      'STATUS': 'FAILED'
                                                    });
                                                    UtilFsNav.showToast(
                                                        "Transaction Failed",
                                                        context,
                                                        TransactionUpdate());
                                                  }
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              TransactionUpdate()));
                                                } else {
                                                  UtilFsNav.showToast(
                                                      "Signature Verification Failed! Try Again",
                                                      context,
                                                      TransactionUpdate());
                                                  await LogCat().writeContent(
                                                      'Payment Confirmation screen: Signature Verification Failed.');
                                                }
                                              } else {
                                                // UtilFsNav.showToast(
                                                //     "${await response.stream.bytesToString()}",
                                                //     context,
                                                //     TransactionUpdate());
                                                print(response.statusCode);
                                                List<
                                                    API_Error_code> error = await API_Error_code()
                                                    .select()
                                                    .API_Err_code
                                                    .equals(response.statusCode)
                                                    .toList();
                                                if (response.statusCode ==
                                                    503 ||
                                                    response.statusCode ==
                                                        504) {
                                                  UtilFsNav.showToast(
                                                      "Insurance " +
                                                          error[0].Description
                                                              .toString(),
                                                      context,
                                                      TransactionUpdate());
                                                }
                                                else
                                                  UtilFsNav.showToast(
                                                      error[0].Description
                                                          .toString(), context,
                                                      TransactionUpdate());
                                              }
                                            } catch (_) {
                                              if (_.toString() == "TIMEOUT") {
                                                return UtilFsNav.showToast(
                                                    "Request Timed Out",
                                                    context,
                                                    TransactionUpdate());
                                              } else
                                                print(_);
                                            }
                                          }
                                        },
                                      )
                                    ]),
                                  ]),
                              ],
                            )),
                          ),
                        )
                      : Container(
                  ),
                  if(rpvisible==false && ipvisible==false)
                    Container(
                      child: Text("No Records to Display"),
                    )
                ],
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

  Future<void> _selectDailyTranReportDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2003),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          _selectedDate = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> encryptTransDetails(List<DAY_TRANSACTION_REPORT> main) async {
    print("Reached writeContent");
    String? ttype, text;
    List<OfficeDetail> office = await OfficeDetail().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "getTransactionDetails", "getTransactionXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text='{"2":"${myController.text}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        60001700${myController.text}","123":"SDP"}';
    // String text ="$bound""\nContent-Id: <jsonInStream>\n\n"
    //     '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${amountTextController.text}|"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";
    // accounts=="Renewal Premium"?ttype="Renewal": ttype="Initial";

    _selectedAccount == "Renewal Premium"
        ? text = "$bound"
            "\nContent-Id: <getTransactionXML>\n\n"
            '{"m_transtype":"Renewal","m_policyNo":"${main[0].POLICY_NO}","m_BoID":"${office[0].POCode}","m_fromdate":"${main[0].FROM_DATE}","m_todate":"${main[0].TO_DATE}","m_Amount":${(main[0].AMOUNT).toString().split(".")[0]},"m_ServiceReqId":"getRenewalTransactionDetails","responseParams":"payment_status,Receipt_num,Response_No"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            ""
        : text = "$bound"
            "\nContent-Id: <getTransactionXML>\n\n"
            '{"m_transtype":"Initial","m_proposalnum":"${main[0].PROPOSAL_NUM}","m_BoID":"${office[0].POCode}","m_Amount":${(main[0].AMOUNT).toString().split(".")[0]},"m_transdate":"${_selectedDate.split("-").reversed.join("-")}","m_ServiceReqId":"getInitialTransactionDetails"}\n\n'
            "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
            "";

    // String text =
    //     '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${amountTextController.text}|"}';

    print(" fetch Transaction Status details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
   LogCat().writeContent("Transaction Update ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
