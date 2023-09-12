import 'dart:convert';
import 'dart:io';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:intl/intl.dart';
import 'package:newenc/newenc.dart';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';

import 'package:flutter/cupertino.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../LogCat.dart';
import '../../../CBS/decryptHeader.dart';
import 'ServicesQuoteGenerationScreen.dart';

class PolicyDetailScreen extends StatefulWidget {
  // String insName;
  String service;
  String policyno;
  String dupbonds;
  String issdate;
  String prem;
  String prod;
  String cname;
  String pstatus;
  String pt;
  String custid;

  // PolicyDetailScreen(this.insName,this.service,this.policyno,this.dupbonds,this.issdate,this.prem,this.prod,this.cname,this.pstatus,this.pt,this.custid);
  PolicyDetailScreen(this.service, this.policyno, this.dupbonds, this.issdate,
      this.prem, this.prod, this.cname, this.pstatus, this.pt, this.custid);

  @override
  _PolicyDetailScreenState createState() => _PolicyDetailScreenState();
}

class _PolicyDetailScreenState extends State<PolicyDetailScreen> {
  bool visible = false;
  Map main = {};
  List<String> revivalservice = ["Revival", "Revival Installment"];
  String _selectedService = "Revival";
  TextEditingController installments = TextEditingController();
  TextEditingController policyno = TextEditingController();
  TextEditingController installment = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController insured = TextEditingController();
  TextEditingController custid = TextEditingController();
  TextEditingController prodname = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController paidtill = TextEditingController();
  TextEditingController dupbond = TextEditingController();
  String? encheader;
  bool _isLoading = false;

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
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Policy Details"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: policyno..text = "${widget.policyno}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Policy Number",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: installment..text = "${widget.prem}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Installment Amount(Excl. Tax)",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: status..text = "${widget.pstatus}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Policy Status",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: insured..text = "${widget.cname}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Insured",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: custid..text = "${widget.custid}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "CustomerID",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: prodname..text = "${widget.prod}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Product Name",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: date
                              ..text =
                                  "${widget.issdate.substring(0, 10).split("-").reversed.join("-")}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Issue Date",
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
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: paidtill
                              ..text =
                                  "${widget.pt.substring(0, 10).split("-").reversed.join("-")}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Premium Paid till",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top:15.0,left: 8.0,right: 8.0,bottom: 8.0),
                    //   child: Container(
                    //     width:
                    //     MediaQuery.of(context).size.width *
                    //         .95,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(90.0)),
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(top:0.5,left:15.0),
                    //       child: TextFormField(
                    //         style: TextStyle(fontSize: 18,
                    //             color:Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                    //         controller: custid..text="32803872",
                    //         decoration:  InputDecoration(
                    //           hintStyle: TextStyle(fontSize: 15,
                    //             color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                    //           border: InputBorder.none,
                    //           labelText: "Customer Id",
                    //           labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: dupbond
                              ..text =
                                  "${widget.dupbonds == "0" ? "No" : "Yes"}",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Duplicate Policy Bond Issued",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //                if(widget.service=="Revival/Reinstatement")
                    //                  Padding(
                    //                    padding: const EdgeInsets.all(8.0),
                    //                    child: Column(
                    //                      children: [
                    //                        Container(
                    //                          alignment: Alignment.centerLeft,
                    //                            child: Text("Select Revival Type")),
                    //                        RadioGroup<String>.builder(
                    //                          direction: Axis.horizontal,
                    //                          groupValue: _selectedService,
                    //                          onChanged: (value) => setState(() {
                    //                            _selectedService = value!;
                    //                          }),
                    //                          items: revivalservice,
                    //                          itemBuilder: (item) => RadioButtonBuilder(
                    //                            item,
                    //                          ),
                    //                        ),
                    //                        _selectedService=="Revival"?Container():Container(
                    //                          child: TextFormField(
                    //                            controller: installments..text="7",
                    //                        decoration: InputDecoration(
                    //                        floatingLabelBehavior:FloatingLabelBehavior.always,
                    //                          hintStyle: TextStyle(fontSize: 15,
                    //                            color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                    //                          border: InputBorder.none,
                    //
                    //                          enabledBorder: OutlineInputBorder(
                    //                              borderSide: BorderSide(color:Colors.blueGrey,width: 3)
                    //                          ),
                    //                          focusedBorder: OutlineInputBorder(
                    //                              borderSide: BorderSide(color:Colors.green,width: 3)
                    //                          ),
                    //
                    //                          contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                    //                          labelText: "Number of installments for Revival",
                    //                        ),
                    // ),
                    //                        )
                    //                    ],),
                    //                  ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text(
                            "GET QUOTE",
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
                            if (widget.service == "Surrender") {
                              encheader = await encryptwriteSurrContent();
                              try {
                                // var headers = {
                                //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                                // };
                                // var request = http.Request('POST',
                                //     Uri.parse(
                                //         'https://gateway.cept.gov.in:443/pli/getLSRQuoteDetails'));
                                // request.files.add(
                                //     await http.MultipartFile.fromPath('',
                                //         '$cachepath/fetchAccountDetails.txt'));
                                // request.headers.addAll(headers);
                                //
                                // http.StreamedResponse response = await request
                                //     .send();

                                var headers = {
                                  'Signature': '$encheader',
                                  'Uri': 'getLSRQuoteDetails',
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
                                    print(main['Character_Value']);
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Center(
                                                child: Text("Surrender Quote")),
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Number: "),
                                                            Text(
                                                                "${widget.policyno}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Holder Name:  "),
                                                            Text(
                                                                "${widget.cname}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Paidup Value: "),
                                                            Text(
                                                                "${main['PaidUpValue']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Approx Bonus: "),
                                                            Text(
                                                                "${main['Bonus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Paidup Value + Bonus: "),
                                                            Text(
                                                                "${main['PUVBonus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Surrender Factor: "),
                                                            Text(
                                                                "${main['SurrFactor']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Gross Surrender Amount: "),
                                                            Text(
                                                                "${main['NetAmount']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text("Excess: "),
                                                            Text(
                                                                "${main['ExcessPremium']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "O/S Loan Prinicpal: "),
                                                            Text(
                                                                "${main['LoanPrincipal']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "O/S Loan Interest: "),
                                                            Text(
                                                                "${main['LoanInterest']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20.0,
                                                                8.0,
                                                                8.0,
                                                                8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Surrender Charges: "),
                                                            Text(
                                                                "${main['SurrCharges']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20.0,
                                                                8.0,
                                                                8.0,
                                                                8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Total Bonus: "),
                                                            Text(
                                                                "${main['revbonus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Paidup Value: "),
                                                            Text(
                                                                "${main['PaidUpValue']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Net Surrender Amount: "),
                                                            Text(
                                                                "${main['NetAmount']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Loan Eligiblity: "),
                                                            Text(
                                                                "${main['availableLoanOnPolicy']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child:
                                                            Text("Get Quote"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          UtilFs.showToast(
                                                              "Quote Generated and saved.",
                                                              context);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("PRINT"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () async {
                                                          // print(widget.insName);

                                                          print(
                                                              "Print for Surreneder Quote generation");
                                                          List<String>
                                                              basicInformation =
                                                              <String>[];
                                                          List<String> Dummy =
                                                              <String>[];
                                                          basicInformation
                                                              .clear();
                                                          // List<DAY_TRANSACTION_REPORT> printData= await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(mainProposal['receiptNumber']).toList();
                                                          List<OfficeDetail>
                                                              office =
                                                              await OfficeDetail()
                                                                  .select()
                                                                  .toList();
                                                          List<OFCMASTERDATA>
                                                              userDetails =
                                                              await OFCMASTERDATA()
                                                                  .select()
                                                                  .toList();
                                                          //
                                                          // printData[0].BAL_AMT==null?printData[0].BAL_AMT="0":printData[0].BAL_AMT;
                                                          //
                                                          basicInformation
                                                              .add('CSI BO ID');
                                                          basicInformation.add(
                                                              '${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                                                          basicInformation.add(
                                                              'Transaction Date');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyDate());
                                                          basicInformation.add(
                                                              'Transaction Time');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyTime());
                                                          basicInformation.add(
                                                              'Operator ID & Name');
                                                          basicInformation.add(
                                                              '${userDetails[0].EMPID!}'
                                                              '${userDetails[0].EmployeeName!}');
                                                          // //basicInformation.add('GSTN Id');
                                                          basicInformation.add(
                                                              "---------------");
                                                          basicInformation.add(
                                                              "---------------");
                                                          // //basicInformation.add("${widget.gstnum}");
                                                          basicInformation.add(
                                                              "Surrender Quote Details:");
                                                          basicInformation
                                                              .add("");
                                                          basicInformation.add(
                                                              "Policy Number");
                                                          basicInformation.add(
                                                              "${widget.policyno}");
                                                          basicInformation.add(
                                                              "Insurant Name");
                                                          basicInformation.add(
                                                              "${widget.cname}");
                                                          basicInformation.add(
                                                              "Product Name");
                                                          basicInformation.add(
                                                              "${widget.prod}");
                                                          basicInformation.add(
                                                              "Surrender Value");
                                                          basicInformation.add(
                                                              "${main['NetAmount']}");
                                                          basicInformation.add(
                                                              "Surrender Factor");
                                                          basicInformation.add(
                                                              "${main['SurrFactor']}");
                                                          basicInformation.add(
                                                              "O/S Loan Principal");
                                                          basicInformation.add(
                                                              "${main['LoanPrincipal']}");
                                                          basicInformation.add(
                                                              "O/S Loan Intrest");
                                                          basicInformation.add(
                                                              "${main['LoanInterest']}");
                                                          basicInformation.add(
                                                              "Total Bonus");
                                                          basicInformation.add(
                                                              "${main['revbonus']}");
                                                          basicInformation.add(
                                                              "Loan Eligibility");
                                                          basicInformation.add(
                                                              "${main['availableLoanOnPolicy']}");
                                                          basicInformation.add(
                                                              "Paidup Value");
                                                          basicInformation.add(
                                                              "${main['PaidUpValue']}");
                                                          basicInformation.add(
                                                              "Approx Bonus");
                                                          basicInformation.add(
                                                              "${main['Bonus']}");
                                                          basicInformation.add(
                                                              "Net Surrender Amount");
                                                          basicInformation.add(
                                                              "${main['NetAmount']}");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          print(
                                                              "data for print is :");
                                                          print(
                                                              basicInformation);
                                                          Dummy.clear();

                                                          PrintingTelPO
                                                              printer =
                                                              new PrintingTelPO();
                                                          bool value = await printer
                                                              .printThroughUsbPrinter(
                                                                  "Insurance",
                                                                  "Surrender Quote",
                                                                  basicInformation,
                                                                  Dummy,
                                                                  1);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("RESET"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ServicesQuoteGenerationScreen()));
                                                        },
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    UtilFsNav.showToast(
                                        "Signature Verification Failed! Try Again",
                                        context,
                                        ServicesQuoteGenerationScreen());
                                    await LogCat().writeContent(
                                        'Surrender Quote: Signature Verification Failed');
                                  }
                                } else {
                                  // UtilFsNav.showToast(
                                  //     "${await response.stream.bytesToString()}",
                                  //     context,
                                  //     ServicesQuoteGenerationScreen());
                                  // print(await response.stream.bytesToString());
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
                            } else if (widget.service == "Loan") {
                              encheader = await encryptwriteLoanContent();

                              // var headers = {
                              //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                              // };
                              // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/getLSRQuoteDetails'));
                              // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                              // request.headers.addAll(headers);
                              //
                              // http.StreamedResponse response = await request.send();

                              try {
                                var headers = {
                                  'Signature': '$encheader',
                                  'Uri': 'getLSRQuoteDetails',
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
                                    print(main['POLICYNUMBER']);
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Center(
                                                child: Text(
                                                    "${widget.service} Quote")),
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Number: "),
                                                            Text(
                                                                "${widget.policyno}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Holder Name:  "),
                                                            Text(
                                                                "${widget.cname}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Product Name: "),
                                                            Text(
                                                                "${widget.prod}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Date: "),
                                                            Text(
                                                                "${widget.issdate}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Payment Particulars",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Paidup Value: "),
                                                            Text(
                                                                "${main['paidupvalue']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Approximate Bonus: "),
                                                            Text(
                                                                "${main['totbonus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Paidup Value+Bonus: "),
                                                            Text(
                                                                "${double.parse(main['totbonus']) + double.parse(main['paidupvalue'])}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Maximum Loan:"),
                                                            Text(
                                                                "${main['maxloan']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Minimum Loan:"),
                                                            Text(
                                                                "${main['minloanamt']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Loan Status:"),
                                                            Text(
                                                                "${main['loanstatus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Total Bonus:"),
                                                            Text(
                                                                "${main['totbonus']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Loan Paidup Value:"),
                                                            Text(
                                                                "${main['paidupvalue']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Get Quote",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ButtonStyle(
                                                            // elevation:MaterialStateProperty.all(),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .red)))),
                                                        onPressed: () {
                                                          UtilFs.showToast(
                                                              "Quote Generated and saved.",
                                                              context);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "PRINT",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ButtonStyle(
                                                            // elevation:MaterialStateProperty.all(),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .red)))),
                                                        onPressed: () async {
                                                          // print(widget.insName);
                                                          print(
                                                              "Print for Loan Quote generation");
                                                          List<String>
                                                              basicInformation =
                                                              <String>[];
                                                          List<String> Dummy =
                                                              <String>[];
                                                          basicInformation
                                                              .clear();
                                                          // List<DAY_TRANSACTION_REPORT> printData= await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(mainProposal['receiptNumber']).toList();
                                                          List<OfficeDetail>
                                                              office =
                                                              await OfficeDetail()
                                                                  .select()
                                                                  .toList();
                                                          List<OFCMASTERDATA>
                                                              userDetails =
                                                              await OFCMASTERDATA()
                                                                  .select()
                                                                  .toList();
                                                          //
                                                          // printData[0].BAL_AMT==null?printData[0].BAL_AMT="0":printData[0].BAL_AMT;
                                                          //
                                                          basicInformation
                                                              .add('CSI BO ID');
                                                          basicInformation.add(
                                                              '${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                                                          basicInformation.add(
                                                              'Transaction Date');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyDate());
                                                          basicInformation.add(
                                                              'Transaction Time');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyTime());
                                                          basicInformation.add(
                                                              'Operator ID & Name');
                                                          basicInformation.add(
                                                              '${userDetails[0].EMPID!}'
                                                              '${userDetails[0].EmployeeName!}');
                                                          // //basicInformation.add('GSTN Id');
                                                          basicInformation.add(
                                                              "---------------");
                                                          basicInformation.add(
                                                              "---------------");
                                                          // //basicInformation.add("${widget.gstnum}");
                                                          basicInformation.add(
                                                              "Loan Quote Details:");
                                                          basicInformation
                                                              .add("");
                                                          basicInformation.add(
                                                              "Policy Number");
                                                          basicInformation.add(
                                                              "${widget.policyno}");
                                                          basicInformation.add(
                                                              "Insurant Name");
                                                          basicInformation.add(
                                                              "${widget.cname}");
                                                          basicInformation.add(
                                                              "Product Name");
                                                          basicInformation.add(
                                                              "${widget.prod}");
                                                          basicInformation.add(
                                                              "Loan Status");
                                                          basicInformation.add(
                                                              "${main['loanstatus']}");
                                                          basicInformation.add(
                                                              "Total Bonus");
                                                          basicInformation.add(
                                                              "${main['totbonus']}");
                                                          basicInformation.add(
                                                              "Approx Bonus");
                                                          basicInformation.add(
                                                              "${main['totbonus']}");
                                                          basicInformation.add(
                                                              "Maximum Loan");
                                                          basicInformation.add(
                                                              "${main['maxloan']}");
                                                          basicInformation.add(
                                                              "Minimum Loan");
                                                          basicInformation.add(
                                                              "${main['minloanamt']}");
                                                          basicInformation.add(
                                                              "Loan Paidup Value");
                                                          basicInformation.add(
                                                              "${main['paidupvalue']}");

                                                          // basicInformation.add("O/S Loan Principal");
                                                          // basicInformation.add("${main['LoanPrincipal']}");
                                                          // basicInformation.add("O/S Loan Intrest");
                                                          // basicInformation.add("${main['LoanInterest']}");
                                                          // basicInformation.add("Loan Eligibility");
                                                          // basicInformation.add("${main['availableLoanOnPolicy']}");
                                                          // basicInformation.add("Loan Paidup Value");
                                                          // basicInformation.add("${main['paidupvalue']}");
                                                          //
                                                          // basicInformation.add("Net Surrender Amount");
                                                          // basicInformation.add("${main['NetAmount']}");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          print(
                                                              "data for print is :");
                                                          print(
                                                              basicInformation);
                                                          Dummy.clear();
                                                          PrintingTelPO
                                                              printer =
                                                              new PrintingTelPO();
                                                          bool value = await printer
                                                              .printThroughUsbPrinter(
                                                                  "Insurance",
                                                                  "Loan Quote",
                                                                  basicInformation,
                                                                  Dummy,
                                                                  1);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "RESET",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ButtonStyle(
                                                            // elevation:MaterialStateProperty.all(),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18.0),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .red)))),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ServicesQuoteGenerationScreen()));
                                                        },
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    UtilFsNav.showToast(
                                        "Signature Verification Failed! Try Again",
                                        context,
                                        ServicesQuoteGenerationScreen());
                                    await LogCat().writeContent(
                                        'Fetching Loan Quote: Signature Verification Failed.');
                                  }
                                } else {
                                  // UtilFsNav.showToast(
                                  //     "${await response.stream.bytesToString()}",
                                  //     context,
                                  //     ServicesQuoteGenerationScreen());
                                  print(response.statusCode);
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
                            } else if (widget.service ==
                                "Revival/Reinstatement") {
                              encheader = await encryptwriteRevContent();
                              // var headers = {
                              //   'Content-Type': 'multipart/form-data; boundary="uuid:f4fd84e5-5779-494e-870c-3b0f0d703b96"'
                              // };
                              // var request = http.Request('POST', Uri.parse('https://gateway.cept.gov.in:443/pli/getLSRQuoteDetails'));
                              // request.files.add(await http.MultipartFile.fromPath('', '$cachepath/fetchAccountDetails.txt'));
                              // request.headers.addAll(headers);

                              try {
                                var headers = {
                                  'Signature': '$encheader',
                                  'Uri': 'getLSRQuoteDetails',
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
                                    print(main['Character_Value']);
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            insetPadding: EdgeInsets.all(10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            title: Center(
                                                child: Text(
                                                    "${widget.service} Quote")),
                                            elevation: 0,
                                            backgroundColor: Colors.white,
                                            content: Container(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Number: "),
                                                            Text(
                                                                "${widget.policyno}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Policy Holder Name:  "),
                                                            Text(
                                                                "${widget.cname}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Product Name: "),
                                                            Text(
                                                                "${widget.prod}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Revival Quote Value as on: "),
                                                            Text(
                                                                "${DateTimeDetails().proposalDate()}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Premium Due",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20.0,
                                                                8.0,
                                                                8.0,
                                                                8.0),
                                                        child: Row(
                                                          children: [
                                                            Text("From Date: "),
                                                            Text(
                                                                "${main['fromdate'].toString().split("-").reversed.join("-")}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20.0,
                                                                8.0,
                                                                8.0,
                                                                8.0),
                                                        child: Row(
                                                          children: [
                                                            Text("To Date: "),
                                                            Text(
                                                                "${main['todate'].toString().split("-").reversed.join("-")}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Revival Date valid till: "),
                                                            Text(
                                                                "${main['redate'].toString().split("-").reversed.join("-")}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Total Premium Amount:"),
                                                            Text(
                                                                "${main['reamt']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text("Interest:"),
                                                            Text(
                                                                "${main['reintamt']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text("Charges:"),
                                                            Text(
                                                                "${main['charges']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Revival Amount:"),
                                                            Text(
                                                                "${main['totalamt']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Premium Amount:"),
                                                            Text(
                                                                "${main['premamt']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                                "Amount Payable:"),
                                                            Text(
                                                                "${main['amtpay']}"),
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                        child:
                                                            Text("Get Quote"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          UtilFs.showToast(
                                                              "Quote Generated and saved.",
                                                              context);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("PRINT"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () async {
                                                          // print(widget.insName);
                                                          print(
                                                              "Print for revival Quote generation");
                                                          List<String>
                                                              basicInformation =
                                                              <String>[];
                                                          List<String> Dummy =
                                                              <String>[];
                                                          // List<DAY_TRANSACTION_REPORT> printData= await DAY_TRANSACTION_REPORT().select().RECEIPT_NO.equals(mainProposal['receiptNumber']).toList();
                                                          List<OfficeDetail>
                                                              office =
                                                              await OfficeDetail()
                                                                  .select()
                                                                  .toList();
                                                          List<OFCMASTERDATA>
                                                              userDetails =
                                                              await OFCMASTERDATA()
                                                                  .select()
                                                                  .toList();
                                                          //
                                                          // printData[0].BAL_AMT==null?printData[0].BAL_AMT="0":printData[0].BAL_AMT;
                                                          //
                                                          basicInformation
                                                              .add('CSI BO ID');
                                                          basicInformation.add(
                                                              '${userDetails[0].BOFacilityID}-${office[0].BOOFFICEADDRESS}');
                                                          basicInformation.add(
                                                              'Transaction Date');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyDate());
                                                          basicInformation.add(
                                                              'Transaction Time');
                                                          basicInformation.add(
                                                              DateTimeDetails()
                                                                  .onlyTime());
                                                          basicInformation.add(
                                                              'Operator ID & Name');
                                                          basicInformation.add(
                                                              '${userDetails[0].EMPID!}'
                                                              '${userDetails[0].EmployeeName!}');
                                                          // //basicInformation.add('GSTN Id');
                                                          basicInformation.add(
                                                              "---------------");
                                                          basicInformation.add(
                                                              "---------------");
                                                          // //basicInformation.add("${widget.gstnum}");
                                                          basicInformation.add(
                                                              "Revival Quote Details:");
                                                          basicInformation
                                                              .add("");
                                                          basicInformation.add(
                                                              "Policy Number");
                                                          basicInformation.add(
                                                              "${widget.policyno}");
                                                          basicInformation.add(
                                                              "Insurant Name");
                                                          basicInformation.add(
                                                              "${widget.cname}");
                                                          basicInformation.add(
                                                              "Product Name");
                                                          basicInformation.add(
                                                              "${widget.prod}");
                                                          basicInformation.add(
                                                              "Revival Quote as on ");
                                                          basicInformation.add(
                                                              "${DateTimeDetails().proposalDate()}");
                                                          basicInformation.add(
                                                              "Revival Amount");
                                                          basicInformation.add(
                                                              "${main['totalamt']}");
                                                          basicInformation
                                                              .add("From Date");
                                                          basicInformation.add(
                                                              "${main['fromdate'].toString().split("-").reversed.join("-")}");
                                                          basicInformation
                                                              .add("To Date");
                                                          basicInformation.add(
                                                              "${main['todate'].toString().split("-").reversed.join("-")}");
                                                          basicInformation.add(
                                                              "Revival Validity Date");
                                                          basicInformation.add(
                                                              "${main['redate'].toString().split("-").reversed.join("-")}");
                                                          basicInformation.add(
                                                              "Total Premium Due");
                                                          basicInformation.add(
                                                              "${main['reamt']}");
                                                          basicInformation
                                                              .add("Intrest");
                                                          basicInformation.add(
                                                              "${main['reintamt']}");
                                                          basicInformation
                                                              .add("Charges");
                                                          basicInformation.add(
                                                              "${main['charges']}");
                                                          basicInformation.add(
                                                              "Premium Amount");
                                                          basicInformation.add(
                                                              "${main['premamt']}");
                                                          basicInformation.add(
                                                              "Amount Payable");
                                                          basicInformation.add(
                                                              "${main['amtpay']}");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          // basicInformation.add("Check Lists to be Submitted:");
                                                          // basicInformation.add("");
                                                          print(
                                                              "data for print is :");
                                                          print(
                                                              basicInformation);
                                                          Dummy.clear();
                                                          PrintingTelPO
                                                              printer =
                                                              new PrintingTelPO();
                                                          bool value = await printer
                                                              .printThroughUsbPrinter(
                                                                  "Insurance",
                                                                  "Revival/Reinstatement Quote",
                                                                  basicInformation,
                                                                  Dummy,
                                                                  1);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text("RESET"),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xFFCC0000),
                                                          primary: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      ServicesQuoteGenerationScreen()));
                                                        },
                                                      )
                                                    ]),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    UtilFsNav.showToast(
                                        "Signature Verification Failed! Try Again",
                                        context,
                                        ServicesQuoteGenerationScreen());
                                    await LogCat().writeContent(
                                        'Revival quote screen: Signature Verification Failed');
                                  }
                                } else {
                                  // UtilFsNav.showToast(
                                  //     "${await response.stream.bytesToString()}",
                                  //     context,
                                  //     ServicesQuoteGenerationScreen());
                                  print(response.statusCode);
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
                        TextButton(
                          child: Text("RESET"),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.blue),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ServicesQuoteGenerationScreen()));
                          },
                        )
                      ],
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
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ServicesQuoteGenerationScreen()),
        (route) => false);
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

  //
  // Future<File> writeLoanContent() async {
  //
  //   final file=await _localFile;
  //
  //   file.writeAsStringSync('');
  //   String text='{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchLoanQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"InterestRate,surrval,maxloan,minloanamt,paidupvalue,loanstatus,persuradmis,totbonus,isSecondLoan,Response_No,severity,Character_Value"}';
  //   // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO21303100001","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"getPolicyDetailsFromMView"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  //
  // }

  Future<String> encryptwriteLoanContent() async {
    final file = await _localFile;

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "getLSRQuoteDetails", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchLoanQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"InterestRate,surrval,maxloan,minloanamt,paidupvalue,loanstatus,persuradmis,totbonus,isSecondLoan,Response_No,severity,Character_Value"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    // String text='{"m_policyNo":"${policyno.text}","m_BoID":"BO21303100001","m_Integer_Value":1,"m_ServiceReqId":"fetchpolicyDetailsReq","responseParams":"getPolicyDetailsFromMView"}';
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Loan ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  //
  // Future<File> writeSurrContent() async{
  //   final file =
  //   await File('$cachepath/fetchAccountDetails.txt');
  //
  //   file.writeAsStringSync('');
  //   String text='{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchSurrenderQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"PaidUpValue,Bonus,GrossAmount,LoanPrincipal,LoanInterest,SurrCharges,NetAmount,ExcessPremium,availableLoanOnPolicy,SurrFactor,revbonus,termbonus,PUVBonus,Response_No,severity,Character_Value"}';
  //   print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteSurrContent() async {
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "getLSRQuoteDetails", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchSurrenderQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"PaidUpValue,Bonus,GrossAmount,LoanPrincipal,LoanInterest,SurrCharges,NetAmount,ExcessPremium,availableLoanOnPolicy,SurrFactor,revbonus,termbonus,PUVBonus,Response_No,severity,Character_Value"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Surrender ${text.split("\n\n")[1]}");
   print("Surrender ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }

  //
  // Future<File> writeRevContent() async{
  //   final file =
  //   await File('$cachepath/fetchAccountDetails.txt');
  //
  //   file.writeAsStringSync('');
  //   String text='{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchRevivalQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"CompType,CompAmt,RequiredInd,fromdate,todate,redate,reamt,reintamt,charges,totalamt,premamt,insnum,amtpay,Response_No,severity,Character_Value"}';
  //       print(text);
  //   return file.writeAsString(text, mode: FileMode.append);
  // }

  Future<String> encryptwriteRevContent() async {
    final file = await File('$cachepath/fetchAccountDetails.txt');

    file.writeAsStringSync('');
    String? goResponse = await Newenc.tester(
        "$cachepath/fetchAccountDetails.txt", "getLSRQuoteDetails", "requestPremiumXML");
    String bound =
        goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[0];
    String text = "$bound"
        "\nContent-Id: <requestPremiumXML>\n\n"
        '{"m_policyNo":"${policyno.text}","m_ServiceReqId":"fetchRevivalQuoteDetailsReq","m_effectiveDate":"${DateTimeDetails().onlyDate()}","responseParams":"CompType,CompAmt,RequiredInd,fromdate,todate,redate,reamt,reintamt,charges,totalamt,premamt,insnum,amtpay,Response_No,severity,Character_Value"}\n\n'
        "${goResponse.replaceAll("{", "").replaceAll("}", "").split("\n")[3]}"
        "";
    print(text);
    await file.writeAsString(text.trim(), mode: FileMode.append);
    print("File Contents: " + text);
   LogCat().writeContent("Revival ${text.split("\n\n")[1]}");
    String test = await Newenc.signString(text.trim().toString());
    print("Signture is: " + test);
    return test;
  }
}
