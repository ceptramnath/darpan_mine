import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';

import 'package:darpan_mine/INSURANCE/HomeScreen/PremiumCollection/InitialPremiumCollection.dart';
import 'package:darpan_mine/INSURANCE/HomeScreen/PremiumCollection/newProposalPremiumCollectin.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import 'NewProposalScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ProposalSubmissionScreen extends StatefulWidget {
  String _selectedProduct;
  String productType;
  String pdate;
  String ddate;
  String ardate;
  String idate;

  ProposalSubmissionScreen(this._selectedProduct, this.productType, this.pdate,
      this.ddate, this.ardate, this.idate);

  @override
  _ProposalSubmissionScreenState createState() =>
      _ProposalSubmissionScreenState();
}

class _ProposalSubmissionScreenState extends State<ProposalSubmissionScreen> {
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController sumassured = TextEditingController();

  // TextEditingController aam=TextEditingController();
  TextEditingController prem = TextEditingController();
  TextEditingController cgst = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController premamount = TextEditingController();
  TextEditingController premamountinclTax = TextEditingController();
  TextEditingController parentpolicy = TextEditingController();
  TextEditingController guarname = TextEditingController();
  TextEditingController guardob = TextEditingController();
  TextEditingController dob =
      TextEditingController(text: DateTimeDetails().proposalDate());
  List<String> _gender = ["Male", "Female"];

