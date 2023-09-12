// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
// import 'package:darpan_mine/Mails/Booking/Reports/GenerateBODA/BODASlipScreen.dart';
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
// class BODA24052022 extends StatefulWidget {
//   const BODA24052022({Key? key}) : super(key: key);
//
//   @override
//   _BODA24052022State createState() => _BODA24052022State();
// }
//
// class _BODA24052022State extends State<BODA24052022> {
//   String? selectedLiability;
//
//   bool _isVisible = false;
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
//   final _liabilityKey = GlobalKey<FormState>();
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
//   final liabilityNumberFocus = FocusNode();
//   final liabilityAmountFocus = FocusNode();
//   final weightFocus = FocusNode();
//
//   getWalletAmount() async {
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
//               padding: EdgeInsets.all(15),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     //Step 1
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Align(
//                             alignment: Alignment.bottomRight,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   'Balance : ${walletAmount.toString()}',
//                                   style: TextStyle(fontSize: 15),
//                                 ),
//                                 Text(
//                                   '(Max amount : $maxAmount)',
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                                 Container(
//                                   width: 90,
//                                   decoration: const BoxDecoration(
//                                     border: Border(
//                                       bottom: BorderSide(
//                                           color: ColorConstants.kPrimaryColor),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const DoubleSpace(),
//                           Row(
//                             children: [
//                               Expanded(
//                                   flex: 1,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text('Cash from AO : ',
//                                           style: headingTextStyle()),
//                                       Flexible(
//                                         child: CInputForm(
//                                             readOnly: false,
//                                             iconData: MdiIcons.currencyInr,
//                                             labelText: 'Cash',
//                                             controller: aoRequestCashController,
//                                             textType: TextInputType.number,
//                                             typeValue: 'Amount',
//                                             focusNode: aoRequestCashFocus),
//                                       ),
//                                     ],
//                                   )),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Expanded(
//                                   flex: 1,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text('Cash to AO :',
//                                           style: headingTextStyle()),
//                                       Flexible(
//                                           child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 8.0.toDouble(),
//                                             horizontal: 3.0.toDouble()),
//                                         child: TextFormField(
//                                           onChanged: (value) {
//                                             if (value.isNotEmpty) {
//                                               setState(() {
//                                                 _balanceVisible = true;
//                                               });
//                                             } else {
//                                               setState(() {
//                                                 _balanceVisible = false;
//                                               });
//                                             }
//                                           },
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           controller: aoConfirmCashController,
//                                           style: const TextStyle(
//                                               color: ColorConstants
//                                                   .kSecondaryColor),
//                                           keyboardType: TextInputType.number,
//                                           decoration: const InputDecoration(
//                                               counterText: '',
//                                               fillColor: ColorConstants.kWhite,
//                                               filled: true,
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color:
//                                                         ColorConstants.kWhite),
//                                               ),
//                                               prefixIcon: Icon(
//                                                 MdiIcons.currencyInr,
//                                                 color: ColorConstants
//                                                     .kSecondaryColor,
//                                               ),
//                                               labelStyle: TextStyle(
//                                                   color: ColorConstants
//                                                       .kAmberAccentColor),
//                                               labelText: 'Cash',
//                                               isDense: true,
//                                               border: InputBorder.none,
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: ColorConstants
//                                                           .kWhite))),
//                                         ),
//                                       ))
//                                     ],
//                                   ))
//                             ],
//                           ),
//                           const DoubleSpace(),
//                         ],
//                       ),
//                     ),
//                     walletAmount > maxAmount
//                         ? Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 10.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Space(),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Excess',
//                                       style: headingTextStyle(),
//                                     ),
//                                     Text(
//                                       '\u{20B9}' + getBalance(),
//                                       style: TextStyle(
//                                           letterSpacing: 1,
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w500,
//                                           color: ColorConstants.kPrimaryColor),
//                                     )
//                                   ],
//                                 ),
//                                 const Space(),
//                                 Text(
//                                   'Closing balance of Varuna B.O exceeds the maximum sanctioned amount of \u{20B9}$maxAmount limit by \u{20B9}${getBalance()}.\n',
//                                   style: headingTextStyle(),
//                                 ),
//                                 TextFormField(
//                                   controller: liabilityReasonController,
//                                   decoration: const InputDecoration(
//                                       counterText: '',
//                                       fillColor: ColorConstants.kWhite,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: ColorConstants.kWhite),
//                                       ),
//                                       prefixIcon: Icon(
//                                         Icons.description,
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       labelStyle: TextStyle(
//                                           color:
//                                               ColorConstants.kAmberAccentColor),
//                                       labelText: 'Liability Reason',
//                                       isDense: true,
//                                       border: InputBorder.none,
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: ColorConstants.kWhite))),
//                                   minLines: 5,
//                                   maxLines: null,
//                                 ),
//                                 const DoubleSpace(),
//                               ],
//                             ),
//                           )
//                         : Container(),
//                     Text(
//                       'Cash bag weight : ',
//                       style: headingTextStyle(),
//                     ),
//                     CInputForm(
//                         readOnly: false,
//                         iconData: MdiIcons.weight,
//                         labelText: 'Weight',
//                         controller: weightController,
//                         textType: TextInputType.number,
//                         typeValue: 'Weight',
//                         focusNode: weightFocus),
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
//     await BookingDBService().addCashIndent(DateTimeDetails().dateCharacter(),
//         aoConfirmCashController.text, weightController.text);
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
//     if (aoConfirmCashController.text.isNotEmpty) {
//       aoAmount = int.parse(aoConfirmCashController.text);
//     }
//     if (liabilityAmountController.text.isNotEmpty) {
//       liabilityAmount = int.parse(liabilityAmountController.text);
//     }
//     var balance = walletAmount - maxAmount - liabilityAmount - aoAmount;
//     if (balance < 0) {
//       return '0';
//     } else {
//       return balance.toString();
//     }
//   }
//
//   getBODAConfirm() {
//     double excess = double.parse(getBalance());
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
//     await BookingDBService().addCashIndent(
//         DateTimeDetails().dateCharacter(),
//         aoConfirmCashController.text.isEmpty
//             ? '0'
//             : aoConfirmCashController.text,
//         weightController.text);
//     var currentDate = DateTimeDetails().currentDate();
//     final saveLiability = Liability()
//       ..Description = liabilityReasonController.text.trim()
//       ..Date = DateTimeDetails().currentDate()
//       ..Amount = getBalance().toString();
//     saveLiability.upsert();
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
//     final dayDetail = await DayModel()
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
//         ..CashClosingBalance =
//             (walletAmount - double.parse(aoConfirmCashController.text))
//                 .toString()
//         ..DayCloseDate = DateTimeDetails().currentDate()
//         ..DayCloseTime = DateTimeDetails().onlyTime();
//       updateDayEnd.upsert();
//     } else {
//       final updateDayEnd = DayModel()
//         ..DayBeginDate = dayDetail[0]['DayBeginDate']
//         ..DayBeginTime = dayDetail[0]['DayBeginTime']
//         ..CashOpeningBalance = dayDetail[0]['CashOpeningBalance']
//         ..CashClosingBalance = (walletAmount -
//                 (aoConfirmCashController.text.isEmpty
//                     ? 0.0
//                     : double.parse(aoConfirmCashController.text)))
//             .toString()
//         ..DayCloseDate = DateTimeDetails().currentDate()
//         ..DayCloseTime = DateTimeDetails().onlyTime();
//       updateDayEnd.upsert();
//     }
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
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.clear();
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
