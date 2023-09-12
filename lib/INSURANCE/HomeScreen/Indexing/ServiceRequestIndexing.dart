import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/decryptHeader.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../HomeScreen.dart';
import 'IndexingScreen.dart';

class ServiceRequestIndexingScreen extends StatefulWidget {
  @override
  _ServiceRequestIndexingScreenState createState() =>
      _ServiceRequestIndexingScreenState();
}

class _ServiceRequestIndexingScreenState
    extends State<ServiceRequestIndexingScreen> {
  late Directory d;
  late String cachepath;
  int _selectedIndex = 100;
  String _selectedDate =
      DateTimeDetails().onlyDate().toString().split('-').reversed.join('-');
  String? _currentDate;
  String _selectedService = "Loan";
  List<String> services = [
    'Loan',
    'Surrender',
    'Death Claim',
    'Maturity Claim',
    'Commutation',
    'Conversion',
    'Reduced Paidup',
    'Revival',
    'Survival Claim'
  ];
  String? encheader;
  bool _isLoading = false;

  TextEditingController policyno = TextEditingController();
  TextEditingController date = TextEditingController();

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
            "Service Request Indexing",
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
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              child: GestureDetector(
                                onTap: () => _selectDate,
                                child: IgnorePointer(
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: date..text = _selectedDate,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Date",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
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
                          _isLoading = true;
                        });


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                        print(policyno.text);
                        if (policyno.text.length != 0) {
                          Map main = {};
                          encheader = await encryptwriteContent();
                          try {
                            // var headers = {
                            //   'Content-Type':
                            //   'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                            // };
                            // var request = http.Request(
                            //     'POST',
                            //     Uri.parse(
                            //         'https://gateway.cept.gov.in:443/pli/searchPolicy'));
                            // request.files.add(
                            //     await http.MultipartFile.fromPath('',
                            //         '$cachepath/fetchAccountDetails.txt'));
                            // request.headers.addAll(headers);
                            //
                            // http.StreamedResponse response = await request
                            //     .send();

                            var headers = {
                              'Signature': '$encheader',
                              'Uri': 'searchPolicy',
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
                                String data = a['JSONResponse']['jsonContent'];
                                main = json.decode(data);
                                print("Values");
                                print(main['POLICYNUMBER']);
                                if (main['Status'] == "FAILURE") {
                                  print("Error received");
                                  print(main['errorMsg']);

                                  List<INS_ERROR_CODES> msg =
                                      await INS_ERROR_CODES()
                                          .select()
                                          .Error_code
                                          .startsWith(main['Response_No'])
                                          .toList();
                                  print(msg);
                                  UtilFsNav.showToast("${msg[0].Error_message}",
                                      context, ServiceRequestIndexingScreen());
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => IndexingScreen(
                                              policyno.text,
                                              _selectedService,
                                              main['policyname'],
                                              main['NAMEID'],
                                              main['paidtodate'],
                                              main['POLICYSTATUS'],
                                              main['POLISSDATE'],
                                              main['PLANNEDPREMIUM'].toString(),
                                              main['PRODNAME'],
                                              main['DUPLICATEPOLICYBONDISSUED']
                                                  .toString())));
                                }
                              } else {
                                UtilFsNav.showToast(
                                    "Signature Verification Failed! Try Again",
                                    context,
                                    ServiceRequestIndexingScreen());
                                await LogCat().writeContent(
                                    'Service Request Indexing Policy Search screen: Signature Verification Failed.');
                              }
                            } else {
                              // print(await response.stream.bytesToString());
                              // UtilFsNav.showToast(
                              //     "${await response.stream.bytesToString()}",
                              //     context,
                              //     ServiceRequestIndexingScreen());
                              print(response.statusCode);
                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                              if(response.statusCode==503 || response.statusCode==504){
                                UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,ServiceRequestIndexingScreen());
                              }
                              else
                                UtilFsNav.showToast(error[0].Description.toString(), context,ServiceRequestIndexingScreen());
                            }
                          } catch (_) {
                            if (_.toString() == "TIMEOUT") {
                              return UtilFsNav.showToast("Request Timed Out",
                                  context, ServiceRequestIndexingScreen());
                            } else
                              print(_);
                          }
                        } else if (policyno.text.length == 0)
                          UtilFsNav.showToast(
                              "Please Enter Policy no. to continue",
                              context,
                              ServiceRequestIndexingScreen());
                        else
                          UtilFsNav.showToast("Please select Service", context,
                              ServiceRequestIndexingScreen());
                      },
                    ),
                  )
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = new DateFormat('dd-MM-yyyy');
        _selectedDate = formatter.format(d);
      });
    }
  }

  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   String text='';
  //
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //   file.writeAsStringSync('');
  //   text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    String text = '';

    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');

    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "searchPolicy", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" SR Indexing ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
