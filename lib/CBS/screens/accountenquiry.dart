import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../accdetails.dart';
import '../decryptHeader.dart';
import 'my_cards_screen.dart';

class AcountEnquiry extends StatefulWidget {
  @override
  _AcountEnquiryState createState() => _AcountEnquiryState();
}

class _AcountEnquiryState extends State<AcountEnquiry> {
  final amountTextController = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  TextEditingController date = TextEditingController();
  bool _showClearButton = true;
  bool _isVisible = false;
  late Directory d;
  late String cachepath;
  Map main = {};
  List Params = [];
  bool _isLoading = false;
  List<TBCBS_TRAN_DETAILS> cbsData = [];
  String? kycStatus;
  String? isMinor;
  String? dateOfBirth;
  String? isSuspended;
  String? name;
  String? status;
  String? dateTime;
  List<TBCBS_TRAN_DETAILS> tbaDetails = [];
  String _verticalGroupValue = "Reference Number";
  List? display = [];
  bool datavisible = false;
  String? encheader;
  List<String> _status = ["Reference Number", "Date"];

  Future<void> _selectinsDate(BuildContext context) async {
    setState(() {
      datavisible = false;
    });
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
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

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCacheDir();
    setState(() {
      amountTextController.clear();
      accountType.clear();
      myController.clear();
      _isVisible = false;
    });
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
            'New Account Enquiry',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFFB71C1C),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: WillPopScope(
          onWillPop: () async {
            bool? result = await _onBackPressed();
            result ??= false;
            return result;
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      RadioGroup<String>.builder(
                        horizontalAlignment: MainAxisAlignment.spaceEvenly,
                        direction: Axis.horizontal,
                        groupValue: _verticalGroupValue,
                        onChanged: (value) => setState(() {
                          datavisible = false;
                          _verticalGroupValue = value!;
                        }),
                        items: _status,
                        itemBuilder: (item) => RadioButtonBuilder(
                          item,
                        ),
                      ),
                      _verticalGroupValue == "Reference Number"
                          ? _searchBar()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                              child: Container(
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
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500),
                                              controller: date,
                                              decoration: const InputDecoration(
                                                hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 2, 40, 86),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: InputBorder.none,
                                                labelText: "Date",
                                                labelStyle: TextStyle(
                                                    color: Color(0xFFCFB53B)),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      TextButton(
                        child: Text("Search"),
                        style: TextButton.styleFrom(
                            elevation: 5.0,
                            textStyle: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Georgia",
                                letterSpacing: 1),
                            backgroundColor: Color(0xFFCC0000),
                            primary: Colors.white),
                        onPressed: () async {


    List<USERLOGINDETAILS> acctoken =
          await USERLOGINDETAILS().select().Active.equals(true).toList();
                          display?.clear();
                          datavisible = false;

                          if (date.text.isNotEmpty ||
                              myController.text.isNotEmpty) {
                            // await writeContent();
                            setState(() {
                              _isLoading=true;
                            });
                            try {
                              encheader = await encryption();

                              var headers = {
                                'Signature': '$encheader',
                                'Uri': 'getNewAccRef',
                                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                'Authorization':
                                    'Bearer ${acctoken[0].AccessToken}',
                                'Cookie':
                                    'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                              };
                              // var request = http.Request('POST', Uri.parse(
                              //     'https://gateway.cept.gov.in:443/cbs/getNewAccRef'));

                              final File file = File('$cachepath/fetchAccountDetails.txt');
                              String tosendText = await file.readAsString();
                              var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
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
                                var resheaders = await response.headers;
                                print("Result Headers");
                                print(resheaders);
                                List t = resheaders['authorization']!
                                    .split(", Signature:");
                                String res =
                                    await response.stream.bytesToString();
                                String temp = resheaders['authorization']!;
                                String decryptSignature = temp;

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
                                  String data = a['JSONResponse']['jsonContent'];
                                  main = json.decode(data);
                                  print(main['NEW_ACC']);
                                  List test = main['NEW_ACC'].split(",");
                                  List test1 = [];
                                  print(test.length);
                                  for (int i = 0; i < test.length - 1; i++) {
                                   // print(test[i].length);
                                   if(test[i].length>0) {
                                     test1.add(test[i]);
                                   }
                                  }
                                  List? test2 = await fac.splitNewAccount(test1);
                                  print(test2);
                                  print("test2 length");
                                  print(test2!.length);
                                  print("Account opening date");
                                  for (int i = 0; i < test2.length; i++) {
                                    print(i);
                                    print(test2[i][6]);
                                  }
                                  print(_verticalGroupValue);
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  if (_verticalGroupValue == "Reference Number") {
                                    for (int i = 0; i < test2.length; i++) {
                                      if (test2[i][1] ==
                                          (myController.text.toString())) {
                                        display?.add(test2[i]);
                                      }
                                    }
                                    if (display?.length != 0) {
                                      setState(() {
                                        datavisible = true;
                                      });
                                    } else
                                      UtilFs.showToast(
                                          "Entered Reference Number not available",
                                          context);
                                  }
                                  else {
                                    for (int i = 0; i < test2.length; i++) {
                                      if (test2[i][6] == (date.text)) {
                                        display!.add(test2[i]);
                                      }
                                    }
                                    print("Display Length: ${display!.length}");
                                    if (display?.length != 0) {
                                      setState(() {
                                        datavisible = true;
                                      });
                                    } else
                                      UtilFs.showToast(
                                          "No Reference Number available for the selected Date",
                                          context);
                                  }
                                  print("Display: $display");
                                } else {
                                  UtilFsNav.showToast(
                                      "Signature Verification Failed! Try Again",
                                      context,
                                      AcountEnquiry());
                                  await LogCat().writeContent(
                                      'A/c Enquiry Screen : Signature Verification Failed.');
                                }
                              } else {
                                //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                print(response.statusCode);
                                List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                if(response.statusCode==503 || response.statusCode==504){
                                  UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,AcountEnquiry());
                                }
                                else
                                  UtilFsNav.showToast(error[0].Description.toString(), context,AcountEnquiry());
                              }
                            } catch (_) {
                              if (_.toString() == "TIMEOUT") {
                                return UtilFsNav.showToast("Request Timed Out",
                                    context, AcountEnquiry());
                              }
                            }
                          }
                          else {
                            UtilFs.showToast(
                                'Please enter either Reference Number or Date',
                                context);
                          }
                        },
                      ),
                      _verticalGroupValue == "Reference Number"
                          ? Visibility(
                              visible: datavisible,
                              child: datavisible == true
                                  ? Container(
                                      // child: Column(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Text("BO ID: ${display![0][0]} "),
                                      //     Text("Reference Number: ${display![0][1]}"),
                                      //     Text("Scheme: ${display![0][4]}"),
                                      //     Text("Amount of Transaction: ${display![0][5]}"),
                                      //     Text("Date: ${display![0][6]}"),
                                      //     Text("Account Holder Name:${display![0][8]}"),
                                      //   ],
                                      // ),
                                      child: Table(
                                        border: TableBorder.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 2),
                                        children: [
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [Text("BO ID:")],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][0]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Reference Number ")
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][1]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [Text("Scheme")],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][4]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [Text("ID")],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][2]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Amount of Transaction")
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][5]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [Text("Date ")],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][6]}")
                                              ],
                                            ),
                                          ]),
                                          TableRow(children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("Account Holder Name")
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text("${display![0][8]}")
                                              ],
                                            ),
                                          ])
                                        ],
                                      ),
                                    )
                                  : Container())
                          : Visibility(
                              child: datavisible == true
                                  ? Container(
                                      child: Column(
                                        children: [
                                          for (int i = 0;
                                              i < display!.length;
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Table(
                                                border: TableBorder.all(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 2),
                                                children: [
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [Text("BO ID:")],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][0]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Reference Number ")
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][1]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [Text("Scheme")],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][4]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [Text("ID")],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][2]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            "Amount of Transaction")
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][5]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [Text("Date ")],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][6]}")
                                                      ],
                                                    ),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            "Account Holder Name")
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("${display![i][8]}")
                                                      ],
                                                    ),
                                                  ])
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    )
                                  : Container())
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
        ));
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
          setState(() {
            _isVisible = false;
          }),
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

  _searchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 14, bottom: 4, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[300],
          boxShadow: [
            const BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 10,
                spreadRadius: 0),
            BoxShadow(
                color: Colors.grey[300]!,
                offset: const Offset(4, 4),
                blurRadius: 10,
                spreadRadius: 0),
          ],
        ),
        child: TextField(
          style: const TextStyle(
              fontSize: 17,
              color: //Colors.white,
                  Color.fromARGB(255, 2, 40, 86),
              fontWeight: FontWeight.w500),
          controller: myController,
          //=cbsData[0].REFERENCE_NO!,
          //  keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.account_balance_outlined,
                size: 22,
              ),
            ),
            hintStyle: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 2, 40, 86),
              fontWeight: FontWeight.w500,
            ),
            hintText: ' Enter Reference Number',
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.blueAccent, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.green, width: 1)),
            contentPadding:
                EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            suffixIcon: _getClearButton(),
          ),
        ),
      ),
    );
  }

  Future<String> encryption() async {
    var login = await USERDETAILS().select().toList();
    print("Reached writeContent");
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "getNewAccRef", "newAccNums");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <newAccNums>\n\n"
        '{"m_BoID":"${login[0].BOFacilityID}","responseParams":"newAccount"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("OAP Account$text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New Account Enquiry ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   print("Reached writeContent");
  //   Directory directory = Directory('$cachepath');
  //   final file=await File('$cachepath/OAP_Account.txt');
  //   file.writeAsStringSync('');
  //   // String text='{"2":"${login[0].SOL_DESC}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${login[0].SOL_DESC}","123":"SDP"}';
  //  // String text='{"2":"5007501G6997N","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        600017005007501G6997N","123":"SDP"}';
  //  String text='{"m_BoID":"${login[0].BOFacilityID}","responseParams":"newAccount"}';
  //   print("OAP Account$text");
  //   return file.writeAsString(text, mode: FileMode.append);
  // }
  Widget createTable() {
    List<TableRow> rows = [];

    rows.add(TableRow(children: [
      Text(kycStatus!),
      // Text("KYC Status " + isMinor==null?!),
      // Text("KYC Status " + dateOfBirth!),
      // Text("KYC Status " + isSuspended!),
      // Text("KYC Status " + name!),
      // Text("KYC Status " + status!),
      // Text("KYC Status " + dateTime!),
    ]));

    return Table(children: rows);
  }
}
