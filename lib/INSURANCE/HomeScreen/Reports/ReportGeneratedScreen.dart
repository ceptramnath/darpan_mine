import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
//import 'package:darpan_mine/Utils/Printing_onePrint.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

import '../HomeScreen.dart';
import 'ReportsScreen.dart';

class ReportGeneratedScreen extends StatefulWidget {
  String reportType;
  String transType;
  String date;

  ReportGeneratedScreen(this.reportType, this.transType, this.date);

  @override
  _ReportGeneratedScreenState createState() => _ReportGeneratedScreenState();
}

class _ReportGeneratedScreenState extends State<ReportGeneratedScreen> {
  List<DAY_TRANSACTION_REPORT> transactions = [];
  List<DAY_INDEXING_REPORT> indexing = [];
  List<DAILY_INDEXING_REPORT> pliindexing = [];
  List<DAILY_INDEXING_REPORT> rpliindexing = [];
  List<DAY_TRANSACTION_REPORT> plisummary = [];
  List<DAY_TRANSACTION_REPORT> rplisummary = [];
  Future? getData;
  int totamount = 0;
  int success = 0;
  int failed = 0;
  int pending = 0;
  double cashfirstsgst = 0.0;
  double cashsecondsgst = 0.0;
  double cashfirstcgst = 0.0;
  double cashsecondcgst = 0.0;
  double chequefirstsgst = 0.0;
  double chequesecondsgst = 0.0;
  double chequefirstcgst = 0.0;
  double chequesecondcgst = 0.0;
  double cashfirstprem = 0.0;
  double cashsecondprem = 0.0;
  double chequesecondprem = 0.0;
  double chequefirstprem = 0.0;
  int cashtot = 0;
  int chequetot = 0;
  double cashrebate = 0.0;
  double chequerebate = 0.0;
  late String trans;

  List<DAY_TRANSACTION_REPORT> firstcash = [];
  List<DAY_TRANSACTION_REPORT> secondcash = [];
  List<DAY_TRANSACTION_REPORT> firstchq = [];
  List<DAY_TRANSACTION_REPORT> secondchq = [];

  @override
  void initState() {
    getData = getDB();
  }

