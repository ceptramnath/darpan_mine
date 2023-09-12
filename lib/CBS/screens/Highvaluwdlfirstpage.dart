import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:basic_utils/basic_utils.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:darpan_mine/CBS/accdetails.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:http/http.dart' as http;
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:path_provider/path_provider.dart';
import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../decryptHeader.dart';
import 'HighcashwithdrawlCard.dart';
import 'initiateHighWithdrawlCartStyle.dart';

//import 'initiateHighWithdrawlSecondpage.dart';
import 'transactionsuccess.dart';
import 'my_cards_screen.dart';

class HighValueWd extends StatefulWidget {
  final acct_Num;

  HighValueWd(this.acct_Num);

  @override
  _HighValueWdState createState() => _HighValueWdState();
}

class _HighValueWdState extends State<HighValueWd> {
  final amountTextController = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  bool _isInitiateWithdrawl = false;
  bool _showClearButton = true;
  bool _showAmtClearButton = true;
  bool _isVisible = false;
  bool _isAmount = false;
  Map main = {};
  Map depositmain = {};
  List? rec = [];
  List<TBCBS_EXCEP_DETAILS> checkReq = [];
  bool _isLoading = false;
  bool _isCreated = false;
  String? displaybalance;
  Map cmain = {};

  // List<TBCBS_EXCEP_DETAILS>tranExpDetails=[];
  List<TBCBS_EXCEP_DETAILS> expDetails = [];
  List<TBCBS_TRAN_DETAILS> cbsDetails = [];
  String? balAftrTrn;
  List? balances = [];
  String? achname;
  String? bal, mainbal, balafterdeposit;
  String amt = "";
  String acctNum = "";
  String reqNum = "";
  String reqDate = "";
  String status = "";
  String msg = "";
  Map mainWdl = {};
  bool finalwdl = false;
  final RegExp regexp = new RegExp(r'^0+(?=.)');
  final _formKey = GlobalKey<FormState>();
  String? encheader = "";

