import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/DashboardCard.dart';
import 'package:flutter/material.dart';

class DeliveryMainScreen extends StatelessWidget {
  const DeliveryMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'Delivery',
      ),
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          childAspectRatio: 1.29,
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 2
                  : 3,
          children: [
            DashboardCard(
                title: 'Accountable Articles',
                image: 'assets/images/book.png',
                position: 21),
            DashboardCard(
                title: 'EMO', image: 'assets/images/emo.png', position: 22),
          ],
        ),
      ),
    );
  }
}
