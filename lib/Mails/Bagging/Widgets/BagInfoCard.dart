import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagInfoCard extends StatelessWidget {
  final String articleNumber;
  final String weight;

  const BagInfoCard(
      {Key? key, required this.articleNumber, required this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.toDouble()))),
                elevation: 0,
                backgroundColor: ColorConstants.kWhite,
                child: _data(context),
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articleNumber,
                          style: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.w500),
                        ),
                        Space(),
                        Text(
                          weight,
                          style: TextStyle(letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _data(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0.toDouble()),
              child: Row(
                children: [
                  Expanded(
                      flex: 2, child: Image.asset('assets/images/ic_logo.png')),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INDIA POST',
                          style: TextStyle(
                              fontSize: 25.toDouble(),
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500),
                        ),
                        Text('Ministry Of Communication')
                      ],
                    ),
                  )
                ],
              ),
            ),
            DottedLine(),
            SizedBox(
              height: 20.toDouble(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DialogText(title: 'Bag Number : ', subtitle: 'LBK1234567890'),
                  Space(),
                  DialogText(title: 'Weight : ', subtitle: '10gms'),
                  Space(),
                  DialogText(title: 'Stamps : ', subtitle: '5'),
                  Space(),
                  DialogText(title: 'Cash : ', subtitle: '\u{20B9} 5'),
                  ExpansionTile(
                    title: Text('Booked Letters',
                        style: TextStyle(color: ColorConstants.kTextColor)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DialogText(
                                title: 'Register Letter : ', subtitle: '8'),
                            DialogText(
                                title: 'Parcel Letter : ', subtitle: '2'),
                            DialogText(title: 'Speed Post : ', subtitle: '2'),
                          ],
                        ),
                      )
                    ],
                  ),
                  Button(
                      buttonText: 'OKAY',
                      buttonFunction: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
            )
          ],
        ),
      );
}
