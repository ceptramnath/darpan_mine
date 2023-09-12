import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:flutter/material.dart';

class EMOMainScreen extends StatefulWidget {
  const EMOMainScreen({Key? key}) : super(key: key);

  @override
  _EMOMainScreenState createState() => _EMOMainScreenState();
}

class _EMOMainScreenState extends State<EMOMainScreen>
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
          backgroundColor: ColorConstants.kPrimaryColor,
          bottom: TabBar(
            controller: _controller,
            indicator: CircleTabIndicator(color: Colors.white, radius: 3),
            tabs: const [
              Tab(
                child: TabTextStyle(
                  title: 'EMO',
                ),
              ),
              Tab(
                child: TabTextStyle(
                  title: 'PMO Relief Fund',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: const [
            // EMOScreen(),
            // PMOReliefScreen()
          ],
        ),
      ),
    );
  }
}
