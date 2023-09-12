import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogCommonWidgets.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagOpenReportDialog extends StatelessWidget {
  String receivedDate;
  String receivedTime;
  String openedDate;
  String openedTime;
  List articles;

  BagOpenReportDialog(
      {Key? key,
      required this.receivedDate,
      required this.receivedTime,
      required this.openedDate,
      required this.openedTime,
      required this.articles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
        elevation: 0,
        backgroundColor: ColorConstants.kWhite,
        child: _data(context));
  }

  _data(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DialogHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowText('Bag Number : ', ' LBK1212121212'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      columnText('Received Date', receivedDate),
                      columnText('Received Time', receivedTime),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      columnText('Opened Date', openedDate),
                      columnText('Opened Time', openedTime),
                    ],
                  ),
                  ExpansionTile(
                    title: const Text(
                      'Bag Articles',
                      style: TextStyle(color: ColorConstants.kTextColor),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0.toDouble()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DialogText(
                                title: 'Total Articles : ',
                                subtitle: articles.length.toString()),
                            const Space(),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: articles.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(articles[index]);
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  rowText(String title, String description) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: title,
          style: TextStyle(
              color: ColorConstants.kTextColor,
              letterSpacing: 1,
              fontSize: 14),
          children: [
            TextSpan(
                text: description,
                style: TextStyle(
                    color: ColorConstants.kTextDark,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.toDouble(),
                    fontSize: 14))
          ]),
    );
  }

  columnText(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: ColorConstants.kTextColor)),
          Text(description,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.kTextDark,
                  letterSpacing: 1.toDouble()))
        ],
      ),
    );
  }
}
