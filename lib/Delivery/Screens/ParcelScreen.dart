import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/SaveScannedParcelArticleScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DeliveryScreen.dart';
import 'Widgets/ParceCard.dart';
import 'db/DarpanDBModel.dart';

class ParcelScreen extends StatefulWidget {
  @override
  _ParcelScreenState createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  List<Delivery> _articlesToDisplay = [];
  Future? getDetails;
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];
  double amounttocollect = 0.0;

  @override
  void initState() {
    getDetails = db();
  }

  db() async {
    _articlesToDisplay.clear();
    _address.clear();
    _addressToDisplay.clear();
    print("Reached Db in parcel");

    // _articlesToDisplay=await ScannedArticle().select().articleType.startsWith("P").and.startBlock.articleStatus.not.startsWith("D").or.articleStatus.not.startsWith("N").endBlock.toList();
    // _articlesToDisplay=await ScannedArticle().select().articleNumber.startsWith([0-9]).toList();
    // print(_articlesToDisplay[0].articleNumber);
    // print(_articlesToDisplay[1].articleNumber);
    //  _articlesToDisplay=await ScannedArticle().select().articleType.startsWith("P").and.articleStatus.equalsOrNull("").toList();
    // _articlesToDisplay=await Delivery().select().MATNR.equals("PARCEL").and.startBlock.ART_STATUS.equalsOrNull("").and.invoiced.equals("Y").endBlock.toList();
    _articlesToDisplay = await Delivery()
        .select()
        .MATNR
        .inValues(["PARCEL", "VPP", "COD", "BP","BUSINESS_PARCEL","EXPRESS_ONP","FGN_AIR_PARCEL","FGN_SAL_PARCEL","EXPRESS_PARCEL"])
        .and
        .startBlock
        .ART_STATUS
        .equalsOrNull("")
        .and
        .invoiced
        .equals("Y")
        .endBlock
        .toList();
    for (int i = 0; i < _articlesToDisplay.length; i++) {
      print(_articlesToDisplay[i].MATNR);
      // print(_articlesToDisplay[i].articleNumber);
      _address = await Addres()
          .select()
          .ART_NUMBER
          .equals(_articlesToDisplay[i].ART_NUMBER)
          .toList();
      // print(_address[0].articleNumber);
      _addressToDisplay.add(_address[0]);
      print(_articlesToDisplay[i].MONEY_TO_BE_COLLECTED.toString());
      if (_articlesToDisplay[i].MONEY_TO_BE_COLLECTED.toString() == "null") {
        print('inside if condition');
        _articlesToDisplay[i].MONEY_TO_BE_COLLECTED = 0.0;
      }
      print(_articlesToDisplay[i].MONEY_TO_BE_COLLECTED.toString());
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
              title: Text("Parcel"),
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
                                              print(
                                                  "Index in itembuilder: $index");
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
                                          ),
                                  ),
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

  _listItem(index) {
    _addressToDisplay[index].SEND_PIN == null
        ? _addressToDisplay[index].SEND_PIN = 0
        : _addressToDisplay[index].SEND_PIN;
    // _articlesToDisplay [index].COD==null?  _articlesToDisplay [index].COD="": _articlesToDisplay [index].COD;
    // _articlesToDisplay [index].VPP==null?  _articlesToDisplay [index].VPP="": _articlesToDisplay [index].VPP;
    print("INdex in Parcel: $index");

    String codValue = _articlesToDisplay[index].COD.toString() == null
        ? ""
        : _articlesToDisplay[index].COD.toString();

    print('Regd Letter Delivery -3');
    String vppValue = _articlesToDisplay[index].VPP.toString() == null
        ? ""
        : _articlesToDisplay[index].VPP.toString();

    String money = _articlesToDisplay[index].MONEY_TO_BE_COLLECTED == null
        ? "0"
        : _articlesToDisplay[index].MONEY_TO_BE_COLLECTED.toString();
    double moneyCollected = double.parse(money);

    // print(_articlesToDisplay[index].COMMISSION.toString());
    String comString = _articlesToDisplay[index].COMMISSION == null
        ? "0"
        : _articlesToDisplay[index].COMMISSION.toString();
    double commission = double.parse(comString);

    return GestureDetector(
      onTap: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => SaveScannedParcelArticleScreen(
                      1,
                      _articlesToDisplay[index].ART_NUMBER!,
                      _articlesToDisplay[index].MATNR!,
                      codValue,
                      vppValue,
                      moneyCollected,
                      commission,
                    )),
            (route) => false);
      },
      child: ParcelCard(
        _articlesToDisplay[index].ART_NUMBER!,
        _articlesToDisplay[index].MATNR!,
        int.parse(_addressToDisplay[index].SEND_PIN!.toString()),
        _addressToDisplay[index].REC_NAME!,
        codValue,
        vppValue,
        moneyCollected,
      ),
    );
  }
}
