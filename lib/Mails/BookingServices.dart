import 'package:darpan_mine/Constants/Fees.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../HomeScreen.dart';
import 'Booking/BookingDBModel/BookingDBModel.dart';
import 'Booking/EMO/Screens/EMOMainScreen.dart';
import 'Booking/Parcel/Screens/ParcelBookingScreen.dart';
import 'Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';
import 'Booking/SpeedPost/Screens/SpeedPostScreen.dart';
import 'Booking/Transactions/TransactionScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class BookingServices extends StatefulWidget {
  @override
  State<BookingServices> createState() => _BookingServicesState();
}

class _BookingServicesState extends State<BookingServices> {
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
                MaterialPageRoute(
                    builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
                (route) => false),
          ),
          title: const Text(
            'Booking Services',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFFB71C1C),
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
                        padding: EdgeInsets.only(top: 15),
                        child: GridView.count(
                          childAspectRatio: 1.29,
                          crossAxisCount: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 3,
                          children: <Widget>[
                            MyMenu(
                              title: "Regd. Letter",
                              img: "assets/images/regd_letter.png",
                              pos: 1,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Speed Post",
                              img: "assets/images/speedpost.png",
                              pos: 2,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "EMO",
                              img: "assets/images/emo.png",
                              pos: 3,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Regd. Parcel",
                              img: "assets/images/regd_parcel.png",
                              pos: 4,
                              bgcolor: Colors.grey[300]!,
                            ),
                            MyMenu(
                              title: "Transactions",
                              img: "assets/images/accountable_articles.png",
                              pos: 5,
                              bgcolor: Colors.grey[300]!,
                            ),
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

class MyMenu extends StatefulWidget {
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
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  var fees;

  @override
  void initState() {
    getFees();
    super.initState();
  }

  getFees() async {
    var rlFees = await Fees().getRegistrationFees('LETTER');
    setState(() {
      fees = rlFees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          //color:
          // Colors.white,
          //Colors.grey[300],
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
                  if (widget.pos.toString() == '1') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterLetterBookingScreen1(
                                fees: fees,
                              )),
                    );
                  }
                  if (widget.pos.toString() == '2') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SpeedPostScreen()),
                    );
                  }
                  if (widget.pos.toString() == '3') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EMOMainScreen()),
                    );
                  }
                  if (widget.pos.toString() == '4') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ParcelBookingScreen()),
                    );
                  }
                  if (widget.pos.toString() == '5') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionScreen()),
                    );
                  }
                },

                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(widget.img!,
                        width: 70, color: Color(0xFFB71C1C)),
                    Text(widget.title!,
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
      ),
    );
    //)
    //);
  }
}
