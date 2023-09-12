// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/DatabaseModel/transtable.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
// import 'package:darpan_mine/Mails/Booking/Reports/BODAReports/BODASlipScreen.dart';
// import 'package:darpan_mine/Mails/Booking/Reports/ReportsMainScreen.dart';
// import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
// import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/LetterForm.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GenerateBODAReportScreen extends StatefulWidget {
//   const GenerateBODAReportScreen({Key? key}) : super(key: key);
//
//   @override
//   _GenerateBODAReportScreenState createState() =>
//       _GenerateBODAReportScreenState();
// }
//
// class _GenerateBODAReportScreenState extends State<GenerateBODAReportScreen> {
//   String? selectedLiability;
//   String savedCashToAO = '';
//
//   bool _balanceVisible = false;
//
//   double walletAmount = 0.0;
//   double liability = 0.0;
//
//   List liabilities = [];
//   List liabilityCategories = [];
//   List liabilityAccountNumber = [];
//   List liabilityAmount = [];
//   List mailsLiability = [];
//   List mailsAmountLiability = [];
//   List<String> liabilityTypes = ['EMO', 'Banking', 'Insurance'];
//
//   final aoRequestCashController = TextEditingController();
//   final aoConfirmCashController = TextEditingController();
//   final liabilityReasonController = TextEditingController();
//   final weightController = TextEditingController();
//   final liabilityAmountController = TextEditingController();
//   final liabilityNumberController = TextEditingController();
//
//   final aoRequestCashFocus = FocusNode();
//   final aoConfirmCashFocus = FocusNode();
//   final liabilityReasonFocus = FocusNode();
//   final weightFocus = FocusNode();
//
//   getWalletAmount() async {
//     final aoCash = await CashTable()
//         .select()
//         .Cash_Date
//         .equals(DateTimeDetails().currentDate())
//         .and
//         .Cash_Description
//         .equals('Cash To A.O')
//         .toMapList();
//     if (aoCash.isNotEmpty) {
//       savedCashToAO = aoCash[aoCash.length - 1]['Cash_Amount'].toString();
//     }
//     final liability = await Liability()
//         .select()
//         .Date
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (liability.isNotEmpty) {
//       liabilityReasonController.text = liability[0]['Description'];
//     }
//     final cashDetails = await BodaSlip()
//         .select()
//         .bodaDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (cashDetails.isNotEmpty) {
//       aoConfirmCashController.text = cashDetails[0]['cashTo'];
//       aoRequestCashController.text = cashDetails[0]['cashFrom'];
//     }
//     final indent = await CashIndent()
//         .select()
//         .SOGenerationDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (indent.isNotEmpty) {
//       weightController.text = indent[0]['Weight'];
//     }
//
//     final prefs = await SharedPreferences.getInstance();
//     final String? aoRequestValue = prefs.getString('aoRequest');
//     final String? aoConfirmValue = prefs.getString('aoConfirm');
//     final String? aoWeightValue = prefs.getString('aoWeight');
//     if (aoRequestValue.toString() != 'null') {
//       aoRequestCashController.text = aoRequestValue!;
//     }
//     if (aoConfirmValue.toString() != 'null') {
//       aoConfirmCashController.text = aoConfirmValue!;
//     }
//     if (aoWeightValue.toString() != 'null') {
//       weightController.text = aoWeightValue!;
//     }
//     walletAmount = await CashService().cashBalance();
//     liabilities = await TempLiability().select().toMapList();
//     return liabilities;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         moveToPrevious(context);
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: ColorConstants.kBackgroundColor,
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
//                   (route) => false);
//             },
//           ),
//           elevation: 0,
//           title: const Text('BODA Report'),
//           backgroundColor: ColorConstants.kPrimaryColor,
//         ),
//         body: FutureBuilder(
//           future: getWalletAmount(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //Step 1
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 'Balance : ${walletAmount.toString()}',
//                                 style: TextStyle(fontSize: 15),
//                               ),
//                               Text(
//                                 '(Max amount : $maxAmount)',
//                                 style: TextStyle(fontSize: 10),
//                               ),
//                               Container(
//                                 width: 90,
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(
//                                         color: ColorConstants.kPrimaryColor),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const DoubleSpace(),
//                         walletAmount > maxAmount
//                             ? Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Excess',
//                                         style: headingTextStyle(),
//                                       ),
//                                       Text(
//                                         '\u{20B9}' + getBalance(),
//                                         style: TextStyle(
//                                             letterSpacing: 1,
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w500,
//                                             color:
//                                                 ColorConstants.kPrimaryColor),
//                                       )
//                                     ],
//                                   ),
//                                   const Space(),
//                                   Text(
//                                     'Closing balance of Varuna B.O exceeds the maximum sanctioned amount of \u{20B9}$maxAmount limit by \u{20B9}${getBalance()}.\n',
//                                     style: headingTextStyle(),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         Row(
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Text('Cash to AO',
//                                     style: headingTextStyle())),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               child: const Text(':'),
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8.0.toDouble(),
//                                       horizontal: 3.0.toDouble()),
//                                   child: TextFormField(
//                                     autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                     controller: aoConfirmCashController,
//                                     style: const TextStyle(
//                                         color: ColorConstants.kSecondaryColor),
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                         counterText: '',
//                                         fillColor: ColorConstants.kWhite,
//                                         filled: true,
//                                         enabledBorder: const OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: ColorConstants.kWhite),
//                                         ),
//                                         prefixIcon: const Icon(
//                                           MdiIcons.currencyInr,
//                                           color: ColorConstants.kSecondaryColor,
//                                         ),
//                                         suffixIcon: IconButton(
//                                           icon: const Icon(
//                                             MdiIcons.closeCircleOutline,
//                                             color:
//                                                 ColorConstants.kSecondaryColor,
//                                           ),
//                                           onPressed: () {
//                                             aoConfirmCashController.clear();
//                                             FocusScope.of(context).unfocus();
//                                           },
//                                         ),
//                                         isDense: true,
//                                         border: InputBorder.none,
//
//                                         // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//                                         focusedBorder: const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: ColorConstants.kWhite))),
//                                     validator: (text) {},
//                                   ),
//                                 ))
//                           ],
//                         ),
//                         walletAmount > maxAmount
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Space(),
//                                   TextFormField(
//                                     focusNode: liabilityReasonFocus,
//                                     controller: liabilityReasonController,
//                                     decoration: const InputDecoration(
//                                         counterText: '',
//                                         fillColor: ColorConstants.kWhite,
//                                         filled: true,
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: ColorConstants.kWhite),
//                                         ),
//                                         prefixIcon: Icon(
//                                           Icons.description,
//                                           color: ColorConstants.kSecondaryColor,
//                                         ),
//                                         labelStyle: TextStyle(
//                                             color: ColorConstants
//                                                 .kAmberAccentColor),
//                                         labelText: 'Liability Reason',
//                                         isDense: true,
//                                         border: InputBorder.none,
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: ColorConstants.kWhite))),
//                                     minLines: 5,
//                                     maxLines: null,
//                                   ),
//                                   const DoubleSpace(),
//                                 ],
//                               )
//                             : Container(),
//                         Row(
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Text('Cash bag weight : ',
//                                     style: headingTextStyle())),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               child: const Text(':'),
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8.0.toDouble(),
//                                       horizontal: 3.0.toDouble()),
//                                   child: CInputForm(
//                                       readOnly: false,
//                                       iconData: MdiIcons.weight,
//                                       labelText: 'Weight',
//                                       controller: weightController,
//                                       textType: TextInputType.number,
//                                       typeValue: 'Weight',
//                                       focusNode: weightFocus),
//                                 ))
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                                 flex: 1,
//                                 child: Text('Cash Indent from AO for Liability',
//                                     style: headingTextStyle())),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10),
//                               child: const Text(':'),
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8.0.toDouble(),
//                                       horizontal: 3.0.toDouble()),
//                                   child: CInputForm(
//                                       readOnly: false,
//                                       iconData: MdiIcons.currencyInr,
//                                       labelText: 'Cash',
//                                       controller: aoRequestCashController,
//                                       textType: TextInputType.number,
//                                       typeValue: 'Amount',
//                                       focusNode: aoRequestCashFocus),
//                                 ))
//                           ],
//                         ),
//                         const DoubleSpace(),
//                       ],
//                     ),
//                     const DoubleSpace(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Button(
//                             buttonText: 'CANCEL',
//                             buttonFunction: () => moveToPrevious(context)),
//                         Button(
//                             buttonText: 'CONFIRM',
//                             buttonFunction: () async {
//                               getBODAConfirm();
//                             })
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void moveToPrevious(BuildContext context) {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
//         (route) => false);
//   }
//
//   void moveToNext(BuildContext context) async {
//     await BookingDBService().addCashIndent(
//         DateTimeDetails().dateCharacter(),
//         aoConfirmCashController.text.isNotEmpty
//             ? aoConfirmCashController.text
//             : '',
//         weightController.text.isNotEmpty ? weightController.text : '');
//     var currentDate = DateTimeDetails().onlyDate();
//     final saveBODA = BodaSlip()
//       ..bodaDate = currentDate
//       ..bodaNumber = 'BO213081100010${currentDate.replaceAll(RegExp('-'), '')}'
//       ..cashFrom = aoRequestCashController.text
//       ..cashTo = aoConfirmCashController.text;
//     saveBODA.save();
//     final deleteAll = await TempLiability().select().delete();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const BODASlipScreen()),
//         (route) => false);
//   }
//
//   headingTextStyle() {
//     return TextStyle(
//         letterSpacing: 1,
//         fontSize: 15,
//         fontWeight: FontWeight.w500,
//         color: ColorConstants.kTextColor);
//   }
//
//   tableHeadingTextStyle() {
//     return TextStyle(
//         letterSpacing: 1,
//         fontSize: 13,
//         fontWeight: FontWeight.w500,
//         color: ColorConstants.kTextColor);
//   }
//
//   getBalance() {
//     int aoAmount = 0;
//     int liabilityAmount = 0;
//     var balance;
//     if (aoConfirmCashController.text.isNotEmpty) {
//       aoAmount = int.parse(aoConfirmCashController.text);
//     }
//     if (liabilityAmountController.text.isNotEmpty) {
//       liabilityAmount = int.parse(liabilityAmountController.text);
//     }
//     if (savedCashToAO.isNotEmpty) {
//       if (double.parse(savedCashToAO) ==
//           double.parse(aoConfirmCashController.text.trim())) {
//         balance = walletAmount - maxAmount - liabilityAmount;
//       } else {
//         balance = walletAmount - maxAmount - liabilityAmount - aoAmount;
//       }
//     } else {
//       balance = walletAmount - maxAmount - liabilityAmount - aoAmount;
//     }
//     if (balance < 0) {
//       return '0';
//     } else {
//       return balance.toString();
//     }
//   }
//
//   getBODAConfirm() async {
//     if (savedCashToAO.isNotEmpty) {
//       if (double.parse(savedCashToAO) !=
//           double.parse(aoConfirmCashController.text.trim())) {
//         final savedCashToAO = await CashTable()
//             .select()
//             .Cash_Date
//             .equals(DateTimeDetails().currentDate())
//             .and
//             .Cash_Description
//             .equals('Cash To A.O')
//             .toMapList();
//         walletAmount = walletAmount + savedCashToAO[0]['Cash_Amount'];
//       }
//     }
//     double excess = double.parse(getBalance());
//     //when
//     if (excess > 0) {
//       if (liabilityReasonController.text.isEmpty) {
//         liabilityReasonFocus.requestFocus();
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Note!'),
//                 content: Text(
//                     'Please fill in the Liability Reason as still \u{20B9} ${getBalance()} is remained as Excess, which will be made as Liability'),
//                 actions: [
//                   Button(
//                       buttonText: 'OKAY',
//                       buttonFunction: () {
//                         Navigator.pop(context);
//                       }),
//                 ],
//               );
//             });
//       } else {
//         liability = excess.toDouble();
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: const Text('Note!'),
//                 content: Text(
//                     '\u{20B9} $excess is remained as Excess will be made as Liability'),
//                 actions: [
//                   Button(
//                       buttonText: 'OKAY',
//                       buttonFunction: () {
//                         Navigator.pop(context);
//                         addBODA();
//                       }),
//                 ],
//               );
//             });
//       }
//     } else {
//       addBODA();
//     }
//   }
//
//   addBODA() async {
//     var currentDate = DateTimeDetails().currentDate();
//     if (savedCashToAO.isNotEmpty) {
//       print("Step 1");
//       if (double.parse(savedCashToAO) !=
//           double.parse(aoConfirmCashController.text.trim())) {
//         final addAOCash = CashTable()
//           ..Cash_ID = "CASHTOAO" + DateTimeDetails().currentDateTime()
//           ..Cash_Date = DateTimeDetails().currentDate()
//           ..Cash_Time = DateTimeDetails().onlyTime()
//           ..Cash_Type = 'Add'
//           ..Cash_Amount = double.parse(savedCashToAO)
//           ..Cash_Description = 'Cash To A.O Revert';
//         addAOCash.save();
//       }
//       print("Step 1 end");
//     }
//
//     if (aoConfirmCashController.text.isNotEmpty) {
//       // if (aoCash.isEmpty) {
//       final addAOCash = CashTable()
//         ..Cash_ID = "CASHTOAO" + DateTimeDetails().currentDateTime()
//         ..Cash_Date = DateTimeDetails().currentDate()
//         ..Cash_Time = DateTimeDetails().onlyTime()
//         ..Cash_Type = 'Minus'
//         ..Cash_Amount = double.parse(aoConfirmCashController.text)
//         ..Cash_Description = 'Cash To A.O';
//       addAOCash.save();
//       // } else {
//       //   final addAOCash = CashTable()
//       //     ..Cash_ID = aoCash[0]['Cash_ID']
//       //     ..Cash_Date = aoCash[0]['Cash_Date']
//       //     ..Cash_Time = aoCash[0]['Cash_Time']
//       //     ..Cash_Type = 'Minus'
//       //     ..Cash_Amount = double.parse(aoConfirmCashController.text)
//       //     ..Cash_Description = 'Cash To A.O';
//       //   addAOCash.upsert();
//       //   // await CashTable().select().startBlock.Cash_Description.equals('Cash to AO')
//       //   //     .and.Cash_Date.equals(DateTimeDetails().currentDate()).endBlock.update({"Cash_Time" : DateTimeDetails().onlyTime(), 'Cash_Amount' : double.parse(aoConfirmCashController.text)});
//       //   // await Delivery().select().ART_NUMBER.equals(_articlesToDisplay[i].ART_NUMBER).update({
//       //   //   "invoiceDate": DateTimeDetails().onlyDate(), 'reasonNonDelivery':null});
//       // }
//
//       final aoTransaction = await TransactionTable()
//           .select()
//           .tranDate
//           .equals(DateTimeDetails().currentDate())
//           .toMapList();
//       if (aoTransaction.isEmpty) {
//         final addTransaction = TransactionTable()
//           ..tranid = "CASHTOAO" + DateTimeDetails().currentDateTime()
//           ..tranType = 'Cash To AO'
//           ..tranDescription = 'Cash to A.O'
//           ..tranDate = DateTimeDetails().currentDate()
//           ..tranTime = DateTimeDetails().onlyTime()
//           ..valuation = 'Minus';
//         await addTransaction.save();
//       } else {
//         await TransactionTable()
//             .select()
//             .tranDate
//             .equals(DateTimeDetails().currentDate())
//             .delete();
//         final addTransaction = TransactionTable()
//           ..tranid = "CASHTOAO" + DateTimeDetails().currentDateTime()
//           ..tranType = 'Cash To AO'
//           ..tranDescription = 'Cash to A.O'
//           ..tranDate = DateTimeDetails().currentDate()
//           ..tranTime = DateTimeDetails().onlyTime()
//           ..valuation = 'Minus';
//         await addTransaction.save();
//       }
//     }
//
//     await BookingDBService().addCashIndent(
//         DateTimeDetails().dateCharacter(),
//         aoConfirmCashController.text.isEmpty
//             ? '0'
//             : aoConfirmCashController.text,
//         weightController.text.isEmpty ? weightController.text : '');
//
//     final letters = await LetterBooking()
//         .select()
//         .BookingDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (letters.isNotEmpty) {
//       for (int i = 0; i < letters.length; i++) {
//         final bodaArticles = BodaArticle()
//           ..ArticleNumber = letters[i]['ArticleNumber']
//           ..ArticleType = letters[i]['ProductCode']
//           ..ArticleAmount = letters[i]['TotalAmount']
//           ..BodaDate = DateTimeDetails().currentDate()
//           ..BodaTime = DateTimeDetails().onlyTime();
//         bodaArticles.upsert();
//       }
//     }
//
//     final parcel = await ParcelBooking()
//         .select()
//         .BookingDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (parcel.isNotEmpty) {
//       for (int i = 0; i < parcel.length; i++) {
//         final bodaArticles = BodaArticle()
//           ..ArticleNumber = parcel[i]['ArticleNumber']
//           ..ArticleType = parcel[i]['ProductCode']
//           ..ArticleAmount = parcel[i]['TotalAmount']
//           ..BodaDate = DateTimeDetails().currentDate()
//           ..BodaTime = DateTimeDetails().onlyTime();
//         bodaArticles.upsert();
//       }
//     }
//
//     final speed = await SpeedBooking()
//         .select()
//         .BookingDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (speed.isNotEmpty) {
//       for (int i = 0; i < speed.length; i++) {
//         final bodaArticles = BodaArticle()
//           ..ArticleNumber = speed[i]['ArticleNumber']
//           ..ArticleType = speed[i]['ProductCode']
//           ..ArticleAmount = speed[i]['TotalAmount']
//           ..BodaDate = DateTimeDetails().currentDate()
//           ..BodaTime = DateTimeDetails().onlyTime();
//         bodaArticles.upsert();
//       }
//     }
//
//     final emo = await EmoBooking()
//         .select()
//         .BookingDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (emo.isNotEmpty) {
//       for (int i = 0; i < emo.length; i++) {
//         final bodaArticles = BodaArticle()
//           ..ArticleNumber = emo[i]['ArticleNumber']
//           ..ArticleType = emo[i]['ProductCode']
//           ..ArticleAmount = emo[i]['TotalAmount']
//           ..BodaDate = DateTimeDetails().currentDate()
//           ..BodaTime = DateTimeDetails().onlyTime();
//         bodaArticles.upsert();
//       }
//     }
//
//     final inventory = await BagStampsTable()
//         .select()
//         .StampDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (inventory.isNotEmpty) {
//       for (int i = 0; i < inventory.length; i++) {
//         final bodaInventory = BodaInventory()
//           ..inventoryid =
//               inventory[i]['StampName'] + DateTimeDetails().currentDate()
//           ..InventoryName = inventory[i]['StampName']
//           ..InventoryDate = DateTimeDetails().currentDate()
//           ..InventoryPrice = inventory[i]['StampPrice']
//           ..InventoryQuantity = inventory[i]['StampQuantity'];
//         bodaInventory.upsert();
//       }
//     }
//
//     final saveLiability = Liability()
//       ..Description = liabilityReasonController.text.trim()
//       ..Date = DateTimeDetails().currentDate()
//       ..Amount = getBalance().toString();
//     saveLiability.upsert();
//
//     final saveBODA = BodaSlip()
//       ..bodaDate = currentDate
//       ..bodaNumber = 'BO213081100010${currentDate.replaceAll(RegExp('-'), '')}'
//       ..cashFrom = aoRequestCashController.text.isEmpty
//           ? '0'
//           : aoRequestCashController.text
//       ..cashTo = aoConfirmCashController.text.isEmpty
//           ? '0'
//           : aoConfirmCashController.text;
//     saveBODA.upsert();
//
//     /*final dayDetail = await DayModel()
//         .select()
//         .DayBeginDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     if (dayDetail.isEmpty) {
//       final dayDetail = await DayModel()
//           .select()
//           .DayBeginDate
//           .equals(DateTimeDetails().previousDate())
//           .toMapList();
//       final updateDayEnd = DayModel()
//         ..DayBeginDate = dayDetail[0]['DayBeginDate']
//         ..DayBeginTime = dayDetail[0]['DayBeginTime']
//         ..CashOpeningBalance = dayDetail[0]['CashOpeningBalance']
//         ..CashClosingBalance = (walletAmount -
//             (aoConfirmCashController.text.isEmpty
//                 ? 0
//                 : double.parse(aoConfirmCashController.text)))
//             .toString()
//         ..DayCloseDate = DateTimeDetails().currentDate()
//         ..DayCloseTime = DateTimeDetails().onlyTime();
//       updateDayEnd.upsert();
//     } else {
//       final updateDayEnd = DayModel()
//         ..DayBeginDate = dayDetail[0]['DayBeginDate']
//         ..DayBeginTime = dayDetail[0]['DayBeginTime']
//         ..CashOpeningBalance = dayDetail[0]['CashOpeningBalance']
//         ..CashClosingBalance = (walletAmount -
//             (aoConfirmCashController.text.isEmpty
//                 ? 0.0
//                 : double.parse(aoConfirmCashController.text)))
//             .toString()
//         ..DayCloseDate = DateTimeDetails().currentDate()
//         ..DayCloseTime = DateTimeDetails().onlyTime();
//       updateDayEnd.upsert();
//     }*/
//
//     final dailyInventory = await InventoryDailyTable()
//         .select()
//         .RecordedDate
//         .equals(DateTimeDetails().currentDate())
//         .toMapList();
//     var fromProductsMain = await ProductsTable().select().toMapList();
//     if (dailyInventory.isEmpty) {
//       for (int i = 0; i < fromProductsMain.length; i++) {
//         final addDailyInventory = InventoryDailyTable()
//           ..InventoryId = fromProductsMain[i]['ProductID']
//           ..StampName = fromProductsMain[i]['Name']
//           ..Price = fromProductsMain[i]['Price']
//           ..RecordedDate = DateTimeDetails().currentDate()
//           ..OpeningQuantity = '0'
//           ..OpeningValue = '0'
//           ..ClosingQuantity = fromProductsMain[i]['Quantity']
//           ..ClosingValue = fromProductsMain[i]['Value'];
//         addDailyInventory.upsert();
//       }
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
//
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const BODASlipScreen()),
//         (route) => false);
//   }
//
//   walletBalance() {
//     if (aoConfirmCashController.text.isNotEmpty) {
//       return (walletAmount - int.parse(aoConfirmCashController.text))
//           .toString();
//     } else {
//       return walletAmount.toString();
//     }
//   }
// }
