import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/accdetails.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/cashdepositcardstyle.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../AlertDialogChecker.dart';
import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../accdetails.dart';
import '../decryptHeader.dart';
import 'my_cards_screen.dart';

class CashDeposit extends StatefulWidget {
  @override
  _CashDepositState createState() => _CashDepositState();
}

class _CashDepositState extends State<CashDeposit> {
  final amountTextController = TextEditingController();
  final installmentTextController = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  bool _showClearButton = true;
  bool _isVisible = false;
  bool _isRDVisible = false;
  bool initTrans = false;
  bool fetchDet = false;
  bool _isDeposit = false;
  bool transactionvisible = false;
  Map main = {};
  String? balAftrTrn;
  List<TBCBS_TRAN_DETAILS> cbsDetails = [];
  Map depositmain = {};
  String? achname, schtype, cifID;
  String? instamt;
  String? bal, mainbal, balafterdeposit;
  final RegExp regexp = new RegExp(r'^0+(?=.)');
  String? processingDate,
      processingTime,
      processingDatetemp,
      processingTimetemp;
  String? InstallmentAmt;
  String? LateInstallmentsBeingPaidCount;
  String? lastTRNdate;
  String? instPaidTill;
  String? transDate;
  List? rec = [];
  List? rdGen = [];
  List? rdFinal = [];
  String? instChange;
  String title = "";
  bool _isDialogLoading = false;
  String? tid;
  late Directory d;
  late String cachepath;
  var installments;
  var installments1;

