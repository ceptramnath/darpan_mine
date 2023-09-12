import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/Utils/CustomDrawer.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';

import 'package:darpan_mine/INSURANCE/HomeScreen/PremiumCollection/PremiumCollection.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';


import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';

import '../../LogCat.dart';
import '../../CBS/decryptHeader.dart';
import 'DisbursementStatus/DisbursementStatus.dart';
import 'Indexing/ServiceRequestIndexing.dart';
import 'NewBusinessQuotes/NewBusinessQuotes.dart';
import 'NewProposal/NewProposalScreen.dart';
import 'PolicySearch/PolicySearchScreen.dart';
import 'Reports/ReportsScreen.dart';

import 'ServicesQuotes/ServicesQuoteGenerationScreen.dart';
import 'StatusRequest/StatusRequestScreen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

import 'TransactionUpdate/TransactionUpdate.dart';

class UserPage extends StatefulWidget {
  bool fetch;

  UserPage(this.fetch);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? encheader;
  late Directory d;
  late String cachepath;

  Map main = {};
  Future? getData;

  @override
  void initState() {
    getCacheDir();
    if (widget.fetch == true) {
      getData = getOfficeDetails();
    } else {
      getData = getdetailsfromDB();
    }
    super.initState();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  getdetailsfromDB() async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    return true;
  }

  getOfficeDetails() async {
    var officedata = await OfficeDetail().select().toList();


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    print("OFikdslfhkahsdf: ${officedata.length}");
    encheader = await encryption();
    print("received enchheader: $encheader");
    // if (officedata.length == 0){
    try {
      var headers = {
        'Signature': '$encheader',
        // 'Signature': '1679979250;>;KeFXafO90C79oQIN8xo2TGYDgeYPb3R1kB7yrt6gz41GELWToCcBKy2lUIQkkxNbskzDwExpUOnOV370GQakCA==;>;1679979850',
        'Uri': 'getPOCode',
        'Authorization': 'Bearer ${acctoken[0].AccessToken}',
        'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
        'Content-Type': 'multipart/form-data'
      };
      final File file = File('$cachepath/fetchAccountDetails.txt');
      String tosendText = await file.readAsString();
      var request = http.Request('POST', Uri.parse(APIEndPoints().insURL));
      request.body = tosendText;
      // var request =
      //     http.Request('POST', Uri.parse(APIEndPoints().insURL));
      // // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in/fsitesting/api/v1/pli/getPOCode'));
      // request.files.add(await http.MultipartFile.fromPath(
      //     'file', '$cachepath/fetchAccountDetails.txt'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: 65), onTimeout: () {
        throw 'TIMEOUT';
      });
      print(response.headers);
      var resheaders = response.headers;
      print(response.statusCode);
      // String res = await response.stream
      //     .bytesToString();
      // print(res);
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        print("Result Headers");
        print(resheaders);
        //  // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;
        // List temp = resheaders['authorization']!.split(", Signature:");
        // String temp = resheaders['authorization']!;
        String res = await response.stream.bytesToString();
        print(res);
        // 
        // String decryptSignature = temp;
        // String decryptSignature="BTiqJrg+HrDqutcvAi4KLPQoniZsHQ2x+O5ZEAvkcVOyqwIuefXEkAAn2TY+kqquiiB1gdB6nN22ZZJ7vOIqAw==";
        print("Decrypt Signature: $decryptSignature");
        // String temp=await Newenc.signString(res);
        // String val = await decryption1(decryptSignature, res);
        String val = await decryption1(decryptSignature, res);
        print(val);

