import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/Utils/Printing_onePrint.dart';
import 'package:darpan_mine/Utils/Printing.dart';

import 'package:flutter/material.dart';

import '../../HomeScreen.dart';
import 'my_cards_screen.dart';

class CashDepositAmount extends StatefulWidget {
  String? tran_Id;
  String? tran_date;
  String? tran_Amt;
  String? tran_Date;
  String? tran_Time;
  String? cus_Acct_Num;
  String? acct_Type;
  String? remarks;
  String? balAftTrn;
  String? schtype;

  CashDepositAmount(this.tran_Id, this.tran_Amt, this.tran_Date, this.tran_Time,
      this.cus_Acct_Num, this.acct_Type, this.remarks, this.balAftTrn,this.schtype);

  @override
  _CashDepositAmountState createState() => _CashDepositAmountState();
}

class _CashDepositAmountState extends State<CashDepositAmount> {
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
          title: Text("Cash Deposit Amount"),
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
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                          // ),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            // textDirection: TextDirection.ltr,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 95.0),
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
                              "Amount Deposited:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.tran_Amt!,
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
                        ])
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)))),
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
                          basicInformation.add('Amount Deposited:');
                          basicInformation.add(widget.tran_Amt!.toString());
                          basicInformation.add('Balance After Transaction:');
                          basicInformation.add(widget.balAftTrn!.toString());
                          basicInformation.add('Mode of Transaction:');
                          basicInformation.add("BY CASH");
                          Dummy.clear();
                          PrintingTelPO printer = new PrintingTelPO();
                          bool value = await printer.printThroughUsbPrinter(
                              "CBS",
                              "Deposit-${widget.schtype}",
                              basicInformation,
                              basicInformation,
                              1);
                        },
                        child: Text('PRINT', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)))),
                        child: Text('BACK', style: TextStyle(fontSize: 16)),
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

class CashRDDepositAmount extends StatefulWidget {
  String? tran_Id;
  String? tran_date;
  String? tran_Amt;
  String? tran_Date;
  String? tran_Time;
  String? cus_Acct_Num;
  String? acct_Type;
  String? remarks;
  String? balAftTrn;
  String? instalmentAmount;
  String? noOfInstallments;
  String? rebateAmt;
  String? defaultFee;
  String? modeOfTran;
  String? schType;
  String? lastTrnDate;

  CashRDDepositAmount(
      this.tran_Id,
      this.tran_Amt,
      this.tran_Date,
      this.tran_Time,
      this.cus_Acct_Num,
      this.acct_Type,
      this.remarks,
      this.balAftTrn,
      this.instalmentAmount,
      this.noOfInstallments,
      this.rebateAmt,
      this.defaultFee,
      this.modeOfTran,
      this.schType,
      this.lastTrnDate);

  @override
  _CashRDDepositAmountState createState() => _CashRDDepositAmountState();
}

class _CashRDDepositAmountState extends State<CashRDDepositAmount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text("Cash RD Deposit Amount"),
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
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                        // ),
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          // textDirection: TextDirection.ltr,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 95.0),
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
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Last Installment Paid on:",
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.lastTrnDate!,
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
                            "Amount Deposited:",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.tran_Amt!,
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
                            'RD Deposit',
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
                            "Installment Amount:",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.instalmentAmount!,
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
                            "No.Of Installments:",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.noOfInstallments!,
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
                            "Default Fee:",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.defaultFee!,
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
                            "Rebate Amount:",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.rebateAmt!,
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
                      style: ButtonStyle(
                        // elevation:MaterialStateProperty.all(),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.grey)))),
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
                        basicInformation.add('Last installment Paid on:');
                        basicInformation.add(widget.lastTrnDate!.toString());
                        basicInformation.add('Amount Deposited:');
                        basicInformation.add(widget.tran_Amt!.toString());
                        basicInformation.add('Balance After Transaction:');
                        basicInformation.add(widget.balAftTrn!.toString());
                        basicInformation.add('Mode of Transaction:');
                        basicInformation.add("BY CASH");
                        basicInformation.add('Installment Amount:');
                        basicInformation.add("${widget.instalmentAmount}");
                        basicInformation.add('No of Installments:');
                        basicInformation.add("${widget.noOfInstallments}");
                        basicInformation.add('Default Fee:');
                        basicInformation.add("${widget.defaultFee}");
                        basicInformation.add('Rebate:');
                        basicInformation.add("${widget.rebateAmt}");
                        Dummy.clear();
                        PrintingTelPO printer = new PrintingTelPO();
                        bool value = await printer.printThroughUsbPrinter(
                            "CBS",
                            "Deposit-${widget.schType}",
                            basicInformation,
                            basicInformation,
                            1);


                      },
                      child: Text('PRINT', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        // elevation:MaterialStateProperty.all(),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.grey)))),
                      child: Text('BACK', style: TextStyle(fontSize: 16)),
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
    );
  }
}