  // List<String> matage = ["35","40","45","50","55","58","60"];
  List<String> matage = ["35", "40", "45", "50", "55", "58", "60"];
  List<String> sumangalpterm = ["15", "20"];
  List<String> gpterm = ["10"];
  String gp = "10";
  String text = "";
  bool premiumscreen = false;
  String selfreq = "Monthly";
  String aam = "35";
  String sumangalterm = "15";
  String suvidhaterm = "60";
  List<String> suvidhapterm = ["60"];
  List<String> surakshapterm = ["55", "58", "60"];
  String surakshaterm = "55";
  Map main = {};
  List<String> cpterms = ["18", "19", "20", "21", "22", "23", "24", "25"];
  String cpterm = "18";
  String _selectedgender = 'Male';
  var diff;
  bool parentdataVisible = false;
  bool _isLoading = false;
  List<String> freq = ["Monthly", "Quarterly", "Half_Yearly", "Annually"];
  List<String> freq1 = ["Monthly"];
  bool gender = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController spousedob =
      TextEditingController(text: DateTimeDetails().proposalDate());
  String? encheader;
  Map parentMain = {};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proposal indexing-${widget.productType}"),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      backgroundColor: Colors.grey[300],
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "${widget.productType} Proposal Details",
                        style: TextStyle(
                            color: Colors.blueGrey[300], fontSize: 18),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Insurant Details",
                        style: TextStyle(
                            color: Colors.blueGrey[300], fontSize: 18),
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
                          width: MediaQuery.of(context).size.width * .95,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 0.5, left: 15.0),
                            child: Container(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z]")),
                                ],
                                textCapitalization:
                                    TextCapitalization.characters,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Insurant Name';
                                  }
                                },
                                // keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                controller: firstname,

                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  labelText: "First Name",
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z]")),
                                ],
                                // keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.characters,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                controller: lastname,

                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  labelText: "LastName",
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
                                _fromDate(context);
                              },
                              child: Container(
                                child: GestureDetector(
                                    onTap: () => _fromDate,
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.characters,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
                                            fontWeight: FontWeight.w500),
                                        controller: dob,
                                        decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromARGB(255, 2, 40, 86),
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
                        widget.productType == "YugalSuraksha"
                            ? Container(
                                width: MediaQuery.of(context).size.width * .95,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90.0)),
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
                                                  TextCapitalization.characters,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: spousedob,
                                              validator: (value) {
                                                var tempdob = DateTimeDetails()
                                                    .selectedDateTime(
                                                        spousedob.text);
                                                print(
                                                    "Date Received: $tempdob");
                                                print(DateTime.now());
                                                var firstDate =
                                                    DateTime.parse(tempdob);
                                                var secondDate = DateTime.now();
                                                diff = (secondDate.year -
                                                        firstDate.year) +
                                                    1;

                                                if (diff < 21 || diff > 55) {
                                                  return 'Age of insurant on next birthday should be >=21 or <=55 years';
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
                                                labelText: "Spouse DOB",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                          child: Divider(
                            thickness: 1.0,
                          ),
                        ),
                        (widget.productType == "ChildrenPolicy" ||
                                widget.productType == "RuralChildrenPolicy")
                            ? Container(
                                width: MediaQuery.of(context).size.width * .95,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90.0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.5, left: 15.0),
                                  child: Container(
                                    child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500),
                                      controller: parentpolicy,
                                      decoration: InputDecoration(
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.search),
                                          onPressed: () async {
                                               List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                            encheader =
                                                await encryptparentpolicyData();

                                            try {
                                              var headers = {
                                                'Signature': '$encheader',
                                                'Uri': 'searchParentPolicyData',
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
                                              if (response.statusCode == 200) {
                                                // print(await response.stream.bytesToString());
                                                var resheaders =
                                                    response.headers;
                                                print("Response Headers");
                                                print(resheaders[
                                                    'authorization']);
                                                // List t =
                                                //     resheaders['authorization']!
                                                //         .split(", Signature:");
                                                String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;

                                                String res = await response
                                                    .stream
                                                    .bytesToString();
                                                print(res);
                                                String val = await decryption1(
                                                    decryptSignature, res);
                                                if (val == "Verified!") {
                                                  await LogCat().writeContent(
                                                    '$res');
                                                  print(res);
                                                  print("\n\n");
                                                  Map a = json.decode(res);
                                                  print("Map a: $a");
                                                  print(a['JSONResponse']
                                                      ['jsonContent']);
                                                  String data =
                                                      a['JSONResponse']
                                                          ['jsonContent'];
                                                  parentMain =
                                                      json.decode(data);
                                                  print(
                                                      "Values of main response are:");
                                                  print(parentMain);

                                                  if (parentMain['Status'] ==
                                                      "SUCCESS") {
                                                    setState(() {
                                                      parentdataVisible = true;
                                                      guardob.text = parentMain[
                                                              'BIRTHDATE']
                                                          .toString()
                                                          .split(" ")[0]
                                                          .toString()
                                                          .split("-")
                                                          .reversed
                                                          .join("-");
                                                      guarname.text =
                                                          parentMain[
                                                                  'SUMASSURED']
                                                              .toString();
                                                      print("Parent Sum Assured" );
                                                      print(guarname.text);

                                                    });
                                                  } else {
                                                    UtilFsNav.showToast(
                                                        "No Data recevied",
                                                        context,
                                                        NewProposalScreen());
                                                  }
                                                } else {
                                                  UtilFsNav.showToast(
                                                      "Signature Verification Failed! Try Again",
                                                      context,
                                                      NewProposalScreen());
                                                  await LogCat().writeContent(
                                                      'Proposal Calculation screen: Signature Verification Failed.');
                                                }
                                              } else {
                                                // UtilFsNav.showToast(
                                                //     "${response.reasonPhrase} \n ${await response.stream.bytesToString()}",
                                                //     context,
                                                //     NewProposalScreen());
                                                // UtilFs.showToast(
                                                //     '${response.reasonPhrase}', context);

                                                print(response.statusCode);
                                                List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                if(response.statusCode==503 || response.statusCode==504){
                                                  UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,NewProposalScreen());
                                                }
                                                else
                                                  UtilFsNav.showToast(error[0].Description.toString(), context,NewProposalScreen());
                                              }
                                            } catch (_) {
                                              if (_.toString() == "TIMEOUT") {
                                                return UtilFsNav.showToast(
                                                    "Request Timed Out",
                                                    context,
                                                    NewProposalScreen());
                                              } else
                                                print(_);
                                            }
                                          },
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Parent Policy Information",
                                        labelStyle:
                                            TextStyle(color: Color(0xFFCFB53B)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        parentdataVisible == true
                            ? Container(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: guarname,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Sum Assured",
                                        // hintText: parentMain['SUMASSURED'],
                                        labelStyle:
                                            TextStyle(color: Color(0xFFCFB53B)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: guardob,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Color.fromARGB(255, 2, 40, 86),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: InputBorder.none,
                                        labelText: "Parent DOB",
                                        // hintText:parentMain['BIRTHDATE'].toString().split(" ")[0].toString().split("-").reversed.join("-"),
                                        labelStyle:
                                            TextStyle(color: Color(0xFFCFB53B)),
                                      ),
                                    ),
                                  )
                                ]),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            color: Colors.blueGrey[300], fontSize: 18),
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 45.0, right: 45.0, bottom: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            child: Container(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                controller: sumassured,
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .90,
                    height: 65,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: (widget.productType == "Santosh" ||
                                (widget._selectedProduct == "RPLI" &&
                                    widget.productType !=
                                        "RuralChildrenPolicy"))
                            ? DropdownButtonFormField<String>(
                                alignment: Alignment.center,
                                value: selfreq,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: "Premium Frequency",
                                  labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selfreq = newValue!;
                                  });
                                },
                                items: freq.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            : DropdownButtonFormField<String>(
                                alignment: Alignment.center,
                                value: selfreq,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 18),
                                decoration: InputDecoration(
                                  labelText: "Premium Frequency",
                                  labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                  border: InputBorder.none,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selfreq = newValue!;
                                  });
                                },
                                items: freq1.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )),
                  ),
                ),
                if (widget.productType == "Santosh" ||
                    widget.productType == "GramSantosh")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: aam,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Age at Maturity",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              aam = newValue!;
                            });
                          },
                          items: matage
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "Sumangal" ||
                    widget.productType == "GramSumangal")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: sumangalterm,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Select Policy Term",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              sumangalterm = newValue!;
                            });
                          },
                          items: sumangalpterm
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "Suraksha" ||
                    widget.productType == "GramSuraksha")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: surakshaterm,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Premium Ceasing Age",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              surakshaterm = newValue!;
                            });
                          },
                          items: surakshapterm
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "Suvidha" ||
                    widget.productType == "GramSuvidha")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: suvidhaterm,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Ceasing Age",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              suvidhaterm = newValue!;
                            });
                          },
                          items: suvidhapterm
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "YugalSuraksha")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: ysterm,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Policy Term",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              ysterm = newValue!;
                            });
                          },
                          items: ysterms
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "ChildrenPolicy" ||
                    widget.productType == "RuralChildrenPolicy")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: cpterm,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Age at Maturity",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              cpterm = newValue!;
                            });
                          },
                          items: cpterms
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else if (widget.productType == "GramPriya")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: gp,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Policy Term",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              gp = newValue!;
                            });
                          },
                          items: gpterm
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .90,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: aam,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Ceasing Age",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              aam = newValue!;
                            });
                          },
                          items: matage
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //     labelText: "Premium Frequency",
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //   ),
                      //   child: DropdownButton<String>(
                      //     value: selfreq,
                      //     icon: const Icon(Icons.arrow_drop_down),
                      //     underline: Container(),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selfreq = newValue!;
                      //       });
                      //     },
                      //     items: freq.map<DropdownMenuItem<String>>(
                      //             (String value) {
                      //           return DropdownMenuItem<String>(
                      //             value: value,
                      //             child: Text(value),
                      //           );
                      //         }).toList(),
                      //   ),
                      // ),
                    ),
                  ),
                premiumscreen == false
                    ? TextButton(
                        child: Text("CALCULATE",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)))),
                        onPressed: () async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                          if (_formKey.currentState!.validate()) {
                            if (firstname.text.length == 0)
                              UtilFs.showToast(
                                  "Please enter Insurant FIrst Name", context);
                            // if(lastname.text.length==0)
                            //   UtilFs.showToast("Please enter Insurant Last Name",context);
                            else if (sumassured.text.length == 0)
                              UtilFs.showToast(
                                  "Please enter Sum Assured Value", context);
                            else if (widget._selectedProduct=="PLI" && int.parse(sumassured.text) <20000)
                              UtilFs.showToast(
                                  "Please enter Sum Assured Value > 20000", context);
                            else if (widget._selectedProduct=="RPLI" && int.parse(sumassured.text) <10000)
                              UtilFs.showToast(
                                  "Please enter Sum Assured Value < 10000", context);
                            else if (widget._selectedProduct=="RPLI" && int.parse(sumassured.text) <10000)
                              UtilFs.showToast(
                                  "Please enter Sum Assured Value < 10000", context);

                            // if(aam.text.length==0)
                            //   UtilFs.showToast("Please enter Age at Maturity",context);
                            else if (aam == "") {
                              UtilFs.showToast(
                                  "Please enter Age at Maturity", context);
                            } else {
                              print("Isnurant dob: " + dob.text);
                              var tempdob =
                                  DateTimeDetails().selectedDateTime(dob.text);
                              print("Date Received: $tempdob");
                              print(DateTime.now());
                              var firstDate = DateTime.parse(tempdob);
                              var secondDate = DateTime.now();
                              diff = (secondDate.year - firstDate.year) + 1;
                              print("Years Difference: $diff");

                              if ((widget.productType == "Santosh" || widget.productType == "GramSantosh") &&
                                  (diff < 19 || diff > 55)) {
                                UtilFs.showToast(
                                    "Age of insurant on next birthday should be >=19 or <=55 years",
                                    context);
                              } else if ((widget.productType == "Sumangal"||widget.productType == "GramSumangal") &&
                                  (diff < 19 || diff > 55)) {
                                UtilFs.showToast(
                                    "Age of insurant on next birthday should be >=19 or <=55 years",
                                    context);
                              } else if ((widget.productType == "Suraksha" || widget.productType == "GramSuraksha") &&
                                  (diff < 19 || diff > 55)) {
                                UtilFs.showToast(
                                    "Age of insurant on next birthday should be >=19 or <=55 years",
                                    context);
                              } else if (widget.productType ==
                                      "YugalSuraksha" &&
                                  (diff < 21 || diff > 55)) {
                                UtilFs.showToast(
                                    "Age of insurant on next birthday should be >=21 or <=55 years",
                                    context);
                              } else if ((widget.productType == "Suvidha" || widget.productType == "GramSuvidha") &&
                                  (diff < 19 || diff > 55)) {
                                UtilFs.showToast(
                                    "Age of insurant on next birthday should be >=19 or <=55 years",
                                    context);
                              }
                              else if ((widget.productType == "ChildrenPolicy" ||
                                  widget.productType == "RuralChildrenPolicy") &&
                              (diff < 5 || diff > 20)) {
                              UtilFs.showToast(
                              "Age of insurant on next birthday should be >=5 or <=20 years",
                              context);}
                              else if (widget.productType == "ChildrenPolicy"  &&
                                  (int.parse(sumassured.text) < 20000 || int.parse(sumassured.text) > 300000)) {
                                UtilFs.showToast(
                                    "Sum Assured Value should be >=20000 or <=300000",
                                    context);}
                              else if (widget.productType == "ChildrenPolicy"  && (guarname.text.length > 0 &&
                                  int.parse(guarname.text) < int.parse(sumassured.text))){
                                UtilFs.showToast(
                                    "Sum Assured Value should be < ${guarname.text}",
                                    context);}
                              else if (widget.productType == "RuralChildrenPolicy"  &&
                                  (int.parse(sumassured.text) < 20000 || int.parse(sumassured.text) > 100000)) {
                                UtilFs.showToast(
                                    "Sum Assured Value should be >=20000 or <=100000",
                                    context);}
                              else if (widget.productType == "RuralChildrenPolicy"  && (guarname.text.length > 0 &&
                                  int.parse(guarname.text) < int.parse(sumassured.text))){
                                UtilFs.showToast(
                                    "Sum Assured Value should be < ${guarname.text}",
                                    context);}
                              else {
                                _showLoadingIndicator();
                                encheader = await encryptwriteContent();
                                // var headers = {
                                //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                // };
                                // var request = http.Request('POST', Uri.parse(
                                //     'https://gateway.cept.gov.in:443/pli/getPremiumCalculations'));
                                // request.files.add(await http.MultipartFile.fromPath('',
                                //     '$cachepath/fetchAccountDetails.txt'));
                                // request.headers.addAll(headers);

                                try {
                                  var headers = {
                                    'Signature': '$encheader',
                                    'Uri': 'getPremiumCalculations',
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

                                  http.StreamedResponse response = await request
                                      .send()
                                      .timeout(const Duration(seconds: 65),
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
                                    // print(await response.stream.bytesToString());
                                    var resheaders = response.headers;
                                    print("Response Headers");
                                    print(resheaders['authorization']);
                                    // List t = resheaders['authorization']!
                                    //     .split(", Signature:");
                                    String temp = resheaders['authorization']!;
                                    String decryptSignature = temp;

                                    String res =
                                        await response.stream.bytesToString();
                                    print(res);
                                    String val =
                                        await decryption1(decryptSignature, res);
                                    if (val == "Verified!") {
                                      await LogCat().writeContent(
                                                    '$res');
                                      print(res);
                                      print("\n\n");
                                      Map a = json.decode(res);
                                      print("Map a: $a");
                                      print(a['JSONResponse']['jsonContent']);
                                      String data =
                                          a['JSONResponse']['jsonContent'];
                                      main = json.decode(data);
                                      print("Values of main response are:");
                                      print(main);
                                      setState(() {
                                        premiumscreen = true;
                                      });
                                    } else {
                                      UtilFsNav.showToast(
                                          "Signature Verification Failed! Try Again",
                                          context,
                                          NewProposalScreen());
                                      await LogCat().writeContent(
                                          'Proposal Calculation screen: Signature Verification Failed.');
                                    }
                                  } else {
                                    // UtilFsNav.showToast(
                                    //     "${response.reasonPhrase} \n ${await response.stream.bytesToString()}",
                                    //     context,
                                    //     NewProposalScreen());
                                    // UtilFs.showToast(
                                    //     '${response.reasonPhrase}', context);
                                    print(response.statusCode);
                                    List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                    if(response.statusCode==503 || response.statusCode==504){
                                      UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,NewProposalScreen());
                                    }
                                    else
                                      UtilFsNav.showToast(error[0].Description.toString(), context,NewProposalScreen());
                                  }
                                } catch (_) {
                                  if (_.toString() == "TIMEOUT") {
                                    return UtilFsNav.showToast(
                                        "Request Timed Out",
                                        context,
                                        NewProposalScreen());
                                  } else
                                    print(_);
                                }
                              }
                            }
                          }
                        },
                      )
                    : Container(),
                premiumscreen == true
                    ? Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 7,
                                  child: Column(children: [
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
                                            readOnly: true,
                                            // keyboardType: TextInputType.number,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500),
                                            controller: premamount
                                              ..text =
                                                  "${main['premiumAmount']}",

                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              border: InputBorder.none,
                                              labelText: "Premium Amount",
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
                                            // keyboardType: TextInputType.number,
                                            readOnly: true,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500),
                                            controller: premamountinclTax
                                              ..text =
                                                  "${main['premiumAmountIncTax']}",

                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 2, 40, 86),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              border: InputBorder.none,
                                              labelText: "Premium Amount + GST",
                                              labelStyle: TextStyle(
                                                  color: Color(0xFFCFB53B)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text("CANCEL",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                NewProposalScreen()));
                                  },
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
                                  child: Text("SUBMIT",
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
                                       List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                    _showLoadingIndicator();
                                    String propnum;

                                    encheader =
                                        await encryptwriteIndexContent();
                                    // var headers = {
                                    //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                    // };
                                    // var request = http.Request('POST', Uri.parse(
                                    //     'https://gateway.cept.gov.in:443/pli/getProposalIndexing'));
                                    // request.files.add(await http.MultipartFile.fromPath('',
                                    //     '$cachepath/fetchAccountDetails.txt'));
                                    // request.headers.addAll(headers);

                                    try {
                                      var headers = {
                                        'Signature': '$encheader',
                                        'Uri': 'getProposalIndexing',
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

                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (response.statusCode == 200) {
                                        // print(await response.stream.bytesToString());
                                        var resheaders = response.headers;
                                        print("Response Headers");
                                        print(resheaders['authorization']);
                                        // List t = resheaders['authorization']!
                                        //     .split(", Signature:");
                                        String temp = resheaders['authorization']!;
                                        String decryptSignature = temp;

                                        String res = await response.stream
                                            .bytesToString();
                                        print(res);
                                        String val = await decryption1(
                                            decryptSignature, res);
                                        print(res);
                                        print("\n\n");
                                        if (val == "Verified!") {
                                          await LogCat().writeContent(
                                                    '$res');
                                          Map a = json.decode(res);
                                          print("Map a: $a");
                                          print(
                                              a['JSONResponse']['jsonContent']);
                                          String data =
                                              a['JSONResponse']['jsonContent'];
                                          Map main1 = json.decode(data);
                                          print("Values of main response are:");
                                          print(main);
                                          if (main1['Status'] == "FAILURE") {
                                            UtilFsNav.showToast(
                                                main1['errorMsg'],
                                                context,
                                                NewProposalScreen());
                                          } else if (main1['responseCode'] ==
                                              null) {
                                            propnum = main1['proposalNumber'];
                                            await DAY_INDEXING_REPORT(
                                                    PROPOSAL_NUM: propnum,
                                                    CREATED_DATE:
                                                        DateTimeDetails()
                                                            .currentDate(),
                                                    POLICY_TYPE:
                                                        widget.productType,
                                                    OPERATOR_ID: '123',
                                                    TRAN_TYPE: 'New proposal',
                                                    RECEIPT_NO: '$propnum',
                                                    AMOUNT: main[
                                                        'premiumAmountIncTax'])
                                                .upsert();
                                            await DAILY_INDEXING_REPORT(
                                                    PROPOSAL_NUM: propnum,
                                                    CREATED_DATE:
                                                        DateTimeDetails()
                                                            .currentDate(),
                                                    POLICY_TYPE:
                                                        widget.productType,
                                                    OPERATOR_ID: '123',
                                                    RECEIPT_NUM: propnum,
                                                    REQ_TYPE: 'New Proposal')
                                                .upsert();
                                            return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        20,
                                                                  ),
                                                                  Text(
                                                                      "Application with Proposal Number $propnum has been checked in. Please choose how to Continue:"),
                                                                  SizedBox(
                                                                    height:
                                                                        20,
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      TextButton(
                                                                        child:
                                                                            Text(
                                                                          "CHECK IN ANOTHER APPLICATION",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.white,
                                                                          backgroundColor:
                                                                              Color(0xFFCC0000),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => NewProposalScreen()));
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: Text(
                                                                            "PAY PREMIUM"),
                                                                        style: TextButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Colors.white,
                                                                          backgroundColor:
                                                                              Color(0xFFCC0000),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (_) => NewProposalPremiumCollection(propnum, firstname.text, widget.ardate, main['premiumAmountIncTax'], widget.productType)));
                                                                        },
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            List<INS_ERROR_CODES> errors =
                                                await INS_ERROR_CODES()
                                                    .select()
                                                    .Error_code
                                                    .equals(
                                                        main1['responseCode'])
                                                    .toList();
                                            UtilFsNav.showToast(
                                                errors[0].Error_message!,
                                                context,
                                                NewProposalScreen());
                                          }
                                        }
                                      } else {
                                        // UtilFsNav.showToast(
                                        //     "${await response.stream.bytesToString()}",
                                        //     context,
                                        //     NewProposalScreen());

                                        print(response.statusCode);
                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                        if(response.statusCode==503 || response.statusCode==504){
                                          UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,NewProposalScreen());
                                        }
                                        else
                                          UtilFsNav.showToast(error[0].Description.toString(), context,NewProposalScreen());
                                      }
                                    } catch (_) {
                                      if (_.toString() == "TIMEOUT") {
                                        return UtilFsNav.showToast(
                                            "Request Timed Out",
                                            context,
                                            NewProposalScreen());
                                      } else
                                        print(_);
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container()
              ]),
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

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _fromDate(BuildContext context) async {
    matage = ["35", "40", "45", "50", "55", "58", "60"];
    aam = '35';
    DateTime now = new DateTime.now();
    final DateTime? d = await showDatePicker(
      locale: const Locale('en', 'IN'),
      fieldHintText: 'dd/mm/yyyy',
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(now.year - 60, now.month, now.day),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = new DateFormat('dd/MM/yyyy');
        dob.text = formatter.format(d);
      });
      String t = dob.text.split("/").reversed.join("-");
      String? age = await AgeCalculator.calculate(t);
      int? age1 = int.parse(age!) + 1;
      print("Age in Proposal calculation: $age1");
      print(widget.productType);
      // if(age1<18 && (widget.productType!="ChildrenPolicy" || widget.productType!="RuralChildrenPolicy")){
      //     UtilFs.showToast("Age of Insurant should be greater than 18 years",context);
      // }

      if (widget.productType == "ChildrenPolicy" ||
          widget.productType == "RuralChildrenPolicy") {
        print('inside if loop');
      } else {
// if(widget.productType!="ChildrenPolicy"  widget.productType!="RuralChildrenPolicy"){
        print("enetered if loop");
        print(widget.productType);
        if (age1 < 18) {
          UtilFs.showToast(
              "Age of Insurant should be greater than 18 years", context);
        } else {
          setState(() {
            matage.removeWhere((item) => int.parse(item) < (age1 + 5));
            aam = matage[0];
          });
        }
      }

      for (int i = 0; i < matage.length; i++) {
        print(matage[i]);
      }
    }
  }

  Future<void> _selectspouseDate(BuildContext context) async {
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
          var formatter = new DateFormat('dd/MM/yyyy');
          spousedob.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<File> writeContent() async {
  //   var freq;
  //   var db=await OfficeDetail().select().toList();
  //   if(selfreq=="Monthly"){
  //     freq="MO";
  //   }
  //   else if(selfreq=="Quarterly"){
  //     freq="QU";
  //   }
  //   else if (selfreq=="Half_Yearly"){
  //     freq="HA";
  //   }
  //   else if(selfreq=="Annually"){
  //     freq="AN";
  //   }
  //
  //   String gen=" ";
  //   if(_selectedgender=="Male"){
  //     gen="M";
  //   }
  //   else
  //     gen="F";
  //
  //
  //   final file=await File('$cachepath/fetchAccountDetails.txt');
  //   var login=await USERDETAILS().select().toList();
  //   file.writeAsStringSync('');
  //   if(widget.productType=="Santosh") {
  //     // text = '{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.ddate}","dateofindexing":"${widget.idate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   text='{"producttype":"PLI","productcode":"200","productname":"Santosh","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //   }
  //   else if(widget.productType=="Sumangal"){
  //     // text='{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"${sumangalterm}","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //     text='{"producttype":"PLI","productcode":"300","productname":"Sumangal","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //   }
  //   else if(widget.productType=="Suraksha"){
  //     text='{"producttype":"PLI","productcode":"001","productname":"Suraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="Suvidha"){
  //     text='{"producttype":"PLI","productcode":"100","productname":"Suvidha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"60","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="YugalSuraksha"){
  //     text='{"producttype":"PLI","productcode":"400","productname":"YugalSuraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="GramSantosh"){
  //     text='{"producttype":"RPL","productcode":"700","productname":"GramSantosh","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text = '{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.ddate}","dateofindexing":"${widget.idate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="GramSuraksha"){
  //     text='{"producttype":"RPL","productcode":"500","productname":"GramSuraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="GramSuvidha"){
  //     text='{"producttype":"RPL","productcode":"600","productname":"GramSuvidha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"60","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   else if(widget.productType=="GramSumangal"){
  //     text='{"producttype":"RPL","productcode":"800","productname":"GramSumangal","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}';
  //     // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
  //   }
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteContent() async {
    var freq;
    var db = await OfficeDetail().select().toList();
    if (selfreq == "Monthly") {
      freq = "MO";
    } else if (selfreq == "Quarterly") {
      freq = "QA";
    } else if (selfreq == "Half_Yearly") {
      freq = "SA";
    } else if (selfreq == "Annually") {
      freq = "AN";
    }

    String gen = " ";
    if (_selectedgender == "Male") {
      gen = "M";
    } else
      gen = "F";

    final file = await File('$cachepath/fetchAccountDetails.txt');
    var login = await USERDETAILS().select().toList();
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "getPremiumCalculations", "requestProposal");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    if (widget.productType == "Santosh") {
      // text = '{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.ddate}","dateofindexing":"${widget.idate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"200","productname":"Santosh","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    } else if (widget.productType == "Sumangal") {
      // text='{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"${sumangalterm}","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"300","productname":"Sumangal","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"$sumangalterm","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    } else if (widget.productType == "Suraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"001","productname":"Suraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","policyTerm":"","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "Suvidha") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"100","productname":"Suvidha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"$suvidhaterm","policyTerm":"","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"60","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "YugalSuraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"400","productname":"Yugal Suraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"${spousedob.text}","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"$ysterm","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "ChildrenPolicy") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"PLI","productcode":"450","productname":"ChildrenPolicy","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$cpterm","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "RuralChildrenPolicy") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"950","productname":"RuralChildrenPolicy","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$cpterm","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSantosh") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"700","productname":"GramSantosh","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"","ageatmaturity":"$aam","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text = '{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.ddate}","dateofindexing":"${widget.idate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSuraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"500","productname":"GramSuraksha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","policyTerm":"","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSuvidha") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"600","productname":"GramSuvidha","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"$suvidhaterm","policyTerm":"","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"60","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSumangal") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"800","productname":"GramSumangal","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"$sumangalterm","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramPriya") {
      text = "$bound"
          "\nContent-Id: <requestProposal>\n\n"
          '{"producttype":"RPL","productcode":"900","productname":"GramPriya","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","applicationreceiptdate":"${widget.ardate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","opportunityid":"","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","issuecircle":"${db[0].COOFFICEADDRESS}","issueho":"${db[0].OFFICEADDRESS_4}","issuepostoffice":"${db[0].OFFICEADDRESS_6}","spousedateofbirth":"","sumassured":${sumassured.text},"premiumceasingage":"","policyTerm":"10","ageatmaturity":"","paymentfrequency":"$freq","serviceRequestDate":"${DateTimeDetails().onlyDate()}","channeltype":"RICT","userName":"${login[0].EMPID}","facilityid":"${db[0].POCode}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"","policyTerm":"5","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"21/01/1997","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    }
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" NPS ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> encryptparentpolicyData() async {
    var login = await USERDETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "searchPolicy", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${parentpolicy.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" NPS ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  Future<String> encryptwriteIndexContent() async {
    var freq;

    var db = await OfficeDetail().select().toList();
    var insofccode=await INS_CIRCLE_CODES().select().CO_CODE.equals(db[0].COOFFICECODE).toList();
    db[0].COOFFICECODE=insofccode[0].Circle_code;
    if (selfreq == "Monthly") {
      freq = "MO";
    } else if (selfreq == "Quarterly") {
      freq = "QA";
    } else if (selfreq == "Half_Yearly") {
      freq = "SA";
    } else if (selfreq == "Annually") {
      freq = "AN";
    }

    String gen = " ";
    if (_selectedgender == "Male") {
      gen = "M";
    } else
      gen = "F";

    final file = await File('$cachepath/fetchAccountDetails.txt');
    var login = await USERDETAILS().select().toList();
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "getProposalIndexing", "requestProposalIndexing");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    print(widget.productType);
    if (widget.productType == "Santosh") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"21/01/2022","dateofdeclaration":"21/01/2022","dateofindexing":"21/01/2022","pocode":"SK030101003","dateofbirth":"21/01/1995","firstname":"aadhirai","lastname":"","gender":"F","sumassured":50000,"premiumceasingage":"","paymentfrequency":"MO","officeCode":"SK030101003","parentOffice":"SK030100000","caseVersion":"01","ageatmaturity":"35","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"21/01/2022","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "Sumangal") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","policyTerm":"$sumangalterm","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "Suraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","premiumceasingage":"$surakshaterm","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "Suvidha") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","premiumceasingage":"$suvidhaterm""policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "YugalSuraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"$ysterm","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"${spousedob.text}","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"YS","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "ChildrenPolicy") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"ChildrenPolicy","productcode":"450","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"$cpterm","premiumceasingage":"""policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "RuralChildrenPolicy") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"PLI","productname":"Suvidha","productcode":"950","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"$cpterm","premiumceasingage":"""policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSantosh") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSuraksha") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"$surakshaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSuvidha") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"$suvidhaterm","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramSumangal") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","policyTerm":"$sumangalterm","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"YS","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    } else if (widget.productType == "GramPriya") {
      text = "$bound"
          "\nContent-Id: <requestProposalIndexing>\n\n"
          '{"producttype":"RPL","productname":"GramPriya","productcode":"900","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].BOOFFICECODE}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].HOOFFICECODE}","caseVersion":"01","ageatmaturity":"","policyTerm":"10","issueAge":$diff,"premiumAmount":${premamount.text.split(".")[0]},"premiumAmountIncTax":${premamountinclTax.text.split(".")[0]},"userName":"${login[0].EMPID}","issueState":"${db[0].COOFFICECODE!.substring(0, 2)}-${db[0].HOOFFICECODE}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].HOOFFICECODE}"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"YS","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
    }
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" NPS ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

