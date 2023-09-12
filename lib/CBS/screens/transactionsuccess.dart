import 'dart:convert';
import 'dart:io';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Utils/Printing.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:path_provider/path_provider.dart';

import '../../HomeScreen.dart';
import '../../LogCat.dart';

class TransSuccess extends StatefulWidget {
  String? TranID;
  String? refNumber;
  String? OAPNum;
  String? amount;
  String? balance;
  String? modeoftran;
  String? operatorID;
  String? trandate;
  String? trantime;
  String? trantype;
  String? tenure;
  String? moop;

  TransSuccess(
      this.TranID,
      this.refNumber,
      this.OAPNum,
      this.amount,
      this.balance,
      this.modeoftran,
      this.operatorID,
      this.trandate,
      this.trantime,
      this.trantype,
      this.tenure,
      this.moop);

  @override
  _TransSuccessState createState() => _TransSuccessState();
}

class _TransSuccessState extends State<TransSuccess> {
  List<OfficeDetail> officedata = [];
  XFile? image;
  late File capturedImagePath;
  String? encheader;
  Future? getData;
  File? _image;
  File? _signimage;
  bool imgVisible = false;
  bool signVisible = false;
  final imagePicker = ImagePicker();
  late Directory d;
  late String cachepath;
  bool _isLoading = false;
  String? signb64;

  // var now = new DateTime.now();
  // var formatter = new DateFormat('yyyy-MM-dd');
  // String? formattedDate;
  // var rng = new Random();
  // var code;
  //
  // void init(){
  //   setState(() {
  //     formattedDate = formatter.format(now);
  //     code = rng. nextInt(900000) + 100000;
  //   });
  // }
  @override
  void initState() {
    getData = getofficedetails();
  }

  getCacheDir() async {
    d = await getTemporaryDirectory();
    cachepath = await d.path.toString();
  }

