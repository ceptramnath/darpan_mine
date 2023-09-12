import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Bagging/Widgets/BagOpenReportDialog.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagOpenReportCard extends StatelessWidget {
  String bagNumber;
  String receivedDate;
  String receivedTime;
  String openedDate;
  String openedTime;
  String articlesCount;
  String documentsReceived;
  String inventoryReceived;
  String cashReceived;
  List articlesReceived;

  BagOpenReportCard(
      {Key? key,
      required this.bagNumber,
      required this.receivedDate,
      required this.receivedTime,
      required this.openedDate,
      required this.openedTime,
      required this.articlesCount,
      required this.documentsReceived,
      required this.inventoryReceived,
      required this.cashReceived,
      required this.articlesReceived})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return BagOpenReportDialog(
                receivedDate: receivedDate,
                receivedTime: receivedTime,
                openedDate: openedDate,
                openedTime: openedTime,
                articles: articlesReceived,
              );
            });
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.5),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: ColorConstants.kSecondaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bag Number'),
                            Text(bagNumber,
                                style: TextStyle(
                                    letterSpacing: 1.0,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(
                    '$openedDate\n $openedTime',
                    style: TextStyle(letterSpacing: 1.0),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              const DottedLine(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardTitleDescription('Articles in Bag', articlesCount),
                  cardTitleDescription('Documents in Bag', documentsReceived),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  cardTitleDescription('Inventory in Bag', inventoryReceived),
                  cardTitleDescription('Cash in Bag', '\u{20B9}$cashReceived'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  cardTitleDescription(String title, String description) {
    return Column(
      children: [
        Text(
          title,
          style:
              TextStyle(letterSpacing: 1.0, color: ColorConstants.kTextColor),
        ),
        Text(description,
            style: TextStyle(
                letterSpacing: 1.0,
                color: ColorConstants.kTextDark,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}
