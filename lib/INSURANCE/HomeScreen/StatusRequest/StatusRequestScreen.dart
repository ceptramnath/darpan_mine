import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../HomeScreen.dart';
import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import '../HomeScreen.dart';
import 'StatusScreen.dart';

class StatusRequestScreen extends StatefulWidget {
  @override
  _StatusRequestScreenState createState() => _StatusRequestScreenState();
}

class _StatusRequestScreenState extends State<StatusRequestScreen> {
  List<String> _options = ['Proposal Status', 'Claim Status'];
  String _selectedService = 'Proposal Status';
  List<IconData> _icons = [
    Icons.flag,
    Icons.stop,
  ];
  bool datavisible=false;
  int _selectedIndex = 0;
  late Directory d;
  late String cachepath;
  TextEditingController propno = TextEditingController();
  TextEditingController policyno = TextEditingController();
  Map policyMain = {};
  Map main = {};
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
            backgroundColor: ColorConstants.kPrimaryColor,
            title: Text("Status Request"),
          ),
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Status request Type",
                              style: TextStyle(
                                  color: Colors.blueGrey[300], fontSize: 18),
                            )),
                      ),
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
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 35.0),
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
                                datavisible=false;
                                propno.clear();
                                policyno.clear();
                              });
                            },
                            items: _options
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
                    if (_selectedService == "Proposal Status")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   controller: propno,
                            //   decoration: InputDecoration(
                            //     labelText: "Proposal Number",
                            //     hintStyle: TextStyle(fontSize: 15,
                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                            //     border: InputBorder.none,
                            //
                            //     enabledBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.blueGrey,width: 3)
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.green,width: 3)
                            //     ),
                            //
                            //     contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * .95,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90.0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.5, left: 15.0),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: propno,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Proposal Number",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                child: Text("Submit",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                style: ButtonStyle(
                                    // elevation:MaterialStateProperty.all(),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.red)))),
                                onPressed: () async {
                                     List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
                                  FocusScope.of(context).unfocus();
                                  // if (propno.text.length > 0) {
                                  //   encheader =
                                  //       await encryptwriteDummyContent();
                                  //   try {
                                  //     // var headers = {
                                  //     //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                  //     // };
                                  //     // var request = http.Request(
                                  //     //     'POST', Uri.parse(
                                  //     //     'https://gateway.cept.gov.in:443/pli/getProposalDetails'));
                                  //     // request.files.add(
                                  //     //     await http.MultipartFile.fromPath('',
                                  //     //         '$cachepath/fetchAccountDetails.txt'));
                                  //     // request.headers.addAll(headers);
                                  //     // // print("request: ");
                                  //     // // print(request);
                                  //     // http
                                  //     //     .StreamedResponse response = await request
                                  //     //     .send();
                                  //     var headers = {
                                  //       'Signature': '$encheader',
                                  //       'Uri': 'getProposalDetails',
                                  //       'Authorization':
                                  //           'Bearer ${acctoken[0].AccessToken}',
                                  //       'Cookie':
                                  //           'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                  //     };
                                  //
                                  //     var request = http.Request(
                                  //         'POST',
                                  //         Uri.parse(APIEndPoints().insURL));
                                  //     request.files.add(
                                  //         await http.MultipartFile.fromPath(
                                  //             'file',
                                  //             '$cachepath/fetchAccountDetails.txt'));
                                  //     request.headers.addAll(headers);
                                  //     http.StreamedResponse response =
                                  //         await request.send().timeout(
                                  //             const Duration(seconds: 65),
                                  //             onTimeout: () {
                                  //       // return UtilFs.showToast('The request Timeout',context);
                                  //       setState(() {
                                  //         _isLoading = false;
                                  //       });
                                  //       throw 'TIMEOUT';
                                  //     });
                                  //
                                  //     if (response.statusCode == 200) {
                                  //       // print(await response.stream.bytesToString());
                                  //
                                  //       var resheaders = response.headers;
                                  //       print("Response Headers");
                                  //       print(resheaders['authorization']);
                                  //       List t = resheaders['authorization']!
                                  //           .split(", Signature:");
                                  //       String decryptSignature =
                                  //           await decryptHeader(t[1]);
                                  //       String res = await response.stream
                                  //           .bytesToString();
                                  //       print(res);
                                  //       String val = await decryption1(
                                  //           decryptSignature, res);
                                  //
                                  //       if (val == "Verified!") {
                                  //         print(res);
                                  //         print("\n\n");
                                  //         Map a = json.decode(res);
                                  //         print("Map a: $a");
                                  //         print(
                                  //             a['JSONResponse']['jsonContent']);
                                  //         String data =
                                  //             a['JSONResponse']['jsonContent'];
                                  //         policyMain = json.decode(data);
                                  //         print("Values");
                                  //         print(policyMain['renewalAmount']);
                                  //         // Map data=json.decode(a);
                                  //         // print("JSON: ${data}");
                                  //         if (policyMain['Status'] ==
                                  //             "FAILURE") {
                                  //           UtilFs.showToast(
                                  //               "${policyMain['errorMsg']}", context);
                                  //         }
                                  //
                                  //
                                  //         else {
                                  //           encheader =
                                  //               await encryptwriteContent();
                                  //           try {
                                  //             // var request = http.Request('POST',
                                  //             //     Uri.parse(
                                  //             //         'https://gateway.cept.gov.in:443/pli/getProposalStatus'));
                                  //             // request.files.add(
                                  //             //     await http.MultipartFile.fromPath('',
                                  //             //         '$cachepath/fetchAccountDetails.txt'));
                                  //             //
                                  //             // http
                                  //             //     .StreamedResponse response = await request
                                  //             //     .send();
                                  //
                                  //             var headers = {
                                  //               'Signature': '$encheader',
                                  //               'Uri': 'getProposalStatus',
                                  //               'Authorization':
                                  //                   'Bearer ${acctoken[0].AccessToken}',
                                  //               'Cookie':
                                  //                   'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                  //             };
                                  //
                                  //             var request =
                                  //                 http.Request(
                                  //                     'POST',
                                  //                     Uri.parse(APIEndPoints()
                                  //                         .insURL));
                                  //             request.files.add(await http
                                  //                     .MultipartFile
                                  //                 .fromPath('file',
                                  //                     '$cachepath/fetchAccountDetails.txt'));
                                  //             request.headers.addAll(headers);
                                  //             http.StreamedResponse response =
                                  //                 await request.send().timeout(
                                  //                     const Duration(
                                  //                         seconds: 65),
                                  //                     onTimeout: () {
                                  //               // return UtilFs.showToast('The request Timeout',context);
                                  //               setState(() {
                                  //                 _isLoading = false;
                                  //               });
                                  //               throw 'TIMEOUT';
                                  //             });
                                  //
                                  //             if (response.statusCode == 200) {
                                  //               // print(await response.stream.bytesToString());
                                  //               var resheaders =
                                  //                   response.headers;
                                  //               print("Response Headers");
                                  //               print(resheaders[
                                  //                   'authorization']);
                                  //               List t =
                                  //                   resheaders['authorization']!
                                  //                       .split(", Signature:");
                                  //               String decryptSignature =
                                  //                   await decryptHeader(t[1]);
                                  //               String res = await response
                                  //                   .stream
                                  //                   .bytesToString();
                                  //               print(res);
                                  //               String val = await decryption1(
                                  //                   decryptSignature, res);
                                  //
                                  //               if (val == "Verified!") {
                                  //                 print(res);
                                  //                 print("\n\n");
                                  //                 Map a = json.decode(res);
                                  //                 print("Map a: $a");
                                  //                 print(a['JSONResponse']
                                  //                     ['jsonContent']);
                                  //                 String data =
                                  //                     a['JSONResponse']
                                  //                         ['jsonContent'];
                                  //                 Map main = json.decode(data);
                                  //                 print(
                                  //                     "Values of main response are:");
                                  //                 print(main);
                                  //                 print(main[
                                  //                         'serviceRequestStatusId']
                                  //                     [1]);
                                  //                 print(
                                  //                     main['serviceRequestType']
                                  //                         [1]);
                                  //                 print(main['serviceRequestId']
                                  //                     [1]);
                                  //                 print(main['stageName'][1]);
                                  //                 print(
                                  //                     main['serviceRequestDate']
                                  //                         [1]);
                                  //                 print(main['proposalNumber']
                                  //                     [1]);
                                  //                 print(main[
                                  //                         'serviceRequestStatus']
                                  //                     [1]);
                                  //                 List dt =
                                  //                     main['serviceRequestDate']
                                  //                             [1]
                                  //                         .toString()
                                  //                         .split("T");
                                  //                 String date = dt[0]
                                  //                     .toString()
                                  //                     .split("-")
                                  //                     .reversed
                                  //                     .join("-");
                                  //                 Navigator.push(
                                  //                     context,
                                  //                     MaterialPageRoute(
                                  //                         builder: (_) => StatusScreen(
                                  //                             propno.text,
                                  //                             "Proposal",
                                  //                             policyMain[
                                  //                                 'customer_id'],
                                  //                             policyMain[
                                  //                                 'full_NAME'],
                                  //                             policyMain[
                                  //                                 'father_name'],
                                  //                             policyMain[
                                  //                                 'husband_NAME'],
                                  //                             '',
                                  //                             '',
                                  //                             policyMain[
                                  //                                     'planned_initial_premium']
                                  //                                 .toString(),
                                  //                             policyMain[
                                  //                                     'planned_initial_premium']
                                  //                                 .toString(),
                                  //                             policyMain[
                                  //                                     'checkin_date']
                                  //                                 .toString(),
                                  //                             policyMain[
                                  //                                     'paidtodate']
                                  //                                 .toString()
                                  //                                 .split('-')
                                  //                                 .reversed
                                  //                                 .join('-'),
                                  //                             policyMain[
                                  //                                 'product_name'],
                                  //                             "",
                                  //                             main['serviceRequestId']
                                  //                                 [1],
                                  //                             main['serviceRequestType']
                                  //                                 [1],
                                  //                             main['serviceRequestStatus']
                                  //                                 [1],
                                  //                             main['stageName']
                                  //                                 [1],
                                  //                             date)));
                                  //               } else {
                                  //                 UtilFs.showToast(
                                  //                     "Signature Verification Failed! Try Again",
                                  //                     context);
                                  //                 await LogCat().writeContent(
                                  //                     '${DateTimeDetails().currentDateTime()} :Status Request screen: Signature Verification Failed.\n\n');
                                  //               }
                                  //             } else {
                                  //                UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                  //             }
                                  //           } catch (_) {
                                  //             if (_.toString() == "TIMEOUT") {
                                  //               return UtilFs.showToast(
                                  //                   "Request Timed Out",
                                  //                   context);
                                  //             } else
                                  //               print(_);
                                  //           }
                                  //         }
                                  //       } else {
                                  //         UtilFs.showToast(
                                  //             "Signature Verification Failed! Try Again",
                                  //             context);
                                  //         await LogCat().writeContent(
                                  //             '${DateTimeDetails().currentDateTime()} :Status Request screen: Signature Verification Failed.\n\n');
                                  //       }
                                  //     }
                                  //   } catch (_) {
                                  //     if (_.toString() == "TIMEOUT") {
                                  //       return UtilFs.showToast(
                                  //           "Request Timed Out", context);
                                  //     } else
                                  //       print(_);
                                  //   }
                                  // }

                                  if (propno.text.length > 0) {
                                    encheader = await encryptwriteContent();
                                    try {
                                      // var request = http.Request('POST',
                                      //     Uri.parse(
                                      //         'https://gateway.cept.gov.in:443/pli/getProposalStatus'));
                                      // request.files.add(
                                      //     await http.MultipartFile.fromPath('',
                                      //         '$cachepath/fetchAccountDetails.txt'));
                                      //
                                      // http
                                      //     .StreamedResponse response = await request
                                      //     .send();

                                      var headers = {
                                        'Signature': '$encheader',
                                        'Uri': 'getProposalStatus',
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
                                          await request.send().timeout(
                                              const Duration(seconds: 65),
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

                                        String res = await response.stream
                                            .bytesToString();
                                        print(res);
                                        String val = await decryption1(
                                            decryptSignature, res);

                                        if (val == "Verified!") {
                                          await LogCat().writeContent(
                                                    '$res');
                                          print(res);
                                          print("\n\n");
                                          Map a = json.decode(res);
                                          print("Map a: $a");
                                          print(
                                              a['JSONResponse']['jsonContent']);
                                          String data =
                                              a['JSONResponse']['jsonContent'];
                                          policyMain = json.decode(data);
                                          Map main = json.decode(data);
                                          print("Values of main response are:");
                                          print(main);
                                          print(main['serviceRequestStatusId']
                                              [1]);
                                          print(main['serviceRequestType'][1]);
                                          print(main['serviceRequestId'][1]);
                                          print(main['stageName'][1]);
                                          print(main['serviceRequestDate'][1]);
                                          print(main['proposalNumber'][1]);
                                          print(
                                              main['serviceRequestStatus'][1]);
                                          List dt = main['serviceRequestDate']
                                                  [1]
                                              .toString()
                                              .split("T");
                                          String date = dt[0]
                                              .toString()
                                              .split("-")
                                              .reversed
                                              .join("-");
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => StatusScreen(
                                          //             propno.text,
                                          //             "Proposal",
                                          //             // policyMain['customer_id'],
                                          //             policyMain['full_NAME'],
                                          //             policyMain['father_name'],
                                          //             policyMain[
                                          //                 'husband_NAME'],
                                          //             '',
                                          //             '',
                                          //             policyMain[
                                          //                     'planned_initial_premium']
                                          //                 .toString(),
                                          //             policyMain[
                                          //                     'planned_initial_premium']
                                          //                 .toString(),
                                          //             policyMain['checkin_date']
                                          //                 .toString(),
                                          //             policyMain['paidtodate']
                                          //                 .toString()
                                          //                 .split('-')
                                          //                 .reversed
                                          //                 .join('-'),
                                          //             policyMain[
                                          //                 'product_name'],
                                          //             "",
                                          //             main['serviceRequestId']
                                          //                 [1],
                                          //             main['serviceRequestType']
                                          //                 [1],
                                          //             main['serviceRequestStatus']
                                          //                 [1],
                                          //             main['stageName'][1],
                                          //             date)));
                                          setState(() {
                                            datavisible=true;
                                          });

                                        } else {
                                          UtilFsNav.showToast(
                                              "Signature Verification Failed! Try Again",
                                              context,
                                              StatusRequestScreen());
                                          await LogCat().writeContent(
                                              'Status Request screen: Signature Verification Failed.');
                                        }
                                      } else {
                                        // UtilFsNav.showToast(
                                        //     "${await response.stream.bytesToString()}",
                                        //     context,
                                        //     StatusRequestScreen());
                                        print(response.statusCode);
                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                        if(response.statusCode==503 || response.statusCode==504){
                                          UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,StatusRequestScreen());
                                        }
                                        else
                                          UtilFsNav.showToast(error[0].Description.toString(), context,StatusRequestScreen());
                                      }
                                    } catch (_) {
                                      if (_.toString() == "TIMEOUT") {
                                        return UtilFsNav.showToast(
                                            "Request Timed Out",
                                            context,
                                            StatusRequestScreen());
                                      } else
                                        print(_);
                                    }
                                  } else
                                    UtilFsNav.showToast(
                                        "Please Enter Proposal No",
                                        context,
                                        StatusRequestScreen());
                                },
                              ),
                            ),
                            datavisible==true?SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child:Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Table(
                                            defaultColumnWidth: IntrinsicColumnWidth(),
                                            border: TableBorder.all(),
                                            children: [
                                              TableRow(children: [
                                                // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Policy Number",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Service Request Type",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Service RequestID",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Service Request Date",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Service Request Status",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "Office Code",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                )
                                              ]),
                                              if (policyMain['serviceRequestType'] is List)
                                                for (int i = 0;
                                                i < policyMain['serviceRequestType'].length;
                                                i++)
                                                  TableRow(children: [
                                                    // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['policyNumber'][i]}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['serviceRequestType'][i]}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['serviceRequestId'][i]}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['serviceRequestDate'][i].toString().split("T")[0].toString().split("-").reversed.join("-")}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['serviceRequestStatus'][i]}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Center(
                                                          child: Text(
                                                            "${policyMain['officeCode'][i]}",
                                                            style: TextStyle(fontSize: 12),
                                                          )),
                                                    )
                                                  ])
                                              else
                                                TableRow(children: [
                                                  // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['policyNumber']}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestType']}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestId']}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestDate'].toString().split("T")[0].toString().split("-").reversed.join("-")}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestStatus']}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['officeCode']}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  )
                                                ])
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                ),
                              ),
                            ):Container()
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   controller: policyno,
                            //   decoration: InputDecoration(
                            //     labelText: "Policy Number",
                            //     hintStyle: TextStyle(fontSize: 15,
                            //       color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                            //     border: InputBorder.none,
                            //
                            //     enabledBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.blueGrey,width: 3)
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: BorderSide(color:Colors.green,width: 3)
                            //     ),
                            //
                            //     contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * .95,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(90.0)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.5, left: 15.0),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
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
                                      labelText: "Policy Number",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                child: Text("Submit",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                style: ButtonStyle(
                                    // elevation:MaterialStateProperty.all(),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.red)))),
                                onPressed: () async {
                                     List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();

                                  FocusScope.of(context).unfocus();
                                  // if (policyno.text.length > 0) {
                                  //   encheader =
                                  //       await encryptwriteDummyContent();
                                  //   try {
                                  //     // var headers = {
                                  //     //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                  //     // };
                                  //     // var request = http.Request(
                                  //     //     'POST', Uri.parse(
                                  //     //     'https://gateway.cept.gov.in:443/pli/searchPolicy'));
                                  //     // request.files.add(
                                  //     //     await http.MultipartFile.fromPath(
                                  //     //         '',
                                  //     //         '$cachepath/fetchAccountDetails.txt'));
                                  //     // request.headers.addAll(headers);
                                  //     // // print("request: ");
                                  //     // // print(request);
                                  //     // http
                                  //     //     .StreamedResponse response = await request
                                  //     //     .send();
                                  //
                                  //     var headers = {
                                  //       'Signature': '$encheader',
                                  //       'Uri': 'searchPolicy',
                                  //       'Authorization':
                                  //           'Bearer ${acctoken[0].AccessToken}',
                                  //       'Cookie':
                                  //           'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                  //     };
                                  //
                                  //     var request = http.Request(
                                  //         'POST',
                                  //         Uri.parse(APIEndPoints().insURL));
                                  //     request.files.add(
                                  //         await http.MultipartFile.fromPath(
                                  //             'file',
                                  //             '$cachepath/fetchAccountDetails.txt'));
                                  //     request.headers.addAll(headers);
                                  //     http.StreamedResponse response =
                                  //         await request.send().timeout(
                                  //             const Duration(seconds: 65),
                                  //             onTimeout: () {
                                  //       // return UtilFs.showToast('The request Timeout',context);
                                  //       setState(() {
                                  //         _isLoading = false;
                                  //       });
                                  //       throw 'TIMEOUT';
                                  //     });
                                  //     if (response.statusCode == 200) {
                                  //       // print(await response.stream.bytesToString());
                                  //       var resheaders = response.headers;
                                  //       print("Response Headers");
                                  //       print(resheaders['authorization']);
                                  //       List t = resheaders['authorization']!
                                  //           .split(", Signature:");
                                  //       String decryptSignature =
                                  //           await decryptHeader(t[1]);
                                  //       String res = await response.stream
                                  //           .bytesToString();
                                  //       print(res);
                                  //       String val = await decryption1(
                                  //           decryptSignature, res);
                                  //       if (val == "Verified!") {
                                  //         print(res);
                                  //         print("\n\n");
                                  //         Map a = json.decode(res);
                                  //         print("Map a: $a");
                                  //         print(
                                  //             a['JSONResponse']['jsonContent']);
                                  //         String data =
                                  //             a['JSONResponse']['jsonContent'];
                                  //         policyMain = json.decode(data);
                                  //         print("Values");
                                  //         print(policyMain['renewalAmount']);
                                  //         // Map data=json.decode(a);
                                  //         // print("JSON: ${data}");
                                  //         if (policyMain['Status'] ==
                                  //             "FAILURE") {
                                  //           UtilFs.showToast(
                                  //               "${policyMain['errorMsg']}", context);
                                  //         } else {
                                  //           encheader =
                                  //               await encryptwriteContent();
                                  //           try {
                                  //             // var request = http
                                  //             //     .Request('POST',
                                  //             //     Uri.parse(
                                  //             //         'https://gateway.cept.gov.in:443/pli/getProposalStatus'));
                                  //             // request.files.add(
                                  //             //     await http.MultipartFile
                                  //             //         .fromPath('',
                                  //             //         '$cachepath/fetchAccountDetails.txt'));
                                  //             //
                                  //             // http
                                  //             //     .StreamedResponse response = await request
                                  //             //     .send();
                                  //             var headers = {
                                  //               'Signature': '$encheader',
                                  //               'Uri': 'getProposalStatus',
                                  //               'Authorization':
                                  //                   'Bearer ${acctoken[0].AccessToken}',
                                  //               'Cookie':
                                  //                   'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9'
                                  //             };
                                  //
                                  //             var request =
                                  //                 http.Request(
                                  //                     'POST',
                                  //                     Uri.parse(APIEndPoints()
                                  //                         .insURL));
                                  //             request.files.add(await http
                                  //                     .MultipartFile
                                  //                 .fromPath('file',
                                  //                     '$cachepath/fetchAccountDetails.txt'));
                                  //             request.headers.addAll(headers);
                                  //             http.StreamedResponse response =
                                  //                 await request.send().timeout(
                                  //                     const Duration(
                                  //                         seconds: 65),
                                  //                     onTimeout: () {
                                  //               // return UtilFs.showToast('The request Timeout',context);
                                  //               setState(() {
                                  //                 _isLoading = false;
                                  //               });
                                  //               throw 'TIMEOUT';
                                  //             });
                                  //
                                  //             if (response.statusCode == 200) {
                                  //               var resheaders =
                                  //                   response.headers;
                                  //               print("Response Headers");
                                  //               print(resheaders[
                                  //                   'authorization']);
                                  //               List t =
                                  //                   resheaders['authorization']!
                                  //                       .split(", Signature:");
                                  //               String decryptSignature =
                                  //                   await decryptHeader(t[1]);
                                  //               String res = await response
                                  //                   .stream
                                  //                   .bytesToString();
                                  //               print(res);
                                  //               String val = await decryption1(
                                  //                   decryptSignature, res);
                                  //
                                  //               if (val == "Verified!") {
                                  //                 print(res);
                                  //                 print("\n\n");
                                  //                 Map a = json.decode(res);
                                  //                 print("Map a: $a");
                                  //                 print(a['JSONResponse']
                                  //                     ['jsonContent']);
                                  //                 String data =
                                  //                     a['JSONResponse']
                                  //                         ['jsonContent'];
                                  //                 main = json.decode(data);
                                  //                 print(
                                  //                     "Values of main response are:");
                                  //                 print(main);
                                  //                 List reslength = main[
                                  //                     'serviceRequestType'];
                                  //                 // List dt=main['serviceRequestDate'].toString().split("T");
                                  //                 String date =
                                  //                     main['serviceRequestDate']
                                  //                             [
                                  //                             reslength.length -
                                  //                                 1]
                                  //                         .toString()
                                  //                         .split("T")[0]
                                  //                         .toString()
                                  //                         .split("-")
                                  //                         .reversed
                                  //                         .join("-");
                                  //                 print(reslength.length);
                                  //                 print(main[
                                  //                         'serviceRequestType']
                                  //                     [reslength.length - 1]);
                                  //                 Navigator.push(
                                  //                     context,
                                  //                     MaterialPageRoute(
                                  //                         builder: (_) => StatusScreen(
                                  //                             policyno.text,
                                  //                             "Policy",
                                  //                             policyMain[
                                  //                                 'NAMEID'],
                                  //                             policyMain[
                                  //                                 'policyname'],
                                  //                             policyMain[
                                  //                                 'father_name'],
                                  //                             policyMain[
                                  //                                 'husband_NAME'],
                                  //                             '',
                                  //                             '',
                                  //                             policyMain[
                                  //                                 'PLANNEDPREMIUM'],
                                  //                             policyMain[
                                  //                                 'PLANNEDPREMIUM'],
                                  //                             policyMain['POLISSDATE']
                                  //                                 .toString()
                                  //                                 .split('-')
                                  //                                 .reversed
                                  //                                 .join('-'),
                                  //                             policyMain[
                                  //                                     'paidtodate']
                                  //                                 .toString()
                                  //                                 .split('-')
                                  //                                 .reversed
                                  //                                 .join('-'),
                                  //                             policyMain[
                                  //                                 'PRODNAME'],
                                  //                             "",
                                  //                             main['serviceRequestId'][
                                  //                                 reslength.length -
                                  //                                     1],
                                  //                             main['serviceRequestType']
                                  //                                 [reslength
                                  //                                         .length -
                                  //                                     1],
                                  //                             main['serviceRequestStatus']
                                  //                                 [reslength
                                  //                                         .length -
                                  //                                     1],
                                  //                             "",
                                  //                             date)));
                                  //               } else {
                                  //                 UtilFs.showToast(
                                  //                     "Signature Verification Failed! Try Again",
                                  //                     context);
                                  //                 await LogCat().writeContent(
                                  //                     '${DateTimeDetails().currentDateTime()} :Status request Screen screen: Signature Verification Failed.\n\n');
                                  //               }
                                  //             } else {
                                  //                UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                  //             }
                                  //           } catch (_) {
                                  //             if (_.toString() == "TIMEOUT") {
                                  //               return UtilFs.showToast(
                                  //                   "Request Timed Out",
                                  //                   context);
                                  //             } else
                                  //               print(_);
                                  //           }
                                  //         }
                                  //       } else {
                                  //         UtilFs.showToast(
                                  //             "Signature Verification Failed! Try Again",
                                  //             context);
                                  //         await LogCat().writeContent(
                                  //             '${DateTimeDetails().currentDateTime()} :Status Request Screen: Signature Verification Failed.\n\n');
                                  //       }
                                  //     } else {
                                  //        UtilFs.showToast("${await response.stream.bytesToString()}", context);
                                  //     }
                                  //   } catch (_) {
                                  //     if (_.toString() == "TIMEOUT") {
                                  //       return UtilFs.showToast(
                                  //           "Request Timed Out", context);
                                  //     } else
                                  //       print(_);
                                  //   }
                                  // }

                                  if (policyno.text.length > 0) {
                                    encheader = await encryptwriteContent();
                                    try {
                                      // var request = http
                                      //     .Request('POST',
                                      //     Uri.parse(
                                      //         'https://gateway.cept.gov.in:443/pli/getProposalStatus'));
                                      // request.files.add(
                                      //     await http.MultipartFile
                                      //         .fromPath('',
                                      //         '$cachepath/fetchAccountDetails.txt'));
                                      //
                                      // http
                                      //     .StreamedResponse response = await request
                                      //     .send();
                                      var headers = {
                                        'Signature': '$encheader',
                                        'Uri': 'getProposalStatus',
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
                                          await request.send().timeout(
                                              const Duration(seconds: 65),
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
                                        // List t = resheaders['authorization']!
                                        //     .split(", Signature:");
                                        String temp = resheaders['authorization']!;
                                        String decryptSignature = temp;

                                        String res = await response.stream
                                            .bytesToString();
                                        print(res);
                                        String val = await decryption1(
                                            decryptSignature, res);

                                        if (val == "Verified!") {
                                          await LogCat().writeContent(
                                                    '$res');
                                          print(res);
                                          print("\n\n");
                                          Map a = json.decode(res);
                                          print("Map a: $a");
                                          print(
                                              a['JSONResponse']['jsonContent']);
                                          String data =
                                              a['JSONResponse']['jsonContent'];
                                          main = json.decode(data);
                                          policyMain = json.decode(data);
                                          print("Values of main response are:");
                                          print(main);
                                          List reslength =
                                              main['serviceRequestType'];
                                          // List dt=main['serviceRequestDate'].toString().split("T");
                                          String date =
                                              main['serviceRequestDate']
                                                      [reslength.length - 1]
                                                  .toString()
                                                  .split("T")[0]
                                                  .toString()
                                                  .split("-")
                                                  .reversed
                                                  .join("-");
                                          print(reslength.length);
                                          print(main['serviceRequestType']
                                              [reslength.length - 1]);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => StatusScreen(
                                          //             policyno.text,
                                          //             "Policy",
                                          //             // policyMain['NAMEID'],
                                          //             policyMain['policyname'],
                                          //             policyMain['father_name'],
                                          //             policyMain[
                                          //                 'husband_NAME'],
                                          //             '',
                                          //             '',
                                          //             policyMain[
                                          //                 'PLANNEDPREMIUM'],
                                          //             policyMain[
                                          //                 'PLANNEDPREMIUM'],
                                          //             policyMain['POLISSDATE']
                                          //                 .toString()
                                          //                 .split('-')
                                          //                 .reversed
                                          //                 .join('-'),
                                          //             policyMain['paidtodate']
                                          //                 .toString()
                                          //                 .split('-')
                                          //                 .reversed
                                          //                 .join('-'),
                                          //             policyMain['PRODNAME'],
                                          //             "",
                                          //             main['serviceRequestId'][
                                          //                 reslength.length - 1],
                                          //             main['serviceRequestType']
                                          //                 [
                                          //                 reslength.length - 1],
                                          //             main['serviceRequestStatus']
                                          //                 [
                                          //                 reslength.length - 1],
                                          //             "",
                                          //             date)));
                                          setState(() {
                                            datavisible=true;
                                          });

                                        } else {
                                          UtilFsNav.showToast(
                                              "Signature Verification Failed! Try Again",
                                              context,
                                              StatusRequestScreen());
                                          await LogCat().writeContent(
                                              'Status request Screen screen: Signature Verification Failed.');
                                        }
                                      } else {
                                        // UtilFsNav.showToast(
                                        //     "${await response.stream.bytesToString()}",
                                        //     context,
                                        //     StatusRequestScreen());

                                        print(response.statusCode);
                                        List<API_Error_code> error = await API_Error_code().select().API_Err_code.equals(response.statusCode).toList();
                                        if(response.statusCode==503 || response.statusCode==504){
                                          UtilFsNav.showToast("Insurance "+error[0].Description.toString(), context,StatusRequestScreen());
                                        }
                                        else
                                          UtilFsNav.showToast(error[0].Description.toString(), context,StatusRequestScreen());
                                      }
                                    } catch (_) {
                                      if (_.toString() == "TIMEOUT") {
                                        return UtilFsNav.showToast(
                                            "Request Timed Out",
                                            context,
                                            StatusRequestScreen());
                                      } else
                                        print(_);
                                    }
                                  } else
                                    UtilFsNav.showToast(
                                        "Please Enter Policy No",
                                        context,
                                        StatusRequestScreen());
                                },
                              ),
                            ),
                            datavisible==true?SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child:Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Table(
                                          defaultColumnWidth: IntrinsicColumnWidth(),
                                          border: TableBorder.all(),
                                          children: [
                                            TableRow(children: [
                                              // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Policy Number",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Service Request Type",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Service RequestID",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Service Request Date",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Service Request Status",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Text(
                                                      "Office Code",
                                                      style: TextStyle(fontSize: 12),
                                                    )),
                                              )
                                            ]),
                                            if (policyMain['serviceRequestType'] is List)
                                              for (int i = 0;
                                              i < policyMain['serviceRequestType'].length;
                                              i++)
                                                TableRow(children: [
                                                  // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['policyNumber'][i]}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestType'][i]}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestId'][i]}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestDate'][i].toString().split("T")[0].toString().split("-").reversed.join("-")}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['serviceRequestStatus'][i]}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Center(
                                                        child: Text(
                                                          "${policyMain['officeCode'][i]}",
                                                          style: TextStyle(fontSize: 12),
                                                        )),
                                                  )
                                                ])
