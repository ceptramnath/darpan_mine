import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:http/http.dart' as http;
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import '../HomeScreen.dart';

class DisbursementStatus extends StatefulWidget {
  @override
  _DisbursementStatusState createState() => _DisbursementStatusState();
}

class _DisbursementStatusState extends State<DisbursementStatus> {
  late Directory d;
  late String cachepath;

  bool _isLoading = false;
  String? encheader;
  String _selectedService = "Loan";
  List<String> services = [
    'Loan',
    'Maturity Claim',
    'Death Claim',
    'Surrender Claim',
    'Survival Claim',
    'Death Reopen',
    'Maturity Reopen'
  ];
  TextEditingController policyno = TextEditingController();
  bool disbvisible = false;
  Map main = {};

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
  }

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
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            "Disbursement Status",
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Request Type",
                          style: TextStyle(
                              color: Colors.blueGrey[300], fontSize: 18),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      height: 65,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                        child: DropdownButtonFormField<String>(
                          alignment: Alignment.center,
                          value: _selectedService,
                          icon: const Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Product Name",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            border: InputBorder.none,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedService = newValue!;
                              policyno.text = "";
                            });
                          },
                          items: services
                              .map<DropdownMenuItem<String>>((String value) {
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
                        top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500),
                          controller: policyno,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            labelText: "Policy No.",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Text(
                        "SEARCH",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          // elevation:MaterialStateProperty.all(),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.red)))),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          disbvisible = false;
                        });
                        main.clear();
                        print(policyno.text);
                        if (policyno.text.length != 0) {
                          setState(() {
                            _isLoading = true;
                          });



    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                          encheader = await encyrptwriteContent();
                          print("Recevied Signature");
                          print(encheader);
                          print("Bearer ${acctoken[0].AccessToken}");
                          bool netresult =
                              await InternetConnectionChecker().hasConnection;
                          print("INternet result: $netresult");
                          try {
                            // var request = http.Request(
                            //     'POST',
                            //     Uri.parse(
                            //         'https://gateway.cept.gov.in:443/pli/getDisbursementDetails'));
                            // request.files.add(await http.MultipartFile.fromPath('',
                            //     '$cachepath/fetchAccountDetails.txt'));

                            var headers = {
                              'Signature': '$encheader',
                              'Uri': 'getDisbursementDetails',
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
                                print("\n\n");
                                Map a = json.decode(res);
                                print("Map a: $a");
                                print(a['JSONResponse']['jsonContent']);
                                String data = a['JSONResponse']['jsonContent'];
                                main = json.decode(data);
                                if (main['Status'] == "FAILURE") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  List<INS_ERROR_CODES> errors =
                                      await INS_ERROR_CODES()
                                          .select()
                                          .Error_code
                                          .equals(main['Response_No'])
                                          .toList();
                                  UtilFsNav.showToast(
                                      "${errors[0].Error_message}",
                                      context,
                                      DisbursementStatus());
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                    disbvisible = true;
                                  });
                                }
                              } else {
                                UtilFsNav.showToast(
                                    "Signature Verification Failed! Try Again",
                                    context,
                                    DisbursementStatus());
                                await LogCat().writeContent(
                                    'Disbursement Status screen: Signature Verification Failed.');
                              }
                            } else {
                              // UtilFsNav.showToast(
                              //     "${await response.stream.bytesToString()}",
                              //     context,
                              //     DisbursementStatus());
                              print(response.statusCode);
                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                              if(response.statusCode==503 || response.statusCode==504){
                                UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,DisbursementStatus());
                              }
                              else
                                UtilFsNav.showToast(error[0].Description.toString(), context,DisbursementStatus());
                            }
                          } catch (_) {
                            if (_.toString() == "TIMEOUT") {
                              return UtilFsNav.showToast("Request Timed Out",
                                  context, DisbursementStatus());
                            } else
                              print(_);
                          }
                        } else if (policyno.text.length == 0) {
                          UtilFsNav.showToast(
                              "Please Enter Policy no. to continue",
                              context,
                              DisbursementStatus());
                        } else {
                          UtilFsNav.showToast("Please select Service", context,
                              DisbursementStatus());
                        }
                      },
                    ),
                  ),
                  disbvisible == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Table(
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  border: TableBorder.all(),
                                  children: [
                                    // TableRow(
                                    //     children: [
                                    //       // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //
                                    //       Column(children: [
                                    //         Text('Policy No',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('Payee Name',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('Disbursed Amount',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('Disbursed Date',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('Disbursed Voucher No.',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //     ]
                                    // ),
                                    // TableRow(
                                    //     children: [
                                    //       // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //
                                    //       Column(children: [
                                    //         Text('${policyno.text}',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('${main['PayeeName']}',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('${main['DisbAmt']}',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('${main['DisbDate']}',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //       Column(children: [
                                    //         Text('${main['DisbVoucher']}',
                                    //             style: TextStyle(
                                    //                 fontSize: 14.sp,
                                    //                 color: Colors.grey[600]))
                                    //       ]),
                                    //     ]
                                    // ),

                                    //
                                    //   TableRow(
                                    //   children: [
                                    //     // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //     Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text("Policy Number"),
                                    //     ),
                                    //     Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text("${policyno.text}"),
                                    //     )
                                    //   ]
                                    // ),
                                    //   TableRow(
                                    //       children: [
                                    //         // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("Payee Name"),
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("${main['PayeeName']}"),
                                    //         )
                                    //       ]
                                    //   ),
                                    //   TableRow(
                                    //       children: [
                                    //         // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("Disbursed Amount"),
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("${main['DisbAmt']}"),
                                    //         )
                                    //       ]
                                    //   ),
                                    //   TableRow(
                                    //       children: [
                                    //         // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("Disbursed Date"),
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("${main['DisbDate'].toString().split("-").reversed.join("-")}"),
                                    //         )
                                    //       ]
                                    //   ),
                                    //   TableRow(
                                    //       children: [
                                    //         // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("Disbursed Voucher No."),
                                    //         ),
                                    //         Padding(
                                    //           padding: const EdgeInsets.all(8.0),
                                    //           child: Text("${main['DisbVoucher']}"),
                                    //         )
                                    //       ]
                                    //   ),

                                    TableRow(children: [
                                      // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Payee Name",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Disbursed Amount",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Disbursed Date",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                            child: Text(
                                          "Disbursed Voucher No",
                                          style: TextStyle(fontSize: 12),
                                        )),
                                      )
                                    ]),
                                    if (main['DisbAmt'] is List)
                                      for (int i = 0;
                                          i < main['DisbAmt'].length;
                                          i++)
                                        TableRow(children: [
                                          // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${main['PayeeName'][i]}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${main['DisbAmt'][i]}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${main['DisbDate'][i]}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                              "${main['DisbVoucher'][i]}",
                                              style: TextStyle(fontSize: 12),
                                            )),
                                          )
                                        ])
                                    else
                                      TableRow(children: [
                                        // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "${main['PayeeName']}",
                                            style: TextStyle(fontSize: 12),
                                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "${main['DisbAmt']}",
                                            style: TextStyle(fontSize: 12),
                                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "${main['DisbDate']}",
                                            style: TextStyle(fontSize: 12),
                                          )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "${main['DisbVoucher']}",
                                            style: TextStyle(fontSize: 12),
                                          )),
                                        )
                                      ]),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DisbursementStatus()),
                                    );
                                  },
                                ),
                              )
                            ],
                          )),
                        )
                      : Container()
                ],
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

  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   String serv="";
  //   print(_selectedService);
  //   if(_selectedService=="Loan"){
  //     serv="loan";
  //   }
  //   else if(_selectedService=="Maturity Claim"){
  //     serv="Maturity Claim";
  //   }
  //   else if(_selectedService=="Death Claim"){
  //     serv="Death Claim";
  //   }
  //   else if(_selectedService=="Surrender Claim"){
  //     serv="Surrender";
  //   }
  //   else if(_selectedService=="Survival Claim"){
  //     serv="Survival Claim";
  //   }
  //   else if(_selectedService=="Maturity Reopen"){
  //     serv="Reopen Maturity Claim";
  //   }
  //   else if(_selectedService=="Death Reopen"){
  //     serv="Reopen Death Claim";
  //   }
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   String text='{"m_policyNum":"${policyno.text}","m_ServiceReqId":"getDisbursementDetails","m_BoID":"${login[0].BOFacilityID}","m_ServiceRequestType":"$serv","responseParams":"PayeeName,DisbAmt,DisbVoucher,DisbDate,Response_No,severity"}';
  //  print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encyrptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    String serv = "";
    print(_selectedService);
    if (_selectedService == "Loan") {
      serv = "loan";
    } else if (_selectedService == "Maturity Claim") {
      serv = "Maturity Claim";
    } else if (_selectedService == "Death Claim") {
      serv = "Death Claim";
    } else if (_selectedService == "Surrender Claim") {
      serv = "Surrender";
    } else if (_selectedService == "Survival Claim") {
      serv = "Survival Claim";
    } else if (_selectedService == "Maturity Reopen") {
      serv = "Reopen Maturity Claim";
    } else if (_selectedService == "Death Reopen") {
      serv = "Reopen Death Claim";
    }
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "getDisbursementDetails", "getTransactionXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <getTransactionXML>\n\n"
        '{"m_policyNum":"${policyno.text}","m_ServiceReqId":"getDisbursementDetails","m_BoID":"${login[0].BOFacilityID}","m_ServiceRequestType":"$serv","responseParams":"PayeeName,DisbAmt,DisbVoucher,DisbDate,Response_No,severity"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Disbursement Status ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
