import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class RLDetailsDialog extends StatelessWidget {
  String? articleNumber;
  String? weight;
  String? weightAmount;
  String? prepaidAmount;
  String? acknowledgement;
  String? insurance;
  String? valuePayablePost;
  String? registrationFee;
  String? amountToBeCollected;
  String? senderName;
  String? senderAddress;
  String? senderPinCode;
  String? senderCity;
  String? senderState;
  String? senderMobileNumber;
  String? senderEmail;
  String? addresseeName;
  String? addresseeAddress;
  String? addresseePinCode;
  String? addresseeCity;
  String? addresseeState;
  String? addresseeMobileNumber;
  String? addresseeEmail;

  RLDetailsDialog(
      {Key? key,
      required this.articleNumber,
      required this.weightAmount,
      required this.weight,
      required this.prepaidAmount,
      required this.acknowledgement,
      required this.insurance,
      required this.valuePayablePost,
      required this.registrationFee,
      required this.amountToBeCollected,
      required this.senderName,
      required this.senderAddress,
      required this.senderPinCode,
      required this.senderCity,
      required this.senderState,
      required this.senderMobileNumber,
      required this.senderEmail,
      required this.addresseeName,
      required this.addresseeAddress,
      required this.addresseePinCode,
      required this.addresseeCity,
      required this.addresseeState,
      required this.addresseeMobileNumber,
      required this.addresseeEmail})
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
                        flex: 2,
                        child: Image.asset('assets/images/ic_logo.png')),
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
                          const Space(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DialogText(
                                  title: 'Weight\n\n', subtitle: '$weight gms'),
                              DialogText(
                                  title: 'Weight \nAmount\n',
                                  subtitle: '\u{20B9} $weightAmount'),
                            ],
                          ),
                          const Space(),
                          DialogText(
                              title: 'Prepaid Amount : ',
                              subtitle: '\u{20B9} $prepaidAmount'),
                          const Space(),
                          Row(
                            children: [
                              Expanded(
                                flex: acknowledgement != '0' ? 1 : 0,
                                child: Visibility(
                                  visible: acknowledgement != '0'
                                      ? true
                                      : insurance != '0'
                                          ? true
                                          : false,
                                  child: DialogText(
                                      title: 'Acknowledge\nAmount\n',
                                      subtitle: insurance != '0'
                                          ? '\u{20B9} 0'
                                          : '\u{20B9} 3'),
                                ),
                              ),
                              Expanded(
                                flex: insurance != '0' ? 1 : 0,
                                child: Visibility(
                                  visible: insurance != '0' ? true : false,
                                  child: DialogText(
                                      title: 'Insurance\nAmount\n',
                                      subtitle: '\u{20B9} $insurance'),
                                ),
                              ),
                              Expanded(
                                flex: valuePayablePost != '0' ? 1 : 0,
                                child: Visibility(
                                  visible:
                                      valuePayablePost != '0' ? true : false,
                                  child: DialogText(
                                      title: 'VPP\nAmount\n',
                                      subtitle: '\u{20B9} $valuePayablePost'),
                                ),
                              ),
                            ],
                          ),
                          const Space(),
                          DialogText(
                              title: 'Register Letter fee : ',
                              subtitle: '\u{20B9} $registrationFee'),
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
                                    title: 'Sender : ',
                                    subtitle: '$senderName'),
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
                                const Space(),
                                senderMobileNumber!.isNotEmpty
                                    ? DialogText(
                                        title: 'Mob# : ',
                                        subtitle: senderMobileNumber!,
                                      )
                                    : Container(),
                                const Space(),
                                senderEmail!.isNotEmpty
                                    ? DialogText(
                                        title: 'Email ID : ',
                                        subtitle: senderEmail!,
                                      )
                                    : Container(),
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
                                const Space(),
                                addresseeMobileNumber!.isNotEmpty
                                    ? DialogText(
                                        title: 'Mob# : ',
                                        subtitle: addresseeMobileNumber!,
                                      )
                                    : Container(),
                                const Space(),
                                addresseeEmail!.isNotEmpty
                                    ? DialogText(
                                        title: 'Email ID : ',
                                        subtitle: addresseeEmail!,
                                      )
                                    : Container(),
                                const Space(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
            ]),
      );
}
