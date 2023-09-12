import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../decryptHeader.dart';
import 'my_cards_screen.dart';

class TransactionStatus extends StatefulWidget {
  @override
  _TransactionStatusState createState() => _TransactionStatusState();
}

class _TransactionStatusState extends State<TransactionStatus> {
  int selected = 0;
  bool isVisible = false;
  final cifTextController = TextEditingController();
  List<TBCBS_TRAN_DETAILS> cbsDetails = [];
  String? tranStatus, tranID, tranDate;
  List<String> accounts = [
    "Cash Deposit",
    "Cash Withdrawal",
    "Account Opening",
    "High value Withdrawal"
  ];
  var _currentDate = DateTimeDetails().currentDate();
  var _selectedDate = " ";
  String _selectedAccount = "Cash Deposit";
  bool _showClearButton = true;
  TextEditingController date = TextEditingController();
  bool cdvisible = false;
  bool cwvisible = false;
  bool nacvisible = false;
  bool hvwvisible = false;
  List<TBCBS_TRAN_DETAILS> cd = [];
  List<TBCBS_TRAN_DETAILS> cw = [];
  List<TBCBS_TRAN_DETAILS> nac = [];
  List<TBCBS_TRAN_DETAILS> hvw = [];
  String? encheader;
  bool _isLoading = false;
  late Directory d;
  late String cachepath;

