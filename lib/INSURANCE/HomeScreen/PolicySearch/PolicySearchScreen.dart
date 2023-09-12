import 'dart:convert';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import '../HomeScreen.dart';

class PolicySearchScreen extends StatefulWidget {
  @override
  _PolicySearchScreenState createState() => _PolicySearchScreenState();
}

class _PolicySearchScreenState extends State<PolicySearchScreen> {
  TextEditingController policyno = TextEditingController();
  TextEditingController insdob = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController premdueamount = TextEditingController();
  TextEditingController cgst = TextEditingController();
  TextEditingController sgst = TextEditingController();
  TextEditingController gst = TextEditingController();
  TextEditingController premamount = TextEditingController();
  TextEditingController premint = TextEditingController();
  TextEditingController rebate = TextEditingController();
  TextEditingController paidtill = TextEditingController();
  TextEditingController custid = TextEditingController();
  Map main = {};
  bool policydetails = false;
  String? encheader;
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

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
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
          title: Text("Policy Search"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        // backgroundColor: Color(0xFFEEEEEE),
        backgroundColor: Colors.grey[300],

        body: SingleChildScrollView(
          child: Column(
            children: [
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
              Visibility(
                visible: !policydetails,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
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
                        controller: name,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          labelText: "Name of Insurant",
                          labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !policydetails,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .95,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(90.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.5, left: 15.0),
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
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: insdob,
                                  decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Insurant DOB",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              policydetails == false
                  ? TextButton(
                      child: Text(
                        "Search",
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


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                        if (policyno.text.length == 0) {
                          UtilFs.showToast("Please Enter Policy no", context);
                        } else {
                          try {
                            encheader = await encryptwriteContent();

                            // var headers = {
                            //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                            // };
                            // var request = http.Request('POST', Uri.parse(
                            //     'https://gateway.cept.gov.in:443/pli/searchPolicy'));
                            // request.files.add(await http.MultipartFile.fromPath('',
                            //     '$cachepath/fetchAccountDetails.txt'));
                            // request.headers.addAll(headers);

                            var headers = {
                              'Signature': '$encheader',
                              'Uri': 'searchPolicy',
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
                                await request.send();

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
                                print(main['Gstnumber']);
                                setState(() {
                                  policydetails = true;
                                });
                              } else {
                                UtilFsNav.showToast(
                                    "Signature Verification Failed! Try Again",
                                    context,
                                    PolicySearchScreen());
                                await LogCat().writeContent(
                                    'Policy Search screen: Signature Verification Failed.');
                              }
                            } else {
                              // UtilFsNav.showToast(
                              //     "${await response.stream.bytesToString()}",
                              //     context,
                              //     PolicySearchScreen());

                              print(response.statusCode);
                              List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                              if(response.statusCode==503 || response.statusCode==504){
                                UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,PolicySearchScreen());
                              }
                              else
                                UtilFsNav.showToast(error[0].Description.toString(), context,PolicySearchScreen());
                            }
                          } catch (_) {
                            if (_.toString() == "TIMEOUT") {
                              return UtilFsNav.showToast("Request Timed Out",
                                  context, PolicySearchScreen());
                            } else
                              print(_);
                          }
                        }
                      },
                    )
                  : Container(),
              policydetails == true
                  ? Container(
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width * .90.w,
                          //     child: TextFormField(
                          //       readOnly: true,
                          //       controller: paidtill..text = main['paidtodate'],
                          //       decoration: InputDecoration(
                          //         labelText: "Paid Till",
                          //         hintStyle: TextStyle(
                          //           fontSize: 15,
                          //           color: Color.fromARGB(255, 2, 40, 86),
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //         border: InputBorder.none,
                          //         enabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 color: Colors.blueGrey, width: 3)),
                          //         focusedBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 color: Colors.green, width: 3)),
                          //         contentPadding: EdgeInsets.only(
                          //             top: 20, bottom: 20, left: 20, right: 20),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: name..text = main['policyname'],
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Name of Insurant",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: custid..text = main['NAMEID'],
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Customer ID",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: paidtill
                                    ..text = main['paidtodate']
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
                                    labelText: "Paid Till",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: premdueamount
                                    ..text =
                                        "\u{20B9} ${main['premiumdueamt']}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Premium Due Amount",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: premint
                                    ..text =
                                        "\u{20B9} ${main['premiumintrest']}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Premium Interest",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: rebate
                                    ..text =
                                        "\u{20B9} ${main['premiumrebate']}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Rebate",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: cgst
                                    ..text =
                                        "\u{20B9} ${int.parse(main['srvtaxtotamt']) / 2}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "CGST",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: sgst
                                    ..text =
                                        "\u{20B9} ${int.parse(main['srvtaxtotamt']) / 2}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "SGST",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: gst
                                    ..text = "\u{20B9} ${main['srvtaxtotamt']}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Total GST",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
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
                                child: TextFormField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500),
                                  controller: premamount
                                    ..text = "\u{20B9} ${main['totalamt']}",
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 2, 40, 86),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                    labelText: "Total Amount",
                                    labelStyle:
                                        TextStyle(color: Color(0xFFCFB53B)),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          TextButton(
                            child: Text(
                              "Reset",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            style: ButtonStyle(
                                // elevation:MaterialStateProperty.all(),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PolicySearchScreen()));
                            },
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectinsDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime(2015),
        firstDate: DateTime(1970),
        lastDate: DateTime(2015),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          insdob.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //
  // Future<File> writeContent() async {
  //   var login=await USERDETAILS().select().toList();
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //
  //   file.writeAsStringSync('');
  //  String text='{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteContent() async {
    var login = await USERDETAILS().select().toList();
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "searchPolicy", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Policy Search ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
