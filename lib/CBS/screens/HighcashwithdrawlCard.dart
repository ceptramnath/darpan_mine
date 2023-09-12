import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';

class HighCashWithdrawlEnquiry extends StatefulWidget {
  String? tran_Id;
  String? tran_Amt;
  String? tran_Date;
  String? tran_Time;
  String? cus_Acct_Num;
  String? acct_Type;
  String? remarks;
  String? balAftTrn;

  HighCashWithdrawlEnquiry(
      this.tran_Id,
      this.tran_Amt,
      this.tran_Date,
      this.tran_Time,
      this.cus_Acct_Num,
      this.acct_Type,
      this.remarks,
      this.balAftTrn);

  @override
  _HighCashWithdrawlEnquiryState createState() =>
      _HighCashWithdrawlEnquiryState();
}

class _HighCashWithdrawlEnquiryState extends State<HighCashWithdrawlEnquiry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            "Transaction ID_Date",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.tran_Id!,
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Account Number",
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
                            "Amount Deposited",
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Balance After Transaction",
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
                  const TableRow(
                      // decoration: BoxDecoration(color: Colors.grey[200]),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Mode of Transaction",
                            textScaleFactor: 1.3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
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
                            "Transaction Processing Date",
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
                            "Transaction Processing Time",
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
                            "Transaction Type",
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
            ],
          ),
        ),
      ),
    );
  }
}
