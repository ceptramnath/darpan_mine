import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DeliveryScreen.dart';
import 'ReportDetailsScreen.dart';
import 'db/DarpanDBModel.dart';

class AbstractReportsScreen extends StatefulWidget {
  @override
  _AbstractReportsScreenState createState() => _AbstractReportsScreenState();
}

class _AbstractReportsScreenState extends State<AbstractReportsScreen> {
  List<Delivery> _articlesToDisplay = [];
  List<Delivery> _previousarticlesToDisplay = [];
  Future? getDetails;
  bool visible = true;
  int _selectedIndex = 0;
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];
  var prevDayCount = 0;
  var recdTodayCount = 0;
  var issueToPostmanCount = 0;
  var notissueToPostmanCount = 0;
  var deliveredCount = 0;
  var redirectCount = 0;
  var rtsCount = 0;
  var depositCount = 0;
  var pendingCount = 0;
  List<Delivery> totalArticlesList = [];
  List prevDayList = [];
  List recdTodayList = [];
  List issueToPostmanList = [];
  List notissueToPostmanList = [];
  List deliveredList = [];
  List redirectedList = [];
  List rtsList = [];
  List depositList = [];
  List pendingList = [];

  @override
  void initState() {
    getDetails = db();
    super.initState();
  }

  db() async {
    prevDayCount = 0;
    recdTodayCount = 0;
    issueToPostmanCount = 0;
    notissueToPostmanCount = 0;
    deliveredCount = 0;
    redirectCount = 0;
    rtsCount = 0;
    depositCount = 0;
    pendingCount = 0;

    if (_selectedIndex == 0) {


      final letterData =  await Delivery()
          .select()
          .MATNR
          .inValues(["LETTER", "VPL","INTL_APP_EPACKET",
    "AEROGRAMME_INTL","BL","BMS","BP","FGN_BL","FGN_BULKBAG","FGN_LETTER","FGN_PRINTEDPAPERS",
    "FGN_SMALLPACKETS","LETTER_CARD_S","MP_AEROGRAMME","MP_ENVELOPE","MP_ILC","MP_MEGHDOOT_PC",
    "MP_PASSBOOK","MP_PC","NBMS","PB","PERIODICAL","P_SP","R_NP"])
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .toList();


      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .equals("LETTER")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .toList();
      _previousarticlesToDisplay = await Delivery()
          .select()
          .MATNR
          .equals("LETTER")
          .and
          .startBlock
          .invoiceDate
          .not
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("N")
          .endBlock
          .toList();

      deliveredList = await Delivery()
          .select()
          .MATNR
          .inValues(["LETTER", "VPL","INTL_APP_EPACKET",
        "AEROGRAMME_INTL","BL","BMS","BP","FGN_BL","FGN_BULKBAG","FGN_LETTER","FGN_PRINTEDPAPERS",
        "FGN_SMALLPACKETS","LETTER_CARD_S","MP_AEROGRAMME","MP_ENVELOPE","MP_ILC","MP_MEGHDOOT_PC",
        "MP_PASSBOOK","MP_PC","NBMS","PB","PERIODICAL","P_SP","R_NP"])
          // .equals("LETTER")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("D")
          .endBlock
          .toList();

      deliveredCount=
      await Delivery()
          .select()
          .MATNR
          .equals("LETTER")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("D")
          .endBlock
          .toCount();

    }
    else if (_selectedIndex == 1) {
      // _articlesToDisplay = await Delivery()
      //     .select()
      //     .matnr
      //     .startsWith("SP")
      //     .and
      //     .startBlock
      //     .artStatus
      //     .equalsOrNull("")
      //     .endBlock
      //     .toList();
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .toList();
      _previousarticlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .startBlock
          .invoiceDate
          .not
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("N")
          .endBlock
          .toList();

      deliveredCount=
      await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("D")
          .endBlock
          .toCount();
      deliveredList= await Delivery()
          .select()
          .MATNR
          .startsWith("SP")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("D")
          .endBlock
          .toList();

    }
    else if (_selectedIndex == 2) {
      // _articlesToDisplay = await Delivery()
      //     .select()
      //     .matnr
      //     .contains("MO")
      //     .and
      //     .startBlock
      //     .artStatus
      //     .equalsOrNull("")
      //     .endBlock
      //     .toList();

      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .contains("MO")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .toList();
      _previousarticlesToDisplay = await Delivery()
          .select()
          .MATNR
          .contains("MO")
          .and
          .startBlock
          .invoiceDate
          .not
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("N")
          .endBlock
          .toList();
    }
    else if (_selectedIndex == 3) {
      // _articlesToDisplay = await Delivery()
      //     .select()
      //     .matnr
      //     .startsWith("P")
      //     .and
      //     .startBlock
      //     .artStatus
      //     .equalsOrNull("")
      //     .endBlock
      //     .toList();
      _articlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("P")
          .and
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          // .and
          // .startBlock
          // .artStatus
          // .equalsOrNull("")
          // .endBlock
          .toList();
      _previousarticlesToDisplay = await Delivery()
          .select()
          .MATNR
          .startsWith("P")
          .and
          .startBlock
          .invoiceDate
          .not
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .equals("N")
          .endBlock
          .toList();
    }


    for (int i = 0; i < _previousarticlesToDisplay.length; i++)
    {
      prevDayCount++;
      prevDayList.add(_previousarticlesToDisplay[i].ART_NUMBER);
      print(prevDayCount);
      print(prevDayList);
    }
    print(_articlesToDisplay.length);
    for (int i = 0; i < _articlesToDisplay.length; i++) {
      print("Status: ${_articlesToDisplay[i].ART_STATUS}");
      // print(_articlesToDisplay[i].reasonType );
      // print(_articlesToDisplay[i].reasonNonDelivery);
      if ((_articlesToDisplay[i].REASON_FOR_NONDELIVERY == "2" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "6" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "30") &&
          _articlesToDisplay[i].ACTION == "11") {
        print("TRUE @");
        redirectCount++;
        redirectedList.add(_articlesToDisplay[i].ART_NUMBER);
        print(redirectCount);
      }

      if (_articlesToDisplay[i].REASON_TYPE == "5" &&
          (_articlesToDisplay[i].REASON_FOR_NONDELIVERY == "2" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "1" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "7" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "6" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "14" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "9" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "11" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "17" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "18" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "27" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "40")) {
        rtsCount++;
        rtsList.add(_articlesToDisplay[i].ART_NUMBER);
      }

      if ((_articlesToDisplay[i].REASON_TYPE == "1" ||
              _articlesToDisplay[i].REASON_TYPE == "2") &&
          (_articlesToDisplay[i].REASON_FOR_NONDELIVERY == "35" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "36" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "1" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "8" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "3" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "5" ||
              _articlesToDisplay[i].REASON_FOR_NONDELIVERY == "15")) {
        print("Entered deposit");
        depositCount++;
        depositList.add(_articlesToDisplay[i].ART_NUMBER);
      }

      if (_articlesToDisplay[i].invoiceDate == DateTimeDetails().onlyDate()) {
        print("Entered postmancount");
        issueToPostmanCount++;
        issueToPostmanList.add(_articlesToDisplay[i].ART_NUMBER);
        // return;
      }
      if (_articlesToDisplay[i].invoiceDate == DateTimeDetails().onlyDate() &&
          _articlesToDisplay[i].ART_STATUS == null) {
        pendingCount++;
        pendingList.add(_articlesToDisplay[i].ART_NUMBER);
        // return;
      }

      print("Reached SetState");
      // setState(() {
      //     if(_articlesToDisplay[i].artStatus=="D"){
      //       deliveredCount++;
      //       deliveredList.add(_articlesToDisplay[i].articleNumber);
      //       return;
      //     }
      //
      //    if(_articlesToDisplay[i].invoiceDate==DateTimeDetails().onlyDate()){
      //       // recdTodayCount++;
      //       issueToPostmanCount++;
      //         // issueToPostmanList.add(_articlesToDisplay[i].articleNumber);
      //       // recdTodayList.add(_articlesToDisplay[i]);
      //       print("PostmanIssuedCount: $issueToPostmanCount");
      //       return;
      //     }
      //     if(_articlesToDisplay[i].invoiceDate==DateTimeDetails().onlyDate() && _articlesToDisplay[i].artStatus==null){
      //
      //       pendingCount++;
      //       // pendingList.add(_articlesToDisplay[i].articleNumber);
      //       // return;
      //     }
      //     // else if(_articlesToDisplay[i].invoiceDate==DateTimeDetails().onlyDate()){
      //     //   issueToPostmanCount++;
      //     //   issueToPostmanList.add(_articlesToDisplay[i]);
      //     //   return;
      //     // }
      //     if ((_articlesToDisplay[i].reasonNonDelivery=="2"||_articlesToDisplay[i].reasonNonDelivery=="6"||_articlesToDisplay[i].reasonNonDelivery=="30") &&_articlesToDisplay[i].action=="11"){
      //       print("Entered Redirected Count");
      //       redirectCount++;
      //       redirectedList.add(_articlesToDisplay[i].articleNumber);
      //       return;
      //     }
      //     if(_articlesToDisplay[i].reasonType=="5" && (_articlesToDisplay[i].reasonNonDelivery=="2"||_articlesToDisplay[i].reasonNonDelivery=="1"||_articlesToDisplay[i].reasonNonDelivery=="7" ||_articlesToDisplay[i].reasonNonDelivery=="6"||_articlesToDisplay[i].reasonNonDelivery=="14"||_articlesToDisplay[i].reasonNonDelivery=="9"||_articlesToDisplay[i].reasonNonDelivery=="11"||_articlesToDisplay[i].reasonNonDelivery=="17"||_articlesToDisplay[i].reasonNonDelivery=="18"||_articlesToDisplay[i].reasonNonDelivery=="27"||_articlesToDisplay[i].reasonNonDelivery=="40")){
      //       rtsCount++;
      //       rtsList.add(_articlesToDisplay[i].articleNumber);
      //       return;
      //     }
      //     if((_articlesToDisplay[i].reasonType=="1" || _articlesToDisplay[i].reasonType=="2") && (_articlesToDisplay[i].reasonNonDelivery=="35" ||_articlesToDisplay[i].reasonNonDelivery=="36" || _articlesToDisplay[i].reasonNonDelivery=="1" ||_articlesToDisplay[i].reasonNonDelivery=="8" || _articlesToDisplay[i].reasonNonDelivery=="3" ||_articlesToDisplay[i].reasonNonDelivery=="5" ||_articlesToDisplay[i].reasonNonDelivery=="15")){
      //       print("Entered deposit");
      //       depositCount++;
      //       depositList.add(_articlesToDisplay[i].articleNumber);
      //       return;
      //     }
      //
      //
      // });
    }
    print("Previous Day Articles: ${_previousarticlesToDisplay.length}");
    print("Entered to check for Pending Count");
    // setState(() {
    //   pendingCount =
    //       _articlesToDisplay.length + prevDayCount - notissueToPostmanCount -
    //           deliveredCount - redirectCount - rtsCount - depositCount;
    // });

    print("Pending Count: $pendingCount");

    print("Articles Count:");
    print(issueToPostmanCount);
    print(prevDayCount);
    print(notissueToPostmanCount);
    print(deliveredCount);
    print(redirectCount);
    print(rtsCount);
    print(depositCount);
    return _articlesToDisplay.length;
  }

  final key = new GlobalKey<ScaffoldState>();

  List<String> _options = ["Register Letter", 'Speed Post', 'EMO', 'Parcel', 'VPP/VPL','COD'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Abstract Report"),
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
                                ? SingleChildScrollView(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: DataTable(
                                              showCheckboxColumn: false,
                                              // columnSpacing: 20,
                                              headingRowColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Color(0xFFCC0000)),
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'Event Type',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Total Count',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                              rows: [
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '01. Previous Day Deposit',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        // _articlesToDisplay.length.toString(),
                                                        _previousarticlesToDisplay
                                                            .length
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (_previousarticlesToDisplay
                                                              .length !=
                                                          0) {
                                                        navigation(
                                                            ' Previous Day Deposit',
                                                            prevDayList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '02. Received Today',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        _articlesToDisplay
                                                            .length
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (_articlesToDisplay !=
                                                          0) {
                                                        navigation(
                                                            'Received Today',
                                                            issueToPostmanList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '03. Issued to Postman',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        _articlesToDisplay
                                                            .length
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (_articlesToDisplay !=
                                                          0) {
                                                        navigation(
                                                            'Issued to Postman',
                                                            issueToPostmanList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '04. Not Issued to Postman',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        notissueToPostmanCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (notissueToPostmanCount !=
                                                          0) {
                                                        navigation(
                                                            'Not Issued to Postman',
                                                            totalArticlesList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '05. Delivered',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        deliveredCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (deliveredCount != 0) {
                                                        navigation(
                                                            'Not Issued to Postman',
                                                            deliveredList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '06. Redirected',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        redirectCount
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (redirectCount != 0) {
                                                        navigation('Redirected',
                                                            redirectedList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '07. Returned To Sender',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        rtsCount.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (rtsCount != 0) {
                                                        navigation(
                                                            'Returned to Sender',
                                                            rtsList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '08. Deposited',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        depositCount.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (depositCount != 0) {
                                                        navigation('Deposited',
                                                            depositList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                                DataRow(
                                                    cells: [
                                                      DataCell(Text(
                                                          '09. Pending With Postman',
                                                          textAlign: TextAlign
                                                              .center)),
                                                      DataCell(Text(
                                                        pendingCount.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ],
                                                    onSelectChanged:
                                                        (newValue) {
                                                      // print(percentage(articles));
                                                      if (pendingCount != 0) {
                                                        navigation(
                                                            'Pending with Postman',
                                                            pendingList);
                                                      } else {
                                                        customSnackBar();
                                                      }
                                                    }),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  customSnackBar() {
    return key.currentState!.showSnackBar(new SnackBar(
      content: new Text("No Articles has been added"),
    ));
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

  navigation(String title, List articles) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReportDetailsScreen(title, articles)));
  }
}
