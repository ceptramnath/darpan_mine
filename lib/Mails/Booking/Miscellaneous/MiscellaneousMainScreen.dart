import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/Miscellaneous/PaymentsScreen.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/material.dart';

import 'ReceiptsScreen.dart';

class MiscellaneousMainScreen extends StatefulWidget {
  const MiscellaneousMainScreen({Key? key}) : super(key: key);

  @override
  _MiscellaneousMainScreenState createState() =>
      _MiscellaneousMainScreenState();
}

class _MiscellaneousMainScreenState extends State<MiscellaneousMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Miscellaneous Transactions',
            style: TextStyle(letterSpacing: 2),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          bottom: TabBar(
            controller: _controller,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: <Widget>[
              Tab(
                child: TabTextStyle(
                  title: 'Receipts',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'Payments',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[ReceiptsScreen(), PaymentsScreen()],
        ),
      ),
    );
  }
}
