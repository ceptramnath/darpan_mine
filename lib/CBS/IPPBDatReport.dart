import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';

import '../../HomeScreen.dart';
import '../UtilitiesMainScreen.dart';

class IPPBdatReport extends StatefulWidget {
  String? tran_date;
  String? deposit;
  String? depositAmount;
  String? withdraw;
  String? withdrawAmount;

  IPPBdatReport(this.tran_date, this.deposit, this.depositAmount, this.withdraw,
      this.withdrawAmount);

  @override
  _IPPBdatReportState createState() => _IPPBdatReportState();
}

class _IPPBdatReportState extends State<IPPBdatReport> {
  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UtilitiesMainScreen(), 0)),
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
          title: Text("IPPB Daily Transaction Report"),
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
                              "Transaction Date:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              widget.tran_date!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    // TableRow(
                    //     // decoration: BoxDecoration(color: Colors.blue[200]),
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           "Total No.of Deposits:",
                    //           textScaleFactor: 1.3,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                    //         child: Text(
                    //           widget.deposit!,
                    //           textScaleFactor: 1.3,
                    //         ),
                    //       ),
                    //     ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Deposit Amount:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              widget.depositAmount!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    // TableRow(
                    //     // decoration: BoxDecoration(color: Colors.blue[200]),
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Text(
                    //           "Total No.of Withdrawals:",
                    //           textScaleFactor: 1.3,
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                    //         child: Text(
                    //           widget.withdraw!,
                    //           textScaleFactor: 1.3,
                    //         ),
                    //       ),
                    //     ]),
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total Withdrawal Amount:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              widget.withdrawAmount!,
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
