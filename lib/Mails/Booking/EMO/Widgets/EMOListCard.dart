import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class EMOListCard extends StatelessWidget {
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

  EMOListCard(
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DialogText(
                          title: 'EMO Value\n',
                          subtitle: '\u{20B9}' + emoValue!.toString()),
                      commission! != 'null'
                          ? DialogText(
                              title: 'Commission\n',
                              subtitle: '\u{20B9}' + commission!.toString())
                          : Container(),
                      DialogText(
                          title: 'Amount Paid\n',
                          subtitle: '\u{20B9}' + amountPaid!.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0.toDouble()),
                  child: DottedLine(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: DialogText(
                        title: 'Sender name\n',
                        subtitle: senderName!,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/images/ic_post_sending.png',
                          height: 50.toDouble(),
                        )),
                    Expanded(
                      flex: 1,
                      child: DialogText(
                        title: 'Payee name\n',
                        subtitle: payeeName!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
