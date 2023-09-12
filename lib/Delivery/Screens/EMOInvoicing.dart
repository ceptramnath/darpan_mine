import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'DeliveryScreen.dart';
import 'Styles/NeuromorphicBox.dart';
import 'db/ArticleModel.dart';
import 'db/DarpanDBModel.dart';

class EMOInvoicingScreen extends StatefulWidget {
  @override
  _EMOInvoicingScreenState createState() => _EMOInvoicingScreenState();
}

class _EMOInvoicingScreenState extends State<EMOInvoicingScreen> {
  late String barcodeScanRes;
  Future? getDetails;
  List<EMOTable> emoarticles = [];
  List<Delivery> _articlesToDisplay = [];
  List<Delivery> _articles = [];
  List<Delivery> mainArticles = [];
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];
  bool artvisible = true;
  var walletAmount;
  var displayAmount;
  var tempAmount1;

  @override
  void initState() {
    getDetails = getList();
  }

  // db() async {
  //   // await EMOTable().select().delete();
  //   print("Reached DB in EMO");
  //   emoarticles = await EMOTable().select().toList();
  //   print("EMO ARTICLS TABLE: ");
  //   if (emoarticles.length > 0) print(emoarticles[0].artNo);
  //   return emoarticles.length;
  // }

  getList() async {
    walletAmount = await CashService().cashBalance();
    emoarticles.clear();
    mainArticles.clear();
    _articlesToDisplay.clear();
    print("Calling DB");
    print("Reached DB in EMO");
    emoarticles = await EMOTable().select().toList();
    print("EMO ARTICLS TABLE: ");
    if (emoarticles.length > 0) print(emoarticles[0].artNo);
    // return emoarticles.length;

    print(emoarticles.length);
    for (int i = 0; i < emoarticles.length; i++)
    {
      // mainArticles = await Delivery()
      //     .select()
      //     .startBlock
      //     .ART_NUMBER
      //     .equals(emoarticles[i].artNo)
      //     .and
      //     // .invoiceDate.equals(DateTimeDetails().onlyDate())
      //     .invoiced
      //     .equalsOrNull("")
      //     .endBlock
      //     .toList();

      mainArticles = await Delivery()
          .select()
          .startBlock
          .ART_NUMBER
          .equals(emoarticles[i].artNo)
          .and
          .MATNR
          .contains("EMO")
          .endBlock
          .and
          .startBlock
          // .invoiceDate.equals(DateTimeDetails().onlyDate())
          .startBlock
          .invoiced
          .equalsOrNull("")
          .or
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .endBlock
          .or
          .startBlock
          .ART_STATUS
          .equals("G")
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
          .or
          .startBlock
          .REASON_FOR_NONDELIVERY
          .equals(6)
          .and
          .ACTION
          .equals(4)
          .endBlock
          .or
          .startBlock
          .REASON_FOR_NONDELIVERY
          .equals(7)
          .and
          .ACTION
          .equals(4)
          .endBlock
          .endBlock
          .endBlock
          .endBlock
          .endBlock
          .toList();

      // print(mainArticles[i].articleNumber);
      print('<><><><><><');
      print(walletAmount);
      print(mainArticles[0].TOTAL_MONEY!);
      if (mainArticles[0].TOTAL_MONEY! <= walletAmount) {
        _articlesToDisplay.add(mainArticles[0]);
        // _articlesToDisplay.toSet().toList();
      } else {
        _articlesToDisplay.clear();
        await EMOTable()
            .select()
            .artNo
            .equals(mainArticles[0].ART_NUMBER)
            .delete();
        UtilFs.showToast("eMO Value is more than Wallet Amount..!", context);
      }
    }
    _articlesToDisplay = _articlesToDisplay.toSet().toList();
    _articles = _articlesToDisplay;
    print("ArticlesToDisplay:");
    for (int i = 0; i < _articlesToDisplay.length; i++)
      print(_articlesToDisplay[i].ART_NUMBER);

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

    for (int i = 0; i < emoarticles.length; i++) {
      tempAmount1 = walletAmount;
      var tempAmount = walletAmount - _articlesToDisplay[i].TOTAL_MONEY!;
      walletAmount = tempAmount;
      print(walletAmount);
    }
    displayAmount = walletAmount;

    print(_articlesToDisplay.length);
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
          title: Text("EMO Invoicing"),
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: _searchBar(),
                      ),
                      Expanded(
                        flex: 10,
                        child: ListView(
                          children: <Widget>[
                            // const Padding(
                            //   padding: EdgeInsets.only(top: 5),
                            // ),
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
                                    left:
                                        MediaQuery.of(context).size.height > 900
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
                                      child: Visibility(
                                        visible: artvisible,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.80,
                                            child: _articlesToDisplay.length > 0
                                                ? ListView.builder(
                                                    itemCount:
                                                        _articlesToDisplay
                                                                .length +
                                                            1,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return index == 0
                                                          ? Container()
                                                          : _listItem(
                                                              index - 1);
                                                    })
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .mark_email_unread_outlined,
                                                          size: 50.toDouble(),
                                                          color: ColorConstants
                                                              .kTextColor,
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
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFCC0000),
                              border: Border.all(color: Color(0xFFCC000)),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                topLeft: Radius.circular(40.0),
                              )),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Count: ${_articlesToDisplay.length}"),
                              Text("Wallet: ${displayAmount}"),
                            ],
                          )),
                        ),
                      )
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
                      heroTag: Text("Confirm"),
                      elevation: 0.0,
                      child: Icon(MdiIcons.checkAll),
                      backgroundColor: ColorConstants.kPrimaryColor,
                      onPressed: () async {
                        var disp = await CashService().cashBalance();
                        var disp1 = disp - walletAmount;
                        print("disp:$disp,walletAmount:$walletAmount,disp1:$disp1");
                        if (_articlesToDisplay.length == 0) {
                          UtilFs.showToast(
                              "No articles available for Invoicing", context);
                        } else if (disp < walletAmount) {
                          UtilFs.showToast(
                              "There is no sufficient balance available in Wallet..!",
                              context);
                        } else if(disp1==0){
                          UtilFs.showToast(
                              "Please try again..!",
                              context);
                        }
                          else {
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
                                                "Are you sure you want to Invoice ${_articlesToDisplay.length} EMOs  with amount $disp1 ?"),
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
                                                          "invoiced": "Y",
                                                          "MONEY_COLLECTED":
                                                              double.parse(
                                                                  '${_articlesToDisplay[i].TOTAL_MONEY!}'
                                                              ),
                                                          "ART_STATUS":null,
                                                          "IS_COMMUNICATED":null,
                                                          "FILE_NAME":null

                                                        });
                                                        await EMOTable()
                                                            .select()
                                                            .artNo
                                                            .equals(
                                                                _articlesToDisplay[
                                                                        i]
                                                                    .ART_NUMBER)
                                                            .delete();
                                                      }
                                                      final addCash1 =
                                                        CashTable()
                                                            ..Cash_ID =
                                                                "EMO_Invoice_${DateTimeDetails().filetimeformat()}"
                                                            ..Cash_Date =
                                                                DateTimeDetails()
                                                                    .currentDate()
                                                            ..Cash_Time =
                                                                DateTimeDetails()
                                                                    .onlyTime()
                                                            ..Cash_Type = 'Add'
                                                            ..Cash_Amount =
                                                                double.parse(
                                                                    "-$disp1")
                                                            ..Cash_Description =
                                                                "EMO Articles Invoicing";
                                                      await addCash1.save();
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EMOInvoicingScreen()),
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
                      heroTag: Text("Scan"),
                      elevation: 0.0,
                      child: Icon(MdiIcons.barcodeScan),
                      backgroundColor: ColorConstants.kPrimaryColor,
                      onPressed: () async {
                        // barcodeScanRes = await scanner.scan();
                        barcodeScanRes = await Scan().scanBag();
                        print('after Barcode scanner ' + barcodeScanRes);

                        if (barcodeScanRes != "") {
                          // List<Delivery> scannedResponse = await Delivery()
                          //     .select()
                          //     .ART_NUMBER
                          //     .equals(barcodeScanRes)
                          //     .toList();

                          List<Delivery> scannedResponse = await Delivery()
                              .select()
                              .startBlock
                              .ART_NUMBER
                              .equals(barcodeScanRes)
                              .and
                              .MATNR
                              .contains("EMO")
                              .endBlock
                              .and
                              .startBlock
                          // .invoiceDate.equals(DateTimeDetails().onlyDate())
                              .startBlock
                              .invoiced
                              .equalsOrNull("")
                              .or
                              .invoiceDate
                              .equals(DateTimeDetails().currentDate())
                              .endBlock
                              .or
                              .startBlock
                              .ART_STATUS
                              .equals("G")
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
                              .or
                              .startBlock
                              .REASON_FOR_NONDELIVERY
                              .equals(6)
                              .and
                              .ACTION
                              .equals(4)
                              .endBlock
                              .or
                              .startBlock
                              .REASON_FOR_NONDELIVERY
                              .equals(7)
                              .and
                              .ACTION
                              .equals(4)
                              .endBlock
                              .endBlock
                              .endBlock
                              .endBlock
                              .endBlock
                              .toList();



                          walletAmount = await CashService().cashBalance();
                          print("<><><><><><><");
                          print(scannedResponse);
                          // print(scannedResponse[0].TOTAL_MONEY!);
                          if (scannedResponse[0].TOTAL_MONEY! >= walletAmount) {
                            UtilFs.showToast(
                                "eMO amount exceeding or equals to Wallet Amount..!",
                                context);
                          } else {
                            print(scannedResponse.length);

                            if (scannedResponse.length > 0) {
                              setState(() {
                                artvisible = false;
                              });
                              List tempemocheck = await EMOTable()
                                  .select()
                                  .artNo
                                  .equals(barcodeScanRes)
                                  .toList();
                              if (tempemocheck.length == 0) {
                                await EMOTable(artNo: barcodeScanRes).upsert();
                                await getList();
                              } else {
                                UtilFs.showToast(
                                    "Article Already Scanned", context);
                              }
                              setState(() {
                                artvisible = true;
                              });
                            } else {
                              UtilFs.showToast(
                                  "Article is not available", context);
                            }
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
    // _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
    // return Column(
    //   children: [
    //     EMOInvoicingCard(
    //       _articlesToDisplay[index].articleNumber!,
    //       _articlesToDisplay[index].articleType!,
    //       _articlesToDisplay[index].sourcepin!,
    //       _articlesToDisplay[index].receiver!,
    //       _articlesToDisplay[index].invoiceDate!,
    //       _articlesToDisplay[index].invoiceTime!,
    //       _articlesToDisplay[index].addresseeType!,
    //       _articlesToDisplay[index].moneytodeliver!,
    //     ),
    //     Divider(),
    //     Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           RaisedButton.icon(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
    //               color: Colors.white70,
    //               onPressed: () async{
    //
    //                 await ScannedArticle().select().articleNumber.equals(_articlesToDisplay[index].articleNumber).update({"invoicedDate":DateTimeDetails().onlyDate()});
    //                 await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
    //
    //               },
    //               icon: Icon(MdiIcons.check),
    //               label:  Flexible(
    //                 child: Text(
    //                   'Accept',textAlign: TextAlign.center,
    //                   //overflow: TextOverflow.ellipsis,
    //                   style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
    //                 ),
    //               )
    //           ),
    //           RaisedButton.icon(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
    //               color: Colors.white70,
    //               onPressed: () async{
    //
    //                 await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
    //               },
    //               icon: Icon(MdiIcons.cancel),
    //               label:  Flexible(
    //                 child: Text(
    //                   'Reject',textAlign: TextAlign.center,
    //                   //overflow: TextOverflow.ellipsis,
    //                   style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
    //                 ),
    //               )
    //           )
    //         ],),
    //     ),
    //   ],
    // );

    _addressToDisplay[index].SEND_PIN == null
        ? _addressToDisplay[index].SEND_PIN = 110001
        : _addressToDisplay[index].SEND_PIN;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      // padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 1.h),
      child: Container(
        decoration: nCDBox,
        child: Container(
          decoration: nCIBox,
          child: Padding(
            padding:
                EdgeInsets.only(left: 20.0, right: 15, bottom: 10, top: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.barcodeScan,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              child: Container(
                                  child: Text(
                            _articlesToDisplay[index].ART_NUMBER!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black54),
                          ))),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Article Type',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        Text(
                          _articlesToDisplay[index].MATNR!,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Text("Amount to Deliver:"),
                            Text(_articlesToDisplay[index]
                                .TOTAL_MONEY!
                                .toString()),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
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
                                              'Delete Confirmation',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: Colors.blueGrey),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "Are you sure you want to delete ${_articlesToDisplay[index].ART_NUMBER} with amount ${_articlesToDisplay[index].TOTAL_MONEY}?"),
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
                                                      setState(() {
                                                        artvisible = false;
                                                      });
                                                      await EMOTable()
                                                          .select()
                                                          .artNo
                                                          .equals(
                                                              _articlesToDisplay[
                                                                      index]
                                                                  .ART_NUMBER)
                                                          .delete();
                                                      await getList();
                                                      setState(() {
                                                        artvisible = true;
                                                      });
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  EMOInvoicingScreen()),
                                                          (route) => false);
                                                      // setState(() {
                                                      //
                                                      //   artvisible=false;
                                                      // });
                                                      //   await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
                                                      //   tempAmount1=displayAmount;
                                                      //   var tempAmount=tempAmount1+_articlesToDisplay[index].totalMoney!;
                                                      //   displayAmount=tempAmount;
                                                      // setState(() {
                                                      //   artvisible=true;
                                                      // });
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
                        },
                      )
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

  _searchBar() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
                cursorColor: Colors.blueGrey,
                style: TextStyle(color: Colors.blueGrey),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Color(0xFFCFB53B)),
                    ),
                    prefixIcon: Icon(
                      MdiIcons.fileSearch,
                      color: Colors.blueGrey,
                    ),
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    labelText: 'Enter Search text',
                    contentPadding: EdgeInsets.all(15.0),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCFB53B))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFCFB53B)))),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(() {
                    if (text.isNotEmpty) {
                      _articlesToDisplay = _articles.where((article) {
                        var articleTitle = article.ART_NUMBER!.toLowerCase();
                        return articleTitle.contains(text);
                      }).toList();
                    } else
                      _articlesToDisplay = _articles.toList();
                  });
                })),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
