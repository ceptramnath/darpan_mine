import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionCard extends StatelessWidget {
  String? id;
  String? type;
  String? description;
  String? date;
  String? time;
  String? valuation;

  TransactionCard(
      {Key? key,
      required this.id,
      required this.date,
      required this.time,
      required this.type,
      required this.description,
      required this.valuation})
      : super(key: key);

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
                RichText(
                  text: TextSpan(
                    text: 'Transaction# :  ',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: id!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    leading: cashIcon(),
                    title: Text(
                      type!,
                      style: const TextStyle(color: ColorConstants.kTextColor),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description!,
                            style: const TextStyle(
                                color: ColorConstants.kTextDark,
                                fontWeight: FontWeight.w500),
                          ),
                          Text('$date, $time')
                        ],
                      ),
                    ),
                    // trailing: Text('\u{20B9} ${amount!}\n', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: ColorConstants.kTextDark),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cashIcon() {
    if (description == 'Bag Receive') {
      return Image.asset('assets/images/ic_cash_bag.png');
    } else if (description == 'Register Letter Booking') {
      return Image.asset('assets/images/ic_cash_letter.png');
    } else if (description == 'Speed Booking') {
      return Image.asset('assets/images/ic_cash_speed.png');
    } else if (description == 'EMO Booking' || description == 'PMO Booking') {
      return Image.asset('assets/images/ic_cash_emo.png');
    } else if (description == 'Parcel Booking') {
      return Image.asset('assets/images/ic_cash_parcel.png');
    } else if (description!.contains('Stamp')) {
      return Image.asset('assets/images/ic_cash_stamp.png');
    } else if (description == 'Register Letter cancelled') {
      return Image.asset('assets/images/ic_cash_cancel_letter.png');
    } else if (description == 'Excess Cash to A.O') {
      return Image.asset('assets/images/ic_cash_to_ao.png');
    } else if (description == 'Biller Collection') {
      return Image.asset('assets/images/ic_cash_biller.png');
    } else if (description == 'Booking Article Cancel') {
      return Image.asset('assets/images/ic_cash_cancel_letter.png');
    } else if (description == 'Cash received from Bag') {
      return Image.asset('assets/images/ic_cash_bag.png');
    } else if (description == 'Cash from AO') {
      return Image.asset('assets/images/ic_cash_ao.png');
    } else if (description == 'Cash to A.O') {
      return Image.asset('assets/images/ic_cash_to_ao.jpeg');
    } else if (description!.contains('Biller Collection')) {
      return Image.asset('assets/images/ic_cash_biller.png');
    } else if (description!.contains('Special Remittance')) {
      return Image.asset('assets/images/ic_cash_speed.png');
    }
    return Image.asset('assets/images/ic_cash_add.png');
  }
}
