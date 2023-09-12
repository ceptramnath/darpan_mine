import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/Biller/SearchScreen.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/material.dart';

import 'CollectionScreen.dart';

class BillerMainScreen extends StatefulWidget {
  const BillerMainScreen({Key? key}) : super(key: key);

  @override
  _BillerMainScreenState createState() => _BillerMainScreenState();
}

class _BillerMainScreenState extends State<BillerMainScreen>
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
          title: const Text(
            'Biller',
            style: TextStyle(letterSpacing: 2),
          ),
          backgroundColor: ColorConstants.kPrimaryColor,
          bottom: TabBar(
            controller: _controller,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: const [
              Tab(
                child: TabTextStyle(
                  title: 'Collection',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'Search',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: const [CollectionScreen(), SearchScreen()],
        ),
      ),
    );
  }
}
