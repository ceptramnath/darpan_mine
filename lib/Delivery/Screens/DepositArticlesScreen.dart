import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zxing_scanner/zxing_scanner.dart' as scanner;

import 'DeliveryScreen.dart';
import 'DepositArticleCard.dart';
import 'db/DarpanDBModel.dart';

class DepositArticleInvoicingScreen extends StatefulWidget {
  @override
  _DepositArticleInvoicingScreenState createState() =>
      _DepositArticleInvoicingScreenState();
}

class _DepositArticleInvoicingScreenState
    extends State<DepositArticleInvoicingScreen> {
  Future? getDetails;
  List<Delivery> _articlesToDisplay = [];
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];
  late String barcodeScanRes;

  @override
  void initState() {
    getDetails = db();
  }

  db() async {
    _articlesToDisplay.clear();
    _address.clear();
    _addressToDisplay.clear();
    print("Entered DB");

    _articlesToDisplay = await Delivery()
        .select()
        .invoiceDate
        .not
        .equals(DateTimeDetails().currentDate())
        .and
        .startBlock
        .MATNR.not.contains("EMO")
        .endBlock
        .and
        .startBlock
        .REASON_FOR_NONDELIVERY
        .equals(35)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(36)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(1)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(8)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(3)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(5)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(15)
        .or.startBlock
        .REASON_FOR_NONDELIVERY
        .equals(6).and.ACTION.equals(4).endBlock
        .or.startBlock
        .REASON_FOR_NONDELIVERY
        .equals(7).and.ACTION.equals(4).endBlock
        .endBlock
        .toList();


    print("Deposit articles length: ${_articlesToDisplay.length}");
    for (int i = 0; i < _articlesToDisplay.length; i++) {
      // print(_articlesToDisplay[i].articleNumber);
      _address = await Addres()
          .select()
          .ART_NUMBER
          .equals(_articlesToDisplay[i].ART_NUMBER)
          .toList();
      // print(_address[0].articleNumber);
      _addressToDisplay.add(_address[0]);
    }
    // print(_addressToDisplay[0].recName);

    return _articlesToDisplay.length;
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DeliveryScreen()),
                (route) => false),
          ),
          title: Text("Deposit Article Invoicing"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: FutureBuilder(
            future: getDetails,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SafeArea(
                  child: ListView(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? MediaQuery.of(context).size.height - 125
                            : MediaQuery.of(context).size.height - 125,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height > 900
                                  ? 14
                                  : 14),
                          child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(75),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.80,
                                    child: _articlesToDisplay.length > 0
                                        ? ListView.builder(
                                            itemCount:
                                                _articlesToDisplay.length + 1,
                                            itemBuilder: (context, index) {
                                              return index == 0
                                                  ? Container()
                                                  : _listItem(index - 1);
                                            })
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .mark_email_unread_outlined,
                                                  size: 50.toDouble(),
                                                  color:
                                                      ColorConstants.kTextColor,
                                                ),
                                                const Text(
                                                  'No Records found',
                                                  style: TextStyle(
                                                      letterSpacing: 2,
                                                      color: ColorConstants
                                                          .kTextColor),
                                                ),
                                              ],
                                            ),
                                          )),
                              )),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 40.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: FloatingActionButton(
                      elevation: 0.0,
                      child: Icon(MdiIcons.checkAll),
                      backgroundColor: ColorConstants.kPrimaryColor,
                      onPressed: () async {
                        if (_articlesToDisplay.length == 0) {
                          UtilFs.showToast(
                              "No articles available for Invoicing", context);
                        } else {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            top: 40,
                                            right: 20,
                                            bottom: 20),
                                        margin: EdgeInsets.only(top: 40),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0, 10),
                                                  blurRadius: 10),
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Invoice Confirmation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Are you sure you want to Invoice ${_articlesToDisplay.length} articles?"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                RaisedButton.icon(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blueGrey)),
                                                    color: Colors.white70,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: Icon(
                                                      MdiIcons
                                                          .emailRemoveOutline,
                                                      color: Color(0xFFd4af37),
                                                    ),
                                                    label: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    )),
                                                RaisedButton.icon(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .blueGrey)),
                                                    color: Colors.white70,
                                                    onPressed: () async {
                                                      for (int i = 0;
                                                          i <
                                                              _articlesToDisplay
                                                                  .length;
                                                          i++) {
                                                        await Delivery()
                                                            .select()
                                                            .ART_NUMBER
                                                            .equals(
                                                                _articlesToDisplay[
                                                                        i]
                                                                    .ART_NUMBER)
                                                            .update({
                                                          "invoiceDate":
                                                              DateTimeDetails()
                                                                  .currentDate(),
                                                          'REASON_FOR_NONDELIVERY':
                                                              null,
                                                          'ART_STATUS': null,'REASON_TYPE':null,'ACTION':null,
                                                        "IS_COMMUNICATED":null,
                                                        "FILE_NAME":null
                                                        });
                                                      }
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DepositArticleInvoicingScreen()),
                                                          (route) => false);
                                                    },
                                                    icon: Icon(
                                                      MdiIcons.emailSendOutline,
                                                      color: Color(0xFFd4af37),
                                                    ),
                                                    label: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blueGrey),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: 20,
                                        right: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 40,
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              child: Image.asset(
                                                "assets/images/ic_arrows.png",
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                  FloatingActionButton(
                      elevation: 0.0,
                      child: Icon(MdiIcons.barcodeScan),
                      backgroundColor: ColorConstants.kPrimaryColor,
                      onPressed: () async {
                        // barcodeScanRes = await scanner.scan();
                        barcodeScanRes=await Scan().scanBag();
                        if (barcodeScanRes != "") {
                          List<Delivery> scannedResponse = await Delivery()
                              .select()
                              .ART_NUMBER
                              .equals(barcodeScanRes)
                              .and
                              .startBlock
                              .MATNR.not.contains("EMO")
                              .endBlock
                              .and
                              .startBlock
                              .REASON_FOR_NONDELIVERY
                              .equals(35)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(36)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(1)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(8)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(3)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(5)
                              .or
                              .REASON_FOR_NONDELIVERY
                              .equals(15)
                              .endBlock
                              .toList();
                          if (scannedResponse.length > 0) {
                          } else {
                            UtilFs.showToast(
                                "Article is not available", context);
                          }
                        }
                      }),
                ])),
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  _listItem(index) {
    _addressToDisplay[index].SEND_PIN == null
        ? _addressToDisplay[index].SEND_PIN = 110001
        : _addressToDisplay[index].SEND_PIN;

    return GestureDetector(
      onTap: () async {},
      child: DepositArticleCard(
        _articlesToDisplay[index].ART_NUMBER!,
        _articlesToDisplay[index].MATNR!,
        _addressToDisplay[index].SEND_PIN! as int,
        _addressToDisplay[index].REC_NAME!,
      ),
    );
  }
}
