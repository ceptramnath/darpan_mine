import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';

class EMOReportDialog extends StatelessWidget {
  String? emoValue;
  String? commission;
  String? amountPaid;
  String? senderName;
  String? senderAddress;
  String? senderPinCode;
  String? senderCity;
  String? senderState;
  String? payeeName;
  String? payeeAddress;
  String? payeePinCode;
  String? payeeCity;
  String? payeeState;

  EMOReportDialog({
    required this.emoValue,
    required this.commission,
    required this.amountPaid,
    required this.senderName,
    required this.senderAddress,
    required this.senderPinCode,
    required this.senderCity,
    required this.senderState,
    required this.payeeName,
    required this.payeeAddress,
    required this.payeePinCode,
    required this.payeeCity,
    required this.payeeState,
  });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DialogText(
                    title: 'EMO\nValue\n', subtitle: '\u{20B9} $emoValue'),
                DialogText(
                    title: 'Commission\nAmount\n',
                    subtitle: '\u{20B9} $commission'),
              ],
            ),
            const DoubleSpace(),
            Padding(
              padding: EdgeInsets.only(left: 20.0.toDouble()),
              child: DialogText(
                  title: 'Amount to be collected :- ',
                  subtitle: '\u{20B9} $amountPaid'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: const Text(
                  'Sender & Addressee Details',
                  style: TextStyle(color: ColorConstants.kTextColor),
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DialogText(title: 'Sender : ', subtitle: '$senderName'),
                      const Space(),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.toDouble()),
                        child: Text(senderAddress! +
                            ", " +
                            senderCity! +
                            ", " +
                            senderState! +
                            ", " +
                            senderPinCode!),
                      ),
                      const DoubleSpace(),
                      DialogText(title: 'Addressee : ', subtitle: payeeName!),
                      const Space(),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.toDouble()),
                        child: Text(payeeAddress! +
                            ", " +
                            payeeCity! +
                            ", " +
                            payeeState! +
                            ", " +
                            payeePinCode!),
                      ),
                      const Space(),
                    ],
                  )
                ],
              ),
            ),
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
