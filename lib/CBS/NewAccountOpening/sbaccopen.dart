import 'dart:io';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/NewAccountOpening/NewAccount.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../LogCat.dart';
import '../decryptHeader.dart';
import 'accopenMain.dart';

class SBAccountOpenMain extends StatefulWidget {
  String scheme;

  SBAccountOpenMain(this.scheme);

  @override
  _SBAccountOpenMainState createState() => _SBAccountOpenMainState();
}

class _SBAccountOpenMainState extends State<SBAccountOpenMain> {
  String? encheader;
  final _formKey = GlobalKey<FormState>();
  bool ssaguardivisble = false;
  bool _minorValue = false;
  bool _isJointVisible = false;
  bool _isMinorVisible = false;
  final cifTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final joint1cifTextController = TextEditingController();
  final joint1nameTextController = TextEditingController();
  final joint2cifTextController = TextEditingController();
  final joint2nameTextController = TextEditingController();
  final modeTextController = TextEditingController();
  final guardianCifTextController = TextEditingController();
  final guardianNameTextController = TextEditingController();
  final guardianRelationTextController = TextEditingController();
  final joint2relationTextController = TextEditingController();
  final joint1relationTextController = TextEditingController();
  final rdinstallmentController = TextEditingController();
  late Directory d;
  late String cachepath;
  TextEditingController date = TextEditingController();
  List<bool> isSelected = [true, false, false];

  List<TBCBS_TRAN_DETAILS> cbsAcctOpenDetails = [];
  List<TBCBS_TRAN_DETAILS> cbsMinorAcctOpenDetails = [];
  List<TBCBS_TRAN_DETAILS> cbsJointAcctOpenDetails = [];
  Map main = {};
  Map guardmain = {};
  var limits;
  late int minlimit;
 late int multiplier;

