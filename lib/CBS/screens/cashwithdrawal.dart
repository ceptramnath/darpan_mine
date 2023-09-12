import 'dart:convert';
import 'dart:io';

import 'package:basic_utils/basic_utils.dart';
import 'package:darpan_mine/Aadhar/checkAadhar.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/accdetails.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/randomstring.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';
import '../../LogCat.dart';
import '../decryptHeader.dart';
import 'CBSErrors.dart';
import 'Highvaluwdlfirstpage.dart';
import 'cashwithdrawlcardstyle.dart';
import 'my_cards_screen.dart';

class CashWithdrawal extends StatefulWidget {
  @override
  _CashWithdrawalState createState() => _CashWithdrawalState();
}

class _CashWithdrawalState extends State<CashWithdrawal> {
  RegExp anvalidator=RegExp(r'^[2-9]{1}[0-9]{11}$');
  final amountText = TextEditingController();
  final accountType = TextEditingController();
  final myController = TextEditingController();
  bool _showClearButton = true;
  bool _isVisible = false;
  bool _isJointVisible = false;
  bool _isinitiatewithdraw = false;
  String? j1cif,j2cif,j3cif,j1aadhar,j2aadhar,j3aadhar;
  String? selectedReceipt;
  List multiaadhar=[];
  List multiholder=[];
  List multicif=[];
  bool wdas = false;
  String? schcode;
  //List<String> _services = ["Signature", "Procedural", "AAPS"];
  List<String> _services = ["AAPS","Signature", "Procedural", ];
  String _selectedValue = "AAPS";
  String _flag_trandetails="AE";
  Map main = {};
  Map depositmain = {};
  // List achname=[];
  String? achname;
  String? bal, mainbal, balafterdeposit, balAftrTrn;
  List<TBCBS_TRAN_DETAILS> cbsDetails = [];
  final RegExp regexp = new RegExp(r'^0+(?=.)');
  String? processingDate,
      processingTime,
      processingDatetemp,
      processingTimetemp;
  String? transDate;
  List? rec = [];
  List? balances = [];
  bool _isLoading = false;
  bool signvisible = false;
  var sbSign;
  String? tid;
  bool _isNewLoading = false;
  String? encheader = "";
  String achaadhar = "";
  late Directory d;
  late String cachepath;

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
        (route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCacheDir();
    setState(() {
      amountText.clear();
      accountType.clear();
      myController.clear();
      _isVisible = false;
    });
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Cash Withdrawal',
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
              SingleChildScrollView(
                child: Column(children: [
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
                      var login = await USERDETAILS().select().toList();
                      FocusScope.of(context).unfocus();
                      List<TBCBS_TRAN_DETAILS> acccheck=await TBCBS_TRAN_DETAILS().select().CUST_ACC_NUM.equals(myController.text).and.startBlock.STATUS.equals("PENDING").endBlock.toList();
                      if (acccheck.length>0) {
                        UtilFsNav.showToast("Please clear the pending transactions on the account before proceeding further for next transaction",context,CashWithdrawal());
                      }
                      else{
                      if (myController.text.isNotEmpty) {
                        setState(() {
                          _isLoading = true;
                        });
                        encheader = await encryptfetchaccdetails();
                        // var request = http.Request('POST', Uri.parse(
                        //     'https://gateway.cept.gov.in:443/cbs/requestJson'));
                        // request.files.add(await http.MultipartFile.fromPath('',
                        //     '$cachepath/withdrawlAcctDetails.txt'));
                        // http.StreamedResponse response = await request.send();


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                        print(acctoken.length);
                        print(acctoken[0].AccessToken);

                        try {
                          var headers = {
                            'Signature': '$encheader',
                            'Uri': 'requestJson',
                            // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                            'Authorization': 'Bearer ${acctoken[0].AccessToken}',
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
                            String res = await response.stream.bytesToString();
                            String temp = resheaders['authorization']!;
                            String decryptSignature = temp;
                            String val = await decryption1(decryptSignature, res);
                            if (val == "Verified!") {
                              await LogCat().writeContent(
                                                    '$res');
                              Map a = json.decode(res);
                              print(a['JSONResponse']['jsonContent']);
                              String data = a['JSONResponse']['jsonContent'];
                              main = json.decode(data);
                              print("Values");
                              print(main);
                              //  bool accountInvalidFlag = false;
                              //  String invalidMessage = "";
                              //  String caseResponse= await statusMessage(main['125']);
                              //  print('casmethod');
                              //  print(caseResponse);
                              //  if(caseResponse!= 'false'){
                              //    accountInvalidFlag = true;
                              //    invalidMessage =caseResponse;
                              //  }
                              //
                              //  if(accountInvalidFlag){
                              // // if (main['125'] == "Invalid ACCOUNT") {
                              //    UtilFs.showToast(
                              //        "Entered account number doesnot exist", context);
                              //  }
                              setState(() {
                                _isLoading = false;
                              });
                              if (main['Status'] == "SUCCESS") {
                                if (main['39'] != "000") {
                                  var ec = await CBS_ERROR_CODES()
                                      .select()
                                      .Error_code
                                      .equals(main['39'])
                                      .toList();
                                  UtilFsNav.showToast('${ec[0].Error_message}',
                                      context, CashWithdrawal());
                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             CashWithdrawal()),
                                  //         (route) => false);
                                } else {
                                  List checkaccount =
                                      await fac.split126accenquiry(main['126']);
                                  rec = await fac.split125(main['125']);
                                  print("Rec");
                                  print(rec![7]);
                                  if(int.parse(rec![7])==017 || int.parse(rec![7])==016) {
                                    print("Entered as not 012");

                                     j1cif = checkaccount[13];
                                     j1aadhar = checkaccount[14];
                                     j2cif = checkaccount[16];
                                     j2aadhar = checkaccount[17];
                                     j3cif = checkaccount[19];
                                     j3aadhar = checkaccount[20];
                                    print("joint holder details");
                                    print(j1cif);
                                    print(j1aadhar);
                                    print(j2cif);
                                    print(j2aadhar);
                                    print(j3cif);
                                    print(j3aadhar);
                                    print(rec![7]);
                                    print(rec![1]);
                                    print(rec![8]);
                                    print(rec![9]);
                                    print(rec![10]);
                                    multicif.add(" CIF ID"+"\n\n"+rec![0]);
                                    multicif.add(" CIF ID"+"\n\n"+j1cif!);
                                    if(j2cif!="")
                                    multicif.add(" CIF ID"+"\n\n"+j2cif!);
                                     if(j2cif!="")
                                    multicif.add(" CIF ID"+"\n\n"+j3cif!);
                                     multiaadhar.add(" Aadhar Number"+"\n\n"+checkaccount[0]);
                                    multiaadhar.add(" Aadhar Number"+"\n\n"+j1aadhar!);
                                    // multiaadhar.add(" Aadhar Number"+"\n\n"+"DLMPS9863P");
                                     if(j2aadhar!="")
                                    multiaadhar.add(" Aadhar Number"+"\n\n"+j2aadhar!);
                                     else
                                       multiaadhar.add(" Aadhar Number"+"\n\n"+"NA");
                                     if(j3aadhar!="")
                                    multiaadhar.add(" Aadhar Number"+"\n\n"+j3aadhar!);
                                     else
                                       multiaadhar.add(" Aadhar Number"+"\n\n"+"NA");
                                    multiholder.add(" Primary Account Holder"+"\n\n"+rec![1]);
                                     multiholder.add(" Joint Account Holder-1"+"\n\n"+rec![8]);
                                     if(rec![9]!="")
                                     multiholder.add(" Joint Account Holder-2"+"\n\n"+rec![9]);
                                     if(rec![10]!="")
                                     multiholder.add(" Joint Account Holder-3"+"\n\n"+rec![10]);
                                    // selectedReceipt!.replaceAll("CIF ID", "").replaceAll("\n\n","").trim()
                                    anvalidator.hasMatch(multiaadhar[1].replaceAll(" Aadhar Number", "").replaceAll("\n\n",""))?
                                      print("True"):print("False");


                                     // !anvalidator.hasMatch(multiaadhar[1]);
                                  }
                                  else{
                                    achaadhar = checkaccount[0];

                                    if (achaadhar == "") {
                                      _services.remove("AAPS");
                                      _selectedValue = "Signature";
                                      _flag_trandetails="BY";
                                    }
                                  }
                                  if (checkaccount[1] == login[0].BOFacilityID) {

                                    String acstatus = rec![6];
                                    schcode = rec![4];
                                    if (schcode!.contains("SB")) {
                                      achname = rec![1];
                                      balances = await fac.split48(main['48']);
                                      String reduced =
                                          balances![1]!.replaceAll(regexp, '');
                                      print("Reduced String"+reduced);
                                      if(reduced=="0"){
                                        mainbal="0.00";
                                      }
                                      else {
                                        mainbal = StringUtils.addCharAtPosition(
                                            reduced, ".", reduced.length - 2);
                                      }
                                      if (acstatus == "A") {
                                        if(int.parse(rec![7])==017 || int.parse(rec![7])==016){
                                          print("acc status is ${rec![7]}");
                                          setState(() {
                                            _isJointVisible=true;
                                          });
                                        }
                                          setState(() {
                                            _isVisible = true;
                                          });
                                      } else {
                                        String error = cbsErrors(acstatus);
                                        UtilFsNav.showToast(
                                            error, context, CashWithdrawal());
                                      }
                                    }
                                    else {
                                      UtilFsNav.showToast(
                                          "Entered Account is not an SB account. Please enter Correct Number",
                                          context,
                                          CashWithdrawal());
                                    }
                                  }
                                  else {
                                    UtilFsNav.showToast(
                                        "Account Number Entered doesnot belong to this BO",
                                        context,
                                        CashWithdrawal());
                                  }
                                }
                              }
                            }
                          } else {
                            // UtilFs.showToast("${response.statusCode}", context);
                            // print(response.statusCode);

                            //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                            print(response.statusCode);
                            List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                            if(response.statusCode==503 || response.statusCode==504){
                              UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,CashWithdrawal());
                            }
                            else
                              UtilFsNav.showToast(error[0].Description.toString(), context,CashWithdrawal());
                          }
                        } catch (_) {
                          if (_.toString() == "TIMEOUT") {
                            return UtilFs.showToast("Request Timed Out", context);
                          } else {
                            print(_);
                          }
                        }
                      } else {
                        UtilFs.showToast("Enter Account Number", context);
                      }
                    }
                    }
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(accountType.text + ' Account Details',
                            style:
                                TextStyle(fontSize: 18, color: Colors.blueGrey)),
                        SizedBox(
                          width: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(border: TableBorder.all(), children: [
                            TableRow(
                              children: [
                                Column(children: [
                                  Text('Account No.',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                                Column(children: [
                                  Text(myController.text,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                              ],
                            ),
                            TableRow(
                              children: [
                                Column(children: [
                                  Text('Name',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                                Column(children: [
                                  Text('${achname.toString().trim()}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                              ],
                            ),
                            TableRow(
                              children: [
                                Column(children: [
                                  Text('Account Balance',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                                Column(children: [
                                  Text('\u{20B9} $mainbal',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[600]))
                                ]),
                              ],
                            ),
                            if (achaadhar != "")
                              TableRow(
                                children: [
                                  Column(children: [
                                    Text('Aadhar Number of selected Account Holder',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                  Column(children: [
                                    Text(
                                        'XXXX XXXX ${achaadhar.substring(8, 12)}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]),
                                ],
                              ),
                          ]),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible:_isJointVisible,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                           child: SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                             physics: BouncingScrollPhysics(),
                             // child: _createJointHolderData(),
                             child:Container(
                               // height:MediaQuery.of(context).size.height,
                               // width:MediaQuery.of(context).size.width*3,
                               width:MediaQuery.of(context).size.width*1,
                               child: Column(

                                   children: List<Widget>.generate(
                                       multicif.length, (index) {
                                     return RadioListTile<String>(
                                       // title: Text("${receipts[index]['receiptNumber'].toString()}""${receipts[index]['receiptDate'].toString()}""${receipts[index]['totalAmount'].toString()}"),
                                       title: Table(
                                         border: TableBorder.all(),
                                         columnWidths: const {
                                           0: FlexColumnWidth(1.1),
                                           1: FlexColumnWidth(1.1),
                                           // 2: FlexColumnWidth(1.1),
                                           // 3:FlexColumnWidth(1.1),
                                           // 4:FlexColumnWidth(1.1),
                                         },
                                         // defaultColumnWidth: IntrinsicColumnWidth(),
                                         // defaultColumnWidth: FixedColumnWidth(150.0),
                                         children: [
                                           TableRow(children: [
                                             Center(
                                                 child: Text(
                                                     "${multiholder[index].toString()}")),
                                             // Center(
                                             //     child: Text(
                                             //         "${multicif[index].toString()}")),
                                             // anvalidator.hasMatch(multiaadhar[index].replaceAll(" Aadhar Number", "").replaceAll("\n\n",""))?  Center(
                                             //     child: Text(
                                             //         "${multiaadhar[index].toString()}")): Center(
                                             //     child: Text(" Aadhar Number"+"\n\n"+"NA"
                                             //     ))
                                             // Center(
                                             //     child: Text(
                                             //         "${multiholder[index].toString()}")),
                                             // Center(
                                             //     child: Text(
                                             //         "${multiholder[index].toString()}")),

                                           ])
                                         ],
                                       ),
                                       value: multicif[index]
                                           .toString(),
                                       groupValue: selectedReceipt,
                                       onChanged: (value) {

                                         setState(() {
                                           achaadhar="";
                                           sbSign=null;
                                           selectedReceipt = value;
                                           anvalidator.hasMatch(multiaadhar[index].replaceAll(" Aadhar Number", "").replaceAll("\n\n",""))? achaadhar=multiaadhar[index].replaceAll(" Aadhar Number", "").replaceAll("\n\n",""):"";
                                         });
                                         anvalidator.hasMatch(multiaadhar[index].replaceAll(" Aadhar Number", "").replaceAll("\n\n",""))?(_services.contains("AAPS")?"":_services.add("AAPS")): _services.remove("AAPS");
                                         String cif=selectedReceipt!.replaceAll("CIF ID", "").replaceAll("\n\n","").trim();
                                         print("CIF Seleced: $cif");
                                       },
                                     );
                                   })
                               ),
                             )
                           )
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Flexible(
                          child: RadioGroup<String>.builder(
                            direction: Axis.horizontal,
                            groupValue: _selectedValue,
                            onChanged: (value) => setState(() {
                              _selectedValue = value!;
                              print(_selectedValue);
                              if(_selectedValue=="AAPS")
                                _flag_trandetails = "AE";
                              else
                                _flag_trandetails = "BY";
                              signvisible=false;
                              wdas=false;
                              amountText.text="";
                            }),
                            items: _services,
                            itemBuilder: (item) => RadioButtonBuilder(
                              item,
                            ),
                          ),
                        ),
                        TextButton(
                          child: Text("Proceed"),
                          style: TextButton.styleFrom(
                              elevation: 5.0,
                              textStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Georgia",
                                  letterSpacing: 1),
                              backgroundColor: Color(0xFFCC0000),
                              primary: Colors.white),
                          onPressed: () async {
                            if(_isJointVisible==true && selectedReceipt==null){
                              UtilFs.showToast("Please select the account holder",context);
                            }
                            else{
                            setState(() {
                              _isLoading = true;
                            });
                            if (_selectedValue == "Signature") {
                              encheader = await encryptfetchsigndetails();


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                              try {
                                // var request = http.Request('POST',
                                //     Uri.parse(
                                //         'https://gateway.cept.gov.in:443/cbs/requestSign'));
                                // request.fields.addAll({
                                //   'Content-ID': '<postSignXML>'
                                // });
                                // request.files.add(await http.MultipartFile.fromPath(
                                //     '',
                                //     '$cachepath/fetchAccountDetails.txt'));
                                // request.headers.addAll(headers);

                                var headers = {
                                  'Signature': '$encheader',
                                  // 'Uri': 'requestSign',
                                  'Uri': 'requestSign',
                                  // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
                                  'Authorization':
                                      'Bearer ${acctoken[0].AccessToken}',
                                  'Cookie':
                                      'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                };

                                // var request = http.Request(
                                //     'POST', Uri.parse(APIEndPoints().cbsURL));
                                // request.files.add(
                                //     await http.MultipartFile.fromPath('file',
                                //         '$cachepath/fetchAccountDetails.txt'));

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
                                String res = await response.stream
                                    .bytesToString();
                                print(res);
                                if (response.statusCode == 200) {
                                  var resheaders = await response.headers;
                                  print("Result Headers");
                                  print(resheaders);
                                  // List t = resheaders['authorization']!
                                  //     .split(", Signature:");
                                  // String res =
                                  //     await response.stream.bytesToString();
                                  String temp = resheaders['authorization']!;
                                  String decryptSignature = temp;

                                  String val =
                                      await decryption1(decryptSignature, res);
                                  // print(res);
                                  if (val == "Verified!") {
                                    // await LogCat().writeContent(
                                    //                 '$res');
                                    Map a = json.decode(res);
                                    // print(a['JSONResponse']['jsonContent']);
                                    String data =
                                        a['JSONResponse']['jsonContent'];
                                    data.replaceAll("\n", "");
                                    print(data);

                                    main = json.decode(data);
                                    if (main['Status'] == "FAILURE") {
                                      UtilFs.showToast(main['errorMsg'], context);
                                    } else {
                                      print("Values");
                                      print(main['returnedSignature']
                                          .replaceAll("\n", ""));
                                      String tempimage = main['returnedSignature']
                                          .replaceAll("\n", "");
                                      print(tempimage);
                                      setState(() {
                                        sbSign = Base64Decoder().convert(tempimage);
                                      });

                                      // sbSign = Base64Decoder().convert(tempimage);
                                    }
                                  }
                                } else {

                                  //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                  print(response.statusCode);
                                  List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                  if(response.statusCode==503 || response.statusCode==504){
                                    UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,CashWithdrawal());
                                  }
                                  else
                                    UtilFsNav.showToast(error[0].Description.toString(), context,CashWithdrawal());

                                  // UtilFs.showToast(
                                  //     response.reasonPhrase!, context);
                                  // UtilFs.showToast(
                                  //     "${await response.stream.bytesToString()}",
                                  //     context);
                                }
                              } catch (_) {
                                if (_.toString() == "TIMEOUT") {
                                  return UtilFs.showToast(
                                      "Request Timed Out", context);
                                }
                              }
                            }
                            else if (_selectedValue == "Procedural") {
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Do you want to authenticate the customer procedural.'),
                                      actions: <Widget>[
                                        TextButton(
                                          style: ButtonStyle(
                                              // elevation:MaterialStateProperty.all(),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.red)))),
                                          child: Text("YES"),
                                          onPressed: () async {
                                            setState(() {
                                              _isNewLoading = false;
                                              wdas = true;

                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("CANCEL"),
                                          onPressed: () {
                                            //Put your code here which you want to execute on Cancel button click.
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                            else if (_selectedValue == "AAPS") {
                              setState(() {
                                _isLoading = false;
                              });
                              print(achaadhar);

                              // String aadharresponse= await captureFromDevice(achaadhar);
                              // if(aadharresponse!="y") {
                              //   UtilFs.showToast(aadharresponse, context);
                              // }
                              // else {
                              //   print(aadharresponse);
                              // }

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirmation'),
                                      content: Text(
                                          'Do you want to authenticate the customer with Aadhar.'),
                                      actions: <Widget>[
                                        TextButton(
                                          style: ButtonStyle(
                                              // elevation:MaterialStateProperty.all(),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: BorderSide(
                                                          color: Colors.red)))),
                                          child: Text("YES"),
                                          onPressed: () async {
                                            setState(() {
                                              _isNewLoading = false;
                                              wdas = true;

                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("CANCEL"),
                                          onPressed: () {
                                            //Put your code here which you want to execute on Cancel button click.
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            }
                          }},
                        ),
                      ],
                    ),
                  ),
                  sbSign == null
                      ? Container()
                      : Column(
                          children: [
                            Image.memory(
                              sbSign,
                              height: 100,
                              width: MediaQuery.of(context).size.width * 99,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text("Confirm"),
                                  style: TextButton.styleFrom(
                                      elevation: 5.0,
                                      textStyle: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "Georgia",
                                          letterSpacing: 1),
                                      backgroundColor: Color(0xFFCC0000),
                                      primary: Colors.white),
                                  onPressed: () async {
                                    setState(() {
                                      wdas = true;
                                    });
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  style: TextButton.styleFrom(
                                      elevation: 5.0,
                                      textStyle: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: "Georgia",
                                          letterSpacing: 1),
                                      backgroundColor: Color(0xFFCC0000),
                                      primary: Colors.white),
                                  onPressed: () async {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CashWithdrawal()),
                                        (route) => false);
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                  Visibility(
                    visible: wdas,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Amount of Transaction';
                              } else if (int.parse(amountText.text.toString()) >
                                  50000) {
                                return 'Enter the transaction amount less than or equal to 50000';
                              }
                            },
                            style: TextStyle(
                                fontSize: 17,
                                color: //Colors.white,
                                    Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: amountText,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  MdiIcons.currencyInr,
                                  size: 22,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              hintText: ' Enter Amount',
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
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
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () async {
                                var walletAmount =
                                    await CashService().cashBalance();
                                if (walletAmount >= int.parse(amountText.text)) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return Stack(
                                            children: [
                                              AlertDialog(
                                                title: Text('Confirmation'),
                                                content: Text(
                                                    'Do you want to proceed with the withdraw of Rs.' +
                                                        amountText.text +
                                                        ', Please'
                                                            ' note that transaction once initiated cannot be reverted.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text("YES"),
                                                    style: ButtonStyle(
                                                        // elevation:MaterialStateProperty.all(),
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                                side: BorderSide(
                                                                    color: Colors
                                                                        .red)))),
                                                    onPressed: () async {
                                                      var login =
                                                          await USERDETAILS()
                                                              .select()
                                                              .toList();
                                                      setState(() {
                                                        _isNewLoading = true;
                                                      });
                                                      if (int.parse(
                                                              amountText.text) >
                                                          20000) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    HighValueWd(
                                                                        myController
                                                                            .text)));
                                                      } else {
                                                        String wdlmethod = "";
                                                        tid =
                                                            GenerateRandomString()
                                                                .randomString();
                                                        encheader =
                                                            await encryptfetchwithdrawdetails(
                                                                tid!);

                                                        if (_selectedValue ==
                                                            "Signature") {
                                                          wdlmethod = "Signature";
                                                        } else if (_selectedValue ==
                                                            "Procedural") {
                                                          wdlmethod =
                                                              "Procedural";
                                                        } else if (_selectedValue ==
                                                            "AAPS") {
                                                          wdlmethod = "AAPS";
                                                        }

                                                        await TBCBS_TRAN_DETAILS(
                                                                DEVICE_TRAN_ID:
                                                                    tid,
                                                                TRANSACTION_ID:
                                                                    tid,
                                                                ACCOUNT_TYPE:
                                                                    schcode,
                                                                OPERATOR_ID:
                                                                    '${login[0].EMPID}',
                                                                CUST_ACC_NUM:
                                                                    myController.text
                                                                        .toString(),
                                                                TRANSACTION_AMT:
                                                                    amountText
                                                                        .text
                                                                        .toString(),
                                                                TRAN_DATE:
                                                                    '${DateTimeDetails().onlyExpDate()}',
                                                                TRAN_TIME:
                                                                    '${DateTimeDetails().onlyTime()}',
                                                                TRAN_TYPE: 'W',
                                                                DEVICE_TRAN_TYPE:
                                                                    'CW',
                                                                CURRENCY: 'INR',
                                                                MODE_OF_TRAN:
                                                                    'Cash',
                                                                FIN_SOLBOD_DATE:
                                                                    DateTimeDetails()
                                                                        .onlyDate(),
                                                                TENURE: '0',
                                                                INSTALMENT_AMT:
                                                                    '0',
                                                                NO_OF_INSTALMENTS:
                                                                    '0',
                                                                REBATE_AMT: '0',
                                                                DEFAULT_FEE: '0',
                                                                STATUS: 'PENDING',
                                                                MAIN_HOLDER_NAME:
                                                                    '$achname',
                                                                SCHEME_TYPE:
                                                                    schcode,
                                                                REMARKS:
                                                                    '$wdlmethod')
                                                            .upsert();
                                                        // var headers = {
                                                        //   'Content-Type': 'application/octet-stream',
                                                        //   'Content-Transfer-Encoding': 'binary',
                                                        //   'Content-ID': '<postSignXML>',
                                                        //   'Content-Disposition': 'attachment'
                                                        // };

                                                        if (_selectedValue ==
                                                            "AAPS") {
                                                          print(achaadhar);
                                                          String aadharresponse =
                                                              await captureFromDevice(
                                                                  achaadhar);
                                                          if (aadharresponse !=
                                                              "y") {
                                                            setState(() {
                                                              _isNewLoading =
                                                                  false;
                                                            });
                                                            UtilFsNav.showToast(
                                                                aadharresponse,
                                                                context,
                                                                CashWithdrawal());
                                                          } else {
                                                            print(aadharresponse);
                                                            proceedwithwdl();
                                                          }
                                                        } else {
                                                          proceedwithwdl();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  FlatButton(
                                                    child: Text("CANCEL"),
                                                    onPressed: () {
                                                      //Put your code here which you want to execute on Cancel button click.
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              _isNewLoading == true
                                                  ? Loader(
                                                      isCustom: true,
                                                      loadingTxt:
                                                          'Please Wait...Loading...')
                                                  : Container()
                                            ],
                                          );
                                        });
                                      });
                                }
                                else {
                                  UtilFsNav.showToast(
                                      "Wallet Balance is less than Entered Amount",
                                      context,
                                      CashWithdrawal());
                                }
                              }),
                        ),
                      ],
                    ),
                  )
                ]),
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
  Widget? _createJointHolderData(){
   return Container(
     // height:MediaQuery.of(context).size.height,
     width:MediaQuery.of(context).size.width,
      child: Column(
          children: List<Widget>.generate(
              multicif.length, (index) {
            return RadioListTile<String>(
              // title: Text("${receipts[index]['receiptNumber'].toString()}""${receipts[index]['receiptDate'].toString()}""${receipts[index]['totalAmount'].toString()}"),
              title: Table(
                border: TableBorder.all(),
                // columnWidths: const {
                //   0: FlexColumnWidth(1.1),
                //   1: FlexColumnWidth(1.1),
                //   2: FlexColumnWidth(1.1),
                //   3:FlexColumnWidth(1.1),
                //   4:FlexColumnWidth(1.1),
                // },
                // defaultColumnWidth: IntrinsicColumnWidth(),
                defaultColumnWidth: FixedColumnWidth(150.0),
                children: [
                  TableRow(children: [
                    Center(
                        child: Text(
                            "${multiholder[index].toString()}")),
                    Center(
                        child: Text(
                            "${multicif[index].toString()}")),
                    Center(
                        child: Text(
                            "${multiaadhar[index].toString()}")),
                    Center(
                        child: Text(
                            "${multiholder[index].toString()}")),
                    Center(
                        child: Text(
                            "${multiholder[index].toString()}")),

                  ])
                ],
              ),
              value: multicif[index]
                  .toString(),
              groupValue: selectedReceipt,
              onChanged: (value) {
                setState(() {
                  selectedReceipt = value;
                });
              },
            );
          })
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
        onPressed: () {
          setState(() {
            _isVisible = false;
          });
          myController.clear();

          multiaadhar.clear();
          multiholder.clear();
          multicif.clear();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CashWithdrawal()),
          );
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
          amountText.clear()
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
  //   print("Reached writeContent");
  //   // final file=await _localFile;
  //   // file.writeAsStringSync('');
  //   Directory directory = Directory('$cachepath');
  //   final file=await  File('$cachepath/withdrawlAcctDetails.txt');
  //   String text='{"2":"${myController.text}","3":"820000","11":"${GenerateRandomString().randomString()}","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        60001700${myController.text}","123":"SDP"}';
  //   print(" fetch account details text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptfetchaccdetails() async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached writeContent");
    // final file=await _localFile;

    Directory directory = Directory('$cachepath');

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
    print(" fetch account details text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Cash withdrawal acc details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchsigndetails() async {
  //  print("Signature writeContent");
  //  print(rec![0]);
  //  final file=await File('$cachepath/fetchAccountDetails.txt');
  //  file.writeAsStringSync('');
  //  String text='{"m_ServiceReqId":"signatureInquiry","m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_CustID":"${rec![0]}","responseParams":"returnedSignature"}';
  //  print(" signature text");
  //  print(text);
  //  return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchsigndetails() async {
    String cif;
    cif=_isJointVisible==true?
    selectedReceipt!.replaceAll("CIF ID", "").replaceAll("\n\n","").trim():rec![0];
    print("Signature writeContent");
    print(rec![0]);
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestSign", "postSignXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <postSignXML>\n\n"
        // '{"m_ServiceReqId":"signatureInquiry","m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_CustID":"${rec![0]}","responseParams":"returnedSignature"}\n\n'
        '{"m_ServiceReqId":"signatureInquiry","m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_CustID":"$cif","responseParams":"returnedSignature"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" signature text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Cash Withdrawal Signature ${text.split("\n\n")[1]}");
    // String test = await Newenc.signString(text.trim().toString());
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  // Future<File> fetchwithdrawdetails(String tid) async {
  //   var login=await TBCBS_SOL_DETAILS().select().toList();
  //   print("Reached  Withdraw writeContent");
  //   String tot=amountText.text.padLeft(14,'0');
  //   print(tot);
  //   String padt=tot.padRight(16,'0');
  //   print(padt);
  //   final file=await File('$cachepath/wdl_finalsubmit.txt');
  //   file.writeAsStringSync('');
  //   String text='{"2":"${myController.text}","3":"010000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}';
  //   print(" withdrawal text");
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptfetchwithdrawdetails(String tid) async {
    var login = await TBCBS_SOL_DETAILS().select().toList();
    print("Reached  Withdraw writeContent");
    String tot = amountText.text.padLeft(14, '0');
    print(tot);
    String padt = tot.padRight(16, '0');
    print(padt);
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "requestJson", "jsonInStream");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text = "$bound"
    //     "\nContent-Id: <jsonInStream>\n\n"
    //     '{"2":"${myController.text}","3":"010000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_BY CASH  "}\n\n'
    //     "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
    //     "";
    String text = "$bound"
        "\nContent-Id: <jsonInStream>\n\n"
        '{"2":"${myController.text}","3":"010000","4":"$padt","11":"$tid","12":"${DateTimeDetails().cbsdatetime()}","17":"${DateTimeDetails().cbsdate()}","24":"200","32":"607245","49":"INR","102":"111        ${login[0].SOL_ID}${myController.text}","123":"SDP","126":"${login[0].BO_ID}_${login[0].OPERATOR_ID}_$_flag_trandetails CASH  "}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(" withdrawal text");
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" Cash Withdrawal ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
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
      case "ACC_DEB_FROZEN":
        invalidMessage = "Transaction not allowed for this scheme from device";
        break;
      case "DIFF_DATE":
        invalidMessage =
            "FSI-CBS SOL BOD Date is different from device date.Transaction not allowed";
        break;
      case 'Invalid ACCOUNT':
        invalidMessage =
            'Account Number Entered is Invalid. Please check and try again';
        break;
    }
    return invalidMessage;
  }

  proceedwithwdl() async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    try {
      // var request = http
      //     .Request(
      //     'POST', Uri.parse(
      //     'https://gateway.cept.gov.in:443/cbs/requestJson'));
      // request.files.add(
      //     await http
      //         .MultipartFile
      //         .fromPath(
      //         '',
      //         '$cachepath/wdl_finalsubmit.txt'));
      // request.headers.addAll(headers);

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
      // request.files.add(await http.MultipartFile.fromPath(
      //     'file', '$cachepath/wdl_finalsubmit.txt'));
      request.headers.addAll(headers);
      print("Request Sent: " + request.toString());
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: 65), onTimeout: () {
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
         // List t =
                                              //     resheaders['authorization']!
                                              //         .split(", Signature:");
 String temp = resheaders['authorization']!;
 String decryptSignature = temp;
        String res = await response.stream.bytesToString();
        
        String val = await decryption1(decryptSignature, res);
        if (val == "Verified!") {
          Map a = json.decode(res);
          print(a['JSONResponse']['jsonContent']);
          String data = a['JSONResponse']['jsonContent'];
          depositmain = json.decode(data);
          print(depositmain);
          if (depositmain['Status'] == "SUCCESS") {
            if (depositmain['39'] != "000") {
              await TBCBS_TRAN_DETAILS().select().DEVICE_TRAN_ID.equals(tid).update({
                'STATUS': 'FAILED'
              });
              setState(() {
                _isLoading = false;
              });
              UtilFs1.showToast(depositmain['127'], context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MainHomeScreen(MyCardsScreen(false), 1)),
                  (route) => false);
            } else {
              print(rec![4]);
              var currentDate = DateTimeDetails().onlyDatewithFormat();
              var currentTime = DateTimeDetails().onlyTime();
              var balance = depositmain['48'].split('+')[2];
              balance = int.parse(balance) > 0
                  ? (int.parse(balance) / 100).toStringAsFixed(2).toString()
                  : "0.00";
              var TranID = depositmain['126'].split('_')[0].toString().trim();
              var trandate = depositmain['126'].split('_')[1];
              print(TranID);

              final addCash =  CashTable()
                ..Cash_ID = myController.text
                ..Cash_Date = DateTimeDetails().currentDate()
                ..Cash_Time = DateTimeDetails().onlyTime()
                ..Cash_Type = 'Add'
                ..Cash_Amount = double.parse("-${amountText.text}")
                ..Cash_Description = "SB Withdrawal";
              await addCash.save();
              final addTransaction = TransactionTable()
                ..tranid = TranID
                ..tranDescription = "SB Withdrawal"
                ..tranAmount = double.parse("-${amountText.text}")
                ..tranType = "CBS"
                ..tranDate = DateTimeDetails().currentDate()
                ..tranTime = DateTimeDetails().onlyTime()
                ..valuation = "Add";

              await addTransaction.save();
              // await TBCBS_TRAN_DETAILS()
              //     .select()
              //     .DEVICE_TRAN_ID
              //     .equals(tid)
              //     .update({
              //   'TRANSACTION_ID': '$TranID',
              //   'STATUS': 'SUCCESS'
              // });
              // final tranDelete = await TBCBS_TRAN_DETAILS()
              //     .select()
              //     .TRANSACTION_ID
              //     .equals(TranID)
              //     .delete();
              // final tranDetails = TBCBS_TRAN_DETAILS()
              //   ..TRANSACTION_ID = TranID
              //   ..TRANSACTION_AMT = amountText.text
              //   ..TRAN_DATE = trandate
              //   ..TRAN_TIME = DateTimeDetails().onlyTime()
              //   ..CUST_ACC_NUM = myController.text
              //   ..ACCOUNT_TYPE = rec![4]
              //   ..STATUS=depositmain['Status']
              //   ..REMARKS = "Withdrawal";
              // tranDetails.save();
              await TBCBS_TRAN_DETAILS()
                  .select()
                  .DEVICE_TRAN_ID
                  .equals(tid)
                  .update({'TRANSACTION_ID': '$TranID', 'STATUS': 'SUCCESS'});
              cbsDetails = await TBCBS_TRAN_DETAILS()
                  .select()
                  .TRANSACTION_ID
                  .equals(TranID)
                  .toList();
              for (int i = 0; i < cbsDetails.length; i++) {
                print(cbsDetails[i].toMap());
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CashWithdrawlAmount(
                          cbsDetails[0].TRANSACTION_ID,
                          amountText.text,
                          currentDate,
                          currentTime,
                          cbsDetails[0].CUST_ACC_NUM,
                          cbsDetails[0].ACCOUNT_TYPE,
                          'Withdrawal',
                          balance,cbsDetails[0].REMARKS)));
            }
          }
        } else {
          UtilFsNav.showToast("Signature Verification Failed! Try Again",
              context, CashWithdrawal());
          await LogCat().writeContent(
              'Cash withdrawal Screen: Signature Verification Failed.');
        }
      } else {

        //  UtilFs.showToast("${await response.stream.bytesToString()}", context);
        print(response.statusCode);
        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
        if(response.statusCode==503 || response.statusCode==504){
          UtilFsNav.showToast("CBS "+error[0].Description.toString(), context,CashWithdrawal());
        }
        else
          UtilFsNav.showToast(error[0].Description.toString(), context,CashWithdrawal());

        // UtilFsNav.showToast(response.reasonPhrase!, context, CashWithdrawal());
        // print(response.reasonPhrase);
      }
    } catch (_) {
      if (_.toString() == "TIMEOUT") {
        return UtilFsNav.showToast(
            "Request Timed Out", context, CashWithdrawal());
      }
    }
  }
}
