import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/SpecialRemittance/CashFromAO.dart';
import 'package:darpan_mine/Mails/Booking/SpecialRemittance/RequestCreationScreen.dart';
import 'package:darpan_mine/Mails/Booking/SpecialRemittance/RequestStatusScreen.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialRemittanceMainScreen extends StatefulWidget {
  const SpecialRemittanceMainScreen({Key? key}) : super(key: key);

  @override
  _SpecialRemittanceMainScreenState createState() =>
      _SpecialRemittanceMainScreenState();
}

class _SpecialRemittanceMainScreenState
    extends State<SpecialRemittanceMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Special Remittance',
            style: TextStyle(letterSpacing: 1),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          bottom: TabBar(
            controller: _controller,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: const [
              Tab(
                child: TabTextStyle(
                  title: 'Create Request',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'Request Status',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'Cash from AO',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: const [RequestCreationScreen(), RequestStatusScreen(),CashFromAOScreen()],
        ),
      ),
    );
  }
}