  @override
  void initState() {
    super.initState();
    getCacheDir();
    fetchlimits();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  fetchlimits() async {
    limits = await CBS_LIMITS_CONFIG().select().toMapList();
    return limits;
  }

  Future<void> _selectMinorDate(BuildContext context) async {
    try {
      DateTime now = new DateTime.now();
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year - 18, now.month, now.day),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          date.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectssaMinorDate(BuildContext context) async {
    try {
      DateTime now = new DateTime.now();
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year - 10, now.month, now.day),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          date.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String _verticalGroupValue = "Self";

  List<String> _status = ["Self", "Joint A", "Joint B"];

  String _minorSSAGroupValue = "Yes";

  List<String> _minorSSAValues = ["Yes"];
  bool _isLoading = false;

  String _minorGroupValue = "No";

  List<String> _minorValues = ["Yes", "No"];

  String _tdGroupValue = "1 Yr";
  List<String> _tdValues = ["1 Yr", "2 Yr", "3 Yr", "5 Yr"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: const Text(
          'New A/C Opening',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            FutureBuilder(
                future: fetchlimits(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text('Primary Account Holder Details',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.deepOrange)),
                          ),
                          // const SizedBox( height: 8,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .95,
                              height:
                                  MediaQuery.of(context).size.height * .111,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: cifTextController,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    // hintText: 'Enter CIF ID',
                                    labelText: 'Primary CIF ID',
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .95,
                              height:
                                  MediaQuery.of(context).size.height * .111,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: nameTextController,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  decoration: const InputDecoration(
                                    // hintText: 'Enter Name',
                                    labelText: 'Primary Account Holder Name',
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    // hintText: 'Enter CIF ID',
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (text) async {
                                    if (widget.scheme == "SSA") {
                                      setState(() {
                                        ssaguardivisble = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          widget.scheme == "SSA"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Is Minor',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    RadioGroup<String>.builder(
                                      horizontalAlignment:
                                          MainAxisAlignment.start,
                                      direction: Axis.horizontal,
                                      groupValue: _minorSSAGroupValue,
                                      onChanged: (value1) => setState(() {
                                        _minorGroupValue = value1!;
                                      }),
                                      items: _minorSSAValues,
                                      itemBuilder: (item) => RadioButtonBuilder(
                                        item,
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(' Is Minor',
                                          style: TextStyle(fontSize: 16)),
                                      RadioGroup<String>.builder(
                                        horizontalAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        direction: Axis.horizontal,
                                        groupValue: _minorGroupValue,
                                        onChanged: (value1) => setState(() {
                                          _minorGroupValue = value1!;
                                          if (_minorGroupValue == "Yes") {
                                            _isMinorVisible = true;
                                            _isJointVisible = false;
                                          } else {
                                            _isMinorVisible = false;
                                          }
                                        }),
                                        items: _minorValues,
                                        itemBuilder: (item) =>
                                            RadioButtonBuilder(
                                          item,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          widget.scheme == "SSA"
                              ? (nameTextController.text.length == 0
                                  ? Container()
                                  : Visibility(
                                      visible: ssaguardivisble,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              const Text('Enter Minor Details',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          Colors.deepOrange)),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .95,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .111,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      90.0)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _selectssaMinorDate(
                                                              context);
                                                        },
                                                        child: Container(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () =>
                                                                _selectMinorDate(
                                                                    context),
                                                            child:
                                                                IgnorePointer(
                                                              child:
                                                                  TextFormField(
                                                                validator:
                                                                    (value) {
                                                                  if (_isMinorVisible ==
                                                                          true ||
                                                                      widget.scheme ==
                                                                          "SSA") {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return 'Please Enter Minor DOB';
                                                                    }
                                                                    return null;
                                                                  }
                                                                },
                                                                controller:
                                                                    date,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            2,
                                                                            40,
                                                                            86),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                readOnly: true,
                                                                decoration:
                                                                    InputDecoration(
                                                                  prefixIcon:
                                                                      IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .calendar_today_outlined,
                                                                    ),
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                  labelText:
                                                                      "Enter Minor DOB",
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Color(0xFFCFB53B)),
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            2,
                                                                            40,
                                                                            86),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .95,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .111,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      90.0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          controller:
                                                              guardianCifTextController,
                                                          style: const TextStyle(
                                                              fontSize: 17,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      2,
                                                                      40,
                                                                      86),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          decoration:
                                                              const InputDecoration(
                                                            // hintText: 'Enter Guardian CIF ID',
                                                            labelText:
                                                                'Guardian CIF ID',
                                                            labelStyle: TextStyle(
                                                                color: Color(
                                                                    0xFFCFB53B)),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      2,
                                                                      40,
                                                                      86),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .95,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .111,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      90.0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (_isMinorVisible ==
                                                                    true ||
                                                                widget.scheme ==
                                                                    "SSA") {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please Enter Guardian name';
                                                              }
                                                              return null;
                                                            }
                                                          },
                                                          controller:
                                                              guardianNameTextController,
                                                          decoration:
                                                              const InputDecoration(
                                                            // hintText: 'Enter  Guardian Name',
                                                            labelText:
                                                                'Guardian Name',
                                                            labelStyle: TextStyle(
                                                                color: Color(
                                                                    0xFFCFB53B)),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      2,
                                                                      40,
                                                                      86),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .95,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .111,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      90.0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (_isMinorVisible ==
                                                                    true ||
                                                                widget.scheme ==
                                                                    "SSA") {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please Enter Guardian Relationship';
                                                              }
                                                              return null;
                                                            }
                                                          },
                                                          controller:
                                                              guardianRelationTextController,
                                                          decoration:
                                                              const InputDecoration(
                                                            hintText:
                                                                'Enter  Guardian Relation',
                                                            labelText:
                                                                'Guardian Relation',
                                                            labelStyle: TextStyle(
                                                                color: Color(
                                                                    0xFFCFB53B)),
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 15,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      2,
                                                                      40,
                                                                      86),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Visibility(
                                    visible: _isMinorVisible,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          const Text('Enter Minor Details',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.deepOrange)),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .95,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .111,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90.0)),
                                                  child: InkWell(
                                                    onTap: () {
                                                      _selectMinorDate(context);
                                                    },
                                                    child: Container(
                                                      child: GestureDetector(
                                                        onTap: () =>
                                                            _selectMinorDate(
                                                                context),
                                                        child: IgnorePointer(
                                                          child: TextFormField(
                                                            validator: (value) {
                                                              if (_isMinorVisible ==
                                                                  true) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please Enter Minor DOB';
                                                                }
                                                                return null;
                                                              }
                                                            },
                                                            controller: date,
                                                            style: const TextStyle(
                                                                fontSize: 17,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        2,
                                                                        40,
                                                                        86),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            readOnly: true,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .calendar_today_outlined,
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                              labelText:
                                                                  "Enter Minor DOB",
                                                              labelStyle: TextStyle(
                                                                  color: Color(
                                                                      0xFFCFB53B)),
                                                              hintStyle:
                                                                  TextStyle(
                                                                fontSize: 15,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        2,
                                                                        40,
                                                                        86),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .95,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .111,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      controller:
                                                          guardianCifTextController,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          color: Color.fromARGB(
                                                              255, 2, 40, 86),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      decoration:
                                                          const InputDecoration(
                                                        // hintText: 'Enter Guardian CIF ID',
                                                        labelText:
                                                            'Guardian CIF ID',
                                                        labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFFCFB53B)),
                                                        hintStyle: TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 2, 40, 86),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .95,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .111,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (_isMinorVisible ==
                                                            true) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please Enter Guardian name';
                                                          }
                                                          return null;
                                                        }
                                                      },
                                                      controller:
                                                          guardianNameTextController,
                                                      decoration:
                                                          const InputDecoration(
                                                        // hintText: 'Enter  Guardian Name',
                                                        labelText:
                                                            'Guardian Name',
                                                        labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFFCFB53B)),
                                                        hintStyle: TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 2, 40, 86),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .95,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .111,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90.0)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (_isMinorVisible ==
                                                            true) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please Enter Guardian Relationship';
                                                          }
                                                          return null;
                                                        }
                                                      },
                                                      controller:
                                                          guardianRelationTextController,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Enter  Guardian Relation',
                                                        labelText:
                                                            'Guardian Relation',
                                                        labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFFCFB53B)),
                                                        hintStyle: TextStyle(
                                                          fontSize: 15,
                                                          color: Color.fromARGB(
                                                              255, 2, 40, 86),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          widget.scheme == "RD"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Tenure: 5 Years",
                                      )),
                                )
                              : Container(),
                          widget.scheme == "RD"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        .95,
                                    height: MediaQuery.of(context).size.height *
                                        .111,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(90.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: rdinstallmentController,
                                        validator: (value) {
                                          print(limits.length);
                                          for (int i = 0;
                                              i < limits.length;
                                              i++) {
                                            print(limits[i]['type']);

                                            if (limits[i]['type'] ==
                                                "RD_ACCOPEN_minLimit") {
                                              minlimit = int.parse(
                                                  limits[i]['tranlimits']);
                                              // multiplier = int.parse(
                                              //     limits[i]['tranlimits']);
                                            }
                                            if (limits[i]['type'] ==
                                                'RD_Deposit_Multiplier') {
                                              print("Entered as RD deposit multiplier");
                                              multiplier =int.parse(
                                                  limits[i]['tranlimits']);
                                            }
                                            // print("Rd deposit multiplier");
                                            // print(multiplier);
                                          }
                                          print("Min Limit: $minlimit");
                                          print("Rd deposit multiplier");
                                          print(multiplier);
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter RD Installment Amount';
                                          } else if (int.parse(
                                                  rdinstallmentController.text
                                                      .toString()) <
                                              minlimit) {
                                            return 'RD Account opening Limit is $minlimit';
                                          } else if (int.parse(
                                                      rdinstallmentController
                                                          .text
                                                          .toString())
                                                  .remainder(multiplier) !=
                                              0) {
                                            return 'RD Account value should be in multiples of $multiplier';
                                          }

                                          return null;
                                        },
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
                                            fontWeight: FontWeight.w500),
                                        decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          border: InputBorder.none,
                                          // hintText: 'Enter CIF ID',
                                          labelText: 'Installment Amount',
                                          labelStyle: TextStyle(
                                              color: Color(0xFFCFB53B)),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          widget.scheme == "TD"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: RadioGroup<String>.builder(
                                      direction: Axis.horizontal,
                                      groupValue: _tdGroupValue,
                                      onChanged: (value) => setState(() {
                                        _tdGroupValue = value!;
                                      }),
                                      items: _tdValues,
                                      itemBuilder: (item) => RadioButtonBuilder(
                                        item,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          _isMinorVisible == false && widget.scheme != "SSA"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(' Mode of Operation:',
                                          style: TextStyle(fontSize: 16)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      // ToggleButtons(
                                      //   isSelected: isSelected,
                                      //   children: const <Widget>[
                                      //     Padding(
                                      //       padding: EdgeInsets.symmetric(horizontal: 12),
                                      //       child: Text('Self', style: TextStyle(fontSize: 16),),
                                      //     ),
                                      //     Padding(
                                      //       padding: EdgeInsets.symmetric(horizontal: 12),
                                      //       child: Text('Joint A', style: TextStyle(fontSize: 16),),
                                      //     ),
                                      //     Padding(
                                      //       padding: EdgeInsets.symmetric(horizontal: 12),
                                      //       child: Text('Joint B', style: TextStyle(fontSize: 16),),
                                      //     ),
                                      //   ],
                                      //   onPressed: (int newIndex){
                                      //     setState(() {
                                      //       for (int i =0;i<isSelected.length;i++) {
                                      //         if (i == newIndex) {
                                      //           isSelected[i]=true;
                                      //           modeTextController.text=isSelected[newIndex].toString();
                                      //           print(modeTextController.text);
                                      //         }
                                      //         else {
                                      //           isSelected[i]=false;
                                      //         }
                                      //         if(isSelected[0]==false){setState(() {
                                      //           _isJointVisible=true;
                                      //         });}
                                      //         //else{_isJointVisible=false;}
                                      //       }
                                      //     });
                                      //
                                      //   },
                                      // ),
                                      RadioGroup<String>.builder(
                                        direction: Axis.horizontal,
                                        groupValue: _verticalGroupValue,
                                        onChanged: (value) => setState(() {
                                          _verticalGroupValue = value!;
                                          if (_verticalGroupValue != "Self") {
                                            _isJointVisible = true;
                                          } else {
                                            _isJointVisible = false;
                                          }
                                        }),
                                        items: _status,
                                        itemBuilder: (item) =>
                                            RadioButtonBuilder(
                                          item,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _isJointVisible,
                            child: Center(
                              child: Container(
                                //    decoration: BoxDecoration(color: Colors.blue),
                                // constraints: BoxConstraints( double minWidth = 0.0,   double maxWidth = double.infinity,   double minHeight = 0.0,   double maxHeight = double.infinity,),
                                //   padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    const Text('Enter Joint Holder Details',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.deepOrange)),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      //    padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                controller:
                                                    joint1cifTextController,
                                                decoration:
                                                    const InputDecoration(
                                                  // hintText: 'Enter Joint holder1 CIF ID',
                                                  labelText:
                                                      'Joint holder1 CIF ID',

                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  validator: (value) {
                                                    if (_isJointVisible ==
                                                        true) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter Joint Holder Name';
                                                      }
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      joint1nameTextController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Enter Joint holder1 Name',
                                                    labelText:
                                                        'Joint holder1 Name',
                                                    // labelText: 'Guardian Relation',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[a-zA-Z]'))
                                                  ]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  validator: (value) {
                                                    if (_isJointVisible ==
                                                        true) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter Joint holder Relationship';
                                                      }
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      joint1relationTextController,
                                                  decoration: const InputDecoration(
                                                    hintText:
                                                        'Enter  Joint holder1 RelationShip',
                                                    labelText:
                                                        'Joint holder1 RelationShip',
                                                    // labelText: 'Guardian Relation',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[a-zA-Z]'))
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      //    padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller:
                                                    joint2cifTextController,
                                                decoration:
                                                    const InputDecoration(
                                                  // hintText: 'Enter Joint holder2 CIF ID',
                                                  labelText:
                                                      'Joint holder2 CIF ID',

                                                  labelStyle: TextStyle(
                                                      color: Color(0xFFCFB53B)),
                                                  hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 2, 40, 86),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                  controller:
                                                      joint2nameTextController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Enter  Joint holder2 Name',
                                                    labelText:
                                                        'Joint holder2 Name',
                                                    // labelText: 'Guardian Relation',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[a-zA-Z]'))
                                                  ]),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .111,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                  validator: (value) {
                                                    if (_isJointVisible ==
                                                            true &&
                                                        joint2nameTextController
                                                                .text
                                                                .toString()
                                                                .length >
                                                            0) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter Joint Holder Relationship';
                                                      }
                                                      return null;
                                                    }
                                                  },
                                                  controller:
                                                      joint2relationTextController,
                                                  decoration: const InputDecoration(
                                                    hintText:
                                                        'Enter  Joint holder2 Relationship',
                                                    labelText:
                                                        'Joint holder2 Relationship',
                                                    // labelText: 'Guardian Relation',
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                  ),
                                                  keyboardType: TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp('[a-zA-Z]'))
                                                  ]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            child: Text('Initiate for New Account'),
                            style: TextButton.styleFrom(
                                elevation: 5.0,
                                textStyle: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontFamily: "Georgia",
                                    letterSpacing: 1),
                                backgroundColor: Color(0xFFCC0000),
                                primary: Colors.white),
                            onPressed: () async {
                              // if(_isJointVisible==true){
                              //   if(joint1nameTextController.text.toString()==''){
                              //      UtilFs.showToast("Please Enter Joint Holder Name",context);
                              //   }
                              //   if(joint1nameTextController.text.toString()==''){
                              //     UtilFs.showToast("Please Enter Joint Holder Relationship",context);
                              //   }
                              //   if(joint1nameTextController.text.length>0 && joint2nameTextController.text.toString()==''){
                              //     UtilFs.showToast("Please Enter Joint Holder Relationship",context);
                              //   }
                              // }
                              // if(_isMinorVisible==true){
                              //  if(guardianNameTextController.text.toString()==''){
                              //    UtilFs.showToast("Please Enter Guardian Name", context);
                              //  }
                              //  if(guardianRelationTextController.text.toString()==''){
                              //    UtilFs.showToast("Please Enter Guardian Name", context);
                              //  }
                              // }
                              FocusScope.of(context).unfocus();
                              if (cifTextController.text.toString().isEmpty &&
                                  nameTextController.text.toString().isEmpty) {
                                UtilFs.showToast(
                                    "Please Enter either CIF ID or Name of Account Holder",
                                    context);
                              }

                              if (_formKey.currentState!.validate()) {
                                if (cifTextController.text.isNotEmpty) {
                                     List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                  print(acctoken[0].AccessToken);
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  encheader = await encryption();
                                  // await fetchaccdetails();

                                  // var request = http.Request('POST',
                                  //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                                  try {
                                    var headers = {
                                      'Signature': '$encheader',
                                      'Uri': 'requestSign',
                                      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                      'Authorization':
                                          'Bearer ${acctoken[0].AccessToken}',
                                      'Cookie':
                                          'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
                                    };

                                    // var request = http.Request('POST',
                                    //     Uri.parse(APIEndPoints().cbsURL));
                                    // request.files.add(
                                    //     await http.MultipartFile.fromPath(
                                    //         'file',
                                    //         '$cachepath/cif_enquiry.txt'));
                                    final File file = File('$cachepath/fetchAccountDetails.txt');
                                    String tosendText = await file.readAsString();
                                    var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                    request.body=tosendText;
                                    request.headers.addAll(headers);
                                    http.StreamedResponse response =
                                        await request.send().timeout(
                                            const Duration(seconds: 65),
                                            onTimeout: () {
                                      // return UtilFs.showToast('The request Timeout',context);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      throw 'TIMEOUT';
                                    });
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (response.statusCode == 200) {
                                      var resheaders = await response.headers;
                                      print("Result Headers");
                                      print(resheaders);
                                      String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                      String res =
                                          await response.stream.bytesToString();
                                      // String temp = resheaders['authorization']!;
                                      // String decryptSignature = temp;
                                      String val = await decryption1(
                                          decryptSignature, res);
                                      if (val == "Verified!") {
                                        await LogCat().writeContent(
                                                    '$res');

                                        Map a = json.decode(res);
                                        print(a['JSONResponse']['jsonContent']);
                                        String data =
                                            a['JSONResponse']['jsonContent'];
                                        main = json.decode(data);
                                        print("Values");
                                        print(main);
                                        print(main['responseParams']);
                                        if (main['Status'] == "FAILURE") {
                                          UtilFsNav.showToast(
                                              "${main['errorMsg']}",
                                              context,
                                              AccountOpenMain());
                                        } else {
                                          if (widget.scheme != "SSA") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => SBNewAccount(
                                                      main['Name'][0],
                                                      cifTextController.text,
                                                      main['IsMinor'],
                                                      main['KycStatus'],
                                                      joint1nameTextController
                                                          .text,
                                                      joint2nameTextController
                                                          .text,
                                                      widget.scheme,
                                                      rdinstallmentController
                                                          .text,
                                                      _tdGroupValue,_verticalGroupValue),
                                                ));
                                          } else {
                                            print(main['BirthDt']);
                                            List recvdDate = main['BirthDt']
                                                .toString()
                                                .split("T");
                                            List bd = recvdDate[0].split("-");
                                            final bday = DateTime(
                                                int.parse(bd[0]),
                                                int.parse(bd[1]),
                                                int.parse(bd[2]));
                                            final curDate = DateTime.now();
                                            final diff =
                                                curDate.difference(bday).inDays;
                                            if (diff > 3650) {
                                              UtilFs.showToast(
                                                  "Age for primary CIF ID (Minor) entered is greater than 10 years",
                                                  context);
                                            } else {
                                              encheader =
                                                  await guardiandetailsencryption();
                                              try {
                                                var headers = {
                                                  'Signature': '$encheader',
                                                  'Uri': 'requestSign',
                                                  // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                  'Authorization':
                                                      'Bearer ${acctoken[0].AccessToken}',
                                                  'Cookie':
                                                      'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
                                                };

                                                final File file = File('$cachepath/fetchAccountDetails.txt');
                                                String tosendText = await file.readAsString();
                                                var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                request.body=tosendText;
                                                request.headers.addAll(headers);
                                                http.StreamedResponse response =
                                                    await request
                                                        .send()
                                                        .timeout(
                                                            const Duration(
                                                                seconds: 65),
                                                            onTimeout: () {
                                                  // return UtilFs.showToast('The request Timeout',context);
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                  throw 'TIMEOUT';
                                                });
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                if (response.statusCode ==
                                                    200) {
                                                  var resheaders =
                                                      await response.headers;
                                                  print("Result Headers");
                                                  print(resheaders);
                                                  // List t = resheaders[
                                                  //         'authorization']!
                                                  //     .split(", Signature:");
                                                  String res = await response
                                                      .stream
                                                      .bytesToString();
                                                  String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                                  String val = await decryption1(
                                                      decryptSignature, res);
                                                  if (val == "Verified!") {
                                                    await LogCat().writeContent(
                                                    '$res');

                                                    Map a1 = json.decode(res);
                                                    print(a1['JSONResponse']
                                                        ['jsonContent']);
                                                    String data =
                                                        a1['JSONResponse']
                                                            ['jsonContent'];
                                                    guardmain =
                                                        json.decode(data);
                                                    print("Values");
                                                    print(guardmain);
                                                    print(
                                                        guardmain['guardCode']);
                                                    if (guardmain['Status'] ==
                                                        "FAILURE") {
                                                      UtilFsNav.showToast(
                                                          "${guardmain['errorMsg']}",
                                                          context,
                                                          AccountOpenMain());
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                      MaterialPageRoute(
                                                        builder: (_) => SBNewAccount(
                                                            main['Name'][0],
                                                            cifTextController
                                                                .text,
                                                            main['IsMinor'],
                                                            main['KycStatus'],
                                                            joint1nameTextController
                                                                .text,
                                                            joint2nameTextController
                                                                .text,
                                                            widget.scheme,
                                                            rdinstallmentController
                                                                .text,
                                                            _tdGroupValue,_verticalGroupValue),
                                                      ),);
                                                    }
                                                  } else {
                                                    UtilFsNav.showToast(
                                                        "Signature Verification Failed! Try Again",
                                                        context,
                                                        AccountOpenMain());
                                                    await LogCat().writeContent(
                                                        'A/c opening Screen Guardian CIF Details Fetching: Signature Verification Failed.');
                                                  }
                                                } else {
                                                  print("Error is");
                                                  String res = await response
                                                      .stream
                                                      .bytesToString();
                                                  print(res);
                                                  print(response.statusCode);
                                                  // UtilFsNav.showToast(
                                                  //     '${response.statusCode}',
                                                  //     context,
                                                  //     AccountOpenMain());
                                                  print(response.statusCode);
                                                  List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                  if(response.statusCode==503 || response.statusCode==504){
                                                    UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                                  }
                                                  else
                                                    UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                                }
                                              } catch (_) {
                                                if (_.toString() == "TIMEOUT") {
                                                  return UtilFsNav.showToast(
                                                      "Request Timed Out",
                                                      context,
                                                      AccountOpenMain());
                                                }
                                              }
                                            }
                                          }
                                        }
                                      } else {
                                        UtilFsNav.showToast(
                                            "Signature Verification Failed! Try Again",
                                            context,
                                            AccountOpenMain());
                                        await LogCat().writeContent(
                                            'A/c opening Screen CIF Details Fetching: Signature Verification Failed');
                                      }
                                    } else {
                                      print("Error is");
                                      String res =
                                          await response.stream.bytesToString();
                                      print(res);
                                      print(response.statusCode);
                                      // UtilFsNav.showToast(
                                      //     '${response.statusCode}',
                                      //     context,
                                      //     AccountOpenMain());
                                      print(response.statusCode);
                                      List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                      if(response.statusCode==503 || response.statusCode==504){
                                        UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AccountOpenMain());
                                      }
                                      else
                                        UtilFsNav.showToast(error[0].Description.toString(), context,AccountOpenMain());
                                    }
                                  } catch (_) {
                                    if (_.toString() == "TIMEOUT") {
                                      return UtilFsNav.showToast(
                                          "Request Timed Out",
                                          context,
                                          AccountOpenMain());
                                    }
                                  }
                                } else if (cifTextController.text.isEmpty &&
                                    nameTextController.text.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SBNewAccount(
                                            nameTextController.text.toString(),
                                            "",
                                            "",
                                            "",
                                            joint1nameTextController.text,
                                            joint2nameTextController.text,
                                            widget.scheme,
                                            rdinstallmentController.text,
                                            _tdGroupValue,_verticalGroupValue),
                                      ));
                                }
                              }

                              // if (_formKey.currentState!.validate()) {
                              //   if (cifTextController.text.isNotEmpty) {
                              //     List<USERLOGINDETAILS> acctoken=await USERLOGINDETAILS().select().toList();
                              //     print(acctoken[0].AppToken);
                              //     setState(() {
                              //       _isLoading = true;
                              //     });
                              //     encheader = await encryption();
                              //     // await fetchaccdetails();
                              //
                              //     // var request = http.Request('POST',
                              //     //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSign'));
                              //     try {
                              //       var headers = {
                              //         'Signature': '$encheader',
                              //         'Uri': 'requestSign',
                              //         // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                              //        'Authorization':'Bearer ${acctoken[0].AccessToken}',
                              //         'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
                              //         'Content-Type':'multipart/form-data'
                              //       };
                              //
                              //       var request = http.Request('POST',
                              //           Uri.parse(
                              //               APIEndPoints().cbsURL));
                              //       request.files.add(await http.MultipartFile.fromPath(
                              //           'file',
                              //           '$cachepath/cif_enquiry.txt'));
                              //       request.headers.addAll(headers);
                              //       http.StreamedResponse response = await request
                              //           .send().timeout(
                              //           const Duration(seconds: 65),
                              //           onTimeout: () {
                              //             // return UtilFs.showToast('The request Timeout',context);
                              //             setState(() {
                              //               _isLoading = false;
                              //             });
                              //             throw 'TIMEOUT';
                              //           });
                              //       setState(() {
                              //         _isLoading = false;
                              //       });
                              //       if (response.statusCode == 200) {
                              //         var resheaders = await response.headers;
                              //         print("Result Headers");
                              //         print(resheaders);
                              //         List t = resheaders['authorization']!.split(
                              //             ", Signature:");
                              //         String res = await response.stream
                              //             .bytesToString();
                              //         String decryptSignature=await decryptHeader(t[1]);
                              //         String val = await decryption1(
                              //             decryptSignature, res);
                              //         if (val == "Verified!") {
                              //
                              //           Map a = json.decode(res);
                              //           print(a['JSONResponse']['jsonContent']);
                              //           String data = a['JSONResponse']['jsonContent'];
                              //           main = json.decode(data);
                              //           print("Values");
                              //           print(main);
                              //           print(main['responseParams']);
                              //           if (main['Status'] == "FAILURE") {
                              //             UtilFs.showToast(
                              //                 "${main['errorMsg']}", context);
                              //           }
                              //           else {
                              //             if (widget.scheme != "SSA") {
                              //               Navigator.push(
                              //                   context,
                              //                   MaterialPageRoute(builder: (_) =>
                              //                       SBNewAccount(
                              //                           main['Name'][0],
                              //                           cifTextController.text,
                              //                           main['IsMinor'],
                              //                           main['KycStatus'],
                              //                           joint1nameTextController
                              //                               .text,
                              //                           joint2nameTextController
                              //                               .text,
                              //                           widget.scheme,
                              //                           rdinstallmentController
                              //                               .text,
                              //                           _tdGroupValue),
                              //                   )
                              //
                              //               );
                              //             }
                              //             else {
                              //               print(main['BirthDt']);
                              //               List recvdDate = main['BirthDt']
                              //                   .toString()
                              //                   .split("T");
                              //               List bd = recvdDate[0].split("-");
                              //               final bday = DateTime(
                              //                   int.parse(bd[0]), int.parse(bd[1]),
                              //                   int.parse(bd[2]));
                              //               final curDate = DateTime.now();
                              //               final diff = curDate
                              //                   .difference(bday)
                              //                   .inDays;
                              //               if (diff > 3650) {
                              //                 UtilFs.showToast(
                              //                     "Age for primary CIF ID (Minor) entered is greater than 10 years",
                              //                     context);
                              //               }
                              //             }
                              //           }
                              //         }
                              //         else{
                              //           UtilFs.showToast("Signature Verification Failed! Try Again",context);
                              //           await LogCat().writeContent(
                              //               '${DateTimeDetails().currentDateTime()} :A/c opening Screen CIF Details Fetching: Signature Verification Failed.\n\n');
                              //         }
                              //       }
                              //       else {
                              //         print("Error is");
                              //         String res=await response.stream.bytesToString();
                              //         print(res);
                              //         print(response.statusCode);
                              //         UtilFs.showToast('${response.statusCode}', context);
                              //       }
                              //     }catch(_){
                              //       if(_.toString()=="TIMEOUT"){
                              //         return UtilFs.showToast("Request Timed Out",context);
                              //       }
                              //     }
                              //   }
                              //   else if (cifTextController.text.isEmpty && nameTextController.text.isNotEmpty){
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(builder: (_) =>
                              //             SBNewAccount(
                              //                 nameTextController.text.toString(), "",
                              //                "", "",
                              //                 joint1nameTextController.text,
                              //                 joint2nameTextController.text,widget.scheme,rdinstallmentController.text,_tdGroupValue),
                              //         )
                              //
                              //     );
                              //   }
                              // }
                            },
                          )
                        ],
                      ),
                    );
                  }
                }),
            Container(
                child: _isLoading
                    ? Loader(
                        isCustom: true, loadingTxt: 'Please Wait...Loading...')
                    : Container()),
          ],
        ),
      ),
    );
  }

  Future<String> encryption() async {
    var login = await USERDETAILS().select().toList();
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/cif_enquiry.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    // String text="\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"}";

    // String text='{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}';

    print("selfopenacct\n $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New Account Opening CIF Details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> guardiandetailsencryption() async {
    var login = await USERDETAILS().select().toList();
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/cif_enquiry.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"getRetailsCustomerRelationShip","m_CustID":"${cifTextController.text}","responseParams":"guardCIF,guardName,guardCode"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    // String text="\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"}";

    // String text='{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}';

    print("selfopenacct\n $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New Account Opening CIF Details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

// Future<File> fetchaccdetails() async {
//   print("Reached writeContent");
//   Directory directory = Directory('$cachepath');
//   final file=await  File('$cachepath/cif_enquiry.txt');
//
//   file.writeAsStringSync('');
//   String text='{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}';
//   print("cifinquiry$text");
//   return file.writeAsString(text, mode: FileMode.append);
// }
}
