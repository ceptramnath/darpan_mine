import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/IPPB_BODA/IPPB_API_CALL.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';

import '../../HomeScreen.dart';
import '../UtilitiesMainScreen.dart';
import 'IPPBDatReport.dart';

class IPPB extends StatefulWidget {
  // String? name;
  // String? CIFNumber;
  // String? isminor;
  // String? kycstatus;
  //
  // SelfNewAccount(this.name,this.CIFNumber,this.isminor,this.kycstatus);
  @override
  _IPPBState createState() => _IPPBState();
}

class _IPPBState extends State<IPPB> {
  int selected = 0;

  // bool isVisible = false;
  bool _isVisible = false;
  final depositTextController = TextEditingController();
  final withdrawalTextController = TextEditingController();
  final depositamountTextController = TextEditingController();
  final withdrawamountTextController = TextEditingController();
  bool _showClearButton = true;
  final currentDate = DateTimeDetails().onlyDatewithFormat();
  String? deposit;
  String? withdrawal;
  String? depositAmt;
  String? withdrawalAmt;

//  bool _showClearButton = true;
  String? schtype;
  TextEditingController date = TextEditingController();
  List<IPPBCBS_DETAILS> IPPBDetails = [];
  String? remarks_mode;

  // final bool showCheckboxColumn=false;

