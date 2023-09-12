
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../UtilitiesMainScreen.dart';
import 'LeaveApplication.dart';
import 'LeaveCancel.dart';

class leaveManagement extends StatefulWidget {
  @override
  _leaveManagementState createState() => _leaveManagementState();
}

class _leaveManagementState extends State<leaveManagement>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  bool _showClearButton = true;
  List<String> gender = ["Male", "Female"];
  String _selectedGender = "Male";
  List<String> maleLeave = [
    "GDS-PAID LEAVE",
    "GDS_LWA",
    "GDS-SPECIAL PAID LEAVE"
  ];
  List<String> femaleLeave = [
    "GDS-PAID LEAVE",
    "GDS_LWA",
    "GDS-SPECIAL PAID LEAVE",
    "GDS-MATERNITY LEAVE"
  ];
  String dropdownvaluemale = "GDS-PAID LEAVE";
  String dropdownvaluerfemale = "GDS-PAID LEAVE";
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  TextEditingController gdsID = TextEditingController();
  TextEditingController reason = TextEditingController();
  TextEditingController leaveBalance = TextEditingController();
  TextEditingController empAdd1controller = TextEditingController();
  TextEditingController empAdd2controller = TextEditingController();
  TextEditingController subsIDcontroller = TextEditingController();
  TextEditingController subsNamecontroller = TextEditingController();
  TextEditingController subsAdd1controller = TextEditingController();
  TextEditingController subAdd2controller = TextEditingController();
  TextEditingController subsAgecontroller = TextEditingController();
  TextEditingController subsQuacontroller = TextEditingController();
  bool _gdsIDvalidate = false;
  bool _reasonvalidate = false;
  bool _validate = false;
  bool _empAdd1validate = false;
  bool _empAdd2validate = false;
  bool _subsIDvalidate = false;
  bool _subsNamevalidate = false;
  bool _subsAdd1validate = false;
  bool _subsAdd2validate = false;
  bool _subsAgevalidate = false;
  bool _subsQuavalidate = false;
  bool _fromdatevalidate = false;
  bool _todatevalidate = false;

  String? reqNum;
  final rowddel = <DataRow>[];
  String? index;
  MaterialColor _applyColor = Colors.red;
  MaterialColor _cancelColor = Colors.red;
  String? reqID;
  String? fromDate;
  String? toDate;
  String? leaveType;

//bool isrowvisible=true;
  bool isapplyleave = false;
  bool isTableVisible = false;
  bool iscancelleave = false;
  List<LEAVE_DETAILS> LeaveDetails = [];

//  List<LEAVE_DETAILS> delLeaveDetails = [];
  String? leaveSelectedValue = "GDS-PAID LEAVE";
  final RegExp regexp = RegExp(r'^[0-9]{8}$');

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => UtilitiesMainScreen()),
              (route) => false);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Leave Management"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => UtilitiesMainScreen()),
                  (route) => false),
            ),
            backgroundColor: ColorConstants.kPrimaryColor,
            bottom: TabBar(
              controller: _controller,
              indicator: CircleTabIndicator(color: Colors.white, radius: 3),
              tabs: const [
                Tab(
                  child: TabTextStyle(
                    title: 'Apply',
                  ),
                ),
                Tab(
                  child: TabTextStyle(
                    title: 'Cancel',
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _controller,
            children: [leaveApplication(), leaveCancel()],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDailyTranReportDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          fromdate.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectDailytoTranReportDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          todate.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  DataTable _createDataTable() {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(),
      columnSpacing: 0,
    );
  }

  List<DataColumn> _createColumns() {
    final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery
    //     .of(context)
    //     .size
    //     .height;
    return [
      DataColumn(
          label: Container(
        width: width * 0.05,
        child: Text('Sl\nNo'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.17,
        child: Text('Request\n     _ID'),
      )),
      DataColumn(
          label: Container(
        width: width * 0.20,
        child: Text(
          'From\nDate',
          textAlign: TextAlign.center,
        ),
      )),
      DataColumn(
          label: Container(
        width: width * 0.20,
        child: Text(
          'To\nDate',
          textAlign: TextAlign.center,
        ),
      )),
      DataColumn(
          label: Container(
        width: width * 0.10,
        child: Text(
          'Leave\nType',
          textAlign: TextAlign.start,
        ),
      )),
      //    DataColumn(label:Container(width:width*0.10,child:Text("Edit"),)),
      DataColumn(
          label: Container(
        width: width * 0.2,
        child: Text("Delete"),
      ))
      //  DataColumn(label: Container(width: width * 0.2, child: Text('Status'),)),

      // DataColumn(label: Text('Transaction\n_ID')),
      // DataColumn(label: Text('Account\nNumber')),
      // DataColumn(label: Text('Amount')),
      // DataColumn(label: Text('Remarks'))
    ];
  }

  List<DataRow> _createRows() {
    // int deposit1=0;
    // int withdrawal1=0;
    // int depositslNo1=0;
    // int withdrawalslNo1=0;
    final rows = <DataRow>[];

    for (int i = 0; i < LeaveDetails.length; i++) {
      reqID =
          LeaveDetails[i].REQUEST_ID == null ? "" : LeaveDetails[i].REQUEST_ID!;
      fromDate = LeaveDetails[i].LEAVE_FROM_DATE == null
          ? ""
          : LeaveDetails[i].LEAVE_FROM_DATE!;
      toDate = LeaveDetails[i].LEAVE_TO_DATE == null
          ? ""
          : LeaveDetails[i].LEAVE_TO_DATE!;
      leaveType = LeaveDetails[i].TYPE_OF_LEAVE == null
          ? ""
          : LeaveDetails[i].TYPE_OF_LEAVE!;
      rows.add(
        DataRow(
            // selected: rowddel.contains(rows),
            //   onSelectChanged: (isSelected)=>setState(() {
            //     final isAdding=isSelected!=null&&isSelected;
            //   isAdding?rowddel.add(rows):rowddel.remove(rows);
            // var isdelete=isSelected;
            // isdelete= rowddel.remove(rows);
            //  }),
            cells: [
              DataCell(Text((i + 1).toString())),
              DataCell(Text(reqID!)),
              DataCell(Wrap(
                children: [Text(fromDate!)],
              )),
              DataCell(Wrap(
                children: [Text(toDate!)],
              )),
              DataCell(Wrap(
                children: [Text(leaveType!)],
              )),
              DataCell(
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.delete),
                  ), onTap: () async {
                // int j=i;
                // String? check=LeaveDetails[j].REQUEST_ID;
                //index=reqID;
                // await LEAVE_DETAILS().select().REQUEST_ID.equals(reqID).delete();
                var result = deleteLeave(LeaveDetails[i].REQUEST_ID);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: Text('Record deleted Successfully'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () async {
                                LeaveDetails = await LEAVE_DETAILS()
                                    .select()
                                    .GDS_ID
                                    .equals(gdsID.text)
                                    .toList();
                                //    LeaveDetails = await LEAVE_DETAILS().select().toList();
                                setState(() {
                                  iscancelleave = false;

                                  //  isTableVisible=true;
                                });
                                //Put your code here which you want to execute on Cancel button click.
                                Navigator.of(context).pop();
                              },
                            ),
                          ]);
                    });

                print(index);
                //print(check);
              })
            ]),
      );
    }

    return rows;
  }

  Future<bool> deleteLeave(String? requestId) async {
    await LEAVE_DETAILS().select().REQUEST_ID.equals(requestId).delete();

    return true;
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
          //   _isVisible=false;
          // }),
          gdsID.clear()
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
