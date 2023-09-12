import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DashboardCard.dart';
import 'package:flutter/material.dart';

import '../BookingMainScreen.dart';

class ReportsMainScreen extends StatelessWidget {
  const ReportsMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToPrevious(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorConstants.kPrimaryColor,
          title: const Text('Reports'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => BookingMainScreen()),
                  (route) => false)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            childAspectRatio: 1.10,
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            children: const [
              DashboardCard(
                  title: 'Cancelled Articles \nReports',
                  image: 'assets/images/report.png',
                  position: 91),
              DashboardCard(
                  title: 'Transaction \nReports',
                  image: 'assets/images/accountable_articles.png',
                  position: 92),
              DashboardCard(
                  title: 'Inventory \nReports',
                  image: 'assets/images/deposit.png',
                  position: 93),
              DashboardCard(
                  title: 'Cash/Card \nReports',
                  image: 'assets/images/ic_vault.png',
                  position: 94),
              // DashboardCard(
              //     title: 'Generate\nBODA',
              //     image: 'assets/images/reports.png',
              //     position: 95),
              DashboardCard(
                  title: 'Cash Balance \nReports',
                  image: 'assets/images/currency.png',
                  position: 96),
              // DashboardCard(title: 'Mail Transaction \nReports', image: 'assets/images/report.png', position: 97),
              // DashboardCard(
              //     title: 'BODA \nReports',
              //     image: 'assets/images/ic_dat.png',
              //     position: 98),
              DashboardCard(
                  title: 'Digital \nReports',
                  image: 'assets/images/biller.png',
                  position: 99),
            ],
          ),
        ),
      ),
    );
  }

  void moveToPrevious(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BookingMainScreen()),
        (route) => false);
  }
}