  getofficedetails() async {
    officedata = await OfficeDetail().select().toList();
    await getCacheDir();
    // print(officedata[0].POCode);
    return officedata.length;
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
    if (widget.trantype == "o" || widget.trantype == "O") {
      widget.trantype = "Account Opening";
    }
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'New A/C Transaction Status',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFFB71C1C),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Transaction submitted successfully',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(border: TableBorder.all(), columnWidths: const {
                    0: FlexColumnWidth(1.1),
                    1: FlexColumnWidth(0.9)
                  }, children: [
                    TableRow(
                      children: [
                        const Text(
                          ' Transaction ID_Date:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.TranID == null
                              ? ""
                              : widget.TranID! + "_\n" + widget.trandate!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Reference Number:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.refNumber == null ? "" : widget.refNumber!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Office Account Number:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.OAPNum == null ? "" : widget.OAPNum!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Amount Deposited:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.amount == null ? "" : widget.amount!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Balance After\n Transaction:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.balance == null
                              ? ""
                              : widget.balance!.toString(),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Mode of Transaction:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.modeoftran == null ? "" : widget.modeoftran!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Operator ID:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.operatorID == null ? "" : widget.operatorID!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Transaction Processing\n Date:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.trandate == null ? "" : widget.trandate!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Transaction Processing\n Time:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.trantime == null ? "" : widget.trantime!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Transaction Type:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.trantype == null ? "" : widget.trantype!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        const Text(
                          ' Tenure:',
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 18),
                        ),
                        Text(
                          widget.tenure == null ? "" : widget.tenure!,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 18),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              child: Text('Capture Photo',
                                  style: TextStyle(fontSize: 18)),
                              color: Color(0xFFB71C1C),
                              //Colors.green,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                getImage();
                              }),
                          RaisedButton(
                              child: Text('Capture Signature',
                                  style: TextStyle(fontSize: 18)),
                              color: Color(0xFFB71C1C),
                              //Colors.green,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                getSignImage();
                              }),
                        ],
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: imgVisible,
                      child: Container(
                          child: _image == null
                              ? const Text('Image Not Selected')
                              : Image.file(_image!)),
                    ),
                    Visibility(
                      visible: signVisible,
                      child: Container(
                          child: _signimage == null
                              ? const Text('Image Not Selected')
                              : Image.file(_signimage!)),
                    ),
                  ],
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)))),
                        onPressed: () async {
                          List<String> basicInformation = <String>[];
                          List<String> Dummy = <String>[];
                          //List<OfficeDetail> office=await OfficeDetail().select().toList();
                          final ofcMaster =
                              await OFCMASTERDATA().select().toList();
                          final trandetails = await TBCBS_TRAN_DETAILS()
                              .select()
                              .TRANSACTION_ID
                              .equals(
                                  widget.TranID == null ? "" : widget.TranID!)
                              .toList();
                          // basicInformation.add('NEW ACCOUNT OPENING');
                          // basicInformation.add(' ');
                          if (trandetails[0].ACCOUNT_TYPE.toString() ==
                              "SBGEN") {
                            basicInformation.add('CSI BO ID');
                            basicInformation
                                .add(ofcMaster[0].BOFacilityID.toString());
                            basicInformation.add('CSI BO Descriprtion');
                            basicInformation
                                .add(ofcMaster[0].BOName.toString());
                            basicInformation.add('Receipt Date & Time');
                            basicInformation
                                .add(DateTimeDetails().onlyExpDateTime());
                            basicInformation.add('SOL ID');
                            basicInformation.add(widget.OAPNum == null
                                ? ""
                                : widget.OAPNum!.toString().substring(0, 8));
                            basicInformation.add('SOL Description');
                            basicInformation
                                .add(ofcMaster[0].AOName.toString());
                            basicInformation.add('Transaction ID_Date:');
                            basicInformation.add(widget.TranID == null
                                ? ""
                                : widget.TranID! + "_" + widget.trandate!);
                            basicInformation.add('Reference Number:');
                            basicInformation.add(widget.refNumber == null
                                ? ""
                                : widget.refNumber!.toString());
                            basicInformation.add('Amount Deposited:');
                            basicInformation.add(widget.amount == null
                                ? ""
                                : widget.amount!.toString());
                            basicInformation.add('Balance After Transaction:');
                            basicInformation.add(widget.balance == null
                                ? ""
                                : widget.balance!.toString());
                            basicInformation.add('Mode of Transaction:');
                            basicInformation.add(widget.modeoftran == null
                                ? ""
                                : widget.modeoftran!.toString());
                            basicInformation.add('Primary Account Holder:');
                            basicInformation.add(
                                trandetails[0].MAIN_HOLDER_NAME.toString());
                          }
                          else if (trandetails[0].ACCOUNT_TYPE.toString() ==
                              "RD") {
                            basicInformation.add('CSI BO ID');
                            basicInformation
                                .add(ofcMaster[0].BOFacilityID.toString());
                            basicInformation.add('CSI BO Descriprtion');
                            basicInformation
                                .add(ofcMaster[0].BOName.toString());
                            basicInformation.add('Receipt Date & Time');
                            basicInformation
                                .add(DateTimeDetails().onlyExpDateTime());
                            basicInformation.add('SOL ID');
                            basicInformation.add(widget.OAPNum == null
                                ? ""
                                : widget.OAPNum!.toString().substring(0, 8));
                            basicInformation.add('SOL Description');
                            basicInformation
                                .add(ofcMaster[0].AOName.toString());
                            basicInformation.add('Transaction ID_Date:');
                            basicInformation.add(widget.TranID == null
                                ? ""
                                : widget.TranID! + "_" + widget.trandate!);
                            basicInformation.add('Reference Number:');
                            basicInformation.add(widget.refNumber == null
                                ? ""
                                : widget.refNumber!.toString());
                            basicInformation.add('Amount Deposited:');
                            basicInformation.add(widget.amount == null
                                ? ""
                                : widget.amount!.toString());
                            basicInformation.add('Balance After Transaction:');
                            basicInformation.add(widget.balance == null
                                ? ""
                                : widget.balance!.toString());
                            basicInformation.add('Mode of Transaction:');
                            basicInformation.add(widget.modeoftran == null
                                ? ""
                                : widget.modeoftran!.toString());
                            basicInformation.add('Installment Amount:');
                            basicInformation
                                .add(trandetails[0].INSTALMENT_AMT.toString());
                            basicInformation.add('Tenure:');
                            basicInformation
                                .add(trandetails[0].TENURE.toString());
                            basicInformation.add('Primary Account Holder:');
                            basicInformation.add(
                                trandetails[0].MAIN_HOLDER_NAME.toString());
                            basicInformation.add('Rebate:');
                            basicInformation
                                .add(trandetails[0].REBATE_AMT.toString());
                            basicInformation.add('Mode of Operation:');
                            basicInformation.add("${widget.moop}");
                          }
                          else if (trandetails[0].ACCOUNT_TYPE.toString() ==
                              "TD") {
                            basicInformation.add('CSI BO ID');
                            basicInformation
                                .add(ofcMaster[0].BOFacilityID.toString());
                            basicInformation.add('CSI BO Descriprtion');
                            basicInformation
                                .add(ofcMaster[0].BOName.toString());
                            basicInformation.add('Receipt Date & Time');
                            basicInformation
                                .add(DateTimeDetails().onlyExpDateTime());
                            basicInformation.add('SOL ID');
                            basicInformation.add(widget.OAPNum == null
                                ? ""
                                : widget.OAPNum!.toString().substring(0, 8));
                            basicInformation.add('SOL Description');
                            basicInformation
                                .add(ofcMaster[0].AOName.toString());
                            basicInformation.add('Transaction ID_Date:');
                            basicInformation.add(widget.TranID == null
                                ? ""
                                : widget.TranID! + "_" + widget.trandate!);
                            basicInformation.add('Reference Number:');
                            basicInformation.add(widget.refNumber == null
                                ? ""
                                : widget.refNumber!.toString());
                            basicInformation.add('Amount Deposited:');
                            basicInformation.add(widget.amount == null
                                ? ""
                                : widget.amount!.toString());
                            basicInformation.add('Balance After Transaction:');
                            basicInformation.add(widget.balance == null
                                ? ""
                                : widget.balance!.toString());
                            basicInformation.add('Mode of Transaction:');
                            basicInformation.add(widget.modeoftran == null
                                ? ""
                                : widget.modeoftran!.toString());
                            basicInformation.add('Primary Account Holder:');
                            basicInformation.add(
                                trandetails[0].MAIN_HOLDER_NAME.toString());
                            basicInformation.add('Tenure:');
                            basicInformation.add(
                                widget.tenure.toString());
                          }
                          else if (trandetails[0].ACCOUNT_TYPE.toString() ==
                              "SSA") {
                            basicInformation.add('CSI BO ID');
                            basicInformation
                                .add(ofcMaster[0].BOFacilityID.toString());
                            basicInformation.add('CSI BO Descriprtion');
                            basicInformation
                                .add(ofcMaster[0].BOName.toString());
                            basicInformation.add('Receipt Date & Time');
                            basicInformation
                                .add(DateTimeDetails().onlyExpDateTime());
                            basicInformation.add('SOL ID');
                            basicInformation.add(widget.OAPNum == null
                                ? ""
                                : widget.OAPNum!.toString().substring(0, 8));
                            basicInformation.add('SOL Description');
                            basicInformation
                                .add(ofcMaster[0].AOName.toString());
                            basicInformation.add('Transaction ID_Date:');
                            basicInformation.add(widget.TranID == null
                                ? ""
                                : widget.TranID! + "_" + widget.trandate!);
                            basicInformation.add('Reference Number:');
                            basicInformation.add(widget.refNumber == null
                                ? ""
                                : widget.refNumber!.toString());
                            basicInformation.add('Amount Deposited:');
                            basicInformation.add(widget.amount == null
                                ? ""
                                : widget.amount!.toString());
                            basicInformation.add('Balance After Transaction:');
                            basicInformation.add(widget.balance == null
                                ? ""
                                : widget.balance!.toString());
                            basicInformation.add('Mode of Transaction:');
                            basicInformation.add(widget.modeoftran == null
                                ? ""
                                : widget.modeoftran!.toString());
                            basicInformation.add('Primary Account Holder:');
                            basicInformation.add(
                                trandetails[0].MAIN_HOLDER_NAME.toString());

                          }
                          Dummy.clear();
                          PrintingTelPO printer = new PrintingTelPO();
                          bool value = await printer.printThroughUsbPrinter(
                              "CBS",
                              "NEW ACCOUNT OPENING-" +
                                  trandetails[0].ACCOUNT_TYPE.toString(),
                              basicInformation,
                              Dummy,
                              1);
                        },
                        child: Text('PRINT', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      TextButton(
                        style: ButtonStyle(
                            // elevation:MaterialStateProperty.all(),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.grey)))),
                        child: Text('BACK', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainHomeScreen(MyCardsScreen(false), 1)),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getSignImage() async {
    imageCache?.clear();
    image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 150,
        maxWidth: 150,
        imageQuality: 90);
    // _capturedImageBytes = await image.readAsBytes();
    File capturedImagePath = File(image!.path);
    if (mounted) {
      setState(() {
        _signimage = capturedImagePath;
        signVisible = true;
      });
      await getCacheDir();
      signb64 = await base64Encode(capturedImagePath.readAsBytesSync());
      await transmit1();
    }
  }

  Future getImage() async {
    imageCache?.clear();
    image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 150,
        maxWidth: 150,
        imageQuality: 90);
    // _capturedImageBytes = await image.readAsBytes();
    capturedImagePath = File(image!.path);
    if (mounted) {
      setState(() {
        _image = capturedImagePath;
        imgVisible = true;
      });
      await getCacheDir();

      signb64 = await base64Encode(capturedImagePath.readAsBytesSync());
      await transmit();
    }
  }

  Future<void> transmit() async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    encheader = await encryption();
    var headers = {
      'Signature': '$encheader',
      'Uri': 'storeImage',
      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
      'Authorization': 'Bearer ${acctoken[0].AccessToken}',
      'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
    };

    final File file = File('$cachepath/fetchAccountDetails.txt');
    String tosendText = await file.readAsString();
    var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
    request.body=tosendText;
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
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> encryption() async {
    var login = await USERDETAILS().select().toList();
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "storeImage", "custImage");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text="$bound""\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";
    // String text="\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"}";

    // String text='{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}';
    String text = "$bound"
        "\nContent-Id: <custImage>\n\n"
        '{"image_name":"${widget.refNumber}_P1.jpg","image_data":"$signb64"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";

    print("selfopenacct\n $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
    // await LogCat().writeContent("${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString()}: New Account Opening Fetch CIF Details ${text.split("\n\n")[1]}");
   LogCat().writeContent(" New Account Image ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }



  Future<void> transmit1() async {


    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().Active.equals(true).toList();
    encheader = await encryption1();
    var headers = {
      'Signature': '$encheader',
      'Uri': 'storeImage',
      // 'Authorization': 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmbEV2eUJsV3p6Q211YkF2UWxFal9SUE1XM013MzVtdG42T0QtQXhRUnZrIn0.eyJleHAiOjE2NTk4NTYwNzEsImlhdCI6MTY1OTg1MjQ3MSwianRpIjoiYzc1M2E2OGUtZmQyNS00YWJlLTk3MGYtMDNlNGZhNDdhOTYwIiwiaXNzIjoiaHR0cDovLzE3Mi4yOC4xMi42NC9hdXRoL3JlYWxtcy9EQVJQQU4iLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZjhkNDk4OTgtZWFiZC00NGZlLThjNjItMGY3Y2JlYTQwMDE3IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiRGFycGFuTG9naW4iLCJzZXNzaW9uX3N0YXRlIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJrZXljbG9hayIsImRlZmF1bHQtcm9sZXMtZGFycGFuIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsInBvc3RncmVzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiYTVjM2U4YjktYjkwYi00ZTk2LTg2MWUtMmUyZThmODc2MzU0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJuYW1lIjoiUm9oaXQgMTAxNzUxNjMiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiIxMDE3NTE2MyIsImdpdmVuX25hbWUiOiJSb2hpdCIsImZhbWlseV9uYW1lIjoiMTAxNzUxNjMifQ.WNsCPzLYEANmqCKYSM5zIeIPvL_lCRQQHb0HnQoS96Kz5CTveLESEtKFQMWTk4-WgLEVd_ef_B_G91KH4RsLAkYM6yrxT_qmxnlPBzQplbBAE9DWMmqxgZHJ9ZEQdC_cxowt1VySf5XQJ-tG0WaMC1UudVaWAzlsz3daL0-anD7yNmbjiKR46cFjAsY0_nB8WaLA6KCEyGJlVHJlrU25fVvKtnD10Met27jOemQs1Qu86WqowKKedcd9R1HDzsBAAOjzhGHb4SqS1wvp78PDkxe8Iw8gJemxTNjSAfCwniQd-OOqDY3FhR_wg8siJcoXxaRTtmcfg3WEpToWYvXwoQ',
      'Authorization': 'Bearer ${acctoken[0].AccessToken}',
      'Cookie': 'JSESSIONID=4EFF9A0AA06AA53F8984006966F26FD9',
    };

    final File file = File('$cachepath/fetchAccountDetails.txt');
    String tosendText = await file.readAsString();
    var request = http.Request('POST', Uri.parse(APIEndPoints().cbsURL));
    request.body=tosendText;
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
    setState(() {
      _isLoading = false;
    });
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> encryption1() async {
    var login = await USERDETAILS().select().toList();
    Directory directory = Directory('$cachepath');
    final file = await File('$cachepath/fetchAccountDetails.txt');
    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "storeImage", "custImage");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    // String text="$bound""\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails().cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"${goResponse.replaceAll("{","").replaceAll("}","").split("\n")[3]}""";
    // String text="\nContent-Id: <postSignXML>\n\n"'{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}\n\n'"}";

    // String text='{"m_ReqUUID":"Req_${DateTimeDetails(). cbsdatetime()}","m_ServiceReqId":"RetCustInqLite","m_CustID":"${cifTextController.text}","responseParams":"Status,Name,KycStatus,IsMinor,IsSuspended,BirthDt"}';
    String text = "$bound"
        "\nContent-Id: <custImage>\n\n"
        '{"image_name":"${widget.refNumber}_S1.jpg","image_data":"$signb64"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";

    print("selfopenacct\n $text");
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent(" New Account Signature ${text.split("\n\n")[1]}");
    // await LogCat().writeContent("${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString()}: New Account Opening Fetch CIF Details ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
