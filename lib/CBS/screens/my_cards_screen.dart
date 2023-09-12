import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/Utils/CustomDrawer.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/NewAccountOpening/accopenMain.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';

import 'package:flutter/material.dart';

import 'package:darpan_mine/CBS/screens/ministatement.dart';
import 'package:darpan_mine/CBS/screens/cashdeposit.dart';
import 'package:darpan_mine/CBS/screens/cashwithdrawal.dart';
import 'package:darpan_mine/CBS/screens/datreport.dart';
import 'package:darpan_mine/CBS/screens/accountenquiry.dart';
import 'package:darpan_mine/CBS/screens/transactionstatus.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../AlertDialogChecker.dart';
import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../IPPB daily report.dart';
import '../accdetails.dart';
import '../decryptHeader.dart';
import 'Highvaluwdlfirstpage.dart';

class cbsL {
  String name;
  String val;

  cbsL(this.name, this.val);
}

class MyCardsScreen extends StatefulWidget {
  bool? fetchconfig;

  MyCardsScreen(this.fetchconfig);

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  Future? getData;
  late Directory d;
  late String cachepath;
  List? bdetails = [];
  bool _isLoading = false;
  String? encheader;

  @override
  void initState() {
    if (widget.fetchconfig == true) {
      getData = getConfigDetails();
    } else {
      getData = getdetailsfromDB();
    }
    super.initState();
  }

