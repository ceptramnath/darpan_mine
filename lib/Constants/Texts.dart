import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
//import 'package:darpan_mine/Constants/Texts.dart';

import 'Color.dart';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

const String directory = "storage/emulated/0/Darpan_Mine/";
const String dataDirectory = "storage/emulated/0/Darpan_Mine/Uploads";

String pmoMessage = 'PM Relief Fund';

final formatCurrency =
    NumberFormat.currency(locale: "en_IN", symbol: "\u{20B9}");

List<String> messageCodes = [
  'VPMO',
  'Money for treatment of illness',
  'Wish you speedy recovery',
  'Money for payment of loan',
  'Money for your admission',
  'Wish you success in your study',
  'Money for your books',
  'Hearty congratulations on success in examination',
  'Confirm receipt of money order',
  'Do not waste money, use cautiously',
  'I am ok, write about your well being',
  'Humble offering to the Lord',
  'If you need more money, let me know',
  'Happy birthday! Get a gift of your choice',
  'Shagun for marriage',
  'Shagun for thread Ceremony',
  'Id Mubarak',
  'Humble offering for Rakhi',
  'Humble offering for Bhai Dooj',
  'Humble offering on thread ceremony',
  'Shagun on Grehapravesh',
  'Happy wedding anniversary! Get a gift of your choice',
  'RTI charges'
];
List<String> fiveRsStamps = ['fiveRsStamps1', 'fiveRsStamps2'];
List<String> sevenRsStamps = ['sevenRsStamps1', 'sevenRsStamps2'];
List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
List<String> holidayLeaves = ['Not Feeling well', 'Vacation'];
List<String> receiptReason = ['Lost & Found', 'Travel'];
List<String> heading = ['Mails', 'Banking', 'Insurance'];
List<String> headingImages = [
  'assets/images/mails.png',
  'assets/images/bank.png',
  'assets/images/insurance.png'
];
List<String> mailOptions = ['Booking', 'Delivery', 'Bagging'];
List<String> mailOptionsImages = [
  'assets/images/book.png',
  'assets/images/delivery.png',
  'assets/images/bagging.png'
];
List<String> bookingOptions = [
  'Regd. Letter',
  'Speed Post',
  'EMO',
  'Regd. Parcel',
  'Transactions'
];
List<String> bookingOptionsImages = [
  'assets/images/regd_letter.png',
  'assets/images/speedpost.png',
  'assets/images/emo.png',
  'assets/images/regd_parcel.png',
  'assets/images/accountable_articles.png'
];
List<String> deliveryOptions = ['Acc. Articles', 'EMO'];
List<String> deliveryOptionsImages = [
  'assets/images/accountable_articles.png',
  'assets/images/emo.png'
];
List<String> baggingOptions = [
  'Bag Receive',
  'Bag Open',
  'Bag Create',
  'Bag Close',
  'Bag Dispatch',
  'Bag Info',
  'Bag Tracking'
];
List<String> baggingOptionsImages = [
  'assets/images/receive.png',
  'assets/images/open.png',
  'assets/images/create.png',
  'assets/images/close.png',
  'assets/images/dispatched.png',
  'assets/images/info.png',
  'assets/images/tracking.png'
];
List<String> bankingOptions = ['Savings Bank', 'RD', 'SSA', 'TD'];
List<String> bankingOptionsImages = ['assets/images/bank.png'];
List<String> savingsBankOptions = ['Deposit', 'Withdraw'];
List<String> savingsBankOptionsImages = [
  'assets/images/deposit.png',
  'assets/images/withdraw.png'
];
List<String> insuranceOptions = [
  'Premium Collection',
  'New Business Quotes',
  'Proposal Indexing',
  'Quote Generation',
  'Policy Search',
  'Service Request Indexing'
];
List<String> insuranceOptionsImages = [
  'assets/images/premium_collector.png',
  'assets/images/index.png'
];
List<String> cashType = ['Cash', 'Cheque'];
List<String> gender = ['Male', 'Female'];

class TabTextStyle extends StatelessWidget {
  final String title;

  const TabTextStyle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: ColorConstants.kWhite,
          fontSize: 15.toDouble(),
          letterSpacing: 2),
    );
  }
}

const bagJson = {
  "bagNumber": "LBK1234567890",
  "articlesInBag": [
    "RK988517896IN",
    "RK988517905IN",
    "RK988517919IN",
    "RK988517922IN",
    "RK988517936IN",
    "RK988517940IN",
    "RK988517825IN",
    "RK988517817IN",
    "RK988517803IN",
    "RK988517794IN",
    "RK988517785IN",
    "RK988517777IN",
    "RK988517701IN",
    "RK988517692IN",
    "RK988517689IN",
    "RK988517675IN",
    "RK988517661IN"
  ]
};
