import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
//import 'package:darpan_mine/Utils/Printing_onePrint.dart';

import 'package:darpan_mine/Utils/Printing.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import '../../HomeScreen.dart';
import 'my_cards_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'pdfdatrep.dart';

class DatReport extends StatefulWidget {
  @override
  _DatReportState createState() => _DatReportState();
}

class _DatReportState extends State<DatReport> {
  int selected = 0;
  var _currentDate = DateTimeDetails().currentDate();
  var _selectedDate = " ";

  // bool isVisible = false;
  bool isDataTableVisible = false;
  bool isAllDataTableVisible = false;
  final amountTextController = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  bool _showClearButton = true;
  List<TBCBS_TRAN_DETAILS> cbsDetails = [];
  int i = 0;
  int deposit1 = 0;
  int withdrawal1 = 0;
  int depositslNo1 = 0;
  int withdrawalslNo1 = 0;

  String? schtype;
  TextEditingController date = TextEditingController();
  List<String> accounts = ["SB", "RD", "TD", "SSA", "ALL"];
  String _selectedAccount = "SB";

  // final bool showCheckboxColumn=false;
  String? deposit;
  String? withdrawal;
  bool _isTotal = false;

//  bool _isDepositTotal=false;
  // bool _isWithdrawalTotal=false;
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
            'Daily Transaction Report',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: const Color(0xFFB71C1C),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: (Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: date
                          ..text =
                              _selectedDate == " " ? _currentDate : _selectedDate,
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
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 3)),
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
                    width: MediaQuery.of(context).size.width * .3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        alignment: Alignment.center,
                        value: _selectedAccount,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                        decoration: InputDecoration(
                          labelText: "Account Type",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            print(_selectedAccount);
                            _selectedAccount = newValue!;
                            isDataTableVisible = false;
                            isAllDataTableVisible = false;
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
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text('SUBMIT', style: TextStyle(fontSize: 16)),
                color: Color(0xFFB71C1C),
                //Colors.green,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  print(MediaQuery.of(context).size.width * .5);
                  if (_selectedAccount == "ALL") {
                    cbsDetails = await TBCBS_TRAN_DETAILS()
                        .select()
                        .TRAN_DATE
                        .equals(date.text)
                        .toList();

                    setState(() {
                      // selected = index;
                      // print(selected);
                      isAllDataTableVisible = true;
                    });
                  } else {
                    String textChanged = _selectedAccount;
                    switch (textChanged) {
                      case "SB":
                        textChanged = "SB";
                        print("SB changed");
                        break;
                      // case "SBBAS":
                      //   textChanged = "SBBAS";
                      //   print("SB BAS changed");
                      //   break;
                      case "RD":
                        textChanged = "RD";
                        print("RD changed");
                        break;
                      case "TD":
                        textChanged = "TD";
                        print("TD changed");
                        break;
                      case "SSA":
                        textChanged = "SSA  ";
                        print("SSA changed");
                        break;
                    }
                    // cbsDetails = await TBCBS_TRAN_DETAILS().select().TRAN_DATE.equals(date.text).and.startBlock.ACCOUNT_TYPE.equals(textChanged).and.STATUS.equals("SUCCESS").endBlock.toList();
                    cbsDetails = await TBCBS_TRAN_DETAILS()
                        .select()
                        .TRAN_DATE
                        .equals(date.text)
                        .and
                        .ACCOUNT_TYPE
                        .startsWith(textChanged.trim())// Added by Rakesh on 19112022 to get only success tran
                        //  .and
                        //  .STATUS
                        // .equals("SUCCESS")
                        .toList();
                    print("123");
                    print("Length of CBS Details: ${cbsDetails.length}");
                    for (i = 0; i < cbsDetails.length; i++) {
                      schtype = cbsDetails[i].ACCOUNT_TYPE;
                    }

                    // if (schtype == textChanged) {
                    //   setState(() {
                    //     // selected = index;
                    //     // print(selected);
                    //     isDataTableVisible = true;
                    //   });
                    // }

                    if (cbsDetails.length>0) {
                      print("456");
                      setState(() {
                        // selected = index;
                        // print(selected);
                        isDataTableVisible = true;
                      });
                    }

                    else {
                      setState(() {
                        isDataTableVisible = false;
                      });
                      UtilFs.showToast("No Records Found", context);
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: isDataTableVisible,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      //SizedBox(height: 10,),
                      Text('Daily Transaction Report',
                          style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                      // SizedBox(height: 10,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: _createDataTable(),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText:
                              "Total Deposit Amount= " + deposit1.toString(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Total Withdrawal Amount= " +
                              withdrawal1.toString(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: isAllDataTableVisible,
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      //SizedBox(height: 10,),
                      Text('Daily Transaction Report',
                          style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                      // SizedBox(height: 10,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: _createAllDataTable(),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText:
                              "Total Deposit Amount= " + deposit1.toString(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Total Withdrawal Amount= " +
                              withdrawal1.toString(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (isDataTableVisible == true || isAllDataTableVisible==true)
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            child: Text('PRINT', style: TextStyle(fontSize: 16)),
                            color: Color(0xFFB71C1C),
                            //Colors.green,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // onPressed: _createPDF,
                            onPressed:() async{
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
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              basicInformation.add('S.No. A/c No.');
                              basicInformation.add('Type Status Amount');
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              for(int i=0;i<cbsDetails.length;i++){
                                basicInformation.add('${i+1} ${cbsDetails[i].REFERENCE_NO == null
                                    ? cbsDetails[i].CUST_ACC_NUM!
                                    : cbsDetails[i].REFERENCE_NO!}.');
                                basicInformation.add('${cbsDetails[i].TRAN_TYPE!} ${cbsDetails[i].STATUS!} ${cbsDetails[i].TRANSACTION_AMT!}');
                              }
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              basicInformation.add("Total Deposit Amount");
                              basicInformation.add("${deposit1}");
                              basicInformation.add("Total Withdrawal Amount");
                              basicInformation.add("${withdrawal1}");
                              basicInformation.add("Deposits Count");
                              basicInformation.add("${depositslNo1}");
                              basicInformation.add("Withdrawals Count");
                              basicInformation.add("${withdrawalslNo1}");
                              basicInformation.add("----------------");
                              basicInformation.add("----------------");
                              Dummy.clear();
                              PrintingTelPO printer = new PrintingTelPO();
                              bool value = await printer.printThroughUsbPrinter(
                                  "CBS",
                                  "Daily Transaction Report-$_selectedAccount Accounts",
                                  basicInformation,
                                  basicInformation,
                                  1);

                            }
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          RaisedButton(
                            child: Text('CANCEL', style: TextStyle(fontSize: 16)),

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
                                      builder: (context) => MainHomeScreen(
                                          MyCardsScreen(false), 1)),
                                  (route) => false);
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ])),
          ),
        ),
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
          myController.clear()
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
          _selectedDate = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createAllColumns(),
      rows: _createAllRows(),
      columnSpacing: 0,
    );
  }

  DataTable _createAllDataTable() {
    return DataTable(
      columns: _createAllColumns(),
      rows: _createAllRows(),
      columnSpacing: 0,
    );
  }





  List<DataRow> _createAllRows() {
    // int deposit1=0;
    // int withdrawal1=0;
    // int depositslNo1=0;
    // int withdrawalslNo1=0;

    final rows = <DataRow>[];
    deposit1 = 0;
    withdrawal1 = 0;
    depositslNo1 = 0;
    withdrawalslNo1 = 0;
    for (int i = 0; i < cbsDetails.length; i++) {
      String defaultFee;
      (cbsDetails[i].DEFAULT_FEE==null||  cbsDetails[i].DEFAULT_FEE=="")?defaultFee="0":defaultFee=cbsDetails[i].DEFAULT_FEE!;

      if ((cbsDetails[i].TRAN_TYPE == "D" || cbsDetails[i].TRAN_TYPE == "O") &&
          cbsDetails[i].STATUS != "FAILED") {
        deposit1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + deposit1;
        depositslNo1 = depositslNo1 + 1;
        print(cbsDetails[i].REFERENCE_NO);
      } else if (cbsDetails[i].TRAN_TYPE == "W" &&
          cbsDetails[i].STATUS != "FAILED") {
        withdrawal1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + withdrawal1;
        withdrawalslNo1 = withdrawalslNo1 + 1;
      }
      rows.add(
        DataRow(cells: [
          DataCell(Text((i + 1).toString())),
          cbsDetails[i].TRANSACTION_ID!.startsWith("S")
              ? DataCell(Text(cbsDetails[i].TRANSACTION_ID!))
              : DataCell(Text("")),
          cbsDetails[i].REFERENCE_NO == null
              ? DataCell(Text(cbsDetails[i].CUST_ACC_NUM!))
              : DataCell(Text(cbsDetails[i].REFERENCE_NO!)),
          // DataCell(Text(cbsDetails[i].ACCOUNT_TYPE!)),
          _selectedAccount=="TD"?DataCell(Text(cbsDetails[i].ACCOUNT_TYPE!+"-"+cbsDetails[i].TENURE!)):DataCell(Text(cbsDetails[i].ACCOUNT_TYPE!)),
          DataCell(Center(child: Text((double.parse(cbsDetails[i].TRANSACTION_AMT!)-double.parse(defaultFee)).toString()))),
          (_selectedAccount=="RD" || _selectedAccount=="SSA")?   DataCell(Center(child: Text(defaultFee))):DataCell(Center(child: SizedBox.shrink())),
          DataCell(Text(cbsDetails[i].TRAN_TYPE!)),
          // DataCell(Text(cbsDetails[i].REMARKS!=null?"":cbsDetails[i].REMARKS!)),
          cbsDetails[i].REMARKS == null
              ? DataCell(Text(""))
              : DataCell(Text(cbsDetails[i].REMARKS!)),
          // DataCell(Text("")),
          DataCell(Text(cbsDetails[i].STATUS!)),
        ]),
      );
    }
    rows.add(
      DataRow(cells: [
        DataCell(Text("")),
        DataCell(Text(depositslNo1.toString() + " Deposits  +")),
        //  DataCell(Text("Total\nDeposit\nAmount="+deposit1.toString())),
        DataCell(Text(withdrawalslNo1.toString() + " Withdrawals")),
        // DataCell(Text("Total\n Withdrawal\nAmount="+withdrawal1.toString())),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
      ]),
    );
    return rows;
  }

  List<DataColumn> _createAllColumns() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return [
      DataColumn(
          label: Container(
        width: width * 0.07,
        child: Text('Sl\nNo'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.22,
        child: Text('Transaction\n     _ID'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.22,
        child: Text('Account\nNumber'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.15,
        child: Text('Scheme\nType'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.15,
        child: Text('Amount'),
      )),
      (_selectedAccount=="RD" || _selectedAccount=="SSA")?
      DataColumn(
          label: Container(
            width: width * 0.15,
            child: Text('Default\nAmount'),
          )):
      DataColumn(
          label: Container(
            width: width * 0.15,
            child: SizedBox.shrink(),
          )),
      DataColumn(
          label: Container(
        width: width * 0.2,
        child: Text('Remarks'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.2,
        child: Text('Withdrawal \n Mode'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.2,
        child: Text('Transaction\nStatus'),
      )),

      // DataColumn(label: Text('Transaction\n_ID')),
      // DataColumn(label: Text('Account\nNumber')),
      // DataColumn(label: Text('Amount')),
      // DataColumn(label: Text('Remarks'))
    ];
  }



// List<DataRow> _createRows() {
//   // int deposit1=0;
//   // int withdrawal1=0;
//   // int depositslNo1=0;
//   // int withdrawalslNo1=0;
//
//   final rows = <DataRow>[];
//   deposit1 = 0;
//   withdrawal1 = 0;
//   depositslNo1 = 0;
//   withdrawalslNo1 = 0;
//   for (int i = 0; i < cbsDetails.length; i++) {
//     if ((cbsDetails[i].TRAN_TYPE == "D" || cbsDetails[i].TRAN_TYPE == "O") &&
//         cbsDetails[i].STATUS != "FAILED") {
//       deposit1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + deposit1;
//       depositslNo1 = depositslNo1 + 1;
//     } else if (cbsDetails[i].TRAN_TYPE == "W" &&
//         cbsDetails[i].STATUS != "FAILED") {
//       withdrawal1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + withdrawal1;
//       withdrawalslNo1 = withdrawalslNo1 + 1;
//     }
//     rows.add(
//       DataRow(cells: [
//         DataCell(Text((i + 1).toString())),
//         cbsDetails[i].TRANSACTION_ID!.startsWith("S")
//             ? DataCell(Text(cbsDetails[i].TRANSACTION_ID!))
//             : DataCell(Text("")),
//         cbsDetails[i].REFERENCE_NO == null
//             ? DataCell(Text(cbsDetails[i].CUST_ACC_NUM!))
//             : DataCell(Text(cbsDetails[i].REFERENCE_NO!)),
//         DataCell(Center(child: Text(cbsDetails[i].TRANSACTION_AMT!))),
//         DataCell(Text(cbsDetails[i].TRAN_TYPE!)),
//         DataCell(Text(cbsDetails[i].STATUS!)),
//       ]),
//     );
//   }
//   rows.add(
//     DataRow(cells: [
//       DataCell(Text("")),
//       DataCell(Text(depositslNo1.toString() + " Deposits  +")),
//
//       //  DataCell(Text("Total\nDeposit\nAmount="+deposit1.toString())),
//       DataCell(Text(withdrawalslNo1.toString() + " Withdrawals")),
//       // DataCell(Text("Total\n Withdrawal\nAmount="+withdrawal1.toString())),
//       DataCell(Text("")),
//       DataCell(Text("")),
//       DataCell(Text("")),
//     ]),
//   );
//   return rows;
// }

  // Future<void> _createPDF() async {
  //   PdfDocument document = PdfDocument();
  //   final page = document.pages.add();
  //   PdfGrid grid = PdfGrid();
  //   grid.columns.add(count: 6);
  //   grid.headers.add(1);
  //   PdfGridRow header = grid.headers[0];
  //   grid.columns[0].width = 50;
  //   grid.columns[1].width = 120;
  //   grid.columns[2].width = 120;
  //   grid.columns[3].width = 70;
  //   grid.columns[4].width = 70;
  //   grid.columns[5].width = 100;
  //   header.height = 25;
  //   header.cells[0].value = 'SlNo';
  //   header.cells[1].value = 'Transaction_ID';
  //   header.cells[2].value = 'AccountNumber';
  //   header.cells[3].value = 'Amount';
  //   header.cells[4].value = 'Remarks';
  //   header.cells[5].value = 'Transaction Status';
  //   header.cells[0].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   header.cells[1].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   header.cells[2].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   header.cells[3].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   header.cells[4].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   header.cells[5].style = PdfGridCellStyle(
  //       font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //       format: PdfStringFormat(
  //           alignment: PdfTextAlignment.center,
  //           lineAlignment: PdfVerticalAlignment.middle,
  //           wordSpacing: 10));
  //   deposit1 = 0;
  //   withdrawal1 = 0;
  //   depositslNo1 = 0;
  //   withdrawalslNo1 = 0;
  //   for (int i = 0; i < cbsDetails.length; i++) {
  //     PdfGridRow row = grid.rows.add();
  //     row.height = 25;
  //     if (cbsDetails[i].TRAN_TYPE == "D" && cbsDetails[i].STATUS != "FAILED") {
  //       deposit1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + deposit1;
  //       depositslNo1 = depositslNo1 + 1;
  //     } else if (cbsDetails[i].TRAN_TYPE == "W" &&
  //         cbsDetails[i].STATUS != "FAILED") {
  //       withdrawal1 = int.parse(cbsDetails[i].TRANSACTION_AMT!) + withdrawal1;
  //       withdrawalslNo1 = withdrawalslNo1 + 1;
  //     }
  //     row.cells[0].value = (i + 1).toString();
  //     row.cells[1].value = cbsDetails[i].TRANSACTION_ID!.startsWith("S")
  //         ? cbsDetails[i].TRANSACTION_ID!
  //         : "";
  //     row.cells[2].value = cbsDetails[i].CUST_ACC_NUM!;
  //     row.cells[3].value = cbsDetails[i].TRANSACTION_AMT!;
  //     row.cells[4].value = cbsDetails[i].TRAN_TYPE!;
  //     row.cells[5].value = cbsDetails[i].STATUS!;
  //     row.cells[0].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //     row.cells[1].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //     row.cells[2].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //     row.cells[3].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //     row.cells[4].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //     row.cells[5].style = PdfGridCellStyle(
  //         font: PdfStandardFont(PdfFontFamily.helvetica, 15),
  //         format: PdfStringFormat(
  //             alignment: PdfTextAlignment.center,
  //             lineAlignment: PdfVerticalAlignment.middle,
  //             wordSpacing: 10));
  //   }
  //   int tableheight = (cbsDetails.length * 30);
  //   PdfTextElement(
  //           text: 'Department of Posts-India\n',
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 30))
  //       .draw(page: page, bounds: Rect.fromLTRB(80, 0, 0, 0));
  //   PdfTextElement(
  //           text: 'Office of the  BO\n',
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 33))
  //       .draw(page: page, bounds: Rect.fromLTRB(20, 40, 0, 0));
  //   PdfTextElement(
  //           text: 'Daily Transaction Report of $_selectedAccount dated ' +
  //               date.text,
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 23))
  //       .draw(page: page, bounds: Rect.fromLTRB(0, 100, 0, 0));
  //   grid.draw(page: page, bounds: const Rect.fromLTWH(0, 140, 0, 0));
  //   PdfTextElement(
  //           text: depositslNo1.toString() +
  //               " Deposits + " +
  //               withdrawalslNo1.toString() +
  //               " Withdrawals\n",
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 20))
  //       .draw(page: page, bounds: Rect.fromLTRB(0, (tableheight + 180), 0, 0));
  //   PdfTextElement(
  //           text: "Total Deposit Amount= " + deposit1.toString(),
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 20))
  //       .draw(page: page, bounds: Rect.fromLTRB(0, (tableheight + 210), 0, 0));
  //   PdfTextElement(
  //           text: "Total Withdrawal Amount= " + withdrawal1.toString(),
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 20))
  //       .draw(page: page, bounds: Rect.fromLTRB(0, (tableheight + 240), 0, 0));
  //   PdfTextElement(
  //           text: 'Branch PostMaster',
  //           font: PdfStandardFont(PdfFontFamily.helvetica, 23))
  //       .draw(
  //           page: page, bounds: Rect.fromLTRB(320, (tableheight + 270), 0, 0));
  //   PdfTextElement(
  //           text: ' BO', font: PdfStandardFont(PdfFontFamily.helvetica, 23))
  //       .draw(
  //           page: page, bounds: Rect.fromLTRB(320, (tableheight + 300), 0, 0));
  //
  //   List<int> bytes = document.save();
  //   document.dispose();
  //   saveAndLaunchFile(bytes, 'Output.pdf');
  // }
// List<DataColumn> _createColumns() {
//   final double width = MediaQuery.of(context).size.width;
//   final double height = MediaQuery.of(context).size.height;
//   return [
//     DataColumn(
//         label: Container(
//       width: width * 0.07,
//       child: Text('Sl\nNo'),
//     )),
//     DataColumn(
//         label: Container(
//       width: width * 0.22,
//       child: Text('Transaction\n     _ID'),
//     )),
//     DataColumn(
//         label: Container(
//       width: width * 0.22,
//       child: Text('Account\nNumber'),
//     )),
//     DataColumn(
//         label: Container(
//       width: width * 0.15,
//       child: Text('Amount'),
//     )),
//     DataColumn(
//         label: Container(
//       width: width * 0.2,
//       child: Text('Remarks'),
//     )),
//     DataColumn(
//         label: Container(
//       width: width * 0.2,
//       child: Text('Transaction\nStatus'),
//     )),
//
//     // DataColumn(label: Text('Transaction\n_ID')),
//     // DataColumn(label: Text('Account\nNumber')),
//     // DataColumn(label: Text('Amount')),
//     // DataColumn(label: Text('Remarks'))
//   ];
// }
}
