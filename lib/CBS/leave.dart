import 'dart:math';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/MainScreen.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';

import '../HomeScreen.dart';

class leaveScreen extends StatefulWidget {
  @override
  _leaveScreenState createState() => _leaveScreenState();
}

class _leaveScreenState extends State<leaveScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.red,
        appBar: AppAppBar(title: 'Leave'),
        body: SingleChildScrollView(
            child: Column(children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: _applyColor,
                child: FlatButton(
                    child: Text("Apply Leave"),
                    // shape: RoundedRectangleBorder(
                    //     side: BorderSide(color: Colors.red.shade900, width: 2),
                    // ),
                    onPressed: () {
                      _cancelColor = Colors.red;
                      _applyColor = Colors.deepOrange;
                      setState(() {
                        isapplyleave = true;
                        iscancelleave = false;
                        isTableVisible = false;
                      });
                    }),
              )),
              Expanded(
                  child: Container(
                color: _cancelColor,
                child: FlatButton(
                    child: Text("Cancel Leave"),
                    onPressed: () async {
                      _cancelColor = Colors.deepOrange;
                      _applyColor = Colors.red;
                      //   LeaveDetails = await LEAVE_DETAILS().select().GDS_ID.equals(gdsID.text).toList();

                      // LeaveDetails = await LEAVE_DETAILS().select().toList();
                      setState(() {
                        isapplyleave = false;
                        iscancelleave = true;
                      });
//                         LeaveDetails = await LEAVE_DETAILS().select().GDS_ID.equals(gdsID.text).toList();
// if(LeaveDetails.isNotEmpty){
//   setState(() {
//     isapplyleave=false;
//     iscancelleave=true;
//   });
//
// }
// else{
//   isapplyleave=false;
//   showDialog(context: context, builder: (BuildContext context){return AlertDialog(content: Text('No Data Found' ),);});
// }
//
                    }),
              )),
            ],
          ),
          SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListTile(
          //     title: const Text(
          //       "GDS ID",
          //       style: TextStyle(color: Colors.red, fontSize: 12.0),
          //     ),
          //     subtitle: TextField(
          //       controller: gdsID,
          //       style: TextStyle(fontSize: 18.0),
          //       keyboardType: TextInputType.number,
          //     ),
          //   ),
          // ),
          Visibility(
            visible: isapplyleave,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "GDS ID*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: gdsID,
                      autofocus: true,
                      maxLength: 8,
                      decoration: InputDecoration(
                        hintText: 'Enter the ID',

                        // errorText: gdsID.text.length<8 ? 'GDSID entered is less than 8 digits' : gdsID.text,
                        errorText: _gdsIDvalidate ? 'ID Can\'t Be empty' : null,
                      ),

                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.number,
//onChanged: (gdsID)=> gdsID.isEmpty ? _gdsIDvalidate = true : _gdsIDvalidate = false,
// onSubmitted:(gdsID)=>  showDialog(context: context, builder: (BuildContext context){return AlertDialog(content: Text('Please Enter Valid GDS ID' ),);}),
                    ),
                  ),
                ),
                //  //const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, right: 8.0, left: 20.0, bottom: 8.0),
                  child: Row(
                    children: [
                      Text("Gender*"),
                      RadioGroup<String>.builder(
                        direction: Axis.horizontal,
                        groupValue: _selectedGender,
                        onChanged: (value) => setState(() {
                          _selectedGender = value!;
                        }),
                        items: gender,
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                    ],
                  ),
                ),
                // const ListTile(
                //   title: Text(
                //     "Gender",
                //     style: TextStyle(color: Colors.red, fontSize: 12.0),
                //   ),
                //   subtitle: Text(
                //     "+977 9818225533",
                //     style: TextStyle(fontSize: 18.0),
                //   ),
                // ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, right: 8.0, left: 20.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // _selectedProduct=="PLI"?DropdownButton(items: pliproducts.map<DropdownMenuItem<String>>(String value){return DropDownMenuItem<String>(value:value,child:Text(value));}).toList());, onChanged: onChanged)
                      _selectedGender == "Male"
                          ? Container(
                              width: MediaQuery.of(context).size.width * .60,
                              height: 50,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Type of Leave",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  alignment: Alignment.center,
                                  value: dropdownvaluemale,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  style: TextStyle(color: Colors.blueGrey),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    leaveSelectedValue = newValue;
                                    setState(() {
                                      dropdownvaluemale = newValue!;
                                    });
                                  },
                                  items: maleLeave
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * .60,
                              height: 50,
                              // decoration: BoxDecoration(  borderRadius: BorderRadius.all(Radius.circular(5.w)),
                              //   border: Border.all(color: Colors.blueGrey, width: 1.0.w), ),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: "Type of Leave*",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  value: dropdownvaluerfemale,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  underline: Container(),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
                                  onChanged: (String? newValue) {
                                    leaveSelectedValue = newValue;
                                    setState(() {
                                      dropdownvaluerfemale = newValue!;
                                    });
                                  },
                                  items: femaleLeave
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
                // const ListTile(
                //   title: Text(
                //     "Type of Leave",
                //     style: TextStyle(color: Colors.red, fontSize: 12.0),
                //   ),
                //
                //   subtitle: Padding(
                //     padding: EdgeInsets.all(8.0),
                //     child: Text(
                //       "@ramkumar",
                //       style: TextStyle(fontSize: 18.0),
                //     ),
                //   ),
                // ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Reason*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: reason,
                      autofocus: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Leave Balance",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: leaveBalance,
                      readOnly: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: fromdate,
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
                            labelText: "From Date",
                            hintText: "Enter Date",
                            errorText: _fromdatevalidate
                                ? 'Please select from date'
                                : null,
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1)),
                            // contentPadding: EdgeInsets.only(
                            //     top: 20, bottom: 20, left: 20, right: 20),
                          ),
                        ),
                      ),
                    ),
                    //const Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: todate,
                          style: TextStyle(color: Colors.blueGrey),
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_today_outlined,
                              ),
                              onPressed: () {
                                _selectDailytoTranReportDate(context);
                              },
                            ),
                            labelText: "To Date",
                            hintText: "Enter Date",
                            errorText: _todatevalidate
                                ? 'Please select to date'
                                : null,

                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey, width: 1)),
                            // contentPadding: EdgeInsets.only(
                            //     top: 20, bottom: 20, left: 20, right: 20),
                          ),
                          validator: (value) {
                            if (value != todate.text) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Employee address1*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: empAdd1controller,
                      autofocus: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Employee address2*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: empAdd2controller,
                      autofocus: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute ID(Aadhar ID)*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subsIDcontroller,
                      maxLength: 12,
                      autofocus: true,
                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute Name*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subsNamecontroller,
                      autofocus: true,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute Address1*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subsAdd1controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        errorText: _subsAdd1validate
                            ? 'Address Can\'t Be empty'
                            : null,
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute Address2*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subAdd2controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        errorText: _subsAdd2validate
                            ? 'Address Can\'t Be empty'
                            : null,
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute Age*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subsAgecontroller,
                      autofocus: true,
                      maxLength: 2,
                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText:
                            "Age cannot be less than 18 and cannot be greater than 65.",
                        hintStyle: TextStyle(fontSize: 10),
                        errorText:
                            _subsAgevalidate ? 'Age Can\'t Be empty' : null,
                      ),
                    ),
                  ),
                ),
                //const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "Substitute Qualification*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: subsQuacontroller,
                      autofocus: true,
                      decoration: InputDecoration(
                        errorText: _subsQuavalidate
                            ? 'Qualification Can\'t Be empty'
                            : null,
                      ),
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),

                //const Divider(),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          child: const Text('Reset',
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
                            setState(() {
                              fromdate.clear();
                              todate.clear();
                              gdsID.clear();
                              reason.clear();
                              leaveBalance.clear();
                              empAdd1controller.clear();
                              empAdd2controller.clear();
                              subsIDcontroller.clear();
                              subsNamecontroller.clear();
                              subsAdd1controller.clear();
                              subAdd2controller.clear();
                              subsAgecontroller.clear();
                              subsQuacontroller.clear();
                            });
                          }),
                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                          child: const Text('Apply leave ',
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
                            setState(() {
                              gdsID.text.isEmpty
                                  ? _gdsIDvalidate = true
                                  : _gdsIDvalidate = false;
                              reason.text.isEmpty
                                  ? _reasonvalidate = true
                                  : _reasonvalidate = false;
                              empAdd1controller.text.isEmpty
                                  ? _empAdd1validate = true
                                  : _empAdd1validate = false;
                              empAdd2controller.text.isEmpty
                                  ? _empAdd2validate = true
                                  : _empAdd2validate = false;
                              subsIDcontroller.text.isEmpty
                                  ? _subsIDvalidate = true
                                  : _subsIDvalidate = false;
                              subsNamecontroller.text.isEmpty
                                  ? _subsNamevalidate = true
                                  : _subsNamevalidate = false;
                              subsAdd1controller.text.isEmpty
                                  ? _subsAdd1validate = true
                                  : _subsAdd1validate = false;
                              subAdd2controller.text.isEmpty
                                  ? _subsAdd2validate = true
                                  : _subsAdd2validate = false;
                              subsAgecontroller.text.isEmpty
                                  ? _subsAgevalidate = true
                                  : _subsAgevalidate = false;
                              subsQuacontroller.text.isEmpty
                                  ? _subsQuavalidate = true
                                  : _subsQuavalidate = false;
                              fromdate.text.isEmpty
                                  ? _fromdatevalidate = true
                                  : _fromdatevalidate = false;
                              todate.text.isEmpty
                                  ? _todatevalidate = true
                                  : _todatevalidate = false;
                            });

                            if (gdsID.text.length < 8) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content:
                                            Text('Please enter valid GDS ID'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              //Put your code here which you want to execute on Cancel button click.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]);
                                  });
                            } else if (fromdate.text.compareTo(todate.text) >
                                0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Text(
                                            'Please Select Valid From Date,From Date should be less than To Date'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              //Put your code here which you want to execute on Cancel button click.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]);
                                  });
                            } else if (todate.text.compareTo(fromdate.text) <
                                0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Text(
                                            'Please Select Valid From Date,To Date should not be less than From Date'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              //Put your code here which you want to execute on Cancel button click.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]);
                                  });
                            } else {
                              reqNum = GenerateRandomString()
                                  .randomNumber()
                                  .toString();
                              final tranDetails = LEAVE_DETAILS()
                                ..GDS_ID = gdsID.text
                                ..REQUEST_ID = reqNum
                                ..GENDER = _selectedGender
                                ..LEAVE_FROM_DATE = fromdate.text
                                ..LEAVE_TO_DATE = todate.text
                                ..TYPE_OF_LEAVE = leaveSelectedValue
                                ..EMP_ADDRESS1 = empAdd1controller.text
                                ..EMP_ADDRESS2 = empAdd2controller.text
                                ..SUBSTITUTE_ID = subsIDcontroller.text
                                ..SUBSTITUTE_NAME = subsNamecontroller.text
                                ..SUBSTITUTE_ADDRESS1 = subsAdd1controller.text
                                ..SUBSTITUTE_ADDRESS2 = subAdd2controller.text
                                ..SUBSTITUTE_AGE = subsAgecontroller.text
                                ..STATUS = "Success"
                                ..SUBSTITUTE_QUALIFICATION =
                                    subsQuacontroller.text;

                              tranDetails.save();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Do you want to Print the Receipt?'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("OK"),
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      content: Text(
                                                          'Leave Applied Successfully  with request ID $reqNum'),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            child: Text("OK"),
                                                            onPressed:
                                                                () async {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MailsMainScreen()));
                                                            }),
                                                      ]);
                                                });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("CANCEL"),
                                          onPressed: () {
                                            //Put your code here which you want to execute on Cancel button click.
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                            //               {
                            //                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
                            //                 showDialog(context: context,
                            //                 builder: (BuildContext context){
                            // return AlertDialog(
                            // content: Text('Leave Applied Successfully',textAlign: TextAlign.center,style: TextStyle(color: Colors.red), ),
                            // );});
                            //
                            // }
                          }

                          // setState(() {
                          //   gdsID.text.isEmpty ? _emptyvalidate = true : _emptyvalidate = false;
                          //   gdsID.text.isEmpty ? _maxvalidate = true : _maxvalidate = false;
                          // });

                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: iscancelleave,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: const Text(
                      "GDS ID*",
                      style: TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                    subtitle: TextField(
                      controller: gdsID,
                      autofocus: true,
                      maxLength: 8,
                      decoration: InputDecoration(
                        hintText: 'Enter the ID',
                        errorText: _gdsIDvalidate ? 'ID Can\'t Be empty' : null,
                        suffixIcon: _getClearButton(),
                        // errorText: gdsID.text.length<8 ? 'GDSID entered is less than 8 digits' : gdsID.text,
                        // errorText: _emptyvalidate ? 'Value Can\'t Be Empty' : null,
                      ),

                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.number,

// onSubmitted:(gdsID)=>  showDialog(context: context, builder: (BuildContext context){return AlertDialog(content: Text('Please Enter Valid GDS ID' ),);}),
                    ),
                  ),
                ),
                RaisedButton(
                    child: const Text('Submit ',
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
                      setState(() {
                        gdsID.text.isEmpty
                            ? _gdsIDvalidate = true
                            : _gdsIDvalidate = false;
                      });
                      if (gdsID.text.length < 8) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Text('Please enter valid GDS ID'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        //Put your code here which you want to execute on Cancel button click.
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            });
                      } else {
                        final test = await LEAVE_DETAILS().select().toList();
                        //  await LEAVE_DETAILS().select().delete();
                        LeaveDetails = await LEAVE_DETAILS()
                            .select()
                            .GDS_ID
                            .equals(gdsID.text)
                            .toList();
                        //   LeaveDetails = await LEAVE_DETAILS().select().toList();
                        if (LeaveDetails.isNotEmpty) {
                          setState(() {
                            iscancelleave = false;
                            isTableVisible = true;
                          });
                        } else {
                          iscancelleave = false;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    content: Text('No Data Found'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          //Put your code here which you want to execute on Cancel button click.
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]);
                              });
                        }
                      }
                    })
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isTableVisible,
              child: Column(children: [
                //SizedBox(height: 10,),
                Text('Leave Details',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                // SizedBox(height: 10,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Container(width: 400, child: _createDataTable()),
                ),
              ]))
        ])));
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
