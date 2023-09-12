import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/Abstract%20Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'ArticleDisplayCard.dart';
import 'Styles/NeuromorphicBox.dart';
import 'db/DarpanDBModel.dart';

class ReportDetailsScreen extends StatefulWidget {
  String title;
  List articles;

  ReportDetailsScreen(this.title, this.articles);

  @override
  _ReportDetailsScreenState createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  Future? getDetails;
  List<Delivery> response = [];
  List<Delivery> mainresponse = [];
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];

  @override
  void initState() {
    getDetails = db();
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AbstractReportsScreen()),
        (route) => false);
  }

  db() async {
    response.clear();
    mainresponse.clear();
    print("Widget length: ${widget.articles.length}");
    for (int i = 0; i < widget.articles.length; i++) {
      print(widget.articles[i]);
      response = await Delivery()
          .select()
          .ART_NUMBER
          .equals(widget.articles[i])
          .toList();
      print(response[0].ART_NUMBER);
      mainresponse.add(response[0]);
      print(mainresponse[i].ART_NUMBER);
    }
    print("MainResponse: ${mainresponse.length}");
    for (int i = 0; i < mainresponse.length; i++) {
      // print(_articlesToDisplay[i].articleNumber);
      _address = await Addres()
          .select()
          .ART_NUMBER
          .equals(mainresponse[i].ART_NUMBER)
          .toList();
      // print(_address[0].articleNumber);
      _addressToDisplay.add(_address[0]);
    }
    return mainresponse.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: ColorConstants.kPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AbstractReportsScreen()),
                (route) => false),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            bool? result = await _onBackPressed();
            result ??= false;
            return result;
          },
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
                  return ListView.builder(
                      itemCount: mainresponse.length + 1,
                      itemBuilder: (context, index) {
                        return index == 0 ? Container() : _listItem(index - 1);
                      });
                }
              }),
        ));
  }

  _listItem(index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: GestureDetector(
        onTap: () async {
          _addressToDisplay[index].SEND_PIN == null
              ? _addressToDisplay[index].SEND_PIN = 110001
              : _addressToDisplay[index].SEND_PIN;
          mainresponse[index].TOTAL_MONEY == null
              ? mainresponse[index].TOTAL_MONEY = 0
              : mainresponse[index].TOTAL_MONEY;
          mainresponse[index].VPP == null
              ? mainresponse[index].VPP = "N"
              : mainresponse[index].VPP = "Y";
          mainresponse[index].COD == null
              ? mainresponse[index].COD = "N"
              : mainresponse[index].COD = "Y";
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        // padding: EdgeInsets.only(
                        //     left: 20.w, top: 40.h, right: 20.w, bottom: 20.h),
                        // margin: EdgeInsets.only(top: 40.h),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 10),
                                  blurRadius: 10),
                            ]),
                        child: ArticleDisplayCard(
                          mainresponse[index].ART_NUMBER!,
                          mainresponse[index].MATNR!,
                          int.parse(
                              _addressToDisplay[index].SEND_PIN!.toString()),
                          _addressToDisplay[index].REC_NAME!,
                          mainresponse[index].COD!,
                          mainresponse[index].VPP!,
                          mainresponse[index].MATNR!.contains("MO") &&
                                  mainresponse[index].ART_STATUS == "D"
                              ? int.parse(
                                  mainresponse[index].TOTAL_MONEY!.toString())
                              : int.parse(
                                  mainresponse[index].TOTAL_MONEY!.toString()),
                        )),
                    // Positioned(
                    //   left: 20.w,
                    //   right: 20.w,
                    //   child: CircleAvatar(
                    //     backgroundColor: Colors.red,
                    //     radius: 40.w,
                    //     child: ClipRRect(
                    //         borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    //         child: Image.asset(
                    //           "assets/images/ic_arrows.png",
                    //         )),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          );
        },
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
                              mainresponse[index].ART_NUMBER!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black54),
                            ))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
