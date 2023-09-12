import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class LetterReportCard extends StatelessWidget {
  String? articleNumber;
  String? weight;
  String? prepaidAmount;
  String? amountToBeCollected;
  String? senderName;
  String? addresseeName;

  LetterReportCard({
    required this.articleNumber,
    required this.weight,
    required this.prepaidAmount,
    required this.amountToBeCollected,
    required this.senderName,
    required this.addresseeName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.toDouble()),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: ColorConstants.kPrimaryAccent,
                  width: 5.toDouble(),
                  style: BorderStyle.solid),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.toDouble()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 35.0.toDouble()),
                  child: RichText(
                    text: TextSpan(
                        text: 'Article Number : ',
                        style:
                            const TextStyle(color: ColorConstants.kTextColor),
                        children: [
                          TextSpan(
                              text: articleNumber,
                              style: const TextStyle(
                                  color: ColorConstants.kTextDark,
                                  fontWeight: FontWeight.w500))
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.toDouble()),
                  child: const DottedLine(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        child: TitleAndHeading(
                            title: 'Sender Name', heading: senderName!)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        'assets/images/ic_post_sending.png',
                        height: 50.toDouble(),
                      ),
                    ),
                    Flexible(
                        child: TitleAndHeading(
                            title: 'Addressee Name', heading: addresseeName!))
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0.toDouble()),
                  child: const Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TitleAndHeading(
                        title: 'Weight', heading: weight!.toString() + 'gms'),
                    TitleAndHeading(
                        title: 'Prepaid Amount',
                        heading: prepaidAmount!.isEmpty
                            ? '\u{20B9} 0'
                            : '\u{20B9}' + prepaidAmount!.toString()),
                    TitleAndHeading(
                        title: 'Amount Paid',
                        heading: '\u{20B9}' + amountToBeCollected!.toString()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