  getdetailsfromDB() async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    return true;
  }

  Future<String> fetchConfigDetail() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
    print("Reached writeContent");
    // final file =
    //     await File('$cachepath/fetchAccountDetails.txt');

    final file = await File("$cachepath/fetchAccountDetails.txt");
    print(file.path.toString());
    // if(file.existsSync()){}
    // else {
    //  await file.create();
    // }
    file.writeAsStringSync('');
    // String? goResponse=await Newenc.tester("$cachepath/fetchAccountDetails.txt","requestConfigData","jsonInStream");
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestConfigData", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","responseParams":"configData"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print(file.path.toString());
    String data = await file.readAsString();
    print("Data: $data");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    String val = await decryption1(test, text.trim().toString());
    print("val in Decrytion of configfetch: $val");
    return test;
  }

  getConfigDetails() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
    List<USERLOGINDETAILS> acctoken =
    await USERLOGINDETAILS()
        .select()
        .Active
        .equals(true)
        .toList();
    try {
      encheader = await fetchConfigDetail();
      print(acctoken[0].AccessToken);
    } catch (e) {
      print("Error in config file encryption: $e");
    }
    // var request = http.Request('POST',
    //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestConfigData'));
    // request.files.add(await http.MultipartFile.fromPath(
    //     '', '$cachepath/fetchAccountDetails.txt'));
    print(acctoken[0].Validity!);
    int validtimer = DateTime.parse(
        acctoken[0].Validity!)
        .difference(DateTime.now())
        .inSeconds;
    if (validtimer > 10){
      try {
        var headers = {
          'Signature': '$encheader',
          'Uri': 'requestConfigData',
          // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
          'Authorization': 'Bearer ${acctoken[0].AccessToken}',
          'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
        };
        print("Try request configdata");
        print(encheader.toString());

        final File file = File('$cachepath/fetchAccountDetails.txt');
        String tosendText = await file.readAsString();
        var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
        request.body = tosendText;
        // request.files.add(await http.MultipartFile.fromPath(
        //     'file', '$cachepath/fetchAccountDetails.txt'));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request
            .send()
            .timeout(const Duration(seconds: 65), onTimeout: () {
          // return UtilFs.showToast('The request Timeout',context);
          setState(() {
            _isLoading = false;
          });
          throw 'TIMEOUT';
        });
        // print("Reqeyust sent");
        // print(request.files.toString());
        // print(request.headers);
        // print(request.url);
        //
        // print(request.fields.toString());
        print(response.statusCode);
        String res = await response.stream.bytesToString();
        print("Response in configData: $res");
        if (response.statusCode == 200) {
          var resheaders = await response.headers;
          print("Result Headers");
          print(resheaders);
          // List t =
          //     resheaders['authorization']!
          //         .split(", Signature:");
          String temp = resheaders['authorization']!;
          String decryptSignature = temp;


          String val = await decryption1(decryptSignature, res);
          if (val == "Verified!") {
            // await LogCat().writeContent(
            //     '${DateTimeDetails().currentDateTime()} : $res\n\n');
            Map a = json.decode(res);
            print(a['JSONResponse']['jsonContent']);
            String data = a['JSONResponse']['jsonContent'];
            var main = json.decode(data);
            // List<cbsL> temp=[];
            print(main.length);
            // main.entries.forEach((entry){
            //   print('${entry.key},${entry.value}');
            //   temp(entry.key,entry.value).toList();
            // });

            List<cbsL> temp = main.entries
                .map<cbsL>((entry) => cbsL(entry.key, entry.value))
                .toList();
            print(temp.length);
            await CBS_LIMITS_CONFIG().select().delete();
            for (int i = 1; i < temp.length; i++) {
              await CBS_LIMITS_CONFIG(
                  type: temp[i].name, tranlimits: temp[i].val)
                  .upsert();
            }
            encheader = await fetchsoldetails();
            // var request = http.Request('POST',
            //     Uri.parse('https://gateway.cept.gov.in:443/cbs/requestSOLDetails'));
            // request.files.add(await http.MultipartFile.fromPath(
            //     '', '$cachepath/fetchAccountDetails.txt'));
            try {
              var headers = {
                'Signature': '$encheader',
                'Uri': 'requestSOLDetails',
                // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                'Authorization': 'Bearer ${acctoken[0].AccessToken}',
                'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
                'Content-Type': 'multipart/form-data'
              };

              final File file = File('$cachepath/fetchAccountDetails.txt');
              String tosendText = await file.readAsString();
              var request = http.Request(
                  'POST', Uri.parse(APIEndPoints().cbsURL));
              request.body = tosendText;
              request.headers.addAll(headers);

              http.StreamedResponse bocodeResponse = await request
                  .send()
                  .timeout(const Duration(seconds: 65), onTimeout: () {
                // return UtilFs.showToast('The request Timeout',context);
                setState(() {
                  _isLoading = false;
                });
                throw 'TIMEOUT';
              });
              if (bocodeResponse.statusCode == 200) {
                var resheaders = await bocodeResponse.headers;
                print("Result Headers");
                print(resheaders);
                // List t =
                //     resheaders['authorization']!
                //         .split(", Signature:");
                String temp = resheaders['authorization']!;
                String decryptSignature = temp;
                String res = await bocodeResponse.stream.bytesToString();
                print(res);

                String val = await decryption1(decryptSignature, res);
                if (val == "Verified!") {
                  // await LogCat().writeContent(
                  //     '${DateTimeDetails().currentDateTime()} : $res\n\n');
                  Map a = json.decode(res);
                  print("Map a: $a");
                  String boData = a['JSONResponse']['jsonContent'];
                  Map tempmain = await json.decode(boData);
                  print(tempmain);
                  bdetails = await fac.splitBODetails(tempmain['M_ADD_PARAMS']);
                  print(bdetails);
                  print("SOL ID: ${bdetails![4].substring(0, 8)}");
                  var login = await USERDETAILS().select().toList();

                  try {
                    await TBCBS_SOL_DETAILS().select().delete();
                    await TBCBS_SOL_DETAILS(
                      BO_ID: bdetails![0],
                      SOL_ID: bdetails![4].substring(0, 8),
                      SOL_DESC: bdetails![4],
                      OPERATOR_ID: login[0].EMPID,
                      // OPERATOR_ID: '10164416',
                    ).upsert();
                  } catch (e) {
                    print("Error in SOL Details insertion: $e");
                  }
                } else {
                  UtilFs.showToast(
                      "Signature Verification Failed! Try Again", context);
                  await LogCat().writeContent(
                      'Fetching SOL Details: Signature Verification Failed.');
                }
              } else {
                print(bocodeResponse.reasonPhrase);
                print(bocodeResponse.statusCode);
                print(await bocodeResponse.stream.bytesToString());
                List<API_Error_code> error = await API_Error_code()
                    .select()
                    .API_Err_code
                    .equals(bocodeResponse.statusCode)
                    .toList();
                if (bocodeResponse.statusCode == 503 ||
                    bocodeResponse.statusCode == 504) {
                  UtilFs.showToast(
                      "CBS " + error[0].Description.toString(), context);
                }
                else if (response.statusCode == 401) {
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
                  UtilFs.showToast(error[0].Description.toString(), context);
              }
            } catch (_) {
              if (_.toString() == "TIMEOUT") {
                return UtilFs.showToast("Request Timed Out", context);
              }
            }
          } else {
            UtilFs.showToast(
                "Signature Verification Failed! Try Again", context);
            await LogCat().writeContent(
                'Fetching Config Details:  Signature Verification Failed.');
          }
        } else {
          print(" Printing statuss.....");
          print(response.statusCode);
          List<API_Error_code> error = await API_Error_code()
              .select()
              .API_Err_code
              .equals(response.statusCode)
              .toList();
          if (response.statusCode == 503 || response.statusCode == 504) {
            UtilFs.showToast("CBS " + error[0].Description.toString(), context);
          }
          else
            UtilFs.showToast(error[0].Description.toString(), context);
        }
        return true;
      } catch (_) {
        if (_.toString() == "TIMEOUT") {
          return UtilFs.showToast("Request Timed Out", context);
        }
      }
  }
    else{
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
  }

  Future<String> fetchsoldetails() async {
    print("Reached SOL Details");
    var login = await USERDETAILS().select().toList();
    print(login.length);
    print(login[0].BOFacilityID);
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSOLDetails", "postBOID");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String text = "$bound"
        "\nContent-Id: <postBOID>\n\n"
         '{"BO_ID":"${login[0].BOFacilityID}"}\n\n'
         //'{"HO_ID":"HO29101100000"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    // String text="\nContent-Id: <postBOID>\n\n"'{"BO_ID":"${login[0].BOFacilityID}"}\n\n';
    print("selfopenacct \n $text");
    print("ENDED");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Core Banking Solution', textAlign: TextAlign.center,style: TextStyle(fontSize: 22,),),backgroundColor: Color(0xFFB71C1C),
      //     appBar: AppBar(title: const Text('Darpan-CBS', textAlign: TextAlign.center,style: TextStyle(fontSize: 22,),),backgroundColor: Color(0xFFB71C1C),
      //
      // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
      //         bottom: Radius.circular(20) )),
      //   ),
      appBar: AppAppBar(title: 'Darpan-CBS'),
      drawer: CustomDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          bool? result = await _onBackPressed();
          result ??= false;
          return result;
        },
        child: FutureBuilder(
            future: getData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Getting Configuration Details... "),
                    Text("Please Wait..."),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(),
                  ],
                ));
              } else {
                return SafeArea(
                  child: ListView(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height - 170
                            : MediaQuery.of(context).size.height - 125,
                        decoration: const BoxDecoration(
                          //color:
                          //Colors.white,
                          //Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height > 900
                                  ? 14
                                  : 14),
                          child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(75),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: GridView.count(
                                  childAspectRatio: 1.29,
                                  crossAxisCount:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.portrait
                                          ? 2
                                          : 3,
                                  children: <Widget>[
                                    MyMenu(
                                      title: "Open New Account",
                                      img: "assets/images/ic_accountopen.png",
                                      pos: 1,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Cash Deposit",
                                      img: "assets/images/ic_cashdeposit.png",
                                      pos: 2,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Cash Withdrawal",
                                      img:
                                          "assets/images/ic_cashwithdrawal.png",
                                      pos: 3,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Mini Statement",
                                      img: "assets/images/ic_ministatement.png",
                                      pos: 4,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Daily Transaction Report",
                                      img: "assets/images/ic_dat.png",
                                      pos: 5,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "High Value Withdrawal",
                                      img:
                                          "assets/images/ic_cashwithdrawal.png",
                                      pos: 6,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Account Enquiry",
                                      img:
                                          "assets/images/ic_accountenquiry.png",
                                      pos: 7,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Transactions Status",
                                      img:
                                          "assets/images/ic_transactionenquiry.png",
                                      pos: 8,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    // MyMenu(
                                    //   title: "IPPB",
                                    //   img: "assets/images/ic_dat.png",
                                    //   pos: 9,
                                    //   bgcolor: Colors.grey[300]!,
                                    // ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
        (route) => false);
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({this.title, this.img, this.pos, this.bgcolor});

  final String? title;
  final Color? bgcolor;

  final int? pos;
  final String? img;
  static const _kFontFam = 'MyHomePage';
  static const _kFontPkg = null;
  static const IconData ic_article_tracking =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          //color:
          // Colors.white,
          //Colors.grey[300],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Container(
            child: Ink(
              //color:Colors.red,[
              child: InkWell(
                //splashColor: Colors.red,
                onTap: () async {
                  var currentDate = DateTimeDetails().currentDate();
                  var previousDate = DateTimeDetails().previousDate();
                  final dayDetails = await DayModel()
                      .select()
                      .DayBeginDate
                      .equals(currentDate)
                      .toList();
                  final dayAlreadyDone = await DayModel()
                      .select()
                      .startBlock
                      .DayBeginDate
                      .equals(currentDate)
                      .and
                      .DayCloseDate
                      .equals(currentDate)
                      .endBlock
                      .toMapList();
                  if (pos.toString() == '5') {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatReport()),
                  );
                  }
                  else if (pos.toString() == '7') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AcountEnquiry()),
                    );
                  }
                 else if (dayDetails.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Note'),
                            content: const Text('Do Day begin to continue'),
                            actions: [
                              Button(
                                  buttonText: 'OKAY',
                                  buttonFunction: () => Navigator.pop(context))
                            ],
                          );
                        });
                  }
                  else if (dayAlreadyDone.isNotEmpty) {
                    // if (pos.toString() == '7') {
                    //   Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsScreen()));
                    // }
                    // else {
                    showDialog(
                        context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Note'),
                        content: const Text('Day end has happened'),
                        actions: [
                          Button(buttonText: 'OKAY',
                              buttonFunction: () => Navigator.pop(context))
                        ],
                      );
                    });
                    // }
                  }
                  else {
                    if (dayDetails[0].DayBeginDate!.isEmpty) {
                      final previousDayDetails = await DayModel()
                          .select()
                          .DayCloseDate
                          .equals(previousDate)
                          .toList();
                      if (previousDayDetails.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Note'),
                                content: Text(
                                    'Please do the day end of date $previousDate to continue'),
                                actions: [
                                  Button(
                                      buttonText: 'OKAY',
                                      buttonFunction: () =>
                                          Navigator.pop(context))
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Note'),
                                content: Text(
                                    'Please do the day begin of date $previousDate to continue'),
                                actions: [
                                  Button(
                                      buttonText: 'OKAY',
                                      buttonFunction: () =>
                                          Navigator.pop(context))
                                ],
                              );
                            });
                      }
                    }
                    else {
                      if (pos.toString() == '1') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountOpenMain()),
                        );
                      }
                      else if (pos.toString() == '2') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CashDeposit()),
                        );
                      }
                      else if (pos.toString() == '3') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CashWithdrawal()),
                        );
                      }
                    else if (pos.toString() == '4') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MiniStatement()),
                        );
                      }

                      else if (pos.toString() == '6') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HighValueWd("")),
                        );
                      }
                     // else if (pos.toString() == '7') {
                     //    Navigator.push(
                     //      context,
                     //      MaterialPageRoute(
                     //          builder: (context) => AcountEnquiry()),
                     //    );
                     //  }
                     else if (pos.toString() == '8') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionStatus()),
                        );
                      }
                    }
                  }

                  // if (pos.toString() == '1') {
                  //   // Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(
                  //   //       builder: (context) => AccountOpen()),
                  //   // );
                  //
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => AccountOpenMain()),
                  //   );
                  // } else if (pos.toString() == '2') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => CashDeposit()),
                  //   );
                  // } else if (pos.toString() == '3') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => CashWithdrawal()),
                  //   );
                  // } else if (pos.toString() == '4') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => MiniStatement()),
                  //   );
                  // } else if (pos.toString() == '5') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => DatReport()),
                  //   );
                  // } else if (pos.toString() == '6') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => HighValueWd("")),
                  //   );
                  // } else if (pos.toString() == '7') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => AcountEnquiry()),
                  //   );
                  // } else if (pos.toString() == '8') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TransactionStatus()),
                  //   );
                  // } else if (pos.toString() == '9') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => IPPB()),
                  //   );
                  // }
                },

                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(img!, width: 70, color: Color(0xFFB71C1C)),
                    Text(title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF984600),
                            //  color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                //),
              ),
            ),
          ),
        ),
      ),
    );
    //)
    //);
  }
}
