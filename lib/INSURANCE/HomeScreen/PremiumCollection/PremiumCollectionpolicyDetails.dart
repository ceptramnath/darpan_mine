import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../../CBS/decryptHeader.dart';
import '../../../LogCat.dart';
import 'PaymentConfirmation.dart';
import 'PremiumCollection.dart';

class RenewalPremiumCollection extends StatefulWidget {
  String risk;
  String paymentCategory;
  String PolicyNumber;
  String name;
  String paidto;
  String billto;
  String freq;
  String due;
  String carrid;

  RenewalPremiumCollection(this.risk, this.paymentCategory, this.PolicyNumber,
      this.name, this.paidto, this.billto, this.freq, this.due, this.carrid);

  @override
  _RenewalPremiumCollectionState createState() =>
      _RenewalPremiumCollectionState();
}

class _RenewalPremiumCollectionState extends State<RenewalPremiumCollection> {
  TextEditingController installments = new TextEditingController();
  TextEditingController installmentsentered = new TextEditingController();
  bool calcbutton = true;
  bool aftercalc = false;
  Map main = {};
  String frequency = "Monthly";
  List<String> policyfrequency = [
    "Monthly",
    "Quarterly",
    "Half-yearly",
    "Yearly"
  ];
  final _formKey = GlobalKey<FormState>();
  TextEditingController toDate = new TextEditingController();
  TextEditingController fromDate = new TextEditingController();
  bool showdata = false;
  bool calc = true;
  Map mainval = {};
  String dispcgst = "";
  String dispsgst = "";
  bool _isLoading = false;
  String? encheader;
  late Directory d;
  late String cachepath;