        if (val == "Verified!") {
          // await LogCat().writeContent(
          //     '${DateTimeDetails().currentDateTime()} : $res\n\n');

          print(res);
          print("\n\n");
          Map a = json.decode(res);
          print("Map a: $a");
          print(a['JSONResponse']['jsonContent']);
          String data = a['JSONResponse']['jsonContent'];
          main = json.decode(data);
          print("Values");
          print(main);
          if (main['Status'] == "FAILURE") {
            UtilFs.showToast("${main['errorMsg']}", context);
          } else {
            print(main['BOOFFICETYPE']);
            await OfficeDetail().select().delete();
            try {
              await OfficeDetail().select().delete();
              List temp0 = await OfficeDetail().select().toList();
              print("TEMP0");
              print(temp0.length);
              await OfficeDetail(
                BOOFFICETYPE: main['BOOFFICETYPE'],
                dateTime: main['DateTime'],
                BOOFFICECODE: main['BOOFFICECODE'],
                COOFFICETYPE: main['COOFFICETYPE'],
                HOOFFICEADDRESS: main['HOOFFICEADDRESS'],
                HOOFFICECODE: main['HOOFFICECODE'],
                HOOFFICETYPE: main['HOOFFICETYPE'],
                BOOFFICEADDRESS: main['BOOFFICEADDRESS'],
                OFFICECODE_6: main['OFFICECODE_6'],
                OFFICECODE_4: main['OFFICECODE_4'],
                OFFICECODE_5: main['OFFICECODE_5'],
                OFFICECODE_2: main['OFFICECODE_2'],
                OFFICECODE_3: main['OFFICECODE_3'],
                OFFICECODE_1: main['OFFICECODE_1'],
                POCode: main['POCode'],
                OFFICETYPE_3: main['OFFICETYPE_3'],
                OFFICEADDRESS_4: main['OFFICEADDRESS_4'],
                OFFICEADDRESS_3: main['OFFICEADDRESS_3'],
                OFFICETYPE_4: main['OFFICETYPE_4'],
                OFFICETYPE_1: main['OFFICETYPE_1'],
                OFFICEADDRESS_6: main['OFFICEADDRESS_6'],
                OFFICETYPE_2: main['OFFICETYPE_2'],
                OFFICEADDRESS_5: main['OFFICEADDRESS_5'],
                COOFFICEADDRESS: main['COOFFICEADDRESS'],
                OFFICEADDRESS_2: main['OFFICEADDRESS_2'],
                OFFICETYPE_5: main['OFFICETYPE_5'],
                COOFFICECODE: main['COOFFICECODE'],
                OFFICEADDRESS_1: main['OFFICEADDRESS_1'],
                OFFICETYPE_6: main['OFFICETYPE_6'],
              ).upsert();
              List temp1 = await OfficeDetail().select().toList();
              print("TEMP1");
              print(temp1.length);
            } catch (e) {
              print(e);
            }
            return true;
          }
        } else {
          await LogCat().writeContent(
              'Insurance Office Details Fetching: Signature Verification Failed.');
        }
      } else {
        // print(response.statusCode);
        // UtilFs.showToast("${await response.stream.bytesToString()}", context);
        // print(await response.stream.bytesToString());

        print(response.statusCode);
        List<API_Error_code> error = await API_Error_code()
            .select()
            .API_Err_code
            .equals(response.statusCode)
            .toList();
        if (response.statusCode == 503 || response.statusCode == 504) {
          UtilFsNav.showToast(
              "Insurance " + error[0].Description.toString(), context,
              UserPage(true));
        }
        else
          UtilFsNav.showToast(
              error[0].Description.toString(), context, UserPage(true));
      }
    }catch(e){
      print("error: $e");
    }
    // }
    return false;
  }

  Future<String> encryption() async {
    var login = await USERDETAILS().select().toList();
    final file = await _localFile;
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "getPOCode", "requestPOCodeXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text='{"m_BoID":"${login[0].BOFacilityID}","responseParams":"getPOCodeResponseParams"}';

    // String text="$bound""\nContent-Id: <requestPOCodeXML>\n\n"'{"m_BoID":"${login[0].BOFacilityID}","responseParams":"getPOCodeResponseParams"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";
    String text = "$bound"
        "\nContent-Id: <requestPOCodeXML>\n\n"
        '{"m_BoID":"${login[0].BOFacilityID}","responseParams":"getPOCodeResponseParams"}\n\n'
        // '{"m_BoID":"BO29310113004","responseParams":"getPOCodeResponseParams"}\n\n'
        // '{"m_BoID":"BO28307100001","responseParams":"getPOCodeResponseParams"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print("selfopenacct$text");
    file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    // print("Testing");
    // String testenc=await Newenc.signString("Hello1");
    // print(testenc);
    // String testdec=await Newenc.verifyString(testenc, "Hello");
    // print(testdec);
    // String val = await decryption1(test, text.trim().toString());
    // print("val in Decrytion of configfetch: $val");
    return test;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fetchAccountDetails.txt');
  }

  Future<String> get _localPath async {
    Directory directory = Directory('$cachepath');
    // print("Path is -"+directory.path.toString());
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    var _crossAxisSpacing = 10;
    var _screenWidth = MediaQuery.of(context).size.width;
    var _crossAxisCount = 2;
    var _width = (_screenWidth - ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    var cellHeight = 150;
    var _aspectRatio = _width / cellHeight;

    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        // appBar: AppBar(title: const Text('Darpan-Insurance', textAlign: TextAlign.center,style: TextStyle(fontSize:  22,),),backgroundColor: Color(0xFFB71C1C),
        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
        //       bottom: Radius.circular(20) )),
        // ),
        appBar: AppAppBar(title: 'Darpan-Insurance'),
        drawer: CustomDrawer(),
        body: FutureBuilder(
            future: getData,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Getting Office Details... "),
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
                                      title: "Premium Collection",
                                      img:
                                          "assets/images/premium_collector.png",
                                      pos: 1,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "New Business Quotes",
                                      img: "assets/images/business.png",
                                      pos: 2,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Proposal Indexing",
                                      img: "assets/images/indexing.png",
                                      pos: 3,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Policy Search",
                                      img: "assets/images/search.png",
                                      pos: 4,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Quote Generation",
                                      img: "assets/images/quotegen.png",
                                      pos: 5,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Service Request Indexing",
                                      img: "assets/images/requestindexing.png",
                                      pos: 6,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Reports",
                                      img: "assets/images/reports.png",
                                      pos: 7,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Status Request",
                                      img: "assets/images/statusrequest.png",
                                      pos: 8,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Transaction Update",
                                      img: "assets/images/statusrequest.png",
                                      pos: 9,
                                      bgcolor: Colors.grey[300]!,
                                    ),
                                    MyMenu(
                                      title: "Disbursement Status",
                                      img: "assets/images/statusrequest.png",
                                      pos: 10,
                                      bgcolor: Colors.grey[300]!,
                                    ),
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
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
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
              //color:Colors.red,
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

                  if (pos.toString() == '7') {
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ReportsScreen()),);
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
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => PremiumCollection()),);
                      }
                      else if (pos.toString() == '2') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NewBusinessQuotes()),);
                      }
                      else if (pos.toString() == '3') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NewProposalScreen()),);
                      }
                      else if (pos.toString() == '4') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => PolicySearchScreen()),);
                      }
                      else if (pos.toString() == '5') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ServicesQuoteGenerationScreen()),);
                      }
                      else if (pos.toString() == '6') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ServiceRequestIndexingScreen()),);
                      }

                      else if (pos.toString() == '8') {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => StatusRequestScreen()),);
                      }
                      else if (pos.toString() == '9') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TransactionUpdate()),
                        );
                      } else if (pos.toString() == '10') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisbursementStatus()),
                        );
                      }
                    }
                  }

                  // if (pos.toString() == '1') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PremiumCollection()),
                  //   );
                  // } else if (pos.toString() == '2') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => NewBusinessQuotes()),
                  //   );
                  // } else if (pos.toString() == '3') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => NewProposalScreen()),
                  //   );
                  // } else if (pos.toString() == '4') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PolicySearchScreen()),
                  //   );
                  // } else if (pos.toString() == '5') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             ServicesQuoteGenerationScreen()),
                  //   );
                  // } else if (pos.toString() == '6') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ServiceRequestIndexingScreen()),
                  //   );
                  // } else if (pos.toString() == '7') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => ReportsScreen()),
                  //   );
                  // } else if (pos.toString() == '8') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => StatusRequestScreen()),
                  //   );
                  // } else if (pos.toString() == '9') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TransactionUpdate()),
                  //   );
                  // } else if (pos.toString() == '10') {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DisbursementStatus()),
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
