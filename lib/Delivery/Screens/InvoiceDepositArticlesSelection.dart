import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'DeliveryScreen.dart';
import 'DepositArticlesScreen.dart';
import 'Styles/NeuromorphicBox.dart';
import 'db/DarpanDBModel.dart';

class InvoiceDepositArticlesScreen extends StatefulWidget {
  @override
  _InvoiceDepositArticlesScreenState createState() => _InvoiceDepositArticlesScreenState();
}

class _InvoiceDepositArticlesScreenState extends State<InvoiceDepositArticlesScreen> {
  int _selectedItems = 0;
  Future? getDetails;
  List<Delivery> _articlesToDisplay = [];
  late String barcodeScanRes;
  List<DepositModel> _depositList = [];

  @override
  void initState() {
    getDetails = fetchDepositArticles();
  }

  fetchDepositArticles() async {
    _depositList.clear();
    _articlesToDisplay.clear();

    _articlesToDisplay = await Delivery()
        .select()
        .invoiceDate
        .not
        .equals(DateTimeDetails().currentDate())
        .and
        .startBlock
        .MATNR.not.contains("EMO")
        .and
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
        .toList();

    print("Deposit articles length: ${_articlesToDisplay.length}");
    for (int i = 0; i < _articlesToDisplay.length; i++) {
      // print(_articlesToDisplay[i].articleNumber);
      _depositList
          .add(DepositModel(i, _articlesToDisplay[i].ART_NUMBER,_articlesToDisplay[i].MATNR, false));
    }
    // print(_addressToDisplay[0].recName);

    return _depositList.length;
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
          title: Text("Invoice Deposit Articles"),
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
                  child: ListView(children: <Widget>[
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
                              height: MediaQuery.of(context).size.height * 0.80,
                              child: _depositList.length > 0
                                  ? ListView.builder(
                                      itemCount: _depositList.length + 1,
                                      itemBuilder: (context, index) {
                                        return index == 0
                                            ? Container()
                                            : _listItem(index - 1);
                                      },
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.mark_email_unread_outlined,
                                            size: 50.toDouble(),
                                            color: ColorConstants.kTextColor,
                                          ),
                                          const Text(
                                            'No Records found',
                                            style: TextStyle(
                                                letterSpacing: 2,
                                                color:
                                                    ColorConstants.kTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
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
                        if (_depositList.length == 0) {
                          UtilFs.showToast(
                              "No articles available for Invoicing", context);
                        } else {
                          for (int i = 0; i < _depositList.length; i++) {
                            if (_depositList[i].isSelected == true) {
                              _selectedItems = _selectedItems + 1;
                            }
                          }
                          //if no article is selected, by default all articles will be invoiced.
                          if (_selectedItems == 0) {
                            // UtilFs.showToast("No articles selected for Invoicing", context);
                            //when no article is selected app will invoice all pending articles by default.
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
                                                  "Are you sure you want to Invoice ALL ${_depositList.length} articles?"),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                        color:
                                                            Color(0xFFd4af37),
                                                      ),
                                                      label: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
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
                                                                _depositList
                                                                    .length;
                                                            i++) {
                                                          await Delivery()
                                                              .select()
                                                              .ART_NUMBER
                                                              .equals(_depositList[
                                                                      i]
                                                                  .ArticleNumber)
                                                              .update({
                                                            "invoiceDate":
                                                                DateTimeDetails()
                                                                    .currentDate(),
                                                            'REASON_FOR_NONDELIVERY':
                                                                null,
                                                            'ART_STATUS': null,
                                                            'REASON_TYPE': null,
                                                            'ACTION': null,
                                                            "IS_COMMUNICATED":null,
                                                            "FILE_NAME":null
                                                          });

                                                        }
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DepositArticleInvoicingScreen()),
                                                            (route) => false);
                                                      },
                                                      icon: Icon(
                                                        MdiIcons
                                                            .emailSendOutline,
                                                        color:
                                                            Color(0xFFd4af37),
                                                      ),
                                                      label: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
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
                                                  "Are you sure you want to Invoice ${_selectedItems} articles?"),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                                                        color:
                                                            Color(0xFFd4af37),
                                                      ),
                                                      label: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
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
                                                        for (int i = 0;i <_depositList.length;i++)
                                                        {
                                                          if (_depositList[i].isSelected ==true)
                                                          {
                                                            await Delivery()
                                                                .select()
                                                                .ART_NUMBER
                                                                .equals(_depositList[i].ArticleNumber)
                                                                .update({
                                                              "invoiceDate":DateTimeDetails().currentDate(),
                                                              'REASON_FOR_NONDELIVERY':null,
                                                              'ART_STATUS':null,
                                                              'REASON_TYPE':null,
                                                              'ACTION': null,
                                                              "IS_COMMUNICATED":null,
                                                              "FILE_NAME":null
                                                            });
                                                          }
                                                        }
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DeliveryScreen()),
                                                            (route) => false);
                                                      },
                                                      icon: Icon(
                                                        MdiIcons
                                                            .emailSendOutline,
                                                        color:
                                                            Color(0xFFd4af37),
                                                      ),
                                                      label: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueGrey),
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
                        }
                      },
                    ),
                  ),
                ])),
      ),
    );
  }

  _listItem(index) {
    return Container(
      child: ListTile(
        title: Container(
            color: _depositList[index].isSelected == true
                ? Colors.blue.withOpacity(0.5)
                : Colors.transparent,
            child: DepositScreen(
              _depositList[index].ArticleNumber!,
              _depositList[index].ArticleType!,
            )),
        onLongPress: () {
          print('Long Press on $index');
        },
        onTap: () {
          print('On tap $index');
          if (_depositList[index].isSelected == true) {
            setState(() {
              _depositList[index].isSelected = false;
            });
          } else if (_depositList[index].isSelected == false) {
            setState(() {
              _depositList[index].isSelected = true;
            });
          }
        },
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  DepositScreen(String ArticleNumber, String ArticleType) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        decoration: nCDBox,
        child: Container(
          decoration: nCIBox,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 15, bottom: 10, top: 10),
            child: Column(
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
                            ArticleNumber,
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
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        Text(
                          ArticleType,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DepositModel {
  int? slno;
  String? ArticleNumber;
  String? ArticleType;
  bool isSelected;

  DepositModel(this.slno, this.ArticleNumber,this.ArticleType, this.isSelected);
}
