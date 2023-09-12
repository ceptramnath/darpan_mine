import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/Leave/ApplyLeaveScreen.dart';
import 'package:darpan_mine/Mails/Booking/Leave/CancelLeaveScreen.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/material.dart';

class LeaveMainScreen extends StatefulWidget {
  const LeaveMainScreen({Key? key}) : super(key: key);

  @override
  _LeaveMainScreenState createState() => _LeaveMainScreenState();
}

class _LeaveMainScreenState extends State<LeaveMainScreen>
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
            'Leave Management',
            style: TextStyle(letterSpacing: 2),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          bottom: TabBar(
            controller: _controller,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: <Widget>[
              Tab(
                child: TabTextStyle(
                  title: 'Apply Leave',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'Cancel Leave',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[ApplyLeaveScreen(), CancelLeaveScreen()],
        ),
      ),
    );
  }
}
