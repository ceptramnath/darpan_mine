import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DeliveryScreen.dart';
import 'ReportsCard.dart';
import 'db/DarpanDBModel.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // List<ScannedArticle> _articlesToDisplay = [];
  List<Delivery> _articlesToDisplay = [];
  Future? getDetails;
  bool visible = true;
  int _selectedIndex = 0;
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];

  @override
  void initState() {
    getDetails = db();
    super.initState();
  }

  db() async {
    _articlesToDisplay.clear();
    _address.clear();
    _addressToDisplay.clear();
    if (_selectedIndex == 0) {
      // _articlesToDisplay=await ScannedArticle().select().articleType.startsWith("R").and.startBlock.articleStatus.contains("Delivered").or.articleStatus.contains("Non Delivered").and.endBlock.toList();
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .equals("LETTER")
          .and
          .startBlock
          .ART_STATUS
          .contains("D")
          .or
          .ART_STATUS
          .contains("N")
          .and
          .endBlock
          .toList();
    } else if (_selectedIndex == 1) {
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .startBlock
          .ART_STATUS
          .contains("D")
          .or
          .ART_STATUS
          .contains("N")
          .and
          .endBlock
          .toList();
    } else if (_selectedIndex == 2) {
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .contains("MO")
          .and
          .startBlock
          .ART_STATUS
          .contains("D")
          .or
          .ART_STATUS
          .contains("N")
          .and
          .endBlock
          .toList();
    } else if (_selectedIndex == 3) {
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("P")
          .and
          .startBlock
          .ART_STATUS
          .contains("D")
          .or
          .ART_STATUS
          .contains("N")
          .and
          .endBlock
          .toList();
    }
    print("Report articles length: ${_articlesToDisplay.length}");

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
    return _articlesToDisplay.length;
  }

  List<String> _options = ["Register Letter", 'Speed Post', 'EMO', 'Parcel'];

  List<Widget> _buildChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _options.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ChoiceChip(
          label: Text(_options[i]),
          labelStyle: TextStyle(color: Colors.white),
          // avatar: Icon(_icons[i]),
          elevation: 10,
          pressElevation: 5,
          shadowColor: Colors.teal,
          backgroundColor: Colors.blue,
          selectedColor: Color(0xFFCC0000),
          selected: _selectedIndex == i,
          onSelected: (bool value) async {
            setState(() {
              visible = false;
              _selectedIndex = i;
            });
            var val = await db();
            if (val >= 0) {
              setState(() {
                visible = true;
              });
            }
          },
        ),
      );
      chips.add(item);
    }
    return chips;
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
          title: Text("Reports"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 6,
                      direction: Axis.horizontal,
                      children: _buildChips(),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.63,
                child: FutureBuilder(
                    future: getDetails,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                    color: ColorConstants.kTextColor),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SafeArea(
                          child: visible == true
                              ? ListView(
                                  shrinkWrap: true,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 5),
                                    ),
                                    Container(
                                      height: MediaQuery.of(context)
                                                  .orientation ==
                                              Orientation.portrait
                                          ? MediaQuery.of(context).size.height -
                                              125
                                          : MediaQuery.of(context).size.height -
                                              125,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(75),
                                          topRight: Radius.circular(2),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                        .size
                                                        .height >
                                                    900
                                                ? 14
                                                : 14),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(75),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 100),
                                              // padding: EdgeInsets.all(12.0),
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.80,
                                                  child: _articlesToDisplay
                                                              .length >
                                                          0
                                                      ? ListView.builder(
                                                          itemCount:
                                                              _articlesToDisplay
                                                                      .length +
                                                                  1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return index == 0
                                                                ? Container()
                                                                // : _articlesToDisplay[index-1].articleType=="Parcel"?_listItemParcel(index-1):_articlesToDisplay[index-1].articleType=="EMO"?_listItemEMO(index-1):_listItem(index-1);
                                                                //   :Text(_articlesToDisplay[index-1].articleNumber!);
                                                                : _listItemParcel(
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
                                                                size: 50

                                                                    .toDouble(),
                                                                color: ColorConstants
                                                                    .kTextColor,
                                                              ),
                                                              const Text(
                                                                'No Records found',
                                                                style: TextStyle(
                                                                    letterSpacing:
                                                                        2,
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
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  _listItemParcel(index) {
    _articlesToDisplay[index].TOTAL_MONEY == null
        ? _articlesToDisplay[index].TOTAL_MONEY = 0
        : _articlesToDisplay[index].TOTAL_MONEY;
    _articlesToDisplay[index].VPP == null
        ? _articlesToDisplay[index].VPP = "N"
        : _articlesToDisplay[index].VPP = "Y";
    _articlesToDisplay[index].COD == null
        ? _articlesToDisplay[index].COD = "N"
        : _articlesToDisplay[index].COD = "Y";
    // _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
    _addressToDisplay[index].SEND_PIN == null
        ? _addressToDisplay[index].SEND_PIN = 110001
        : _addressToDisplay[index].SEND_PIN;
    print("Entered for parcelCard");
    return ReportCard(
      _articlesToDisplay[index].ART_NUMBER!,
      _articlesToDisplay[index].MATNR!,
      int.parse(_addressToDisplay[index].SEND_PIN!.toString()),
      _addressToDisplay[index].REC_NAME!,
      _articlesToDisplay[index].COD!,
      _articlesToDisplay[index].VPP!,
      _articlesToDisplay[index].MATNR!.contains("MO") &&
              _articlesToDisplay[index].ART_STATUS == "D"
          ? double.parse(_articlesToDisplay[index].TOTAL_MONEY!.toString())
          : double.parse(_articlesToDisplay[index].TOTAL_MONEY!.toString()),
    );
  }
}
