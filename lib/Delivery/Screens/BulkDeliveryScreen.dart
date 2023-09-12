import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'BulkDeliveryCard.dart';
import 'DeliveryScreen.dart';
import 'db/DarpanDBModel.dart';

class BulkDeliveryScreen extends StatefulWidget {
  @override
  _BulkDeliveryScreenState createState() => _BulkDeliveryScreenState();
}

class _BulkDeliveryScreenState extends State<BulkDeliveryScreen> {

  List<String> _options = ["Register Letter", 'Speed Post', 'Parcel'];

  List<Delivery> _articlesToDisplay = [];
  Future? getDetails;
  bool visible = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    getDetails = db();
    super.initState();
  }

  db() async {
    _articlesToDisplay.clear();
    final list = await Delivery()
        .select()
        .invoiceDate
        .equals(DateTimeDetails().currentDate())
        .toCount();
    print('Invoiced Count' + list.toString());
    if (_selectedIndex == 0) {
      setState(() {
        _articlesToDisplay.clear();
      });

      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .inValues(["LETTER"])
          .and
          .startBlock
          .ART_STATUS
          .equalsOrNull("")
          .and
          .invoiced
          .equals("Y")
          .endBlock
          .toList();
    }
    else if (_selectedIndex == 1) {
      setState(() {
        _articlesToDisplay.clear();
      });
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .startBlock
          .ART_STATUS
          .equalsOrNull("")
          .and
          .invoiced
          .equals("Y")
          .and
          .MONEY_TO_BE_COLLECTED
          .equals(0.0)
          .endBlock
          .toList();
    }
    else if (_selectedIndex == 2) {
      setState(() {
        _articlesToDisplay.clear();
      });
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .inValues(["PARCEL","BP"])
          .and
          .startBlock
          .ART_STATUS
          .equalsOrNull("")
          .and
          .invoiced
          .equals("Y")
          .and
          .MONEY_TO_BE_COLLECTED
          .equals(0.0)
          .endBlock
          .toList();
    }

    return _articlesToDisplay.length;
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Bulk Delivery"),
        backgroundColor: ColorConstants.kPrimaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => DeliveryScreen()),
              (route) => false),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          bool? result = await _onBackPressed();
          result ??= false;
          return result;
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(
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
              Expanded(
                flex: 10,
                child: Container(
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
                        }
                        else {
                          return SafeArea(
                            child: visible == true
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                      .orientation ==
                                                  Orientation.portrait
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height -
                                                  125
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height -
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(75),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 15),
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height:
                                                          MediaQuery.of(context)
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
                                                                  (context,
                                                                      index) {
                                                                return index ==
                                                                        0
                                                                    ? Container()
                                                                    // : _articlesToDisplay[index-1].articleType=="Parcel"?_listItemParcel(index-1):_articlesToDisplay[index-1].articleType=="EMO"?_listItemEMO(index-1):_listItem(index-1);
                                                                    //   :Text(_articlesToDisplay[index-1].articleNumber!);
                                                                    : _listItem(
                                                                        index -
                                                                            1);
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
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          );
                        }
                      }),
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
                      child: RaisedButton(
                    child: Text("Deliver All"
                         ,style: TextStyle(fontSize: 14), ),

                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.blueGrey)),
                        textColor: Color(0xFFCD853F),
                        color: Colors.white,
                    onPressed: () {

                      showDialog(
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
                                          'Return Confirmation',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                              color: Colors.blueGrey),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Are you sure you want to Deliver \n "
                                              "${_articlesToDisplay.length} "
                                              "${_selectedIndex==0?'Regd.Letter':_selectedIndex==1?'Speed Post':'Parcel'}\n ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            RaisedButton.icon(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        color:
                                                            Colors.blueGrey)),
                                                color: Colors.white70,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: Icon(
                                                  MdiIcons.emailRemoveOutline,
                                                  color: Color(0xFFd4af37),
                                                ),
                                                label: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey),
                                                )),
                                            RaisedButton.icon(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                        color:
                                                            Colors.blueGrey)),
                                                color: Colors.white70,
                                                onPressed: () async {
                                                  for (int i = 0;i <_articlesToDisplay.length;i++)
                                                  {

                                                    await Delivery()
                                                        .select()
                                                        .ART_NUMBER
                                                        .equals(_articlesToDisplay[i].ART_NUMBER)
                                                        .update({
                                                      'REMARK_DATE':DateTimeDetails().dbdatetime(),
                                                      'DATE_OF_DELIVERY':DateTimeDetails().onlyDate(),
                                                      'DELIVERY_TIME':DateTimeDetails().dbdatetime(),
                                                      'DEL_DATE': DateTimeDetails().onlyDate(),
                                                      'BEAT_NO': "BO",
                                                     'ART_STATUS': "D",
                                                      'DATE_OF_DELIVERY_CONFIRM':
                                                      DateTimeDetails().onlyDate(),
                                                      'TIME_OF_DELIVERY_CONFIRM':
                                                      DateTimeDetails().oT(),
                                                    });
                                                  }

                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              BulkDeliveryScreen()),
                                                      (route) => false);
                                                },
                                                icon: Icon(
                                                  MdiIcons.emailSendOutline,
                                                  color: Color(0xFFd4af37),
                                                ),
                                                label: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.blueGrey),
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
                  )),
                ),
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
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  _listItem(index) {
    return BulkDeliveryCard(
      _articlesToDisplay[index].ART_NUMBER!,
      _articlesToDisplay[index].MATNR!

    );
  }
}
