import 'package:darpan_mine/Mails/Bagging/Screens/BagClose/BagCloseDetailsScreen.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagCloseCard extends StatelessWidget {
  final String bagNumber;
  final String bagWeight;
  final String bagReceivedDate;
  final String bagReceivedTime;
  final String bagOpenedDate;
  final String bagOpenedTime;
  final Function() function;

  const BagCloseCard(
      {Key? key,
      required this.bagNumber,
      required this.bagWeight,
      required this.bagReceivedDate,
      required this.bagReceivedTime,
      required this.bagOpenedDate,
      required this.bagOpenedTime,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => BagCloseDetailsScreen(bagNumber: bagNumber)));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bagNumber,
                              style: const TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500),
                            ),
                            const Space(),
                            DialogText(
                                title: 'Bag weight -> ',
                                subtitle: '$bagWeight gms'),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BagCloseDetailsScreen(
                                          bagNumber: bagNumber,
                                        )));
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.blueGrey,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
