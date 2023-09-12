import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class LetterReportDialog extends StatelessWidget {
  String? articleNumber;
  String? weight;
  String? prepaidAmount;
  String? amountToBeCollected;
  String? senderName;
  String? senderAddress;
  String? senderCity;
  String? senderState;
  String? senderPinCode;
  String? addresseeName;
  String? addresseeAddress;
  String? addresseeCity;
  String? addresseeState;
  String? addresseePinCode;

  LetterReportDialog(
      {Key? key,
      required this.articleNumber,
      required this.weight,
      required this.prepaidAmount,
      required this.amountToBeCollected,
      required this.senderName,
      required this.senderAddress,
      required this.senderCity,
      required this.senderState,
      required this.senderPinCode,
      required this.addresseeName,
      required this.addresseeAddress,
      required this.addresseeCity,
      required this.addresseeState,
      required this.addresseePinCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
      elevation: 0,
      backgroundColor: ColorConstants.kWhite,
      child: _data(context),
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
                        const Text('Ministry Of Communication')
                      ],
                    ),
                  )
                ],
              ),
            ),
            const DottedLine(),
            SizedBox(
              height: 20.toDouble(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.toDouble()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DialogText(
                            title: 'Article Number : ',
                            subtitle: articleNumber!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DialogText(
                                title: 'Weight\n\n', subtitle: '$weight gms'),
                            DialogText(
                                title: 'Prepaid \nAmount : ',
                                subtitle: '\u{20B9} $prepaidAmount'),
                          ],
                        ),
                        const Space(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'Amount to be paid : ',
                              style: const TextStyle(
                                  color: ColorConstants.kTextColor,
                                  letterSpacing: 1),
                              children: [
                                TextSpan(
                                    text: '\u{20B9} $amountToBeCollected',
                                    style: TextStyle(
                                        fontSize: 15.toDouble(),
                                        color: ColorConstants.kTextDark,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.toDouble()))
                              ]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                      title: const Text(
                        'Sender & Addressee Details',
                        style: TextStyle(color: ColorConstants.kTextColor),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0.toDouble()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DialogText(
                                  title: 'Sender : ', subtitle: '$senderName'),
                              const Space(),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 8.0.toDouble()),
                                child: Text(senderAddress! +
                                    ", " +
                                    senderCity! +
                                    ", " +
                                    senderState! +
                                    ", " +
                                    senderPinCode!),
                              ),
                              const DoubleSpace(),
                              DialogText(
                                  title: 'Addressee : ',
                                  subtitle: addresseeName!),
                              const Space(),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 8.0.toDouble()),
                                child: Text(addresseeAddress! +
                                    ", " +
                                    addresseeCity! +
                                    ", " +
                                    addresseeState! +
                                    ", " +
                                    addresseePinCode!),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Space(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0.toDouble()),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: ColorConstants.kPrimaryAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0.toDouble()),
                            bottomLeft: Radius.circular(10.0.toDouble()))),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 15.0.toDouble()),
                        child: Text(
                          "OKAY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0.toDouble(),
                              color: ColorConstants.kWhite),
                        ),
                      ),
                      SizedBox(width: 20.0.toDouble()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
