import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:flutter/material.dart';

import '../../HomeScreen.dart';
import 'my_cards_screen.dart';

class CashWithdrawlAmount extends StatefulWidget {
  String? tran_Id;
  String? TRANSACTION_AMT;
  String? tran_Date;
  String? tran_Time;
  String? cus_Acct_Num;
  String? acct_Type;
  String? remarks;
  String? balAftTrn;
  String? remarks1;

  CashWithdrawlAmount(
      this.tran_Id,
      this.TRANSACTION_AMT,
      this.tran_Date,
      this.tran_Time,
      this.cus_Acct_Num,
      this.acct_Type,
      this.remarks,
      this.balAftTrn,
      this.remarks1);

  @override
  _CashWithdrawlAmountState createState() => _CashWithdrawlAmountState();
}

class _CashWithdrawlAmountState extends State<CashWithdrawlAmount> {
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
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text("Cash Withdrawl Amount"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Table(
                  defaultColumnWidth: FixedColumnWidth(200),
                  children: [
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Transaction ID_Date:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 95.0),
                                // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                                child: Text(
                                  widget.tran_Id! + "_",
                                  textScaleFactor: 1.3,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 90.0),
                                child: Text(
                                  widget.tran_Date!,
                                  textScaleFactor: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Account Number:",
                          textScaleFactor: 1.3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.cus_Acct_Num!,
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Amount Withdrawn:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.TRANSACTION_AMT!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Balance After Transaction:",
                          textScaleFactor: 1.3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.balAftTrn!,
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Mode of Transaction:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "BY CASH",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Transaction Processing Date:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.tran_Date!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Transaction Processing Time:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.tran_Time!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Transaction Type:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.remarks!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.grey[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Mode of Withdrawal",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.remarks1!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ])
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            elevation: 5.0,
                            textStyle: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Georgia",
                                letterSpacing: 1),
                            backgroundColor: Color(0xFFCC0000),
                            primary: Colors.white),
                        child: Text('PRINT', style: TextStyle(fontSize: 16)),
                        onPressed: () async {
                          List<String> basicInformation = <String>[];
                          List<String> Dummy = <String>[];
                          //List<OfficeDetail> office=await OfficeDetail().select().toList();
                          final ofcMaster =
                              await OFCMASTERDATA().select().toList();
                          final soltb =
                              await TBCBS_SOL_DETAILS().select().toList();
                          // basicInformation.add('NEW ACCOUNT OPENING');
                          // basicInformation.add(' ');
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
                          basicInformation.add('Transaction ID_Date:');
                          basicInformation
                              .add(widget.tran_Id! + "_" + widget.tran_Date!);
                          basicInformation.add('Account Number:');
                          basicInformation.add(widget.cus_Acct_Num!.toString());
                          basicInformation.add('Amount Withdrawn:');
                          basicInformation
                              .add(widget.TRANSACTION_AMT!.toString());
                          basicInformation.add('Account Balance:');
                          basicInformation.add(widget.balAftTrn!.toString());
                          basicInformation.add('Mode of Transaction:');
                          basicInformation.add("BY CASH");
                          basicInformation.add('Mode of Withdrawal:');
                          basicInformation.add("${widget.remarks1}");
                          Dummy.clear();
                          PrintingTelPO printer = new PrintingTelPO();
                          bool value = await printer.printThroughUsbPrinter(
                              "CBS",
                              "Withdrawl",
                              basicInformation,
                              basicInformation,
                              1);
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            elevation: 5.0,
                            textStyle: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Georgia",
                                letterSpacing: 1),
                            backgroundColor: Color(0xFFCC0000),
                            primary: Colors.white),
                        child: Text('Back', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainHomeScreen(MyCardsScreen(false), 1)),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
