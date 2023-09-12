import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

import 'StatusRequestScreen.dart';

class StatusScreen extends StatefulWidget {
  String number;
  String type;
  String custid;
  String insName;
  String fatName;
  String husName;
  String insCircle;
  String issHO;
  String initprem;
  String instAm;
  String issdate;
  String paidtill;
  String prodName;
  String dupBond;
  String reqId;
  String reqType;
  String reqSt;
  String propSt;
  String reqdttime;

  StatusScreen(
      this.number,
      this.type,
      this.custid,
      this.insName,
      this.fatName,
      this.husName,
      this.insCircle,
      this.issHO,
      this.initprem,
      this.instAm,
      this.issdate,
      this.paidtill,
      this.prodName,
      this.dupBond,
      this.reqId,
      this.reqType,
      this.reqSt,
      this.propSt,
      this.reqdttime);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  TextEditingController policyno = new TextEditingController();
  TextEditingController custid = new TextEditingController();
  TextEditingController insName = new TextEditingController();
  TextEditingController fatName = new TextEditingController();
  TextEditingController husName = new TextEditingController();
  TextEditingController appreceipDate = new TextEditingController();
  TextEditingController issCircle = new TextEditingController();
  TextEditingController issHO = new TextEditingController();
  TextEditingController initPrem = new TextEditingController();
  TextEditingController instAm = new TextEditingController();
  TextEditingController issDate = new TextEditingController();
  TextEditingController paidtill = new TextEditingController();
  TextEditingController prodName = new TextEditingController();
  TextEditingController dupBond = new TextEditingController();
  TextEditingController reqId = new TextEditingController();
  TextEditingController reqType = new TextEditingController();
  TextEditingController reqSt = new TextEditingController();
  TextEditingController propSt = new TextEditingController();
  TextEditingController reqdttim = new TextEditingController();

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
          title: Text("Status"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.type == "Policy")
                Column(
                  children: [
                    Padding(
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: policyno..text = widget.number,
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
                          top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
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
                            controller: custid..text = widget.custid,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Customer ID",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: insName..text = widget.insName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Insurant Name",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issCircle..text = widget.insCircle,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Issue Circle",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issHO..text = widget.issHO,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Issue HO",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: initPrem..text = widget.initprem,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Planned Initial Premium",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: instAm..text = widget.instAm,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Installment Amount",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issDate..text = widget.issdate,
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
                          top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
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
                            controller: paidtill..text = widget.paidtill,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Premium Paid Till",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: prodName..text = widget.prodName,
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0,bottom: 8.0),
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
                    //         controller: dupBond..text = widget.dupBond,
                    //         decoration:  InputDecoration(
                    //           hintStyle: TextStyle(fontSize: 15,
                    //             color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                    //           border: InputBorder.none,
                    //           labelText: "Duplicate bond Issued",
                    //           labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                    //         ),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqId..text = widget.reqId,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request ID",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqType..text = widget.reqType,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Type",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqSt..text = widget.reqSt,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Status",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: propSt..text = widget.propSt,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Proposal Stage",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqdttim..text = widget.reqdttime,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Date Time",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      child: Text("Reset"),
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFCC0000),
                          primary: Colors.white),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StatusRequestScreen()));
                      },
                    )
                  ],
                )
              else
                Column(
                  children: [
                    Padding(
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
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: policyno..text = widget.number,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Proposal Number",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: custid..text = widget.custid,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Customer ID",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: insName..text = widget.insName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Insurant Name",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: fatName..text = widget.fatName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Fathers Name",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: husName..text = widget.husName,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Husbands Name",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: appreceipDate..text = "",
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Application Receipt Date",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issCircle..text = widget.insCircle,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Issue Circle",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issHO..text = widget.issHO,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Issue HO",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: issDate..text = widget.issdate,
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
                          top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
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
                            controller: prodName..text = widget.prodName,
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top:8.0,left: 8.0,right: 8.0,bottom: 8.0),
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
                    //         controller: dupBond..text = widget.dupBond,
                    //         decoration:  InputDecoration(
                    //           hintStyle: TextStyle(fontSize: 15,
                    //             color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
                    //           border: InputBorder.none,
                    //           labelText: "Duplicate bond Issued",
                    //           labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                    //         ),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqId..text = widget.reqId,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request ID",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqType..text = widget.reqType,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Type",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqSt..text = widget.reqSt,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Status",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: propSt..text = widget.propSt,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Proposal Stage",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
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
                          padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500),
                            controller: reqdttim..text = widget.reqdttime,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              labelText: "Request Date Time",
                              labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      child: Text("Reset"),
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFCC0000),
                          primary: Colors.white),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StatusRequestScreen()));
                      },
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StatusRequestScreen()),
        (route) => false);
  }
}
