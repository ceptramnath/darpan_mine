import 'dart:io';
import 'package:age_calculator/age_calculator.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../../HomeScreen.dart';
import '../../../CBS/decryptHeader.dart';
import '../../../LogCat.dart';
import '../../PolicyCodes.dart';
import '../HomeScreen.dart';
import 'QuoteGeneration.dart';

class NewBusinessQuotes extends StatefulWidget {
  @override
  _NewBusinessQuotesState createState() => _NewBusinessQuotesState();
}

class _NewBusinessQuotesState extends State<NewBusinessQuotes> {
  final _formKey = GlobalKey<FormState>();
  List<String> _gender = ["Male", "Female"];
  List<String> _productTypes = ["PLI", "RPLI"];
  String _selectedProduct = "PLI";
  String _selectedgender = 'Male';
  bool gender = false;
  bool policy = false;
  String? val;
  String? gen;
  String? pol;
  String? temppassval;
  String? temp;
  String? age;
  TextEditingController guardianpolcontroller = TextEditingController();
  TextEditingController guardianName = TextEditingController();
  TextEditingController insdob = TextEditingController();
  TextEditingController ceasing = TextEditingController();
  TextEditingController sa = TextEditingController();
  TextEditingController spousedob = TextEditingController();
  List<String> pliproducts = [
    "Suraksha",
    "Suvidha",
    "Santosh",
    "YugalSuraksha",
    "Sumangal",
    "ChildrenPolicy"
  ];
  List<String> rpliproducts = [
    "GramSuraksha",
    "GramSuvidha",
    "GramSantosh",
    "GramPriya",
    "GramSumangal",
    "RuralChildrenPolicy"
  ];
  String dropdownvaluepli = "Santosh";
  String dropdownvaluerpli = "GramSantosh";
  List<String> ysterms = [
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20"
  ];
  String ysterm = "5";
  List<String> matage = ["35", "40", "45", "50", "55", "58", "60"];
  List<String> sumangalpterm = ["15", "20"];
  String aam = "35";
  String sumangalterm = "15";
  List<String> surakshapterm = ["55", "58", "60"];
  String surakshaterm = "55";
  List<String> suvidhapterm = ["60"];
  String suvidhaterm = "60";
  List<String> cpterms = ["18", "19", "20", "21", "22", "23", "24", "25"];
  String cpterm = "18";
  String? encheader;
  List<String> gpterm = ["10"];
  List<String> gsumangalterm = ["15", "20"];
  List<String> gsuvidhaterm = ["60"];
  List<String> gsurakshaterm = ["55", "58", "60"];
  List<String> gsantoshterm = ["35", "40", "45", "50", "55", "58", "60"];
  String gp = "19";
  String gsum = "15";
  String gsuv = "60";
  String gsur = "55";
  String gsan = "40";
  Map main = {};
  bool _isLoading = false;
  late Directory d;
  late String cachepath;

