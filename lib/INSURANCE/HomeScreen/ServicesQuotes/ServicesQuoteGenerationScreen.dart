import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
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
import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../HomeScreen.dart';
import 'PolicyDetailScreen.dart';

class ServicesQuoteGenerationScreen extends StatefulWidget {
  @override
  _ServicesQuoteGenerationScreenState createState() =>
      _ServicesQuoteGenerationScreenState();
}

class _ServicesQuoteGenerationScreenState
    extends State<ServicesQuoteGenerationScreen> {
  List<String> services = ["Surrender", "Loan", "Revival/Reinstatement"];
  String _selectedService = "Surrender";
  bool policyDetails = false;
  Map main = {};
  bool _isLoading = false;
  late Directory d;
  late String cachepath;

  TextEditingController policyno = TextEditingController();
  TextEditingController date = TextEditingController();
  String? encheader;

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
          title: Text("Quote"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
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
                        top: 5.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500),
                          controller: date
                            ..text = DateTimeDetails()
                                .onlyDate()
                                .toString()
                                .split("-")
                                .reversed
                                .join("-"),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            labelText: "Date",
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 8.0, right: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
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
                            if (policyno.text.length == 0)
                              UtilFs.showToast(
                                  "Please Enter Policy No. ", context);
                            else {
                              encheader = await encryptwriteContent();
                              try {
                                // var headers = {
                                //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                // };
                                // var request = http.Request('POST',
                                //     Uri.parse(
                                //         'https://gateway.cept.gov.in:443/pli/searchPolicyForIndexing'));
                                // request.files.add(
                                //     await http.MultipartFile.fromPath('',
                                //         '$cachepath/fetchAccountDetails.txt'));
                                // request.headers.addAll(headers);
                                //
                                // http.StreamedResponse response = await request
                                //     .send();

                                var headers = {
                                  'Signature': '$encheader',
                                  'Uri': 'searchPolicyForIndexing',
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
                                    print(res);
                                    print("\n\n");
                                    Map a = json.decode(res);
                                    print("Map a: $a");
                                    print(a['JSONResponse']['jsonContent']);
                                    String data =
                                        a['JSONResponse']['jsonContent'];
                                    main = json.decode(data);
                                    print("Values");
                                    print(main['Gstnumber']);
                                    if (main['Status'] == "FAILURE") {
                                      UtilFsNav.showToast(
                                          "No Records Found",
                                          context,
                                          ServicesQuoteGenerationScreen());
                                    } else {
                                      print(main['policyname']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  PolicyDetailScreen(
                                                      // main['policyname'],
                                                      _selectedService,
                                                      policyno.text,
                                                      main['DUPLICATEPOLICYBONDISSUED']
                                                          .toString(),
                                                      main['ISSUEDATE'],
                                                      main['MODALPREMIUM']
                                                          .toString(),
                                                      main['PRODUCTNAME'],
                                                      main['CUSTOMERFIRSTNAME'],
                                                      main['POLICYSTATUS'],
                                                      main['LASTPREMIUMDATE'],
                                                      main['NAMEID'])));
                                    }
                                  } else {
                                    UtilFsNav.showToast(
                                        "Signature Verification Failed! Try Again",
                                        context,
                                        ServicesQuoteGenerationScreen());
                                    await LogCat().writeContent(
                                        'Disbursement Status screen: Signature Verification Failed.');
                                  }
                                } else {
                                  // UtilFsNav.showToast(
                                  //     "${await response.stream.bytesToString()}",
                                  //     context,
                                  //     ServicesQuoteGenerationScreen());
                                  print(response.statusCode);
                                  print(await response.stream.bytesToString());
                                  List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                  if(response.statusCode==503 || response.statusCode==504){
                                    UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,ServicesQuoteGenerationScreen());
                                  }
                                  else
                                    UtilFsNav.showToast(error[0].Description.toString(), context,ServicesQuoteGenerationScreen());
                                }
                              } catch (_) {
                                if (_.toString() == "TIMEOUT") {
                                  return UtilFsNav.showToast(
                                      "Request Timed Out",
                                      context,
                                      ServicesQuoteGenerationScreen());
                                } else
                                  print(_);
                              }
                            }
                          },
                        ),
                      ],
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

  Future<String> get _localPath async {
    Directory directory = Directory('$cachepath');
    // print("Path is -"+directory.path.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/fetchAccountDetails.txt');
  }

  //  Future<File> writeContent() async {
  //    var login=await USERDETAILS().select().toList();
  //    final file=await _localFile;
  //
  //    file.writeAsStringSync('');
  // // String text='{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchLoanQuoteDetailsReq","m_effectiveDate":"2022-01-21","responseParams":"InterestRate,surrval,maxloan,minloanamt,paidupvalue,loanstatus,persuradmis,totbonus,isSecondLoan,Response_No,severity,Character_Value"}';
  //    String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"getPolicyDetailsFromMView"}';
  //    return file.writeAsString(text, mode: FileMode.append);
  //
  //  }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    final file = await _localFile;

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt",
        "searchPolicyForIndexing",
        "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text='{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchLoanQuoteDetailsReq","m_effectiveDate":"2022-01-21","responseParams":"InterestRate,surrval,maxloan,minloanamt,paidupvalue,loanstatus,persuradmis,totbonus,isSecondLoan,Response_No,severity,Character_Value"}';
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"getPolicyDetailsFromMView"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Fetch quotes ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