else
                                              TableRow(children: [
                                                // Row(children:[Text("S.No."),Text("A/c No"),Text("Type"),Text("Amount"),Text("Status")]),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['policyNumber']}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['serviceRequestType']}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['serviceRequestId']}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['serviceRequestDate'].toString().split("T")[0].toString().split("-").reversed.join("-")}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['serviceRequestStatus']}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                        "${policyMain['officeCode']}",
                                                        style: TextStyle(fontSize: 12),
                                                      )),
                                                )
                                              ])
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ),
                              ),
                            ):Container()


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
        ));
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
  }

  //
  // writeDummyContent() async{
  //   var login=await USERDETAILS().select().toList();
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //   String req;
  //   String text;
  //   String reqID;
  //   _selectedService=="Proposal Status"? req=propno.text:req=policyno.text;
  //   // _selectedService=="Proposal Status"? reqID="fetchProposalStatusReq":reqID="fetchPolicyStatusReq";
  //   file.writeAsStringSync('');
  //   // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO11302127002","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   _selectedService=="Proposal Status"?text='{"proposal_number":"$req"}':
  //   text='{"m_policyNo":"$req","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  // Future<String> encryptwriteDummyContent() async {
  //   var login = await USERDETAILS().select().toList();
  //   final file =
  //       await File('$cachepath/fetchAccountDetails.txt');
  //   String req;
  //   String text;
  //   String reqID;
  //   _selectedService == "Proposal Status"
  //       ? req = propno.text
  //       : req = policyno.text;
  //   // _selectedService=="Proposal Status"? reqID="fetchProposalStatusReq":reqID="fetchPolicyStatusReq";
  //   file.writeAsStringSync('');
  //   // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO11302127002","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //   String? goResponse = await Newenc.tester(
  //       "$cachepath/fetchAccountDetails.txt",
  //       "getProposalDetails",
  //       "requestPremiumXML");
  //   String bound =
  //       goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
  //   _selectedService == "Proposal Status"
  //       ? text = "{"
  //           "$bound"
  //           "\nContent-Id: <requestPremiumXML>\n\n"
  //           '{"proposal_number":"$req"}\n\n'
  //           "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
  //           "\n}"
  //       : text = "{"
  //           "$bound"
  //           "\nContent-Id: <requestPremiumXML>\n\n"
  //           '{"m_policyNo":"$req","m_BoID":"${login[0].BOFacilityID}","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}\n\n'
  //           "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
  //           "\n}";
  //   print(text);
  //   await file.writeAsString(text.trim(), mode: FileMode.append);
  //   print("File Contents: " + text);
  //   String test = await Newenc.signString(text.trim().toString());
  //   print("Signture is: " + test);
  //   return test;
  // }

  // writeContent() async{
  //   final file = await File('$cachepath/fetchAccountDetails.txt');
  //   String req;
  //   String reqID;
  //   _selectedService=="Proposal Status"? req=propno.text:req=policyno.text;
  //   _selectedService=="Proposal Status"? reqID="fetchProposalStatusReq":reqID="fetchPolicyStatusReq";
  //   file.writeAsStringSync('');
  //   // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO11302127002","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
  //  String text='{"m_proposal_policy_number":"${req}","m_ServiceReqId":$reqID,"responseParams":"policyNumber,proposalNumber,officeCode,HOSONAME,serviceRequestId,serviceRequestType,serviceRequestStatus,serviceRequestDate,stageName,serviceRequestStatusId,statusCode"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteContent() async {
    final file = await File('$cachepath/fetchAccountDetails.txt');
    String req;
    String reqID;
    _selectedService == "Proposal Status"
        ? req = propno.text
        : req = policyno.text;
    _selectedService == "Proposal Status"
        ? reqID = "fetchProposalStatusReq"
        : reqID = "fetchPolicyStatusReq";
    file.writeAsStringSync('');
    // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO11302127002","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","isMaturity":"YES","responseParams":"Character_Value,policyname,paidtodate,billtodate,agentid,premiumdueamt,premiumintrest,premiumrebate,balamt,srvtaxtotamt,totalamt,officecode,createdby,Response_No,BO_OFF_CODE,freq,carrid,Gstnumber,maturedate"}';
    String? goResponse = await Newenc.tester("$cachepath/fetchAccountDetails.txt",
        "getProposalStatus", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_proposal_policy_number":"${req}","m_ServiceReqId":"$reqID","responseParams":"policyNumber,proposalNumber,officeCode,HOSONAME,serviceRequestId,serviceRequestType,serviceRequestStatus,serviceRequestDate,stageName,serviceRequestStatusId,statusCode"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Fetch Status ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
