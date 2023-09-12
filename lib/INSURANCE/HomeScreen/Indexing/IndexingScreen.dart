import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/decryptHeader.dart';
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
import '../../../LogCat.dart';
import 'ServiceRequestIndexing.dart';

class IndexingScreen extends StatefulWidget {
  String service;
  String policyno;
  String insured;
  String customid;
  String paid;
  String stat;
  String issue;
  String inst;
  String pname;
  String db;

  IndexingScreen(this.policyno, this.service, this.insured, this.customid,
      this.paid, this.stat, this.issue, this.inst, this.pname, this.db);

  @override
  _IndexingScreenState createState() => _IndexingScreenState();
}

class _IndexingScreenState extends State<IndexingScreen> {
  TextEditingController policyno = TextEditingController();
  TextEditingController insured = TextEditingController();
  TextEditingController custid = TextEditingController();
  TextEditingController paidtill = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController dupbond = TextEditingController();
  TextEditingController prodname = TextEditingController();
  TextEditingController installment = TextEditingController();
  TextEditingController issdate = TextEditingController();
  String? encheader;
  bool _isLoading = false;
  String _selectedDate = DateTimeDetails().servicerequestIndexingDate();
  Map main = {};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Indexing Screen"),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.service,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: policyno..text = widget.policyno,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Policy No."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: insured..text = widget.insured,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Insured"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: custid..text = widget.customid,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Customer ID"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: paidtill..text = widget.paid,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Premium Paid Till"),
                  ),
                ),
                widget.service == "Maturity Claim"
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: status
                            ..text = "Pending Maturity Processing",
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 3)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 3)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              labelText: "Policy Status"),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: status..text = widget.stat,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 3)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.green, width: 3)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              labelText: "Policy Status"),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: issdate..text = widget.issue,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Issue Date"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: installment..text = widget.inst,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "Installment Amount(Excl. Tax)"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: prodname..text = widget.pname,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 2, 40, 86),
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 3)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 3)),
                        contentPadding: EdgeInsets.only(
                            top: 20, bottom: 20, left: 20, right: 20),
                        labelText: "ProductName"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _selectinsDate(context);
                    },
                    child: Container(
                      child: GestureDetector(
                          onTap: () => _selectinsDate,
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: dupbond..text = _selectedDate,
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey, width: 3)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.green, width: 3)),
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 20, right: 20),
                                  labelText: "Passbook Paid To Date"),
                            ),
                          )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      child: Text('SUBMIT'),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xFFCC0000)),
                      onPressed: () async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                        encheader = await encryptwriteClaimContent();
                        try {
                          // var request = http.Request(
                          //     'POST',
                          //     Uri.parse(
                          //         'https://gateway.cept.gov.in:443/pli/claimRequest'));
                          // request.files.add(await http.MultipartFile.fromPath('',
                          //     '$cachepath/fetchAccountDetails.txt'));
                          //
                          //
                          // http.StreamedResponse response = await request.send();

                          var headers = {
                            'Signature': '$encheader',
                            'Uri': 'claimRequest',
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
                            var resheaders = response.headers;
                            print("Response Headers");
                            print(resheaders['authorization']);

                            String temp = resheaders['authorization']!;
                            String decryptSignature = temp;
                            String res = await response.stream.bytesToString();
                            print(res);
                            String val =
                                await decryption1(decryptSignature, res);
                            if (val == "Verified!") {
                              await LogCat().writeContent(
                                                    '$res');
                              Map a = json.decode(res);
                              // print(a['JSONResponse']['jsonContent']);
                              String data = a['JSONResponse']['jsonContent'];
                              main = json.decode(data);
                              print("Response: $main");
                              if (main['serviceRequestId'] == null) {
                                List<INS_ERROR_CODES> errors =
                                    await INS_ERROR_CODES()
                                        .select()
                                        .Error_code
                                        .equals(main['errorCode'])
                                        .toList();
                                UtilFsNav.showToast(
                                    "${errors[0].Error_message}",
                                    context,
                                    ServiceRequestIndexingScreen());
                              } else {
                                // UtilFs.showToast("${main['serviceRequestId']}", context);

                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                          "Application with Request ID ${main['serviceRequestId']} has been checked in."),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          TextButton(
                                                            child: Text(
                                                              "Back",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFFCC0000),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (_) =>
                                                                              ServiceRequestIndexingScreen()));
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }
                            } else {
                              UtilFsNav.showToast(
                                  "Signature Verification Failed! Try Again",
                                  context,
                                  ServiceRequestIndexingScreen());
                              await LogCat().writeContent(
                                  'Service Request indexing screen: Signature Verification Failed.');
                            }
                          } else {
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
                      },
                    ),
                    TextButton(
                      child: Text('CANCEL'),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xFFCC0000)),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ServiceRequestIndexingScreen()));
                      },
                    )
                  ],
                )
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
    );
  }

  Future<void> _selectinsDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime(2015),
        firstDate: DateTime(1970),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yy');
          _selectedDate = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

//   writeClaimContent() async{
// //     final file = await File('$cachepath/fetchAccountDetails.txt');
// //
// //     file.writeAsStringSync('');
// //     String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO11302127002","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
// // print(text);
// //     return file.writeAsString(text, mode: FileMode.append);
//     var login=await USERDETAILS().select().toList();
//     String text='';
//     final file = await File('$cachepath/fetchAccountDetails.txt');
//     file.writeAsStringSync('');
//     if(widget.service=="Maturity Claim")
//       text='{"policyNumber":"${policyno.text}","requestType":"Maturity Claim","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestSubParams":{"paidToDate":"${dupbond.text.toString()}"}}';
//     else if(widget.service=="Loan")
//       text='{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Loan","requestSubParams":{"paidToDate":""}}';
//     else if(widget.service=="Survival Claim")
//       text='{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Survival Claim","requestSubParams":{"paidToDate":""}}';
//     else if(widget.service=="Commutation")
//       text='{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Commutation","requestSubParams":{"paidToDate":""}}';
//     else if(widget.service=="Reduced Paidup")
//       text='{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Reduced Paidup","requestSubParams":{}}';
//     print(text);
//     return file.writeAsString(text, mode: FileMode.append);
//   }

  Future<String> encryptwriteClaimContent() async {
    var login = await USERDETAILS().select().toList();
    String text = '';
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "claimRequest", "claimRequest");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];

    if (widget.service == "Maturity Claim")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","requestType":"Maturity Claim","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestSubParams":{"paidToDate":"${dupbond.text.toString()}"}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Loan")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Loan","requestSubParams":{"paidToDate":""}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Survival Claim")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Survival Claim","requestSubParams":{"paidToDate":""}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Commutation")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Commutation","requestSubParams":{"paidToDate":""}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Reduced Paidup")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Reduced Paidup","requestSubParams":{}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Surrender")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Surrender","requestSubParams":{"paidToDate":"$_selectedDate"}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Death Claim")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Death Claim","requestSubParams":{"paidToDate":"$_selectedDate"}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Revival")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Revival","requestSubParams":{"paidToDate":""}}\n\n'
          "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
          "";
    else if (widget.service == "Conversion")
      text = "$bound"
          "\nContent-Id: <claimRequest>\n\n"
          '{"policyNumber":"${policyno.text}","serviceRequestDate":"${DateTimeDetails().onlyDate()}","serviceRequestChannel":"RICT","officeCode":"${login[0].BOFacilityID}","userName":"${login[0].EMPID}","requestType":"Conversion","requestSubParams":{"paidToDate":""}}\n\n'
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