  // Widget customRadio(String text, int index) {
  //   return OutlineButton(
  //     onPressed: () {
  //       setState(() {
  //         selected = index;
  //         isVisible = true;
  //       });
  //     },
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //           color: (selected == index) ? Colors.green : Colors.blueGrey,
  //           fontSize: 18),
  //     ),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     borderSide: BorderSide(
  //         color: (selected == index) ? Colors.green : Colors.blueGrey),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    getCacheDir();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }
  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
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
        appBar: AppBar(
          title: Text(
            'Transaction Update',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFFB71C1C),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 20, bottom: 20),
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
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 3)),
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
                                  cdvisible = false;
                                  print(_selectedAccount);
                                  _selectedAccount = newValue!;
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
                          setState(() {
                            _isLoading=true;
                          });
                          cd.clear();
                          cw.clear();
                          nac.clear();
                          hvw.clear();
                          // TRAN_TYPE='D' AND DEVICE_TRAN_TYPE='CD' AND DATE(TRAN_DATE) = '2022-07-27'
                          // print(date.text);
                          // String dt1=date.text.toString();
                          // print(dt1);
                          // String dt=dt1.split("-").reversed.join("-");
                          // print(dt);
                          cd = await TBCBS_TRAN_DETAILS()
                              .select()
                              .STATUS
                              .equals("PENDING")
                              .and
                              .startBlock
                              .TRAN_TYPE
                              .equals('D')
                              .and
                              .DEVICE_TRAN_TYPE
                              .equals('CD')
                              .and
                              .TRAN_DATE
                              .equals(date.text.toString())
                              .endBlock
                              .toList();
                          print(cd.length);
                          if (cd.length > 0 &&
                              _selectedAccount == "Cash Deposit") {
                            setState(() {
                              _isLoading=false;
                              cdvisible = true;
                            });
                          }
                          else{
                            setState(() {
                              _isLoading=false;
                            });
                          }
                          cw = await TBCBS_TRAN_DETAILS()
                              .select()
                              .STATUS
                              .equals("PENDING")
                              .and
                              .startBlock
                              .TRAN_TYPE
                              .equals('W')
                              .and
                              .DEVICE_TRAN_TYPE
                              .equals('CW')
                              .and
                              .TRAN_DATE
                              .equals(date.text.toString())
                              .endBlock
                              .toList();
                          print(cw.length);
                          if (cw.length > 0 &&
                              _selectedAccount == "Cash Withdrawal") {
                            setState(() {
                              _isLoading=false;
                              cwvisible = true;
                            });
                          }
                          else{
                            setState(() {
                              _isLoading=false;
                            });
                          }
                          nac = await TBCBS_TRAN_DETAILS()
                              .select()
                              .STATUS
                              .equals("PENDING")
                              .and
                              .startBlock
                              .TRAN_TYPE
                              .equals('O')
                              .and
                              .DEVICE_TRAN_TYPE
                              .equals('AO')
                              .and
                              .TRAN_DATE
                              .equals(date.text.toString())
                              .endBlock
                              .toList();
                          print(nac.length);
                          if (nac.length > 0 &&
                              _selectedAccount == "Account Opening") {
                            setState(() {
                              _isLoading=false;
                              nacvisible = true;
                            });
                          }
                          else{
                            setState(() {
                              _isLoading=false;
                            });
                          }
                          hvw = await TBCBS_TRAN_DETAILS()
                              .select()
                              .STATUS
                              .equals("PENDING")
                              .and
                              .startBlock
                              .TRAN_TYPE
                              .equals('W')
                              .and
                              .DEVICE_TRAN_TYPE
                              .equals('HVW')
                              .and
                              .TRAN_DATE
                              .equals(date.text.toString())
                              .endBlock
                              .toList();
                          print(hvw.length);
                          if (hvw.length > 0 &&
                              _selectedAccount == "High value Withdrawal") {
                            setState(() {
                              _isLoading=false;
                              hvwvisible = true;
                            });
                          }
                          else{
                            setState(() {
                              _isLoading=false;
                            });
                          }
                        },
                      ),
                      cdvisible == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(),
                                children: [
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Text('S.No.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('A/c No',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Type',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Fetch Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                  ]),
                                  for (int i = 0; i < cd.length; i++)
                                    TableRow(children: [
                                      // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                      Column(children: [
                                        Text('${(i + 1).toString()}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cd[i].CUST_ACC_NUM}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cd[i].TRAN_TYPE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cd[i].TRANSACTION_AMT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cd[i].STATUS}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
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
                                          child: Text("Update"),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading=true;
                                            });
                                            print(cd[i]);
                                            print(cd[i].TRAN_TIME);
                                            print(cd[i].TRAN_DATE);

                                           var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                              '${cd[i].TRAN_DATE} ${cd[i].TRAN_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                            );print(result);
                                            print(DateTime.now().difference( result).inMinutes);
                                            var diftimer=DateTime.now().difference( result).inMinutes;
                                            if(diftimer<5){
                                              UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionStatus());

                                            }
                                            else {
                                              List<TBCBS_TRAN_DETAILS> main = [
                                              ];
                                              main.add(cd[i]);
                                              encheader =
                                              await encrypttranUpdate(
                                                  main, "deposit");
                                              List<USERLOGINDETAILS> acctoken =
                                              await USERLOGINDETAILS()
                                                  .select()
                                                  .Active
                                                  .equals(true)
                                                  .toList();
                                              // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                                              // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                              try {
                                                var headers = {
                                                  'Signature': '$encheader',
                                                  'Uri': 'requestSign',
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
                                                var request = http.Request(
                                                    'POST', Uri.parse(
                                                    APIEndPoints().cbsURL));
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

                                                if (response.statusCode ==
                                                    200) {
                                                  // print(await response.stream.bytesToString());
                                                  var resheaders =
                                                  await response.headers;
                                                  print("Result Headers");
                                                  print(resheaders);

                                                  String temp = resheaders['authorization']!;
                                                  String decryptSignature = temp;
                                                  String res = await response
                                                      .stream
                                                      .bytesToString();
                                                  // String decryptSignature =
                                                  //     await decryptHeader(t[1]);
                                                  String val = await decryption1(
                                                      decryptSignature, res);
                                                  if (val == "Verified!") {
                                                    await LogCat().writeContent(
                                                        '$res');
                                                    Map a = json.decode(res);
                                                    print(a['JSONResponse']
                                                    ['jsonContent']);
                                                    String data = a['JSONResponse']
                                                    ['jsonContent'];
                                                    Map main1 = json.decode(
                                                        data);
                                                    if (main1['SuccessOrFailure'] ==
                                                        "SUCCESS") {
                                                      if (main1['Transtat'] ==
                                                          "Posted") {
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(cd[i]
                                                                .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'SUCCESS',
                                                          'TRANSACTION_ID':
                                                              main1['TranID']
                                                        });
                                                        final addCash =  CashTable()
                                                          ..Cash_ID = main[0]
                                                              .CUST_ACC_NUM
                                                          ..Cash_Date = DateTimeDetails()
                                                              .currentDate()
                                                          ..Cash_Time = DateTimeDetails()
                                                              .onlyTime()
                                                          ..Cash_Type = 'Add'
                                                          ..Cash_Amount = double
                                                              .parse(cd[i]
                                                              .TRANSACTION_AMT!)
                                                          ..Cash_Description = "${cd[i]
                                                              .ACCOUNT_TYPE} deposit";
                                                        await addCash.save();
                                                        final addTransaction = TransactionTable()
                                                          ..tranid = '${main1['TranID']}'
                                                          ..tranDescription = "${cd[i]
                                                              .ACCOUNT_TYPE} deposit"
                                                          ..tranAmount = double
                                                              .parse(cd[i]
                                                              .TRANSACTION_AMT!)
                                                          ..tranType = "CBS"
                                                          ..tranDate = DateTimeDetails()
                                                              .currentDate()
                                                          ..tranTime = DateTimeDetails()
                                                              .onlyTime()
                                                          ..valuation = "Add";
                                                        await addTransaction.save();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Posted Successfully",
                                                            context,
                                                            TransactionStatus());
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //       builder: (context) =>
                                                        //           TransactionStatus()),
                                                        // );
                                                      } else {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(cd[i]
                                                            .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'FAILED'
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Failed",
                                                            context,
                                                            TransactionStatus());
                                                      }
                                                    }
                                                  } else {
                                                    UtilFs.showToast(
                                                        "Signature Verification Failed! Try Again",
                                                        context);
                                                    await LogCat().writeContent(
                                                        'Transaction Update screen: Signature Verification Failed.');
                                                  }
                                                } else {
                                                  // UtilFs.showToast(
                                                  //     "${await response.stream.bytesToString()}",
                                                  //     context);
                                                  print(response.statusCode);
                                                  List<
                                                      API_Error_code> error = await API_Error_code()
                                                      .select()
                                                      .API_Err_code
                                                      .equals(
                                                      response.statusCode)
                                                      .toList();
                                                  if (response.statusCode ==
                                                      503 ||
                                                      response.statusCode ==
                                                          504) {
                                                    UtilFsNav.showToast("CBS " +
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                  }
                                                  else
                                                    UtilFsNav.showToast(
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                }
                                              } catch (_) {
                                                if (_.toString() == "TIMEOUT") {
                                                  return UtilFs.showToast(
                                                      "Request Timed Out",
                                                      context);
                                                }
                                              }
                                            }
                                          },
                                        )
                                      ]),
                                    ]),
                                ],
                              )),
                            )
                          : Container(),
                      cwvisible == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(),
                                children: [
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Text('S.No.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('A/c No',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Type',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Fetch Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                  ]),
                                  for (int i = 0; i < cw.length; i++)
                                    TableRow(children: [
                                      // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                      Column(children: [
                                        Text('${(i + 1).toString()}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cw[i].CUST_ACC_NUM}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cw[i].TRAN_TYPE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cw[i].TRANSACTION_AMT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${cw[i].STATUS}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
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
                                          child: Text("Update"),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading=true;
                                            });
                                            print(cw[i]);
                                            var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                              '${cw[i].TRAN_DATE} ${cw[i].TRAN_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                            );print(result);
                                            print(DateTime.now().difference( result).inMinutes);
                                            var diftimer=DateTime.now().difference( result).inMinutes;
                                            if(diftimer<5){
                                              UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionStatus());

                                            }
                                            else {
                                              List<TBCBS_TRAN_DETAILS> main = [
                                              ];
                                              main.add(cw[i]);
                                              encheader =
                                              await encrypttranUpdate(
                                                  main, "withdraw");
                                              // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                                              // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));

                                              List<USERLOGINDETAILS> acctoken =
                                              await USERLOGINDETAILS()
                                                  .select()
                                                  .Active
                                                  .equals(true)
                                                  .toList();
                                              try {
                                                var headers = {
                                                  'Signature': '$encheader',
                                                  'Uri': 'requestSign',
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
                                                var request = http.Request(
                                                    'POST', Uri.parse(
                                                    APIEndPoints().cbsURL));
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

                                                if (response.statusCode ==
                                                    200) {
                                                  // print(await response.stream.bytesToString());
                                                  var resheaders =
                                                  await response.headers;
                                                  print("Result Headers");
                                                  print(resheaders);
                                                  // List t =
                                                  //     resheaders['authorization']!
                                                  //         .split(", Signature:");
                                                  String res = await response
                                                      .stream
                                                      .bytesToString();
                                                  String temp = resheaders['authorization']!;
                                                  String decryptSignature = temp;

                                                  String val = await decryption1(
                                                      decryptSignature, res);
                                                  if (val == "Verified!") {
                                                    await LogCat().writeContent(
                                                        '$res');
                                                    Map a = json.decode(res);
                                                    print(a['JSONResponse']
                                                    ['jsonContent']);
                                                    String data = a['JSONResponse']
                                                    ['jsonContent'];
                                                    Map main1 = json.decode(
                                                        data);
                                                    if (main1['SuccessOrFailure'] ==
                                                        "SUCCESS") {
                                                      if (main1['Transtat'] ==
                                                          "Posted") {
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(cw[i]
                                                            .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'SUCCESS',
                                                          'TRANSACTION_ID':
                                                          main1['TranID']
                                                        });
                                                        final addCash =  CashTable()
                                                          ..Cash_ID = main[0]
                                                              .CUST_ACC_NUM
                                                          ..Cash_Date = DateTimeDetails()
                                                              .currentDate()
                                                          ..Cash_Time = DateTimeDetails()
                                                              .onlyTime()
                                                          ..Cash_Type = 'Add'
                                                          ..Cash_Amount = double
                                                              .parse("-${cw[i]
                                                              .TRANSACTION_AMT!}")
                                                          ..Cash_Description = "SB Withdrawal";
                                                        await addCash.save();
                                                        final addTransaction = TransactionTable()
                                                          ..tranid = '${main1['TranID']}'
                                                          ..tranDescription = "${cw[i]
                                                              .ACCOUNT_TYPE} Withdrawal"
                                                          ..tranAmount = double
                                                              .parse("-${cw[i]
                                                              .TRANSACTION_AMT!}")
                                                          ..tranType = "CBS"
                                                          ..tranDate = DateTimeDetails()
                                                              .currentDate()
                                                          ..tranTime = DateTimeDetails()
                                                              .onlyTime()
                                                          ..valuation = "Add";
                                                        await addTransaction.save();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Posted Successfully",
                                                            context,
                                                            TransactionStatus());
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //       builder: (
                                                        //           context) =>
                                                        //           TransactionStatus()),
                                                        // );
                                                      } else {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(cw[i]
                                                            .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'FAILED'
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Failed",
                                                            context,
                                                            TransactionStatus());
                                                      }
                                                    }
                                                  } else {
                                                    UtilFs.showToast(
                                                        "Signature Verification Failed! Try Again",
                                                        context);
                                                    await LogCat().writeContent(
                                                        'Transaction Update screen: Signature Verification Failed');
                                                  }
                                                } else {
                                                  // UtilFs.showToast(
                                                  //     "${await response.stream.bytesToString()}",
                                                  //     context);

                                                  print(response.statusCode);
                                                  List<
                                                      API_Error_code> error = await API_Error_code()
                                                      .select()
                                                      .API_Err_code
                                                      .equals(
                                                      response.statusCode)
                                                      .toList();
                                                  if (response.statusCode ==
                                                      503 ||
                                                      response.statusCode ==
                                                          504) {
                                                    UtilFsNav.showToast("CBS " +
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                  }
                                                  else
                                                    UtilFsNav.showToast(
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                }
                                              } catch (_) {
                                                if (_.toString() == "TIMEOUT") {
                                                  return UtilFs.showToast(
                                                      "Request Timed Out",
                                                      context);
                                                }
                                              }
                                            }
                                          },
                                        )
                                      ]),
                                    ]),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("A/c No")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Type")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Amount")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Status")]),
                                  //     ]
                                  // ),
                                ],
                              )),
                            )
                          : Container(),
                      nacvisible == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(),
                                children: [
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Text('S.No.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('A/c No',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Type',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Fetch Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                  ]),
                                  for (int i = 0; i < nac.length; i++)
                                    TableRow(children: [
                                      // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                      Column(children: [
                                        Text('${(i + 1).toString()}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('New Account-${nac[i].ACCOUNT_TYPE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${nac[i].TRAN_TYPE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${nac[i].TRANSACTION_AMT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${nac[i].STATUS}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
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
                                          child: Text("Update"),
                                          onPressed: () async {

                                            setState(() {
                                              _isLoading=true;
                                            });
                                            print(nac[i]);
                                            var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                              '${nac[i].TRAN_DATE} ${nac[i].TRAN_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                            );print(result);
                                            print(DateTime.now().difference( result).inMinutes);
                                            var diftimer=DateTime.now().difference( result).inMinutes;
                                            if(diftimer<5){
                                              UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionStatus());

                                            }
                                            else {
                                              List<TBCBS_TRAN_DETAILS> main = [
                                              ];
                                              main.add(nac[i]);
                                              List<USERLOGINDETAILS> acctoken =
                                              await USERLOGINDETAILS()
                                                  .select()
                                                  .Active
                                                  .equals(true)
                                                  .toList();
                                              encheader =
                                              await nactranUpdate(main);

                                              var headers = {
                                                'Signature': '$encheader',
                                                'Uri': 'requestSign',
                                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                'Authorization':
                                                'Bearer ${acctoken[0]
                                                    .AccessToken}',
                                                'Cookie':
                                                'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                              };
                                              // var request = http.Request(
                                              //     'POST',
                                              //     Uri.parse(
                                              //         'https://gateway.cept.gov.in:443/cbs/requestSign'));
                                              final File file = File(
                                                  '$cachepath/fetchAccountDetails.txt');
                                              String tosendText = await file
                                                  .readAsString();
                                              var request = http.Request('POST',
                                                  Uri.parse(
                                                      APIEndPoints().cbsURL));
                                              request.body = tosendText;
                                              request.headers.addAll(headers);
                                              http.StreamedResponse response =
                                              await request.send();
                                              print(response.statusCode);
                                              if (response.statusCode == 200) {
                                                // print(await response.stream.bytesToString());
                                                var resheaders =
                                                await response.headers;
                                                // List t =
                                                // resheaders['authorization']!
                                                //     .split(", Signature:");
                                                String res = await response
                                                    .stream
                                                    .bytesToString();
                                                String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;

                                                String val = await decryption1(
                                                    decryptSignature, res);
                                                if (val == "Verified!") {
                                                  await LogCat().writeContent(
                                                      '$res');
                                                  Map a = json.decode(res);
                                                  print(a['JSONResponse']
                                                  ['jsonContent']);
                                                  String data = a['JSONResponse']
                                                  ['jsonContent'];
                                                  Map main = json.decode(data);
                                                  if (main['SuccessOrFailure'] ==
                                                      "SUCCESS") {
                                                    if (main['RefNum'] !=
                                                        null) {
                                                      await TBCBS_TRAN_DETAILS()
                                                          .select()
                                                          .DEVICE_TRAN_ID
                                                          .equals(
                                                          nac[i].DEVICE_TRAN_ID)
                                                          .update({
                                                        'STATUS': 'SUCCESS',
                                                      });
                                                      print("Rakesh CBS");
                                                      final addCash =  CashTable()
                                                        ..Cash_ID = '${nac[i].DEVICE_TRAN_ID}'
                                                        ..Cash_Date = DateTimeDetails()
                                                            .currentDate()
                                                        ..Cash_Time = DateTimeDetails()
                                                            .onlyTime()
                                                        ..Cash_Type = 'Add'
                                                        ..Cash_Amount = double
                                                            .parse("${nac[i].TRANSACTION_AMT}")
                                                        ..Cash_Description = "TD Acc Opening";
                                                      await addCash.save();

                                                      final addTransaction = TransactionTable()
                                                        ..tranid = '${nac[i].DEVICE_TRAN_ID}'
                                                        ..tranDescription = "New Account Opening"
                                                        ..tranAmount = double
                                                            .parse("${nac[i].TRANSACTION_AMT}")
                                                        ..tranType = "CBS"
                                                        ..tranDate = DateTimeDetails()
                                                            .currentDate()
                                                        ..tranTime = DateTimeDetails()
                                                            .onlyTime()
                                                        ..valuation = "Add";
                                                      await addTransaction.save();

                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      UtilFsNav.showToast(
                                                          "Transaction Posted Successfully",
                                                          context,
                                                          TransactionStatus());
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) => TransactionStatus()),
                                                      // );
                                                    } else {
                                                      await TBCBS_TRAN_DETAILS()
                                                          .select()
                                                          .DEVICE_TRAN_ID
                                                          .equals(
                                                          nac[i].DEVICE_TRAN_ID)
                                                          .update(
                                                          {'STATUS': 'FAILED'});
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      UtilFsNav.showToast(
                                                          "Transaction Failed",
                                                          context,
                                                          TransactionStatus());
                                                    }
                                                  }
                                                  else if (main['Status'] ==
                                                      "FAILURE") {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    UtilFs.showToast(
                                                        main['errorMsg'],
                                                        context);
                                                  }
                                                }
                                                else {
                                                  UtilFs.showToast(
                                                      "Signature Verification Failed! Try Again",
                                                      context);
                                                  await LogCat().writeContent(
                                                      'Transaction Update screen: Signature Verification Failed.');
                                                }
                                              } else {
                                                // UtilFs.showToast(
                                                //     "${await response.stream.bytesToString()}",
                                                //     context);

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
                                                  UtilFsNav.showToast("CBS " +
                                                      error[0].Description
                                                          .toString(), context,
                                                      TransactionStatus());
                                                }
                                                else
                                                  UtilFsNav.showToast(
                                                      error[0].Description
                                                          .toString(), context,
                                                      TransactionStatus());
                                              }
                                            }
                                          },
                                        )
                                      ]),
                                    ]),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("A/c No")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Type")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Amount")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Status")]),
                                  //     ]
                                  // ),
                                ],
                              )),
                            )
                          : Container(),
                      hvwvisible == true
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Table(
                                defaultColumnWidth: IntrinsicColumnWidth(),
                                border: TableBorder.all(),
                                children: [
                                  TableRow(children: [
                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    Column(children: [
                                      Text('S.No.',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('A/c No',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Type',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Amount',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('Fetch Status',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]))
                                    ]),
                                  ]),
                                  for (int i = 0; i < hvw.length; i++)
                                    TableRow(children: [
                                      // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                      Column(children: [
                                        Text('${(i + 1).toString()}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${hvw[i].CUST_ACC_NUM}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${hvw[i].TRAN_TYPE}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${hvw[i].TRANSACTION_AMT}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
                                      ]),
                                      Column(children: [
                                        Text('${hvw[i].STATUS}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600]))
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
                                          child: Text("Update"),
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading=true;
                                            });
                                            print(hvw[i]);
                                            var result= DateFormat("dd-MM-yyyy hh:mm aaa").parse(
                                              '${hvw[i].TRAN_DATE} ${hvw[i].TRAN_TIME}'.replaceAll('pm', 'PM').replaceAll('am', 'AM'),
                                            );print(result);
                                            print(DateTime.now().difference( result).inMinutes);
                                            var diftimer=DateTime.now().difference( result).inMinutes;
                                            if(diftimer<5){
                                              UtilFsNav.showToast("Please try after ${5-diftimer} minutes", context,TransactionStatus());

                                            }
                                            else {
                                              List<TBCBS_TRAN_DETAILS> main = [
                                              ];
                                              main.add(hvw[i]);
                                              encheader =
                                              await encrypttranUpdate(
                                                  main, "hvw");
                                              // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                                              // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));

                                              List<USERLOGINDETAILS> acctoken =
                                              await USERLOGINDETAILS()
                                                  .select()
                                                  .Active
                                                  .equals(true)
                                                  .toList();
                                              try {
                                                var headers = {
                                                  'Signature': '$encheader',
                                                  'Uri': 'requestSign',
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
                                                var request = http.Request(
                                                    'POST', Uri.parse(
                                                    APIEndPoints().cbsURL));
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

                                                if (response.statusCode ==
                                                    200) {
                                                  // print(await response.stream.bytesToString());
                                                  var resheaders =
                                                  await response.headers;
                                                  print("Result Headers");
                                                  print(resheaders);
                                                  // List t =
                                                  //     resheaders['authorization']!
                                                  //         .split(", Signature:");
                                                  String res = await response
                                                      .stream
                                                      .bytesToString();
                                                  String temp = resheaders['authorization']!;
                                                  String decryptSignature = temp;

                                                  String val = await decryption1(
                                                      decryptSignature, res);
                                                  if (val == "Verified!") {
                                                    Map a = json.decode(res);
                                                    print(a['JSONResponse']
                                                    ['jsonContent']);
                                                    String data = a['JSONResponse']
                                                    ['jsonContent'];
                                                    Map main = json.decode(
                                                        data);
                                                    if (main['SuccessOrFailure'] ==
                                                        "SUCCESS") {
                                                      if (main['Transtat'] ==
                                                          "Posted") {
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(hvw[i]
                                                            .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'SUCCESS',
                                                          'TRANSACTION_ID':
                                                          main['TranID']
                                                        });
                                                        final addCash =  CashTable()
                                                          ..Cash_ID = '${hvw[i].CUST_ACC_NUM}'
                                                          ..Cash_Date = DateTimeDetails()
                                                              .currentDate()
                                                          ..Cash_Time = DateTimeDetails()
                                                              .onlyTime()
                                                          ..Cash_Type = 'Add'
                                                          ..Cash_Amount = double
                                                              .parse("-'${hvw[i].TRANSACTION_AMT}'")
                                                          ..Cash_Description = "High Value Withdrawal";
                                                        await addCash.save();
                                                        final addTransaction = TransactionTable()
                                                          ..tranid = '${hvw[i]
                                                              .DEVICE_TRAN_ID}'
                                                          ..tranDescription = "High Value Withdrawal"
                                                          ..tranAmount = double
                                                              .parse("-${hvw[i].TRANSACTION_AMT}")
                                                          ..tranType = "CBS"
                                                          ..tranDate = DateTimeDetails()
                                                              .currentDate()
                                                          ..tranTime = DateTimeDetails()
                                                              .onlyTime()
                                                          ..valuation = "Add";
                                                        await addTransaction.save();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Posted Successfully",
                                                            context,
                                                            TransactionStatus());
                                                        // Navigator.push(
                                                        //   context,
                                                        //   MaterialPageRoute(
                                                        //       builder: (
                                                        //           context) =>
                                                        //           TransactionStatus()),
                                                        // );
                                                      } else {
                                                        await TBCBS_TRAN_DETAILS()
                                                            .select()
                                                            .DEVICE_TRAN_ID
                                                            .equals(hvw[i]
                                                            .DEVICE_TRAN_ID)
                                                            .update({
                                                          'STATUS': 'FAILED'
                                                        });
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        UtilFsNav.showToast(
                                                            "Transaction Failed",
                                                            context,
                                                            TransactionStatus());
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  // UtilFs.showToast(
                                                  //     "${await response.stream.bytesToString()}",
                                                  //     context);
                                                  print(response.statusCode);
                                                  List<
                                                      API_Error_code> error = await API_Error_code()
                                                      .select()
                                                      .API_Err_code
                                                      .equals(
                                                      response.statusCode)
                                                      .toList();
                                                  if (response.statusCode ==
                                                      503 ||
                                                      response.statusCode ==
                                                          504) {
                                                    UtilFsNav.showToast("CBS " +
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                  }
                                                  else
                                                    UtilFsNav.showToast(
                                                        error[0].Description
                                                            .toString(),
                                                        context,
                                                        TransactionStatus());
                                                }
                                              } catch (_) {
                                                if (_.toString() == "TIMEOUT") {
                                                  return UtilFs.showToast(
                                                      "Request Timed Out",
                                                      context);
                                                }
                                              }
                                            }
                                          },
                                        )
                                      ]),
                                    ]),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("A/c No")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Type")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Amount")]),
                                  //     ]
                                  // ),
                                  // TableRow(
                                  //     children: [
                                  //       Column(children:[Text("Status")]),
                                  //     ]
                                  // ),
                                ],
                              )),
                            )
                          : Container(),
                      if(cdvisible==false && cwvisible==false && nacvisible==false && hvwvisible==false)
                        Container(
                          child: Text("No Records to Display"),
                        )
                    ],
                  ),
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
      ),
    );
  }

  // Future<File> tranUpdate(List<TBCBS_TRAN_DETAILS> main) async{
  //
  //   final file =
  //   await File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   // file.writeAsStringSync('{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().headerTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"","m_SysTime":"25-07-2022","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}');
  //   String text ='{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().tranUpdateTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"${main[0].CUST_ACC_NUM}","m_SysTime":"${DateTimeDetails().currentDate()}","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}';
  //    print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encrypttranUpdate(
      List<TBCBS_TRAN_DETAILS> main, String type) async {
    late String cmd;
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    // file.writeAsStringSync('{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().headerTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"","m_SysTime":"25-07-2022","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    if (type == "deposit") {
      cmd = "CRTR";
    } else if (type == "withdraw") {
      cmd = "CWDR";
    }
    else if (type == "hvw") {
      cmd = "CHVW";
    }
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().tranUpdateTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"$cmd","m_RequestNo":"${main[0].CUST_ACC_NUM}","m_SysTime":"${DateTimeDetails().currentDate()}","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Transaction Update ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> nactranUpdate(List<TBCBS_TRAN_DETAILS> main) async {
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    // file.writeAsStringSync('{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().headerTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"","m_SysTime":"25-07-2022","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    String text =
        "$bound"
        "\nContent-Id: <postSignXML>\n\n"
       '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_RequestDate":"${DateTimeDetails().tranUpdateTime()}","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"${main[0].OFFICE_ACC_NUM}","m_SysTime":"${DateTimeDetails().currentDate()}","m_StanId":"${main[0].DEVICE_TRAN_ID}","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}\n\n'
       // '{"m_ReqUUID":"Req_20230825133623","m_RequestDate":"2023-08-25T13:36:23.471","m_ServiceReqId":"RecRequestXML_CW_CD_AO","m_Command":"CRTR","m_RequestNo":"63155101D4920N","m_SysTime":"25-08-2023","m_StanId":"TQ5peMt3Gref","responseParams":"Status,status,SuccessOrFailure,Transtat,TranID,RefNum,req_date,rej_reason,amount,ErrorCode,ErrorDesc,ErrorType"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New Account Transaction Update${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Widget? _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {cifTextController.clear()},
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
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
}
