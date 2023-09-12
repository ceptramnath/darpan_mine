// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagAddDetailsScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/DialogText.dart';
// import 'package:darpan_mine/Widgets/DottedLine.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../BaggingServices.dart';
//
// class BagDetailsScreen extends StatefulWidget {
//   final String bagNumber;
//   final List toBeScannedList;
//
//   const BagDetailsScreen({Key? key, required this.bagNumber, required this.toBeScannedList})
//       : super(key: key);
//
//   @override
//   _BagDetailsScreenState createState() => _BagDetailsScreenState();
// }
//
// class _BagDetailsScreenState extends State<BagDetailsScreen> {
//   int bagArticlesCount = 0;
//   int shortArticlesCount = 0;
//   int bagStampsCount = 0;
//   int bagStampsQuantityCount = 0;
//   int bagCashCount = 0;
//   int difference = 0;
//
//   List receivedArticles = [];
//   List shortArticle = [];
//   List shortArticleType = [];
//   List documents = [];
//   List documents1 = [];
//   List shortDocuments = [];
//   List bagArticlesTypes = [];
//   List excessArticles = [];
//   List bagArticles = [];
//   List bagStamps = [];
//   List excessInventory = [];
//   List bagExcessStamps = [];
//   List bagDocuments = [];
//   List<String> registerArticles = [];
//   List<String> registerShortArticles = [];
//   List<String> registerExcessArticles = [];
//   List<String> speedArticles = [];
//   List<String> speedShortArticles = [];
//   List<String> speedExcessArticles = [];
//   List<String> parcelArticles = [];
//   List<String> parcelShortArticles = [];
//   List<String> parcelExcessArticles = [];
//
//   fetchBagData() async {
//
//     /*-------------------------------------Articles-------------------------------------*/
//     var shortArticles = await BagArticlesTable().select().startBlock.BagNumber
//         .equals(widget.bagNumber).and.Status.equals('Received').endBlock.toMapList();
//     print("Short Articles $shortArticles");
//     for (int i = 0; i<shortArticles.length; i++) {
//       shortArticle.add(shortArticles[i]['ArticleNumber']);
//       shortArticleType.add(shortArticles[i]['ArticleType']);
//       if (shortArticles[i]['ArticleType'] == 'LETTER' || shortArticles[i]['ArticleType'] == 'Register Article') {
//         registerShortArticles.add(shortArticles[i]['ArticleNumber']);
//       } else if (shortArticles[i]['ArticleType'] == 'Speed Post') {
//         speedShortArticles.add(shortArticles[i]['ArticleNumber']);
//       } else if (shortArticles[i]['ArticleType'] == 'Parcel') {
//         parcelShortArticles.add(shortArticles[i]['ArticleNumber']);
//       }
//     }
//     shortArticlesCount = shortArticles.length;
//
//     receivedArticles = await BagArticlesTable().select().startBlock.BagNumber
//         .equals(widget.bagNumber).and.Status.equals('Added').endBlock.toMapList();
//     for (int i = 0; i < receivedArticles.length; i++) {
//       bagArticles.add(receivedArticles[i]['ArticleNumber']);
//       bagArticlesTypes.add(receivedArticles[i]['ArticleType']);
//       if (receivedArticles[i]['ArticleType'] == 'Registered Letter') {
//         registerArticles.add(receivedArticles[i]['ArticleNumber']);
//       } else if (receivedArticles[i]['ArticleType'] == 'Speed Post') {
//         speedArticles.add(receivedArticles[i]['ArticleNumber']);
//       } else if (receivedArticles[i]['ArticleType'] == 'Parcel') {
//         parcelArticles.add(receivedArticles[i]['ArticleNumber']);
//       }
//     }
//
//     excessArticles = await BagExcessArticlesTable().select().startBlock.BagNumber
//         .equals(widget.bagNumber).and.Status.equals('Added').endBlock.toMapList();
//     print("Excess Articles $excessArticles");
//     for (int i = 0; i < excessArticles.length; i++) {
//       bagArticles.add(excessArticles[i]['ArticleNumber']);
//       bagArticlesTypes.add(excessArticles[i]['ArticleType']);
//       if (excessArticles[i]['ArticleType'] == 'LETTER') {
//         registerExcessArticles.add(excessArticles[i]['ArticleNumber']);
//         registerArticles.add(excessArticles[i]['ArticleNumber']);
//       } else if (excessArticles[i]['ArticleType'] == 'Speed Post') {
//         speedExcessArticles.add(excessArticles[i]['ArticleNumber']);
//         speedArticles.add(excessArticles[i]['ArticleNumber']);
//       } else if (excessArticles[i]['ArticleType'] == 'Parcel') {
//         parcelExcessArticles.add(excessArticles[i]['ArticleNumber']);
//         parcelArticles.add(excessArticles[i]['ArticleNumber']);
//       }
//     }
//
//     bagArticlesCount = receivedArticles.length + excessArticles.length;
//     /*----------------------------------------------------------------------------------*/
//
//     /*------------------------------------Documents-------------------------------------*/
//     documents = await BagDocumentsTable().select().startBlock.BagNumber
//         .equals(widget.bagNumber).and.IsAdded.equals('Y').endBlock.toMapList();
//     for (int i = 0; i < documents.length; i++) {
//       bagDocuments.add(documents[i]);
//     }
//     documents1 = await BagDocumentsTable().select().startBlock.BagNumber
//         .equals(widget.bagNumber).and.IsAdded.equals('N').endBlock.toMapList();
//     for (int i = 0; i < documents1.length; i++) {
//       shortDocuments.add(documents1[i]['DocumentName']);
//     }
//     /*----------------------------------------------------------------------------------*/
//
//     /*-------------------------------------Inventory------------------------------------*/
//     bagStamps = await BagStampsTable().select().BagNumber.equals(widget.bagNumber)
//         .toMapList();
//     bagStampsCount = bagStamps.length;
//
//
//     var totalStamps = 0;
//     for (int i = 0; i < bagStamps.length; i++) {
//       totalStamps += int.parse(bagStamps[i]['StampQuantity']);
//     }
//
//     excessInventory = await BagExcessStampsTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for (int i = 0; i < excessInventory.length; i++) {
//       bagExcessStamps.add(excessInventory[i]['StampName']);
//     }
//     bagStampsQuantityCount = totalStamps;
//     /*----------------------------------------------------------------------------------*/
//
//     /*---------------------------------------Cash---------------------------------------*/
//     final bagCash =
//     await BagCashTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     var totalCash = 0;
//     for (int i = 0; i < bagCash.length; i++) {
//       totalCash += int.parse(bagCash[i]['CashAmount']);
//     }
//     var receivedCash = int.parse(bagCash[0]['CashReceived']);
//     var cashAdded = int.parse(bagCash[0]['CashAmount']);
//     difference = cashAdded - receivedCash;
//     bagCashCount = totalCash;
//     /*----------------------------------------------------------------------------------*/
//
//     return bagCashCount;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: ColorConstants.kPrimaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30.w),
//           ),
//         ),
//         title: Text('Summary of ${widget.bagNumber}'),
//         leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
//           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
//               BagAddDetailsScreen(bagNumber: widget.bagNumber)), (route) => false);
//         },),
//       ),
//       body: FutureBuilder(
//           future: fetchBagData(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ExpansionTile(
//                     title: Text(
//                       'Total Articles : ${bagArticlesCount.toString()}',
//                       style: TextStyle(letterSpacing: 2.sp, fontWeight: FontWeight.w500),
//                     ),
//                     children: [
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Register Letter', style: TextStyle(letterSpacing: 1)),
//                             Text(registerArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: registerArticles
//                                 .map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Register Letter : ', subtitle: e),
//                             ))
//                                 .toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Speed Post', style: TextStyle(letterSpacing: 1)),
//                             Text(speedArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: speedArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Speed Post : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Parcel', style: TextStyle(letterSpacing: 1)),
//                             Text(parcelArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: parcelArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Parcel : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   ExpansionTile(
//                     title: Text(
//                       'Total Documents : ${bagDocuments.length}',
//                       style: const TextStyle(letterSpacing: 2),
//                     ),
//                     children: [
//                       ListView.builder(
//                         itemCount: bagDocuments.length,
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                               padding: EdgeInsets.all(8.0.w),
//                               child: DialogText(
//                                 title: (index + 1).toString(),
//                                 subtitle: ' : ${bagDocuments[index]['DocumentName']}',
//                               ));
//                         },
//                       )
//                     ],
//                   ),
//                   ExpansionTile(
//                     title: Text(
//                       'Total Inventory : $bagStampsQuantityCount',
//                       style: const TextStyle(letterSpacing: 2),
//                     ),
//                     children: [
//                       Card(
//                         child: Column(
//                           children: [
//                             const Space(),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     flex: 3,
//                                     child: Text('Category', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                               ],
//                             ),
//                             const Divider(),
//                             Row(
//                               children: [
//                                 Flexible(
//                                   flex: 3,
//                                   child: ListView.builder(
//                                     itemCount: bagStamps.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: DialogText(
//                                             title: (index + 1).toString(),
//                                             subtitle: ' : ${bagStamps[index]['StampName']}',
//                                           ));
//                                     },
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   child: ListView.builder(
//                                     itemCount: bagStamps.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text(bagStamps[index]['StampQuantity'], textAlign: TextAlign.center, style: TextStyle(letterSpacing: 1.sp, fontSize: 14.sp, color: ColorConstants.kTextColor),));
//                                     },
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   child: ListView.builder(
//                                     itemCount: bagStamps.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text('\u{20B9}${bagStamps[index]['StampAmountTotal']}', textAlign: TextAlign.center, style: TextStyle(letterSpacing: 1.sp, fontSize: 14.sp, color: ColorConstants.kTextColor),));
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 15.0.w, top: 10.h, bottom: 10.h),
//                     child: Text(
//                       'Total Cash : \u{20B9}$bagCashCount',
//                       style: TextStyle(letterSpacing: 2, fontSize: 14.sp),
//                     ),
//                   ),
//                   const Space(),
//                   const DottedLine(),
//                   const Space(),
//                   ExpansionTile(
//                     title: Text(
//                       'Excess Articles : ${excessArticles.length.toString()}',
//                       style: TextStyle(letterSpacing: 2.sp, fontWeight: FontWeight.w500),
//                     ),
//                     children: [
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Register Letter', style: TextStyle(letterSpacing: 1)),
//                             Text(registerExcessArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: registerExcessArticles
//                                 .map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Register Letter : ', subtitle: e),
//                             ))
//                                 .toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Speed Post', style: TextStyle(letterSpacing: 1)),
//                             Text(speedExcessArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: speedExcessArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Speed Post : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Parcel', style: TextStyle(letterSpacing: 1)),
//                             Text(parcelExcessArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: parcelExcessArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Parcel : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   ExpansionTile(
//                     title: Text(
//                       'Short Articles : ${shortArticlesCount.toString()}',
//                       style: TextStyle(letterSpacing: 2.sp, fontWeight: FontWeight.w500),
//                     ),
//                     children: [
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Register Letter', style: TextStyle(letterSpacing: 1)),
//                             Text(registerShortArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: registerShortArticles
//                                 .map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Register Letter : ', subtitle: e),
//                             ))
//                                 .toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Speed Post', style: TextStyle(letterSpacing: 1)),
//                             Text(speedShortArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: speedShortArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Speed Post : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                       ExpansionTile(
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             const Text('Parcel', style: TextStyle(letterSpacing: 1)),
//                             Text(parcelShortArticles.length.toString())
//                           ],
//                         ),
//                         children: [
//                           Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: parcelShortArticles.map((e) => Padding(
//                               padding: EdgeInsets.symmetric(vertical: 4.0.h),
//                               child: DialogText(title: 'Parcel : ', subtitle: e),
//                             )).toList(),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                   ExpansionTile(
//                     title: Text(
//                       'Short Documents : ${shortDocuments.length}',
//                       style: const TextStyle(letterSpacing: 2),
//                     ),
//                     children: [
//                       ListView.builder(
//                         itemCount: shortDocuments.length,
//                         shrinkWrap: true,
//                         physics: const ClampingScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index) {
//                           return Padding(
//                               padding: EdgeInsets.all(8.0.w),
//                               child: DialogText(
//                                 title: (index + 1).toString(),
//                                 subtitle: ' : ${shortDocuments[index]}',
//                               ));
//                         },
//                       )
//                     ],
//                   ),
//                   ExpansionTile(
//                     title: Text(
//                       'Excess Inventory : ${bagExcessStamps.length}',
//                       style: const TextStyle(letterSpacing: 2),
//                     ),
//                     children: [
//                       Card(
//                         child: Column(
//                           children: [
//                             const Space(),
//                             Row(
//                               children: [
//                                 Expanded(
//                                     flex: 3,
//                                     child: Text('Category', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                 Expanded(
//                                     flex: 1,
//                                     child: Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                               ],
//                             ),
//                             const Divider(),
//                             Row(
//                               children: [
//                                 Flexible(
//                                   flex: 3,
//                                   child: ListView.builder(
//                                     itemCount: excessInventory.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: DialogText(
//                                             title: (index + 1).toString(),
//                                             subtitle: ' : ${excessInventory[index]['Name']}',
//                                           ));
//                                     },
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   child: ListView.builder(
//                                     itemCount: excessInventory.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text(excessInventory[index]['StampQuantity'], textAlign: TextAlign.center, style: TextStyle(letterSpacing: 1.sp, fontSize: 14.sp, color: ColorConstants.kTextColor),));
//                                     },
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   child: ListView.builder(
//                                     itemCount: excessInventory.length,
//                                     shrinkWrap: true,
//                                     physics: const ClampingScrollPhysics(),
//                                     itemBuilder: (BuildContext context, int index) {
//                                       return Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text('\u{20B9}${excessInventory[index]['StampAmountTotal']}', textAlign: TextAlign.center, style: TextStyle(letterSpacing: 1.sp, fontSize: 14.sp, color: ColorConstants.kTextColor),));
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   ListTile(
//                       title: Text('Excess/Short Cash :  \u{20B9} $difference', style: TextStyle(letterSpacing: 1.sp),)
//                   ),
//                   Align(
//                       alignment: Alignment.center,
//                       child: Button(buttonText: 'SAVE', buttonFunction: () async {
//                         showDialog(context: context, builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('Note!'),
//                             content: RichText(
//                               text: TextSpan(
//                                 text: 'Are you sure to set BagNumber ',
//                                 style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor, fontSize: 14.sp),
//                                 children:  <TextSpan>[
//                                   TextSpan(text: widget.bagNumber, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                                   TextSpan(text: ' as Opened?', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                                 ],
//                               ),
//                             ),
//                             actions: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//                                   Button(buttonText: 'CONFIRM', buttonFunction: () async {
//                                     await BagReceivedTable().select().BagNumber
//                                         .equals(widget.bagNumber).toMapList();
//                                     await BaggingDBService().updateBag(widget.bagNumber, 'Opened',
//                                         DateTimeDetails().onlyDate(), DateTimeDetails().onlyTime());
//
//                                     await BaggingDBService().addExcessCashToDB(
//                                         DateTimeDetails().dateCharacter(), difference > 0 ? difference.toString() : '0', widget.bagNumber);
//
//                                     if (bagDocuments.isNotEmpty) {
//                                       for (int i = 0; i < bagDocuments.length; i++) {
//                                         await BaggingDBService().saveDocumentsToDB(DateTimeDetails().dateCharacter(), bagDocuments[i]['DocumentName'], widget.bagNumber);
//                                       }
//                                     }
//
//                                     await BagReceivedTable().select()
//                                         .BagNumber.equals(widget.bagNumber).toMapList();
//
//                                     final articleDetails = await BagArticlesTable().select()
//                                         .startBlock.BagNumber.equals(widget.bagNumber)
//                                         .and.Status.equals('Added').endBlock.toMapList();
//                                     for (int i = 0; i < articleDetails.length; i++) {
//                                       await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//                                           articleDetails[i]['ArticleNumber'],
//                                           articleDetails[i]['ArticleType'], 'Opened');
//                                     }
//                                     final excessArticleDetails = await BagExcessArticlesTable()
//                                         .select().startBlock.BagNumber.equals(widget.bagNumber)
//                                         .and.Status.equals('Added').endBlock.toMapList();
//                                     for (int i = 0; i < excessArticles.length; i++) {
//                                       await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//                                           excessArticleDetails[i]['ArticleNumber'],
//                                           excessArticles[i]['ArticleType'], 'Opened');
//                                     }
//
//                                     final inventory = await BagStampsTable().select().BagNumber
//                                         .equals(widget.bagNumber).toMapList();
//                                     for (int i = 0; i < inventory.length; i++) {
//                                       await BaggingDBService().addInventoryFromBagToDB(
//                                           inventory[i]['StampName'], inventory[i]['StampPrice'],
//                                           inventory[i]['StampQuantity'],
//                                           inventory[i]['StampAmountTotal'], widget.bagNumber,
//                                           'Opened');
//                                     }
//
//                                     final cash = await BagCashTable().select().BagNumber
//                                         .equals(widget.bagNumber).toMapList();
//                                     await BookingDBService().updateCashInDB(bagCashCount, 'Add', 'Cash from Bag');
//                                     await BookingDBService().addTransaction('BAG${widget.bagNumber}', 'Bag Cash', 'Cash received from Bag', DateTimeDetails().onlyDate(), DateTimeDetails().onlyTime(), bagCashCount.toString(), 'Add');
//                                     await BaggingDBService().addBagCashToDB(cash[0]['CashAmount'],
//                                         'Opened', widget.bagNumber, cash[0]['CashReceived']);
//                                     Toast.showToast('Bag ${widget.bagNumber} is Opened', context);
//                                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BaggingServices()), (route) => false);
//
//                                   })
//                                 ],
//                               )
//                             ],
//                           );
//                         });
//                       }))
//                 ],
//               ),
//             );
//           }),
//     ), onWillPop: () async {
//       moveToPrevious(context);
//       return true;
//     },);
//   }
//
//   void moveToPrevious(BuildContext context){
//     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagAddDetailsScreen(bagNumber: widget.bagNumber)), (route) => false);
//   }
// }