  // var TranID="Req_${DateTimeDetails().cbsdatetime()}";
  final TranReqID = DateTimeDetails().cbsdatetime();
  final TranID = GenerateRandomString().random12Number();
  var tid;
  late Directory d;
  late String cachepath;

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
        (route) => false);
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCacheDir();
    setState(() {
      amountTextController.clear();
      accountType.clear();
      myController.clear();
      _isVisible = false;
      _isAmount = false;
      if (widget.acct_Num != "") {
        myController.text = widget.acct_Num;
        getAcctDetails();
      }
    });
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
              'High Value Cash Withdrawal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            backgroundColor: Color(0xFFB71C1C),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
          ),
          body: Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(children: [
                    _searchBar(),
                    _isVisible == false
                        ? TextButton(
                            child: Text("Submit"),
                            style: ButtonStyle(
                                // elevation:MaterialStateProperty.all(),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _isLoading = true;
                              });
                              getAcctDetails();
                            },
                          )
                        : Container(),
                    Visibility(
                        visible: _isVisible,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Text(accountType.text + ' Account Details',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.blueGrey)),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Table(border: TableBorder.all(), children: [
                              TableRow(
                                children: [
                                  Column(children: [
                                    Text('Account No.',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                  Column(children: [
                                    Text(myController.text,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Column(children: [
                                    Text('Primary Account Holder',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                  Column(children: [
                                    Text('$achname',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Column(children: [
                                    Text('Account Balance',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                  Column(children: [
                                    Text('\u{20B9} $mainbal',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                ],
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          // Column(children: [
                          //   Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          //     RaisedButton(
                          //         child: Text('NEW REQUEST',
                          //             style: TextStyle(fontSize: 16)),
                          //         color: Color(0xFFB71C1C),
                          //         textColor: Colors.white,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         onPressed: ()
                          //             //{ setState(() { _isAmount = true; });}
                          //             async {
                          //           setState(() {
                          //             _isAmount = true;
                          //           });
                          //
                          //           _isInitiateWithdrawl = false;
                          //           // amountTextController.clear();
                          //         }),
                          //     SizedBox(
                          //       width: 8,
                          //     ),
                          //     RaisedButton(
                          //         child:
                          //             Text('ENQUIRY', style: TextStyle(fontSize: 16)),
                          //         color: Color(0xFFB71C1C),
                          //         textColor: Colors.white,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(20),
                          //         ),
                          //         onPressed: () async {
                          //           setState(() {
                          //             _isLoading = true;
                          //           });
                          //
                          //
                          //           var excwdl=await TBCBS_EXCEP_DETAILS().select().toList();
                          //
                          //
                          //           await fetchenquiry();
                          //           setState(() {
                          //             _isAmount = false;
                          //           });
                          //           var request = http.Request(
                          //               'POST',
                          //               Uri.parse(
                          //                   'https://gateway.cept.gov.in:443/cbs/requestJson'));
                          //           request.files.add(await http.MultipartFile.fromPath(
                          //               '',
                          //               '$cachepath/hvw_enquiry.txt'));
                          //           http.StreamedResponse response =
                          //               await request.send();
                          //           setState(() {
                          //             _isLoading = false;
                          //           });
                          //           if (response.statusCode == 200) {
                          //             String res =
                          //                 await response.stream.bytesToString();
                          //             Map a = json.decode(res);
                          //             print(a['JSONResponse']['jsonContent']);
                          //             String data = a['JSONResponse']['jsonContent'];
                          //             depositmain = json.decode(data);
                          //             print(depositmain);
                          //
                          //             if (depositmain['Status'] == "SUCCESS") {
                          //               if (expDetails[0].ACCOUNT_NUMBER ==
                          //                       myController.text &&
                          //                   expDetails[0].REQUEST_NUMBER ==
                          //                       DateTimeDetails()
                          //                           .onlyDatewithFormat()) {
                          //                 print(rec![4]);
                          //                 amt = depositmain['amount'];
                          //                 acctNum = depositmain['acctNum'];
                          //                 reqNum = TranID;
                          //                 reqDate = depositmain['reqDate'];
                          //                 status = depositmain['status'];
                          //                 setState(() {
                          //                   _isInitiateWithdrawl = true;
                          //                 });
                          //               } else {
                          //                 showDialog(
                          //                     context: context,
                          //                     builder: (BuildContext context) {
                          //                       return AlertDialog(
                          //                         content: Text(
                          //                             'No pending requests.Please create new request'),
                          //                       );
                          //                     });
                          //               }
                          //             } else {
                          //               UtilFs.showToast(
                          //                   response.reasonPhrase!, context);
                          //                UtilFs.showToast("${await response.stream.bytesToString()}", context);
                          //             }
                          //           }
                          //         }),
                          //   ]),
                          //   SizedBox(
                          //     height: 8,
                          //   ),
                          //   Visibility(
                          //       visible: _isAmount,
                          //       child: Column(children: [
                          //         SingleChildScrollView(
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8),
                          //             child: TextField(
                          //               style: TextStyle(
                          //                   fontSize: 17,
                          //                   color: //Colors.white,
                          //                       Color.fromARGB(255, 2, 40, 86),
                          //                   fontWeight: FontWeight.w500),
                          //               controller: amountTextController,
                          //               keyboardType: TextInputType.number,
                          //               decoration: InputDecoration(
                          //                 prefixIcon: Padding(
                          //                   padding: EdgeInsets.only(left: 8),
                          //                   child: Icon(
                          //                     Icons.money_off_sharp,
                          //                     size: 22,
                          //                   ),
                          //                 ),
                          //                 hintStyle: TextStyle(
                          //                   fontSize: 15,
                          //                   color: Color.fromARGB(255, 2, 40, 86),
                          //                   fontWeight: FontWeight.w500,
                          //                 ),
                          //                 hintText: ' Enter Amount',
                          //                 border: InputBorder.none,
                          //                 enabledBorder: OutlineInputBorder(
                          //                     borderRadius: BorderRadius.all(
                          //                         Radius.circular(30.0)),
                          //                     borderSide: BorderSide(
                          //                         color: Colors.blueAccent, width: 1)),
                          //                 focusedBorder: OutlineInputBorder(
                          //                     borderRadius: BorderRadius.all(
                          //                         Radius.circular(30.0)),
                          //                     borderSide: BorderSide(
                          //                         color: Colors.green, width: 1)),
                          //                 contentPadding: EdgeInsets.only(
                          //                     top: 20, bottom: 20, left: 20, right: 20),
                          //                 suffixIcon: _getAmtClearButton(),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         SizedBox(height: 8),
                          //         RaisedButton(
                          //             child: Text('Create New Request',
                          //                 style: TextStyle(fontSize: 16)),
                          //             color: Color(0xFFB71C1C),
                          //             //Colors.green,
                          //             textColor: Colors.white,
                          //             shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(20),
                          //             ),
                          //             onPressed: () async {
                          //               setState(() {
                          //                 _isInitiateWithdrawl = false;
                          //               });
                          //               int amt = int.parse(amountTextController.text);
                          //               if (amt <= 20000) {
                          //                 showDialog(
                          //                     context: context,
                          //                     builder: (BuildContext context) {
                          //                       return AlertDialog(
                          //                           backgroundColor: Colors.white,
                          //                           shape: RoundedRectangleBorder(
                          //                               borderRadius: BorderRadius.all(
                          //                                   Radius.circular(10.0))),
                          //                           contentPadding:
                          //                               EdgeInsets.all(10.0),
                          //                           content: Stack(
                          //                             children: <Widget>[
                          //                               Positioned(
                          //                                 top: -20.0,
                          //                                 right: -30.0,
                          //                                 child: Padding(
                          //                                   padding:
                          //                                       const EdgeInsets.only(
                          //                                           top: 10.0),
                          //                                   child: Align(
                          //                                     alignment:
                          //                                         Alignment.topRight,
                          //                                     child: FlatButton(
                          //                                       child: Container(
                          //                                         decoration:
                          //                                             BoxDecoration(
                          //                                           color: Colors
                          //                                               .grey[200],
                          //                                           borderRadius:
                          //                                               BorderRadius
                          //                                                   .circular(
                          //                                                       12),
                          //                                         ),
                          //                                         child: Icon(
                          //                                           Icons.close,
                          //                                           color: Colors.red,
                          //                                         ),
                          //                                       ),
                          //                                       onPressed: () {
                          //                                         Navigator.pop(
                          //                                             context);
                          //                                       },
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               SizedBox(
                          //                                 height: 20.0,
                          //                               ),
                          //                               Container(
                          //                                 width: MediaQuery.of(context)
                          //                                         .size
                          //                                         .width *
                          //                                     4.0,
                          //                                 height: MediaQuery.of(context)
                          //                                         .size
                          //                                         .height *
                          //                                     0.30.h,
                          //                                 child: Column(
                          //                                   // mainAxisAlignment: MainAxisAlignment.center,
                          //                                   // crossAxisAlignment: CrossAxisAlignment.stretch,
                          //                                   //  mainAxisSize: MainAxisSize.min,
                          //                                   children: <Widget>[
                          //                                     Center(
                          //                                       child: Padding(
                          //                                         padding:
                          //                                             const EdgeInsets
                          //                                                 .all(10.0),
                          //                                         child: new Text(
                          //                                             'Amount requested should be greater than Rs.20000, Please'
                          //                                             ' use cash withdrawal option for amount less than or equal to Rs.20000/-',
                          //                                             style: TextStyle(
                          //                                                 fontSize:
                          //                                                     23.0,
                          //                                                 color: Colors
                          //                                                     .black)),
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           ));
                          //                     });
                          //               } else {
                          //                 setState(() {
                          //                   _isLoading = true;
                          //                 });
                          //                 var login=await USERDETAILS().select().toList();
                          //                 await fetchCreateRequest();
                          //                 var request = http.Request(
                          //                     'POST',
                          //                     Uri.parse(
                          //                         'https://gateway.cept.gov.in:443/cbs/requestSign'));
                          //                 request.files.add(
                          //                     await http.MultipartFile.fromPath('',
                          //                         '$cachepath/hvw_CreateNewRequest.txt'));
                          //                 http.StreamedResponse response =
                          //                     await request.send();
                          //                 setState(() {
                          //                   _isLoading = false;
                          //                 });
                          //                 if (response.statusCode == 200) {
                          //                   String res =
                          //                       await response.stream.bytesToString();
                          //                   Map a = json.decode(res);
                          //                   print(a['JSONResponse']['jsonContent']);
                          //                   String data =
                          //                       a['JSONResponse']['jsonContent'];
                          //                   main = json.decode(data);
                          //                   print("Values");
                          //                   print(main);
                          //                   if (main['successOrFailure'] == "SUCCESS") {
                          //                     // if(depositmain['39']!="000"){
                          //                     //   UtilFs.showToast(depositmain['127'], context);
                          //                     // }
                          //                     // else {
                          //                     // print(rec![4]);
                          //
                          //                     var currentDate = DateTimeDetails()
                          //                         .onlyDatewithFormat();
                          //                     print(TranID);
                          //                     // tranDet=depositmain['126'];
                          //                     // for(var i=0;i<tranDet!.length;i++){
                          //                     //   print(tranDet!.length);
                          //                     //   print("tranDet list is$tranDet![i]");
                          //                     // }
                          //                     // var TranID=tranDet![0];
                          //                     final tranExpDetails =
                          //                         TBCBS_EXCEP_DETAILS()
                          //                           ..REQUEST_NUMBER = TranID
                          //                           ..REQUEST_DATE = currentDate
                          //                           ..ACCOUNT_NUMBER = myController.text
                          //                           ..REQUEST_STATUS = "Pending";
                          //                     tranExpDetails.save();
                          //                     print("tranExpDetails");
                          //                     print(tranExpDetails);
                          //                     final cbsDet = TBCBS_TRAN_DETAILS()
                          //                       ..REFERENCE_NO=TranID
                          //                       ..DEVICE_TRAN_ID=TranID
                          //                       ..CUST_ACC_NUM='${myController.text}'
                          //                       ..STATUS='PENDING'
                          //                       ..TRAN_DATE=DateTimeDetails().currentDate()
                          //                       ..TRAN_TIME=DateTimeDetails().onlyTime()
                          //                       ..TRAN_TYPE="HVW"
                          //                       ..OPERATOR_ID='${login[0].EMPID}'
                          //                       ..SCHEME_TYPE="SBGEN"
                          //                       ..TRANSACTION_AMT =
                          //                           amountTextController.text;
                          //                     cbsDet.save();
                          //                     expDetails = await TBCBS_EXCEP_DETAILS()
                          //                         .select()
                          //                         .REQUEST_NUMBER
                          //                         .equals(TranID)
                          //                         .toList();
                          //                     if (main['Message'] != null) {
                          //                       msg = main["Message"];
                          //                     }
                          //                     showDialog(
                          //                         context: context,
                          //                         builder: (BuildContext context) {
                          //                           return AlertDialog(
                          //                               content: Container(
                          //                             decoration: BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius.circular(40),
                          //                             ),
                          //                             child: Column(
                          //                                 mainAxisAlignment:
                          //                                     MainAxisAlignment.center,
                          //                                 crossAxisAlignment:
                          //                                     CrossAxisAlignment
                          //                                         .stretch,
                          //                                 mainAxisSize:
                          //                                     MainAxisSize.min,
                          //
                          //                                 //  crossAxisAlignment: CrossAxisAlignment.center,
                          //                                 children: [
                          //                                   Center(
                          //                                       child: Text(msg,
                          //                                           style: TextStyle(
                          //                                               fontSize: 18,
                          //                                               color: Colors
                          //                                                   .blueGrey))),
                          //                                   SizedBox(
                          //                                     height: 20,
                          //                                   ),
                          //                                   Container(
                          //                                     height:
                          //                                         MediaQuery.of(context)
                          //                                                 .size
                          //                                                 .height *
                          //                                             0.17,
                          //                                     width:
                          //                                         MediaQuery.of(context)
                          //                                             .size
                          //                                             .width,
                          //                                     // decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),),
                          //                                     child:
                          //                                         SingleChildScrollView(
                          //                                       child: Table(
                          //                                           defaultColumnWidth:
                          //                                               FixedColumnWidth(
                          //                                                   120),
                          //                                           children: [
                          //                                             TableRow(
                          //                                                 children: [
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       "Account Number:",
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       expDetails[0].ACCOUNT_NUMBER ==
                          //                                                               null
                          //                                                           ? ""
                          //                                                           : expDetails[0].ACCOUNT_NUMBER!,
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                 ]),
                          //                                             TableRow(
                          //                                                 children: [
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       "Request Number:",
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       expDetails[0].REQUEST_NUMBER ==
                          //                                                               null
                          //                                                           ? ""
                          //                                                           : expDetails[0].REQUEST_NUMBER!,
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                 ]),
                          //                                             TableRow(
                          //                                                 children: [
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       "Request Date:",
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                   Padding(
                          //                                                       padding:
                          //                                                           const EdgeInsets.all(
                          //                                                               1.0),
                          //                                                       child:
                          //                                                           Text(
                          //                                                         expDetails[0].REQUEST_DATE == null
                          //                                                             ? ""
                          //                                                             : expDetails[0].REQUEST_DATE!,
                          //                                                         textScaleFactor:
                          //                                                             1,
                          //                                                       )),
                          //                                                 ]),
                          //                                             TableRow(
                          //                                                 children: [
                          //                                                   Padding(
                          //                                                     padding:
                          //                                                         const EdgeInsets.all(
                          //                                                             1.0),
                          //                                                     child:
                          //                                                         Text(
                          //                                                       "Amount:",
                          //                                                       textScaleFactor:
                          //                                                           1,
                          //                                                     ),
                          //                                                   ),
                          //                                                   Padding(
                          //                                                       padding:
                          //                                                           const EdgeInsets.all(
                          //                                                               1.0),
                          //                                                       child:
                          //                                                           Text(
                          //                                                         cbsDetails[0].TRANSACTION_AMT == null
                          //                                                             ? ""
                          //                                                             : cbsDetails[0].TRANSACTION_AMT!,
                          //                                                         textScaleFactor:
                          //                                                             1,
                          //                                                       )),
                          //                                                 ]),
                          //                                           ]),
                          //                                     ),
                          //                                   ),
                          //                                   SizedBox(
                          //                                     height: 4,
                          //                                   ),
                          //                                   RaisedButton(
                          //                                       child: Text('PRINT',
                          //                                           style: TextStyle(
                          //                                               fontSize: 16)),
                          //                                       color:
                          //                                           Color(0xFFB71C1C),
                          //                                       textColor: Colors.white,
                          //                                       shape:
                          //                                           RoundedRectangleBorder(
                          //                                         borderRadius:
                          //                                             BorderRadius
                          //                                                 .circular(20),
                          //                                       ),
                          //                                       onPressed: () {
                          //                                         showDialog(
                          //                                             context: context,
                          //                                             builder:
                          //                                                 (BuildContext
                          //                                                     context) {
                          //                                               return AlertDialog(
                          //                                                   backgroundColor:
                          //                                                       Colors
                          //                                                           .white,
                          //                                                   shape: RoundedRectangleBorder(
                          //                                                       borderRadius:
                          //                                                           BorderRadius.all(Radius.circular(
                          //                                                               10.0))),
                          //                                                   contentPadding:
                          //                                                       EdgeInsets.all(
                          //                                                           10.0),
                          //                                                   content:
                          //                                                       Stack(
                          //                                                     children: <
                          //                                                         Widget>[
                          //                                                       Positioned(
                          //                                                         top:
                          //                                                             -20.0,
                          //                                                         right:
                          //                                                             -30.0,
                          //                                                         child:
                          //                                                             Padding(
                          //                                                           padding:
                          //                                                               const EdgeInsets.only(top: 10.0),
                          //                                                           child:
                          //                                                               Align(
                          //                                                             alignment: Alignment.topRight,
                          //                                                             child: FlatButton(
                          //                                                               child: Container(
                          //                                                                 decoration: BoxDecoration(
                          //                                                                   color: Colors.grey[200],
                          //                                                                   borderRadius: BorderRadius.circular(12),
                          //                                                                 ),
                          //                                                                 child: Icon(
                          //                                                                   Icons.close,
                          //                                                                   color: Colors.red,
                          //                                                                 ),
                          //                                                               ),
                          //                                                               onPressed: () {
                          //                                                                 Navigator.pop(context);
                          //                                                               },
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height:
                          //                                                             20.0,
                          //                                                       ),
                          //                                                       Container(
                          //                                                         width:
                          //                                                             MediaQuery.of(context).size.width * 2.0,
                          //                                                         height:
                          //                                                             MediaQuery.of(context).size.height * 0.07,
                          //                                                         child:
                          //                                                             Column(
                          //                                                           // mainAxisAlignment: MainAxisAlignment.center,
                          //                                                           // crossAxisAlignment: CrossAxisAlignment.stretch,
                          //                                                           //  mainAxisSize: MainAxisSize.min,
                          //                                                           children: <Widget>[
                          //                                                             Center(
                          //                                                               child: Padding(
                          //                                                                 padding: const EdgeInsets.all(10.0),
                          //                                                                 child: new Text('Printer not attached', style: TextStyle(fontSize: 23.0, color: Colors.black)),
                          //                                                               ),
                          //                                                             ),
                          //                                                           ],
                          //                                                         ),
                          //                                                       ),
                          //                                                     ],
                          //                                                   ));
                          //                                             });
                          //                                       }),
                          //                                   SizedBox(
                          //                                     height: 4,
                          //                                   ),
                          //                                   RaisedButton(
                          //                                     child: Text('CLOSE',
                          //                                         style: TextStyle(
                          //                                             fontSize: 16)),
                          //                                     color: Color(0xFFB71C1C),
                          //                                     textColor: Colors.white,
                          //                                     shape:
                          //                                         RoundedRectangleBorder(
                          //                                       borderRadius:
                          //                                           BorderRadius
                          //                                               .circular(20),
                          //                                     ),
                          //                                     onPressed: () {
                          //                                       Navigator.of(context)
                          //                                           .pop();
                          //                                     },
                          //                                   ),
                          //                                 ]),
                          //                           ));
                          //                         });
                          //                   } else {
                          //                      UtilFs.showToast("${await response.stream.bytesToString()}", context);
                          //                     UtilFs.showToast(
                          //                         response.reasonPhrase!, context);
                          //                   }
                          //                 }
                          //               }
                          //             })
                          //       ])),
                          //   SizedBox(
                          //     height: 20,
                          //   ),
                          //   Visibility(
                          //     visible: _isInitiateWithdrawl,
                          //     child: Column(children: [
                          //       Container(
                          //         width: MediaQuery.of(context).size.width * 0.8,
                          //         child: SingleChildScrollView(
                          //           child: Table(
                          //               columnWidths: const {
                          //                 0: FlexColumnWidth(20),
                          //                 1: FlexColumnWidth(20),
                          //               },
                          //               border: TableBorder.all(),
                          //               children: [
                          //                 TableRow(children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       "Account Number",
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       acctNum,
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                 ]),
                          //                 TableRow(children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       "Request Number",
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       TranID,
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                 ]),
                          //                 TableRow(children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       "Request Date",
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       reqDate,
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                 ]),
                          //                 TableRow(children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       "Amount",
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       amt,
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                 ]),
                          //                 TableRow(children: [
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       "Status",
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.all(8.0),
                          //                     child: Text(
                          //                       status,
                          //                       textScaleFactor: 1.2,
                          //                     ),
                          //                   ),
                          //                 ]),
                          //               ]),
                          //         ),
                          //       ),
                          //       SizedBox(height: 10),
                          //       Center(
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             RaisedButton(
                          //               onPressed: () async {
                          //                 await fetchInitiateRequest();
                          //                 var request = http.Request(
                          //                     'POST',
                          //                     Uri.parse(
                          //                         'https://gateway.cept.gov.in:443/cbs/requestJson'));
                          //                 request.files.add(
                          //                     await http.MultipartFile.fromPath('',
                          //                         '$cachepath/hvw_initiatereq.txt'));
                          //                 http.StreamedResponse response =
                          //                     await request.send();
                          //                 setState(() {
                          //                   _isLoading = false;
                          //                 });
                          //                 if (response.statusCode == 200) {
                          //                   String res =
                          //                       await response.stream.bytesToString();
                          //                   Map a = json.decode(res);
                          //                   print(a['JSONResponse']['jsonContent']);
                          //                   String data =
                          //                       a['JSONResponse']['jsonContent'];
                          //                   depositmain = json.decode(data);
                          //                   print(depositmain);
                          //                   if (depositmain['Status'] == "SUCCESS") {
                          //                     print(rec![4]);
                          //                     var currentDate = DateTimeDetails()
                          //                         .onlyDatewithFormat();
                          //                     var currentTime =
                          //                         DateTimeDetails().onlyTime();
                          //                     var balance =
                          //                         depositmain['48'].split('+')[2];
                          //                     balance = int.parse(balance) > 0
                          //                         ? (int.parse(balance) / 100)
                          //                             .toStringAsFixed(2)
                          //                             .toString()
                          //                         : "0.00";
                          //                     var TranID =
                          //                         depositmain['126'].split('_')[0];
                          //                     print(TranID);
                          //                     final tranDelete =
                          //                         await TBCBS_TRAN_DETAILS()
                          //                             .select()
                          //                             .TRANSACTION_ID
                          //                             .equals(TranID)
                          //                             .delete();
                          //                     final tranDetails = TBCBS_TRAN_DETAILS()
                          //                       ..TRANSACTION_ID = TranID
                          //                       ..TRANSACTION_AMT =
                          //                           amountTextController.text
                          //                       ..TRAN_DATE =
                          //                           DateTimeDetails().onlyDate()
                          //                       ..TRAN_TIME =
                          //                           DateTimeDetails().onlyTime()
                          //                       ..CUST_ACC_NUM = myController.text
                          //                       ..ACCOUNT_TYPE = rec![4]
                          //                       ..STATUS = depositmain['Status']
                          //                       ..REMARKS = "High Value Wdwl";
                          //                     tranDetails.save();
                          //                     cbsDetails = await TBCBS_TRAN_DETAILS()
                          //                         .select()
                          //                         .TRANSACTION_ID
                          //                         .equals(TranID)
                          //                         .toList();
                          //                     for (int i = 0;
                          //                         i < cbsDetails.length;
                          //                         i++) {
                          //                       print(cbsDetails[i].toMap());
                          //                     }
                          //                     Navigator.push(
                          //                         context,
                          //                         MaterialPageRoute(
                          //                             builder: (_) =>
                          //                                 HighCashWithdrawlAmount(
                          //                                     cbsDetails[0]
                          //                                         .TRANSACTION_ID,
                          //                                     amountTextController.text,
                          //                                     currentDate,
                          //                                     currentTime,
                          //                                     cbsDetails[0]
                          //                                         .CUST_ACC_NUM,
                          //                                     cbsDetails[0]
                          //                                         .ACCOUNT_TYPE,
                          //                                     cbsDetails[0].REMARKS,
                          //                                     balance)));
                          //                   }
                          //                 } else {
                          //                   UtilFs.showToast(
                          //                       response.reasonPhrase!, context);
                          //                    UtilFs.showToast("${await response.stream.bytesToString()}", context);
                          //                 }
                          //
                          //                 // showDialog(context: context, builder: (BuildContext context) {return AlertDialog(
                          //                 //     backgroundColor: Colors.white,
                          //                 //     shape: RoundedRectangleBorder(
                          //                 //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
                          //                 //     contentPadding: EdgeInsets.all(10.0),
                          //                 //     content: Stack(
                          //                 //       children: <Widget>[
                          //                 //         Positioned(
                          //                 //           top:-20.0,
                          //                 //           right:-30.0,
                          //                 //           child: Padding(
                          //                 //             padding: const EdgeInsets.only(top:10.0),
                          //                 //             child: Align(
                          //                 //               alignment:Alignment.topRight,
                          //                 //               child: FlatButton(
                          //                 //                 child: Container(
                          //                 //                   decoration: BoxDecoration(
                          //                 //                     color: Colors.grey[200],
                          //                 //                     borderRadius: BorderRadius.circular(12),
                          //                 //                   ),
                          //                 //                   child: Icon(
                          //                 //                     Icons.close,
                          //                 //                     color: Colors.red,
                          //                 //
                          //                 //                   ),
                          //                 //                 ),
                          //                 //
                          //                 //                 onPressed: (){
                          //                 //                   Navigator.pop(context);
                          //                 //                 },
                          //                 //               ),
                          //                 //             ),
                          //                 //           ),
                          //                 //         ),
                          //                 //         SizedBox(height: 20.0,),
                          //                 //         Container(
                          //                 //           width: MediaQuery.of(context).size.width*4.0,
                          //                 //           height: MediaQuery.of(context).size.height*0.24,
                          //                 //           child: Column(
                          //                 //             // mainAxisAlignment: MainAxisAlignment.center,
                          //                 //             // crossAxisAlignment: CrossAxisAlignment.stretch,
                          //                 //             //  mainAxisSize: MainAxisSize.min,
                          //                 //             children: <Widget>[
                          //                 //               Center(
                          //                 //                 child: Padding(
                          //                 //                   padding: const EdgeInsets.all(10.0),
                          //                 //                   child: new Text('The Withdrawal request is not approved', style:TextStyle(fontSize: 23.0,color: Colors.black)),
                          //                 //                 ),
                          //                 //               ),
                          //                 //             ],
                          //                 //           ),
                          //                 //         ),
                          //                 //       ],
                          //                 //     )
                          //                 // );});
                          //               },
                          //               child: Text('INITIATE WITHDRAWAL',
                          //                   style: TextStyle(fontSize: 16)),
                          //               color: Color(0xFFB71C1C),
                          //               textColor: Colors.white,
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(20),
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               width: 15,
                          //             ),
                          //             RaisedButton(
                          //               child: Text('CANCEL',
                          //                   style: TextStyle(fontSize: 16)),
                          //               color: Color(0xFFB71C1C),
                          //               textColor: Colors.white,
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(20),
                          //               ),
                          //               onPressed: () {
                          //                 // setState(() {
                          //                 //   _isVisible=true;
                          //                 // });
                          //                 Navigator.of(context).pop();
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ]),
                          //   ),
                          // ]),

                          _isAmount == true
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      style: ButtonStyle(
                                          // elevation:MaterialStateProperty.all(),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18.0),
                                                  side: BorderSide(
                                                      color: Colors.red)))),
                                      child: Text("New Request"),
                                      onPressed: () async {
                                        setState(() {
                                          finalwdl=false;
                                        });
                                           List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        encheader =
                                            await encryptfetchhvwenquiry();

                                        // var request = http.Request(
                                        //     'POST',
                                        //     Uri.parse(
                                        //         'https://rictapi.cept.gov.in:443/cbs/requestSign'));
                                        // request.files.add(await http.MultipartFile.fromPath(
                                        //     '',
                                        //     '$cachepath/highvalue_wdl.txt'));
                                        try {
                                          var headers = {
                                            'Signature': '$encheader',
                                            'Uri': 'requestSign',
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

                                          if (response.statusCode == 200) {
                                            var resheaders =
                                                await response.headers;
                                            print("Result Headers");
                                            print(resheaders);
                                            // List t = resheaders['authorization']!
                                            //     .split(", Signature:");
                                            String res = await response.stream
                                                .bytesToString();
String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
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
                                              main = json.decode(data);
                                              print("Values");
                                              print(main);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              if (main['successOrFailure'] ==
                                                  "SUCCESS") {
                                                if (main['status'].contains( "P") || main['status'].contains( "A")) {
                                                  UtilFsNav.showToast(
                                                      "Old Request is pending. Cannot raise New Request",
                                                      context,
                                                      HighValueWd(""));
                                                }
                                                // else {
                                                //   UtilFsNav.showToast(
                                                //       "Cannot raise more than one high value withdrawal request in a day",
                                                //       context,
                                                //       HighValueWd(""));
                                                // }
                                                else{
                                                  _isAmount=true;
                                                }
                                              } else {
                                                setState(() {
                                                  _isAmount = true;
                                                });
                                              }
                                            } else {
                                              UtilFsNav.showToast(
                                                  "Signature Verification Failed! Try Again",
                                                  context,
                                                  HighValueWd(""));
                                              await LogCat().writeContent(
                                                  'High value withdrawal page: Signature Verification Failed');
                                            }
                                          } else {
                                            UtilFsNav.showToast(
                                                "${response.reasonPhrase}\n${await response.stream.bytesToString()}",
                                                context,
                                                HighValueWd(""));
                                            // UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                          }

                                          // final tranDetails = TBCBS_EXCEP_DETAILS()
                                          //                      ..REQUEST_NUMBER=TranID
                                          //                      ..REQUEST_DATE=DateTimeDetails().onlyExpDate()
                                          //                      ..ACCOUNT_NUMBER=myController.text
                                          //                      ..REQUEST_STATUS='P'
                                          //                      ..OPERATOR_ID=login[0].EMPID;
                                          //                     tranDetails.save();
                                        } catch (_) {
                                          if (_.toString() == "TIMEOUT") {
                                            return UtilFsNav.showToast(
                                                "Request Timed Out",
                                                context,
                                                HighValueWd(""));
                                          }
                                        }
                                      },
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          // elevation:MaterialStateProperty.all(),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(18.0),
                                                  side: BorderSide(
                                                      color: Colors.red)))),
                                      child: Text("Enquiry"),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        encheader =
                                            await encryptfetchhvwenquiry();
                                        // var excwdl = await TBCBS_EXCEP_DETAILS()
                                        //     .select()
                                        //     .toList();

                                        // var request = http.Request(
                                        //     'POST',
                                        //     Uri.parse(
                                        //         'https://rictapi.cept.gov.in:443/cbs/requestSign'));
                                        // request.files.add(await http.MultipartFile.fromPath(
                                        //     '',
                                        //     '$cachepath/highvalue_wdl.txt'));
                                           List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                        try {
                                          var headers = {
                                            'Signature': '$encheader',
                                            'Uri': 'requestSign',
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

                                          if (response.statusCode == 200) {
                                            var resheaders =
                                                await response.headers;
                                            print("Result Headers");
                                            print(resheaders);
                                            // List t = resheaders['authorization']!
                                            //     .split(", Signature:");
                                            String res = await response.stream
                                                .bytesToString();
String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                            String val = await decryption1(
                                                decryptSignature, res);
                                            if (val == "Verified!") {
                                              await LogCat().writeContent(
                                                    '$res');
                                              print(res);
                                              print("\n\n");
                                              Map a = json.decode(res);
                                              print("Map a: $a");
                                              print(a['JSONResponse']
                                                  ['jsonContent']);
                                              String data = a['JSONResponse']
                                                  ['jsonContent'];
                                              mainWdl = json.decode(data);
                                              print("Values");
                                              print(mainWdl);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              if (mainWdl['successOrFailure'] ==
                                                  "SUCCESS") {
                                                print(mainWdl['status'].length);
                                                for(int i=0;i<mainWdl['status'].length;i++){
                                                  print(mainWdl['status'][i]);
                                                }
                                                if (mainWdl['status'] == 'X' || mainWdl['status'] == 'S') {
                                                  UtilFsNav.showToast(
                                                      "No Pending requests",
                                                      context,
                                                      HighValueWd(""));
                                                } else {
                                                  setState(() {
                                                    finalwdl = true;
                                                  });
                                                  // UtilFs.showToast("No Pending Requests",context);
                                                }
                                                // if(mainWdl['status']=='A') {
                                                //   setState(() {
                                                //     finalwdl = true;
                                                //   });
                                                // }
                                                // else if(mainWdl['status']=='P'){
                                                //   UtilFs.showToast("Request is still not approved", context);
                                                // }
                                                // else{
                                                //   UtilFs.showToast("Request is already approved and processed for withdrawal",context);
                                                // }
                                              }
                                              else {

                                                UtilFs.showToast("No Pending Requests",context);
                                              }
                                            } else {
                                              UtilFsNav.showToast(
                                                  "Signature Verification Failed! Try Again",
                                                  context,
                                                  HighValueWd(""));
                                              await LogCat().writeContent(
                                                  'High Value Withdrawal Enquiry: Signature Verification Failed.');
                                            }
                                          } else {
                                            // UtilFsNav.showToast(
                                            //     "${response.reasonPhrase}\n${await response.stream.bytesToString()}",
                                            //     context,
                                            //     HighValueWd(""));

                                            //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                            print(response.statusCode);
                                            List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                            if(response.statusCode==503 || response.statusCode==504){
                                              UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
                                            }
                                            else
                                              UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
                                            
                                            // UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                          }
                                        } catch (_) {
                                          if (_.toString() == "TIMEOUT") {
                                            return UtilFsNav.showToast(
                                                "Request Timed Out",
                                                context,
                                                HighValueWd(""));
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                        ])),
                    _isAmount == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: //Colors.white,
                                            Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: amountTextController,
                                    // autovalidateMode: AutovalidateMode.always,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter amount of Transaction';
                                      } else if (int.parse(value) < 20000) {
                                        return 'Amount Requested should be greater than \u{20B9} 20000';
                                      } else if (int.parse(value) >
                                          int.parse(displaybalance!)) {
                                        return 'Amount Requested should not be greater than \u{20B9} $mainbal';
                                      }
                                    },
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
                                      labelText: "Enter Amount",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                    child: Text("Create New Request"),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();

                                      if (_formKey.currentState!.validate()) {

                                        setState(() {
                                          _isLoading = true;
                                        });
                                        var login = await USERDETAILS()
                                            .select()
                                            .toList();
                                        // UtilFs.showToast("${main['message']}",context);
                                        final tranDetails =
                                        TBCBS_EXCEP_DETAILS()
                                          ..REQUEST_NUMBER = TranID
                                          ..REQUEST_DATE =
                                          DateTimeDetails()
                                              .onlyExpDate()
                                          ..ACCOUNT_NUMBER =
                                              myController.text
                                          ..REQUEST_STATUS = 'P'
                                          ..OPERATOR_ID =
                                              login[0].EMPID;
                                       await tranDetails.save();
                                        encheader = await encryptnewhvwrequest();
                                           List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                        // var request = http.Request(
                                        //     'POST',
                                        //     Uri.parse(
                                        //         'https://gateway.cept.gov.in:443/cbs/requestSign'));
                                        // request.files.add(await http.MultipartFile.fromPath(
                                        //     '',
                                        //     '$cachepath/hvw_CreateNewRequest.txt'));

                                        try {
                                          var headers = {
                                            'Signature': '$encheader',
                                            'Uri': 'requestSign',
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
                                          if (response.statusCode == 200) {
                                            // print(await response.stream.bytesToString());
                                            var resheaders =
                                                await response.headers;
                                            print("Result Headers");
                                            print(resheaders);
                                            // List t = resheaders['authorization']!
                                            //     .split(", Signature:");
                                            String res = await response.stream
                                                .bytesToString();
String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                            String val = await decryption1(
                                                decryptSignature, res);
                                            if (val == "Verified!") {
                                              await LogCat().writeContent(
                                                    '$res');
                                              print(res);
                                              print("\n\n");
                                              Map a = json.decode(res);
                                              print("Map a: $a");
                                              print(a['JSONResponse']
                                                  ['jsonContent']);
                                              String data = a['JSONResponse']
                                                  ['jsonContent'];

                                              Map cmain = json.decode(data);
                                              // cmain= {"Status":"SUCCESS","successOrFailure":"SUCCESS","message":"REQUEST CREATED SUCCESSFULLY","DateTime":"20220729014629"};
                                              print("Values");
                                              print(cmain);
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              if (cmain['successOrFailure'] ==
                                                  "SUCCESS") {

                                                setState(() {
                                                  _isCreated = true;
                                                });
                                              } else {
                                                UtilFsNav.showToast(
                                                    "Request Failed. Please Retry",
                                                    context,
                                                    HighValueWd(""));
                                              }
                                            } else {
                                              UtilFsNav.showToast(
                                                  "Signature Verification Failed! Try Again",
                                                  context,
                                                  HighValueWd(""));
                                              await LogCat().writeContent(
                                                  'New HVW request creation: Signature Verification Failed.');
                                            }
                                          } else {
                                            // UtilFsNav.showToast(
                                            //     "${await response.stream.bytesToString()}",
                                            //     context,
                                            //     HighValueWd(""));

                                            //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                            print(response.statusCode);
                                            List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                            if(response.statusCode==503 || response.statusCode==504){
                                              UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
                                            }
                                            else
                                              UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
                                            
                                          }
                                        } catch (_) {
                                          if (_.toString() == "TIMEOUT") {
                                            return UtilFsNav.showToast(
                                                "Request Timed Out",
                                                context,
                                                HighValueWd(""));
                                          }
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    _isCreated == true
                        ? Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('REQUEST CREATED SUCCESSFULLY'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Table(
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(children: [
                                        Column(
                                          children: [
                                            Text('Account Number'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('${myController.text}'),
                                          ],
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                          children: [
                                            Text('Request ID'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('$TranID'),
                                          ],
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                          children: [
                                            Text('Amount'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('${amountTextController.text}'),
                                          ],
                                        ),
                                      ]),
                                      TableRow(children: [
                                        Column(
                                          children: [
                                            Text('Transaction Status'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Pending'),
                                          ],
                                        )
                                      ]),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
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
                                        child: Text("PRINT"),
                                        onPressed: () async {
                                          //Added By rakesh on 18112022
                                          List<String> basicInformation = <String>[];
                                          List<String> Dummy = <String>[];
                                          //List<OfficeDetail> office=await OfficeDetail().select().toList();
                                          final ofcMaster =
                                          await OFCMASTERDATA().select().toList();
                                          final soltb =
                                          await TBCBS_SOL_DETAILS().select().toList();
                                          basicInformation.add('CSI BO ID');
                                          basicInformation
                                              .add(ofcMaster[0].BOFacilityID.toString());
                                          basicInformation.add('CSI BO Descriprtion');
                                          basicInformation.add(ofcMaster[0].BOName.toString());
                                          basicInformation.add('Receipt Date & Time');
                                          basicInformation
                                              .add(DateTimeDetails().onlyExpDateTime());
                                          basicInformation.add('SOL ID');
                                          basicInformation.add(soltb[0].SOL_ID.toString());
                                          basicInformation.add('SOL Description');
                                          basicInformation.add(ofcMaster[0].AOName.toString());
                                          basicInformation.add("----------------");
                                          basicInformation.add("----------------");
                                          basicInformation.add('Account Number:');
                                          basicInformation
                                              .add('${myController.text}'.toString());

                                          basicInformation.add('Request ID:');
                                          basicInformation.add('$TranID'.toString());
                                          basicInformation.add('Amount:');
                                          basicInformation.add('${amountTextController.text}'.toString());
                                          basicInformation.add('Transaction Status:');
                                          basicInformation.add("Pending");
                                          Dummy.clear();
                                          PrintingTelPO printer = new PrintingTelPO();
                                          bool value = await printer.printThroughUsbPrinter(
                                              "CBS",
                                              "High Value Cash Withdrawal Request",
                                              basicInformation,
                                              basicInformation,
                                              1);

                                        },
                                      ),
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
                                        child: Text("Back"),
                                        onPressed: () async {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainHomeScreen(
                                                          MyCardsScreen(false),
                                                          1)),
                                              (route) => false);
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    finalwdl == true
                        ?
                   mainWdl['status'].length>1? Container(

                            child:
                            Column(
                              children: [

                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Pending Requests'),
                                      ),
                                      for(int i=0;i<mainWdl['status'].length;i++)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Table(                                          border: TableBorder.all(),

                                          children: [
                                            TableRow(children: [
                                              Column(
                                                children: [
                                                  Text('Account Number'),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('${mainWdl['acctNum'][i].toString()}'),
                                                ],
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Column(
                                                children: [
                                                  Text('Request ID'),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('${mainWdl['blockID'][i].toString()}'),
                                                ],
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Column(
                                                children: [
                                                  Text('Amount'),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('${mainWdl['amount'][i].toString()}'),
                                                ],
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Column(
                                                children: [
                                                  Text('Transaction Status'),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  if(mainWdl['status'][i]=="X")
                                                  Text('Transaction is Cancelled')
                                                    else if(mainWdl['status'][i]=="S")
                                                      Text("Transaction is Successful")
                                                  // else if(mainWdl['status'][i]=="A")
                                                  //   Text("Transaction is Approved")
                                                  else if(mainWdl['status'][i]=="P")
                                                  Text("Transaction is Pending")
                                                ],
                                              )
                                            ]),
                                           if(mainWdl['status'][i]=="P" || mainWdl['status'][i]=="A" )
                                            TableRow(
                                                children: [
                                                    Column(
                                                        children:[
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              // elevation:MaterialStateProperty.all(),
                                                                shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(18.0),
                                                                        side: BorderSide(
                                                                            color: Colors.red)))),
                                                            child: Text("Initiate Transaction"),
                                                            onPressed: () async {
                                                              var walletAmount =
                                                              await CashService().cashBalance();
                                                              if (mainWdl['status'][i] == 'A') {
                                                                if(walletAmount >= int.parse(mainWdl['amount'][i])) {
                                                                  setState(() {
                                                                    _isLoading =
                                                                    true;
                                                                  });
                                                                  tid =
                                                                      GenerateRandomString()
                                                                          .randomString();
                                                                  var login = await USERDETAILS()
                                                                      .select()
                                                                      .toList();
                                                                  await TBCBS_TRAN_DETAILS(
                                                                      DEVICE_TRAN_ID: tid,
                                                                      TRANSACTION_ID: tid,
                                                                      ACCOUNT_TYPE: 'SBGEN',
                                                                      OPERATOR_ID:
                                                                      '${login[0]
                                                                          .EMPID}',
                                                                      CUST_ACC_NUM: myController
                                                                          .text
                                                                          .toString(),
                                                                      TRANSACTION_AMT:
                                                                      mainWdl['amount'][i]
                                                                          .toString(),
                                                                      TRAN_DATE:
                                                                      '${DateTimeDetails()
                                                                          .onlyExpDate()}',
                                                                      TRAN_TIME:
                                                                      '${DateTimeDetails()
                                                                          .onlyTime()}',
                                                                      TRAN_TYPE: 'W',
                                                                      DEVICE_TRAN_TYPE: 'HVW',
                                                                      CURRENCY: 'INR',
                                                                      MODE_OF_TRAN: 'Cash',
                                                                      FIN_SOLBOD_DATE:
                                                                      DateTimeDetails()
                                                                          .onlyDate(),
                                                                      TENURE: '0',
                                                                      INSTALMENT_AMT: '0',
                                                                      NO_OF_INSTALMENTS: '0',
                                                                      REBATE_AMT: '0',
                                                                      DEFAULT_FEE: '0',
                                                                      STATUS: 'PENDING',
                                                                      MAIN_HOLDER_NAME: '$achname',
                                                                      SCHEME_TYPE: 'SBGEN')
                                                                      .upsert();

                                                                  encheader =
                                                                  await encryptfinalhvwdl(
                                                                      mainWdl['amount'][i],
                                                                      mainWdl['blockID'][i]);

                                                                  // var request = http.Request('POST',
                                                                  //     Uri.parse(
                                                                  //         'https://rictapi.cept.gov.in:443/cbs/requestJson'));
                                                                  // request.files.add(
                                                                  //     await http.MultipartFile.fromPath('',
                                                                  //         '$cachepath/highvalue_wdl.txt'));
                                                                  List<
                                                                      USERLOGINDETAILS> acctoken =
                                                                  await USERLOGINDETAILS()
                                                                      .select()
                                                                      .Active
                                                                      .equals(
                                                                      true)
                                                                      .toList();
                                                                  try {
                                                                    var headers = {
                                                                      'Signature': '$encheader',
                                                                      'Uri': 'requestJson',
                                                                      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                      'Authorization':
                                                                      'Bearer ${acctoken[0]
                                                                          .AccessToken}',
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

                                                                    http
                                                                        .StreamedResponse response =
                                                                    await request
                                                                        .send()
                                                                        .timeout(
                                                                        const Duration(
                                                                            seconds: 65),
                                                                        onTimeout: () {
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
                                                                      var resheaders =
                                                                      await response
                                                                          .headers;
                                                                      print(
                                                                          "Result Headers");
                                                                      print(
                                                                          resheaders);
                                                                      List t =
                                                                      resheaders['authorization']!
                                                                          .split(
                                                                          ", Signature:");
                                                                      String res = await response
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
                                                                        print(
                                                                            res);
                                                                        print(
                                                                            "\n\n");
                                                                        Map a = json
                                                                            .decode(
                                                                            res);
                                                                        print(
                                                                            "Map a: $a");
                                                                        print(
                                                                            a['JSONResponse']
                                                                            ['jsonContent']);
                                                                        String data = a['JSONResponse']
                                                                        ['jsonContent'];
                                                                        Map finalMain = json
                                                                            .decode(
                                                                            data);
                                                                        print(
                                                                            "Values");
                                                                        print(
                                                                            finalMain);
                                                                        if (finalMain['39'] ==
                                                                            "000") {
                                                                          var TranID1 = finalMain['126']
                                                                              .split(
                                                                              '_')[0]
                                                                              .toString()
                                                                              .trim();
                                                                          await TBCBS_TRAN_DETAILS()
                                                                              .select()
                                                                              .DEVICE_TRAN_ID
                                                                              .equals(
                                                                              tid)
                                                                              .update(
                                                                              {
                                                                                'TRANSACTION_ID': '$TranID1',
                                                                                'STATUS': 'SUCCESS'
                                                                              });
                                                                          await TBCBS_EXCEP_DETAILS()
                                                                              .select()
                                                                              .ACCOUNT_NUMBER
                                                                              .equals(
                                                                              myController
                                                                                  .text)
                                                                              .update(
                                                                              {
                                                                                'REQUEST_STATUS': 'S'
                                                                              });
                                                                          var temp = await TBCBS_TRAN_DETAILS()
                                                                              .select()
                                                                              .DEVICE_TRAN_ID
                                                                              .equals(
                                                                              tid)
                                                                              .toList();
                                                                          final addCash =  CashTable()
                                                                            ..Cash_ID = myController
                                                                                .text
                                                                            ..Cash_Date = DateTimeDetails()
                                                                                .currentDate()
                                                                            ..Cash_Time = DateTimeDetails()
                                                                                .onlyTime()
                                                                            ..Cash_Type = 'Add'
                                                                            ..Cash_Amount = double
                                                                                .parse(
                                                                                "-${temp[0]
                                                                                    .TRANSACTION_AMT!}")
                                                                            ..Cash_Description = "HVW Withdrawal";
                                                                          addCash
                                                                              .save();
                                                                          final addTransaction = TransactionTable()
                                                                            ..tranid = 'CBS${DateTimeDetails()
                                                                                .filetimeformat()}'
                                                                            ..tranDescription = "HVW Withdrawal"
                                                                            ..tranAmount = double
                                                                                .parse(
                                                                                "-${temp[0]
                                                                                    .TRANSACTION_AMT!}")
                                                                            ..tranType = "CBS"
                                                                            ..tranDate = DateTimeDetails()
                                                                                .currentDate()
                                                                            ..tranTime = DateTimeDetails()
                                                                                .onlyTime()
                                                                            ..valuation = "Add";

                                                                          addTransaction
                                                                              .save();
                                                                          setState(() {
                                                                            _isLoading =
                                                                            false;
                                                                          });
                                                                          final transsucess =
                                                                          await TBCBS_TRAN_DETAILS()
                                                                              .select()
                                                                              .DEVICE_TRAN_ID
                                                                              .equals(
                                                                              tid)
                                                                              .toList();
                                                                          return showDialog(
                                                                              context: context,
                                                                              builder:
                                                                                  (
                                                                                  BuildContext context) {
                                                                                return Dialog(
                                                                                  shape:
                                                                                  RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        20),
                                                                                  ),
                                                                                  elevation: 0,
                                                                                  backgroundColor:
                                                                                  Colors
                                                                                      .white,
                                                                                  child: Stack(
                                                                                    children: [
                                                                                      Container(
                                                                                        child: Padding(
                                                                                          padding:
                                                                                          const EdgeInsets
                                                                                              .all(
                                                                                              8.0),
                                                                                          child: Column(
                                                                                              crossAxisAlignment:
                                                                                              CrossAxisAlignment
                                                                                                  .start,
                                                                                              mainAxisSize:
                                                                                              MainAxisSize
                                                                                                  .min,
                                                                                              children: [
                                                                                                Table(
                                                                                                  border:
                                                                                                  TableBorder
                                                                                                      .all(),
                                                                                                  children: [
                                                                                                    TableRow(
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  'Account Number'),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  '${transsucess[0]
                                                                                                                      .CUST_ACC_NUM}'),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ]),
                                                                                                    TableRow(
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  'Transaction ID'),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  '${transsucess[0]
                                                                                                                      .TRANSACTION_ID}'),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ]),
                                                                                                    TableRow(
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  'Amount'),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  '${transsucess[0]
                                                                                                                      .TRANSACTION_AMT}'),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ]),
                                                                                                    TableRow(
                                                                                                        children: [
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  'Transaction Status'),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Column(
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                  'Approved'),
                                                                                                            ],
                                                                                                          )
                                                                                                        ]),
                                                                                                  ],
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment
                                                                                                      .spaceEvenly,
                                                                                                  children: [
                                                                                                    TextButton(
                                                                                                      style: ButtonStyle(
                                                                                                        // elevation:MaterialStateProperty.all(),
                                                                                                          shape: MaterialStateProperty
                                                                                                              .all<
                                                                                                              RoundedRectangleBorder>(
                                                                                                              RoundedRectangleBorder(
                                                                                                                  borderRadius: BorderRadius
                                                                                                                      .circular(
                                                                                                                      18.0),
                                                                                                                  side: BorderSide(
                                                                                                                      color: Colors
                                                                                                                          .grey)))),
                                                                                                      child: Text(
                                                                                                          'PRINT',
                                                                                                          style: TextStyle(
                                                                                                              fontSize: 16)),
                                                                                                      onPressed:
                                                                                                          () async {
                                                                                                        //Added By rakesh on 18112022
                                                                                                        List<
                                                                                                            String> basicInformation = <
                                                                                                            String>[
                                                                                                        ];
                                                                                                        List<
                                                                                                            String> Dummy = <
                                                                                                            String>[
                                                                                                        ];
                                                                                                        //List<OfficeDetail> office=await OfficeDetail().select().toList();
                                                                                                        final ofcMaster =
                                                                                                        await OFCMASTERDATA()
                                                                                                            .select()
                                                                                                            .toList();
                                                                                                        final soltb =
                                                                                                        await TBCBS_SOL_DETAILS()
                                                                                                            .select()
                                                                                                            .toList();
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'CSI BO ID');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            ofcMaster[0]
                                                                                                                .BOFacilityID
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'CSI BO Descriprtion');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            ofcMaster[0]
                                                                                                                .BOName
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'Receipt Date & Time');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            DateTimeDetails()
                                                                                                                .onlyExpDateTime());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'SOL ID');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            soltb[0]
                                                                                                                .SOL_ID
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'SOL Description');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            ofcMaster[0]
                                                                                                                .AOName
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            "----------------");
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            "----------------");
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'Account Number:');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            '${transsucess[0]
                                                                                                                .CUST_ACC_NUM}'
                                                                                                                .toString());

                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'Transaction ID:');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            '${transsucess[0]
                                                                                                                .TRANSACTION_ID}'
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'Amount:');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            '${transsucess[0]
                                                                                                                .TRANSACTION_AMT}'
                                                                                                                .toString());
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            'Transaction Status:');
                                                                                                        basicInformation
                                                                                                            .add(
                                                                                                            "Approved");
                                                                                                        Dummy
                                                                                                            .clear();
                                                                                                        PrintingTelPO printer = new PrintingTelPO();
                                                                                                        bool value = await printer
                                                                                                            .printThroughUsbPrinter(
                                                                                                            "CBS",
                                                                                                            "High Value Cash Withdrawal Details",
                                                                                                            basicInformation,
                                                                                                            basicInformation,
                                                                                                            1);
                                                                                                      },
                                                                                                    ),
                                                                                                    TextButton(
                                                                                                      child:
                                                                                                      Text(
                                                                                                          "Back"),
                                                                                                      style: ButtonStyle(
                                                                                                        // elevation:MaterialStateProperty.all(),
                                                                                                          shape: MaterialStateProperty
                                                                                                              .all<
                                                                                                              RoundedRectangleBorder>(
                                                                                                              RoundedRectangleBorder(
                                                                                                                  borderRadius: BorderRadius
                                                                                                                      .circular(
                                                                                                                      18.0),
                                                                                                                  side: BorderSide(
                                                                                                                      color: Colors
                                                                                                                          .red)))),
                                                                                                      onPressed:
                                                                                                          () {
                                                                                                        Navigator
                                                                                                            .pushAndRemoveUntil(
                                                                                                            context,
                                                                                                            MaterialPageRoute(
                                                                                                                builder: (
                                                                                                                    context) =>
                                                                                                                    MainHomeScreen(
                                                                                                                        MyCardsScreen(
                                                                                                                            false),
                                                                                                                        1)), (
                                                                                                            route) => false);
                                                                                                      },
                                                                                                    ),
                                                                                                  ],
                                                                                                )
                                                                                              ]),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              });
                                                                        }
                                                                        else {
                                                                          setState(() {
                                                                            _isLoading =
                                                                            false;
                                                                          });
                                                                          await TBCBS_TRAN_DETAILS()
                                                                              .select()
                                                                              .DEVICE_TRAN_ID
                                                                              .equals(
                                                                              tid)
                                                                              .update(
                                                                              {
                                                                                'STATUS': 'FAILED'
                                                                              });

                                                                          UtilFsNav
                                                                              .showToast(
                                                                              "${finalMain['127']}",
                                                                              context,
                                                                              HighValueWd(
                                                                                  ""));
                                                                        }
                                                                      } else {
                                                                        UtilFsNav
                                                                            .showToast(
                                                                            "Signature Verification Failed! Try Again",
                                                                            context,
                                                                            HighValueWd(
                                                                                ""));
                                                                        await LogCat()
                                                                            .writeContent(
                                                                            '${DateTimeDetails()
                                                                                .currentDateTime()} :High value final withdrawal: Signature Verification Failed.\n\n');
                                                                      }
                                                                    } else {
                                                                      // UtilFsNav.showToast(
                                                                      //     '${response.reasonPhrase}',
                                                                      //     context,
                                                                      //     HighValueWd(""));
                                                                      await TBCBS_TRAN_DETAILS()
                                                                          .select()
                                                                          .DEVICE_TRAN_ID
                                                                          .equals(
                                                                          tid)
                                                                          .update(
                                                                          {
                                                                            'STATUS': 'FAILED'
                                                                          });

                                                                      // UtilFsNav.showToast(
                                                                      //     "${await response.stream.bytesToString()}",
                                                                      //     context,
                                                                      //     HighValueWd(""));

                                                                      //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                                                      print(
                                                                          response
                                                                              .statusCode);
                                                                      List<
                                                                          API_Error_code> error = await API_Error_code()
                                                                          .select()
                                                                          .API_Err_code
                                                                          .equals(
                                                                          response
                                                                              .statusCode)
                                                                          .toList();
                                                                      if (response
                                                                          .statusCode ==
                                                                          503 ||
                                                                          response
                                                                              .statusCode ==
                                                                              504) {
                                                                        UtilFsNav
                                                                            .showToast(
                                                                            "CBS " +
                                                                                error[0]
                                                                                    .Description
                                                                                    .toString(),
                                                                            context,
                                                                            HighValueWd(
                                                                                ""));
                                                                      }
                                                                      else
                                                                        UtilFsNav
                                                                            .showToast(
                                                                            error[0]
                                                                                .Description
                                                                                .toString(),
                                                                            context,
                                                                            HighValueWd(
                                                                                ""));
                                                                    }
                                                                  } catch (_) {
                                                                    if (_
                                                                        .toString() ==
                                                                        "TIMEOUT") {
                                                                      return UtilFsNav
                                                                          .showToast(
                                                                          "Request Timed Out",
                                                                          context,
                                                                          HighValueWd(
                                                                              ""));
                                                                    }
                                                                  }
                                                                }
                                                                else {
                                                                  UtilFsNav.showToast(
                                                                      "Wallet Balance is less than Amount of Transaction",
                                                                      context,
                                                                      HighValueWd(""));
                                                                }
                                                              }
                                                              else {
                                                                UtilFsNav.showToast(
                                                                    "Request approval is pending",
                                                                    context,
                                                                    HighValueWd(""));
                                                              }
                                                            },
                                                          ),
                                                        ]
                                                    ),
                                                      Column(
                                                          children:[
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
                                                                child: Text("Cancel Transaction"),
                                                                onPressed: () async {
                                                                  encheader = await encryptcancelhvwdl(mainWdl['blockID'][i]);
                                                                  List<USERLOGINDETAILS> acctoken =
                                                                  await USERLOGINDETAILS().select().Active.equals(true).toList();
                                                                  // var request = http.Request('POST', Uri.parse('https://rictapi.cept.gov.in:443/cbs/requestSign'));
                                                                  // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/highvalue_wdl.txt'));
                                                                  try {
                                                                    var headers = {
                                                                      'Signature': '$encheader',
                                                                      'Uri': 'requestSign',
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

                                                                    if (response.statusCode == 200) {
                                                                      // print(await response.stream.bytesToString());
                                                                      var resheaders =
                                                                      await response.headers;
                                                                      print("Result Headers");
                                                                      print(resheaders);
                                                                      // List t =
                                                                      // resheaders['authorization']!
                                                                      //     .split(", Signature:");
                                                                      String res = await response.stream
                                                                          .bytesToString();
                                                                      String temp = resheaders['authorization']!;
                                                                      String decryptSignature = temp;

                                                                      String val = await decryption1(
                                                                          decryptSignature, res);
                                                                      if (val == "Verified!") {
                                                                        await LogCat().writeContent(
                                                    '$res');
                                                                        Map a = json.decode(res);
                                                                        String data = a['JSONResponse']
                                                                        ['jsonContent'];
                                                                        Map cancmain = json.decode(data);
                                                                        if (cancmain[
                                                                        'successOrFailure'] ==
                                                                            "SUCCESS") {
                                                                          await TBCBS_TRAN_DETAILS()
                                                                              .select()
                                                                              .DEVICE_TRAN_ID
                                                                              .equals(mainWdl['blockID'])
                                                                              .update({
                                                                            'STATUS': 'Cancelled'
                                                                          });
                                                                          await TBCBS_EXCEP_DETAILS()
                                                                              .select()
                                                                              .ACCOUNT_NUMBER
                                                                              .equals(myController.text)
                                                                              .update({
                                                                            'REQUEST_STATUS': 'X'
                                                                          });
                                                                          UtilFsNav.showToast(
                                                                              "${cancmain['message']}",
                                                                              context,
                                                                              HighValueWd(""));
                                                                          // Navigator.pushAndRemoveUntil(
                                                                          // context,
                                                                          // MaterialPageRoute(
                                                                          // builder: (context) => HighValueWd("")),
                                                                          // (route) => false);
                                                                        }
                                                                      } else {
                                                                        UtilFsNav.showToast(
                                                                            "Signature Verification Failed! Try Again",
                                                                            context,
                                                                            HighValueWd(""));
                                                                        await LogCat().writeContent(
                                                                            'High value withdrawal Cancel: Signature Verification Failed.');
                                                                      }
                                                                    } else {
                                                                      // UtilFsNav.showToast(
                                                                      //     "${await response.stream.bytesToString()}",
                                                                      //     context,
                                                                      //     HighValueWd(""));

                                                                      //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                                                      print(response.statusCode);
                                                                      List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                                      if(response.statusCode==503 || response.statusCode==504){
                                                                        UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
                                                                      }
                                                                      else
                                                                        UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
                                                                    }
                                                                  } catch (_) {
                                                                    if (_.toString() == "TIMEOUT") {
                                                                      return UtilFsNav.showToast(
                                                                          "Request Timed Out",
                                                                          context,
                                                                          HighValueWd(""));
                                                                    }
                                                                  }
                                                                })
                                                          ]
                                                      )
                                                ]
                                            )
                                            else
                                              TableRow(
                                                  children:[
                                                    Column(
                                                        children:[
                                                          Text("")
                                                        ]
                                                    ),
                                                    Column(
                                                        children:[
                                                          Text("")
                                                        ]
                                                    )
                                                  ]
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ):Container(
                     child: Column(
                       children: [
                         Container(
                           child: Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text('Pending Requests'),
                               ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Table(
                                   border: TableBorder.all(),
                                   children: [
                                     TableRow(children: [
                                       Column(
                                         children: [
                                           Text('Account Number'),
                                         ],
                                       ),
                                       Column(
                                         children: [
                                           Text('${mainWdl['acctNum']}'),
                                         ],
                                       ),
                                     ]),
                                     TableRow(children: [
                                       Column(
                                         children: [
                                           Text('Request ID'),
                                         ],
                                       ),
                                       Column(
                                         children: [
                                           Text('${mainWdl['blockID']}'),
                                         ],
                                       ),
                                     ]),
                                     TableRow(children: [
                                       Column(
                                         children: [
                                           Text('Amount'),
                                         ],
                                       ),
                                       Column(
                                         children: [
                                           Text('${mainWdl['amount']}'),
                                         ],
                                       ),
                                     ]),
                                     TableRow(children: [
                                       Column(
                                         children: [
                                           Text('Transaction Status'),
                                         ],
                                       ),
                                       Column(
                                         children: [
                                           Text('${mainWdl['status']}'),
                                         ],
                                       )
                                     ]),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         ),
                         Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceEvenly,
                           children: [
                             TextButton(
                               style: ButtonStyle(
                                 // elevation:MaterialStateProperty.all(),
                                   shape: MaterialStateProperty.all<
                                       RoundedRectangleBorder>(
                                       RoundedRectangleBorder(
                                           borderRadius:
                                           BorderRadius.circular(18.0),
                                           side: BorderSide(
                                               color: Colors.red)))),
                               child: Text("Initiate Transaction"),
                               onPressed: () async {
                                 if (mainWdl['status'] == 'A') {
                                   setState(() {
                                     _isLoading = true;
                                   });
                                   tid = GenerateRandomString().randomString();
                                   var login = await USERDETAILS()
                                       .select()
                                       .toList();
                                   await TBCBS_TRAN_DETAILS(
                                       DEVICE_TRAN_ID: tid,
                                       TRANSACTION_ID: tid,
                                       ACCOUNT_TYPE: 'SBGEN',
                                       OPERATOR_ID:
                                       '${login[0].EMPID}',
                                       CUST_ACC_NUM: myController.text
                                           .toString(),
                                       TRANSACTION_AMT:
                                       mainWdl['amount'].toString(),
                                       TRAN_DATE:
                                       '${DateTimeDetails().onlyExpDate()}',
                                       TRAN_TIME:
                                       '${DateTimeDetails().onlyTime()}',
                                       TRAN_TYPE: 'W',
                                       DEVICE_TRAN_TYPE: 'HVW',
                                       CURRENCY: 'INR',
                                       MODE_OF_TRAN: 'Cash',
                                       FIN_SOLBOD_DATE:
                                       DateTimeDetails()
                                           .onlyDate(),
                                       TENURE: '0',
                                       INSTALMENT_AMT: '0',
                                       NO_OF_INSTALMENTS: '0',
                                       REBATE_AMT: '0',
                                       DEFAULT_FEE: '0',
                                       STATUS: 'PENDING',
                                       MAIN_HOLDER_NAME: '$achname',
                                       SCHEME_TYPE: 'SBGEN')
                                       .upsert();

                                   encheader = await encryptfinalhvwdl1();

                                   // var request = http.Request('POST',
                                   //     Uri.parse(
                                   //         'https://rictapi.cept.gov.in:443/cbs/requestJson'));
                                   // request.files.add(
                                   //     await http.MultipartFile.fromPath('',
                                   //         '$cachepath/highvalue_wdl.txt'));
                                   List<USERLOGINDETAILS> acctoken =
                                   await USERLOGINDETAILS().select().Active.equals(true).toList();
                                   try {
                                     var headers = {
                                       'Signature': '$encheader',
                                       'Uri': 'requestJson',
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

                                     if (response.statusCode == 200) {
                                       var resheaders =
                                       await response.headers;
                                       print("Result Headers");
                                       print(resheaders);
                                       // List t =
                                       // resheaders['authorization']!
                                       //     .split(", Signature:");
                                       String res = await response.stream
                                           .bytesToString();
                                       String temp = resheaders['authorization']!;
                                       String decryptSignature = temp;

                                       String val = await decryption1(
                                           decryptSignature, res);
                                       if (val == "Verified!") {
                                         await LogCat().writeContent(
                                                    '$res');
                                         print(res);
                                         print("\n\n");
                                         Map a = json.decode(res);
                                         print("Map a: $a");
                                         print(a['JSONResponse']
                                         ['jsonContent']);
                                         String data = a['JSONResponse']
                                         ['jsonContent'];
                                         Map finalMain = json.decode(data);
                                         print("Values");
                                         print(finalMain);
                                         if (finalMain['39'] == "000") {

                                           var TranID1 = finalMain['126']
                                               .split('_')[0]
                                               .toString()
                                               .trim();
                                           await TBCBS_TRAN_DETAILS()
                                               .select()
                                               .DEVICE_TRAN_ID
                                               .equals(tid)
                                               .update({
                                             'TRANSACTION_ID': '$TranID1',
                                             'STATUS': 'SUCCESS'
                                           });
                                           var temp=await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).toList();
                                           final addCash =  CashTable()
                                             ..Cash_ID = myController.text
                                             ..Cash_Date = DateTimeDetails().currentDate()
                                             ..Cash_Time = DateTimeDetails().onlyTime()
                                             ..Cash_Type = 'Add'
                                             ..Cash_Amount = double.parse("-${temp[0].TRANSACTION_AMT!}")
                                             ..Cash_Description = "HVW Withdrawal";
                                           await addCash.save();
                                           final addTransaction = TransactionTable()
                                             ..tranid = 'CBS${DateTimeDetails().filetimeformat()}'
                                             ..tranDescription = "HVW Withdrawal"
                                             ..tranAmount = double.parse("-${temp[0].TRANSACTION_AMT!}")
                                             ..tranType = "CBS"
                                             ..tranDate = DateTimeDetails().currentDate()
                                             ..tranTime = DateTimeDetails().onlyTime()
                                             ..valuation = "Add";

                                           await addTransaction.save();
                                           setState(() {
                                             _isLoading=false;
                                           });
                                           final transsucess =
                                           await TBCBS_TRAN_DETAILS()
                                               .select()
                                               .DEVICE_TRAN_ID
                                               .equals(tid)
                                               .toList();
                                           return showDialog(
                                               context: context,
                                               builder:
                                                   (BuildContext context) {
                                                 return Dialog(
                                                   shape:
                                                   RoundedRectangleBorder(
                                                     borderRadius:
                                                     BorderRadius
                                                         .circular(
                                                         20),
                                                   ),
                                                   elevation: 0,
                                                   backgroundColor:
                                                   Colors.white,
                                                   child: Stack(
                                                     children: [
                                                       Container(
                                                         child: Padding(
                                                           padding:
                                                           const EdgeInsets
                                                               .all(
                                                               8.0),
                                                           child: Column(
                                                               crossAxisAlignment:
                                                               CrossAxisAlignment
                                                                   .start,
                                                               mainAxisSize:
                                                               MainAxisSize
                                                                   .min,
                                                               children: [
                                                                 Table(
                                                                   border:
                                                                   TableBorder.all(),
                                                                   children: [
                                                                     TableRow(
                                                                         children: [
                                                                           Column(
                                                                             children: [
                                                                               Text('Account Number'),
                                                                             ],
                                                                           ),
                                                                           Column(
                                                                             children: [
                                                                               Text('${transsucess[0].CUST_ACC_NUM}'),
                                                                             ],
                                                                           ),
                                                                         ]),
                                                                     TableRow(
                                                                         children: [
                                                                           Column(
                                                                             children: [
                                                                               Text('Transaction ID'),
                                                                             ],
                                                                           ),
                                                                           Column(
                                                                             children: [
                                                                               Text('${transsucess[0].TRANSACTION_ID}'),
                                                                             ],
                                                                           ),
                                                                         ]),
                                                                     TableRow(
                                                                         children: [
                                                                           Column(
                                                                             children: [
                                                                               Text('Amount'),
                                                                             ],
                                                                           ),
                                                                           Column(
                                                                             children: [
                                                                               Text('${transsucess[0].TRANSACTION_AMT}'),
                                                                             ],
                                                                           ),
                                                                         ]),
                                                                     TableRow(
                                                                         children: [
                                                                           Column(
                                                                             children: [
                                                                               Text('Transaction Status'),
                                                                             ],
                                                                           ),
                                                                           Column(
                                                                             children: [
                                                                               Text('Approved'),
                                                                             ],
                                                                           )
                                                                         ]),
                                                                   ],
                                                                 ),
                                                                 Row(
                                                                   mainAxisAlignment:
                                                                   MainAxisAlignment.spaceEvenly,
                                                                   children: [
                                                                     TextButton(
                                                                       style: ButtonStyle(
                                                                         // elevation:MaterialStateProperty.all(),
                                                                           shape: MaterialStateProperty.all<
                                                                               RoundedRectangleBorder>(
                                                                               RoundedRectangleBorder(
                                                                                   borderRadius: BorderRadius.circular(18.0),
                                                                                   side: BorderSide(color: Colors.grey)))),
                                                                       child: Text('PRINT', style: TextStyle(fontSize: 16)),
                                                                       onPressed:
                                                                           () async {

                                                                         //Added By rakesh on 18112022
                                                                         List<String> basicInformation = <String>[];
                                                                         List<String> Dummy = <String>[];
                                                                         //List<OfficeDetail> office=await OfficeDetail().select().toList();
                                                                         final ofcMaster =
                                                                         await OFCMASTERDATA().select().toList();
                                                                         final soltb =
                                                                         await TBCBS_SOL_DETAILS().select().toList();
                                                                         basicInformation.add('CSI BO ID');
                                                                         basicInformation
                                                                             .add(ofcMaster[0].BOFacilityID.toString());
                                                                         basicInformation.add('CSI BO Descriprtion');
                                                                         basicInformation.add(ofcMaster[0].BOName.toString());
                                                                         basicInformation.add('Receipt Date & Time');
                                                                         basicInformation
                                                                             .add(DateTimeDetails().onlyExpDateTime());
                                                                         basicInformation.add('SOL ID');
                                                                         basicInformation.add(soltb[0].SOL_ID.toString());
                                                                         basicInformation.add('SOL Description');
                                                                         basicInformation.add(ofcMaster[0].AOName.toString());
                                                                         basicInformation.add("----------------");
                                                                         basicInformation.add("----------------");
                                                                         basicInformation.add('Account Number:');
                                                                         basicInformation
                                                                             .add('${transsucess[0].CUST_ACC_NUM}'.toString());

                                                                         basicInformation.add('Transaction ID:');
                                                                         basicInformation.add('${transsucess[0].TRANSACTION_ID}'.toString());
                                                                         basicInformation.add('Amount:');
                                                                         basicInformation.add('${transsucess[0].TRANSACTION_AMT}'.toString());
                                                                         basicInformation.add('Transaction Status:');
                                                                         basicInformation.add("Approved");
                                                                         Dummy.clear();
                                                                         PrintingTelPO printer = new PrintingTelPO();
                                                                         bool value = await printer.printThroughUsbPrinter(
                                                                             "CBS",
                                                                             "High Value Cash Withdrawal Details",
                                                                             basicInformation,
                                                                             basicInformation,
                                                                             1);

                                                                       },
                                                                     ),
                                                                     TextButton(
                                                                       child:
                                                                       Text("Back"),
                                                                       style: ButtonStyle(
                                                                         // elevation:MaterialStateProperty.all(),
                                                                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                       onPressed:
                                                                           () {
                                                                         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainHomeScreen(MyCardsScreen(false), 1)), (route) => false);
                                                                       },
                                                                     ),
                                                                   ],
                                                                 )
                                                               ]),
                                                         ),
                                                       )
                                                     ],
                                                   ),
                                                 );
                                               });
                                         }
                                         else {
                                           setState(() {
                                             _isLoading=false;
                                           });
                                           UtilFsNav.showToast(
                                               "${finalMain['127']}",
                                               context,
                                               HighValueWd(""));
                                         }
                                       } else {
                                         UtilFsNav.showToast(
                                             "Signature Verification Failed! Try Again",
                                             context,
                                             HighValueWd(""));
                                         await LogCat().writeContent(
                                             'High value final withdrawal: Signature Verification Failed.');
                                       }
                                     } else {
                                       // UtilFsNav.showToast(
                                       //     '${response.reasonPhrase}',
                                       //     context,
                                       //     HighValueWd(""));
                                       await TBCBS_TRAN_DETAILS()
                                           .select()
                                           .DEVICE_TRAN_ID
                                           .equals(tid)
                                           .update({'STATUS': 'FAILED'});

                                       // UtilFsNav.showToast(
                                       //     "${await response.stream.bytesToString()}",
                                       //     context,
                                       //     HighValueWd(""));

                                       //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                       print(response.statusCode);
                                       List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                       if(response.statusCode==503 || response.statusCode==504){
                                         UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
                                       }
                                       else
                                         UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
                                     }
                                   } catch (_) {
                                     if (_.toString() == "TIMEOUT") {
                                       return UtilFsNav.showToast(
                                           "Request Timed Out",
                                           context,
                                           HighValueWd(""));
                                     }
                                   }
                                 } else {
                                   UtilFsNav.showToast(
                                       "Request approval is pending",
                                       context,
                                       HighValueWd(""));
                                 }
                               },
                             ),
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
                                 child: Text("Cancel Transaction"),
                                 onPressed: () async {
                                   encheader = await encryptcancelhvwdl1();
                                   List<USERLOGINDETAILS> acctoken =
                                   await USERLOGINDETAILS().select().Active.equals(true).toList();
                                   // var request = http.Request('POST', Uri.parse('https://rictapi.cept.gov.in:443/cbs/requestSign'));
                                   // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/highvalue_wdl.txt'));
                                   try {
                                     var headers = {
                                       'Signature': '$encheader',
                                       'Uri': 'requestSign',
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

                                     if (response.statusCode == 200) {
                                       // print(await response.stream.bytesToString());
                                       var resheaders =
                                       await response.headers;
                                       print("Result Headers");
                                       print(resheaders);
                                       // List t =
                                       // resheaders['authorization']!
                                       //     .split(", Signature:");
                                       String res = await response.stream
                                           .bytesToString();
                                       String temp = resheaders['authorization']!;
                                       String decryptSignature = temp;

                                       String val = await decryption1(
                                           decryptSignature, res);
                                       if (val == "Verified!") {
                                         await LogCat().writeContent(
                                                    '$res');
                                         Map a = json.decode(res);
                                         String data = a['JSONResponse']
                                         ['jsonContent'];
                                         Map cancmain = json.decode(data);
                                         if (cancmain[
                                         'successOrFailure'] ==
                                             "SUCCESS") {
                                           await TBCBS_TRAN_DETAILS()
                                               .select()
                                               .DEVICE_TRAN_ID
                                               .equals(mainWdl['blockID'])
                                               .update({
                                             'STATUS': 'Cancelled'
                                           });
                                           UtilFsNav.showToast(
                                               "${cancmain['message']}",
                                               context,
                                               HighValueWd(""));
                                           // Navigator.pushAndRemoveUntil(
                                           // context,
                                           // MaterialPageRoute(
                                           // builder: (context) => HighValueWd("")),
                                           // (route) => false);
                                         }
                                       } else {
                                         UtilFsNav.showToast(
                                             "Signature Verification Failed! Try Again",
                                             context,
                                             HighValueWd(""));
                                         await LogCat().writeContent(
                                             'High value withdrawal Cancel: Signature Verification Failed.');
                                       }
                                     } else {
                                       // UtilFsNav.showToast(
                                       //     "${await response.stream.bytesToString()}",
                                       //     context,
                                       //     HighValueWd(""));

                                       //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                       print(response.statusCode);
                                       List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                       if(response.statusCode==503 || response.statusCode==504){
                                         UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
                                       }
                                       else
                                         UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
                                     }
                                   } catch (_) {
                                     if (_.toString() == "TIMEOUT") {
                                       return UtilFsNav.showToast(
                                           "Request Timed Out",
                                           context,
                                           HighValueWd(""));
                                     }
                                   }
                                 })
                           ],
                         ),
                       ],
                     ),
                   )
                        : Container(),
                  ]),
                ),
                Container(
                    child: _isLoading
                        ? Loader(
                            isCustom: true,
                            loadingTxt: 'Please Wait...Loading...')
                        : Container()),
              ],
            ),
          )),
    );
  }

  Widget? _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () async {
          setState(() {
            _isVisible = false;
            _isCreated = false;
            _isAmount = false;
            finalwdl = false;
          });
          myController.clear();
          _isAmount = false;
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget? _getAmtClearButton() {
    if (!_showAmtClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isAmount = false;
          // }),
          amountTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 14, bottom: 4, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[300],
          boxShadow: [
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 10,
                spreadRadius: 0),
            BoxShadow(
                color: Colors.grey[300]!,
                offset: const Offset(4, 4),
                blurRadius: 10,
                spreadRadius: 0),
          ],
        ),
        child: TextField(
          style: const TextStyle(
              fontSize: 17,
              color: //Colors.white,
                  Color.fromARGB(255, 2, 40, 86),
              fontWeight: FontWeight.w500),
          controller: myController,
          maxLength: 12,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.account_balance_outlined,
                size: 22,
              ),
            ),
            hintStyle: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 2, 40, 86),
              fontWeight: FontWeight.w500,
            ),
            hintText: ' Enter A/C Number',
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.blueAccent, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.green, width: 1)),
            contentPadding:
                EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            suffixIcon: _getClearButton(),
          ),
        ),
      ),
    );
  }

  //
  // Future<File> finalhvwdl() async {
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //
  //   print("Reached finalhvwdl");
  //   final file = File('$cachepath/highvalue_wdl.txt');
  //   file.writeAsStringSync('');
  //   String text='{"2":"${myController.text}","3":"180000","4":"${mainWdl['amount']}","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","125":"N${mainWdl['blockID']}             HVWS 20991231HIGH VALUE WITHDRAWAL THROUGH BO","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH_P  "}';
  //      print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }
  Future<String> encryptfinalhvwdl(String amount,String blockId) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();

    print("Reached finalhvwdl");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String tot =amount.padLeft(14, '0');
    String padt = tot.padRight(16, '0');
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"180000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","125":"N${blockId}             HVWS 20991231HIGH VALUE WITHDRAWAL THROUGH BO","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH_P  "}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" HVW Submission ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> cancelhvwdl() async{
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //
  //   print("Reached finalhvwdl");
  //   final file = File('$cachepath/highvalue_wdl.txt');
  //   file.writeAsStringSync('');
  //  String text='{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"Cancel_blockid_Request","m_BlockID":"${mainWdl['blockID']}","m_BoId":"${login[0].BO_ID}","responseParams":"message,Status,successOrFailure"}';
  //      print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptcancelhvwdl(String blockid) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();

    print("Reached finalhvwdl");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"Cancel_blockid_Request","m_BlockID":"$blockid","m_BoId":"${login[0].BO_ID}","responseParams":"message,Status,successOrFailure"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Cancel HVW ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchhvwenquiry() async {
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached fetchhvwenquiry");
  //   final file = File('$cachepath/highvalue_wdl.txt');
  //   file.writeAsStringSync('');
  //   String text =
  //       '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"InquiryAcctDate","m_AccNum":"${myController.text}","m_BoId":"${login[0].BO_ID}","responseParams":"blockID,reqDate,acctNum,amount,status,Status,successOrFailure,rejReason","m_reqDate":"${DateTimeDetails().currentDate()}"}';
  //   print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchhvwenquiry() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached fetchhvwenquiry");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    var excep=await TBCBS_EXCEP_DETAILS().select().ACCOUNT_NUMBER.equals(myController.text).and.startBlock.REQUEST_STATUS.equals('P').endBlock.toList();
    print("Exception length");
    print(excep.length);
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        // '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"InquiryAcctDate","m_AccNum":"${myController.text}","m_BoId":"${login[0].BO_ID}","responseParams":"blockID,reqDate,acctNum,amount,status,Status,successOrFailure,rejReason","m_reqDate":"${DateTimeDetails().currentDate()}"}\n\n'
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"InquiryAcctDate","m_AccNum":"${myController.text}","m_BoId":"${login[0].BO_ID}","responseParams":"blockID,reqDate,acctNum,amount,status,Status,successOrFailure,rejReason","m_reqDate":"${excep.length>0 ? excep[0].REQUEST_DATE : DateTimeDetails().currentDate()}"}\n\n'

        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" HVW Enquiry ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> newhvwrequest() async {
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached  newhvwrequest");
  //   // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
  //   String tot = amountTextController.text.padLeft(14, '0');
  //   print(tot);
  //   String padt = tot.padRight(16, '0');
  //   print(padt);
  //   final file =
  //       File('$cachepath/hvw_CreateNewRequest.txt');
  //
  //   file.writeAsStringSync('');
  //   String amount = amountTextController.text;
  //   String text =
  //       '{"m_ServiceReqId":"AddExpWithDrawRequest","m_ReqUUID":"Req_$TranReqID","m_BlockID":"$TranID","m_AccNum":"${myController.text}","m_Amount":"${amountTextController.text}","m_BoId":"${login[0].BO_ID}","m_ReqDate":"${DateTimeDetails().proposalDate()}","responseParams":"message,status,successOrFailure"}';
  //   print("HVW_create new request");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptcancelhvwdl1() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();

    print("Reached finalhvwdl");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
    goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"Cancel_blockid_Request","m_BlockID":"${mainWdl['blockID']}","m_BoId":"${login[0].BO_ID}","responseParams":"message,Status,successOrFailure"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Cancel HVW ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> encryptnewhvwrequest() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached  newhvwrequest");
    // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
    String tot = amountTextController.text.padLeft(14, '0');
    print(tot);
    String padt = tot.padRight(16, '0');
    print(padt);
    final file = File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    String amount = amountTextController.text;
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ServiceReqId":"AddExpWithDrawRequest","m_ReqUUID":"Req_$TranReqID","m_BlockID":"$TranID","m_AccNum":"${myController.text}","m_Amount":"${amountTextController.text}","m_BoId":"${login[0].BO_ID}","m_ReqDate":"${DateTimeDetails().proposalDate()}","responseParams":"message,status,successOrFailure"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("HVW_create new request");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New HVW Request ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchaccdetails() async {
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached fetchaccdetails");
  //   final file = File('$cachepath/highvalue_wdl.txt');
  //   file.writeAsStringSync('');
  //   String text =
  //       '{"2":"${myController.text}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}';
  //   print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchaccdetails() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached fetchaccdetails");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" HVW acc details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future getAcctDetails() async {
    var login = await USERDETAILS().select().toList();


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    encheader = await encryptfetchaccdetails();
    // var request = http.Request(
    //     'POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
    // request.files.add(await http.MultipartFile.fromPath(
    //     '', '$cachepath/highvalue_wdl.txt'));
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
      //request.files.add(await http.MultipartFile.fromPath(
   //       'file', '$cachepath/fetchAccountDetails.txt'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: 65), onTimeout: () {
        // return UtilFs.showToast('The request Timeout',context);
        setState(() {
          _isLoading = false;
        });
        throw 'TIMEOUT';
      });
      setState(() {
        _isLoading = false;
      });
      print(response.statusCode);
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
          Map a = json.decode(res);
          print(a['JSONResponse']['jsonContent']);
          String data = a['JSONResponse']['jsonContent'];
          main = json.decode(data);
          print("Values");
          print(main);
          setState(() {
            _isLoading = false;
          });
          if (main['Status'] == "SUCCESS") {
            if (main['39'] != "000") {
              var ec = await CBS_ERROR_CODES()
                  .select()
                  .Error_code
                  .equals(main['39'])
                  .toList();
              UtilFsNav.showToast(
                  '${ec[0].Error_message}', context, HighValueWd(""));
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => HighValueWd("")),
              //         (route) => false);
            } else {
              print(login[0].BOFacilityID);
              List checkaccount = await fac.split126accenquiry(main['126']);
              if (checkaccount[1] == login[0].BOFacilityID) {
                bool accountInvalidFlag = false;
                String invalidMessage = "";
                String caseResponse = await statusMessage(main['125']);
                print('casmethod');
                print(caseResponse);
                if (caseResponse != 'false') {
                  accountInvalidFlag = true;
                  invalidMessage = caseResponse;
                }
                if (accountInvalidFlag) {
                  UtilFsNav.showToast(invalidMessage, context, HighValueWd(""));
                } else {
                  rec = await fac.split125(main['125']);
                  balances = await fac.split48(main['48']);
                  achname = rec![1].toString().trim();

                  String reduced = balances![1]!.replaceAll(regexp, '');

                  mainbal = StringUtils.addCharAtPosition(
                      reduced, ".", reduced.length - 2);
                  displaybalance = mainbal!.split('.')[0];
                  print(displaybalance);
                  setState(() {
                    _isVisible = true;
                  });
                }
              } else {
                UtilFsNav.showToast(
                    "Account Number Entered doesnot belong to this BO",
                    context,
                    HighValueWd(""));
              }
            }
          }
        } else {
          UtilFsNav.showToast("Signature Verification Failed! Try Again",
              context, HighValueWd(""));
          await LogCat().writeContent(
              'HVW acc details Fetching: Signature Verification Failed.');
        }
      } else {
        // UtilFsNav.showToast("${await response.stream.bytesToString()}", context,
        //     HighValueWd(""));

        //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
        print(response.statusCode);
        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
        if(response.statusCode==503 || response.statusCode==504){
          UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,HighValueWd(""));
        }
        else
          UtilFsNav.showToast(error[0].Description.toString(), context,HighValueWd(""));
        
        // UtilFs.showToast("${await response.stream.bytesToString()}", context);
      }
    } catch (_) {
      if (_.toString() == "TIMEOUT") {
        return UtilFsNav.showToast(
            "Request Timed Out", context, HighValueWd(""));
      }
    }
  }

  Future<String> encryptfinalhvwdl1() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();

    print("Reached finalhvwdl");
    final file = File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
    goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String tot = mainWdl['amount'].padLeft(14, '0');
    String padt = tot.padRight(16, '0');
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"180000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","125":"N${mainWdl['blockID']}             HVWS 20991231HIGH VALUE WITHDRAWAL THROUGH BO","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH_P  "}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" HVW Submission ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> statusMessage(inputValue) async {
    String invalidMessage = "false";
    switch (inputValue) {
      case "INVALID_ACC_NO":
        invalidMessage = "Entered account number does not exist";
        break;
      case "ACC_CLOSED":
        invalidMessage = "Entered account number is Closed";
        break;
      case "ACC_SILENT":
        invalidMessage = "Entered Account Number is Silent";
        break;
      case "ACC_FROZEN":
        invalidMessage = "Entered Account Number is Frozen";
        break;
      case "ACC_NOT_WIT_BO":
        invalidMessage =
            "Entered account number is not linked to this BO.Please contact Home Branch";
        break;
      case "RD_SB_SSA":
        invalidMessage = "Please enter only SB or RD or SSA account numbers";
        break;
      case "ACC_DEB_FROZEN":
        invalidMessage = "Transaction not allowed for this scheme from device";
        break;
      case "DIFF_DATE":
        invalidMessage =
            "FSI-CBS SOL BOD Date is different from device date.Transaction not allowed";
        break;
    }
    return invalidMessage;
  }
}
