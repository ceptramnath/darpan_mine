import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:flutter/material.dart';

import 'PremiumCollection.dart';

class dupReceipt extends StatefulWidget {
  List duplist;

  dupReceipt(this.duplist);

  @override
  _dupReceiptState createState() => _dupReceiptState();
}

class _dupReceiptState extends State<dupReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Duplicate Receipt Print',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: Color(0xFFB71C1C),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(border: TableBorder.all(), columnWidths: const {
                0: FlexColumnWidth(1.1),
                1: FlexColumnWidth(0.9)
              }, children: [
                TableRow(
                  children: [
                    const Text(
                      ' Receipt Number',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[20].toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Policy Holder Name',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[2],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Policy/Proposal Number',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[6],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Receipt Date',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[8],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Receipt Time',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[15],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      ' Paid From',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[18].toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      ' Paid Till',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[12],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'CGST',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[3],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'SGST',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[9],
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      ' Total GST',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[19].toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Premium Due Amount',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[16].toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                    ),
                    Text(
                      widget.duplist[13].toString(),
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ],
                ),
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    List<String> basicInformation = <String>[];
                    List<String> DummyList = <String>[];
                    // List<DAY_TRANSACTION_REPORT> printData = await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(main['item'][0]).toList();
                    List<OfficeDetail> office = await OfficeDetail().select().toList();
                    List<OFCMASTERDATA> userDetails = await OFCMASTERDATA().select().toList();

                    basicInformation.add('CSI BO ID');
                    basicInformation.add('${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                    basicInformation.add('Transaction Date');
                    basicInformation.add(widget.duplist[8]);
                    basicInformation.add('Transaction Time');
                    basicInformation.add(widget.duplist[15]);
                    basicInformation.add('Operator ID');
                    basicInformation.add('${userDetails[0].EMPID!}');
                    basicInformation.add('Operator Name');
                    basicInformation.add('${userDetails[0].EmployeeName!}');
                    basicInformation.add("Receipt Details:");
                    basicInformation.add("");
                    basicInformation.add("Policy Number");
                    basicInformation.add("${widget.duplist[6]}");
                    basicInformation.add("Insurant Name");
                    basicInformation.add(widget.duplist[2]);
                    // basicInformation.add("Product Name");
                    // basicInformation.add("${printData[0].}");
                    basicInformation.add("Receipt Number");
                    basicInformation.add("${widget.duplist[20]}");
                    basicInformation.add("From date");
                    basicInformation.add("${widget.duplist[18]}");
                    basicInformation.add("To date");
                    basicInformation.add("${widget.duplist[12]}");
                    basicInformation.add("Premium Due Amount");
                    basicInformation.add("${widget.duplist[16]}");
                    // basicInformation.add("Default");
                    // basicInformation.add("${printData[0].DEFAULT_FEE}");
                    // basicInformation.add("Rebate");
                    // basicInformation.add("${printData[0].REBATE}");
                    // basicInformation.add("Balance Amount");
                    // basicInformation.add("${printData[0].BAL_AMT}");
                    basicInformation.add("CGST");
                    basicInformation.add("${widget.duplist[3]}");
                    basicInformation.add("SGST/UGST");
                    basicInformation.add("${widget.duplist[9]}");
                    basicInformation.add("Total GST");
                    basicInformation.add("${widget.duplist[19]}");
                    basicInformation.add("Total Amount");
                    basicInformation.add("${widget.duplist[13]}");
                    // basicInformation.add("Payment Mode");
                    // cash==true? basicInformation.add("Cash"):basicInformation.add("Cheque");
                    DummyList.clear();
                    PrintingTelPO printer = new PrintingTelPO();
                    // bool value = await printer.printThroughUsbPrinter("Insurance", "${printData[0].POLICY_TYPE}" + "-" + "Renewal Premium Collection", basicInformation, DummyList, 1);
                    bool value = await printer.printThroughUsbPrinter("Insurance", "Duplicate Receipt", basicInformation, DummyList, 0);
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
                // TextButton(
                //   child: Text("CONTINUE"),
                //   style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                //   onPressed: () async {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumCollection()));
                //   },
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
