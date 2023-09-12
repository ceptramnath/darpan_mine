import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashCard extends StatelessWidget {
  String? cashId;
  String? date;
  String? time;
  String? amount;
  String? type;
  String? description;

  CashCard(
      {Key? key,
      required this.cashId,
      required this.date,
      required this.time,
      required this.amount,
      required this.description,
      required this.type})
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
                  color: Colors.black26,
                  width: 5.toDouble(),
                  style: BorderStyle.solid),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0.toDouble()),
            child: Column(
              children: [
                ListTile(
                  leading: cashIcon(),
                  title: Text(
                    description!,
                    style: const TextStyle(color: ColorConstants.kTextColor),
                  ),
                  subtitle: getDate(),
                  trailing: Text(
                    '\u{20B9} ${amount!}\n',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColorConstants.kTextDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDate() {
    DateTime receivedDate = DateFormat("dd-MM-yyyy").parse(date!);
    final dateNow = DateTime.now();
    final difference = daysBetween(receivedDate, dateNow);
    if (date == DateTimeDetails().onlyDate()) {
      return Text(time!);
    } else {
      return Text(date!);
    }
  }

  daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  ///A widget to display the particular icons according to the description
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
    } else if (description.toString().endsWith('Stamp')) {
      return Image.asset('assets/images/ic_cash_stamp.png');
    } else if (description == 'Register Letter cancelled') {
      return Image.asset('assets/images/ic_cash_cancel_letter.png');
    } else if (description == 'Excess Cash to A.O') {
      return Image.asset('assets/images/ic_cash_to_ao.png');
    } else if (description == 'Biller Collection') {
      return Image.asset('assets/images/ic_cash_biller.png');
    } else if (description!.contains('Bag')) {
      return Image.asset('assets/images/ic_cash_bag.png');
    } else if (description == 'Cash From AO') {
      return Image.asset('assets/images/ic_cash_ao.png');
    } else if (description == 'Cash To A.O') {
      return Image.asset('assets/images/ic_cash_to_ao.jpeg');
    } else if (description!.contains('Stamp')) {
      return Image.asset('assets/images/ic_cash_stamp.png');
    } else if (description!.contains('Biller Collection')) {
      return Image.asset('assets/images/ic_cash_biller.png');
    } else if (description!.contains('Special Remittance')) {
      return Image.asset('assets/images/ic_cash_speed.png');
    } else if (description!.contains('Cash To A.O Revert')) {
      return Image.asset('assets/images/ic_cash_ao.png');
    }
    return Image.asset('assets/images/ic_cash_add.png');
  }
}
