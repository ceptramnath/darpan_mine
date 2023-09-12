import 'dart:convert';
import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Utils/Printing.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../decryptHeader.dart';
import '../accdetails.dart';
import 'my_cards_screen.dart';

class MiniStatement extends StatefulWidget {
  @override
  _MiniStatementState createState() => _MiniStatementState();
}

class _MiniStatementState extends State<MiniStatement> {
  late Directory d;
  late String cachepath;
  final amountTextController = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  bool _showClearButton = true;
  bool _isVisible = false;
  bool statement = false;
  Map main = {};
  Map ministmain = {};
  String? achname;
  String? bal, mainbal, balafterdeposit;
  final RegExp regexp = new RegExp(r'^0+(?=.)');
  String? processingDate,
      processingTime,
      processingDatetemp,
      processingTimetemp;
  String? transDate;
  List? rec = [];
  List? balances = [];
  List? miniresponse = [];
  String? encheader;
  bool _isLoading = false;

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
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
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
        appBar: AppBar(
          title: Text(
            'Mini Statement',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFFB71C1C),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  _searchBar(),
                  _isVisible == false
                      ? TextButton(
                          child: Text("Proceed"),
                          style: TextButton.styleFrom(
                              elevation: 5.0,
                              textStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Georgia"),
                              backgroundColor: Color(0xFFCC0000),
                              primary: Colors.white),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _isLoading = true;
                            });
                            encheader = await encryptfetchaccdetails();


