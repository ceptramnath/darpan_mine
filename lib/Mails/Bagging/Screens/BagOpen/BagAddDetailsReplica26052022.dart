// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Mails/BaggingServices.dart';
// import 'package:darpan_mine/Utils/Scan.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import 'BagOpenScreen.dart';
//
// class BagAddDetailsReplica26052022 extends StatefulWidget {
//   final String bagNumber;
//
//   const BagAddDetailsReplica26052022({Key? key, required this.bagNumber}) : super(key: key);
//
//   @override
//   _BagAddDetailsReplica26052022State createState() => _BagAddDetailsReplica26052022State();
// }
//
// class _BagAddDetailsReplica26052022State extends State<BagAddDetailsReplica26052022> {
//   var typeArticle = null;
//
//   String? articleType;
//   String jsonBagCashReceived = '';
//
//   List expansionArticle = [];
//   List expansionArticleType = [];
//   List expansionInventoryName = [];
//   List expansionInventoryPrice = [];
//   List expansionInventoryQuantity = [];
//   List expansionInventoryTotal = [];
//   List expansionDocuments = [];
//   List<String> jsonBagArticles = [];
//   List<String> jsonBagArticleTypes = [];
//   List<String> jsonBagStampName = [];
//   List<String> jsonBagStampQuantity = [];
//   List<String> jsonBagStampPrice = [];
//   List<String> jsonBagDocuments = [];
//
//   bool _bagFetched = false;
//   bool _selectedArticle = false;
//   bool _selectedRegularArticle = false;
//   bool _selectedVPArticle = false;
//
//   final bagNumberFocus = FocusNode();
//   final articleNumberFocusNode = FocusNode();
//   final vpArticleNumberFocusNode = FocusNode();
//   final vpAmountFocusNode = FocusNode();
//   final vpCommissionFocusNode = FocusNode();
//   final documentFocusNode = FocusNode();
//
//   final bagController = TextEditingController();
//   final articleNumberController = TextEditingController();
//   final vpArticleNumberController = TextEditingController();
//   final vpAmountController = TextEditingController();
//   final vpCommissionController = TextEditingController();
//   final editArticleNumberController = TextEditingController();
//   final inventoryNameController = TextEditingController();
//   final inventoryQuantityController = TextEditingController();
//   final inventoryPriceController = TextEditingController();
//   final inventoryTotalController = TextEditingController();
//   final editInventoryNameController = TextEditingController();
//   final editInventoryQuantityController = TextEditingController();
//   final editInventoryPriceController = TextEditingController();
//   final editInventoryTotalController = TextEditingController();
//   final documentsController = TextEditingController();
//   final editDocumentsController = TextEditingController();
//   final amountController = TextEditingController();
//
//   final _articleTypes = ['Parcel', 'LETTER', 'Speed Post', 'VPP', 'VPL', 'COD'];
//
//   @override
//   void initState() {
//     bagController.text = widget.bagNumber;
//     super.initState();
//   }
//
//   fetchDetails() async {
//
//     /*-------------------------------------Articles-------------------------------------*/
//     final bagArticles = await BagArticlesTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for (int i = 0; i < bagArticles.length; i++) {
//       if (!expansionArticle.contains(bagArticles[i]['ArticleNumber'].toString())) {
//         expansionArticle.add(bagArticles[i]['ArticleNumber'].toString());
//         expansionArticleType.add(bagArticles[i]['ArticleType'].toString());
//       }
//     }
//
//     /*----------------------------------Inventory Data----------------------------------*/
//     final bagAddedStamps = await BagStampsTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for (int i = 0; i < bagAddedStamps.length; i++) {
//       if (!expansionInventoryName.contains(bagAddedStamps[i]['StampName'])) {
//         expansionInventoryName.add(bagAddedStamps[i]['StampName']);
//         expansionInventoryPrice.add(bagAddedStamps[i]['StampPrice']);
//         expansionInventoryQuantity.add(bagAddedStamps[i]['StampQuantity']);
//       }
//     }
//
//     /*----------------------------------Documents Data----------------------------------*/
//     final bagDocuments = await BagDocumentsTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for (int i = 0; i < bagDocuments.length; i++) {
//       if (!expansionDocuments.contains(bagDocuments[i]['DocumentName'])) {
//         expansionDocuments.add(bagDocuments[i]['DocumentName']);
//       }
//     }
//
//     /*------------------------------------Cash Data-------------------------------------*/
//     final bagCash = await BagCashTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     if (bagCash.isNotEmpty) {
//       amountController.text = bagCash[0]['CashReceived'].toString();
//     }
//
//     return true;
//   }
//
//   scanBarCode() async {
//     var scan = await Scan().scanBag();
//     setState(() {
//       if (typeArticle == 'VPP' || typeArticle == 'VPL' || typeArticle == 'COD') {
//         vpArticleNumberController.text = scan;
//       } else {
//         articleNumberController.text = scan;
//       }
//     });
//   }
//
//   void _dropDownItemSelected(String valueSelectedByUser) {
//     setState(() {
//       typeArticle = valueSelectedByUser;
//       _selectedArticle = true;
//       if (valueSelectedByUser == 'VPP' ||
//           valueSelectedByUser == 'VPL' ||
//           valueSelectedByUser == 'COD') {
//         _selectedVPArticle = true;
//         _selectedRegularArticle = false;
//       } else {
//         _selectedRegularArticle = true;
//         _selectedVPArticle = false;
//       }
//     });
//   }
//
//   showArticleAddDialog(String articleNumber, String typeOfArticle) async {
//     showDialog(context: context, builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Note!'),
//         content: RichText(
//           text: TextSpan(
//             text: 'Article ',
//             style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor, fontSize: 14.sp),
//             children:  <TextSpan>[
//               TextSpan(text: articleNumber, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' of type ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//               TextSpan(text: typeOfArticle, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' is not available in bag, would you still like to ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//               TextSpan(text: 'ADD', style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' it ?', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//             ],
//           ),
//         ),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//               Button(buttonText: 'CONFIRM', buttonFunction: () {
//                 setState(() {
//                   expansionArticle.add(articleNumberController.text);
//                   expansionArticleType.add(typeArticle);
//                   articleNumberController.clear();
//                   Navigator.of(context).pop();
//                 });
//               })
//             ],
//           )
//         ],
//       );
//     });
//   }
//
//   showArticleEditDialog(String articleNumber, String typeOfArticle) async {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const DoubleSpace(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       controller: editArticleNumberController..text = articleNumber,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.email,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.w),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton(
//                           isExpanded: true,
//                           iconEnabledColor: Colors.blueGrey,
//                           value: typeOfArticle,
//                           items: _articleTypes.map((String myMenuItem) {
//                             return DropdownMenuItem<String>(
//                               value: myMenuItem,
//                               child: Text(
//                                 myMenuItem,
//                                 style: const TextStyle(color: Colors.blueGrey),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (String? valueSelectedByUser) async {
//                             setState(() {
//                               typeOfArticle = valueSelectedByUser ?? '';
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//             Button(
//                 buttonText: 'SAVE',
//                 buttonFunction: () {
//                   setState(() {
//                     final index = expansionArticle
//                         .indexWhere((element) => element == articleNumber);
//                     expansionArticle.removeAt(index);
//                     expansionArticleType.removeAt(index);
//                     expansionArticle.add(editArticleNumberController.text);
//                     expansionArticleType.add(typeOfArticle);
//                     Navigator.pop(context);
//                   });
//                 }),
//           ],
//         );
//       },
//     );
//   }
//
//   showArticleDeleteDialog(String articleNumber, String articleType) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: Text(
//                 'Do you wish to delete the Article $articleNumber of type $articleType?'),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () {
//                         Navigator.pop(context);
//                       }),
//                   Button(
//                     buttonText: 'DELETE',
//                     buttonFunction: () async {
//                       setState(() {
//                         final index = expansionArticle
//                             .indexWhere((element) => element == articleNumber);
//                         expansionArticle.removeAt(index);
//                         expansionArticleType.removeAt(index);
//                         Navigator.pop(context);
//                       });
//                     },
//                   )
//                 ],
//               )
//             ],
//           );
//         });
//   }
//
//   showInventoryAddDialog(String name, String quantity, String price) async {
//     showDialog(context: context, builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Note!'),
//         content: RichText(
//           text: TextSpan(
//             text: 'Inventory ',
//             style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor, fontSize: 14.sp),
//             children:  <TextSpan>[
//               TextSpan(text: name, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' of Quantity ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//               TextSpan(text: quantity, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' with a price of \u{20B9} ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//               TextSpan(text: price, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' is not available in bag, would you still like to ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//               TextSpan(text: 'ADD', style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//               TextSpan(text: ' it ?', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//             ],
//           ),
//         ),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//               Button(buttonText: 'CONFIRM', buttonFunction: () {
//                 setState(() {
//                   expansionInventoryName.add(inventoryNameController.text);
//                   expansionInventoryQuantity.add(inventoryQuantityController.text);
//                   expansionInventoryPrice.add(inventoryPriceController.text);
//                   expansionInventoryTotal.add(inventoryTotalController.text);
//                   inventoryNameController.clear();
//                   inventoryQuantityController.clear();
//                   inventoryPriceController.clear();
//                   inventoryTotalController.clear();
//                 });
//               })
//             ],
//           )
//         ],
//       );
//     });
//   }
//
//   showInventoryEditDialog(String name, String quantity, String price, String total) async {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const DoubleSpace(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       controller: editInventoryNameController..text = name,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.postageStamp,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       controller: editInventoryQuantityController..text = quantity,
//                       onChanged: (text) {
//                         editInventoryTotalController.text = (int.parse(text) * int.parse(editInventoryPriceController.text)).toString();
//                       },
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.sticky_note_2_outlined,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       controller: editInventoryPriceController..text = price,
//                       onChanged: (text) {
//                         editInventoryTotalController.text = (int.parse(text) * int.parse(editInventoryQuantityController.text)).toString();
//                       },
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.currencyInr,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       readOnly: true,
//                       controller: editInventoryTotalController..text = total,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.currencyInr,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//             Button(
//                 buttonText: 'SAVE',
//                 buttonFunction: () {
//                   setState(() {
//                     final index = expansionInventoryName
//                         .indexWhere((element) => element == name);
//                     expansionInventoryName.removeAt(index);
//                     expansionInventoryQuantity.removeAt(index);
//                     expansionInventoryPrice.removeAt(index);
//                     expansionInventoryTotal.removeAt(index);
//                     expansionInventoryName.add(editInventoryNameController.text);
//                     expansionInventoryQuantity.add(editInventoryQuantityController.text);
//                     expansionInventoryPrice.add(editInventoryPriceController.text);
//                     expansionInventoryTotal.add(editInventoryTotalController.text);
//                     Navigator.pop(context);
//                   });
//                 }),
//           ],
//         );
//       },
//     );
//   }
//
//   showInventoryDeleteDialog(String name, String quantity, String price, String total) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: Text(
//                 'Do you wish to delete the Inventory $name of type $quantity?'),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () {
//                         Navigator.pop(context);
//                       }),
//                   Button(
//                     buttonText: 'DELETE',
//                     buttonFunction: () async {
//                       setState(() {
//                         final index = expansionInventoryName
//                             .indexWhere((element) => element == name);
//                         expansionInventoryName.removeAt(index);
//                         expansionInventoryQuantity.removeAt(index);
//                         expansionInventoryPrice.removeAt(index);
//                         expansionInventoryTotal.removeAt(index);
//                         Navigator.pop(context);
//                       });
//                     },
//                   )
//                 ],
//               )
//             ],
//           );
//         });
//   }
//
//   showDocumentEditDialog(String document) async {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const DoubleSpace(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10.w))),
//                     child: TextFormField(
//                       controller: editDocumentsController..text = document,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.description,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//             Button(
//                 buttonText: 'SAVE',
//                 buttonFunction: () {
//                   setState(() {
//                     final index = expansionDocuments
//                         .indexWhere((element) => element == document);
//                     expansionDocuments.removeAt(index);
//                     expansionDocuments.add(editDocumentsController.text);
//                     Navigator.pop(context);
//                   });
//                 }),
//           ],
//         );
//       },
//     );
//   }
//
//   showDocumentDeleteDialog(String document) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: Text(
//                 'Do you wish to delete the Document $document?'),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () {
//                         Navigator.pop(context);
//                       }),
//                   Button(
//                     buttonText: 'DELETE',
//                     buttonFunction: () async {
//                       setState(() {
//                         final index = expansionDocuments
//                             .indexWhere((element) => element == document);
//                         expansionDocuments.removeAt(index);
//                         Navigator.pop(context);
//                       });
//                     },
//                   )
//                 ],
//               )
//             ],
//           );
//         });
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
//           backgroundColor: ColorConstants.kPrimaryColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(30.w),
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () async {
//               showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: const Text('Note!'),
//                       content: const Text(
//                           'Do you wish to save the details entered and then leave the page?'),
//                       actions: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Button(
//                                 buttonText: 'CANCEL',
//                                 buttonFunction: () {
//                                   Navigator.pop(context);
//                                   Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(builder: (_) => BagOpenScreen()),
//                                           (route) => false);
//                                 }),
//                             Button(
//                               buttonText: 'SAVE',
//                               buttonFunction: () async {
//                                 await addingData();
//                                 Toast.showToast(
//                                     'Details has been added for the Bag ${widget.bagNumber}',
//                                     context);
//                                 Navigator.pushAndRemoveUntil(
//                                     context,
//                                     MaterialPageRoute(builder: (_) => BagOpenScreen()),
//                                         (route) => false);
//                               },
//                             )
//                           ],
//                         )
//                       ],
//                     );
//                   });
//             },
//           ),
//           title: Text('Details of ${widget.bagNumber}'),
//         ),
//         body: FutureBuilder(
//           future: fetchDetails(),
//           builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SmallSpace(),
//                       Row(
//                         children: [
//                           Container(
//                               padding:
//                               EdgeInsets.symmetric(vertical: 3.h.toDouble()),
//                               decoration: const BoxDecoration(
//                                 color: ColorConstants.kSecondaryColor,
//                               ),
//                               child: IconButton(
//                                 onPressed: (){},
//                                 icon: const Icon(
//                                   Icons.email,
//                                   color: ColorConstants.kWhite,
//                                 ),
//                               )),
//                           Expanded(
//                             child: Container(
//                               color: Colors.white,
//                               child: Padding(
//                                 padding:
//                                 EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.w),
//                                 child: DropdownButtonHideUnderline(
//                                   child: DropdownButtonHideUnderline(
//                                     child: DropdownButton<String>(
//                                       isExpanded: true,
//                                       iconEnabledColor: Colors.blueGrey,
//                                       hint: const Text(
//                                         'Select an Article Type',
//                                         style: TextStyle(color: Color(0xFFCFB53B)),
//                                       ),
//                                       items: _articleTypes.map((String myMenuItem) {
//                                         return DropdownMenuItem<String>(
//                                           value: myMenuItem,
//                                           child: Text(
//                                             myMenuItem,
//                                             style:
//                                             const TextStyle(color: Colors.blueGrey),
//                                           ),
//                                         );
//                                       }).toList(),
//                                       onChanged: (String? valueSelectedByUser) async {
//                                         _dropDownItemSelected(valueSelectedByUser!);
//                                       },
//                                       value: _selectedArticle ? typeArticle : articleType,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       const Space(),
//                       Visibility(
//                         visible: _selectedRegularArticle,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 4,
//                               child: TextFormField(
//                                 focusNode: articleNumberFocusNode,
//                                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                                 controller: articleNumberController,
//                                 style: TextStyle(color: ColorConstants.kSecondaryColor, letterSpacing: 1.sp),
//                                 textCapitalization: TextCapitalization.characters,
//                                 keyboardType: TextInputType.text,
//                                 decoration: InputDecoration(
//                                     hintText: 'Article Number',
//                                     hintStyle: const TextStyle(
//                                         color: ColorConstants.kAmberAccentColor),
//                                     counterText: '',
//                                     fillColor: ColorConstants.kWhite,
//                                     filled: true,
//                                     enabledBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(color: ColorConstants.kWhite),
//                                     ),
//                                     prefixIcon: Container(
//                                         padding:
//                                         EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                         margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                         decoration: const BoxDecoration(
//                                           color: ColorConstants.kSecondaryColor,
//                                         ),
//                                         child: IconButton(
//                                           onPressed: scanBarCode,
//                                           icon: const Icon(
//                                             MdiIcons.barcodeScan,
//                                             color: ColorConstants.kWhite,
//                                           ),
//                                         )),
//                                     contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                     isDense: true,
//                                     border: OutlineInputBorder(
//                                         borderSide:
//                                         const BorderSide(color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20.0.w.toDouble()),
//                                           bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                         )),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                         const BorderSide(color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20.0.w.toDouble()),
//                                           bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                         ))),
//                                 validator: (text) {
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                       backgroundColor: MaterialStateProperty.all<Color>(
//                                           ColorConstants.kWhite),
//                                       shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                           RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius.circular(10.w.toDouble()),
//                                               side: const BorderSide(
//                                                   color: ColorConstants.kSecondaryColor)))),
//                                   onPressed: () {
//                                     if (articleNumberController.text.isEmpty) {
//                                       articleNumberFocusNode.requestFocus();
//                                       Toast.showFloatingToast(
//                                           'Enter the Article number', context);
//                                     } else if (expansionArticle
//                                         .contains(articleNumberController.text)) {
//                                       Toast.showFloatingToast(
//                                           'Article already scanned', context);
//                                     } else {
//                                       if (_bagFetched == true) {
//                                         if (jsonBagArticles.contains(articleNumberController.text)) {
//                                           final index = jsonBagArticles.indexWhere((element) => element == articleNumberController.text);
//                                           var typeOfJSONArticle = jsonBagArticleTypes[index];
//                                           if (typeArticle != typeOfJSONArticle) {
//                                             showArticleAddDialog(articleNumberController.text, typeArticle);
//                                           }
//                                         } else {
//                                           showArticleAddDialog(articleNumberController.text, typeArticle);
//                                         }
//                                       } else {
//                                         setState(() {
//                                           expansionArticle.add(articleNumberController.text);
//                                           expansionArticleType.add(typeArticle);
//                                           articleNumberController.clear();
//                                         });
//                                       }
//                                     }
//                                   },
//                                   child: Padding(
//                                     padding:
//                                     EdgeInsets.symmetric(vertical: 18.0.w.toDouble()),
//                                     child: const Text(
//                                       'ADD',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           color: ColorConstants.kAmberAccentColor),
//                                     ),
//                                   ),
//                                 ))
//                           ],
//                         ),
//                       ),
//                       const SmallSpace(),
//                       Visibility(
//                           visible: _selectedVPArticle,
//                           child: Column(
//                             children: [
//                               TextFormField(
//                                 focusNode: vpArticleNumberFocusNode,
//                                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                                 controller: vpArticleNumberController,
//                                 style: TextStyle(color: ColorConstants.kSecondaryColor, letterSpacing: 1.sp),
//                                 textCapitalization: TextCapitalization.characters,
//                                 keyboardType: TextInputType.text,
//                                 decoration: InputDecoration(
//                                     hintText: 'Article Number',
//                                     hintStyle: const TextStyle(
//                                         color: ColorConstants.kAmberAccentColor),
//                                     counterText: '',
//                                     fillColor: ColorConstants.kWhite,
//                                     filled: true,
//                                     enabledBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(color: ColorConstants.kWhite),
//                                     ),
//                                     prefixIcon: Container(
//                                         padding:
//                                         EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                         margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                         decoration: const BoxDecoration(
//                                           color: ColorConstants.kSecondaryColor,
//                                         ),
//                                         child: IconButton(
//                                           onPressed: scanBarCode,
//                                           icon: const Icon(
//                                             MdiIcons.barcodeScan,
//                                             color: ColorConstants.kWhite,
//                                           ),
//                                         )),
//                                     contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                     isDense: true,
//                                     border: OutlineInputBorder(
//                                         borderSide:
//                                         const BorderSide(color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20.0.w.toDouble()),
//                                           bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                         )),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                         const BorderSide(color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(20.0.w.toDouble()),
//                                           bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                         ))),
//                                 validator: (text) {
//                                   return null;
//                                 },
//                               ),
//                               const SmallSpace(),
//                               Row(
//                                 children: [
//                                   Expanded(flex: typeArticle != "COD" ? 2 : 4, child: TextFormField(
//                                     focusNode: vpAmountFocusNode,
//                                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                                     controller: vpAmountController,
//                                     style:
//                                     const TextStyle(color: ColorConstants.kSecondaryColor),
//                                     textCapitalization: TextCapitalization.characters,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                         border: const OutlineInputBorder(
//                                           borderSide: BorderSide.none,
//                                         ),
//                                         hintText: typeArticle != "COD" ? 'VP Amount' : 'COD Amount',
//                                         hintStyle: const TextStyle(
//                                             color: ColorConstants.kAmberAccentColor),
//                                         counterText: '',
//                                         fillColor: ColorConstants.kWhite,
//                                         filled: true,
//                                         enabledBorder: const OutlineInputBorder(
//                                           borderSide: BorderSide(color: ColorConstants.kWhite),
//                                         ),
//                                         contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                         isDense: true),
//                                     validator: (text) {
//                                       return null;
//                                     },
//                                   )),
//                                   SizedBox(width: 10.w,),
//                                   Visibility(
//                                     visible: typeArticle != "COD" ? true : false,
//                                     child: Expanded(flex: 2, child: TextFormField(
//                                       focusNode: vpCommissionFocusNode,
//                                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                                       controller: vpCommissionController,
//                                       style:
//                                       const TextStyle(color: ColorConstants.kSecondaryColor),
//                                       textCapitalization: TextCapitalization.characters,
//                                       keyboardType: TextInputType.number,
//                                       decoration: InputDecoration(
//                                           border: const OutlineInputBorder(
//                                             borderSide: BorderSide.none,
//                                           ),
//                                           hintText: 'Commission',
//                                           hintStyle: const TextStyle(
//                                               color: ColorConstants.kAmberAccentColor),
//                                           counterText: '',
//                                           fillColor: ColorConstants.kWhite,
//                                           filled: true,
//                                           enabledBorder: const OutlineInputBorder(
//                                             borderSide: BorderSide(color: ColorConstants.kWhite),
//                                           ),
//                                           contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                           isDense: true),
//                                       validator: (text) {
//                                         return null;
//                                       },
//                                     )),
//                                   ),
//                                   SizedBox(width: 10.w,),
//                                   Expanded(
//                                       flex: 1,
//                                       child: ElevatedButton(
//                                         style: ButtonStyle(
//                                             backgroundColor: MaterialStateProperty.all<Color>(
//                                                 ColorConstants.kWhite),
//                                             shape: MaterialStateProperty.all<
//                                                 RoundedRectangleBorder>(
//                                                 RoundedRectangleBorder(
//                                                     borderRadius:
//                                                     BorderRadius.circular(10.w.toDouble()),
//                                                     side: const BorderSide(
//                                                         color: ColorConstants.kSecondaryColor)))),
//                                         onPressed: () {
//                                           if (vpArticleNumberController.text.isEmpty) {
//                                             Toast.showFloatingToast(
//                                                 'Enter the Article number', context);
//                                           } else if (expansionArticle
//                                               .contains(vpArticleNumberController.text)) {
//                                             Toast.showFloatingToast(
//                                                 'Article already scanned', context);
//                                           } else {
//                                             setState(() {
//                                               expansionArticle.add(vpArticleNumberController.text);
//                                               expansionArticleType.add(typeArticle);
//                                               vpArticleNumberController.clear();
//                                               vpCommissionController.clear();
//                                               vpAmountController.clear();
//                                             });
//                                           }
//                                         },
//                                         child: Padding(
//                                           padding:
//                                           EdgeInsets.symmetric(vertical: 18.0.w.toDouble()),
//                                           child: const Text(
//                                             'ADD',
//                                             overflow: TextOverflow.ellipsis,
//                                             style: TextStyle(
//                                                 color: ColorConstants.kAmberAccentColor),
//                                           ),
//                                         ),
//                                       ))
//                                 ],
//                               ),
//                               const SmallSpace()],
//                           )),
//                       expansionArticle.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200.h),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(12.0),
//                           ),
//                         ),
//                         child: Scrollbar(
//                           showTrackOnHover: true,
//                           child: ListView.builder(
//                               physics: const AlwaysScrollableScrollPhysics(),
//                               itemCount: expansionArticle.length,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 20.0.w),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                           flex: 4,
//                                           child: Text(
//                                             expansionArticle[index],
//                                             style: const TextStyle(
//                                                 letterSpacing: 1,
//                                                 color: ColorConstants.kTextColor,
//                                                 fontWeight: FontWeight.w500),
//                                           )),
//                                       Expanded(
//                                           flex: 2,
//                                           child: Text(expansionArticleType[index],
//                                               style: const TextStyle(
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: ColorConstants.kTextColor))),
//                                       Expanded(
//                                           flex: 1,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 showArticleDeleteDialog(
//                                                     expansionArticle[index],
//                                                     expansionArticleType[index]);
//                                               },
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 color:
//                                                 Colors.redAccent.withOpacity(.8),
//                                               ))),
//                                       Expanded(
//                                           flex: 1,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 showArticleEditDialog(
//                                                     expansionArticle[index],
//                                                     expansionArticleType[index]);
//                                               },
//                                               icon: const Icon(
//                                                 Icons.edit,
//                                                 color: Colors.blueGrey,
//                                               ))),
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ),
//                       ),
//                       const Divider(),
//                       const SmallSpace(),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                               controller: inventoryNameController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor, letterSpacing: 1),
//                               decoration: InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(color: ColorConstants.kWhite),
//                                   ),
//                                   prefixIcon: Container(
//                                       padding:
//                                       EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                       margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                       decoration: const BoxDecoration(
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: (){},
//                                         icon: const Icon(
//                                           MdiIcons.postageStamp,
//                                           color: ColorConstants.kWhite,
//                                         ),
//                                       )),
//                                   isDense: true,
//                                   border: InputBorder.none,
//                                   hintText: 'Inventory Name',
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   focusedBorder: const OutlineInputBorder(
//                                       borderSide:
//                                       BorderSide(color: ColorConstants.kWhite))),
//                             ),
//                           ),
//                           SizedBox(width: 10.w,),
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: inventoryQuantityController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor, letterSpacing: 1),
//                               decoration: InputDecoration(
//                                   border: const OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   hintText: 'Quantity',
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(color: ColorConstants.kWhite),
//                                   ),
//                                   contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                   isDense: true),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SmallSpace(),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               keyboardType: TextInputType.number,
//                               controller: inventoryPriceController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor, letterSpacing: 1),
//                               onChanged: (text) {
//                                 inventoryTotalController.text = (int.parse(text) * int.parse(inventoryQuantityController.text)).toString();
//                               },
//                               decoration: const InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide:
//                                     BorderSide(color: ColorConstants.kWhite),
//                                   ),
//                                   hintStyle: TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   hintText: 'Price',
//                                   isDense: true,
//                                   border: InputBorder.none,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide:
//                                       BorderSide(color: ColorConstants.kWhite))),
//                             ),
//                           ),
//                           SizedBox(width: 10.w,),
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               readOnly: true,
//                               keyboardType: TextInputType.number,
//                               controller: inventoryTotalController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor, letterSpacing: 1),
//                               decoration: const InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide:
//                                     BorderSide(color: ColorConstants.kWhite),
//                                   ),
//                                   hintStyle: TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   hintText: 'Total',
//                                   isDense: true,
//                                   border: InputBorder.none,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide:
//                                       BorderSide(color: ColorConstants.kWhite))),
//                             ),
//                           ),
//                           SizedBox(width: 10.w,),
//                           Expanded(
//                               flex: 1,
//                               child: ElevatedButton(
//                                 style: ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.all<Color>(
//                                         ColorConstants.kWhite),
//                                     shape:
//                                     MaterialStateProperty.all<RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(10.w.toDouble()),
//                                             side: const BorderSide(
//                                                 color:
//                                                 ColorConstants.kSecondaryColor)))),
//                                 onPressed: () {
//                                   if (inventoryNameController.text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Inventory name', context);
//                                   } else if (expansionInventoryName
//                                       .contains(inventoryNameController.text)) {
//                                     Toast.showFloatingToast(
//                                         'Inventory Already added', context);
//                                   } else if (inventoryQuantityController.text.isEmpty) {
//                                     Toast.showFloatingToast('Enter the Quantity', context);
//                                   } else if (inventoryPriceController.text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Price of 1 item', context);
//                                   } else {
//                                     setState(() {
//                                       expansionInventoryName.add(inventoryNameController.text);
//                                       expansionInventoryQuantity.add(inventoryQuantityController.text);
//                                       expansionInventoryPrice.add(inventoryPriceController.text);
//                                       expansionInventoryTotal.add(inventoryTotalController.text);
//                                       inventoryNameController.clear();
//                                       inventoryQuantityController.clear();
//                                       inventoryPriceController.clear();
//                                       inventoryTotalController.clear();
//                                     });
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   EdgeInsets.symmetric(vertical: 18.0.w.toDouble()),
//                                   child: const Text(
//                                     'ADD',
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                     TextStyle(color: ColorConstants.kAmberAccentColor),
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ),
//                       const SmallSpace(),
//                       expansionInventoryName.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200.h),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(12.0),
//                           ),
//                         ),
//                         child: Scrollbar(
//                           showTrackOnHover: true,
//                           child: ListView.builder(
//                               itemCount: expansionInventoryName.length,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     Padding(
//                                       padding:
//                                       EdgeInsets.symmetric(horizontal: 20.0.w),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 4,
//                                               child: Text(
//                                                 expansionInventoryName[index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants.kTextColor,
//                                                     fontWeight: FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text(
//                                                 expansionInventoryQuantity[index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants.kTextColor,
//                                                     fontWeight: FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text(
//                                                 '\u{20B9}' +
//                                                     expansionInventoryPrice[index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants.kTextColor,
//                                                     fontWeight: FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: IconButton(
//                                                   onPressed: () {
//                                                     showInventoryDeleteDialog(
//                                                         expansionInventoryName[index],
//                                                         expansionInventoryQuantity[index],
//                                                         expansionInventoryPrice[index],
//                                                         expansionInventoryTotal[index]);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.delete,
//                                                     color: Colors.redAccent
//                                                         .withOpacity(.8),
//                                                   ))),
//                                           Expanded(
//                                               flex: 1,
//                                               child: IconButton(
//                                                   onPressed: () {
//                                                     showInventoryEditDialog(
//                                                         expansionInventoryName[index],
//                                                         expansionInventoryQuantity[index],
//                                                         expansionInventoryPrice[index],
//                                                         expansionInventoryTotal[index]);
//                                                   },
//                                                   icon: const Icon(
//                                                     Icons.edit,
//                                                     color: Colors.blueGrey,
//                                                   ))),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ),
//                       const SmallSpace(),
//                       const Divider(),
//                       const SmallSpace(),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                               maxLines: null,
//                               focusNode: documentFocusNode,
//                               autovalidateMode: AutovalidateMode.onUserInteraction,
//                               controller: documentsController,
//                               style:
//                               const TextStyle(color: ColorConstants.kSecondaryColor),
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   hintText: 'Document Name',
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(color: ColorConstants.kWhite),
//                                   ),
//                                   prefixIcon: Container(
//                                       padding:
//                                       EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                       margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                       decoration: const BoxDecoration(
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: (){},
//                                         icon: const Icon(
//                                           Icons.description,
//                                           color: ColorConstants.kWhite,
//                                         ),
//                                       )),
//                                   contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                   isDense: true,
//                                   border: const OutlineInputBorder(
//                                       borderSide:
//                                       BorderSide(color: ColorConstants.kWhite),
//                                     ),
//                                   focusedBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(color: ColorConstants.kWhite),
//                                      )),
//                               validator: (text) {
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           Expanded(
//                               flex: 1,
//                               child: ElevatedButton(
//                                 style: ButtonStyle(
//                                     backgroundColor: MaterialStateProperty.all<Color>(
//                                         ColorConstants.kWhite),
//                                     shape:
//                                     MaterialStateProperty.all<RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                             borderRadius:
//                                             BorderRadius.circular(10.w.toDouble()),
//                                             side: const BorderSide(
//                                                 color:
//                                                 ColorConstants.kSecondaryColor)))),
//                                 onPressed: () {
//                                   if (documentsController.text.isEmpty) {
//                                     Toast.showFloatingToast('Enter the Document', context);
//                                   } else {
//                                     setState(() {
//                                       expansionDocuments.add(documentsController.text);
//                                       documentsController.clear();
//                                     });
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding:
//                                   EdgeInsets.symmetric(vertical: 18.0.w.toDouble()),
//                                   child: const Text(
//                                     'ADD',
//                                     overflow: TextOverflow.ellipsis,
//                                     style:
//                                     TextStyle(color: ColorConstants.kAmberAccentColor),
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ),
//                       const SmallSpace(),
//                       expansionDocuments.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200.h),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(12.0),
//                           ),
//                         ),
//                         child: Scrollbar(
//                           showTrackOnHover: true,
//                           child: ListView.builder(
//                               itemCount: expansionDocuments.length,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     Padding(
//                                       padding:
//                                       EdgeInsets.symmetric(horizontal: 20.0.w),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 4,
//                                               child: Text(
//                                                 expansionDocuments[index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants.kTextColor,
//                                                     fontWeight: FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: IconButton(
//                                                   onPressed: () {
//                                                     showDocumentDeleteDialog(expansionDocuments[index]);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.delete,
//                                                     color: Colors.redAccent
//                                                         .withOpacity(.8),
//                                                   ))),
//                                           Expanded(
//                                               flex: 1,
//                                               child: IconButton(
//                                                   onPressed: () {
//                                                     showDocumentEditDialog(expansionDocuments[index]);
//                                                   },
//                                                   icon: const Icon(
//                                                     Icons.edit,
//                                                     color: Colors.blueGrey,
//                                                   ))),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ),
//                       const SmallSpace(),
//                       const Divider(),
//                       const SmallSpace(),
//                       TextFormField(
//                         keyboardType: TextInputType.number,
//                         controller: amountController,
//                         style: const TextStyle(
//                             color: ColorConstants.kTextColor, letterSpacing: 1),
//                         decoration: InputDecoration(
//                             counterText: '',
//                             fillColor: ColorConstants.kWhite,
//                             filled: true,
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite),
//                             ),
//                             hintText: 'Amount Received',
//                             hintStyle: const TextStyle(
//                                 color: ColorConstants.kAmberAccentColor),
//                             prefixIcon: Container(
//                                 padding:
//                                 EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                 margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                 decoration: const BoxDecoration(
//                                   color: ColorConstants.kSecondaryColor,
//                                 ),
//                                 child: IconButton(
//                                   onPressed: (){},
//                                   icon: const Icon(
//                                     MdiIcons.currencyInr,
//                                     color: ColorConstants.kWhite,
//                                   ),
//                                 )),
//                             isDense: true,
//                             border: InputBorder.none,
//                             focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(color: ColorConstants.kWhite))),
//                       ),
//                       Align(
//                           alignment: Alignment.center,
//                           child: Button(
//                               buttonText: 'SAVE',
//                               buttonFunction: () async {
//                                 await addingData();
//                                 Toast.showToast(
//                                     'Details has been added for the Bag ${widget.bagNumber}',
//                                     context);
//                                 Navigator.pushAndRemoveUntil(context,
//                                     MaterialPageRoute(builder: (_) => BaggingServices()),
//                                         (route) => false);
//                               }))
//                     ],
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Future<bool> addingData() async {
//     await addArticlesToBag();
//     await addInventoryToBag();
//     await addDocumentsToBag();
//     await addCashMain();
//     return true;
//   }
//
//   addArticlesToBag() async {
//     if (expansionArticle.isNotEmpty) {
//       for (int i = 0; i < expansionArticle.length; i++) {
//         await BaggingDBService().updateBagArticlesToDB(
//             widget.bagNumber, expansionArticle[i], expansionArticleType[i], 'Added');
//         await BaggingDBService().addArticlesToDelivery(
//             widget.bagNumber, expansionArticle[i], expansionArticleType[i]);
//       }
//     }
//   }
//
//   addInventoryToBag() async {
//     if (expansionInventoryName.isNotEmpty) {
//       for (int i = 0; i < expansionInventoryName.toSet().toList().length; i++) {
//         await BaggingDBService().addInventoryFromBagToDB(
//             expansionInventoryName[i],
//             expansionInventoryPrice[i],
//             expansionInventoryQuantity[i],
//             (int.parse(expansionInventoryPrice[i]) *
//                 int.parse(expansionInventoryQuantity[i]))
//                 .toString(),
//             widget.bagNumber,
//             'Added');
//         await BaggingDBService().addProductsMain(
//             expansionInventoryName[i],
//             int.parse(expansionInventoryPrice[i]),
//             int.parse(expansionInventoryQuantity[i]));
//       }
//     }
//   }
//
//   addDocumentsToBag() async {
//     if (expansionDocuments.isNotEmpty) {
//       for (int i = 0; i < expansionDocuments.length; i++) {
//         await BaggingDBService()
//             .updateBagDocumentsToDB(widget.bagNumber, expansionDocuments[i], 'Y', 'Added');
//       }
//     }
//   }
//
//   addCashMain() async {
//     print("Adding cash");
//     if (amountController.text.isNotEmpty) {
//       await BaggingDBService().addCashReceive(amountController.text, widget.bagNumber);
//     }
//   }
//
//   void moveToPrevious(BuildContext context){
//     showDialog(context: context, builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Note!'),
//         content: const Text('Do you wish to save the details entered and then leave the page?'),
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Button(buttonText: 'CANCEL', buttonFunction: () {
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false);
//               }),
//               Button(buttonText: 'SAVE', buttonFunction: () async {
//                 await addingData();
//                 Toast.showToast(
//                     'Details has been added for the Bag ${widget.bagNumber}',
//                     context);
//                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false);
//               },)
//             ],
//           )
//         ],
//       );
//     });
//   }
// }
