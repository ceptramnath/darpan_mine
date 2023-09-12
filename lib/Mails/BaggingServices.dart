import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagReports/BagReportsScreen.dart';
import 'package:flutter/material.dart';

import '../HomeScreen.dart';
import 'Bagging/Screens/BagClose/BagCloseScreen.dart';
import 'Bagging/Screens/BagDispatchScreen.dart';
import 'Bagging/Screens/BagOpen/BagOpenScreen.dart';
import 'Bagging/Screens/BagReceiveScreen.dart';
import 'MailsMainScreen.dart';

class BaggingServices extends StatefulWidget {
  @override
  State<BaggingServices> createState() => _BaggingServicesState();
}

class _BaggingServicesState extends State<BaggingServices> {
  bool downloaded = false;

  @override
  void initState() {
    fetchBag();
    super.initState();
  }

  fetchBag() async {
    final bags = await BagReceivedTable().select().toMapList();
    final articles = await BagArticlesTable().select().toMapList();
    final stamps = await InventoryMainTable().select().toMapList();
    final stamp = await BagInventory().select().toMapList();
    final cash = await CashTable().select().toMapList();
    final inventory = await BagInventory().select().toMapList();
    final excess = await BagExcessArticlesTable().select().toMapList();
    final excessStamp = await BagExcessStampsTable().select().toMapList();
    final products = await ProductsTable().select().toMapList();
    final docs = await DocumentsTable().select().toMapList();
    final deliveryArticles = await Delivery()
        .select()
        .invoiceDate
        .equals(DateTimeDetails().onlyDate())
        .toMapList();
    final deliveryAddress = await Addres().select().toMapList();
    final closedBag = await BagCloseTable().select().toMapList();
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
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 20.0),
          //     child: IconButton(onPressed: !downloaded ? () async {
          //       setState(() {
          //         downloaded = true;
          //       });
          //       fetchBag();
          //       var bagLength = bagJson['bagData']?.length;
          //       for (int i = 0; i < bagLength!; i++) {
          //         //Adding Bag Details
          //         try {
          //           await BaggingDBService().addBagToDB(
          //               bagJson['bagData']![i]['bagNumber'].toString(),
          //               DateTimeDetails().onlyDate(),
          //               DateTimeDetails().onlyTime(), "", "",
          //               bagJson['bagData']![i]['articlesCount'].toString(),
          //               bagJson['bagData']![i]['bagCashCount'].toString(),
          //               bagJson['bagData']![i]['stampsCount'].toString(),
          //               bagJson['bagData']![i]['documentsCount'].toString(),
          //               "Received"
          //           );
          //
          //             var bagArticles = bagJson['bagData']![i]['bagArticles'] as List;
          //             for (int j = 0; j<bagArticles.length; j++) {
          //               await BaggingDBService().addBagArticlesToDB(bagArticles[j]['article'],
          //                   bagJson['bagData']![i]['bagNumber'].toString(),
          //                   bagArticles[j]['type'], 'Received');
          //             }
          //
          //             var bagStamps = bagJson['bagData']![i]['bagStamps'] as List;
          //             for (int j = 0; j<bagStamps.length; j++) {
          //
          //               await BaggingDBService().addInventoryFromBag(
          //                   bagJson['bagData']![i]['bagNumber'].toString(),
          //                   bagStamps[j]['type'].toString().replaceAll(' ', ''),
          //                   bagStamps[j]['type'].toString().replaceAll(' ', '').substring(0,3)+bagStamps[j]['denomination'],
          //                   bagStamps[j]['denomination'],
          //                   bagStamps[j]['type'],
          //                   bagStamps[j]['count']);
          //             }
          //
          //             await BaggingDBService().addCashFromBagToDB(i.toString(), bagJson['bagData']![i]['bagCash'].toString(), bagJson['bagData']![i]['bagNumber'].toString(),);
          //
          //             var bagDocuments = bagJson['bagData']![i]['bagDocuments'] as List;
          //             for (int j = 0 ; j < bagDocuments.length; j++) {
          //               await BaggingDBService().addBagDocumentsToDB(
          //                   bagDocuments[j].toString().replaceAll(' ', ''),
          //                   bagDocuments[j], bagJson['bagData']![i]['bagNumber'].toString());
          //             }
          //         } catch (e) {
          //           Toast.showToast(e.toString(), context);
          //         }
          //       }
          //       final getBags = await BagReceivedTable().select().toMapList();
          //       Toast.showToast("${getBags.length} Bags has been added", context);
          //     } : () {
          //       Toast.showToast("Downloading data please wait", context);
          //     }, icon: const Icon(Icons.download_outlined)),
          //   )
          // ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => MainHomeScreen(MailsMainScreen(), 1)),
                (route) => false),
          ),
          title: const Text(
            'Bagging Services',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: const Color(0xFFB71C1C),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height - 125
                        : MediaQuery.of(context).size.height - 125,
                decoration: const BoxDecoration(
                  //color:
                  //Colors.white,
                  //Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75),
                    topRight: Radius.circular(2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height > 900 ? 14 : 14),
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(75),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GridView.count(
                          childAspectRatio: 1.29,
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 3,
                          children: <Widget>[
                            // MyMenu(
                            //   title: "Bag Receive",
                            //   img: "assets/images/receive.png",
                            //   pos: 1,
                            //   bgcolor: Colors.grey[300]!,
                            // ),

                            MyMenu(
                              title: "Bag Open",
                              img: "assets/images/open.png",
                              pos: 2,
                              bgcolor: Colors.grey[300]!,
                            ),

                            // MyMenu(
                            //   title: "Bag Create",
                            //   img: "assets/images/create.png",
                            //   pos: 3,
                            //   bgcolor: Colors.grey[300]!,
                            // ),
                            MyMenu(
                              title: "Bag Close",
                              img: "assets/images/close.png",
                              pos: 4,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Bag Dispatch",
                              img: "assets/images/dispatched.png",
                              pos: 5,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Bag Reports",
                              img: "assets/images/reports.png",
                              pos: 6,
                              bgcolor: Colors.grey[300]!,
                            ),
                            // MyMenu(
                            //   title: "Bag Tracking",
                            //   img: "assets/images/tracking.png",
                            //   pos: 7,
                            //   bgcolor: Colors.grey[300]!,
                            // ),
                          ],
                        ),
                      )),
                ),
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
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
        (route) => false);
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({this.title, this.img, this.pos, this.bgcolor});

  final String? title;
  final Color? bgcolor;

  final int? pos;
  final String? img;
  static const _kFontFam = 'MyHomePage';
  static const _kFontPkg = null;
  static const IconData ic_article_tracking =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          //color:
          // Colors.white,
          //Colors.grey[300],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Ink(
            //color:Colors.red,
            child: InkWell(
              //splashColor: Colors.red,
              onTap: () async {
                if (pos.toString() == '1') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BagReceiveScreen()),
                  );
                }
                if (pos.toString() == '2') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BagOpenScreen()),
                  );
                }
                if (pos.toString() == '4') {
                  //removed BODA and DayEnd Condition as suggested by RICT Team while testing.
                  //
                  // final bodaDetails = await BodaSlip()
                  //     .select()
                  //     .bodaDate
                  //     .equals(DateTimeDetails().currentDate())
                  //     .toMapList();
                  // if (bodaDetails.isEmpty) {
                  //   Toast.showFloatingToast(
                  //       'Please generate BODA Report', context);
                  // } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BagCloseScreen()),
                  );
                  // }
                }
                if (pos.toString() == '5') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BagDispatchScreen()),
                  );
                }
                if (pos.toString() == '6') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BagReportsScreen()),
                  );
                }
                // if(pos.toString()=='7') {
                //   Navigator.push(context,MaterialPageRoute(builder: (context) => BagTrackingScreen()),);
                // }
              },

              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(img!, width: 70, color: Color(0xFFB71C1C)),
                  Text(title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF984600),
                          //  color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              //),
            ),
          ),
        ),
      ),
    );
    //)
    //);
  }
}