  bool _isTotal = false;

//  bool _isDepositTotal=false;
  // bool _isWithdrawalTotal=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IPPB Daily Transaction Report',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: (Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
            child: TextFormField(
              controller: date,
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
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.green, width: 1)),
                contentPadding:
                    EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
    children: [
          RaisedButton(
              child: Text('Search',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: "Georgia",
                      letterSpacing: 1)),
              color: Color(0xFFB71C1C),
              //Colors.green,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () async {
                // print("DataEntry_DETAILS are:");
                // print(await IPPBCBS_DETAILS()
                //     .select().toMapList());
                // await IPPBCBS_DETAILS().select()
                //     .TRANSACTION_DATE
                //     .equals(date.text)
                //     .update({"Remarks": "API",});
                // print(DateTimeDetails().FrmIppbConvert("31-DEC-23"));
                // print(DateTimeDetails().ToIppbConvert("12-08-2023"));
                IPPBDetails = await IPPBCBS_DETAILS()
                    .select()
                    .TRANSACTION_DATE
                    .equals(date.text)
                    .toList();
                print(  await IPPBCBS_DETAILS()
                      .select()
                      .TRANSACTION_DATE
                      .equals(date.text)
                  .toMapList());
                // await IPPBCBS_DETAILS()
                //     .select()
                //     .TRANSACTION_DATE
                //     .equals(date.text)
                //     .delete();
                if (IPPBDetails.isNotEmpty) {
                  deposit = IPPBDetails[0].TOTAL_DEPOSITS;
                  withdrawal = IPPBDetails[0].TOTAL_WITHDRAWALS;
                  depositAmt = IPPBDetails[0].TOTAL_DEPOSIT_AMOUNT;
                  withdrawalAmt = IPPBDetails[0].TOTAL_WITHDRAWAL_AMOUNT;
                  depositTextController.text = deposit!;
                  depositamountTextController.text = depositAmt!;
                  withdrawalTextController.text = withdrawal!;
                  withdrawamountTextController.text = withdrawalAmt!;
                  remarks_mode=IPPBDetails[0].Remarks;
                } else {
                  deposit = null;
                  withdrawal = null;
                  depositAmt = null;
                  withdrawalAmt = null;
                  depositTextController.text = "";
                  depositamountTextController.text = "";
                  withdrawalTextController.text = "";
                  withdrawamountTextController.text = "";
                  // await IPPBCBS_DETAILS()
                  //     .select()
                  //     .TRANSACTION_DATE
                  //     .equals(date.text)
                  //     .delete();
                 // UtilFs.showToast("Please fetch/provide the IPPB Transaction details!", context);
                }
                setState(() {
                  // selected = index;
                  // print(selected);
                  _isVisible = true;
                });
              }),
          // RaisedButton(
          //     child: Text('Fetch Data',
          //         style: TextStyle(
          //             fontStyle: FontStyle.italic,
          //             fontFamily: "Georgia",
          //             letterSpacing: 1)),
          //     color: Color(0xFFB71C1C),
          //     //Colors.green,
          //     textColor: Colors.white,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     onPressed: () async {
          //       // Get the last IPPB data datetime
          //       var test =
          //       '''select MAX(substr(TRANSACTION_DATE,7,4)|| '-'||substr(TRANSACTION_DATE,4,2)||'-' ||substr(TRANSACTION_DATE,1,2)) as LastTranDate from IPPBCBS_DETAILS''';
          //       final lastippbdate = await CBS().execDataTable(test);
          //       print(lastippbdate[0]["LastTranDate"]);
          //       final last_ippb=  await IPPBCBS_DETAILS()
          //           .select()
          //           .TRANSACTION_DATE
          //           .equals(lastippbdate[0]["LastTranDate"].toString()
          //           .split('-')
          //           .reversed
          //           .join('-').toString())
          //           .toMapList();
          //       print(last_ippb[0]["TRANSACTION_DATE"].toString());
          //       print(last_ippb[0]["TRANSACTION_TIME"].toString());
          //
          //       ippb_BODA ippbboda= new ippb_BODA();
          //       //Check the date difference between last BODA and today
          //       final datediff=DateTime.now().difference(DateTime.parse(lastippbdate[0]["LastTranDate"].toString())).inDays ;
          //       print("Date difference is $datediff");
          //       // Make API calls based on the date difference
          //       String fromDate="";//"08-02-23 00:00:00";//frmDate
          //       String toDate="";//"08-02-23 23:59:00";//ToDate
          //       if(datediff == 1)
          //       {
          //         //     First call from the time of IPPB data/BODA of D-1 to 23:59:00 of D-1 (to fetch IPPB transactions done after
          //         // day end of BO for D-1 )
          //         fromDate= "${last_ippb[0]["TRANSACTION_DATE"]} ${last_ippb[0]["TRANSACTION_TIME"].toString()}";
          //         toDate= "${DateTimeDetails().previousDate()} 23:59:00";
          //         print("From Date for D-1 call is $fromDate");
          //         print("To Date for D-1 call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //         //Second call from 00:00:00 of D to the actual time of BODA on D.
          //         fromDate= "${DateTimeDetails().currentDate()} 00:00:00";
          //         toDate= "${DateTimeDetails().currentDate()} ${DateTimeDetails().oT()}";
          //         print("From Date for D call is $fromDate");
          //         print("To Date for D call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //       } else if(datediff == 2){
          //         //  First call from the time of IPPB/BODA of D-2 to 23:59:00 of D-2
          //         fromDate= "${last_ippb[0]["TRANSACTION_DATE"]} ${last_ippb[0]["TRANSACTION_TIME"].toString()}";
          //         toDate= "${DateTimeDetails().Dminus2DateOnly()} 23:59:00";
          //         print("From Date for D-2 call is $fromDate");
          //         print("To Date for D-2 call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //         // Second call from 00:00:00 of D-1 to 23:59:00 of D-1 .
          //         fromDate= "${DateTimeDetails().previousDate()} 00:00:00";
          //         toDate= "${DateTimeDetails().previousDate()} 23:59:00";
          //         print("From Date for D-1 call is $fromDate");
          //         print("To Date for D-1 call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //         // Third call from 00:00:00 of D to the actual time of BODA on D.
          //         fromDate= "${DateTimeDetails().currentDate()} 00:00:00";
          //         toDate= "${DateTimeDetails().currentDate()} ${DateTimeDetails().oT()}";
          //         print("From Date for D call is $fromDate");
          //         print("To Date for D call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //       }
          //       else if(datediff >= 3){
          //         //   For D-3 or more, call to be made to middle layer and data to be pulled for
          //         //   complete days like 00:00:00 to 23:59:59 hours**************
          //         //////////////////////// Yet to get the API
          //
          //         // First call from the time 00:00:00 of D-2 to 23:59:00 of D-2
          //         fromDate= "${DateTimeDetails().Dminus2DateOnly()} 00:00:00";
          //         toDate= "${DateTimeDetails().Dminus2DateOnly()} 23:59:00";
          //         print("From Date for D-2 call is $fromDate");
          //         print("To Date for D-2 call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //         // Second call from 00:00:00 of D-1 to 23:59:00 of D-1 .
          //         fromDate= "${DateTimeDetails().previousDate()} 00:00:00";
          //         toDate= "${DateTimeDetails().previousDate()} 23:59:00";
          //         print("From Date for D-1 call is $fromDate");
          //         print("To Date for D-1 call is $toDate");
          //         // Third call from 00:00:00 of D to the actual time of BODA on D.
          //         fromDate= "${DateTimeDetails().currentDate()} 00:00:00";
          //         toDate= "${DateTimeDetails().currentDate()} ${DateTimeDetails().oT()}";
          //         print("From Date for D call is $fromDate");
          //         print("To Date for D call is $toDate");
          //         //await  ippbboda.getData(fromDate,toDate);
          //       }
          //
          //       //Check the rows in IppbApi where status not equal to SUCCESS for today ReqDATE
          //       final ippbapi_fail = await IppbApi()
          //           .select()
          //           .ReqDATE
          //           .equals(DateTimeDetails().currentDate())
          //           .and
          //           .Status
          //           .not.equals("SUCCESS")
          //           .toList();
          //       print(ippbapi_fail.length);
          //       if(ippbapi_fail.length==0){
          //         //Total all and put in IPPBCBS_DETAILS table
          //         var total_Data =
          //         '''SELECT SUM(TotalDeposit) as TotDeposit,SUM(TotalWithdrawl) as TotWdl from IppbApi where ReqDATE ='${DateTimeDetails().currentDate()}'  and Status = "SUCCESS" ''';
          //         print(total_Data);
          //         final Total_cons = await TransactionsMain().execDataTable(total_Data);
          //         print(Total_cons[0]["TotDeposit"]);
          //         print(Total_cons[0]["TotWdl"]);
          //         depositamountTextController.text=Total_cons[0]["TotDeposit"].toString();
          //         withdrawamountTextController.text=Total_cons[0]["TotWdl"].toString();
          //         await _submit(context,"API");
          //         // final tranDetails = IPPBCBS_DETAILS()
          //         //   ..TRANSACTION_DATE = DateTimeDetails().currentDate()
          //         //   ..TRANSACTION_TIME = DateTimeDetails().oT()
          //         //  // ..TOTAL_DEPOSITS = Total_cons[0]["TotDeposit"]
          //         //   ..TOTAL_DEPOSIT_AMOUNT =
          //         //   Total_cons[0]["TotDeposit"].toString()
          //         //  // ..TOTAL_WITHDRAWALS = withdrawalTextController.text
          //         //   ..TOTAL_WITHDRAWAL_AMOUNT =
          //         //   Total_cons[0]["TotWdl"].toString();
          //         // tranDetails.save();
          //         //
          //         // //Adding to Cash Table
          //         // final addCash =  CashTable()
          //         //   ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
          //         //   ..Cash_Date = DateTimeDetails().currentDate()
          //         //   ..Cash_Time = DateTimeDetails().onlyTime()
          //         //   ..Cash_Type = 'Add'
          //         //   ..Cash_Amount = double.parse(Total_cons[0]["TotDeposit"].toString())
          //         //   ..Cash_Description = 'IPPB Deposit';
          //         // await addCash.save();
          //         //
          //         // //Adding to Cash Table
          //         // final minusCash = CashTable()
          //         //   ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
          //         //   ..Cash_Date = DateTimeDetails().currentDate()
          //         //   ..Cash_Time = DateTimeDetails().onlyTime()
          //         //   ..Cash_Type = 'Add'
          //         //   ..Cash_Amount = double.parse("-${Total_cons[0]["TotWdl"].toString()}")
          //         //   ..Cash_Description = 'IPPB Withdraw';
          //         // minusCash.save();
          //         // var now = DateTime.now();
          //         // var formatter = DateFormat('dd-MM-yyyy');
          //         // final String formattedTime = DateFormat.jm().format(now).toString();
          //         //
          //         // //Adding to Transaction Table
          //         //
          //         // final addTransaction = TransactionTable()
          //         //   ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
          //         //   ..tranDescription = "IPPB Deposit"
          //         //   ..tranAmount = double.parse(Total_cons[0]["TotDeposit"].toString())
          //         //   ..tranType = "IPPB"
          //         //   ..tranDate = DateTimeDetails().currentDate()
          //         //   ..tranTime = DateTimeDetails().onlyTime()
          //         //   ..valuation = "Add";
          //         //
          //         // await addTransaction.save();
          //         //
          //         // final minusTransaction = TransactionTable()
          //         //   ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
          //         //   ..tranDescription = "IPPB Withdraw"
          //         //   ..tranAmount = double.parse("-${Total_cons[0]["TotWdl"].toString()}")
          //         //   ..tranType = "IPPB"
          //         //   ..tranDate = DateTimeDetails().currentDate()
          //         //   ..tranTime = DateTimeDetails().onlyTime()
          //         //   ..valuation = "Add";
          //         // minusTransaction.save();
          //       }
          //       else{
          //         //Activate Data entry and get data, insert data in IPPBCBS_DETAILS table
          //         _isVisible=true;
          //       }
          //       // String res="";
          //       // res= await  ippbboda.getData();
          //       //print("Response is $res");
          //     }
          //
          // ),
          ]
          ),
          // SizedBox(height: 10,),
          //  Visibility(
          //    visible: isDataTableVisible,
          //    child: Column(
          //      children: [
          //        SizedBox(height: 10,),
          //        Text('Daily Transaction Report', style: TextStyle(
          //            fontSize: 18, color: Colors.blueGrey)),
          //        SizedBox(height: 10,),
          //        TextFormField(
          //          controller: date,
          //          style: TextStyle(color: Colors.blueGrey),
          //          readOnly: true,
          //          decoration: InputDecoration(
          //            prefixIcon: IconButton(
          //              icon: Icon(
          //                Icons.calendar_today_outlined,
          //              ),
          //              onPressed: () {
          //                _selectDailyTranReportDate(context);
          //              },
          //            ),
          //            labelText: "Enter Date",
          //            hintStyle: TextStyle(
          //              fontSize: 15,
          //              color: Color.fromARGB(255, 2, 40, 86),
          //              fontWeight: FontWeight.w500,
          //            ),
          //            border: InputBorder.none,
          //            enabledBorder: OutlineInputBorder(
          //                borderSide:
          //                BorderSide(
          //                    color: Colors.blueGrey, width: 3)),
          //            focusedBorder: OutlineInputBorder(
          //                borderSide: BorderSide(
          //                    color: Colors.green, width: 3)),
          //            // contentPadding: EdgeInsets.only(
          //            //     top: 20, bottom: 20, left: 20, right: 20),
          //          ),
          //        ),
          //        // Row(
          //        //   mainAxisAlignment: MainAxisAlignment.start,
          //        //   children: [
          //        //     TextFormField(
          //        //       style: TextStyle(color: Colors.black),
          //        //       //   readOnly: true,
          //        //       decoration: const InputDecoration(
          //        //         labelText: "Total No.of Deposits",
          //        //         hintText: "Enter No.of Deposits",
          //        //         border: InputBorder.none,
          //        //         contentPadding: EdgeInsets.symmetric(
          //        //             vertical: 10.0, horizontal: 10.0),
          //        //       ),
          //        //     ),
          //        //     TextFormField(
          //        //       style: TextStyle(color: Colors.black),
          //        //       readOnly: true,
          //        //       decoration: InputDecoration(
          //        //         //  labelText: "Total Deposits" + deposit1.toString(),
          //        //         border: InputBorder.none,
          //        //         contentPadding: const EdgeInsets.symmetric(
          //        //             vertical: 10.0, horizontal: 10.0),
          //        //       ),
          //        //     ),
          //        //
          //        //   ],
          //        // ),
          //        // Row(
          //        //   mainAxisAlignment: MainAxisAlignment.start,
          //        //   children: [
          //        //     Column(
          //        //       children: [
          //        //         TextFormField(
          //        //           style: TextStyle(color: Colors.black),
          //        //           readOnly: true,
          //        //           decoration: InputDecoration(
          //        //             labelText: "Total No.of Withdrawals " + deposit1.toString(),
          //        //             border: InputBorder.none,
          //        //             contentPadding: const EdgeInsets.symmetric(
          //        //                 vertical: 10.0, horizontal: 10.0),
          //        //           ),
          //        //         ),
          //        //         TextFormField(
          //        //           style: TextStyle(color: Colors.black),
          //        //           //  readOnly: true,
          //        //           decoration: InputDecoration(
          //        //             //  labelText: "Total Deposits" + deposit1.toString(),
          //        //             border: InputBorder.none,
          //        //             contentPadding: const EdgeInsets.symmetric(
          //        //                 vertical: 10.0, horizontal: 10.0),
          //        //           ),
          //        //         ),
          //        //       ],
          //        //     ),
          //        //     Column(
          //        //       children: [
          //        //         TextFormField(
          //        //           style: TextStyle(color: Colors.black),
          //        //           readOnly: true,
          //        //           decoration: InputDecoration(
          //        //             labelText: "Total Withdrawal Amount" ,
          //        //             border: InputBorder.none,
          //        //             contentPadding: const EdgeInsets.symmetric(
          //        //                 vertical: 10.0, horizontal: 10.0),
          //        //           ),
          //        //         ),
          //        //         TextFormField(
          //        //           style: TextStyle(color: Colors.black),
          //        //           // readOnly: true,
          //        //           decoration: InputDecoration(
          //        //             //   labelText: "Total Deposits Amount" +withdrawal1.toString(),
          //        //             border: InputBorder.none,
          //        //             contentPadding: const EdgeInsets.symmetric(
          //        //                 vertical: 10.0, horizontal: 10.0),
          //        //           ),
          //        //         ),
          //        //       ],
          //        //     ),
          //        //   ],
          //        // ),
          //        SizedBox(height: 10,),
          //        Center(
          //          child: Row(
          //            mainAxisAlignment: MainAxisAlignment.center,
          //            children: [
          //              RaisedButton(
          //                  child: Text(
          //                      'Print', style: TextStyle(fontStyle: FontStyle.italic,fontFamily: "Georgia",letterSpacing:1)),
          //                  color: Color(0xFFB71C1C),
          //                  //Colors.green,
          //                  textColor: Colors.white,
          //                  shape: RoundedRectangleBorder(
          //                    borderRadius: BorderRadius.circular(20),
          //                  ),
          //                  onPressed: (){}
          //
          //              ),
          //
          //              SizedBox(width: 15,),
          //
          //              RaisedButton(
          //
          //                child: Text(
          //                    'Cancel', style: TextStyle(fontStyle: FontStyle.italic,fontFamily: "Georgia",letterSpacing:1)),
          //
          //                color: Color(0xFFB71C1C),
          //
          //                //Colors.green,
          //
          //                textColor: Colors.white,
          //
          //                shape: RoundedRectangleBorder(
          //
          //                  borderRadius: BorderRadius.circular(20),
          //
          //                ),
          //
          //                onPressed: () {
          //                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
          //                  Navigator.pushAndRemoveUntil(context,
          //                      MaterialPageRoute(builder: (context) =>
          //                          MainHomeScreen(MyCardsScreen(false), 1)), (
          //                          route) => false);
          //                },
          //
          //              ),
          //
          //            ],
          //
          //          ),
          //
          //        ),
          //      ],
          //    ),
          //  ),
          Visibility(
            visible: _isVisible,
            child: Column(
              children: [
                Text('IPPB Transaction Details',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 10,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8),
                    //     child: TextFormField(
                    //       style: TextStyle(color: Colors.blueGrey),
                    //       controller: depositTextController,
                    //       readOnly: currentDate != date.text ? true : false,
                    //       keyboardType:
                    //       // TextInputType.phone,
                    //                 TextInputType.number,
                    //       decoration: InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(left: 8),
                    //           child: Icon(
                    //             Icons.account_balance_outlined,
                    //             size: 22,
                    //           ),
                    //         ),
                    //
                    //         hintStyle: TextStyle(
                    //           fontSize: 15,
                    //           color: Color.fromARGB(255, 2, 40, 86),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         //      hintText: ' Enter No.of Deposits',
                    //
                    //         hintText: deposit != null
                    //             ? deposit
                    //             : ' Enter No.of Deposits',
                    //         labelText: "Number of Deposits",
                    //         floatingLabelBehavior: FloatingLabelBehavior.always,
                    //         border: InputBorder.none,
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(30.0)),
                    //             borderSide: BorderSide(
                    //                 color: Colors.blueAccent, width: 1)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(30.0)),
                    //             borderSide:
                    //                 BorderSide(color: Colors.green, width: 1)),
                    //         contentPadding: EdgeInsets.only(
                    //             top: 20, bottom: 20, left: 20, right: 20),
                    //         //       suffixIcon: _getClearButton(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width * 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.blueGrey),
                          controller: depositamountTextController,
                          readOnly: currentDate != date.text || remarks_mode=="API" ? true : false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.money_off_sharp,
                                size: 22,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            //  hintText: ' Enter Deposit Amount',
                            hintText: depositAmt != null
                                ? depositAmt
                                : ' Enter Deposit Amount',
                            labelText: "Total Deposit Amount",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                            //    suffixIcon: _getdepositamountClearButton(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 10,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8),
                    //     child: TextFormField(
                    //       style: TextStyle(color: Colors.blueGrey),
                    //       controller: withdrawalTextController,
                    //       readOnly: currentDate != date.text ? true : false,
                    //       keyboardType: TextInputType.number,
                    //       decoration: InputDecoration(
                    //         prefixIcon: Padding(
                    //           padding: EdgeInsets.only(left: 8),
                    //           child: Icon(
                    //             Icons.account_balance_outlined,
                    //             size: 22,
                    //           ),
                    //         ),
                    //         hintStyle: TextStyle(
                    //           fontSize: 15,
                    //           color: Color.fromARGB(255, 2, 40, 86),
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         //   hintText: ' Enter No.of Withdrawals',
                    //         hintText: withdrawal != null
                    //             ? withdrawal
                    //             : ' Enter No.of Withdrawals',
                    //         labelText: "Number of withdrawals",
                    //         floatingLabelBehavior: FloatingLabelBehavior.always,
                    //         border: InputBorder.none,
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(30.0)),
                    //             borderSide: BorderSide(
                    //                 color: Colors.blueAccent, width: 1)),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(30.0)),
                    //             borderSide:
                    //                 BorderSide(color: Colors.green, width: 1)),
                    //         contentPadding: EdgeInsets.only(
                    //             top: 20, bottom: 20, left: 20, right: 20),
                    //         //    suffixIcon: _getwithdrawClearButton(),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width * 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          style: TextStyle(color: Colors.blueGrey),
                          controller: withdrawamountTextController,
                          readOnly: currentDate != date.text || remarks_mode=="API" ? true : false,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.money_off_sharp,
                                size: 22,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            // hintText: ' Enter Withdrawal Amount',

                            hintText: withdrawalAmt != null
                                ? withdrawalAmt
                                : ' Enter Withdrawal Amount',
                            labelText: "Total Withdrawal Amount",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 1)),
                            contentPadding: EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                            //     suffixIcon: _getwithdrawamountClearButton(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),


                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      RaisedButton(
                          child: Text('Submit',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Georgia",
                                  letterSpacing: 1)),
                          color: Color(0xFFB71C1C),
                          //Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () async {
                            //      bool isredirect=true;
                           await _submit(context,"DE");
                          }
                          ),

                      // RaisedButton(
                      //     child: Text('Print',
                      //         style: TextStyle(
                      //             fontStyle: FontStyle.italic,
                      //             fontFamily: "Georgia",
                      //             letterSpacing: 1)),
                      //     color: Color(0xFFB71C1C),
                      //     //Colors.green,
                      //     textColor: Colors.white,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     onPressed: () {}),


                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                        child: Text('Cancel',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Georgia",
                                letterSpacing: 1)),

                        color: Color(0xFFB71C1C),

                        //Colors.green,

                        textColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainHomeScreen(UtilitiesMainScreen(), 0)),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ])),
      ),
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
        onPressed: () => {
          // setState(() {
          //   isVisible=false;
          // }),
          depositTextController.clear()
        },
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
          date.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _submit(BuildContext context,String mode) async {
    if (
    //depositTextController.text.isEmpty ||
    depositamountTextController.text.isEmpty ||
        //withdrawalTextController.text.isEmpty ||
        withdrawamountTextController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Please Enter Deposit & Withdrawal Data..!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          });
      //   UtilFs.showToast("No data found", context);
    }
    else {
      IPPBDetails = await IPPBCBS_DETAILS()
          .select()
          .TRANSACTION_DATE
          .equals(date.text)
          .toList();
      if (IPPBDetails.isEmpty) {
        final tranDetails = IPPBCBS_DETAILS()
          ..TRANSACTION_DATE = date.text
          ..TRANSACTION_TIME = DateTimeDetails().oT()
          ..TOTAL_DEPOSITS = depositTextController.text
          ..TOTAL_DEPOSIT_AMOUNT =
              depositamountTextController.text
          ..TOTAL_WITHDRAWALS = withdrawalTextController.text
          ..TOTAL_WITHDRAWAL_AMOUNT =
              withdrawamountTextController.text
        ..Remarks=mode;
        tranDetails.save();

        //Adding to Cash Table
        final addCash =  CashTable()
          ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
          ..Cash_Date = DateTimeDetails().currentDate()
          ..Cash_Time = DateTimeDetails().onlyTime()
          ..Cash_Type = 'Add'
          ..Cash_Amount = double.parse(depositamountTextController.text)
          ..Cash_Description = 'IPPB Deposit';
        await addCash.save();


        //Adding to Cash Table
        final minusCash = CashTable()
          ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
          ..Cash_Date = DateTimeDetails().currentDate()
          ..Cash_Time = DateTimeDetails().onlyTime()
          ..Cash_Type = 'Add'
          ..Cash_Amount = double.parse("-${withdrawamountTextController.text}")
          ..Cash_Description = 'IPPB Withdraw';
        minusCash.save();


        var now = DateTime.now();
        var formatter = DateFormat('dd-MM-yyyy');
        final String formattedTime = DateFormat.jm().format(now).toString();

        //Adding to Transaction Table

        final addTransaction = TransactionTable()
          ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
          ..tranDescription = "IPPB Deposit"
          ..tranAmount = double.parse(depositamountTextController.text)
          ..tranType = "IPPB"
          ..tranDate = DateTimeDetails().currentDate()
          ..tranTime = DateTimeDetails().onlyTime()
          ..valuation = "Add";

        await addTransaction.save();

        final minusTransaction = TransactionTable()
          ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
          ..tranDescription = "IPPB Withdraw"
          ..tranAmount = double.parse("-${withdrawamountTextController.text}")
          ..tranType = "IPPB"
          ..tranDate = DateTimeDetails().currentDate()
          ..tranTime = DateTimeDetails().onlyTime()
          ..valuation = "Add";
        minusTransaction.save();
      }

      else {
        // currentDate=    await DateTimeDetails().onlyDatewithFormat();
        if (currentDate != date.text) {
          UtilFs.showToast("Modification not allowed for previous date",
              context);
          depositTextController.text = deposit!;
          depositamountTextController.text = depositAmt!;
          withdrawalTextController.text = withdrawal!;
          withdrawamountTextController.text = withdrawalAmt!;

          //  isredirect=false;
        }
        //Update allowed only for Data Entry mode
        else if(mode=="DE") {
          final result = await IPPBCBS_DETAILS()
              .select()
              .TRANSACTION_DATE
              .equals(date.text)
              .update({
            "TOTAL_DEPOSITS": depositTextController.text,
            "TOTAL_DEPOSIT_AMOUNT":
            depositamountTextController.text,
            "TOTAL_WITHDRAWALS":
            withdrawalTextController.text,
            "TOTAL_WITHDRAWAL_AMOUNT":
            withdrawamountTextController.text,
            "TRANSACTION_TIME" : DateTimeDetails().oT()
          });
          print(result.toString());

          //Adding to Cash Table
          final updateaddCash = CashTable().select()
              .Cash_ID.equals('IPPB_'+DateTimeDetails().dateCharacter()).and
              .startBlock.Cash_Description.equals('IPPB Deposit').endBlock
              .update({"Cash_Amount":double.parse(depositamountTextController.text)
          });
          print(updateaddCash);

          final updateminusCash = CashTable().select()
              .Cash_ID.equals('IPPB_'+DateTimeDetails().dateCharacter()).and
              .startBlock.Cash_Description.equals('IPPB Withdraw').endBlock
              .update({"Cash_Amount":double.parse("-${withdrawamountTextController.text}")
          });
          print(updateminusCash);

          final updateaddTransaction = TransactionTable().select()
              .tranid.equals('IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}')
              .and.startBlock.tranDescription.equals("IPPB Deposit").endBlock
              .update({"tranAmount":double.parse(depositamountTextController.text)});

          print(updateaddTransaction);

          final updateminusTransaction = TransactionTable().select()
              .tranid.equals('IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}')
              .and.startBlock.tranDescription.equals("IPPB Withdraw").endBlock
              .update({"tranAmount":double.parse("-${withdrawamountTextController.text}")});

          print(updateminusTransaction);

          //Commented Insert code. added above code for update.
          /*
                                  final addCash =  CashTable()
                                    ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
                                    ..Cash_Date = DateTimeDetails().currentDate()
                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                    ..Cash_Type = 'Add'
                                    ..Cash_Amount = double.parse(depositTextController.text)
                                    ..Cash_Description = 'IPPB Deposit';
                                  await addCash.save();


                                  //Adding to Cash Table
                                  final minusCash = CashTable()
                                    ..Cash_ID = 'IPPB_'+DateTimeDetails().dateCharacter()
                                    ..Cash_Date = DateTimeDetails().currentDate()
                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                    ..Cash_Type = 'Add'
                                    ..Cash_Amount = double.parse("-${withdrawalTextController.text}")
                                    ..Cash_Description = 'IPPB Withdraw';
                                  minusCash.save();


                                  var now = DateTime.now();
                                  var formatter = DateFormat('dd-MM-yyyy');
                                  final String formattedTime = DateFormat.jm().format(now).toString();

                                  //Adding to Transaction Table

                                  final addTransaction = TransactionTable()
                                    ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
                                    ..tranDescription = "IPPB Deposit"
                                    ..tranAmount = double.parse(depositTextController.text)
                                    ..tranType = "IPPB"
                                    ..tranDate = DateTimeDetails().currentDate()
                                    ..tranTime = DateTimeDetails().onlyTime()
                                    ..valuation = "Add";

                                  await addTransaction.save();

                                  final minusTransaction = TransactionTable()
                                    ..tranid = 'IPPB${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
                                    ..tranDescription = "IPPB Withdraw"
                                    ..tranAmount = double.parse("-${withdrawalTextController.text}")
                                    ..tranType = "IPPB"
                                    ..tranDate = DateTimeDetails().currentDate()
                                    ..tranTime = DateTimeDetails().onlyTime()
                                    ..valuation = "Add";

                                  minusTransaction.save();

                                   */



        }
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => IPPBdatReport(
                  date.text,
                  depositTextController.text,
                  depositamountTextController.text,
                  withdrawalTextController.text,
                  withdrawamountTextController.text)));
    }
  }
  Widget? _getwithdrawClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          withdrawalTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget? _getdepositamountClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          depositamountTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget? _getwithdrawamountClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          withdrawamountTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }
}
