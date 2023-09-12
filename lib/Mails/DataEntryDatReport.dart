import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';

import '../../HomeScreen.dart';
import '../UtilitiesMainScreen.dart';
import 'Data entry daily report.dart';

class DataEntryDatReport extends StatefulWidget {
  String? tran_date;
  String? deposit;
  String? depositAmount;
  String? withdraw;
  String? withdrawAmount;

  @override



  @override
  _DataEntryDatReportState createState() => _DataEntryDatReportState();
}

class _DataEntryDatReportState extends State<DataEntryDatReport> {
  List<DataEntry_DETAILS> DEDbDetails_dcube = [];
  List<DataEntry_DETAILS> DEDbDetails_csc = [];
  List<DataEntry_DETAILS> DEDbDetails_others = [];
  Future? getDetails;
  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        // MaterialPageRoute(
        //     builder: (context) => MainHomeScreen(UtilitiesMainScreen(), 0)),
        // (route) => false);
    MaterialPageRoute(
        builder: (context) => MainHomeScreen(DataEntry(), 0)),
    (route) => false);
  }
  void initState()  {
    print("getting data");
    getDetails = getdata();

  }
  getdata() async{
    DEDbDetails_dcube= await DataEntry_DETAILS()
        .select().TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate()).and.ENTRY_TYPE.equals("DCube")
        .toList();
    if(DEDbDetails_dcube.isNotEmpty)
   print(DEDbDetails_dcube[0].TOTAL_WITHDRAWAL_AMOUNT);
    DEDbDetails_csc= await DataEntry_DETAILS()
        .select().TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate()).and.ENTRY_TYPE.equals("CSC")
       .toList();
    if(DEDbDetails_csc.isNotEmpty)
   print(DEDbDetails_csc[0].TOTAL_DEPOSIT_AMOUNT);
    DEDbDetails_others= await DataEntry_DETAILS()
        .select().TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate()).and.ENTRY_TYPE.equals("Others")
        .toList();
    if(DEDbDetails_others.isNotEmpty)
    print(DEDbDetails_others[0]);
    return 0;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: FutureBuilder(
      future: getDetails,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data);
      if (snapshot.data == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
       return Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text("Data Entry Details"),
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
                  border: TableBorder(horizontalInside: BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid),
                      verticalInside:  BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)),
                  children: [
                    //Date
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
                              DateTimeDetails().onlyDatewithFormat(),
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Report type
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "DCUBE Details",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                // color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              "",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),

                    //Number of Withdrawl
                    TableRow(
                        // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total No.of Withdrawals:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              DEDbDetails_dcube.isNotEmpty ? DEDbDetails_dcube[0].TOTAL_WITHDRAWALS!:"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Total Withdrawl Amount
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
                              DEDbDetails_dcube.isNotEmpty? DEDbDetails_dcube[0].TOTAL_WITHDRAWAL_AMOUNT!:"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                     //Report type
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "CSC Details",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                // color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              "",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Number of Deposits
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total No.of Deposits:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              DEDbDetails_csc.isNotEmpty? DEDbDetails_csc[0].TOTAL_DEPOSITS!:"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Total Deposit Amount
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
                              DEDbDetails_csc.isNotEmpty ? DEDbDetails_csc[0].TOTAL_DEPOSIT_AMOUNT!:"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Report type
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Others Details",
                              textScaleFactor: 1.3,
                              style: TextStyle(
                                // color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              "",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Number of Deposits
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total No.of Deposits:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              DEDbDetails_others.isNotEmpty ? DEDbDetails_others[0].TOTAL_DEPOSITS! :"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Total Deposit Amount
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
                              DEDbDetails_others.isNotEmpty ? DEDbDetails_others[0].TOTAL_DEPOSIT_AMOUNT!: "",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Number of Withdrawl
                    TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[200]),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Total No.of Withdrawals:",
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            // child: Text("S${Random().nextInt(99999999).toString()}_\n${DateTimeDetails().cbsdate()}",textScaleFactor: 1.3,),
                            child: Text(
                              DEDbDetails_others.isNotEmpty ? DEDbDetails_others[0].TOTAL_WITHDRAWALS!:"",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ]),
                    //Total Withdrawl Amount
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
                              DEDbDetails_others.isNotEmpty ? DEDbDetails_others[0].TOTAL_WITHDRAWAL_AMOUNT!:"",
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
      );
      }
      }
      )
    );
  }
}
