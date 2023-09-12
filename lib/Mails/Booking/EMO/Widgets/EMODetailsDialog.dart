import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class EMODetailsDialog extends StatelessWidget {
  String? emoValue;
  String? commission;
  String? amountPaid;
  String? senderName;
  String? senderAddress;
  String? senderPinCode;
  String? senderCity;
  String? senderState;
  String? senderMobileNumber;
  String? senderEmail;
  String? payeeName;
  String? payeeAddress;
  String? payeePinCode;
  String? payeeCity;
  String? payeeState;
  String? payeeMobileNumber;
  String? payeeEmail;

  EMODetailsDialog(
      {required this.emoValue,
      required this.commission,
      required this.amountPaid,
      required this.senderName,
      required this.senderAddress,
      required this.senderPinCode,
      required this.senderCity,
      required this.senderState,
      required this.senderMobileNumber,
      required this.senderEmail,
      required this.payeeName,
      required this.payeeAddress,
      required this.payeePinCode,
      required this.payeeCity,
      required this.payeeState,
      required this.payeeMobileNumber,
      required this.payeeEmail});

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
            DoubleSpace(),
            Padding(
              padding: EdgeInsets.only(left: 20.0.toDouble()),
              child: DialogText(
                  title: 'Amount to be collected :- ',
                  subtitle: '\u{20B9} $amountPaid'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  'Sender & Addressee Details',
                  style: TextStyle(color: ColorConstants.kTextColor),
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DialogText(title: 'Sender : ', subtitle: '$senderName'),
                      Space(),
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
                      Space(),
                      senderMobileNumber!.isNotEmpty
                          ? DialogText(
                              title: 'Mob# : ',
                              subtitle: senderMobileNumber!,
                            )
                          : Container(),
                      Space(),
                      senderEmail!.isNotEmpty
                          ? DialogText(
                              title: 'Email ID : ',
                              subtitle: senderEmail!,
                            )
                          : Container(),
                      DoubleSpace(),
                      DialogText(title: 'Addressee : ', subtitle: payeeName!),
                      Space(),
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
                      Space(),
                      payeeMobileNumber!.isNotEmpty
                          ? DialogText(
                              title: 'Mob# : ',
                              subtitle: payeeMobileNumber!,
                            )
                          : Container(),
                      Space(),
                      payeeEmail!.isNotEmpty
                          ? DialogText(
                              title: 'Email ID : ',
                              subtitle: payeeEmail!,
                            )
                          : Container(),
                      Space(),
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
