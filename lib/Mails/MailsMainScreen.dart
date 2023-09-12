import 'package:darpan_mine/Authentication/FileProcessing.dart';
import 'package:darpan_mine/CBS/leave.dart';
import 'package:darpan_mine/Delivery/Screens/AlertDigitalOTP.dart';
import 'package:darpan_mine/Delivery/Screens/ConsolidatedAbstractReport.dart';
import 'package:darpan_mine/Delivery/Screens/DeliveryScreen.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Utils/CustomDrawer.dart';
import 'package:darpan_mine/Utils/delete.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../HomeScreen.dart';
import 'BaggingServices.dart';
import 'Booking/BookingDBModel/BookingDBModel.dart';
import 'Booking/BookingMainScreen.dart';
import 'Booking/PayRoll/PayRollScreen.dart';
import 'Booking/SpecialRemittance/SpecialRemittanceMainScreen.dart';
import 'LoginAccessTokenScreen.dart';
import 'backgroundoperations.dart';

class MailsMainScreen extends StatefulWidget {
  @override
  State<MailsMainScreen> createState() => _MailsMainScreenState();
}

class _MailsMainScreenState extends State<MailsMainScreen> {
  invoke() async {
    print("Reached Invoke");
    var login = await Login().select().toList();
    ado.showDialogBox(context, login[0].digitalToken!);
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
        // appBar: AppBar(title: const Text('Darpan-Mails ', textAlign: TextAlign.center,style: TextStyle(fontSize: 22,),),backgroundColor: Color(0xFFB71C1C),
        //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
        //       bottom: Radius.circular(20) )),
        // ),
        appBar: AppAppBar(title: "Mail Operations"),
        drawer: CustomDrawer(),
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height - 170
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
                        padding: EdgeInsets.only(top: 15),
                        child: GridView.count(
                          childAspectRatio: 1,
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 3,
                          children: <Widget>[
                            // MyMenu(
                            //   title: "Operations",
                            //   img: "assets/images/book.png",
                            //   pos: 0,
                            //   bgcolor: Colors.grey[300]!,
                            // ),
                            MyMenu(
                              title: "Booking",
                              img: "assets/images/book.png",
                              pos: 1,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Delivery",
                              img: "assets/images/ic_postman1.png",
                              pos: 2,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Bagging",
                              img: "assets/images/bagging.png",
                              pos: 3,
                              bgcolor: Colors.grey[300]!,
                            ),
                            // MyMenu(
                            //   title: "FileProcess",
                            //   img: "assets/images/bagging.png",
                            //   pos: 99,
                            //   bgcolor: Colors.grey[300]!,
                            // ),
                            MyMenu(
                              title: "Delete old Data",
                              img: "assets/images/delete1.png",
                              pos: 101,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Pay Roll",
                              img: "assets/images/ic_ministatement.png",
                              pos: 102,
                              bgcolor: Colors.grey[300]!,
                            ),
                            // MyMenu(
                            //     title: 'Special Remittance',
                            //     img: 'assets/images/speedpost.png',
                            //     pos: 19),

                            // MyMenu(title: 'DelReport',
                            //       img: 'assets/images/speedpost.png',
                            //       pos: 77),
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

_MailsMainScreenState mms = _MailsMainScreenState();

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
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white,
          // Colors.grey[300],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Container(
            child: Ink(
              //color:Colors.red,
              child: InkWell(
                //splashColor: Colors.red,
                onTap: () async {
                  var currentDate = DateTimeDetails().currentDate();
                  final dayDetails = await DayModel()
                      .select()
                      .DayBeginDate
                      .equals(currentDate)
                      .toList();

                  //NO checking for Daybegin in delete.
                  if (pos.toString() == '101') {
                    //await dataSync.upload();
                    print("Calling the delete");
                    dBdelete.delete();
                    // PrintingTelPO printer = new PrintingTelPO();
                    // await printer.printImage();
                  }
                  if (dayDetails.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Note'),
                            content: const Text('Do Day Begin to continue!'),
                            actions: [
                              Button(
                                  buttonText: 'OKAY',
                                  buttonFunction: () => Navigator.pop(context))
                            ],
                          );
                        });
                  } else {
                    if (pos.toString() == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingMainScreen()),
                      );
                    }
                    if (pos.toString() == '2') {
                      // Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(false,scannerValue!,false)),);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeliveryScreen()),
                      );
                    }
                    if (pos.toString() == '3') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BaggingServices()),
                      );
                    }
                    if (pos.toString() == '4') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginAccessTokenScreen()),
                      );
                    }
                    if (pos.toString() == '5') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => leaveScreen()),
                      );
                    }
                    // if (pos.toString() == '99') {
                    //   // await dataSync.download();
                    //   await dataSync.upload();
                    //
                    //
                    //   // PrintingTelPO printer = new PrintingTelPO();
                    //   // await printer.printImage();
                    // }
                    if (pos.toString() == '100') {
                      await fileProcessing.FileProc();
                      // PrintingTelPO printer = new PrintingTelPO();
                      // await printer.printImage();
                    }

                    if (pos.toString() == '102') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PayRollScreen()));
                    }
                    if (pos.toString() == '19') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const SpecialRemittanceMainScreen()));
                    }
                    if (pos.toString() == '77') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              ConsolidatedAbstractScreen()));
                    }
                  }
                },

                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(img!, width: 80, color: Color(0xFFB71C1C)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF984600),
                            //  color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                //),
              ),
            ),
          ),
        ),
      ),
    );
    //)
    //);
  }
}
