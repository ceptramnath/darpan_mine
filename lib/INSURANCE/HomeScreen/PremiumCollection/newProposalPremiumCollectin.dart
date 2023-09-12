import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'PremiumCollection.dart';
import 'ProposalPaymentConfirmation.dart';

class NewProposalPremiumCollection extends StatefulWidget {
  String ProposalNumber;
  String name;
  String date;
  String amount;
  String carr;

  NewProposalPremiumCollection(
      this.ProposalNumber, this.name, this.date, this.amount, this.carr);

  @override
  _NewProposalPremiumCollectionState createState() =>
      _NewProposalPremiumCollectionState();
}

class _NewProposalPremiumCollectionState
    extends State<NewProposalPremiumCollection> {
  TextEditingController installments = new TextEditingController();
  TextEditingController amtotCollect = new TextEditingController();
  TextEditingController totamt = new TextEditingController();
  TextEditingController fromdate =
      new TextEditingController(text: DateTimeDetails().onlyDate());
  TextEditingController todate = new TextEditingController();
  TextEditingController propnumber = new TextEditingController();
  TextEditingController insName = new TextEditingController();
  bool calcbutton = true;
  bool aftercalc = false;
  final _formKey = GlobalKey<FormState>();

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PremiumCollection()),
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
        backgroundColor: Colors.grey[300],
        appBar: AppBar(title: Text("Initial Premium collection")),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Initial Premium",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Premium Details ",
                        textAlign: TextAlign.left,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: propnumber..text = widget.ProposalNumber,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(
                              fontSize: 17,
                              color: //Colors.white,
                                  Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 2, 40, 86),
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            labelText: "Proposal Number",
                            hintText: widget.ProposalNumber,
                            labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: TextFormField(
                        readOnly: true,
                        controller: insName..text = widget.name,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(
                            fontSize: 17,
                            color: //Colors.white,
                                Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                          labelText: "Insured Name",
                          // hintText: widget.name,
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,

                          contentPadding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 20, right: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: TextFormField(
                        readOnly: true,
                        style: const TextStyle(
                            fontSize: 17,
                            color: //Colors.white,
                                Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500),
                        controller: fromdate..text = widget.date,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 20, right: 20),
                          labelText: "Check-in Date",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                controller: totamt..text = widget.amount,
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: //Colors.white,
                                        Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  prefixIcon: const Padding(
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
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 20, right: 20),
                                  labelText: "Total Amount ",
                                  hintText: widget.amount,
                                  labelStyle:
                                      TextStyle(color: Color(0xFFCFB53B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     width:
                        //     MediaQuery.of(context).size.width *
                        //         .95.w,
                        //     decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(90.0)),
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(top:0.5,left:15.0),
                        //       child: TextFormField(
                        //
                        //         controller: amtotCollect,
                        //         validator: (value){
                        //           if(value==null || value.isEmpty){
                        //             return 'Please Enter transaction amount';
                        //           }
                        //           else if(int.parse(totamt.text)<1){
                        //             return 'Enter amount greater than or equal to 1 rupee';
                        //           }
                        //           return null;
                        //         },
                        //
                        //         style:const TextStyle(fontSize: 17,
                        //             color://Colors.white,
                        //             Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                        //         decoration: InputDecoration(
                        //           prefixIcon: const Padding(
                        //             padding: EdgeInsets.only(left: 8),
                        //             child: Icon(
                        //               MdiIcons.currencyInr,
                        //               size: 22,
                        //             ),
                        //           ),
                        //           hintStyle: TextStyle(fontSize: 15.sp,
                        //             color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                        //           border: InputBorder.none,
                        //           contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                        //           labelText: "Enter Amount to be collected",
                        //           labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * .95,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(90.0)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 0.5, left: 15.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Amount to be collected';
                                  } else if (double.parse(value) <
                                      double.parse(totamt.text.toString())) {
                                    return 'Please Enter Amount >= ${totamt.text.toString()}';
                                  }
                                  return null;
                                },
                                controller: amtotCollect,

                                style: const TextStyle(
                                    fontSize: 17,
                                    color: //Colors.white,
                                        Color.fromARGB(255, 2, 40, 86),
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  prefixIcon: const Padding(
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
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      top: 20, bottom: 20, left: 20, right: 20),
                                  labelText: "Amount collected ",
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
                              child: Text("Make Payment"),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              proposalpaymentconfirmation(
                                                  widget.name,
                                                  widget.amount,
                                                  "${double.parse(amtotCollect.text.toString())}",
                                                  widget.ProposalNumber,
                                                  widget.carr,
                                                  widget.name)));
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFFCC0000),
                                primary: Colors.white,
                              )
                              // style: ButtonStyle( foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFCC0000))),
                              ),
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Column(
                  //     children: [
                  //
                  //       // Padding(
                  //       //   padding: const EdgeInsets.all(8.0),
                  //       //   child: Container(
                  //       //     width:
                  //       //     MediaQuery.of(context).size.width *
                  //       //         .95.w,
                  //       //     decoration: BoxDecoration(
                  //       //         color: Colors.white,
                  //       //         borderRadius: BorderRadius.circular(90.0)),
                  //       //     child: Padding(
                  //       //       padding: const EdgeInsets.only(top:0.5,left:15.0),
                  //       //       child: TextFormField(
                  //       //
                  //       //         controller: amtotCollect,
                  //       //         validator: (value){
                  //       //           if(value==null || value.isEmpty){
                  //       //             return 'Please Enter transaction amount';
                  //       //           }
                  //       //           else if(int.parse(totamt.text)<1){
                  //       //             return 'Enter amount greater than or equal to 1 rupee';
                  //       //           }
                  //       //           return null;
                  //       //         },
                  //       //
                  //       //         style:const TextStyle(fontSize: 17,
                  //       //             color://Colors.white,
                  //       //             Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
                  //       //         decoration: InputDecoration(
                  //       //           prefixIcon: const Padding(
                  //       //             padding: EdgeInsets.only(left: 8),
                  //       //             child: Icon(
                  //       //               MdiIcons.currencyInr,
                  //       //               size: 22,
                  //       //             ),
                  //       //           ),
                  //       //           hintStyle: TextStyle(fontSize: 15.sp,
                  //       //             color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                  //       //           border: InputBorder.none,
                  //       //           contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
                  //       //           labelText: "Enter Amount to be collected",
                  //       //           labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                  //       //         ),
                  //       //       ),
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: TextButton(
                  //             child: Text("Make Payment"),
                  //             onPressed: () async{
                  //               if (_formKey.currentState!.validate()) {
                  //                 Navigator.push(context,
                  //                     MaterialPageRoute(builder: (_) =>
                  //                         proposalpaymentconfirmation(
                  //                             "${totamt.text}", widget.ProposalNumber, widget.carr,
                  //                             widget.name)));
                  //               }
                  //             },
                  //             style:TextButton.styleFrom(
                  //               backgroundColor: Color(0xFFCC0000),
                  //               primary: Colors.white,
                  //             )
                  //           // style: ButtonStyle( foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFCC0000))),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