  @override
  void initState() {
    super.initState();
    getCacheDir();
    if (widget.freq == "MO") {
      widget.freq = "Monthly";
    }
    if (widget.freq == "QU") {
      widget.freq = "Quarterly";
    }
    if (widget.freq == "SA") {
      widget.freq = "Half-yearly";
    }
    if (widget.freq == "AN") {
      widget.freq = "Yearly";
    }
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        title: Text("Renewal Premium collection"),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, left: 5.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Policy Number",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${widget.PolicyNumber}",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Center(
                                                    child: Text(
                                                  "Insurant Name",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey),
                                                )),
                                                Center(
                                                    child: Text(
                                                  "${widget.name}",
                                                  style: TextStyle(fontSize: 15),
                                                ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Premium Due Amount",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  "\u{20B9} ${widget.due}",
                                                  style: TextStyle(fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "From Date",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                "${widget.paidto.split("-").reversed.join("-")}",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "To Date",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                "${widget.billto.split("-").reversed.join("-")}",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Frequency",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                "${widget.freq}",
                                                style: TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 55,
                          right: 4,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.35,
                            padding:
                                EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: const BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              "${widget.carrid}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: calc,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35.0, top: 8.0, right: 8.0, bottom: 8.0),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("No of Installments",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.orangeAccent)),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * .3,
                                child: TextFormField(
                                  textAlign: TextAlign.end,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    // return 'Please Enter No of installments';
                                  ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Please Enter No of installments"),
                                    ));
                                  } else if (int.parse(installments.text.toString()) < 1) {
                                    // return 'Please enter Minimum no of installments as 1';
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text("Please enter Minimum no of installments as 1"),));
                                  }
                                  return null;
                                },
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: //Colors.white,
                                          Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    // labelText: "No of Installments",
                                    contentPadding: EdgeInsets.all(15.0),
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),

                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 0.5)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.red, width: 0.5)),
                                    // labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                  controller: installments,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            child: Text("Calculate"),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                if (int.parse(installments.text.toString())>0) {
                                  _showLoadingIndicator();
                                  encheader = await encryptwriteContent();


                                  List<USERLOGINDETAILS> acctoken =
                                  await USERLOGINDETAILS()
                                      .select()
                                      .Active
                                      .equals(true)
                                      .toList();
                                  // var headers = {
                                  //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                  // };
                                  // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/calcPremium'));
                                  // // var request = http.Request('POST', Uri.parse(Urls().premCalc));
                                  // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                  // request.headers.addAll(headers);
                                  try {
                                    var headers = {
                                      'Signature': '$encheader',
                                      'Uri': 'calcPremium',
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
                                      print("Calc premium");
                                      // print(await response.stream.bytesToString());
                                      var resheaders = response.headers;
                                      print("Response Headers");
                                      print(resheaders['authorization']);
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
                                        mainval = json.decode(data);
                                        print("Values");
                                        print(mainval['Gstnumber']);
                                        print(mainval['Status']);

                                        if (mainval['Status'] == "FAILURE") {
                                          List<INS_ERROR_CODES> res =
                                          await INS_ERROR_CODES()
                                              .select()
                                              .Error_code
                                              .startsWith(
                                              mainval['Response_No'])
                                              .toList();
                                          print(res.length);
                                          // print(res[0]);
                                          UtilFsNav.showToast(
                                              "${res[0].Error_message}",
                                              context,
                                              PremiumCollection());
                                        }


                                        // if (mainval['RENEWAL_CGSTPER'] == "0.0") {
                                        //   dispcgst = mainval['Init_CGST'];
                                        //   dispsgst = mainval['Init_SGST'];
                                        // } else {
                                        //   dispcgst = mainval['Renewal_CGST'];
                                        //   dispsgst = mainval['Renewal_SGST'];
                                        // }
                                          else {
                                          if (mainval['RENEWAL_CGST'] ==
                                              "0.0") {
                                            dispcgst = mainval['Init_CGST'];
                                            dispsgst = mainval['Init_SGST'];
                                          } else
                                          if (mainval['Init_CGST'] == "0.0") {
                                            dispcgst = mainval['Renewal_CGST'];
                                            dispsgst = mainval['Renewal_SGST'];
                                          }
                                          else {
                                            dispcgst = (double.parse(
                                                mainval['Renewal_CGST']) +
                                                double.parse(
                                                    mainval['Init_CGST']))
                                                .toString();
                                            dispsgst = (double.parse(
                                                mainval['Renewal_SGST']) +
                                                double.parse(
                                                    mainval['Init_SGST']))
                                                .toString();
                                          }
                                          setState(() {
                                            widget.billto =
                                            mainval['billtodate'];
                                            widget.due =
                                            mainval['premiumdueamt'];
                                            showdata = true;
                                            calc = false;
                                          });
                                        }
                                      } else {
                                        UtilFsNav.showToast(
                                            "Signature Verification Failed! Try Again",
                                            context,
                                            PremiumCollection());
                                        await LogCat().writeContent(
                                            '${DateTimeDetails()
                                                .currentDateTime()} :Premium COllection Policy Details screen: Signature Verification Failed.\n\n');
                                      }
                                    } else {
                                      // UtilFsNav.showToast(
                                      //     "${await response.stream
                                      //         .bytesToString()}",
                                      //     context,
                                      //     PremiumCollection());

                                      print(response.statusCode);
                                      List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                      if(response.statusCode==503 || response.statusCode==504){
                                        UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,PremiumCollection());
                                      }
                                      else
                                        UtilFsNav.showToast(error[0].Description.toString(), context,PremiumCollection());
                                    }
                                  } catch (_) {
                                    if (_.toString() == "TIMEOUT") {
                                      return UtilFsNav.showToast(
                                          "Request Timed Out",
                                          context,
                                          PremiumCollection());
                                    } else
                                      print(_);
                                  }
                                }
                              }
                            },
                            // style: ButtonStyle( foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFCC0000))),
                            style: ButtonStyle(
                                // elevation:MaterialStateProperty.all(),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: showdata,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Card(
                          elevation: 12,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "GST Details",
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        "CGST  ${showdata == true ? "\u{20B9} ${dispcgst}" : " "}"),
                                    Text(
                                        "SGST ${showdata == true ? "\u{20B9} ${dispsgst}" : " "}"),
                                    Text(
                                        "Total GST  ${showdata == true ? "\u{20B9} ${mainval['srvtaxtotamt']}" : " "}")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                  Visibility(
                    visible: showdata,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 2.0, top: 8.0, bottom: 10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Card(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                // color: Colors.red,
                                // elevation: 10,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0,
                                      left: 2.0,
                                      right: 5.0,
                                      bottom: 8.0),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Premium Details",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Premium Interest",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                            textAlign: TextAlign.left,
                                          ),
                                          showdata == true
                                              ? Text(
                                                  "\u{20B9} ${mainval['premiumintrest']}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                  textAlign: TextAlign.right,
                                                )
                                              : Text(" "),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Rebate",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                            textAlign: TextAlign.left,
                                          ),
                                          showdata == true
                                              ? Text(
                                                  "\u{20B9} ${mainval['premiumrebate']}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                  textAlign: TextAlign.right,
                                                )
                                              : Text(" "),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Balance Amount",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                            textAlign: TextAlign.left,
                                          ),
                                          showdata == true
                                              ? Text(
                                                  "\u{20B9} ${mainval['balamt']}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                  textAlign: TextAlign.right,
                                                )
                                              : Text(" "),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: MediaQuery.of(context).size.height * 0.20,
                              child: Card(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                // color: Colors.red,
                                // elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      left: 2.0,
                                      bottom: 10.0,
                                      right: 1.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Other Details",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.grey),
                                      ),
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("AgentID",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey)),
                                          showdata == true
                                              ? Text("${mainval['agentid']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ))
                                              : Text(" "),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Installments",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey)),
                                          showdata == true
                                              ? Text("${installments.text}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ))
                                              : Text(" "),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showdata,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 5.0, left: 8.0, right: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Card(
                            elevation: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Amount Payable",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                  showdata == true
                                      ? Text("${mainval['totalamt']}",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ))
                                      : Text(" ")
                                ],
                              ),
                            )
                            // ListTile(
                            //   title: Text("Amount Payable"),
                            //   subtitle:  showdata==true?Text("${mainval['totalamt']}",style: TextStyle(fontSize: 11,)):Text(" "),
                            // ),
                            ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: showdata,
                    child: Container(
                      alignment: Alignment.center,
                      child: TextButton(
                        child: Text("Make Payment"),
                        onPressed: () async {
                          print("Rebate: ${mainval['premiumrebate']}");
                          print("Prem interest: ${mainval['premiumintrest']}");
                          print("GSTNID: ${mainval['Gstnumber']}");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => paymentconfirmation(
                                    widget.name,
                                    widget.paymentCategory,
                                    mainval['carrid'],
                                    "${mainval['totalamt']}",
                                    widget.paidto,
                                    widget.billto,
                                    mainval['premiumintrest'],
                                    mainval['premiumrebate'],
                                    mainval['agentid'],
                                    dispcgst,
                                    dispsgst,
                                    mainval['Gstnumber'],
                                    mainval['RENEWAL_CGSTPER'],
                                    mainval['RENEWAL_SGSTPER'],
                                    mainval['op_GSTrenewalyr'],
                                    mainval['srvtaxtotamt'],
                                    widget.PolicyNumber,
                                    mainval['renewalAmount'].toString(),
                                    mainval['balamt'],
                                    mainval['premiumdueamt']),
                              ));
                        },
                        // style: ButtonStyle( foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFCC0000))),
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  child: _isLoading
                      ? Loader(
                          isCustom: true, loadingTxt: 'Please Wait...Loading...')
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    Directory directory = Directory('$cachepath');
    // print("Path is -"+directory.path.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fetchAccountDetails.txt');
  }

  // Future<File> writeContent() async {
  //
  //   final file=await _localFile;
  //
  //   file.writeAsStringSync('');
  //
  //   String text='{"m_policyNo":"${widget.PolicyNumber}","m_BoID":"BO11302127002","m_Integer_Value":"${installments.text}","m_ServiceReqId":"fetchpolicyDetailsReq","m_RiskCommDate":"${widget.risk} 00:00:00.0","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Renewal_CGST,Renewal_UGST,Renewal_SGST,Gstnumber,Init_SGST,Init_UGST,Init_CGST,INIT_CGSTPER,INIT_SGSTPER,INIT_UGSTPER,RENEWAL_CGSTPER,RENEWAL_SGSTPER,RENEWAL_UGSTPER,op_GSTinityr,op_GSTrenewalyr,taxtype"}';
  //   print("Calculate Premium: $text");
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    final file = await _localFile;

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "calcPremium", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${widget.PolicyNumber}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":"${installments.text}","m_ServiceReqId":"fetchpolicyDetailsReq","m_RiskCommDate":"${widget.risk} 00:00:00.0","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Renewal_CGST,Renewal_UGST,Renewal_SGST,Gstnumber,Init_SGST,Init_UGST,Init_CGST,INIT_CGSTPER,INIT_SGSTPER,INIT_UGSTPER,RENEWAL_CGSTPER,RENEWAL_SGSTPER,RENEWAL_UGSTPER,op_GSTinityr,op_GSTrenewalyr,taxtype"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("Calculate Premium: $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Initial Premium ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  void _showLoadingIndicator() {
    print('isloading');
    setState(() {
      _isLoading = true;
    });
  }
}