  getDB() async {
    totamount = 0;
    success = 0;
    failed = 0;
    pending = 0;
    String d = widget.date.toString();
    transactions =
        await DAY_TRANSACTION_REPORT().select().TRAN_DATE.equals(d).toList();
    indexing =
        await DAY_INDEXING_REPORT().select().CREATED_DATE.equals(d).toList();
    pliindexing = await DAILY_INDEXING_REPORT()
        .select()
        .POLICY_TYPE
        .equals("PLI")
        .toList();
    rpliindexing = await DAILY_INDEXING_REPORT()
        .select()
        .POLICY_TYPE
        .equals("RPLI")
        .toList();
    plisummary = await DAY_TRANSACTION_REPORT()
        .select()
        .CREATED_DATE
        .equals(d)
        .and
        .POLICY_TYPE
        .equals("PLI")
        .toList();
    rplisummary = await DAY_TRANSACTION_REPORT()
        .select()
        .CREATED_DATE
        .equals(d)
        .and
        .POLICY_TYPE
        .equals("RPLI")
        .toList();

    if (widget.transType == "RPLI") {
      trans = "RPL";
    } else
      trans = "PLI";

    for (int i = 0; i < transactions.length; i++) {
      print(transactions[i].AMOUNT);
      if(transactions[i].STATUS=="SUCCESS" || transactions[i].STATUS=="Success") {
        totamount = totamount +
            int.parse(transactions[i].AMOUNT.toString().split(".")[0]);
      }
      // print("Total Amount");
      // print(totamount);
    }
    List<DAY_TRANSACTION_REPORT> transtatus =
        await DAY_TRANSACTION_REPORT().select().TRAN_DATE.equals(d).toList();
    for (int i = 0; i < transtatus.length; i++) {
      if (transtatus[i].STATUS == "PENDING") {
        pending = pending + 1;
      } else if (transtatus[i].STATUS == "FAILED") {
        failed = failed + 1;
      } else if (transtatus[i].STATUS == "SUCCESS" || transactions[i].STATUS=="Success") {
        success = success + 1;
      }
    }
print("Reached till firstcash");
    firstcash = await DAY_TRANSACTION_REPORT()
        .select()
        .PAYMENT_CATEGORY
        .equals("F")
        .and
        .startBlock
        .TRAN_DATE
        .equals(d)
        .and
        .PAYMENT_MODE
        .equals("CASH")
        .and
        .POLICY_TYPE
        .equals(trans).and.STATUS.equals("SUCCESS")
        .endBlock
        .toList();
    print("Reached till secondcash");
    secondcash = await DAY_TRANSACTION_REPORT()
        .select()
        .PAYMENT_CATEGORY
        .equals("R")
        .and
        .startBlock
        .TRAN_DATE
        .equals(d)
        .and
        .PAYMENT_MODE
        .equals("CASH")
        .and
        .POLICY_TYPE
        .equals(trans).and.STATUS.equals("SUCCESS")
        .endBlock
        .toList();
    print("Reached till firstchq");
    firstchq = await DAY_TRANSACTION_REPORT()
        .select()
        .PAYMENT_CATEGORY
        .equals("F")
        .and
        .startBlock
        .TRAN_DATE
        .equals(d)
        .and
        .PAYMENT_MODE
        .equals("CHEQUE")
        .and
        .POLICY_TYPE
        .equals(trans).and.STATUS.equals("SUCCESS")
        .endBlock
        .toList();
    print("Reached till secondchq");
    secondchq = await DAY_TRANSACTION_REPORT()
        .select()
        .PAYMENT_CATEGORY
        .equals("R")
        .and
        .startBlock
        .TRAN_DATE
        .equals(d)
        .and
        .PAYMENT_MODE
        .equals("CHEQUE")
        .and
        .POLICY_TYPE
        .equals(trans).and.STATUS.equals("SUCCESS")
        .endBlock
        .toList();
    print(firstcash.length);
    print(secondcash.length);
    print(firstchq.length);
    print(secondchq.length);

    for (int i = 0; i < firstcash.length; i++) {
      print("Inside For Loop");
      print(i);
      print(firstcash[i].PREM_AMNT);
      print(double.parse(firstcash[i].PREM_AMNT!));
      print(firstcash[i].SGST!);
      print(firstcash[i].CGST!);
      print( double.parse(firstcash[i].SGST!));
      print( double.parse(firstcash[i].CGST!));
      print(cashfirstprem);
      cashfirstprem = cashfirstprem + double.parse(firstcash[i].PREM_AMNT!);
      cashfirstsgst = cashfirstsgst + double.parse(firstcash[i].SGST!);
      cashfirstcgst = cashfirstcgst + double.parse(firstcash[i].CGST!);
      print(cashfirstprem);
    }
    print(cashfirstprem);
    for (int i = 0; i < secondcash.length; i++) {
      cashsecondprem = cashsecondprem + double.parse(secondcash[i].PREM_AMNT!);
      cashsecondsgst = cashsecondsgst + double.parse(secondcash[i].SGST!);
      cashsecondcgst = cashsecondcgst + double.parse(secondcash[i].CGST!);
    }
    print(cashsecondprem);
    for (int i = 0; i < firstchq.length; i++) {
      chequefirstprem = chequefirstprem + double.parse(firstchq[i].PREM_AMNT!);
      chequefirstsgst = chequefirstsgst + double.parse(firstchq[i].SGST!);
      chequefirstcgst = chequefirstcgst + double.parse(firstchq[i].CGST!);
    }
    print(chequefirstprem);
    for (int i = 0; i < secondchq.length; i++) {
      chequesecondprem =
          chequesecondprem + double.parse(secondchq[i].PREM_AMNT!);
      chequefirstsgst = chequefirstsgst + double.parse(secondchq[i].SGST!);
      chequefirstcgst = chequefirstcgst + double.parse(secondchq[i].CGST!);
    }
    print(chequesecondprem);
print("Reached till cashtot");
    cashtot = (cashfirstprem +
            cashfirstsgst +
            cashfirstcgst +
            cashsecondprem +
            cashsecondsgst +
            cashsecondsgst)
        .round();
    chequetot = (chequefirstprem +
            chequefirstsgst +
            chequefirstcgst +
            chequesecondprem +
            chequesecondcgst +
            chequesecondsgst)
        .round();

    return transactions;
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
            title: Text(
              "${widget.reportType}",
            ),
            backgroundColor: ColorConstants.kPrimaryColor,
          ),
          body: FutureBuilder(
              future: getData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (widget.reportType == "Day End Collection Report")
                          if (transactions.length > 0)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Text("Day End Collection Report"),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Table(
                                    defaultColumnWidth: IntrinsicColumnWidth(),
                                    border: TableBorder.all(),
                                    children: [
                                      TableRow(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "No.",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Trans date",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Pol/Prop No.",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Amt.",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Type",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Status",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      for (int i = 0;
                                          i < transactions.length;
                                          i++)
                                        TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              (i + 1).toString(),
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${transactions[i].TRAN_DATE.toString()}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child:transactions[i].PROPOSAL_NUM==null? Text(
                                              "${transactions[i].POLICY_NO} ",
                                              style: TextStyle(fontSize: 12),
                                            ):Text(
                                                  "${transactions[i].PROPOSAL_NUM} ",
                                                  style: TextStyle(fontSize: 12),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${transactions[i].AMOUNT}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${transactions[i].POLICY_TYPE}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${transactions[i].STATUS}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                        ]),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Total Deposit Amount:    \u{20B9}$totamount "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Total Successful Transactions:    $success "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Total Pending Transactions:    $pending "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Total Failed Transactions:    $failed "),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                      child: Text("PRINT"),
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Color(0xFFCC0000)),
                                      onPressed: () async{



                                        List<String> basicInformation = <String>[];
                                        List<String> Dummy = <String>[];
                                        //List<OfficeDetail> office=await OfficeDetail().select().toList();
                                        final ofcMaster =
                                            await OFCMASTERDATA().select().toList();

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
                                        basicInformation.add('Report Date');
                                        basicInformation
                                            .add(widget.date);
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        basicInformation.add('S.No Rpt No Pol/Prop No. Status Amount');
                                        basicInformation.add('');
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        for(int i=0;i<transactions.length;i++){
                                          if(transactions[i].STATUS=="SUCCESS"){transactions[i].STATUS="S";}
                                          else if(transactions[i].STATUS=="PENDING"){transactions[i].STATUS="P";}
                                          else if(transactions[i].STATUS=="FAILED"){transactions[i].STATUS="F";}
                                          basicInformation.add('${i+1} ${transactions[i].RECEIPT_NO} ${transactions[i].PROPOSAL_NUM==null?transactions[i].POLICY_NO:transactions[i].PROPOSAL_NUM} ${transactions[i].STATUS!} ${transactions[i].AMOUNT!}');
                                          basicInformation.add('');
                                        }
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        basicInformation.add("Total Deposit Amount");
                                        basicInformation.add("${totamount}");
                                        basicInformation.add("Total Successful Transactions");
                                        basicInformation.add("${success}");
                                        basicInformation.add("Total Pending Transactions");
                                        basicInformation.add("${pending}");
                                        basicInformation.add("Total Failed Transactions");
                                        basicInformation.add("${failed}");
                                        basicInformation.add("----------------");
                                        basicInformation.add("----------------");
                                        Dummy.clear();
                                        PrintingTelPO printer = new PrintingTelPO();
                                        bool value = await printer.printThroughUsbPrinter(
                                            "INSURANCE",
                                            "Day End Collection Report-Transactions",
                                            basicInformation,
                                            basicInformation,
                                            1);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          else
                            Center(
                              child: Text("No Transactions to Display"),
                            )
                        else if (widget.reportType == "Daily Indexing Report")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                        "Daily Indexing Report- ${widget.transType}"),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                if (widget.transType == "Transactions")
                                  if (indexing.length > 0)
                                    Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Center(child: Text("No.")),
                                          Center(child: Text("Rcpt No.")),
                                          Center(child: Text("Pol/Prop No.")),
                                          Center(child: Text("Type")),
                                        ]),
                                        // TableRow(
                                        //     children: [
                                        //       Center(child: Text("1")),
                                        //       Center(child: Text("123124")),
                                        //       Center(child: Text("45545454")),
                                        //       Center(child: Text("M")),
                                        //     ]
                                        // ),
                                        // TableRow(
                                        //     children: [
                                        //       Center(child: Text("2")),
                                        //       Center(child: Text("322")),
                                        //       Center(child: Text("32432")),
                                        //       Center(child: Text("R")),
                                        //     ]
                                        // ),
                                        // TableRow(
                                        //     children: [
                                        //       Center(child: Text("3")),
                                        //       Center(child: Text("3443434")),
                                        //       Center(child: Text("4233626")),
                                        //       Center(child: Text("R")),
                                        //     ]
                                        // ),
                                        for (int i = 0;
                                            i < indexing.length;
                                            i++)
                                          TableRow(children: [
                                            Center(
                                                child:
                                                    Text((i + 1).toString())),
                                            Center(
                                                child: Text(indexing[i]
                                                    .RECEIPT_NO
                                                    .toString())),
                                            Center(
                                              child: Text(indexing[i]
                                                  .PROPOSAL_NUM
                                                  .toString()),
                                            ),
                                            Center(
                                                child: Text(indexing[i]
                                                    .POLICY_TYPE
                                                    .toString())),
                                          ])
                                      ],
                                    )
                                  else if (widget.transType == "PLI")
                                    Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Center(child: Text("Request Type.")),
                                          Center(child: Text("Number.")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("New Proposal")),
                                          Center(
                                              child: Text(pliindexing.length
                                                  .toString())),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Maturity Claim")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Loan")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(
                                              child: Text("Survival Benefit")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Surrender")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Revival")),
                                          Center(child: Text("0")),
                                        ]),
                                      ],
                                    )
                                  else if (widget.transType == "RPLI")
                                    Table(
                                      border: TableBorder.all(),
                                      children: [
                                        TableRow(children: [
                                          Center(child: Text("Request Type.")),
                                          Center(child: Text("Number.")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("New Proposal")),
                                          Center(
                                              child: Text(rpliindexing.length
                                                  .toString())),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Maturity Claim")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Loan")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(
                                              child: Text("Survival Benefit")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Surrender")),
                                          Center(child: Text("0")),
                                        ]),
                                        TableRow(children: [
                                          Center(child: Text("Revival")),
                                          Center(child: Text("0")),
                                        ]),
                                      ],
                                    ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    child: Text("PRINT"),
                                    style: TextButton.styleFrom(
                                        onSurface: Colors.white,
                                        backgroundColor: Color(0xFFCC0000)),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                          )
                        else if (widget.reportType == "Daily Summary Report")
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Text(
                                        "Daily Summary Report- ${widget.transType}"),
                                    alignment: Alignment.center,
                                  ),
                                ),

                                // if(widget.transType == "PLI")
                                Table(
                                  border: TableBorder.all(),
                                  children: [
                                    TableRow(children: [
                                      Center(child: Text("Receipts")),
                                      Center(child: Text("CASH")),
                                      Center(child: Text("CHEQUE")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("First Year")),
                                      Center(child: Text("$cashfirstprem")),
                                      Center(child: Text("$chequefirstprem")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Second Year")),
                                      Center(child: Text("$cashsecondprem")),
                                      Center(child: Text("$chequesecondprem")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Renewal Premium")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Revival Premium")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Default realized")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                    // TableRow(
                                    //     children: [
                                    //       Center(child: Text(
                                    //           "Loan Prinicpal")),
                                    //       Center(child: Text("")),
                                    //       Center(child: Text("")),
                                    //     ]
                                    // ),
                                    // TableRow(
                                    //     children: [
                                    //       Center(
                                    //           child: Text("Loan Intt.")),
                                    //       Center(child: Text("")),
                                    //       Center(child: Text("")),
                                    //     ]
                                    // ),
                                    TableRow(children: [
                                      Center(
                                          child: Text(
                                              "First Year CGST Collected")),
                                      Center(child: Text("$cashfirstcgst")),
                                      Center(child: Text("$chequefirstcgst")),
                                    ]),
                                    TableRow(children: [
                                      Center(
                                          child: Text(
                                              "First Year SGST Collected")),
                                      Center(child: Text("$cashfirstsgst")),
                                      Center(child: Text("$chequefirstsgst")),
                                    ]),
                                    TableRow(children: [
                                      Center(
                                          child: Text(
                                              "First Year UTGST Collected")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Renewal Year CGST")),
                                      Center(child: Text("$cashsecondcgst")),
                                      Center(child: Text("$chequesecondcgst")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Renewal Year SGST")),
                                      Center(child: Text("$cashsecondsgst")),
                                      Center(child: Text("$chequesecondcgst")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Renewal Year UTGST")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                    // TableRow(
                                    //     children: [
                                    //       Center(child: Text(
                                    //           "Miscalleneous")),
                                    //       Center(child: Text("")),
                                    //       Center(child: Text("")),
                                    //     ]
                                    // ),
                                    // TableRow(
                                    //     children: [
                                    //       Center(child: Text(
                                    //           "Special Group")),
                                    //       Center(child: Text("")),
                                    //       Center(child: Text("")),
                                    //     ]
                                    // ),
                                    TableRow(children: [
                                      Center(child: Text("Total")),
                                      Center(child: Text("$cashtot")),
                                      Center(child: Text("$chequetot")),
                                    ]),
                                    TableRow(children: [
                                      Center(child: Text("Rebate Allowed")),
                                      Center(child: Text("")),
                                      Center(child: Text("")),
                                    ]),
                                  ],
                                ),
                                // else
                                //   if(widget.transType == "RPLI")
                                //     Table(
                                //       border: TableBorder.all(),
                                //       children: [
                                //         TableRow(
                                //             children: [
                                //               Center(
                                //                   child: Text("Receipts")),
                                //               Center(child: Text("CASH")),
                                //               Center(child: Text("CHEQUE")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "First Year")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Second Year")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Renewal Premium")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Revival Premium")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Default realized")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Loan Prinicpal")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Loan Intt.")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "First Year CGST Collected")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "First Year SGST Collected")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "First Year UTGST Collected")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Renewal Year CGST")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Renewal Year SGST")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Renewal Year UTGST")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Miscalleneous")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Special Group")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text("Total")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //         TableRow(
                                //             children: [
                                //               Center(child: Text(
                                //                   "Rebate Allowed")),
                                //               Center(child: Text("")),
                                //               Center(child: Text("")),
                                //             ]
                                //         ),
                                //
                                //       ],
                                //     ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    child: Text("PRINT"),
                                    style: TextButton.styleFrom(
                                        onSurface: Colors.white,
                                        backgroundColor: Color(0xFFCC0000)),
                                    onPressed: () {},
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                }
              })),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ReportsScreen()),
        (route) => false);
  }
}
