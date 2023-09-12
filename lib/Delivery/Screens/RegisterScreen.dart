import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DeliveryScreen.dart';
import 'SaveScannedArticleScreen.dart';
import 'Widgets/ArticleCard.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<Delivery> _articlesToDisplay = [];
  Future? getDetails;
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];

  @override
  void initState() {
    getDetails = db();
  }

  db() async {
    _articlesToDisplay.clear();
    _address.clear();
    _addressToDisplay.clear();
    _articlesToDisplay = await Delivery()
        .select()
        .MATNR
        .inValues(["LETTER", "VPL","INTL_APP_EPACKET",
      "AEROGRAMME_INTL","BL","BMS","BP","FGN_BL","FGN_BULKBAG","FGN_LETTER","FGN_PRINTEDPAPERS",
      "FGN_SMALLPACKETS","LETTER_CARD_S","MP_AEROGRAMME","MP_ENVELOPE","MP_ILC","MP_MEGHDOOT_PC",
      "MP_PASSBOOK","MP_PC","NBMS","PB","PERIODICAL","P_SP","R_NP"])
        .and
        .startBlock
        .ART_STATUS
        .equalsOrNull("")
        .and
        .invoiced
        .equals("Y")
        .endBlock
        .toList();
    // _articlesToDisplay=await Delivery().select().MATNR.equals("LETTER").and.startBlock.ART_STATUS.equalsOrNull("").and.invoiced.equals("Y").endBlock.toList();
    print("Register Articles length: ${_articlesToDisplay.length}");
    // _articlesToDisplay=await ScannedArticle().select().articleNumber.startsWith([0-9]).toList();
    // print("Register articles length: ${_articlesToDisplay.length}");
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
    // print(_addressToDisplay[0].REC_NAME);
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
              title: Text("Registered"),
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                                )),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )));
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
        (route) => false);
  }

  remarkText(String? reasonCode) {
    if (reasonCode == "8")
      return 'Addressee Absent';
    else if (reasonCode == "7")
      return 'Addressee cannot be located';
    else if (reasonCode == "11")
      return 'Addressee left without Instructions';
    else if (reasonCode == "2")
      return 'Addressee Moved';
    else if (reasonCode == "19")
      return 'Beat Change';
    else if (reasonCode == "18")
      return 'Deceased';
    else if (reasonCode == "1")
      return 'Door locked';
    else if (reasonCode == "6")
      return 'Insufficient Address';
    else if (reasonCode == '40')
      return 'Recalled';
    else if (reasonCode == "14")
      return 'No such persons in the address';
    else if (reasonCode == "9") return 'Refused';
  }

  // _listItem(index) {
  //   _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
  //   return GestureDetector(
  //     onTap: () async{
  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => SaveScannedArticleScreen(2, _articlesToDisplay[index].articleNumber!, "Registered Letter",_articlesToDisplay[index].addressee,
  //               _articlesToDisplay[index].cod!,
  //               _articlesToDisplay[index].vpp!,
  //               _articlesToDisplay[index].moneytocollect!)),
  //               (route) => false);
  //     },
  //     child: ArticleCard(
  //       _articlesToDisplay[index].articleNumber!,
  //       _articlesToDisplay[index].articleType!,
  //       _articlesToDisplay[index].reasonCode == null ? 'Delivered to ${_articlesToDisplay[index].deliveredTo}' : remarkText(_articlesToDisplay[index].reasonCode),
  //       _articlesToDisplay[index].reasonCode == null ? Colors.blueGrey : Color(0xFF990000),
  //       _articlesToDisplay[index].invoiceDate!,
  //       _articlesToDisplay[index].invoiceTime!,
  //       _articlesToDisplay[index].addresseeType!,
  //       _articlesToDisplay[index].sourcepin!,
  //       _articlesToDisplay[index].receiver!,
  //     ),
  //   );
  // }

  _listItem(index) {
    // _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
    _addressToDisplay[index].SEND_PIN == null
        ? _addressToDisplay[index].SEND_PIN = 0
        : _addressToDisplay[index].SEND_PIN;
    _articlesToDisplay[index].COD == null
        ? _articlesToDisplay[index].COD = ""
        : _articlesToDisplay[index].COD;
    _articlesToDisplay[index].VPP == null
        ? _articlesToDisplay[index].VPP = ""
        : _articlesToDisplay[index].VPP;

    String codValue = _articlesToDisplay[index].COD!.toString() == null
        ? ""
        : _articlesToDisplay[index].COD!.toString();

    print('Regd Letter Delivery -3');
    String vppValue = _articlesToDisplay[index].VPP!.toString() == null
        ? ""
        : _articlesToDisplay[index].VPP!.toString();

    print('========================');
    // print(_articlesToDisplay[index].MONEY_TO_BE_COLLECTED.toString());
    print('<<<<<<<<<<>>>>>>>>>>>>>>>>>');

    // print(_articlesToDisplay[index].MONEY_TO_BE_COLLECTED.toString());
    String money = _articlesToDisplay[index].MONEY_TO_BE_COLLECTED == null
        ? "0"
        : _articlesToDisplay[index].MONEY_TO_BE_COLLECTED.toString();
    double moneyCollected = double.parse(money);

    // print(_articlesToDisplay[index].COMMISSION.toString());
    String comString = _articlesToDisplay[index].COMMISSION == null
        ? "0"
        : _articlesToDisplay[index].COMMISSION.toString();
    double commission = double.parse(comString);

    // double moneyCollected =double.parse(_articlesToDisplay[index].MONEY_TO_BE_COLLECTED == "null"
    //     ? '0'
    //     :_articlesToDisplay[index].MONEY_TO_BE_COLLECTED.toString());
    //
    // print("******");
    // double commission = double.parse(_articlesToDisplay[index].COMMISSION!.toString()== "null"
    //     ? "0"
    //     :_articlesToDisplay[index].COMMISSION!.toString());

    // double moneyCollected =0;
    print(moneyCollected);
    print(commission);
    // double commission =0;
    return GestureDetector(
      onTap: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SaveScannedArticleScreen(
                    2,
                    _articlesToDisplay[index].ART_NUMBER!,
                    "Registered Letter",
                    codValue,
                    vppValue,
                    moneyCollected,
                    commission)),
            (route) => false);
      },
      child: ArticleCard(
        _articlesToDisplay[index].ART_NUMBER!,
        _articlesToDisplay[index].MATNR!,
        int.parse(_addressToDisplay[index].SEND_PIN!.toString()),
        _addressToDisplay[index].REC_NAME!,
      ),
    );
  }
}