      List<USERLOGINDETAILS> acctoken =
          await USERLOGINDETAILS().select().Active.equals(true).toList();
                            // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                            // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                            try {
                              var headers = {
                                'Signature': '$encheader',
                                'Uri': 'requestJson',
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
                                var resheaders = await response.headers;
                                print("Result Headers");
                                print(resheaders);
                                // List t = resheaders['authorization']!
                                //     .split(", Signature:");
                                String res =
                                    await response.stream.bytesToString();
                                String temp = resheaders['authorization']!;
                                String decryptSignature = temp;

                                String val =
                                    await decryption1(decryptSignature, res);
                                if (val == "Verified!") {
                                  await LogCat().writeContent(
                                                    '$res');
                                  Map a = json.decode(res);
                                  print(a['JSONResponse']['jsonContent']);
                                  String data = a['JSONResponse']['jsonContent'];
                                  main = json.decode(data);
                                  print("Values");
                                  print(main);
                                  if (main['125'] == "Invalid ACCOUNT") {
                                    UtilFsNav.showToast(
                                        "Entered account number doesnot exist",
                                        context,
                                        MiniStatement());
                                  } else {
                                    List? rec = await fac.split125(main['125']);
                                    List? balances =
                                        await fac.split48(main['48']);
                                    achname = rec![1];
                                    String? sch = rec[4];
                                    String reduced =
                                        balances![1]!.replaceAll(regexp, '');
                                    if(reduced=="0"){
                                      mainbal="0.00";
                                    }
                                    else {
                                      mainbal = StringUtils.addCharAtPosition(
                                          reduced, ".", reduced.length - 2);
                                    }
                                    if (sch!.contains("SB") ||
                                        sch.contains("SSA")) {
                                      setState(() {
                                        _isVisible = true;
                                      });
                                    } else {
                                      UtilFs.showToast(
                                          "Account is not a valid SB/SSA Account. Please check the Account number entered",
                                          context);
                                    }
                                  }
                                } else {
                                  UtilFsNav.showToast(
                                      "Signature Verification Failed! Try Again",
                                      context,
                                      MiniStatement());
                                  await LogCat().writeContent(
                                      'Mini Statement Account Fetch Details: Signature Verification Failed');
                                }
                              } else {
                                // UtilFsNav.showToast(
                                //     "${response.reasonPhrase!}\n${await response.stream.bytesToString()}",
                                //     context,
                                //     MiniStatement());
                                // UtilFs.showToast("${await response.stream.bytesToString()}", context);

                                //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                print(response.statusCode);
                                List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                if(response.statusCode==503 || response.statusCode==504){
                                  UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,MiniStatement());
                                }
                                else
                                  UtilFsNav.showToast(error[0].Description.toString(), context,MiniStatement());
                              }
                            } catch (_) {
                              if (_.toString() == "TIMEOUT") {
                                return UtilFsNav.showToast("Request Timed Out",
                                    context, MiniStatement());
                              }
                            }
                          },
                        )
                      : Container(),
                  SizedBox(
                    height: 16,
                  ),
                  _isVisible == true
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              Text('Account Details',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blueGrey)),
                              Table(border: TableBorder.all(), children: [
                                TableRow(
                                  children: [
                                    Column(children: [
                                      Text('Account No',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text(myController.text,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Column(children: [
                                      Text('Account Holder Name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('${achname.toString().trim()}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Column(children: [
                                      Text('Account Balance',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                    Column(children: [
                                      Text('$mainbal',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600]))
                                    ]),
                                  ],
                                ),
                              ]),
                              SizedBox(
                                height: 15,
                              ),
                              statement == false
                                  ? TextButton(
                                      child: Text("Fetch Mini Statement"),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Color(0xFFCC0000),
                                          primary: Colors.white),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        encheader = await encryptfetchstatement();
                                        // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/cbs/requestJson'));
                                        // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                                           List<USERLOGINDETAILS> acctoken =
          await USERLOGINDETAILS().select().Active.equals(true).toList();
                                        try {
                                          var headers = {
                                            'Signature': '$encheader',
                                            'Uri': 'requestJson',
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
                                            var resheaders =
                                                await response.headers;
                                            print("Result Headers");
                                            print(resheaders);
                                            // List t = resheaders['authorization']!
                                            //     .split(", Signature:");
                                            String res = await response.stream
                                                .bytesToString();
String temp = resheaders['authorization']!;
                                                String decryptSignature = temp;
                                            String val = await decryption1(
                                                decryptSignature, res);
                                            if (val == "Verified!") {
                                              await LogCat().writeContent(
                                                    '$res');
                                              Map a = json.decode(res);
                                              // print("Map a: $a");
                                              print(a['JSONResponse']
                                                  ['jsonContent']);
                                              String data = a['JSONResponse']
                                                  ['jsonContent'];
                                              ministmain = json.decode(data);
                                              print("Values");
                                              print(main);
                                              miniresponse =
                                                  await fac.splitministatement(
                                                      ministmain['125']);
                                              setState(() {
                                                statement = true;
                                              });
                                            } else {
                                              UtilFsNav.showToast(
                                                  "Signature Verification Failed! Try Again",
                                                  context,
                                                  MiniStatement());
                                              await LogCat().writeContent(
                                                  'Fetching MiniStatement screen: Signature Verification Failed.');
                                            }
                                          } else {
                                            // UtilFsNav.showToast(
                                            //     "${response.reasonPhrase!}\n ${await response.stream.bytesToString()}",
                                            //     context,
                                            //     MiniStatement());
                                            // UtilFsNav.showToast("${await response.stream.bytesToString()}", context,MiniStatement());

                                            //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                            print(response.statusCode);
                                            List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                            if(response.statusCode==503 || response.statusCode==504){
                                              UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,MiniStatement());
                                            }
                                            else
                                              UtilFsNav.showToast(error[0].Description.toString(), context,MiniStatement());

                                          }
                                        } catch (_) {
                                          if (_.toString() == "TIMEOUT") {
                                            return UtilFsNav.showToast(
                                                "Request Timed Out",
                                                context,
                                                MiniStatement());
                                          }
                                        }
                                      },
                                    )
                                  : Container(),
                              SizedBox(
                                height: 15,
                              ),
                              Visibility(
                                visible: statement,
                                child: Column(
                                  children: [
                                    Text('Account Statement',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blueGrey)),
                                    Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.35,
                                      child: SingleChildScrollView(
                                        child: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(1.5),
                                              1: FlexColumnWidth(3),
                                              2: FlexColumnWidth(5),
                                              3: FlexColumnWidth(1.5),
                                              4: FlexColumnWidth(3),
                                            },
                                            border: TableBorder.all(),
                                            children: [
                                              TableRow(
                                                children: [
                                                  Column(children: [
                                                    Text('Sl. No.',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]))
                                                  ]),
                                                  Column(children: [
                                                    Text('DATE',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]))
                                                  ]),
                                                  Column(children: [
                                                    Text('Tran. Particulars',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]))
                                                  ]),
                                                  Column(children: [
                                                    Text('Type',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]))
                                                  ]),
                                                  Column(children: [
                                                    Text('Amount',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]))
                                                  ]),
                                                ],
                                              ),
                                              for (int i = 0, count = 1;
                                                  i < (miniresponse!.length);
                                                  i = i + 6, count++)
                                                TableRow(
                                                  children: [
                                                    Column(children: [
                                                      Text('${count}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                          '${(miniresponse![i].toString().substring(0, 4) + "/" + miniresponse![i].toString().substring(4, 6) + "/" + miniresponse![i].toString().substring(6, 8)).split('/').reversed.join("/")}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                          '${miniresponse![i + 3]}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                          '${miniresponse![i + 4]}',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600]))
                                                    ]),
                                                    Column(children: [
                                                      Text(
                                                        '${miniresponse![i + 5].trim()}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey[600]),
                                                        textAlign: miniresponse![
                                                                    i + 4] ==
                                                                'C'
                                                            ? TextAlign.left
                                                            : TextAlign.right,
                                                      )
                                                    ]),
                                                  ],
                                                ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  statement == true
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  List<String> basicInformation = <String>[];
                                  List<String> Dummy = <String>[];
                                  //List<OfficeDetail> office=await OfficeDetail().select().toList();
                                  final ofcMaster =
                                      await OFCMASTERDATA().select().toList();
                                  basicInformation.add('CSI BO Descriprtion');
                                  basicInformation
                                      .add(ofcMaster[0].BOName.toString());
                                  basicInformation.add('Receipt Date & Time');
                                  basicInformation
                                      .add(DateTimeDetails().onlyExpDateTime());
                                  basicInformation.add('SOL Description');
                                  basicInformation
                                      .add(ofcMaster[0].AOName.toString());
                                  basicInformation.add('Account Number');
                                  basicInformation
                                      .add(myController.text.toString());
                                  basicInformation.add('Customer Name');
                                  basicInformation
                                      .add(achname.toString().trimRight());
                                  basicInformation.add('Account Balance');
                                  basicInformation.add('$mainbal'.toString());
                                  basicInformation.add("----------------");
                                  basicInformation.add("----------------");
                                  basicInformation.add("Date         ");
                                  basicInformation.add("Type   Amount");
                                  basicInformation.add("----------------");
                                  basicInformation.add("----------------");
                                  for (int i = 0, count = 1;
                                      i < (miniresponse!.length);
                                      i = i + 6, count++) {
                                    print(
                                        "${(miniresponse![i].toString().substring(0, 4) + "/" + miniresponse![i].toString().substring(4, 6) + "/" + miniresponse![i].toString().substring(6, 8)).split('/').reversed.join("/")}   ${miniresponse![i + 4]}    ${miniresponse![i + 5].trim()}");
                                    basicInformation.add(
                                        "${(miniresponse![i].toString().substring(0, 4) + "/" + miniresponse![i].toString().substring(4, 6) + "/" + miniresponse![i].toString().substring(6, 8)).split('/').reversed.join("/")}         ${miniresponse![i + 4]}");
                                    basicInformation
                                        .add("${miniresponse![i + 5].trim()}");
                                  }
                                  Dummy.clear();
                                  PrintingTelPO printer = new PrintingTelPO();
                                  bool value =
                                      await printer.printThroughUsbPrinter(
                                          "CBS",
                                          "Mini Statement",
                                          basicInformation,
                                          basicInformation,
                                          1);
                                },
                                child:
                                    Text('PRINT', style: TextStyle(fontSize: 16)),
                                color: Color(0xFFB71C1C),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              RaisedButton(
                                child:
                                    Text('BACK', style: TextStyle(fontSize: 16)),
                                color: Color(0xFFB71C1C),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainHomeScreen(
                                              MyCardsScreen(false), 1)),
                                      (route) => false);
                                },
                              ),
                            ],
                          ),
                        )
                      : Container()
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
          myController.clear(),
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MiniStatement()),
          ),
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
                offset: Offset(4, 4),
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
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.account_balance_outlined,
                size: 22,
              ),
            ),
            hintStyle: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 2, 40, 86),
              fontWeight: FontWeight.w500,
            ),
            hintText: 'Enter A/C Number',
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

  // Future<String> get _localPath async {
  //   Directory directory = Directory('$cachepath');
  //   // print("Path is -"+directory.path.toString());
  //   return directory.path;
  // }
  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/fetchAccountDetails.txt');
  // }
  Future<String> encryptfetchaccdetails() async {
    print("Reached writeContent");
    var login = await TBCBS_SOL_DETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("fetchacctdetails$text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Ministatement Acc Enquiry ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> get _statementFile async {
  //   final path = await _localPath;
  //   return File('$path/fetchAccountDetails.txt');
  // }
  // Future<File> fetchstatement() async{
  //   print("Reached writeContent");
  //   var login=await TBCBS_SOL_DETAILS().select().toList();
  //   final file=await File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   String text='{"2":"${myController.text}","3":"380000","4":"0000000000000000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}';
  //   print("fetchstatement$text");
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchstatement() async {
    print("Reached writeContent");
    var login = await TBCBS_SOL_DETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        '{"2":"${myController.text}","3":"380000","4":"0000000000000000","11":${GenerateRandomString().randomString()},"12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("fetchstatement$text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Fetch Mini Statement ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