// Future<File> writeIndexContent() async {
//
//   var freq;
//   var db=await OfficeDetail().select().toList();
//   if(selfreq=="Monthly"){
//     freq="MO";
//   }
//   else if(selfreq=="Quarterly"){
//     freq="QU";
//   }
//   else if (selfreq=="Half_Yearly"){
//     freq="HA";
//   }
//   else if(selfreq=="Annually"){
//     freq="AN";
//   }
//
//   String gen=" ";
//   if(_selectedgender=="Male"){
//     gen="M";
//   }
//   else
//     gen="F";
//
//   final file=await File('$cachepath/fetchAccountDetails.txt');
//   var login=await USERDETAILS().select().toList();
//   file.writeAsStringSync('');
//   if(widget.productType=="Santosh") {
//   text='{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//   // text='{"producttype":"PLI","productname":"Santosh","productcode":"200","caseNumber":"EAP","dateofproposal":"21/01/2022","dateofdeclaration":"21/01/2022","dateofindexing":"21/01/2022","pocode":"SK030101003","dateofbirth":"21/01/1995","firstname":"aadhirai","lastname":"","gender":"F","sumassured":50000,"premiumceasingage":"","paymentfrequency":"MO","officeCode":"SK030101003","parentOffice":"SK030100000","caseVersion":"01","ageatmaturity":"35","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"21/01/2022","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="Sumangal"){
//     text='{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"PLI","productname":"Sumangal","productcode":"300","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="Suraksha"){
//     text='{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"PLI","productname":"Suraksha","productcode":"001","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="Suvidha"){
//     text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"PLI","productname":"Suvidha","productcode":"100","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="YugalSuraksha"){
//     text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"PLI","productname":"YugalSuraksha","productcode":"400","caseNumber":"YS","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="GramSantosh"){
//     text='{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"RPL","productname":"GramSantosh","productcode":"700","caseNumber":"EAP","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="GramSuraksha"){
//     text='{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"RPL","productname":"GramSuraksha","productcode":"500","caseNumber":"WLA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="GramSuvidha"){
//     text='{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"RPL","productname":"GramSuvidha","productcode":"600","caseNumber":"CWA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   else if(widget.productType=="GramSumangal"){
//     text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"AEA","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$gen","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":$diff,"premiumAmount":${premamount.text},"premiumAmountIncTax":${premamountinclTax.text},"userName":"${login[0].EMPID}","issueState":"${db[0].OFFICECODE_1!.substring(0,3)}-${db[0].OFFICECODE_5}","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"${db[0].OFFICECODE_5}"}';
//     // text='{"producttype":"RPL","productname":"GramSumangal","productcode":"800","caseNumber":"YS","dateofproposal":"${widget.pdate}","dateofdeclaration":"${widget.pdate}","dateofindexing":"${widget.pdate}","pocode":"${db[0].POCode}","dateofbirth":"${dob.text}","firstname":"${firstname.text}","lastname":"${lastname.text}","gender":"$_selectedgender","sumassured":${sumassured.text},"premiumceasingage":"","paymentfrequency":"$freq","officeCode":"${db[0].BOOFFICECODE}","parentOffice":"${db[0].OFFICECODE_5}","caseVersion":"01","ageatmaturity":"$aam","policyTerm":"","issueAge":28,"premiumAmount":608,"premiumAmountIncTax":635,"userName":"51236789","issueState":"KA-SK030100000","applicationReceiptDate":"${widget.ardate}","spouseDateOfBirth":"","opportunityId":"RICTOppurtunity","cpc":"SK030100000"}';
//   }
//   print(text);
//   return file.writeAsString(text, mode: FileMode.append);
// }

}