  // List? tranDet=[];
//  String? tranID,tranDate;
  bool _isLoading = false;
  bool _isNewLoading = false;
  var limits;
  final _formKey = GlobalKey<FormState>();
  late int minlimit;
  late int maxlimit;
  late int multiplier;
  String? encheader;

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
        (route) => false);
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
      // _isLoading = true;
    });
  }

  fetchlimits() async {
    limits = await CBS_LIMITS_CONFIG().select().toMapList();
    return limits;
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
                'Cash Deposit',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              backgroundColor: Color(0xFFB71C1C),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
            ),
            body: Form(
              key: _formKey,
              child: FutureBuilder(
                  future: fetchlimits(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                _searchBar(),
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
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _isVisible = false;
                                        _isRDVisible = false;
                                        initTrans = false;
                                        amountTextController.clear();
                                      });
                                      List<TBCBS_TRAN_DETAILS> acccheck =
                                          await TBCBS_TRAN_DETAILS()
                                              .select()
                                              .CUST_ACC_NUM
                                              .equals(myController.text)
                                              .and
                                              .startBlock
                                              .STATUS
                                              .equals("PENDING")
                                              .endBlock
                                              .toList();
                                      if (acccheck.length > 0) {
                                        UtilFsNav.showToast(
                                            "Please clear the pending transactions on the account before proceeding further for next deposit",
                                            context,
                                            CashDeposit());
                                      } else {
                                        var login = await USERDETAILS()
                                            .select()
                                            .toList();
                                        List<USERLOGINDETAILS> acctoken =
                                            await USERLOGINDETAILS()
                                                .select()
                                                .Active
                                                .equals(true)
                                                .toList();
                                        if (myController.text.isNotEmpty) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          encheader =
                                              await encryptfetchaccdetails();
                                          print(acctoken[0].AccessToken);
                                          try {
                                            // await fetchaccdetails();
                                            // String? goResponse=await Newenc.tester("$cachepath/fetchAccountDetails.txt","requestJson","jsonInStream");

                                            // encheader=await encryptfetchaccdetails(goResponse);

                                            // print("Go Response Received");
                                            // print(goResponse);
                                            print(encheader);
                                            var headers = {
                                              'Signature': '$encheader',
                                              // 'Uri': 'requestJson',
                                              'Uri': 'requestJson',
                                              // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                              'Authorization':
                                                  'Bearer ${acctoken[0].AccessToken}',
                                              'Cookie':
                                                  'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
                                              'Content-Type':
                                                  'multipart/form-data',
                                              // 'Contentid':'jsonInStream'
                                            };

                                            final File file = File('$cachepath/fetchAccountDetails.txt');
                                           String tosendText = await file.readAsString();
                                            var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                            request.body=tosendText;
                                            // var request = http.Request(
                                            //     'POST',
                                            //     Uri.parse(
                                            //         APIEndPoints().cbsURL1));
                                            // var request = http.Request(
                                            //     'POST',
                                            //     Uri.parse(
                                            //         'https://gateway.cept.gov.in:443/cbs/requestJson'));
                                            // request.files.add(await http
                                            //         .MultipartFile
                                            //     .fromPath('file',
                                            //         '$cachepath/fetchAccountDetails.txt'));
                                            // request.fields.addAll({'Content-ID':'<jsonInStream>'});

                                            // var request=http.Request('POST',Uri.parse(APIEndPoints().cbsURL));
                                            //  http.MultipartFile.fromPath('file', '$cachepath/fetchAccountDetails.txt');
                                            //
                                            // request.body=goResponse;
                                            //
                                            // // request.bodyFields.addAll({'file':'$cachepath/fetchAccountDetails.txt'});

                                            // var request=http.Request('POST',Uri.parse(APIEndPoints().cbsURL);
                                            // request.body=goResponse;
                                            // request.body;
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
                                            print(response.statusCode);
                                            // String res = await response.stream
                                            //     .bytesToString();
                                            // print(res);

                                            if (response.statusCode == 200) {
                                              var resheaders =
                                                  await response.headers;
                                              print("Result Headers");
                                              print(resheaders);
                                              // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
                                              String temp = resheaders['authorization']!;
                                              String res = await response.stream
                                                  .bytesToString();
                                              // String decryptSignature =
                                              //     await decryptHeader(t[1]);
                                              String decryptSignature = temp;
                                              String val = await decryption1(
                                                  decryptSignature, res);
                                              if (val == "Verified!") {
                                                await LogCat().writeContent(
                                                    '$res');

                                                Map a = json.decode(res);
                                                print(a['JSONResponse']
                                                    ['jsonContent']);
                                                String data = a['JSONResponse']
                                                    ['jsonContent'];
                                                main = json.decode(data);
                                                print("Values1");
                                                print(main);
                                                if (main['Status'] ==
                                                    "SUCCESS") {
                                                  print("Kjfasdkgjhakjdksfd");
                                                  if (main['39'] != "000") {
                                                    var ec =
                                                        await CBS_ERROR_CODES()
                                                            .select()
                                                            .Error_code
                                                            .equals(main['39'])
                                                            .toList();
                                                    print(
                                                        "Error received in acc enquiry: ${ec[0].Error_message}");
                                                    UtilFsNav.showToast(
                                                        '${ec[0].Error_message}',
                                                        context,
                                                        CashDeposit());
                                                    // Navigator.pushAndRemoveUntil(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             CashDeposit()),
                                                    //     (route) => false);
                                                  }
                                                  else {
                                                    List checkaccount =
                                                        await fac
                                                            .split126accenquiry(
                                                                main['126']);
                                                    print("Rakesh BO facility ID:${login[0].BOFacilityID}");
                                                    print(checkaccount[1].toString());
                                                    if (checkaccount[1] ==
                                                        login[0].BOFacilityID) {
                                                      rec = await fac.split125(
                                                          main['125']);
                                                      List? balances = await fac
                                                          .split48(main['48']);
                                                      String reduced =
                                                          balances![1]!
                                                              .replaceAll(
                                                                  regexp, '');
                                                      print("Reduced String");
                                                      print(reduced);
                                                      if (reduced == "0") {
                                                        mainbal = "0.00";
                                                      } else {
                                                        mainbal = StringUtils
                                                            .addCharAtPosition(
                                                                reduced,
                                                                ".",
                                                                reduced.length -
                                                                    2);
                                                      }
                                                      achname = rec![1];
                                                      schtype = rec![4];
                                                      cifID = rec![0];
                                                      // instChange=rdinteger.toString();
                                                      print(
                                                          "Scheme Type: ${schtype}");
                                                      switch (schtype) {
                                                        case "RDIPN":
                                                          print(
                                                              "RD Switch case");
                                                          rdGen = await fac
                                                              .split126RDGEN(
                                                                  main['126']);
                                                          String rdInst =
                                                              rdGen![3];
                                                          int rdinteger =
                                                              int.parse(rdInst)
                                                                  .toInt();
                                                          instamt =
                                                              (rdinteger * 6)
                                                                  .toString();
                                                          List? rec = await fac
                                                              .split126RD(
                                                                  main['126']);
                                                          InstallmentAmt =
                                                              rec![3];
                                                          LateInstallmentsBeingPaidCount =
                                                              rec[10].split(
                                                                  '.')[0];
                                                          lastTRNdate = rec[2];
                                                          instPaidTill =
                                                              rec[12];
                                                          List? balances =
                                                              await fac.split48(
                                                                  main['48']);
                                                          String reduced =
                                                              balances![1]!
                                                                  .replaceAll(
                                                                      regexp,
                                                                      '');

                                                          // mainbal = StringUtils
                                                          //     .addCharAtPosition(
                                                          //         reduced,
                                                          //         ".",
                                                          //         reduced.length -
                                                          //             2);
                                                          if (reduced == "0") {
                                                            mainbal = "0.00";
                                                          }
                                                          else {
                                                            mainbal =
                                                                StringUtils
                                                                    .addCharAtPosition(
                                                                    reduced,
                                                                    ".",
                                                                    reduced
                                                                        .length -
                                                                        2);
                                                          }
                                                          List? list125 =
                                                              await fac.split125(
                                                                  main['125']);
                                                          achname = list125![1];
                                                          schtype = list125[4];
                                                          cifID = list125[0];
                                                          if (rec[11] == "N")
                                                            _isRDVisible = true;
                                                          else
                                                            UtilFsNav.showToast(
                                                                "Account entered is Agent Linked. Cannot process Transaction",
                                                                context,
                                                                CashDeposit());
                                                          //       }
                                                          //     }
                                                          //   }
                                                          // }
                                                          break;
                                                        case "TDIP1":
                                                          UtilFsNav.showToast(
                                                              "Account is a TD account. Cannot perform Deposit Transactions",
                                                              context,
                                                              CashDeposit());
                                                          break;
                                                        case "TDIP2":
                                                          UtilFsNav.showToast(
                                                              "Account is a TD account. Cannot perform Deposit Transactions",
                                                              context,
                                                              CashDeposit());
                                                          break;
                                                        case "TDIP3":
                                                          UtilFsNav.showToast(
                                                              "Account is a TD account. Cannot perform Deposit Transactions",
                                                              context,
                                                              CashDeposit());
                                                          break;
                                                        case "TDIP5":
                                                          UtilFsNav.showToast(
                                                              "Account is a TD account. Cannot perform Deposit Transactions",
                                                              context,
                                                              CashDeposit());
                                                          break;

                                                        case "SSA  ":
                                                          print(
                                                              "SSA Switch case");
                                                          _isVisible = true;
                                                          break;
                                                        case "SBGEN":
                                                          print(
                                                              "SBGEN Switch case");
                                                          _isVisible = true;
                                                          break;
                                                        case "SBBAS":
                                                          print(
                                                              "SBBAS Switch case");
                                                          _isVisible = true;
                                                          break;
                                                        // case "SBCHQ":
                                                        //   print(
                                                        //       "SBCHQ Switch case");
                                                        //   _isVisible = true;
                                                        //   break;
                                                        default:
                                                          _isVisible = true;
                                                      }
                                                      // setState(() {
                                                      //   _isVisible = true;
                                                      // });
                                                    } else {
                                                      UtilFsNav.showToast(
                                                          "Account Number Entered doesnot belong to this BO",
                                                          context,
                                                          CashDeposit());
                                                    }
                                                  }
                                                }
                                                else {
                                                  UtilFsNav.showToast(
                                                      "${response.reasonPhrase!}\n${main['errorMsg']}",
                                                      context,
                                                      CashDeposit());
                                                  // UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                                }
                                              } else {
                                                UtilFsNav.showToast(
                                                    "Signature Verification Failed! Try Again",
                                                    context,
                                                    CashDeposit());
                                                await LogCat().writeContent(
                                                    'Cash Deposit Screen: Signature Verification Failed.');
                                              }
                                              // }
                                            } else {
                                              //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                              print(response.statusCode);
                                              List<API_Error_code> error =
                                                  await API_Error_code()
                                                      .select()
                                                      .API_Err_code
                                                      .equals(
                                                          response.statusCode)
                                                      .toList();
                                              if (response.statusCode == 503 ||
                                                  response.statusCode == 504) {
                                                UtilFsNav.showToast(
                                                    "CBS " +
                                                        error[0]
                                                            .Description
                                                            .toString(),
                                                    context,
                                                    CashDeposit());
                                              } else
                                                UtilFsNav.showToast(
                                                    error[0]
                                                        .Description
                                                        .toString(),
                                                    context,
                                                    CashDeposit());

                                              // UtilFsNav.showToast(
                                              //     "${response.statusCode}",
                                              //     context,
                                              //     CashDeposit());
                                            }
                                          } catch (_) {
                                            if (_.toString() == "TIMEOUT") {
                                              return UtilFsNav.showToast(
                                                  "Request Timed Out",
                                                  context,
                                                  CashDeposit());
                                            } else {
                                              print(_);
                                            }
                                          }
                                        } else {
                                          UtilFs.showToast(
                                            "Enter Account Number",
                                            context,
                                          );
                                        }
                                      }
                                    }),
                                Visibility(
                                  visible: _isVisible,
                                  child: Column(
                                    children: [
                                      Text(
                                          accountType.text + ' Account Details',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blueGrey)),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Table(
                                          border: TableBorder.all(),
                                          children: [
                                            TableRow(
                                              children: [
                                                Column(children: [
                                                  Text('Account No.',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                                Column(children: [
                                                  Text(myController.text,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Column(children: [
                                                  Text('CIF ID',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                                Column(children: [
                                                  Text(cifID.toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Column(children: [
                                                  Text('Name',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                                Column(children: [
                                                  Text(
                                                      '${achname.toString().trim()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Column(children: [
                                                  Text('Scheme Type',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                          Colors.grey[600]))
                                                ]),
                                                Column(children: [
                                                  Text(
                                                      '${ schtype.toString().trim()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                          Colors.grey[600]))
                                                ]),
                                              ],
                                            ),
                                            TableRow(
                                              children: [
                                                Column(children: [
                                                  Text('Account Balance',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                                Column(children: [
                                                  Text('\u{20B9} $mainbal',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[600]))
                                                ]),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Amount of Transaction';
                                            }
                                            // else if (int.parse(
                                            //     amountTextController.text
                                            //         .toString()) >
                                            //     maxlimit) {
                                            //   return 'Enter the transaction amount less than or equal to $maxlimit';
                                            // }
                                            else {
                                              print("ELse statement");
                                              print(limits.length);
                                              print(amountTextController.text);
                                              print(rec![4]);
                                              for (int i = 0;
                                                  i < limits.length;
                                                  i++) {
                                                // print(rec![4]);
                                                // if (rec![4] == "SBGEN" || rec![4] == "SBBAS") {
                                                if (rec![4].contains("SB")) {
                                                  print("Entered as SBGEN");
                                                  if (limits[i]['type'] ==
                                                      "SB_ACCOPEN_minLimit") {
                                                    minlimit = int.parse(
                                                        limits[i]
                                                            ['tranlimits']);
                                                  }
                                                  if (limits[i]['type'] ==
                                                      "Deposit_Limit") {
                                                    maxlimit = int.parse(
                                                        limits[i]
                                                            ['tranlimits']);
                                                  }
                                                } else if (rec![4]
                                                        .toString()
                                                        .trim() ==
                                                    "SSA") {
                                                  print("Entered as SSA");
                                                  if (limits[i]['type'] ==
                                                      "SSA_Deposit_Multiplier") {
                                                    minlimit = int.parse(
                                                        limits[i]
                                                            ['tranlimits']);
                                                  }
                                                  if (limits[i]['type'] ==
                                                      'SSA_Deposit_Multiplier') {
                                                    multiplier = int.parse(
                                                        limits[i]
                                                            ['tranlimits']);
                                                  }
                                                  if (limits[i]['type'] ==
                                                      "Deposit_Limit") {
                                                    maxlimit = int.parse(
                                                        limits[i]
                                                            ['tranlimits']);
                                                  }
                                                }
                                              }
                                              if (rec![4] == "SSA")
                                                print(
                                                    "Multiplier: $multiplier");

                                              // if (rec![4] == "SBGEN" &&
                                              //     int.parse(amountTextController
                                              //             .text
                                              //             .toString()) <
                                              //         minlimit) {
                                              //   return 'SB Minimum Deposit Limit is $minlimit';
                                              // }
                                              else if (rec![4] == "SBGEN" &&
                                                  int.parse(amountTextController
                                                          .text
                                                          .toString()) >
                                                      maxlimit) {
                                                return 'Enter the transaction amount less than or equal to $maxlimit';
                                              } else if (rec![4]
                                                          .toString()
                                                          .trim() ==
                                                      "SSA" &&
                                                  int.parse(amountTextController
                                                          .text
                                                          .toString()) <
                                                      minlimit) {
                                                return 'SSA Deposit Limit is $minlimit';
                                              } else if (rec![4]
                                                          .toString()
                                                          .trim() ==
                                                      "SSA" &&
                                                  int.parse(amountTextController
                                                              .text
                                                              .toString())
                                                          .remainder(
                                                              multiplier) !=
                                                      0) {
                                                return 'SSA Deposit value should be in multiples of $multiplier';
                                              }
                                            }
                                            return null;
                                          },
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: //Colors.white,
                                                  Color.fromARGB(
                                                      255, 2, 40, 86),
                                              fontWeight: FontWeight.w500),
                                          controller: amountTextController,
                                          maxLength: 5,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Icon(
                                                MdiIcons.currencyInr,
                                                size: 22,
                                              ),
                                            ),
                                            hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 2, 40, 86),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            hintText: ' Enter Amount',
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent,
                                                    width: 1)),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.green,
                                                    width: 1)),
                                            contentPadding: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 20,
                                                right: 20),
                                            suffixIcon: _getAmtClearButton(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: RaisedButton(
                                            child: Text('Initiate Transaction',
                                                style: TextStyle(fontSize: 16)),
                                            color: Color(0xFFB71C1C),
                                            //Colors.green,
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            onPressed: () async {
                                              FocusScope.of(context).unfocus();
                                              print(rec![4]);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                var amountdone = 0;
                                                var amcheck =
                                                    await TBCBS_TRAN_DETAILS()
                                                        .select()
                                                        .CUST_ACC_NUM
                                                        .equals(
                                                            myController.text)
                                                        .and
                                                        .startBlock
                                                        .STATUS
                                                        .equals("SUCCESS")
                                                        .and
                                                        .TRAN_DATE
                                                        .equals(
                                                            DateTimeDetails()
                                                                .onlyExpDate())
                                                        .endBlock
                                                        .toList();
                                                for (int i = 0;
                                                    i < amcheck.length;
                                                    i++) {
                                                  amountdone = amountdone +
                                                      int.parse(amcheck[i]
                                                          .TRANSACTION_AMT!);
                                                  print(amountdone);
                                                  print(maxlimit);
                                                }
                                                if ((amountdone +
                                                        int.parse(
                                                            amountTextController
                                                                .text
                                                                .toString())) >
                                                    maxlimit) {
                                                  UtilFsNav.showToast(
                                                      "Transaction limit reached for the entered account for the day",
                                                      context,
                                                      CashDeposit());
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                          return Stack(
                                                            children: [
                                                              AlertDialog(
                                                                title: Text(
                                                                    'Confirmation'),
                                                                content: Text(
                                                                    'Do you want to proceed with the deposit of Rs.' +
                                                                        amountTextController
                                                                            .text +
                                                                        ', Please'
                                                                            ' note that transaction once initiated cannot be reverted.'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                      child: Text(
                                                                          "YES"),
                                                                      style: ButtonStyle(
                                                                          // elevation:MaterialStateProperty.all(),
                                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                      onPressed: () async {
                                                                        var login = await USERDETAILS()
                                                                            .select()
                                                                            .toList();
                                                                        // Navigator.pop(context);
                                                                        setState(
                                                                            () {
                                                                          _isNewLoading =
                                                                              true;
                                                                        });
                                                                        tid = GenerateRandomString()
                                                                            .randomString();

                                                                        encheader =
                                                                            await encryptfetchdepositdetails(tid!);

                                                                        await TBCBS_TRAN_DETAILS(
                                                                                DEVICE_TRAN_ID: tid,
                                                                                TRANSACTION_ID: tid,
                                                                                ACCOUNT_TYPE: '$schtype',
                                                                                OPERATOR_ID: '${login[0].EMPID}',
                                                                                CUST_ACC_NUM: myController.text.toString(),
                                                                                TRANSACTION_AMT: amountTextController.text.toString(),
                                                                                TRAN_DATE: '${DateTimeDetails().onlyExpDate()}',
                                                                                TRAN_TIME: '${DateTimeDetails().onlyTime()}',
                                                                                TRAN_TYPE: 'D',
                                                                                DEVICE_TRAN_TYPE: 'CD',
                                                                                CURRENCY: 'INR',
                                                                                MODE_OF_TRAN: 'Cash',
                                                                                FIN_SOLBOD_DATE: DateTimeDetails().onlyDate(),
                                                                                TENURE: '0',
                                                                                INSTALMENT_AMT: '0',
                                                                                NO_OF_INSTALMENTS: '0',
                                                                                REBATE_AMT: '0',
                                                                                DEFAULT_FEE: '0',
                                                                                STATUS: 'PENDING',
                                                                                MAIN_HOLDER_NAME: '$achname',
                                                                                SCHEME_TYPE: '$schtype')
                                                                            .upsert();
                                                                        List<USERLOGINDETAILS> acctoken = await USERLOGINDETAILS()
                                                                            .select()
                                                                            .Active
                                                                            .equals(true)
                                                                            .toList();
                                                                        try {
                                                                        var headers =
                                                                            {
                                                                          'Signature':
                                                                              '$encheader',
                                                                          'Uri':
                                                                              'requestJson',
                                                                          // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                          'Authorization':
                                                                              'Bearer ${acctoken[0].AccessToken}',
                                                                          'Cookie':
                                                                              'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                        };
                                                                        // var request =
                                                                        // http
                                                                        //     .Request(
                                                                        //     'POST',
                                                                        //     Uri.parse(
                                                                        //         'https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                                        // request.files
                                                                        //     .add(
                                                                        //     await http
                                                                        //         .MultipartFile
                                                                        //         .fromPath(
                                                                        //         '',
                                                                        //         '$cachepath/fetchAccountDetails.txt'));


                                                                          final File file = File('$cachepath/fetchAccountDetails.txt');
                                                                          String tosendText = await file.readAsString();
                                                                          var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                          request.body=tosendText;
                                                                          request
                                                                              .headers
                                                                              .addAll(headers);
                                                                          http.StreamedResponse
                                                                              response =
                                                                              await request.send().timeout(const Duration(seconds: 65), onTimeout: () {
                                                                            // return UtilFs.showToast('The request Timeout',context);
                                                                            setState(() {
                                                                              _isLoading = false;
                                                                            });
                                                                            throw 'TIMEOUT';
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            _isLoading =
                                                                                false;
                                                                          });
                                                                          if (response.statusCode ==
                                                                              200) {
                                                                            var resheaders =
                                                                                await response.headers;
                                                                            print("Result Headers");
                                                                            print(resheaders);
                                                                              // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;

                                                                            String
                                                                                res =
                                                                                await response.stream.bytesToString();

                                                                            String
                                                                                val =
                                                                                await decryption1(decryptSignature, res);
                                                                            if (val ==
                                                                                "Verified!") {
                                                                              await LogCat().writeContent('$res');

                                                                              Map a = json.decode(res);
                                                                              print(a['JSONResponse']['jsonContent']);
                                                                              String data = a['JSONResponse']['jsonContent'];
                                                                              depositmain = json.decode(data);
                                                                              print(depositmain);
                                                                              if (depositmain['Status'] == "SUCCESS") {
                                                                                if (depositmain['39'] != "000") {
                                                                                  var ec = await CBS_ERROR_CODES().select().Error_code.equals(depositmain['39']).toList();
                                                                                  // Navigator.pop(context);
                                                                                  UtilFsNav.showToast('${ec[0].Error_message}: ${depositmain['127']}', context, CashDeposit());
                                                                                  await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                                    'STATUS': 'FAILED'
                                                                                  });
                                                                                  // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CashDeposit()), (route) => false);
                                                                                } else {
                                                                                  var currentDate = DateTimeDetails().onlyDatewithFormat();
                                                                                  var currentTime = DateTimeDetails().onlyTime();
                                                                                  var balance = depositmain['48'].split('+')[2];
                                                                                  balance = int.parse(balance) > 0 ? (int.parse(balance) / 100).toStringAsFixed(2).toString() : "0.00";
                                                                                  var TranID = depositmain['126'].split('_')[0].toString().trim();
                                                                                  var trandate = depositmain['126'].split('_')[1];
                                                                                  print(TranID);
                                                                                  final addCash =  CashTable()
                                                                                    ..Cash_ID = myController.text
                                                                                    ..Cash_Date = DateTimeDetails().currentDate()
                                                                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                                                                    ..Cash_Type = 'Add'
                                                                                    ..Cash_Amount = double.parse(amountTextController.text)
                                                                                    ..Cash_Description = "$schtype deposit";
                                                                                  await addCash.save();
                                                                                  final addTransaction = TransactionTable()
                                                                                    ..tranid = '$TranID'
                                                                                    ..tranDescription = "$schtype deposit"
                                                                                    ..tranAmount = double.parse(amountTextController.text)
                                                                                    ..tranType = "CBS"
                                                                                    ..tranDate = DateTimeDetails().currentDate()
                                                                                    ..tranTime = DateTimeDetails().onlyTime()
                                                                                    ..valuation = "Add";

                                                                                  await addTransaction.save();

                                                                                  await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                                    'TRANSACTION_ID': '$TranID',
                                                                                    'STATUS': 'SUCCESS'
                                                                                  });

                                                                                  // final tranDetails =
                                                                                  // TBCBS_TRAN_DETAILS()
                                                                                  //   ..TRANSACTION_ID =
                                                                                  //       TranID
                                                                                  //   ..TRANSACTION_AMT =
                                                                                  //       amountTextController
                                                                                  //           .text
                                                                                  //   ..TRAN_DATE =
                                                                                  //       trandate
                                                                                  //   ..TRAN_TIME =
                                                                                  //       currentTime
                                                                                  //   ..CUST_ACC_NUM =
                                                                                  //       myController
                                                                                  //           .text
                                                                                  //   ..ACCOUNT_TYPE =
                                                                                  //   rec![4]
                                                                                  //   ..STATUS =
                                                                                  //   depositmain[
                                                                                  //   'Status']
                                                                                  //   ..REMARKS =
                                                                                  //       "Deposit";
                                                                                  // tranDetails.save();
                                                                                  cbsDetails = await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                                                                                  print("cbsDetails");
                                                                                  print(cbsDetails);
                                                                                  print('status');
                                                                                  print(cbsDetails[0].STATUS);
                                                                                  for (int i = 0; i < cbsDetails.length; i++) {
                                                                                    print(cbsDetails[i].toMap());
                                                                                  }
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (_) => CashDepositAmount(cbsDetails[0].TRANSACTION_ID, amountTextController.text, currentDate, currentTime, cbsDetails[0].CUST_ACC_NUM, cbsDetails[0].ACCOUNT_TYPE, "Deposit", balance, schtype)));
                                                                                }
                                                                              }
                                                                            } else {
                                                                              UtilFsNav.showToast("Signature Verification Failed! Try Again", context, CashDeposit());
                                                                              await LogCat().writeContent('Cash deposit Screen: Signature Verification Failed.');
                                                                            }
                                                                          }
                                                                          // }
                                                                          else {
                                                                            // UtilFsNav.showToast(
                                                                            //     "${response.reasonPhrase!}\n${await response.stream.bytesToString()}",
                                                                            //     context,
                                                                            //     CashDeposit());

                                                                            print(response.statusCode);
                                                                            List<API_Error_code>
                                                                                error =
                                                                                await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                                            if (response.statusCode == 503 ||
                                                                                response.statusCode == 504) {
                                                                              UtilFsNav.showToast("CBS " + error[0].Description.toString(), context, CashDeposit());
                                                                            } else
                                                                              UtilFsNav.showToast(error[0].Description.toString(), context, CashDeposit());
                                                                            // UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                                                          }
                                                                          // Navigator.pop(context);
                                                                        } catch (_) {
                                                                          if (_.toString() ==
                                                                              "TIMEOUT") {
                                                                            return UtilFsNav.showToast(
                                                                                "Request Timed Out",
                                                                                context,
                                                                                CashDeposit());
                                                                          }
                                                                        }
                                                                      }),
                                                                  TextButton(
                                                                    child: Text(
                                                                      "CANCEL",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    style: ButtonStyle(
                                                                        // elevation:MaterialStateProperty.all(),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.grey)))),
                                                                    onPressed:
                                                                        () {
                                                                      //Put your code here which you want to execute on Cancel button click.
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              _isNewLoading ==
                                                                      true
                                                                  ? Loader(
                                                                      isCustom:
                                                                          true,
                                                                      loadingTxt:
                                                                          'Please Wait...Loading...')
                                                                  : Container()
                                                            ],
                                                          );
                                                        });
                                                      });
                                                }
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                _isRDVisible == true
                                    ? Column(
                                        children: [
                                          Text(
                                              accountType.text +
                                                  ' Account Details',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blueGrey)),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Table(
                                              border: TableBorder.all(),
                                              children: [
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text('Account No.',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(myController.text,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text('Name',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                        '$achname',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[600]),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text('Scheme Type',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                              Colors.grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                          '${ schtype.toString().trim()}',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                              Colors.grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text('Account Balance',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text('\u{20B9} $mainbal',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text(
                                                          'Installment amount:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                          '\u{20B9} $InstallmentAmt',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text(
                                                          'Installments paid till:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text('$instPaidTill',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text(
                                                          'Last installment paid on:',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text('$lastTRNdate',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                  ],
                                                ),
                                              ]),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          initTrans == false
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: //Colors.white,
                                                            Color.fromARGB(
                                                                255, 2, 40, 86),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    controller:
                                                        amountTextController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Icon(
                                                          MdiIcons.currencyInr,
                                                          size: 22,
                                                        ),
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 2, 40, 86),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      hintText: ' Enter Amount',
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  width: 3)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          3)),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20,
                                                              left: 20,
                                                              right: 20),
                                                      suffixIcon:
                                                          _getAmtClearButton(),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: TextField(
                                                    readOnly: true,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: //Colors.white,
                                                            Color.fromARGB(
                                                                255, 2, 40, 86),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    controller:
                                                        amountTextController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      prefixIcon: const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Icon(
                                                          MdiIcons.currencyInr,
                                                          size: 22,
                                                        ),
                                                      ),
                                                      hintStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 2, 40, 86),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      hintText: ' Enter Amount',
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  width: 3)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          3)),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20,
                                                              left: 20,
                                                              right: 20),
                                                      suffixIcon:
                                                          _getAmtClearButton(),
                                                    ),
                                                  ),
                                                ),
                                          initTrans == true
                                              ? Container()
                                              : Container(
                                                  child: RaisedButton(
                                                      child: Text(
                                                          'Fetch Additional Details',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      color: Color(0xFFB71C1C),
                                                      //Colors.green,
                                                      textColor: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      onPressed: () async {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        int am = int.parse(
                                                            amountTextController
                                                                .text
                                                                .toString());
                                                        int ins = int.parse(
                                                            InstallmentAmt
                                                                .toString());
                                                        List<USERLOGINDETAILS>
                                                            acctoken =
                                                            await USERLOGINDETAILS()
                                                                .select()
                                                                .toList();
                                                        installments =
                                                            am.remainder(ins);
                                                        installments1 =
                                                            (am / ins).floor();
                                                        print(installments);
                                                        if (installments == 0) {
                                                          encheader =
                                                              await encryptfetchRDaccdetails();
                                                          // var request = http.Request(
                                                          //     'POST',
                                                          //     Uri.parse(
                                                          //         'https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                          // request.files.add(await http
                                                          //     .MultipartFile
                                                          //     .fromPath('',
                                                          //     '$cachepath/fetchRDAccountDetails.txt'));
                                                          try {
                                                            var headers = {
                                                              'Signature':
                                                                  '$encheader',
                                                              'Uri':
                                                                  'requestJson',
                                                              // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                              'Authorization':
                                                                  'Bearer ${acctoken[0].AccessToken}',
                                                              'Cookie':
                                                                  'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                            };


                                                            final File file = File('$cachepath/fetchAccountDetails.txt');
                                                            String tosendText = await file.readAsString();
                                                            var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                            request.body=tosendText;

                                                            request.headers
                                                                .addAll(
                                                                    headers);
                                                            http.StreamedResponse
                                                                response =
                                                                await request.send().timeout(
                                                                    const Duration(
                                                                        seconds:
                                                                            65),
                                                                    onTimeout:
                                                                        () {
                                                              // return UtilFs.showToast('The request Timeout',context);
                                                              setState(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                              throw 'TIMEOUT';
                                                            });
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                            if (response
                                                                    .statusCode ==
                                                                200) {
                                                              var resheaders =
                                                                  await response
                                                                      .headers;
                                                              print(
                                                                  "Result Headers");
                                                              print(resheaders);
                                                              List t = resheaders[
                                                                      'authorization']!
                                                                  .split(
                                                                      ", Signature:");
                                                              String res =
                                                                  await response
                                                                      .stream
                                                                      .bytesToString();
                                                              String temp = resheaders['authorization']!;
                                                              String decryptSignature = temp;

                                                              String val =
                                                              await decryption1(decryptSignature, res);
                                                              if (val ==
                                                                  "Verified!") {
                                                                await LogCat()
                                                                    .writeContent(
                                                                        '${DateTimeDetails().currentDateTime()} : $res\n\n');
                                                                Map a =
                                                                    json.decode(
                                                                        res);
                                                                print(
                                                                    "Fetch acc details");
                                                                print(a['JSONResponse']
                                                                    [
                                                                    'jsonContent']);
                                                                String data = a[
                                                                        'JSONResponse']
                                                                    [
                                                                    'jsonContent'];
                                                                main =
                                                                    json.decode(
                                                                        data);
                                                                print("Values");
                                                                print(main);
                                                                bool
                                                                    accountInvalidFlag =
                                                                    false;
                                                                String
                                                                    invalidMessage =
                                                                    "";
                                                                String
                                                                    caseResponse =
                                                                    await statusMessage(
                                                                        main[
                                                                            '125']);
                                                                print(
                                                                    'casmethod');
                                                                print(
                                                                    caseResponse);
                                                                if (caseResponse !=
                                                                    'false') {
                                                                  accountInvalidFlag =
                                                                      true;
                                                                  invalidMessage =
                                                                      caseResponse;
                                                                }

                                                                if (accountInvalidFlag) {
                                                                  UtilFsNav.showToast(
                                                                      "Entered account number doesnot exist",
                                                                      context,
                                                                      CashDeposit());
                                                                } else {
                                                                  if (main[
                                                                          'Status'] ==
                                                                      "SUCCESS") {
                                                                    if (main[
                                                                            '39'] !=
                                                                        "000") {
                                                                      print(main[
                                                                          "127"]);
                                                                      UtilFsNav.showToast(
                                                                          main[
                                                                              '127'],
                                                                          context,
                                                                          CashDeposit());
                                                                    } else {
                                                                      rdFinal =
                                                                          await fac
                                                                              .split126RDGEN(main['126']);
                                                                      setState(
                                                                          () {
                                                                        initTrans =
                                                                            true;
                                                                      });
                                                                    }
                                                                  }
                                                                }
                                                              } else {
                                                                UtilFsNav.showToast(
                                                                    "Signature Verification Failed! Try Again",
                                                                    context,
                                                                    CashDeposit());
                                                                await LogCat()
                                                                    .writeContent(
                                                                        '${DateTimeDetails().currentDateTime()} :Cash deposit Screen: Signature Verification Failed.\n\n');
                                                              }
                                                            } else {
                                                              //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                                              print(response
                                                                  .statusCode);
                                                              List<API_Error_code>
                                                                  error =
                                                                  await API_Error_code()
                                                                      .select()
                                                                      .API_Err_code
                                                                      .equals(response
                                                                          .statusCode)
                                                                      .toList();
                                                              if (response.statusCode ==
                                                                      503 ||
                                                                  response.statusCode ==
                                                                      504) {
                                                                UtilFsNav.showToast(
                                                                    "CBS " +
                                                                        error[0]
                                                                            .Description
                                                                            .toString(),
                                                                    context,
                                                                    CashDeposit());
                                                              } else
                                                                UtilFsNav.showToast(
                                                                    error[0]
                                                                        .Description
                                                                        .toString(),
                                                                    context,
                                                                    CashDeposit());
                                                              // UtilFsNav.showToast(
                                                              //     "${await response.stream.bytesToString()}",
                                                              //     context,
                                                              //     CashDeposit());
                                                            }
                                                          } catch (_) {
                                                            if (_.toString() ==
                                                                "TIMEOUT") {
                                                              return UtilFsNav
                                                                  .showToast(
                                                                      "Request Timed Out",
                                                                      context,
                                                                      CashDeposit());
                                                            }
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                          UtilFs.showToast(
                                                              "Enter installment amount equal to $InstallmentAmt or in multiples of $InstallmentAmt",
                                                              context);
                                                        }
                                                      }),
                                                ),
                                          initTrans == true
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      // Column(
                                                      //     children:[
                                                      //       Text('Rebate: ${rdFinal![7]} '),
                                                      //       Text('Late Fee: ${rdFinal![8]}'),
                                                      //       Text('Final Transaction Amount:${rdFinal![9]} '),
                                                      //     ]
                                                      // ),
                                                      Table(
                                                        border:
                                                            TableBorder.all(),
                                                        children: [
                                                          TableRow(children: [
                                                            Column(
                                                                children: [
                                                                  Text("Rebate",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[600]))
                                                                ]),
                                                            Column(
                                                                children: [
                                                                  Text(
                                                                      "${rdFinal![7]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[600]))
                                                                ])
                                                          ]),
                                                          TableRow(children: [
                                                            Column(
                                                                children: [
                                                                  Text(
                                                                      "Default Fee",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[600]))
                                                                ]),
                                                            Column(
                                                                children: [
                                                                  Text(
                                                                      "${rdFinal![8]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[600]))
                                                                ])
                                                          ]),
                                                          TableRow(children: [
                                                            Column(children: [
                                                              Text(
                                                                  "Final Transaction Amount",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                              .grey[
                                                                          600]))
                                                            ]),
                                                            Column(
                                                                children: [
                                                                  Text(
                                                                      "${rdFinal![9]}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey[600]))
                                                                ])
                                                          ])
                                                        ],
                                                      ),
                                                      TextButton(
                                                          child: Text(
                                                              'Initiate Transaction',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                          style: ButtonStyle(
                                                              // elevation:MaterialStateProperty.all(),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .red)))),
                                                          onPressed: () async {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                    return Stack(
                                                                      children: [
                                                                        AlertDialog(
                                                                          title:
                                                                              Text('Confirmation'),
                                                                          content: Text('Do you want to proceed with the deposit of Rs.' +
                                                                              rdFinal![9] +
                                                                              ', Please'
                                                                                  ' note that transaction once initiated cannot be reverted.'),
                                                                          actions: <
                                                                              Widget>[
                                                                            TextButton(
                                                                              style: ButtonStyle(
                                                                                  // elevation:MaterialStateProperty.all(),
                                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                              child: Text("YES"),
                                                                              onPressed: () async {
                                                                                setState(() {
                                                                                  _isNewLoading = true;
                                                                                });
                                                                                print(_isNewLoading);
                                                                                List<USERDETAILS> login = await USERDETAILS().select().toList();

                                                                                // Navigator.pop(context);
                                                                                tid = GenerateRandomString().randomString();

                                                                                encheader = await encryptfetchRDdepositdetails(tid!);
                                                                                await TBCBS_TRAN_DETAILS(DEVICE_TRAN_ID: tid, TRANSACTION_ID: tid, ACCOUNT_TYPE: 'RD', OPERATOR_ID: '${login[0].EMPID}', CUST_ACC_NUM: myController.text.toString(), TRANSACTION_AMT: rdFinal![9], TRAN_DATE: '${DateTimeDetails().onlyExpDate()}', TRAN_TIME: '${DateTimeDetails().onlyTime()}', TRAN_TYPE: 'D', DEVICE_TRAN_TYPE: 'CD', CURRENCY: 'INR', MODE_OF_TRAN: 'Cash', FIN_SOLBOD_DATE: DateTimeDetails().onlyDate(), TENURE: '60', INSTALMENT_AMT: '$InstallmentAmt', NO_OF_INSTALMENTS: '$installments1', REBATE_AMT: '${rdFinal![7]}', DEFAULT_FEE: '${rdFinal![8]}', STATUS: 'PENDING', MAIN_HOLDER_NAME: '$achname', SCHEME_TYPE: '$schtype').upsert();
                                                                                List<USERLOGINDETAILS> acctoken = await USERLOGINDETAILS().select().toList();

                                                                                try {
                                                                                  var headers = {
                                                                                    'Signature': '$encheader',
                                                                                    'Uri': 'requestJson',
                                                                                    // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                                                                    'Authorization': 'Bearer ${acctoken[0].AccessToken}',
                                                                                    'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                                                                  };

                                                                                  final File file = File('$cachepath/fetchAccountDetails.txt');
                                                                                  String tosendText = await file.readAsString();
                                                                                  var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
                                                                                  request.body=tosendText;
                                                                                  request.headers.addAll(headers);

                                                                                  // var request =
                                                                                  //     http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                                                                                  // request.files.add(await http.MultipartFile.fromPath('',
                                                                                  //     '$cachepath/RDfetchAccountDetails.txt'));
                                                                                  http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 65), onTimeout: () {
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
                                                                                     // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;
                                                                                    String res = await response.stream.bytesToString();
                                                                                    
                                                                                    String val = await decryption1(decryptSignature, res);
                                                                                    if (val == "Verified!") {
                                                                                      await LogCat().writeContent('$res');
                                                                                      Map a = json.decode(res);
                                                                                      print(a['JSONResponse']['jsonContent']);
                                                                                      String data = a['JSONResponse']['jsonContent'];
                                                                                      depositmain = json.decode(data);
                                                                                      print(depositmain);
                                                                                      if (depositmain['Status'] == "SUCCESS") {
                                                                                        if (depositmain['39'] != "000") {
                                                                                          setState(() {
                                                                                            _isNewLoading = false;
                                                                                          });
                                                                                          if (depositmain['127'] == null) {
                                                                                            var ec = await CBS_ERROR_CODES().select().Error_code.equals(depositmain['39']).toList();
                                                                                            // Navigator.pop(context);
                                                                                            // UtilFs
                                                                                            //     .showToast(
                                                                                            //     '${ec[0]
                                                                                            //         .Error_message}: ${depositmain['127']}',
                                                                                            //     context);
                                                                                            UtilFsNav.showToast('${ec[0].Error_message}', context, CashDeposit());
                                                                                          } else
                                                                                            UtilFsNav.showToast('${depositmain['127']}', context, CashDeposit());
                                                                                          await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                                            'STATUS': 'FAILED'
                                                                                          });

                                                                                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CashDeposit()), (route) => false);
                                                                                        } else {
                                                                                          print(rec![4]);

                                                                                          var currentDate = DateTimeDetails().onlyDatewithFormat();
                                                                                          var currentTime = DateTimeDetails().onlyTime();
                                                                                          var balance = depositmain['48'].split('+')[2];
                                                                                          balance = int.parse(balance) > 0 ? (int.parse(balance) / 100).toStringAsFixed(2).toString() : "0.00";
                                                                                          var TranID = depositmain['126'].split('_')[0].toString().trim();
                                                                                          var trandate = depositmain['126'].split('_')[1];
                                                                                          print(TranID + "&" + depositmain['Status']);
                                                                                          // tranDet=depositmain['126'];
                                                                                          // for(var i=0;i<tranDet!.length;i++){
                                                                                          //   print(tranDet!.length);
                                                                                          //   print("tranDet list is$tranDet![i]");
                                                                                          // }
                                                                                          // var TranID=tranDet![0];
                                                                                          await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                                                                                            'STATUS': 'SUCCESS',
                                                                                            'TRANSACTION_ID': TranID
                                                                                          });
                                                                                          final addCash =  CashTable()
                                                                                            ..Cash_ID = myController.text
                                                                                            ..Cash_Date = DateTimeDetails().currentDate()
                                                                                            ..Cash_Time = DateTimeDetails().onlyTime()
                                                                                            ..Cash_Type = 'Add'
                                                                                            ..Cash_Amount = double.parse(rdFinal![9])
                                                                                            ..Cash_Description = "RD deposit";
                                                                                          await addCash.save();
                                                                                          final addTransaction = TransactionTable()
                                                                                            ..tranid = 'CBS${DateTimeDetails().filetimeformat()}'
                                                                                            ..tranDescription = "RD deposit"
                                                                                            ..tranAmount = double.parse(rdFinal![9])
                                                                                            ..tranType = "CBS"
                                                                                            ..tranDate = DateTimeDetails().currentDate()
                                                                                            ..tranTime = DateTimeDetails().onlyTime()
                                                                                            ..valuation = "Add";

                                                                                          await addTransaction.save();
                                                                                          // final tranDetails =
                                                                                          //     TBCBS_TRAN_DETAILS()
                                                                                          //       ..TRANSACTION_ID =
                                                                                          //           TranID
                                                                                          //       // ..TRANSACTION_ID=tranDet![0]
                                                                                          //       ..TRANSACTION_AMT =
                                                                                          //           amountTextController
                                                                                          //               .text
                                                                                          //       ..TRAN_DATE =
                                                                                          //           trandate
                                                                                          //       ..TRAN_TIME =
                                                                                          //           currentTime
                                                                                          //       ..CUST_ACC_NUM =
                                                                                          //           myController
                                                                                          //               .text
                                                                                          //       ..ACCOUNT_TYPE =
                                                                                          //           rec![4]
                                                                                          //       ..SCHEME_TYPE =
                                                                                          //           rec![5]
                                                                                          //       ..TRAN_TYPE =
                                                                                          //           "Deposit"
                                                                                          //       ..INSTALMENT_AMT =
                                                                                          //           rec![3]
                                                                                          //       ..NO_OF_INSTALMENTS =
                                                                                          //           rec![10]
                                                                                          //       ..REBATE_AMT =
                                                                                          //           rec![7]
                                                                                          //       ..DEFAULT_FEE =
                                                                                          //           rec![8]
                                                                                          //       ..MODE_OF_TRAN =
                                                                                          //           "By Cash"
                                                                                          //       ..OPERATOR_ID =
                                                                                          //           "232323"
                                                                                          //       ..STATUS =
                                                                                          //           depositmain[
                                                                                          //               'Status']
                                                                                          //       ..REMARKS =
                                                                                          //           "Deposit";
                                                                                          // tranDetails.save();
                                                                                          cbsDetails = await TBCBS_TRAN_DETAILS().select().TRANSACTION_ID.equals(TranID).toList();
                                                                                          print("cbsDetails");
                                                                                          print(cbsDetails);
                                                                                          print("status");
                                                                                          print(cbsDetails[0].STATUS);
                                                                                          for (int i = 0; i < cbsDetails.length; i++) {
                                                                                            print(cbsDetails[i].toMap());
                                                                                          }
                                                                                          // setState(() {
                                                                                          //   _isNewLoading = false;
                                                                                          // });
                                                                                          Navigator.push(context, MaterialPageRoute(builder: (_) => CashRDDepositAmount(cbsDetails[0].TRANSACTION_ID, amountTextController.text, currentDate, currentTime, cbsDetails[0].CUST_ACC_NUM, cbsDetails[0].ACCOUNT_TYPE, cbsDetails[0].REMARKS, balance, cbsDetails[0].INSTALMENT_AMT, cbsDetails[0].NO_OF_INSTALMENTS, cbsDetails[0].REBATE_AMT, cbsDetails[0].DEFAULT_FEE, cbsDetails[0].MODE_OF_TRAN, schtype, lastTRNdate)));
                                                                                        }
                                                                                      }
                                                                                    } else {
                                                                                      UtilFsNav.showToast("Signature Verification Failed! Try Again", context, CashDeposit());
                                                                                      await LogCat().writeContent('Cash Deposit Screen: Signature Verification Failed.');
                                                                                    }
                                                                                  } else {
                                                                                    print(response.statusCode);
                                                                                    List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                                                                    if (response.statusCode == 503 || response.statusCode == 504) {
                                                                                      UtilFsNav.showToast("CBS " + error[0].Description.toString(), context, CashDeposit());
                                                                                    }
                                                                                    else if(response.statusCode==401){
                                                                                      showDialog(
                                                                                        barrierDismissible: false,
                                                                                        context: context,
                                                                                        builder:
                                                                                            (BuildContext dialogContext) {
                                                                                          return WillPopScope(
                                                                                            onWillPop: () async => false,
                                                                                            child: MyAlertDialog(
                                                                                              title: '',
                                                                                              content: 'Dialog content',
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    }

                                                                                    else
                                                                                      UtilFsNav.showToast(error[0].Description.toString(), context, CashDeposit());
                                                                                  }
                                                                                } catch (_) {
                                                                                  if (_.toString() == "TIMEOUT") {
                                                                                    return UtilFsNav.showToast("Request Timed Out", context, CashDeposit());
                                                                                  }
                                                                                }
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              style: ButtonStyle(
                                                                                  // elevation:MaterialStateProperty.all(),
                                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)))),
                                                                              child: Text(
                                                                                "CANCEL",
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              onPressed: () {
                                                                                //Put your code here which you want to execute on Cancel button click.
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        _isNewLoading ==
                                                                                true
                                                                            ? Loader(
                                                                                isCustom: true,
                                                                                loadingTxt: 'Please Wait...Loading...')
                                                                            : Container()
                                                                      ],
                                                                    );
                                                                  });
                                                                });
                                                          }),
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                        ],
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
                      );
                    }
                  }),
            )));
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
            _isRDVisible = false;
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

  Widget? _getAmtClearButton() {
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
          amountTextController.clear()
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
          maxLength: 12,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIcon: Padding(
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
            hintText: ' Enter A/C Number',
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

  // Future<File> fetchaccdetails() async {
  //   var login=await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached writeContent");
  //   final file =
  //       await File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   String text =
  //       '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}';
  //   print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }
  Future<String> encryptfetchaccdetails() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    if (login.length == 0) {
      UtilFs.showToast("Incomplete data available. Please try again", context);
      return "false";
    } else {
      print("Reached writeContent");
      final file = await File('$cachepath/fetchAccountDetails.txt');
      file.writeAsStringSync('');
      String? goResponse = await Newenc.tester(
          "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
      String bound =
          goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
      String? text;

      text = "$bound"
          "\nContent-Id: <jsonInStream>\n\n"
          '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
      print(" fetch account details text");
      print(text);

     LogCat().writeContent(" Cash Deposit ${text.split("\n\n")[1]}");
      await file.writeAsString(text.trim(), mode: FileMode.append);
      // String test = await Newenc.signString(text.trim().toString());
      String test = await Newenc.signString(text.trim().toString());
      print("Signture is: " + test);
      return test;
    }
  }

  // Future<String> encryptfetchaccdetails(String response) async {
  //
  //   String test = await Newenc.signString(response.toString());
  //   print("Signture is: " + test);
  //   return test;
  // }

  // Future<File> fetchRDaccdetails() async {
  //   print("Reached writeContent");
  //   var login=await TBCBS_SOL_DETAILS().select().toList();
  //   final file = await File(
  //       '$cachepath/fetchRDAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   // String text='{"2":"${myController.text}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        60001700${myController.text}","123":"SDP"}';
  //   String text =
  //       '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${amountTextController.text}|"}';
  //   print(" fetch RDaccount details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchRDaccdetails() async {
    print("Reached writeContent");
    var login = await TBCBS_SOL_DETAILS().select().toList();
    if (login.length == 0) {
      UtilFs.showToast("Incomplete data available. Please try again", context);
      return "false";
    } else {
      final file = await File('$cachepath/fetchAccountDetails.txt');
      file.writeAsStringSync('');
      String? goResponse = await Newenc.tester(
          "$cachepath/fetchAccountDetails.txt",
          "requestJson",
          "jsonInStream");
      String bound =
          goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
      // String text='{"2":"${myController.text}","3":"820000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        60001700${myController.text}","123":"SDP"}';
      String text = "$bound"
          "\nContent-Id: <jsonInStream>\n\n"
          '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${amountTextController.text}|"}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";

      // String text =
      //     '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${amountTextController.text}|"}';
     LogCat().writeContent(" Cash Deposit RD ${text.split("\n\n")[1]}");
      print(" fetch RDaccount details text");
      print(text);
      await file.writeAsString(text.trim(), mode: FileMode.append);
      String test = await Newenc.signString(text.trim().toString());
      print("Signture is: " + test);
      return test;
    }
  }

  Future<String> encryptfetchdepositdetails(String uid) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached Deposit writeContent");
    // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
    String tot = amountTextController.text.padLeft(14, '0');
    print(tot);
    String padt = tot.padRight(16, '0');
    print(padt);
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');

    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    // String text =
    //     '{"2":"${myController.text}","3":"490000","4":"$padt","11":"$uid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}';

    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"490000","4":"$padt","11":"$uid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
   LogCat().writeContent(" Cash Deposit  ${text.split("\n\n")[1]}");
    print("deposit amount text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchRDdepositdetails(String tid) async {
  //   var login = await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached RD Deposit writeContent");
  //   // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
  //   String tot = amountTextController.text.padLeft(14, '0');
  //   // String tot = rdFinal![9].padLeft(14, '0');
  //   // ${rdFinal![9]}
  //
  //   print(tot);
  //   String padt = tot.padRight(16, '0');
  //   print(padt);
  //   String defpadding = rdFinal![8].padLeft(14, '0');
  //   String maindefpadding = defpadding.padRight(23, '0');
  //   String rebpadding = rdFinal![8].padLeft(14, '0');
  //   String mainrebpadding = rebpadding.padRight(23, '0');
  //   print("Main Def Padding: $maindefpadding");
  //   final file =
  //       await File('$cachepath/RDfetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   // String text='{"2":"${myController.text}","3":"490000","4":"$padt","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        50007504${myController.text}","123":"SDP","126":"BO11202102003_50343458_BY CASH  "}';
  //   String text =
  //       '{"2":"${myController.text}","3":"490000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","46":"90INRC${mainrebpadding}1C0000000000000000INR91INRD${maindefpadding}1D0000000000000000INR","49":"INR","103":"  111        ${login[0].SOL_ID}${myController.text}","123":"SDP","125":"$LateInstallmentsBeingPaidCount","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}';
  //   print("deposit amount text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }
  Future<String> encryptfetchRDdepositdetails(String tid) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    if (login.length == 0) {
      UtilFs.showToast("Incomplete data available. Please try again", context);
      return "false";
    } else {
      print("Reached RD Deposit writeContent");
      // print(amountTextController.text.padLeft(14,'0').padRight(4,'0'));
      String tot = amountTextController.text.padLeft(14, '0');
      // String tot = rdFinal![9].padLeft(14, '0');
      // ${rdFinal![9]}

      print(tot);
      String padt = tot.padRight(16, '0');
      print(padt);
      String defpadding = rdFinal![8].padLeft(14, '0');
      String maindefpadding = defpadding.padRight(23, '0');
      // String rebpadding = rdFinal![8].padLeft(14, '0');
      String rebpadding = rdFinal![7].padLeft(14, '0');
      String mainrebpadding = rebpadding.padRight(23, '0');
      print("Main Def Padding: $maindefpadding");
      final file = await File('$cachepath/fetchAccountDetails.txt');
      file.writeAsStringSync('');
      // String text='{"2":"${myController.text}","3":"490000","4":"$padt","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","103":"  111        50007504${myController.text}","123":"SDP","126":"BO11202102003_50343458_BY CASH  "}';
      String? goResponse = await Newenc.tester(
          "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
      String bound =
          goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

      String text = "$bound"
          "\nContent-Id: <jsonInStream>\n\n"
          '{"2":"${myController.text}","3":"490000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","46":"90INRC${mainrebpadding}1C0000000000000000INR91INRD${maindefpadding}1D0000000000000000INR","49":"INR","103":"  111        ${login[0].SOL_ID}${myController.text}","123":"SDP","125":"$LateInstallmentsBeingPaidCount","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
     LogCat().writeContent(" Cash Deposit RD ${text.split("\n\n")[1]}");
      print("deposit amount text");
      print(text);
      await file.writeAsString(text.trim(), mode: FileMode.append);
      // String test = await Newenc.signString(text.trim().toString());
      String test = await Newenc.signString(text.trim().toString());
      print("Signture is: " + test);
      return test;
    }
  }

  Future<String> statusMessage(inputValue) async {
    String invalidMessage = "false";
    switch (inputValue) {
      case "INVALID_ACC_NO":
        invalidMessage = "Entered account number does not exist";
        break;
      case "ACC_CLOSED":
        invalidMessage = "Entered account number is Closed";
        break;
      case "ACC_SILENT":
        invalidMessage = "Entered Account Number is Silent";
        break;
      case "ACC_FROZEN":
        invalidMessage = "Entered Account Number is Frozen";
        break;
      case "ACC_NOT_WIT_BO":
        invalidMessage =
            "Entered account number is not linked to this BO.Please contact Home Branch";
        break;
      case "RD_SB_SSA":
        invalidMessage = "Please enter only SB or RD or SSA account numbers";
        break;
      case "ACC_CRE_FROZEN":
        invalidMessage = "Transaction not allowed for this scheme from device";
        break;
      case "DIFF_DATE":
        invalidMessage =
            "FSI-CBS SOL BOD Date is different from device date.Transaction not allowed";
        break;
    }
    return invalidMessage;
  }
}
