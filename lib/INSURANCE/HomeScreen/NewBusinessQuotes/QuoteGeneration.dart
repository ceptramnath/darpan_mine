import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'NewBusinessQuotes.dart';

class QuoteGeneration extends StatefulWidget {
  String type;
  String ptype;
  String sa;
  String ceasing;
  String monthly;
  String quarterly;
  String halfyearly;
  String yearly;
  String temp;

  QuoteGeneration(this.type, this.ptype, this.sa, this.temp, this.ceasing,
      this.monthly, this.quarterly, this.halfyearly, this.yearly);

  @override
  _QuoteGenerationState createState() => _QuoteGenerationState();
}

class _QuoteGenerationState extends State<QuoteGeneration> {
  TextEditingController sa = TextEditingController();
  TextEditingController aam = TextEditingController();
  TextEditingController mquote = TextEditingController();
  TextEditingController qquote = TextEditingController();
  TextEditingController hquote = TextEditingController();
  TextEditingController yquote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Business Quote"),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   alignment: Alignment.center,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("Quote Generation - PLI QUOTE"),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Quote Generation - ${widget.type} QUOTE",
                      style: TextStyle(
                          color: Colors.blueGrey[300], fontSize: 18),
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "${widget.ptype}",
                      style: TextStyle(
                          color: Colors.blueGrey[300], fontSize: 18),
                    )),
              ),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text("SANTOSH-ENDOWMENT ASSURANCE"),
            //       ],
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 7,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: sa..text = widget.sa,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Sum Assured",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                      child: Divider(
                        thickness: 1.0,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: aam..text = widget.ceasing,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "${widget.temp}",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: sa..text=widget.sa,
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Sum Assured",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: aam..text=widget.ceasing,
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Age at Maturity",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 7,
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 0.5, left: 15.0),
                            child: Container(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                controller: mquote
                                  ..text = " \u{20B9} ${widget.monthly}",
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Monthly Quote",
                                  labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                          child: Divider(
                            thickness: 1.0,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .45,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 0.5, left: 15.0),
                            child: Container(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                controller: qquote
                                  ..text = " \u{20B9} ${widget.quarterly}",
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: InputBorder.none,
                                  labelText: "Quarterly Quote",
                                  labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 2, 40, 86),
                                  fontWeight: FontWeight.w500),
                              controller: hquote
                                ..text = " \u{20B9} ${widget.halfyearly}",
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 2, 40, 86),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                labelText: "Half-Yearly Quote",
                                labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, bottom: 2.0, top: 2.0, right: 8.0),
                        child: Divider(
                          thickness: 1.0,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .45,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(90.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 2, 40, 86),
                                  fontWeight: FontWeight.w500),
                              controller: yquote
                                ..text = " \u{20B9} ${widget.yearly}",
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 2, 40, 86),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                labelText: "Annually Quote",
                                labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),

                    // Padding(
                    //   padding: const EdgeInsets.only(left: 2.0,bottom: 2.0,top:2.0,right:8.0),
                    //   child: Divider(thickness: 1.0,),
                    // ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: mquote..text=" \u{20B9} 3475.00",
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Monthly Quote",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: qquote..text=" \u{20B9} 10405",
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Quarterly Quote",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: hquote..text=" \u{20B9} 20540.00",
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Half-Yearly Quote",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextFormField(
            //     controller: yquote..text=" \u{20B9} 40450.00",
            //     style: TextStyle(color: Colors.blueGrey),
            //     readOnly: true,
            //     decoration: InputDecoration(
            //       labelText: "Annually Quote",
            //       hintStyle: TextStyle(fontSize: 15,
            //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
            //       border: InputBorder.none,
            //
            //       enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color:Colors.green,width: 3)
            //       ),
            //
            //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
            //     ),
            //   ),
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Sum Assured: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("500000"),
            //     ),
            //   ],
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Age at Maturity: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("35"),
            //     ),
            //   ],
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Monthly Quote*: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Rs. 3475.00"),
            //     ),
            //   ],
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Quarterly Quote*: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Rs. 10405.00"),
            //     ),
            //   ],
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Half Yearly Quote*: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Rs. 20540.00"),
            //     ),
            //   ],
            // ),
            // Row(
            //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Annually Quote*: "),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text("Rs. 40450.00"),
            //     ),
            //   ],
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         // Text("** The above premiums mentionedare excluding GST",style: Text,),
            //         RichText(
            //           textAlign: TextAlign.center,
            //           text: TextSpan(children: <TextSpan>[
            //             TextSpan(
            //                 text: "** ",
            //                 style: TextStyle(color: Colors.red)),
            //             TextSpan(
            //                 text: "The above premiums mentioned are excluding GST",
            //                 style: TextStyle(
            //                     color: Colors.blue,
            //                     fontWeight: FontWeight.bold)),
            //           ]),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text("Print",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    List<String> basicInformation = <String>[];
                    List<String> DummyList = <String>[];

                    List<OfficeDetail> office =
                        await OfficeDetail().select().toList();
                    List<OFCMASTERDATA> userDetails =
                        await OFCMASTERDATA().select().toList();

                    basicInformation.add('CSI BO ID');
                    basicInformation.add(
                        '${office[0].BOOFFICECODE}${office[0].BOOFFICEADDRESS}');
                    basicInformation.add('Receipt Date & Time');
                    basicInformation.add(DateTimeDetails().onlyExpDateTime());
                    basicInformation.add('Operator ID & Name');
                    basicInformation.add('${userDetails[0].EMPID!}'
                        '${userDetails[0].EmployeeName!}');
                    basicInformation.add("---------------");
                    basicInformation.add("---------------");
                    basicInformation.add("Sum Assured");
                    basicInformation.add("${widget.sa}");
                    basicInformation.add("Age at Maturity");
                    basicInformation.add("${widget.ceasing}");
                    basicInformation.add("----Monthly Quote----");
                    basicInformation.add("");
                    basicInformation.add("Premium Amount");
                    basicInformation.add("${widget.monthly}");
                    basicInformation.add("----Quarterly Quote----");
                    basicInformation.add("");
                    basicInformation.add("Premium Amount");
                    basicInformation.add("${widget.quarterly}");
                    basicInformation.add("----Half-Yearly Quote----");
                    basicInformation.add("");
                    basicInformation.add("Premium Amount");
                    basicInformation.add("${widget.halfyearly}");
                    basicInformation.add("----Yearly Quote----");
                    basicInformation.add("");
                    basicInformation.add("Premium Amount");
                    basicInformation.add("${widget.yearly}");
                    DummyList.clear();
                    PrintingTelPO printer = new PrintingTelPO();
                    bool value = await printer.printThroughUsbPrinter(
                        "Insurance",
                        "Quote Generation",
                        basicInformation,
                        DummyList,
                        1);
                    // if(value==true){
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (_) =>
                    //               NewBusinessQuotes()));
                    // }
                    // else{
                    //   UtilFs.showToast("Printing Failed, Try Again",context);
                    // }
                  },
                  style: ButtonStyle(
                      // elevation:MaterialStateProperty.all(),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                ),
                TextButton(
                  child: Text("Continue",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  // style: ButtonStyle(
                  //     foregroundColor:
                  //     MaterialStateProperty.all<Color>(
                  //         Color(0xFFCC0000))),
                  style: ButtonStyle(
                      // elevation:MaterialStateProperty.all(),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => NewBusinessQuotes()));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