  @override
  void initState() {
    super.initState();
    getCacheDir();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("New Business Quotes"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 7,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 45.0,
                                  right: 45.0,
                                  bottom: 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Container(
                                  //   width: MediaQuery.of(context).size.width*0.20.w,
                                  //   child: Image.asset('assets/images/boy.jpg',   color:Colors.blue),),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      child: Text(
                                        "Male",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                        // activeColor: Colors.pink[200],
                                        // trackColor: Colors.blue,
                                        activeColor: Colors.green,
                                        trackColor: Colors.red,
                                        value: gender,
                                        onChanged: (value) {
                                          gender = value;
                                          setState(() {});
                                        }),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      child: Text(
                                        "Female",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  // Container(
                                  //     width: MediaQuery.of(context).size.width*0.23.w,
                                  //     child: Image.asset('assets/images/girl.png',color:Colors.pink[200])),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, bottom: 2.0, top: 2.0, right: 8.0),
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0,
                                  left: 45.0,
                                  right: 45.0,
                                  bottom: 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      child: Text(
                                        "PLI",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                        activeColor: Colors.green,
                                        trackColor: Colors.red,
                                        value: policy,
                                        onChanged: (value) {
                                          policy = value;
                                          setState(() {});
                                        }),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      child: Text("RPLI",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 7,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .95,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.5, left: 15.0),
                                child: InkWell(
                                  onTap: () {
                                    _selectinsDate(context);
                                  },
                                  child: Container(
                                    child: GestureDetector(
                                        onTap: () => _selectinsDate,
                                        child: IgnorePointer(
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500),
                                            controller: insdob,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Insurant DOB';
                                              } else {
                                                int? age1 = int.parse(age!) + 1;
                                                if ((age1 < 18 &&
                                                        dropdownvaluepli !=
                                                            "ChildrenPolicy") &&
                                                    (age1 < 18 &&
                                                        dropdownvaluerpli !=
                                                            "RuralChildrenPolicy")) {
                                                  // UtilFs.showToast(
                                                  //     "Age of Insurant should be greater than 18 years",
                                                  //     context);
                                                  return 'Age of Insurant should be greater than 18 years';
                                                } else if (age1 < 5 &&
                                                    (dropdownvaluepli ==
                                                            "ChildrenPolicy" ||
                                                        dropdownvaluerpli ==
                                                            "RuralChildrenPolicy")) {
                                                  return 'Age of Insurant should be > 5 years and <20 years';
                                                }
                                              }
                                            },
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              border: InputBorder.none,
                                              labelText: "Insurant DOB",
                                              labelStyle: TextStyle(
                                                  color: Color(0xFFCFB53B)),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            dropdownvaluepli == "YugalSuraksha"
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * .95,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(90.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0.5, left: 15.0),
                                      child: InkWell(
                                        onTap: () {
                                          _selectspouseDate(context);
                                        },
                                        child: Container(
                                          child: GestureDetector(
                                              onTap: () => _selectspouseDate,
                                              child: IgnorePointer(
                                                child: TextFormField(
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .characters,
                                                  style: const TextStyle(
                                                      fontSize: 17,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  controller: spousedob,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 2, 40, 86),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    border: InputBorder.none,
                                                    labelText: "Spouse DOB",
                                                    labelStyle: TextStyle(
                                                        color:
                                                            Color(0xFFCFB53B)),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    policy == false
                        ? Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .95,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 35.0),
                                child: DropdownButtonFormField<String>(
                                  alignment: Alignment.center,
                                  value: dropdownvaluepli,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: "Product Name",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvaluepli = newValue!;
                                    });
                                  },
                                  items: pliproducts
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * .95,
                              height: 65,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 35.0),
                                child: DropdownButtonFormField<String>(
                                  alignment: Alignment.center,
                                  value: dropdownvaluerpli,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 18),
                                  decoration: InputDecoration(
                                    labelText: "Product Name",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvaluerpli = newValue!;
                                    });
                                  },
                                  items: rpliproducts
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 7,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .95,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(90.0)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0.5, left: 15.0),
                                child: Container(
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    validator: (value) {
                                      if (policy == false) {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Sum Assured Value';
                                        } else if (int.parse(value) < 20000 ||
                                            int.parse(value) > 5000000) {
                                          return 'Please Enter Sum Assured value between 20000 and 5000000';
                                        } else if (int.parse(value)
                                                .remainder(1000) !=
                                            0) {
                                          return 'Please Enter Sum Assured value in Multiples of 10000';
                                        }
                                      } else {
                                        if (value!.isEmpty) {
                                          return 'Please Enter Sum Assured Value';
                                        } else if (int.parse(value) < 10000 ||
                                            int.parse(value) > 1000000) {
                                          return 'Please Enter Sum Assured value between 10000 and 1000000';
                                        } else if (int.parse(value)
                                                .remainder(1000) !=
                                            0) {
                                          return 'Please Enter Sum Assured value in Multiples of 10000';
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: sa,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Sum Assured",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            policy == false
                                ? Container(
                                    child: Column(
                                      children: [
                                        if (dropdownvaluepli == "Suraksha")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Policy Term"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue:
                                                            surakshaterm,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          surakshaterm = value!;
                                                        }),
                                                        items: surakshapterm,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (dropdownvaluepli == "Santosh")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Age at Maturity"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue: aam,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          aam = value!;
                                                        }),
                                                        items: matage,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (dropdownvaluepli == "Sumangal")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Policy Term"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue:
                                                            sumangalterm,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          sumangalterm = value!;
                                                        }),
                                                        items: sumangalpterm,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (dropdownvaluepli ==
                                            "YugalSuraksha")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Policy Term"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue: ysterm,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          ysterm = value!;
                                                        }),
                                                        items: ysterms,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (dropdownvaluepli == "Suvidha")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  children: [
                                                    Text("Prmeium Ceasing Age"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue: suvidhaterm,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          suvidhaterm = value!;
                                                        }),
                                                        items: suvidhapterm,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        else if (dropdownvaluepli ==
                                                "ChildrenPolicy" ||
                                            dropdownvaluerpli ==
                                                "RuralChildrenPolicy")
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .95,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        90.0)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0.5, left: 15.0),
                                              child: Container(
                                                // child: TextFormField(
                                                //   keyboardType: TextInputType.number,
                                                //
                                                //   style: TextStyle(fontSize: 18.sp,
                                                //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                                //   controller: ceasing,
                                                //
                                                //   decoration:  InputDecoration(
                                                //
                                                //     hintStyle: TextStyle(fontSize: 15.sp,
                                                //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                                //     border: InputBorder.none,
                                                //     labelText: "Premium Ceasing age",
                                                //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                                //   ),
                                                // ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Age at Maturity"),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: RadioGroup<
                                                          String>.builder(
                                                        direction:
                                                            Axis.horizontal,
                                                        groupValue: cpterm,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                          cpterm = value!;
                                                        }),
                                                        items: cpterms,
                                                        itemBuilder: (item) =>
                                                            RadioButtonBuilder(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Column(children: [
                                    if (dropdownvaluerpli == "GramPriya")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            // child: TextFormField(
                                            //   keyboardType: TextInputType.number,
                                            //
                                            //   style: TextStyle(fontSize: 18.sp,
                                            //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                            //   controller: ceasing,
                                            //
                                            //   decoration:  InputDecoration(
                                            //
                                            //     hintStyle: TextStyle(fontSize: 15.sp,
                                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                            //     border: InputBorder.none,
                                            //     labelText: "Premium Ceasing age",
                                            //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                            //   ),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Policy Term"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: RadioGroup<
                                                      String>.builder(
                                                    direction: Axis.horizontal,
                                                    groupValue: gp,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                      gp = value!;
                                                    }),
                                                    items: gpterm,
                                                    itemBuilder: (item) =>
                                                        RadioButtonBuilder(
                                                      item,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (dropdownvaluerpli ==
                                        "GramSumangal")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            // child: TextFormField(
                                            //   keyboardType: TextInputType.number,
                                            //
                                            //   style: TextStyle(fontSize: 18.sp,
                                            //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                            //   controller: ceasing,
                                            //
                                            //   decoration:  InputDecoration(
                                            //
                                            //     hintStyle: TextStyle(fontSize: 15.sp,
                                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                            //     border: InputBorder.none,
                                            //     labelText: "Premium Ceasing age",
                                            //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                            //   ),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Policy Term"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: RadioGroup<
                                                      String>.builder(
                                                    direction: Axis.horizontal,
                                                    groupValue: gsum,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                      gsum = value!;
                                                    }),
                                                    items: gsumangalterm,
                                                    itemBuilder: (item) =>
                                                        RadioButtonBuilder(
                                                      item,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (dropdownvaluerpli == "GramSuvidha")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            // child: TextFormField(
                                            //   keyboardType: TextInputType.number,
                                            //
                                            //   style: TextStyle(fontSize: 18.sp,
                                            //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                            //   controller: ceasing,
                                            //
                                            //   decoration:  InputDecoration(
                                            //
                                            //     hintStyle: TextStyle(fontSize: 15.sp,
                                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                            //     border: InputBorder.none,
                                            //     labelText: "Premium Ceasing age",
                                            //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                            //   ),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Premium Ceasing Age"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: RadioGroup<
                                                      String>.builder(
                                                    direction: Axis.horizontal,
                                                    groupValue: gsuv,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                      gsuv = value!;
                                                    }),
                                                    items: gsuvidhaterm,
                                                    itemBuilder: (item) =>
                                                        RadioButtonBuilder(
                                                      item,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (dropdownvaluerpli ==
                                        "GramSuraksha")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            // child: TextFormField(
                                            //   keyboardType: TextInputType.number,
                                            //
                                            //   style: TextStyle(fontSize: 18.sp,
                                            //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                            //   controller: ceasing,
                                            //
                                            //   decoration:  InputDecoration(
                                            //
                                            //     hintStyle: TextStyle(fontSize: 15.sp,
                                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                            //     border: InputBorder.none,
                                            //     labelText: "Premium Ceasing age",
                                            //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                            //   ),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Premium Ceasing Age"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: RadioGroup<
                                                      String>.builder(
                                                    direction: Axis.horizontal,
                                                    groupValue: gsur,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                      gsur = value!;
                                                    }),
                                                    items: gsurakshaterm,
                                                    itemBuilder: (item) =>
                                                        RadioButtonBuilder(
                                                      item,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    else if (dropdownvaluerpli == "GramSantosh")
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .95,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            // child: TextFormField(
                                            //   keyboardType: TextInputType.number,
                                            //
                                            //   style: TextStyle(fontSize: 18.sp,
                                            //       color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                                            //   controller: ceasing,
                                            //
                                            //   decoration:  InputDecoration(
                                            //
                                            //     hintStyle: TextStyle(fontSize: 15.sp,
                                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                                            //     border: InputBorder.none,
                                            //     labelText: "Premium Ceasing age",
                                            //     labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                            //   ),
                                            // ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Age at Maturity"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: RadioGroup<
                                                      String>.builder(
                                                    direction: Axis.horizontal,
                                                    groupValue: gsan,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                      gsan = value!;
                                                    }),
                                                    items: gsantoshterm,
                                                    itemBuilder: (item) =>
                                                        RadioButtonBuilder(
                                                      item,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ]))
                          ],
                        ),
                      ),
                    ),
                    dropdownvaluepli == "ChildrenPolicy" ||
                            dropdownvaluerpli == "RuralChildrenPolicy"
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 7,
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .95,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(90.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.5, left: 15.0),
                                        child: Container(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500),
                                            controller: guardianpolcontroller,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Policy Number of Guardian';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                icon: Icon(Icons.search),
                                                onPressed: () async {
                                                  List<USERLOGINDETAILS>
                                                      acctoken =
                                                      await USERLOGINDETAILS()
                                                          .select()
                                                          .toList();
                                                  // await writeContent();
                                                  encheader =
                                                      await encryptwriteContent();
                                                  try {
                                                    var headers = {
                                                      'Signature': '$encheader',
                                                      'Uri':
                                                          'searchParentPolicyData',
                                                      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                      'Authorization':
                                                          'Bearer ${acctoken[0].AccessToken}',
                                                      'Cookie':
                                                          'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                    };

                                                    final File file = File('$cachepath/fetchAccountDetails.txt');
                                                    String tosendText = await file.readAsString();
                                                    var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
                                                    request.body=tosendText;
                                                    request.headers
                                                        .addAll(headers);
                                                    // var request = http.Request('POST',
                                                    //     Uri.parse(
                                                    //         'https://gateway.cept.gov.in:443/pli/searchPolicy'));
                                                    // request.files.add(await http.MultipartFile.fromPath(
                                                    //     'file',
                                                    //     '$cachepath/fetchAccountDetails.txt'));

                                                    http.StreamedResponse
                                                        response =
                                                        await request.send();

                                                    if (response.statusCode ==
                                                        200) {
                                                      var resheaders =
                                                          await response
                                                              .headers;
                                                      print("Result Headers");
                                                      print(resheaders);
                                                      List t = resheaders[
                                                              'authorization']!
                                                          .split(
                                                              ", Signature:");
                                                      String res =
                                                          await response.stream
                                                              .bytesToString();
                                                      String temp = resheaders['authorization']!;
                                                      String decryptSignature = temp;

                                                      String val =
                                                      await decryption1(decryptSignature, res);
                                                      print(res);
                                                      print("\n\n");
                                                      if (val == "Verified!") {
                                                        await LogCat().writeContent(
                                                    '$res');
                                                        Map a =
                                                            json.decode(res);
                                                        print("Map a: $a");
                                                        print(a['JSONResponse']
                                                            ['jsonContent']);
                                                        String data =
                                                            a['JSONResponse']
                                                                ['jsonContent'];
                                                        main =
                                                            json.decode(data);
                                                        print("Values");
                                                        print(
                                                            main['policyname']);
                                                        setState(() {
                                                          guardianName = main[
                                                              'policyname'];
                                                        });
                                                      }
                                                    } else {
                                                      // UtilFsNav.showToast(
                                                      //     "${await response.stream.bytesToString()}",
                                                      //     context,
                                                      //     NewBusinessQuotes());

                                                      print(response.statusCode);
                                                      List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                      if(response.statusCode==503 || response.statusCode==504){
                                                        UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,NewBusinessQuotes());
                                                      }
                                                      else
                                                        UtilFsNav.showToast(error[0].Description.toString(), context,NewBusinessQuotes());
                                                    }
                                                  } catch (_) {
                                                    if (_.toString() ==
                                                        "TIMEOUT") {
                                                      return UtilFsNav.showToast(
                                                          "Request Timed Out",
                                                          context,
                                                          NewBusinessQuotes());
                                                    }
                                                  }
                                                },
                                              ),
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              border: InputBorder.none,
                                              labelText:
                                                  "Enter Parent Policy Number",
                                              labelStyle: TextStyle(
                                                  color: Color(0xFFCFB53B)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2.0,
                                          bottom: 2.0,
                                          top: 2.0,
                                          right: 8.0),
                                      child: Divider(
                                        thickness: 1.0,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .95,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(90.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 0.5, left: 15.0),
                                        child: Container(
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500),
                                            controller: guardianName,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              border: InputBorder.none,
                                              labelText: "Guardian Name",
                                              labelStyle: TextStyle(
                                                  color: Color(0xFFCFB53B)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              child: Text("Get Quote",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              style: ButtonStyle(
                                  // elevation:MaterialStateProperty.all(),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side:
                                              BorderSide(color: Colors.red)))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (insdob.text.length == 0)
                                    UtilFs.showToast(
                                        "Please Enter Insurant DOB", context);
                                  else if (dropdownvaluepli ==
                                          "YugalSuraksha" ||
                                      dropdownvaluerpli == "GramSumangal") {
                                    if (spousedob.text.length == 0)
                                      UtilFs.showToast(
                                          "Please Enter Spouse DOB", context);
                                  }
                                  // if(ceasing.text.length==0)
                                  //   UtilFs.showToast("Please Enter Premium ceasing age", context);
                                  else if (sa.text.length == 0)
                                    UtilFs.showToast(
                                        "Please Enter Sum Assured Value",
                                        context);
                                  else {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                       List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                    encheader = await encryption();

                                    // await writeBusinessQuote();
                                    // var request = http.Request('POST', Uri.parse(
                                    //     'https://gateway.cept.gov.in:443/pli/getQuoteDetails'));
                                    // var request = http.Request('POST', Uri.parse(
                                    //       'https://gateway.cept.gov.in:443/pli/getQuoteDetails'));
                                    try {
                                      var headers = {
                                        'Signature': '$encheader',
                                        'Uri': 'getQuoteDetails',
                                        // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                        'Authorization':
                                            'Bearer ${acctoken[0].AccessToken}',
                                        'Cookie':
                                            'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                      };

                                      final File file = File('$cachepath/fetchAccountDetails.txt');
                                      String tosendText = await file.readAsString();
                                      var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
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

                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        // print(await response.stream.bytesToString());
                                        var resheaders = await response.headers;
                                        print("Result Headers");
                                        print(resheaders);
                                        // List t = resheaders['authorization']!
                                        //     .split(", Signature:");
                                        String res = await response.stream
                                            .bytesToString();
                                        String temp1 = resheaders['authorization']!;
                                        String decryptSignature = temp1;

                                        String val1 = await decryption1(
                                            decryptSignature, res);
                                        if (val1 == "Verified!") {
                                          await LogCat().writeContent(
                                                    '$res');
                                          print(res);
                                          print("\n\n");
                                          Map a = json.decode(res);
                                          print("Map a: $a");
                                          print(
                                              a['JSONResponse']['jsonContent']);
                                          String data =
                                              a['JSONResponse']['jsonContent'];
                                          main = json.decode(data);
                                          if (main['Status'] == "FAILURE") {
                                            UtilFs.showToast(
                                                "${main['errorMsg']}", context);
                                          } else {
                                            print("Monthly Premium");
                                            print(main['AccumPremMonthly']);
                                            String? ptype =
                                                await policyTypes(val!);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => QuoteGeneration(
                                                        pol!,
                                                        ptype!,
                                                        sa.text,
                                                        temp!,
                                                        temppassval!,
                                                        main[
                                                            'ModalPremiumMonthly'],
                                                        main[
                                                            'ModalPremiumQuaterly'],
                                                        main[
                                                            'ModalPremiumHalfYearly'],
                                                        main[
                                                            'ModalPremiumYearly'])));
                                          }
                                        }
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        print(await response.stream
                                            .bytesToString());
                                        print(response.statusCode);
                                        // UtilFsNav.showToast(
                                        //     "${await response.stream.bytesToString()}",
                                        //     context,
                                        //     NewBusinessQuotes());
                                        print(response.statusCode);
                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                        if(response.statusCode==503 || response.statusCode==504){
                                          UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,NewBusinessQuotes());
                                        }
                                        else
                                          UtilFsNav.showToast(error[0].Description.toString(), context,NewBusinessQuotes());
                                        // UtilFs.showToast("${await response.stream.bytesToString()}",context);
                                      }
                                    } catch (_) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (_.toString() == "TIMEOUT") {
                                        return UtilFsNav.showToast(
                                            "Request Timed Out",
                                            context,
                                            NewBusinessQuotes());
                                      }
                                    }
                                  }
                                }
                              }),
                          TextButton(
                            child: Text("Re-Calculate",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            style: ButtonStyle(
                                // elevation:MaterialStateProperty.all(),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NewBusinessQuotes()));
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  child: _isLoading
                      ? Loader(
                          isCustom: true,
                          loadingTxt: 'Please Wait...Loading...')
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectinsDate(BuildContext context) async {
    matage = ["35", "40", "45", "50", "55", "58", "60"];
    aam = '35';
    DateTime now = new DateTime.now();
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(now.year - 60, now.month, now.day),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          insdob.text = formatter.format(d);
        });
        String t = insdob.text.split("-").reversed.join("-");
        age = await AgeCalculator.calculate(t);
        int? age1 = int.parse(age!) + 1;
        print("Age in Proposal calculation: $age1");

        setState(() {
          matage.removeWhere((item) => int.parse(item) < (age1 + 5));
          aam = matage[0];
        });
        for (int i = 0; i < matage.length; i++) {
          print(matage[i]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectspouseDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime(2015),
        firstDate: DateTime(1970),
        lastDate: DateTime(2015),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          spousedob.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> encryption() async {
    var login = await USERDETAILS().select().toList();
    String? spdob;
    if (gender == false) {
      gen = 'M';
    } else
      gen = 'F';

    if (policy == false)
      pol = "PLI";
    else
      pol = "RPL";

    val = policy == false
        ? await policyCodes(dropdownvaluepli)
        : await policyCodes(dropdownvaluerpli);
    String dob = insdob.text.toString().split("-").reversed.join("-");
    print("DOB Sending: $dob");
    String? tage = await AgeCalculator.calculate(dob);
    int? age = int.parse(tage!) + 1;
    if (dropdownvaluepli == "YugalSuraksha")
      spdob = await AgeCalculator.calculate(
          spousedob.text.toString().split("-").reversed.join("-"));
    print(age);
    final file = await File('$cachepath/fetchAccountDetails.txt');

    if (dropdownvaluepli == "Santosh" || dropdownvaluepli == "ChildrenPolicy") {
      temp = "Age at maturity";
      dropdownvaluepli == "Santosh" ? temppassval = aam : temppassval = cpterm;
    } else if (dropdownvaluepli == "Sumangal" ||
        dropdownvaluepli == "YugalSuraksha") {
      temp = "Policy Term";
      dropdownvaluepli == "Sumangal"
          ? temppassval = sumangalterm
          : temppassval = ysterm;
    } else if (dropdownvaluepli == "Suraksha" ||
        dropdownvaluepli == "Suvidha") {
      temp = "Premium Ceasing Age";
      dropdownvaluepli == "Suraksha"
          ? temppassval = surakshaterm
          : temppassval = suvidhaterm;
    } else if (dropdownvaluerpli == "GramSantosh" ||
        dropdownvaluepli == "RuralChildrenPolicy") {
      temp = "Age at Maturity";
      dropdownvaluepli == "GramSantosh"
          ? temppassval = gsan
          : temppassval = "10";
    } else if (dropdownvaluerpli == "GramPriya" ||
        dropdownvaluepli == "GramSumangal") {
      temp = "Policy Term";
      dropdownvaluepli == "GramPriya" ? temppassval = gp : temppassval = gsum;
    } else if (dropdownvaluerpli == "GramSuvidha" ||
        dropdownvaluepli == "GramSuraksha") {
      temp = "Premium Ceasing Age";
      dropdownvaluepli == "GramSuvidha"
          ? temppassval = gsuv
          : temppassval = gsur;
    }

    // dropdownvaluepli == "YugalSuraksha" ? spdob = spousedob.text : spdob = "";
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt",
        "getQuoteDetails",
        "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    //
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchQuoteDetailsReq","m_loginID":"${login[0].EMPID}","m_carrID":"$pol","m_prodID":"$val","m_coverageID":"001","m_faceAmount":${sa.text},"m_sex":"$gen","m_age":$age,"m_spouseage":$spdob,"m_recoveryInd":"YES","m_premCeasingAge":"$temppassval","m_policyTerm":"$temppassval","m_ageAtMaturity":"$temppassval","m_tobaccoClass":"N","m_billFreq":"MO","m_billMethod":"M","m_nonStdAgeProof":"NO","m_polYrDate":"${DateTimeDetails().bqdate()}","m_issueState":"","m_officecode":"${login[0].BOFacilityID}","responseParams":"Character_Value,premiumCeasingAge,ageAtMaturity,policyTerm,halfYearlyQuote,monthlyQuote,quaterlyQuote,yearlyQuote,Response_No,severity"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";

    // String text = "\nContent-Id: <requestPremiumXML>\n\n"'{"m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchQuoteDetailsReq","m_loginID":"${login[0].EMPID}","m_carrID":"$pol","m_prodID":"$val","m_coverageID":"001","m_faceAmount":${sa
    //     .text},"m_sex":"$gen","m_age":$age,"m_spouseage":$spdob,m_recoveryInd":"YES","m_premCeasingAge":"$temppassval","m_policyTerm":"$temppassval","m_ageAtMaturity":"$temppassval","m_tobaccoClass":"N","m_billFreq":"MO","m_billMethod":"M","m_nonStdAgeProof":"NO","m_polYrDate":"${DateTimeDetails()
    //     .bqdate()}","m_issueState":"","m_officecode":"${login[0].BOFacilityID}","responseParams":"Character_Value,premiumCeasingAge,ageAtMaturity,policyTerm,halfYearlyQuote,monthlyQuote,quaterlyQuote,yearlyQuote,Response_No,severity"}\n\n'"}";

    file.writeAsStringSync('');
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print(text);
   LogCat().writeContent(" NBQ ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  //
  // Future<File> writeBusinessQuote() async {
  //   // matage = ["35","40","45","50","55","58","60"];
  //   // aam='35';
  //   var login=await USERDETAILS().select().toList();
  //   String? spdob;
  //   if (gender == false) {
  //     gen = 'M';
  //   }
  //   else
  //     gen = 'F';
  //
  //   if (policy == false)
  //     pol = "PLI";
  //   else
  //     pol = "RPL";
  //
  //   val =
  //   policy == false ? await policyCodes(dropdownvaluepli) : await policyCodes(
  //       dropdownvaluerpli);
  //   String dob = insdob.text
  //       .toString()
  //       .split("-")
  //       .reversed
  //       .join("-");
  //   print("DOB Sending: $dob");
  //   String? age = await AgeCalculator.calculate(dob);
  //   if (dropdownvaluepli == "YugalSuraksha")
  //   spdob=await AgeCalculator.calculate(spousedob.text.toString().split("-").reversed.join("-"));
  //   print(age);
  //   final file =
  //   await File('$cachepath/fetchAccountDetails.txt');
  //
  //   if (dropdownvaluepli == "Santosh" ||
  //       dropdownvaluepli == "ChildrenPolicy") {
  //     temp = "Age at maturity";
  //     dropdownvaluepli == "Santosh" ? temppassval = aam : temppassval = cpterm;
  //   }
  //   else
  //   if (dropdownvaluepli == "Sumangal" || dropdownvaluepli == "YugalSuraksha") {
  //     temp = "Policy Term";
  //     dropdownvaluepli == "Sumangal"
  //         ? temppassval = sumangalterm
  //         : temppassval = ysterm;
  //   }
  //   else if (dropdownvaluepli == "Suraksha" || dropdownvaluepli == "Suvidha") {
  //     temp = "Premium Ceasing Age";
  //     dropdownvaluepli == "Suraksha"
  //         ? temppassval = surakshaterm
  //         : temppassval = suvidhaterm;
  //   }
  //
  //   else if (dropdownvaluerpli == "GramSantosh" || dropdownvaluepli == "RuralChildrenPolicy") {
  //     temp = "Age at Maturity";
  //     dropdownvaluepli == "GramSantosh"
  //         ? temppassval = gsan
  //         : temppassval = "10";
  //   }
  //   else if (dropdownvaluerpli == "GramPriya" || dropdownvaluepli == "GramSumangal") {
  //     temp = "Policy Term";
  //     dropdownvaluepli == "GramPriya"
  //         ? temppassval = gp
  //         : temppassval = gsum;
  //   }
  //   else if (dropdownvaluerpli == "GramSuvidha" || dropdownvaluepli == "GramSuraksha") {
  //     temp = "Premium Ceasing Age";
  //     dropdownvaluepli == "GramSuvidha"
  //         ? temppassval = gsuv
  //         : temppassval = gsur;
  //   }
  //
  //   // dropdownvaluepli == "YugalSuraksha" ? spdob = spousedob.text : spdob = "";
  //
  //
  //   String text = '{"m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchQuoteDetailsReq","m_loginID":"${login[0].EMPID}","m_carrID":"$pol","m_prodID":"$val","m_coverageID":"001","m_faceAmount":${sa
  //       .text},"m_sex":"$gen","m_age":$age,"m_spouseage":$spdob,"m_recoveryInd":"YES","m_premCeasingAge":"$temppassval","m_policyTerm":"$temppassval","m_ageAtMaturity":"$temppassval","m_tobaccoClass":"N","m_billFreq":"MO","m_billMethod":"M","m_nonStdAgeProof":"NO","m_polYrDate":"${DateTimeDetails()
  //       .bqdate()}","m_issueState":"","m_officecode":"${login[0].BOFacilityID}","responseParams":"Character_Value,premiumCeasingAge,ageAtMaturity,policyTerm,halfYearlyQuote,monthlyQuote,quaterlyQuote,yearlyQuote,Response_No,severity"}';
  //   file.writeAsStringSync('');
  //
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //
  //   final file = await File(
  //       '$cachepath/fetchAccountDetails.txt');
  //
  //   file.writeAsStringSync('');
  //   String text = '{"m_policyNo":"${guardianpolcontroller
  //       .text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();

    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "searchParentPolicyData", "getTransactionXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    String text = "$bound"
        "\nContent-Id: <getTransactionXML>\n\n"
        '{"m_policyNo":"${guardianpolcontroller.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
   LogCat().writeContent(" NBQ ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
