import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../HomeScreen.dart';
import '../HomeScreen.dart';
import 'ProposalSubmissionScreen.dart';

class NewProposalScreen extends StatefulWidget {
  @override
  _NewProposalScreenState createState() => _NewProposalScreenState();
}

class _NewProposalScreenState extends State<NewProposalScreen> {
  List<String> _productTypes = ["PLI", "RPLI"];
  String _selectedProduct = "PLI";
  List<String> pliproducts = [
    "Suraksha",
    "Suvidha",
    "Santosh",
    "YugalSuraksha",
    "Sumangal",
    "ChildrenPolicy"
  ];
  List<String> freq = ["Monthly", "Quarterly", "Half_Yearly", "Annually"];

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
  String selfreq = "Monthly";
  List<OfficeDetail> officedata = [];

  TextEditingController dec = new TextEditingController();
  TextEditingController prop = new TextEditingController();
  TextEditingController appreceipt = new TextEditingController();
  TextEditingController indexdate = new TextEditingController();
  TextEditingController pocode = new TextEditingController();
  TextEditingController oppid = new TextEditingController();
  TextEditingController isscircle = new TextEditingController();
  TextEditingController issho = new TextEditingController();
  TextEditingController isspo = new TextEditingController();
  TextEditingController insdob = new TextEditingController();
  TextEditingController insname = new TextEditingController();

  Future? getData;
  bool policy = false;

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
  }

  @override
  void initState() {
    getData = getofficedetails();
  }

  getofficedetails() async {
    officedata = await OfficeDetail().select().toList();
    print("Office Data");
    print(officedata[0].POCode);
    print("OFfice data length: ${officedata.length}");
    return officedata.length;
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
              "New Proposal Indexing",
            ),
            backgroundColor: ColorConstants.kPrimaryColor,
          ),
          backgroundColor: Colors.grey[300],
          body: FutureBuilder(
              future: getData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 15.0),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Product Type",
                                  style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 7,
                              child: Padding(
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        child: Text(
                                          "PLI",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    CupertinoSwitch(
                                        activeColor: Colors.green,
                                        trackColor: Colors.red,
                                        value: policy,
                                        onChanged: (value) {
                                          policy = value;
                                          setState(() {});
                                        }),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.20,
                                        child: Text("RPLI",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          policy == false
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        .95,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(90.0)),
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
                                          labelStyle: TextStyle(
                                              color: Color(0xFFCFB53B)),
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
                                      top: 15.0,
                                      left: 8.0,
                                      right: 8.0,
                                      bottom: 8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        .95,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(90.0)),
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
                                          labelStyle: TextStyle(
                                              color: Color(0xFFCFB53B)),
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
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            child: TextFormField(
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: prop
                                                ..text = DateTimeDetails()
                                                    .proposalDate(),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                labelText: "Proposal Date",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            child: TextFormField(
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: dec
                                                ..text = DateTimeDetails()
                                                    .proposalDate(),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                labelText: "Declaration Date",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 0.8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            child: TextFormField(
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: appreceipt
                                                ..text = DateTimeDetails()
                                                    .proposalDate(),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                labelText: "Appln Receipt Date",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 0.8,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(90.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0.5, left: 15.0),
                                          child: Container(
                                            child: TextFormField(
                                              readOnly: true,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: indexdate
                                                ..text = DateTimeDetails()
                                                    .proposalDate(),
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                labelText: "Indexing Date",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, left: 15.0),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Office Details",
                                  style: TextStyle(
                                      color: Colors.blueGrey[300],
                                      fontSize: 18),
                                )),
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
                                    width:
                                        MediaQuery.of(context).size.width * .95,
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
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: pocode
                                            ..text = officedata[0].POCode!,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,
                                            labelText: "PO Code",
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
                                    width:
                                        MediaQuery.of(context).size.width * .95,
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
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: oppid..text = " ",
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,
                                            labelText: "Opportunity ID",
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
                                    width:
                                        MediaQuery.of(context).size.width * .95,
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
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: isscircle
                                            ..text =
                                                officedata[0].OFFICEADDRESS_1!,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,
                                            labelText: "Issue Circle",
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
                                    width:
                                        MediaQuery.of(context).size.width * .95,
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
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: issho
                                            ..text =
                                                officedata[0].HOOFFICEADDRESS!,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,
                                            labelText: "Issue HO",
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
                                    width:
                                        MediaQuery.of(context).size.width * .95,
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
                                          readOnly: true,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: isspo
                                            ..text =
                                                officedata[0].OFFICEADDRESS_5!,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            border: InputBorder.none,
                                            labelText: "Issue PO",
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () async {},
                                style: ButtonStyle(
                                    // elevation:MaterialStateProperty.all(),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.red)))),
                              ),
                              TextButton(
                                child: Text("Next",
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
                                            side: BorderSide(
                                                color: Colors.red)))),
                                onPressed: () async {
                                  policy == false
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ProposalSubmissionScreen(
                                                      "PLI",
                                                      dropdownvaluepli,
                                                      prop.text,
                                                      dec.text,
                                                      appreceipt.text,
                                                      indexdate.text)))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  ProposalSubmissionScreen(
                                                      "RPLI",
                                                      dropdownvaluerpli,
                                                      prop.text,
                                                      dec.text,
                                                      appreceipt.text,
                                                      indexdate.text)));
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  Future<void> _selectinsDate(BuildContext context) async {
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
          insdob.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
