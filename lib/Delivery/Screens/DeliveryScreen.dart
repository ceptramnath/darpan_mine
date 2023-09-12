import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/Abstract%20Report.dart';
import 'package:darpan_mine/Delivery/Screens/EMOInvoicing.dart';
import 'package:darpan_mine/Delivery/Screens/SaveScannedParcelArticleScreen.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:zxing_scanner/zxing_scanner.dart' as scanner;

import '../../HomeScreen.dart';
import 'BulkDeliveryScreen.dart';
import 'ConsolidatedAbstractReport.dart';
import 'DepositArticlesScreen.dart';
import 'EMOScreen.dart';
import 'InvoiceDepositArticlesSelection.dart';
import 'ParcelScreen.dart';
import 'RegisterScreen.dart';
import 'ReportsScreen.dart';
import 'SaveScannedArticleScreen.dart';
import 'SaveScannedEMOArticleScreen.dart';
import 'SpeedScreen.dart';
import 'db/ArticleModel.dart';
import 'db/DarpanDBModel.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  late String barcodeScanRes;

  @override
  void initState() {
    db();
  }

  db() async {
    // var count = await ScannedArticle().select().toCount();
    var count =0;
    // var a = await Delivery().select().toCount();
  }
  /*



   */

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
        (route) => false);
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
              title: Text("Delivery Services"),
              backgroundColor: ColorConstants.kPrimaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MainHomeScreen(MailsMainScreen(), 1)),
                    (route) => false),
              ),
            ),
            body: SafeArea(
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
                            child: GridView.count(
                              childAspectRatio: 1.17,
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 2
                                      : 3,
                              children: [
                                Card(
                                  child: MyMenu(
                                    title: "Invoice EMO",
                                    img: "assets/images/emo.png",
                                    pos: 6,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                Card(
                                  child: MyMenu(
                                    title: "Deliver EMO",
                                    img: "assets/images/book.png",
                                    pos: 1,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                Card(
                                  child: MyMenu(
                                    title: "Parcel",
                                    img: "assets/images/delivery.png",
                                    pos: 2,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                Card(
                                  child: MyMenu(
                                    title: "Register Letter",
                                    img: "assets/images/bagging.png",
                                    pos: 3,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                Card(
                                  child: MyMenu(
                                    title: "Speed Post",
                                    img: "assets/images/bagging.png",
                                    pos: 4,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                // Card(
                                //   child: MyMenu(
                                //     title: "Invoice EMO",
                                //     img: "assets/images/emo.png",
                                //     pos: 6,
                                //     bgcolor: Colors.grey[300]!,
                                //   ),
                                // ),
                                Card(
                                  child: MyMenu(
                                    title: "Invoice Deposit Articles",
                                    img: "assets/images/deposit.png",
                                    pos: 7,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                // Card(
                                //   child: MyMenu(
                                //     title: "Reports",
                                //     img: "assets/images/reports.png",
                                //     pos: 5,
                                //     bgcolor: Colors.grey[300]!,
                                //   ),
                                // ),
                                Card(
                                  child: MyMenu(
                                    title: "Bulk Delivery",
                                    img: "assets/images/reports.png",
                                    pos: 8,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                ),
                                Card(
                                  child: MyMenu(
                                    title: "Abstract Report",
                                    img: "assets/images/reports.png",
                                    pos: 9,
                                    bgcolor: Colors.grey[300]!,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //     elevation: 0.0,
            //     child: Icon(MdiIcons.barcodeScan),
            //     backgroundColor: ColorConstants.kPrimaryColor,
            //     onPressed: () async {
            //       // barcodeScanRes = await scanner.scan();
            //       barcodeScanRes = await Scan().scanBag();
            //       print("Barcode value: $barcodeScanRes");
            //       if (barcodeScanRes != "" && barcodeScanRes != null) {
            //         List<Delivery> scannedResponse = await Delivery()
            //             .select()
            //             .ART_NUMBER
            //             .equals(barcodeScanRes)
            //             .and
            //             .invoiceDate
            //             .equals(DateTimeDetails().onlyDate())
            //             .toList();
            //
            //         if (scannedResponse.length > 0) {
            //           scannedResponse[0].COD == null
            //               ? scannedResponse[0].COD = ""
            //               : scannedResponse[0].COD;
            //           scannedResponse[0].VPP == null
            //               ? scannedResponse[0].VPP = ""
            //               : scannedResponse[0].VPP;
            //           if ((scannedResponse[0].MATNR)!.contains("MO")) {
            //             print("Entered EMO Navigation");
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         SaveScannedEMOArticleScreen(
            //                             4,
            //                             scannedResponse[0].ART_NUMBER!,
            //                             "EMO",
            //                             scannedResponse[0].COD!,
            //                             scannedResponse[0].VPP!,
            //                             scannedResponse[0].TOTAL_MONEY!
            //                                 as double,
            //                             scannedResponse[0].COMMISSION!
            //                                 as double)),
            //                 (route) => false);
            //           } else if ((scannedResponse[0].MATNR)!.startsWith("P")) {
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) =>
            //                         SaveScannedParcelArticleScreen(
            //                           4,
            //                           scannedResponse[0].ART_NUMBER!,
            //                           "PARCEL",
            //                           scannedResponse[0].COD!,
            //                           scannedResponse[0].VPP!,
            //                           scannedResponse[0].MONEY_TO_BE_COLLECTED!
            //                               as double,
            //                           scannedResponse[0].COMMISSION! as double,
            //                         )),
            //                 (route) => false);
            //           } else {
            //             Navigator.pushAndRemoveUntil(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => SaveScannedArticleScreen(
            //                         4,
            //                         scannedResponse[0].ART_NUMBER!,
            //                         scannedResponse[0].MATNR,
            //                         scannedResponse[0].COD!,
            //                         scannedResponse[0].VPP!,
            //                         scannedResponse[0].MONEY_TO_BE_COLLECTED
            //                             as double,
            //                         scannedResponse[0].COMMISSION as double)),
            //                 (route) => false);
            //           }
            //         } else {
            //           UtilFs.showToast("Article is not invoiced", context);
            //           // barcodeScanRes = await scanner.scan();
            //         }
            //       }
            //     })
        )
    );
  }

// Future<bool> ?_onBackPressed() async{
//   return await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Are you sure?'),
//       content: Text('Do you want to exit App?'),
//       actions: <Widget>[
//         FlatButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: Text('No'),
//         ),
//         FlatButton(
//           onPressed: () async{
//             //await cron.close();
//             // await LogCat().writeContent("${DateTimeDetails().currentDateTime()}:Scheduler closed\n\n");
//             //exit(0);
//             SystemNavigator.pop();
//           },
//           /*Navigator.of(context).pop(true)*/
//           child: Text('Yes'),
//         ),
//       ],
//     ),
//   ) ??
//       false;
//
//
// }

}

class MyMenu extends StatelessWidget {
  MyMenu({this.title, this.img, this.pos, this.bgcolor});

  final String? title;
  final Color? bgcolor;
  int? scannerValue = 4;
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
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Ink(
            child: InkWell(
              onTap: () async {
                if (pos.toString() == '1') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EMOScreen()),
                  );
                } else if (pos.toString() == '2') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ParcelScreen()),
                  );
                } else if (pos.toString() == '3') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                } else if (pos.toString() == '4') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpeedScreen()),
                  );
                } else if (pos.toString() == '5') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportsScreen()),
                  );
                } else if (pos.toString() == '6') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EMOInvoicingScreen()),
                  );
                } else if (pos.toString() == '7') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InvoiceDepositArticlesScreen()),
                  );
                } else if (pos.toString() == '8') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BulkDeliveryScreen()),
                  );
                } else if (pos.toString() == '9') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConsolidatedAbstractScreen()),
                  );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => AbstractReportsScreen()),
                  // );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(img!, width: 70, color: Color(0xFFB71C1C)),
                  Text(title!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF984600),
                          //  color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500)),
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
