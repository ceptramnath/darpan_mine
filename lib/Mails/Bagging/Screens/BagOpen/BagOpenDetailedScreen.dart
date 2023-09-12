// import 'dart:convert';
//
// import 'package:darpan_mine/Constants/Calculations.dart';
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagOpenModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Mails/BaggingServices.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/Utils/Scan.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import 'BagOpenScreen.dart';
//
// class BagAddDetailsReplica extends StatefulWidget {
//   final String bagNumber;
//   final bool isDataEntry;
//
//   const BagAddDetailsReplica(
//       {Key? key, required this.bagNumber, required this.isDataEntry})
//       : super(key: key);
//
//   @override
//   _BagAddDetailsReplicaState createState() => _BagAddDetailsReplicaState();
// }
//
// class _BagAddDetailsReplicaState extends State<BagAddDetailsReplica> {
//   var typeArticle = null;
//
//   String? articleType;
//   String? boSlipNumber;
//   String jsonBagCashReceived = '';
//   var infer;
//   List expansionArticle = [];
//   List expansionArticleType = [];
//   List expansionAmount = [];
//   List expansionCommission = [];
//
//   List expansionInventoryName = [];
//   List expansionInventoryPrice = [];
//   List expansionInventoryQuantity = [];
//   List expansionInventoryTotal = [];
//   List expansionDocuments = [];
//   List jsonBagArticles = [];
//   List alreadyScannedArticles = [];
//   List unScannedArticles = [];
//   List bagAddedStamps = [];
//   List bagStamps = [];
//   List bagDocuments = [];
//   List bagCash = [];
//   List<bool> jsonArticles = [];
//   List<bool> receivedArticles = [];
//   List<bool> receivedInventory = [];
//   List<bool> receivedDocuments = [];
//   List<bool> alreadyPresentArticles = [];
//   List<String> boStampSlipNumber = [];
//   List<BagArticlesModel> bagArticlesModel = [];
//   List<ArticlesinBag> articlesInBag = [];
//   Map<String, dynamic> masterData = {};
//
//   Map<String, bool> articleMap = {};
//
//   // bool isDE = false;
//   bool bagFetched = false;
//   bool selectedArticle = false;
//   bool selectedRegularArticle = false;
//   bool selectedVPArticle = false;
//   bool selectedEMOArticle = false;
//
//   final bagNumberFocus = FocusNode();
//   final articleNumberFocusNode = FocusNode();
//   final vpArticleNumberFocusNode = FocusNode();
//   final vpAmountFocusNode = FocusNode();
//   final vpCommissionFocusNode = FocusNode();
//   final emoFocusNode = FocusNode();
//   final emoAmountFocusNode = FocusNode();
//   final documentFocusNode = FocusNode();
//   final inventoryidFocusNode = FocusNode();
//
//   final bagController = TextEditingController();
//   final articleNumberController = TextEditingController();
//   final vpArticleNumberController = TextEditingController();
//   final vpAmountController = TextEditingController();
//   final vpCommissionController = TextEditingController();
//   final emoController = TextEditingController();
//   final emoAmountController = TextEditingController();
//   final editArticleNumberController = TextEditingController();
//   final dialogVPPAmountController = TextEditingController();
//   final inventoryNameController = TextEditingController();
//   final inventoryQuantityController = TextEditingController();
//   final inventoryPriceController = TextEditingController();
//   final inventoryTotalController = TextEditingController();
//   final inverntoryIDController = TextEditingController();
//
//   final editInventoryNameController = TextEditingController();
//   final editInventoryQuantityController = TextEditingController();
//   final editInventoryPriceController = TextEditingController();
//   final editInventoryTotalController = TextEditingController();
//   final documentsController = TextEditingController();
//   final editDocumentsController = TextEditingController();
//   final amountController = TextEditingController();
//   final customdutyController = TextEditingController();
//   bool customVisible = false;
//
//   final _articleTypes = [
//     'PARCEL',
//     'LETTER',
//     'SP_INLAND',
//     'EMO',
//     'VPP',
//     'VPL',
//     'COD'
//   ];
//
//   String? _chosenProductID;
//   List<String> productID=[];
//   Future? fetchProductMaster;
//   List<ProductsMaster> productMasterList = [];
//
//
//   @override
//   void initState() {
//     print('Bag Open Screen. IsData Entry -');
//     print(widget.isDataEntry);
//
//     bagController.text = widget.bagNumber;
//     // isDE=widget.isDataEntry;
//     // print('Bag Open Screen Value of DE- '+ isDE.toString());
//
//     // setState(() {
//     //   isDE= widget.isDataEntry;
//     // });
//     emoAmountFocusNode.addListener(() {
//       var commission = 0;
//       if (!emoAmountFocusNode.hasFocus) {
//         commissionAmt = 0;
//         commission = double.parse(emoAmountController.text) ~/ 20;
//         double.parse(emoAmountController.text) % 20 != 0
//             ? commission += 1
//             : commission += 0;
//         commissionAmt = commission.toInt();
//         setState(() {
//           vpCommissionController.text = commissionAmt.toString();
//         });
//       }
//     });
//
//     print('Fetching Product Master Data..!');
//     // fetchProductMaster= getProductMaster();
//
//     // if (isDE)
//     //   Toast.showFloatingToast(
//     //       'Virtual Data not received for this bag number..!', context);
//     super.initState();
//   }
//
//   getProductMaster() async{
//     productMasterList.clear();
//     productID.clear();
//     print("ProductMaster before fetch");
//     print(productMasterList.length);
//     productMasterList = await ProductsMaster().distinct(columnsToSelect: ['ItemCode','ShortDescription','SalePrice']).toList();
//     print("ProductMaster after fetch");
//     print(productMasterList.length);
//     print("ProductMaster codes");
//     for(int i=0;i<productMasterList.length;i++){
//       print(productMasterList[i].ItemCode);
//     }
//     if(productMasterList.length>0)
//     {
//       print('Product Master is available in DB..!');
//       for(int i =0;i<productMasterList.length;i++) {
//         // setState(() {
//         productID.add(productMasterList[i].ItemCode.toString());
//         // });
//
//       }
//     }
//     else{
//       print('Product Master is not available in DB..!');
//     }
//
//   }
//
//
//   fetchDetails() async {
//     /*-------------------------------------BO Slip--------------------------------------*/
//     final bagDetails = await BSRDETAILS_NEW()
//         .select()
//         .BAGNUMBER
//         .equals(widget.bagNumber)
//         .toMapList();
//
//     if (bagDetails.isNotEmpty) {
//       boSlipNumber = bagDetails[0]['BOSLIPID'];
//     }
//
//     if (bagFetched == false) {
//       /*------------------------------------Articles------------------------------------*/
//       for (int i = 0; i < expansionArticle.length; i++) {
//         alreadyScannedArticles = await Delivery()
//             .select()
//             .ART_NUMBER
//             .equals(expansionArticle[i])
//             .toMapList();
//         if (alreadyScannedArticles.isNotEmpty) {
//           final index = expansionArticle.indexWhere(
//                   (element) => element == alreadyScannedArticles[0]['ART_NUMBER']);
//           alreadyPresentArticles.insert(index, true);
//         }
//       }
//
//       final bagArticles =
//       await Delivery().select().BAG_ID.equals(widget.bagNumber).toMapList();
//
//       if (bagArticles.isNotEmpty) {
//         print('bagArticles.isNotEmpty');
//         if (bagDetails.isEmpty) {
//           boSlipNumber = bagArticles[0]['BO_SLIP'];
//         }
//         print(bagArticles.length);
//         for (int i = 0; i < bagArticles.length; i++) {
//           if (!expansionArticle.contains(bagArticles[i]['ART_NUMBER'])) {
//             print(bagArticles[i]['ART_NUMBER']);
//             jsonArticles.add(true);
//             receivedArticles.add(false);
//             articleMap.addAll({bagArticles[i]['ART_NUMBER']: false});
//             bagArticlesModel.add(BagArticlesModel(
//                 articleNumber: bagArticles[i]['ART_NUMBER'],
//                 isReceived: false));
//             jsonBagArticles.add(bagArticles[i]['ART_NUMBER']);
//             expansionArticle.add(bagArticles[i]['ART_NUMBER'].toString());
//             expansionArticleType.add(bagArticles[i]['MATNR'].toString());
//             print("LLLLLLLLLLLLLLLLLLLLL");
//             print(bagArticles[i]['ART_NUMBER']);
//             print(bagArticles[i]['MATNR']);
//             print(bagArticles[i]['MONEY_TO_BE_COLLECTED']);
//             print(bagArticles[i]['COMMISSION']);
//
//             articlesInBag.add(ArticlesinBag(
//                 articleNumber: bagArticles[i]['ART_NUMBER'],
//                 articleType: bagArticles[i]['MATNR'],
//                 amount: bagArticles[i]['MONEY_TO_BE_COLLECTED'].toString(),
//                 commission: bagArticles[i]['COMMISSION'].toString()));
//             print("========================");
//           }
//         }
//       }
//       print("Received Articles length: ${receivedArticles.length}");
//       print("Received articles: $receivedArticles");
//
//
//       /*---------------------------------Inventory Data---------------------------------*/
//
//       bagAddedStamps = await BagStampsTable()
//           .select()
//           .BagNumber
//           .equals(widget.bagNumber)
//           .toMapList();
//       if (bagAddedStamps.isNotEmpty) {
//         print('bagAddedStamps.isNotEmpty');
//         for (int i = 0; i < bagAddedStamps.length; i++) {
//           expansionInventoryName.add(bagAddedStamps[i]['StampName']);
//           expansionInventoryPrice.add(bagAddedStamps[i]['StampPrice']);
//           expansionInventoryQuantity.add(bagAddedStamps[i]['StampQuantity']);
//           expansionInventoryTotal.add(
//               int.parse(bagAddedStamps[i]['StampQuantity']) *
//                   int.parse(bagAddedStamps[i]['StampPrice']));
//           if (bagAddedStamps[i]['Status'] == 'Added') {
//             receivedInventory.add(true);
//           } else {
//             receivedInventory.add(false);
//           }
//         }
//       }
//       if (boSlipNumber.toString() != "null") {
//         bagStamps = await BOSLIP_STAMP1()
//             .select()
//             .BO_SLIP_NO
//             .equals(boSlipNumber)
//             .toMapList();
//         if (bagStamps.isNotEmpty) {
//           print('bagStamps.isNotEmpty');
//           for (int i = 0; i < bagStamps.length; i++) {
//             final product = await ProductsMaster()
//                 .select()
//                 .ItemCode
//                 .equals(bagStamps[i]['MATNR'])
//                 .toMapList();
//             if (product.isNotEmpty) {
//               for (int j = 0; j < product.length; j++) {
//                 if (!expansionInventoryName
//                     .contains(product[j]['ShortDescription'])) {
//                   var quantity = double.parse(bagStamps[i]['MENGE_D']) ~/
//                       double.parse(product[j]['SalePrice']);
//                   var salePrice =
//                   (double.parse(product[j]['SalePrice'])).toInt();
//                   var total = (double.parse(bagStamps[i]['MENGE_D'])).toInt();
//                   expansionInventoryName.add(product[j]['ShortDescription']);
//                   expansionInventoryPrice.add(salePrice);
//                   expansionInventoryQuantity.add(quantity);
//                   expansionInventoryTotal.add(total);
//                   receivedInventory.add(false);
//                 }
//               }
//             } else {
//               Toast.showFloatingToast(
//                   'Product details of ${bagStamps[i]['MATNR']} not available',
//                   context);
//             }
//           }
//         }
//       }
//
//       /*---------------------------------Documents Data---------------------------------*/
//
//       final bagDBDocuments = await BagDocumentsTable()
//           .select()
//           .BagNumber
//           .equals(widget.bagNumber)
//           .toMapList();
//       if (bagDBDocuments.isNotEmpty) {
//         for (int i = 0; i < bagDBDocuments.length; i++) {
//           if (!expansionDocuments.contains(bagDBDocuments[i]['DocumentName'])) {
//             expansionDocuments
//                 .add(bagDBDocuments[i]['DocumentName'].toString().trim());
//             if (bagDBDocuments[i]['DocumentStatus'] == 'Added') {
//               receivedDocuments.add(true);
//             } else {
//               receivedDocuments.add(false);
//             }
//           }
//         }
//       }
//
//       print('BO SLIP Number - ' + boSlipNumber.toString());
//       if (boSlipNumber.toString() != "null") {
//         final boSlipDocuments = await BOSLIP_DOCUMENT1()
//             .select()
//             .BO_SLIP_NO
//             .equals(boSlipNumber)
//             .toMapList();
//         if (boSlipDocuments.isNotEmpty) {
//           print('boSlipDocuments.isNotEmpty');
//           for (int i = 0; i < boSlipDocuments.length; i++) {
//             if (boSlipDocuments[i]['IS_RCVD'].toString() != 'Y') {
//               if (!expansionDocuments
//                   .contains(boSlipDocuments[i]['DOCUMENT_DETAILS'])) {
//                 expansionDocuments.add(boSlipDocuments[i]['DOCUMENT_DETAILS']);
//                 receivedDocuments.add(false);
//               }
//             }
//           }
//         }
//       }
//       /*-----------------------------------Cash Data------------------------------------*/
//
//       final bagCash = await BagCashTable()
//           .select()
//           .BagNumber
//           .equals(widget.bagNumber)
//           .toMapList();
//       if (bagCash.isNotEmpty) {
//         print('bagCash.isNotEmpty');
//         amountController.text = bagCash[0]['CashReceived'].toString();
//       } else if (boSlipNumber.toString() != "null") {
//         final boSlipCash = await BOSLIP_CASH1()
//             .select()
//             .BO_SLIP_NO
//             .equals(boSlipNumber)
//             .toMapList();
//         if (boSlipCash.isNotEmpty) {
//           amountController.text = boSlipCash[0]['AMOUNT'].toString().trim();
//         } else {
//           amountController.text = '0';
//         }
//       }
//     }
//     bagFetched = true;
//     await getProductMaster();
//     return true;
//   }
//
//   scanArticles() async {
//     print('scanArticles function');
//     var scan = await Scan().scanBag();
//
//     if (expansionArticle.contains(scan))  {
//       print('inside scan function- ');
//       print(scan.toString());
//       final index = expansionArticle.indexWhere((element) => element == scan);
//       print("Index after scanning: $index");
//       if (receivedArticles[index] == true) {
//         print("Index in receivedArticles: $receivedArticles");
//         Toast.showFloatingToast('$scan has been already added', context);
//       } else {
//
//         setState(() {
//           print('inside setState scanArticles');
//
//           for (final articleNumber in articleMap.entries) {
//             print('inside for loop');
//             if (articleNumber.key == scan) {
//               print('inside scan function- 1st if');
//
//               articleMap.update(articleNumber.key, (value) => true);
//               print(articleNumber.key);
//               print(articleNumber.value);
//             }
//           }
//         });
//
//         // receivedArticles.insert(index, true);
//         receivedArticles[index]=true;
//         Toast.showFloatingToast('$scan has been added', context);
//       }
//     }
//     else {
//       articleNumberController.text = scan;
//       Toast.showFloatingToast('$scan is not received virtually..!', context);
//     }
//   }
//
//
//   void _dropDownItemSelected(String valueSelectedByUser) {
//     setState(() {
//       typeArticle = valueSelectedByUser;
//       selectedArticle = true;
//       if (valueSelectedByUser == 'VPP' ||
//           valueSelectedByUser == 'VPL' ||
//           valueSelectedByUser == 'COD') {
//         selectedVPArticle = true;
//         selectedRegularArticle = false;
//         selectedEMOArticle = false;
//       } else if (valueSelectedByUser == 'EMO') {
//         selectedRegularArticle = false;
//         selectedEMOArticle = true;
//         selectedVPArticle = false;
//       } else {
//         selectedRegularArticle = true;
//         selectedEMOArticle = false;
//         selectedVPArticle = false;
//       }
//     });
//   }
//
//   showArticleAddDialog(String articleNumber, String typeOfArticle) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: RichText(
//               text: TextSpan(
//                 text: 'Article ',
//                 style: TextStyle(
//                     letterSpacing: 1,
//                     color: ColorConstants.kTextColor,
//                     fontSize: 14),
//                 children: <TextSpan>[
//                   TextSpan(
//                       text: articleNumber,
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: ' of type ',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: typeOfArticle,
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text:
//                       ' is not available in bag, would you still like to ',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: 'ADD',
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: ' it ?',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                 ],
//               ),
//             ),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () => Navigator.pop(context)),
//                   Button(
//                       buttonText: 'CONFIRM',
//                       buttonFunction: () {
//                         setState(() {
//                           jsonArticles.add(true);
//                           receivedArticles.add(false);
//                           expansionArticle.add(articleNumberController.text);
//                           expansionArticleType.add(typeArticle);
//                           articleNumberController.clear();
//                           Navigator.of(context).pop();
//                         });
//                       })
//                 ],
//               )
//             ],
//           );
//         });
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
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: editArticleNumberController
//                         ..text = articleNumber,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.email,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: Padding(
//                       padding:
//                       EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
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
//                   ),
//                   const Space(),
//                   typeOfArticle == 'VPL' ||
//                       typeOfArticle == 'COD' ||
//                       typeOfArticle == 'VPP'
//                       ? Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius:
//                         BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: dialogVPPAmountController,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.currencyInr,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: ColorConstants.kWhite))),
//                     ),
//                   )
//                       : Container()
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(
//                 buttonText: 'CANCEL',
//                 buttonFunction: () => Navigator.pop(context)),
//             Button(
//                 buttonText: 'SAVE',
//                 buttonFunction: () {
//                   final index = expansionArticle
//                       .indexWhere((element) => element == articleNumber);
//                   expansionArticle.removeAt(index);
//                   expansionArticleType.removeAt(index);
//                   expansionArticle.add(editArticleNumberController.text);
//                   expansionArticleType.add(typeOfArticle);
//                   Navigator.pop(context);
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
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: RichText(
//               text: TextSpan(
//                 text: 'Inventory ',
//                 style: TextStyle(
//                     letterSpacing: 1,
//                     color: ColorConstants.kTextColor,
//                     fontSize: 14),
//                 children: <TextSpan>[
//                   TextSpan(
//                       text: name,
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: ' of Quantity ',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: quantity,
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: ' with a price of \u{20B9} ',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: price,
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text:
//                       ' is not available in bag, would you still like to ',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: 'ADD',
//                       style: TextStyle(
//                           color: ColorConstants.kTextDark,
//                           letterSpacing: 1,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14)),
//                   TextSpan(
//                       text: ' it ?',
//                       style: TextStyle(
//                           color: ColorConstants.kTextColor,
//                           letterSpacing: 1,
//                           fontSize: 14)),
//                 ],
//               ),
//             ),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () => Navigator.pop(context)),
//                   Button(
//                       buttonText: 'CONFIRM',
//                       buttonFunction: () {
//                         setState(() {
//                           expansionInventoryName
//                               .add(inventoryNameController.text);
//                           expansionInventoryQuantity
//                               .add(inventoryQuantityController.text);
//                           expansionInventoryPrice
//                               .add(inventoryPriceController.text);
//                           expansionInventoryTotal
//                               .add(inventoryTotalController.text);
//                           receivedInventory.add(false);
//                           inventoryNameController.clear();
//                           inventoryQuantityController.clear();
//                           inventoryPriceController.clear();
//                           inventoryTotalController.clear();
//                         });
//                       })
//                 ],
//               )
//             ],
//           );
//         });
//   }
//
//   showInventoryEditDialog(
//       String name, String quantity, String price, String total) async {
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
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: editInventoryNameController..text = name,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.postageStamp,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: editInventoryQuantityController
//                         ..text = quantity,
//                       onChanged: (text) {
//                         editInventoryTotalController.text = (int.parse(text) *
//                             int.parse(editInventoryPriceController.text))
//                             .toString();
//                       },
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.sticky_note_2_outlined,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: editInventoryPriceController..text = price,
//                       onChanged: (text) {
//                         editInventoryTotalController.text = (int.parse(text) *
//                             int.parse(editInventoryQuantityController.text))
//                             .toString();
//                       },
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.currencyInr,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(.1),
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       readOnly: true,
//                       controller: editInventoryTotalController..text = total,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             MdiIcons.currencyInr,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(
//                 buttonText: 'CANCEL',
//                 buttonFunction: () => Navigator.pop(context)),
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
//                     expansionInventoryName
//                         .add(editInventoryNameController.text);
//                     expansionInventoryQuantity
//                         .add(editInventoryQuantityController.text);
//                     expansionInventoryPrice
//                         .add(editInventoryPriceController.text);
//                     expansionInventoryTotal
//                         .add(editInventoryTotalController.text);
//                     Navigator.pop(context);
//                   });
//                 }),
//           ],
//         );
//       },
//     );
//   }
//
//   showInventoryDeleteDialog(
//       String name, String quantity, String price, String total) async {
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
//                         borderRadius: BorderRadius.all(Radius.circular(10))),
//                     child: TextFormField(
//                       controller: editDocumentsController..text = document,
//                       style: const TextStyle(
//                           color: ColorConstants.kTextColor, letterSpacing: 1),
//                       decoration: const InputDecoration(
//                           counterText: '',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide:
//                             BorderSide(color: ColorConstants.kWhite),
//                           ),
//                           prefixIcon: Icon(
//                             Icons.description,
//                             color: ColorConstants.kSecondaryColor,
//                           ),
//                           isDense: true,
//                           border: InputBorder.none,
//                           focusedBorder: OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite))),
//                     ),
//                   ),
//                   const Space(),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             Button(
//                 buttonText: 'CANCEL',
//                 buttonFunction: () => Navigator.pop(context)),
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
//             content: Text('Do you wish to delete the Document $document?'),
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
//   getCommissionAmount(int amount, String type) {
//     if (type == 'dialog') {
//     } else {
//       String commissionAmount =
//       (double.parse(vpAmountController.text) ~/ 20).toString();
//       vpCommissionController.text = commissionAmount;
//     }
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
//               bottom: Radius.circular(30),
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
//                                 buttonFunction: () async {
//                                   print('Cancel is progress..!');
//                                   final bagDetails1 = await BagTable()
//                                       .select()
//                                       .BagType
//                                       .equals('Open')
//                                       .toMapList();
//                                   print('Bag Open Count- in Revised.');
//                                   print(bagDetails1.length);
//
//                                   for (int i = 0; i < bagDetails1.length; i++) {
//                                     print(bagDetails1[i].toString());
//                                   }
//
//                                   final bagDetails = await BagTable()
//                                       .select()
//                                       .BagNumber
//                                       .equals(bagController.text)
//                                       .delete();
//                                   final bagDetails2 = await BagTable()
//                                       .select()
//                                       .BagType
//                                       .equals('Open')
//                                       .toMapList();
//                                   print('Bag Open Count- in Revised.');
//                                   print(bagDetails2.length);
//
//                                   for (int i = 0; i < bagDetails2.length; i++) {
//                                     print(bagDetails2[i].toString());
//                                   }
//
//                                   Navigator.pop(context);
//                                   Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (_) => BagOpenScreen()),
//                                           (route) => false);
//                                 }),
//                             Button(
//                               buttonText: 'SAVE',
//                               buttonFunction: () async {
//                                 String amount, commission = "";
//                                 selectedEMOArticle == true
//                                     ? amount = emoAmountController.text
//                                     : amount = "0";
//                                 selectedEMOArticle == true
//                                     ? commission = vpCommissionController.text
//                                     : commission = "0";
//
//                                 selectedVPArticle == true
//                                     ? amount = vpAmountController.text
//                                     : amount = "0";
//                                 selectedVPArticle == true
//                                     ? commission = vpCommissionController.text
//                                     : commission = "0";
//
//                                 await savingData(amount, commission);
//
//                                 Toast.showToast(
//                                     'Details has been added for the Bag ${widget.bagNumber}',
//                                     context);
//                                 Navigator.pushAndRemoveUntil(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => BagOpenScreen()),
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
//           title: Text('Bag Number -  ${widget.bagNumber}'),
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
//                 padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Space(),
//                       Visibility(
//                         visible: true,
//                         // selectedRegularArticle,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               flex: 3,
//                               child: TextFormField(
//                                 focusNode: articleNumberFocusNode,
//                                 autovalidateMode:
//                                 AutovalidateMode.onUserInteraction,
//                                 controller: articleNumberController,
//                                 style: TextStyle(
//                                     color: ColorConstants.kSecondaryColor,
//                                     letterSpacing: 1),
//                                 textCapitalization:
//                                 TextCapitalization.characters,
//                                 keyboardType: TextInputType.text,
//                                 decoration: InputDecoration(
//                                     hintText: 'Article Number',
//                                     hintStyle: const TextStyle(
//                                         color:
//                                         ColorConstants.kAmberAccentColor),
//                                     counterText: '',
//                                     fillColor: ColorConstants.kWhite,
//                                     filled: true,
//                                     enabledBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: ColorConstants.kWhite),
//                                     ),
//                                     prefixIcon: Container(
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 5.toDouble()),
//                                         margin: EdgeInsets.only(
//                                             right: 8.0.toDouble()),
//                                         decoration: const BoxDecoration(
//                                           color: ColorConstants.kSecondaryColor,
//                                         ),
//                                         child: IconButton(
//                                           onPressed: scanArticles,
//                                           icon: const Icon(
//                                             MdiIcons.barcodeScan,
//                                             color: ColorConstants.kWhite,
//                                           ),
//                                         )),
//                                     contentPadding:
//                                     EdgeInsets.all(15.0.toDouble()),
//                                     isDense: true,
//                                     border: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(
//                                               20.0.toDouble()),
//                                           bottomLeft: Radius.circular(
//                                               30.0.toDouble()),
//                                         )),
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: const BorderSide(
//                                             color: ColorConstants.kWhite),
//                                         borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(
//                                               20.0.toDouble()),
//                                           bottomLeft: Radius.circular(
//                                               30.0.toDouble()),
//                                         ))),
//                                 validator: (text) {
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: ElevatedButton(
//                                   style: ButtonStyle(
//                                       backgroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           ColorConstants.kWhite),
//                                       shape: MaterialStateProperty.all<
//                                           RoundedRectangleBorder>(
//                                           RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(
//                                                   10.toDouble()),
//                                               side: const BorderSide(
//                                                   color: ColorConstants
//                                                       .kSecondaryColor)))),
//                                   onPressed: () {
//                                     if (articleNumberController.text.isEmpty) {
//                                       articleNumberFocusNode.requestFocus();
//                                       Toast.showFloatingToast(
//                                           'Enter the Article Number', context);
//                                     }
//                                     // else if (expansionArticle
//                                     //     .contains(articleNumberController.text)) {
//                                     //   Toast.showFloatingToast(
//                                     //       'Article is already scanned', context);
//                                     // }
//                                     else {
//                                       // if (receivedArticles [expansionArticle.indexWhere((element) => element == articleNumberController.text)]==true) {
//                                       //   Toast.showFloatingToast(
//                                       //       'Article is already scanned', context);
//                                       // }
//
//                                       if (!selectedArticle &&
//                                           !expansionArticle.contains(
//                                               articleNumberController.text)) {
//
//                                         Toast.showFloatingToast(
//                                             'Select Article Type', context);
//                                       } else if (customVisible == true &&
//                                           customdutyController.text.isEmpty) {
//                                         Toast.showFloatingToast(
//                                             'Enter Custom Duty', context);
//                                       } else if (selectedEMOArticle == true &&
//                                           emoAmountController.text.isEmpty) {
//                                         print('inside eMO condition');
//                                         Toast.showFloatingToast(
//                                             'Enter EMO Amount', context);
//                                       } else if (selectedEMOArticle == true &&
//                                           vpCommissionController.text
//                                               .isEmpty) {
//                                         Toast.showFloatingToast(
//                                             'Enter EMO Commission', context);
//                                       } else if (selectedVPArticle == true &&
//                                           vpAmountController.text.isEmpty) {
//                                         Toast.showFloatingToast(
//                                             'Enter Amount', context);
//                                       } else if (selectedVPArticle == true &&
//                                           vpCommissionController.text
//                                               .isEmpty) {
//                                         Toast.showFloatingToast(
//                                             'Enter Commission', context);
//                                       }
//                                       else {
//                                         infer = expansionArticle
//                                             .indexWhere((
//                                             element) => element ==
//                                             articleNumberController.text
//                                                 .toString());
//                                         print("infer: $infer");
//                                         setState(() {
//                                           String amount = "0";
//                                           String commission = "0";
//                                           // selectedEMOArticle==true ? amount =emoAmountController.text: amount ="0";
//                                           // selectedEMOArticle==true ? commission =vpCommissionController.text: amount ="0";
//                                           // selectedVPArticle ==true ? amount = vpAmountController.text: amount ="0";
//                                           // selectedVPArticle ==true ? commission = vpCommissionController.text: commission ="0";
//
//                                           switch (typeArticle) {
//                                             case "EMO":
//                                               amount =
//                                                   emoAmountController.text;
//                                               commission =
//                                                   vpCommissionController.text;
//                                               expansionAmount.add(amount);
//                                               expansionCommission.add(
//                                                   commission);
//                                               break;
//                                             case "COD":
//                                               amount =
//                                                   vpAmountController.text;
//                                               commission = "0";
//                                               expansionAmount.add(amount);
//                                               expansionCommission.add(
//                                                   commission);
//                                               break;
//                                             case "VPP":
//                                               amount =
//                                                   vpAmountController.text;
//                                               commission =
//                                                   vpCommissionController.text;
//                                               expansionAmount.add(amount);
//                                               expansionCommission.add(
//                                                   commission);
//                                               break;
//                                             case "VPL":
//                                               amount =
//                                                   vpAmountController.text;
//                                               commission =
//                                                   vpCommissionController.text;
//                                               expansionAmount.add(amount);
//                                               expansionCommission.add(
//                                                   commission);
//                                               break;
//                                             default:
//                                               amount = "0";
//                                               commission = "0";
//                                               break;
//                                           }
//
//                                           if (!expansionArticle.contains(
//                                               articleNumberController.text)) {
//                                             expansionArticle.add(articleNumberController.text);
//                                             expansionArticleType.add(typeArticle);
//                                             articlesInBag.add(ArticlesinBag(
//                                                 articleNumber:
//                                                 articleNumberController.text,
//                                                 articleType: typeArticle,
//                                                 amount: amount,
//                                                 commission: commission));
//                                             jsonArticles.add(false);
//                                             receivedArticles.add(false);
//                                             infer = expansionArticle
//                                                 .indexWhere((
//                                                 element) => element ==
//                                                 articleNumberController.text
//                                                     .toString());
//                                             print("infer: $infer");
//
//                                           }
//                                           else if (receivedArticles [expansionArticle.indexWhere((element) => element == articleNumberController.text)]==true) {
//                                             Toast.showFloatingToast(
//                                                 'Article is already scanned', context);
//                                           }
//
//                                           for (final articleNumber in articleMap
//                                               .entries) {
//                                             print('inside for loop $articleNumber');
//                                             print(articleNumberController.text);
//                                             if (articleNumber.key == articleNumberController.text)
//                                             {
//                                               print('inside scan function- 1st if');
//
//                                               articleMap.update(articleNumber.key, (value) => true);
//                                               print(articleNumber.key);
//                                               print(articleNumber.value);
//                                             }
//                                           }
//                                           // articleMap.update((articleNumberController.text).key, (value) => true);
//
//                                           receivedArticles[infer] = true;
//
//                                           articleNumberController.clear();
//                                           emoAmountController.clear();
//                                           vpArticleNumberController.clear();
//                                           vpCommissionController.clear();
//                                           vpAmountController.clear();
//                                           customdutyController.clear();
//
//                                         });
//                                         print(
//                                             "After changing the value boolean value");
//                                         print(expansionArticle.length);
//                                         print(articleMap);
//                                       }
//
//                                     }
//
//
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 18.0.toDouble()),
//                                     child: const Text(
//                                       'ADD',
//                                       overflow: TextOverflow.ellipsis,
//                                       style: TextStyle(
//                                           color:
//                                           ColorConstants.kAmberAccentColor),
//                                     ),
//                                   ),
//                                 )),
//                           ],
//                         ),
//                       ),
//                       const SmallSpace(),
//                       Row(
//                         children: [
//                           Container(
//                             child: const Text(
//                               '* For Manual Data Entry- please select "Article Type"',
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: Colors.redAccent, fontSize: 14),
//                             ),
//                           ),
//                         ],
//                       ),
//
//                       Visibility(
//                         visible: widget.isDataEntry,
//                         child: Column(
//                           children: [
//                             CheckboxListTile(
//                               title: Text('Custom Duty',
//                                   style: TextStyle(color: Colors.blueGrey)),
//                               value: customVisible,
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   customVisible = value!;
//                                 });
//                               },
//                               // secondary: const Icon(Icons.hourglass_empty),
//                             ),
//                             Visibility(
//                                 visible: customVisible,
//                                 child: TextFormField(
//                                   readOnly: !widget.isDataEntry,
//                                   keyboardType: TextInputType.number,
//                                   controller: customdutyController,
//                                   style: const TextStyle(
//                                       color: ColorConstants.kTextColor,
//                                       letterSpacing: 1),
//                                   onChanged: (text) {},
//                                   decoration: const InputDecoration(
//                                       counterText: '',
//                                       fillColor: ColorConstants.kWhite,
//                                       filled: true,
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color: ColorConstants.kWhite),
//                                       ),
//                                       hintStyle: TextStyle(
//                                           color:
//                                           ColorConstants.kAmberAccentColor),
//                                       hintText: 'Custom Duty Amount',
//                                       isDense: true,
//                                       border: InputBorder.none,
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color: ColorConstants.kWhite))),
//                                 )),
//                           ],
//                         ),
//                       ),
//                       const SmallSpace(),
//
//                       //Add Article field
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: Row(
//                               children: [
//                                 Container(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 3.toDouble()),
//                                     decoration: const BoxDecoration(
//                                       color: ColorConstants.kSecondaryColor,
//                                     ),
//                                     child: IconButton(
//                                       onPressed: () {},
//                                       icon: const Icon(
//                                         Icons.email,
//                                         color: ColorConstants.kWhite,
//                                       ),
//                                     )),
//                                 Expanded(
//                                   child: Container(
//                                     color: Colors.white,
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 4.0, horizontal: 10),
//                                       child: DropdownButtonHideUnderline(
//                                         child: DropdownButtonHideUnderline(
//                                           child: DropdownButton<String>(
//                                             isExpanded: true,
//                                             iconEnabledColor: Colors.blueGrey,
//                                             hint: const Text(
//                                               'Select an Article Type',
//                                               style: TextStyle(
//                                                   color: Color(0xFFCFB53B)),
//                                             ),
//                                             items: _articleTypes
//                                                 .map((String myMenuItem) {
//                                               return DropdownMenuItem<String>(
//                                                 value: myMenuItem,
//                                                 child: Text(
//                                                   myMenuItem,
//                                                   style: const TextStyle(
//                                                       color: Colors.blueGrey),
//                                                 ),
//                                               );
//                                             }).toList(),
//                                             onChanged: (String?
//                                             valueSelectedByUser) async {
//                                               _dropDownItemSelected(
//                                                   valueSelectedByUser!);
//                                             },
//                                             value: selectedArticle
//                                                 ? typeArticle
//                                                 : articleType,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//
//                         ],
//                       ),
//
//                       const SmallSpace(),
//                       Visibility(
//                           visible: selectedVPArticle,
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                       flex: typeArticle != "COD" ? 2 : 4,
//                                       child: TextFormField(
//                                         focusNode: vpAmountFocusNode,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         controller: vpAmountController,
//                                         style: const TextStyle(
//                                             color:
//                                             ColorConstants.kSecondaryColor),
//                                         textCapitalization:
//                                         TextCapitalization.characters,
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                             border: const OutlineInputBorder(
//                                               borderSide: BorderSide.none,
//                                             ),
//                                             hintText: typeArticle != "COD"
//                                                 ? 'VP Amount'
//                                                 : 'COD Amount',
//                                             hintStyle: const TextStyle(
//                                                 color: ColorConstants
//                                                     .kAmberAccentColor),
//                                             counterText: '',
//                                             fillColor: ColorConstants.kWhite,
//                                             filled: true,
//                                             enabledBorder:
//                                             const OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorConstants.kWhite),
//                                             ),
//                                             contentPadding: EdgeInsets.all(
//                                                 15.0.toDouble()),
//                                             isDense: true),
//                                         onChanged: (text) {
//                                           var commissionAmt = 0;
//                                           var commission = 0;
//                                           commission = double.parse(text) ~/ 20;
//                                           double.parse(text) % 20 != 0
//                                               ? commission += 1
//                                               : commission += 0;
//                                           commissionAmt = commission.toInt();
//                                           vpCommissionController.text =
//                                               commissionAmt.toString();
//                                         },
//                                         validator: (text) {
//                                           return null;
//                                         },
//                                       )),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Visibility(
//                                     visible:
//                                     typeArticle != "COD" ? true : false,
//                                     child: Expanded(
//                                         flex: 2,
//                                         child: TextFormField(
//                                           readOnly: true,
//                                           focusNode: vpCommissionFocusNode,
//                                           autovalidateMode: AutovalidateMode
//                                               .onUserInteraction,
//                                           controller: vpCommissionController,
//                                           style: const TextStyle(
//                                               color: ColorConstants
//                                                   .kSecondaryColor),
//                                           textCapitalization:
//                                           TextCapitalization.characters,
//                                           keyboardType: TextInputType.number,
//                                           decoration: InputDecoration(
//                                               border: const OutlineInputBorder(
//                                                 borderSide: BorderSide.none,
//                                               ),
//                                               hintText: 'Commission',
//                                               hintStyle: const TextStyle(
//                                                   color: ColorConstants
//                                                       .kAmberAccentColor),
//                                               counterText: '',
//                                               fillColor: ColorConstants.kWhite,
//                                               filled: true,
//                                               enabledBorder:
//                                               const OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color:
//                                                     ColorConstants.kWhite),
//                                               ),
//                                               contentPadding: EdgeInsets.all(
//                                                   15.0.toDouble()),
//                                               isDense: true),
//                                           validator: (text) {
//                                             return null;
//                                           },
//                                         )),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                 ],
//                               ),
//                               const SmallSpace()
//                             ],
//                           )),
//                       Visibility(
//                         visible: selectedEMOArticle,
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                     flex: 2,
//                                     child: TextFormField(
//                                       focusNode: emoAmountFocusNode,
//                                       autovalidateMode:
//                                       AutovalidateMode.onUserInteraction,
//                                       controller: emoAmountController,
//                                       style: const TextStyle(
//                                           color:
//                                           ColorConstants.kSecondaryColor),
//                                       textCapitalization:
//                                       TextCapitalization.characters,
//                                       keyboardType: TextInputType.number,
//                                       decoration: InputDecoration(
//                                           border: const OutlineInputBorder(
//                                             borderSide: BorderSide.none,
//                                           ),
//                                           hintText: 'eMO Amount',
//                                           hintStyle: const TextStyle(
//                                               color: ColorConstants
//                                                   .kAmberAccentColor),
//                                           counterText: '',
//                                           fillColor: ColorConstants.kWhite,
//                                           filled: true,
//                                           enabledBorder:
//                                           const OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                                 color: ColorConstants.kWhite),
//                                           ),
//                                           contentPadding:
//                                           EdgeInsets.all(15.0.toDouble()),
//                                           isDense: true),
//                                       onChanged: (text) {},
//                                       validator: (text) {
//                                         return null;
//                                       },
//                                     )),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Visibility(
//                                   visible: true,
//                                   child: Expanded(
//                                       flex: 2,
//                                       child: TextFormField(
//                                         readOnly: true,
//                                         focusNode: vpCommissionFocusNode,
//                                         autovalidateMode:
//                                         AutovalidateMode.onUserInteraction,
//                                         controller: vpCommissionController,
//                                         style: const TextStyle(
//                                             color:
//                                             ColorConstants.kSecondaryColor),
//                                         textCapitalization:
//                                         TextCapitalization.characters,
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                             border: const OutlineInputBorder(
//                                               borderSide: BorderSide.none,
//                                             ),
//                                             hintText: 'Commission',
//                                             hintStyle: const TextStyle(
//                                                 color: ColorConstants
//                                                     .kAmberAccentColor),
//                                             counterText: '',
//                                             fillColor: ColorConstants.kWhite,
//                                             filled: true,
//                                             enabledBorder:
//                                             const OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                   color: ColorConstants.kWhite),
//                                             ),
//                                             contentPadding: EdgeInsets.all(
//                                                 15.0.toDouble()),
//                                             isDense: true),
//                                         validator: (text) {
//                                           return null;
//                                         },
//                                       )),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                               ],
//                             ),
//                             const SmallSpace()
//                           ],
//                         ),
//                       ),
//                       const Divider(),
//                       const Divider(),
//
//                       //Article list field
//                       expansionArticle.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200),
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(12.0),
//                           ),
//                         ),
//                         child: Scrollbar(
//                           showTrackOnHover: true,
//                           child: ListView.builder(
//                               physics:
//                               const AlwaysScrollableScrollPhysics(),
//                               itemCount: expansionArticle.length,
//                               shrinkWrap: true,
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 20.0),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                           flex: 4,
//                                           child: Text(
//                                             expansionArticle[index],
//                                             style: TextStyle(
//                                                 letterSpacing: 1,
//                                                 color:
//                                                 jsonArticles[index] ==
//                                                     true
//                                                     ? ColorConstants
//                                                     .kTextColor
//                                                     : Colors
//                                                     .blue[300],
//                                                 fontWeight:
//                                                 jsonArticles[index] ==
//                                                     true
//                                                     ? FontWeight.w500
//                                                     : FontWeight
//                                                     .bold),
//                                           )),
//                                       Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                               expansionArticleType[index],
//                                               style: TextStyle(
//                                                   letterSpacing: 1,
//                                                   color: jsonArticles[
//                                                   index] ==
//                                                       true
//                                                       ? ColorConstants
//                                                       .kTextColor
//                                                       : Colors.blue[300],
//                                                   fontWeight: jsonArticles[
//                                                   index] ==
//                                                       true
//                                                       ? FontWeight.w500
//                                                       : FontWeight
//                                                       .bold))),
//                                       jsonArticles[index] == true
//                                           ? Expanded(
//                                           child: Checkbox(
//                                             shape:
//                                             RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius.circular(
//                                                   15),
//                                             ),
//                                             onChanged: (bool? value) {},
//                                             value:
//                                             receivedArticles[index],
//                                           ))
//                                           : Expanded(
//                                         flex: 2,
//                                         child: Row(
//                                           children: [
//                                             Expanded(
//                                                 flex: 1,
//                                                 child: IconButton(
//                                                     onPressed: () {
//                                                       showArticleDeleteDialog(
//                                                           expansionArticle[
//                                                           index],
//                                                           expansionArticleType[
//                                                           index]);
//                                                     },
//                                                     icon: Icon(
//                                                       Icons.delete,
//                                                       color: Colors
//                                                           .redAccent
//                                                           .withOpacity(
//                                                           .8),
//                                                     ))),
//                                             Expanded(
//                                                 flex: 1,
//                                                 child: IconButton(
//                                                     onPressed: () {
//                                                       showArticleEditDialog(
//                                                           expansionArticle[
//                                                           index],
//                                                           expansionArticleType[
//                                                           index]);
//                                                     },
//                                                     icon:
//                                                     const Icon(
//                                                       Icons.edit,
//                                                       color: Colors
//                                                           .blueGrey,
//                                                     ))),
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               }),
//                         ),
//                       ),
//                       const Divider(),
//                       const SmallSpace(),
//
//                       //Add Inventory field
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: Row(
//                               children: [
//                                 Container(
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: 3.toDouble()),
//                                     decoration: const BoxDecoration(
//                                       color: ColorConstants.kSecondaryColor,
//                                     ),
//                                     child: IconButton(
//                                       onPressed: () {},
//                                       icon: const Icon(
//                                         Icons.inventory,
//                                         color: ColorConstants.kWhite,
//                                       ),
//                                     )),
//                                 Expanded(
//                                   child: Container(
//                                     color: Colors.white,
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 4.0, horizontal: 10),
//                                       child: DropdownButtonHideUnderline(
//                                         child: DropdownButtonHideUnderline(
//                                           child: DropdownButton<String>(
//                                             isExpanded: true,
//                                             iconEnabledColor: Colors.blueGrey,
//                                             hint: const Text(
//                                               'Select Product ID',
//                                               style: TextStyle(
//                                                   color: Color(0xFFCFB53B)),
//                                             ),
//                                             items: productID
//                                                 .map((String myMenuItem) {
//                                               return DropdownMenuItem<String>(
//                                                 value: myMenuItem,
//                                                 child: Text(
//                                                   myMenuItem,
//                                                   style: const TextStyle(
//                                                       color: Colors.blueGrey),
//                                                 ),
//                                               );
//                                             }).toList(),
//                                             onChanged: (String?
//                                             valueSelectedByUser) async {
//                                               print(valueSelectedByUser);
//                                               print(_chosenProductID);
//
//                                               for (int i =0;i<productMasterList.length;i++)
//                                               {
//                                                 if(productMasterList[i].ItemCode==valueSelectedByUser) {
//                                                   print("Short Description");
//                                                   print(productMasterList[i]
//                                                       .ShortDescription
//                                                       .toString());
//                                                   setState(() {
//                                                     inventoryNameController
//                                                         .text =
//                                                         productMasterList[i]
//                                                             .ShortDescription
//                                                             .toString();
//                                                     inventoryPriceController.text=productMasterList[i].SalePrice.toString();
//                                                   });
//                                                 }
//                                               }
//
//                                               setState(() {
//                                                 _chosenProductID=valueSelectedByUser;
//
//                                                 // inventoryNameController.text = productMasterList
//                                               });
//
//                                             },
//                                             value: _chosenProductID,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // Expanded(
//                                 //   child: Padding(
//                                 //     padding: const EdgeInsets.all(8.0),
//                                 //     child: DropdownButtonFormField<String>(
//                                 //       alignment: Alignment.center,
//                                 //       value: _chosenProductID,
//                                 //       icon: const Icon(Icons.arrow_drop_down),
//                                 //       elevation: 16,
//                                 //       style:
//                                 //       TextStyle(color: Colors.blueGrey, fontSize: 18),
//                                 //       decoration: InputDecoration(
//                                 //         labelText: "Transaction Type",
//                                 //         border: OutlineInputBorder(
//                                 //           borderRadius: BorderRadius.circular(10.0),
//                                 //         ),
//                                 //       ),
//                                 //       onChanged: (String? newValue) {
//                                 //         setState(() {
//                                 //           // cdvisible = false;
//                                 //           print(newValue);
//                                 //           _chosenProductID = newValue;
//                                 //           print(_chosenProductID);
//                                 //         });
//                                 //       },
//                                 //       items: productID
//                                 //           .map<DropdownMenuItem<String>>((String value) {
//                                 //         return DropdownMenuItem<String>(
//                                 //           value: value,
//                                 //           child: Text(value),
//                                 //         );
//                                 //       }).toList(),
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//
//
//                         ],
//                       ),
//                       const SmallSpace(),
//                       //Commented Inventory ID Textbox by Rohit on 23112022
//                       /*
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               readOnly: !widget.isDataEntry,
//                               maxLines: null,
//                               focusNode: inventoryidFocusNode,
//                               autovalidateMode:
//                               AutovalidateMode.onUserInteraction,
//                               controller: inverntoryIDController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kSecondaryColor),
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   hintText: 'Inventory ID',
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   prefixIcon: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 5.h.toDouble()),
//                                       margin: EdgeInsets.only(
//                                           right: 8.0.w.toDouble()),
//                                       decoration: const BoxDecoration(
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.description,
//                                           color: ColorConstants.kWhite,
//                                         ),
//                                       )),
//                                   contentPadding:
//                                   EdgeInsets.all(15.0.w.toDouble()),
//                                   isDense: true,
//                                   border: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   )),
//                               validator: (text) {
//                                 return null;
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//
//                       */
//
//                       const SmallSpace(),
//                       Row(
//                         children: [
//                           //Inventory Name
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                               // enabled: isDE,
//                               // readOnly: !widget.isDataEntry,
//                               readOnly: true,
//                               controller: inventoryNameController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor,
//                                   letterSpacing: 1),
//                               decoration: InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   prefixIcon: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 5.toDouble()),
//                                       margin: EdgeInsets.only(
//                                           right: 8.0.toDouble()),
//                                       decoration: const BoxDecoration(
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {},
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
//                                       borderSide: BorderSide(
//                                           color: ColorConstants.kWhite))),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               // readOnly: !widget.isDataEntry,
//                               readOnly: true,
//                               keyboardType: TextInputType.number,
//                               controller: inventoryPriceController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor,
//                                   letterSpacing: 1),
//                               onChanged: (text) {
//
//                               },
//                               decoration: const InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   hintStyle: TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   hintText: 'Price',
//                                   isDense: true,
//                                   border: InputBorder.none,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: ColorConstants.kWhite))),
//                             ),
//                           ),
//
//                         ],
//                       ),
//
//                       const SmallSpace(),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               readOnly: !widget.isDataEntry,
//                               keyboardType: TextInputType.number,
//                               controller: inventoryQuantityController,
//                               onChanged: (text){
//                                 inventoryTotalController
//                                     .text = (double.parse(text) *
//                                     double.parse(
//                                         inventoryPriceController.text))
//                                     .toString();
//                               },
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor,
//                                   letterSpacing: 1),
//                               decoration: InputDecoration(
//                                   border: const OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   hintText: 'Quantity',
//
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   contentPadding:
//                                   EdgeInsets.all(15.0.toDouble()),
//                                   isDense: true),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: TextFormField(
//                               readOnly: true,
//                               keyboardType: TextInputType.number,
//                               controller: inventoryTotalController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kTextColor,
//                                   letterSpacing: 1),
//                               decoration: const InputDecoration(
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   hintStyle: TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   hintText: 'Total',
//                                   isDense: true,
//                                   border: InputBorder.none,
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: ColorConstants.kWhite))),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                               flex: 1,
//                               child: ElevatedButton(
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         ColorConstants.kWhite),
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 10.toDouble()),
//                                             side: const BorderSide(
//                                                 color: ColorConstants
//                                                     .kSecondaryColor)))),
//                                 onPressed: () {
//
//                                   if (inventoryNameController.text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Inventory name', context);
//                                   } else if (expansionInventoryName
//                                       .contains(inventoryNameController.text)) {
//                                     Toast.showFloatingToast(
//                                         'Inventory Already added', context);
//                                   } else if (inventoryQuantityController
//                                       .text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Quantity', context);
//                                   } else if (inventoryPriceController
//                                       .text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Price of 1 item', context);
//                                   } else {
//                                     setState(() {
//                                       expansionInventoryName
//                                           .add(inventoryNameController.text);
//                                       expansionInventoryQuantity.add(
//                                           inventoryQuantityController.text);
//                                       expansionInventoryPrice
//                                           .add(inventoryPriceController.text);
//                                       expansionInventoryTotal
//                                           .add(inventoryTotalController.text);
//                                       receivedInventory.add(false);
//                                       inventoryNameController.clear();
//                                       inventoryQuantityController.clear();
//                                       inventoryPriceController.clear();
//                                       inventoryTotalController.clear();
//                                     });
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 18.0.toDouble()),
//                                   child: const Text(
//                                     'ADD',
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color:
//                                         ColorConstants.kAmberAccentColor),
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ),
//                       const SmallSpace(),
//
//                       //Inventory list field
//                       expansionInventoryName.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200),
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
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 20.0),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 4,
//                                               child: Text(
//                                                 expansionInventoryName[
//                                                 index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants
//                                                         .kTextColor,
//                                                     fontWeight:
//                                                     FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text(
//                                                 expansionInventoryQuantity[
//                                                 index]
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants
//                                                         .kTextColor,
//                                                     fontWeight:
//                                                     FontWeight.w500),
//                                               )),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text(
//                                                 '\u{20B9}' +
//                                                     expansionInventoryPrice[
//                                                     index]
//                                                         .toString(),
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants
//                                                         .kTextColor,
//                                                     fontWeight:
//                                                     FontWeight.w500),
//                                               )),
//                                           receivedInventory[index] == true
//                                               ? Checkbox(
//                                             shape:
//                                             RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius
//                                                   .circular(15),
//                                             ),
//                                             onChanged:
//                                                 (bool? value) {},
//                                             value: true,
//                                           )
//                                               : Expanded(
//                                             flex: 2,
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                     flex: 1,
//                                                     child:
//                                                     IconButton(
//                                                         onPressed:
//                                                             () {
//                                                           showInventoryDeleteDialog(
//                                                               expansionInventoryName[index],
//                                                               expansionInventoryQuantity[index],
//                                                               expansionInventoryPrice[index],
//                                                               expansionInventoryTotal[index].toString());
//                                                         },
//                                                         icon:
//                                                         Icon(
//                                                           Icons
//                                                               .delete,
//                                                           color: Colors
//                                                               .redAccent
//                                                               .withOpacity(.8),
//                                                         ))),
//                                                 Expanded(
//                                                     flex: 1,
//                                                     child:
//                                                     IconButton(
//                                                         onPressed:
//                                                             () {
//                                                           showInventoryEditDialog(
//                                                               expansionInventoryName[index],
//                                                               expansionInventoryQuantity[index].toString(),
//                                                               expansionInventoryPrice[index].toString(),
//                                                               expansionInventoryTotal[index].toString());
//                                                         },
//                                                         icon:
//                                                         const Icon(
//                                                           Icons
//                                                               .edit,
//                                                           color:
//                                                           Colors.blueGrey,
//                                                         ))),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ),
//
//                       const SmallSpace(),
//                       const Divider(),
//                       const SmallSpace(),
//
//                       //Add Documents field
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: TextFormField(
//                               readOnly: !widget.isDataEntry,
//                               maxLines: null,
//                               focusNode: documentFocusNode,
//                               autovalidateMode:
//                               AutovalidateMode.onUserInteraction,
//                               controller: documentsController,
//                               style: const TextStyle(
//                                   color: ColorConstants.kSecondaryColor),
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   hintText: 'Document Name',
//                                   hintStyle: const TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   counterText: '',
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   prefixIcon: Container(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: 5.toDouble()),
//                                       margin: EdgeInsets.only(
//                                           right: 8.0.toDouble()),
//                                       decoration: const BoxDecoration(
//                                         color: ColorConstants.kSecondaryColor,
//                                       ),
//                                       child: IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.description,
//                                           color: ColorConstants.kWhite,
//                                         ),
//                                       )),
//                                   contentPadding:
//                                   EdgeInsets.all(15.0.toDouble()),
//                                   isDense: true,
//                                   border: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   )),
//                               validator: (text) {
//                                 return null;
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                               flex: 1,
//                               child: ElevatedButton(
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         ColorConstants.kWhite),
//                                     shape: MaterialStateProperty.all<
//                                         RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                                 10.toDouble()),
//                                             side: const BorderSide(
//                                                 color: ColorConstants
//                                                     .kSecondaryColor)))),
//                                 onPressed: () {
//                                   if (documentsController.text.isEmpty) {
//                                     Toast.showFloatingToast(
//                                         'Enter the Document', context);
//                                   } else {
//                                     setState(() {
//                                       expansionDocuments
//                                           .add(documentsController.text);
//                                       documentsController.clear();
//                                       receivedDocuments.add(false);
//                                     });
//                                   }
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 18.0.toDouble()),
//                                   child: const Text(
//                                     'ADD',
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         color:
//                                         ColorConstants.kAmberAccentColor),
//                                   ),
//                                 ),
//                               ))
//                         ],
//                       ),
//                       const SmallSpace(),
//
//                       //Documents list field
//                       expansionDocuments.isEmpty
//                           ? Container()
//                           : Container(
//                         constraints: BoxConstraints(maxHeight: 200),
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
//                               itemBuilder:
//                                   (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 20.0),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 4,
//                                               child: Text(
//                                                 expansionDocuments[index],
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     color: ColorConstants
//                                                         .kTextColor,
//                                                     fontWeight:
//                                                     FontWeight.w500),
//                                               )),
//                                           receivedDocuments[index] == true
//                                               ? Checkbox(
//                                             shape:
//                                             RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius
//                                                   .circular(15),
//                                             ),
//                                             onChanged:
//                                                 (bool? value) {},
//                                             value: true,
//                                           )
//                                               : Expanded(
//                                             flex: 2,
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                     flex: 1,
//                                                     child:
//                                                     IconButton(
//                                                         onPressed:
//                                                             () {
//                                                           showDocumentDeleteDialog(
//                                                               expansionDocuments[index]);
//                                                         },
//                                                         icon:
//                                                         Icon(
//                                                           Icons
//                                                               .delete,
//                                                           color: Colors
//                                                               .redAccent
//                                                               .withOpacity(.8),
//                                                         ))),
//                                                 Expanded(
//                                                     flex: 1,
//                                                     child:
//                                                     IconButton(
//                                                         onPressed:
//                                                             () {
//                                                           showDocumentEditDialog(
//                                                               expansionDocuments[index]);
//                                                         },
//                                                         icon:
//                                                         const Icon(
//                                                           Icons
//                                                               .edit,
//                                                           color:
//                                                           Colors.blueGrey,
//                                                         ))),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   ],
//                                 );
//                               }),
//                         ),
//                       ),
//
//                       const SmallSpace(),
//                       const Divider(),
//                       const SmallSpace(),
//
//                       //Cash field
//                       TextFormField(
//                         readOnly: !widget.isDataEntry,
//                         // readOnly: bagCash.isNotEmpty &&
//                         //         bagCash[0]['Status'] == 'Received'
//                         //     ? true
//                         //     : false,
//                         keyboardType: TextInputType.number,
//                         controller: amountController,
//                         style: const TextStyle(
//                             color: ColorConstants.kTextColor, letterSpacing: 1),
//                         decoration: InputDecoration(
//                             counterText: '',
//                             fillColor: ColorConstants.kWhite,
//                             filled: true,
//                             enabledBorder: const OutlineInputBorder(
//                               borderSide:
//                               BorderSide(color: ColorConstants.kWhite),
//                             ),
//                             hintText: 'Amount Received',
//                             hintStyle: const TextStyle(
//                                 color: ColorConstants.kAmberAccentColor),
//                             prefixIcon: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 5.toDouble()),
//                                 margin:
//                                 EdgeInsets.only(right: 8.0.toDouble()),
//                                 decoration: const BoxDecoration(
//                                   color: ColorConstants.kSecondaryColor,
//                                 ),
//                                 child: IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     MdiIcons.currencyInr,
//                                     color: ColorConstants.kWhite,
//                                   ),
//                                 )),
//                             isDense: true,
//                             border: InputBorder.none,
//                             focusedBorder: const OutlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: ColorConstants.kWhite))),
//                       ),
//                       Align(
//                           alignment: Alignment.center,
//                           child: Button(
//                               buttonText: 'SAVE',
//                               buttonFunction: () async {
//                                 var unScannedArticles = Map.fromEntries(
//                                     articleMap.entries.expand((e) => [
//                                       if (e.value == false)
//                                         MapEntry(e.key, e.value)
//                                     ]));
//                                 print("<><><><><><><");
//                                 print(unScannedArticles.length);
//                                 print(unScannedArticles);
//
//
//                                 String unScanned =
//                                 jsonEncode(unScannedArticles);
//                                 print(unScanned.length);
//                                 print(unScanned);
//
//                                 if (jsonArticles.isNotEmpty) {
//                                   if (unScannedArticles.isNotEmpty) {
//                                     showDialog(
//                                       context: context,
//                                       builder: (ctx) => AlertDialog(
//                                         title: const Text("Note!"),
//                                         content: Text(
//                                             "You still have ${unScannedArticles.length} ${unScannedArticles.keys} articles to be scanned, would you like to skip it?"),
//                                         actions: <Widget>[
//                                           Button(
//                                             buttonFunction: () {
//                                               Navigator.of(ctx).pop();
//                                             },
//                                             buttonText: "CANCEL",
//                                           ),
//                                           Button(
//                                             buttonFunction: () async {
//                                               await addingData();
//                                               Toast.showToast(
//                                                   'Details has been added for the Bag ${widget.bagNumber}',
//                                                   context);
//                                               Navigator.of(ctx).pop();
//                                               Navigator.pushAndRemoveUntil(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (_) =>
//                                                           BaggingServices()),
//                                                       (route) => false);
//                                             },
//                                             buttonText: "CONFIRM",
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   } else {
//                                     await addingData();
//                                     Toast.showToast(
//                                         'Details has been added for the Bag ${widget.bagNumber}',
//                                         context);
//                                     Navigator.of(ctx).pop();
//                                     Navigator.pushAndRemoveUntil(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (_) => BaggingServices()),
//                                             (route) => false);
//                                   }
//                                 } else {
//                                   await addingData();
//                                   Toast.showToast(
//                                       'Details has been added for the Bag ${widget.bagNumber}',
//                                       context);
//                                   Navigator.of(ctx).pop();
//                                   Navigator.pushAndRemoveUntil(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (_) => BaggingServices()),
//                                           (route) => false);
//                                 }
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
//   /*----------------------------------Adding--------------------------------------------*/
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
//     print('Add Articles to Bag Function..!');
//     print(expansionArticle.length);
//     print(articlesInBag.length);
//     if (expansionArticle.isNotEmpty) {
//       print('inside if Condition..!');
//
//       for (int i = 0; i < expansionArticle.length; i++) {
//         if (!jsonBagArticles.contains(expansionArticle[i])) {
//           await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//               expansionArticle[i], expansionArticleType[i], 'Added');
//           // String com = expansionCommission.length == 0
//           //     ? "0"
//           //     : expansionCommission[i].toString();
//           // String amount = expansionAmount.length == 0 ? "0" : expansionAmount[i]
//           //     .toString();
//           await BaggingDBService().addArticlesToDelivery(
//               widget.bagNumber,
//               articlesInBag[i].articleNumber!,
//               articlesInBag[i].articleType!,
//               articlesInBag[i].commission!,
//               articlesInBag[i].amount!);
//         }
//         if (receivedArticles[i] == true) {
//           print('index is ' + i.toString());
//           print(expansionCommission.length);
//           if (expansionCommission.isEmpty) print("Empty");
//           if (expansionCommission.isNotEmpty) print("Not Empty");
//           await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//               expansionArticle[i], expansionArticleType[i], 'Added');
//           String com = expansionCommission.length == 0
//               ? "0"
//               : expansionCommission[i].toString();
//           String amount =
//           expansionAmount.length == 0 ? "0" : expansionAmount[i].toString();
//           await BaggingDBService().addArticlesToDelivery(
//               widget.bagNumber,
//               articlesInBag[i].articleNumber!,
//               articlesInBag[i].articleType!,
//               articlesInBag[i].commission!,
//               articlesInBag[i].amount!);
//
//         }
//
//       }
//       print('for loop saving completed.');
//       print('BAGDETAILS_NEW Update..!');
//       //insert or update into BagDetails_New table
//       BaggingDBService().addBAGDETAILS_NEW(
//           widget.bagNumber, (expansionArticle.length + 1).toString());
//     }
//   }
//
//   addInventoryToBag() async {
//     if (expansionInventoryName.isNotEmpty) {
//       for (int i = 0; i < expansionInventoryName.toSet().toList().length; i++) {
//         await BaggingDBService().addInventoryFromBagToDB(
//             expansionInventoryName[i],
//             expansionInventoryPrice[i].toString(),
//             expansionInventoryQuantity[i].toString(),
//             (double.parse(expansionInventoryPrice[i]) *
//                 double.parse(expansionInventoryQuantity[i]))
//                 .toString(),
//             widget.bagNumber,
//             'Added');
//         await BaggingDBService().addProductsMain(
//             expansionInventoryName[i],
//             double.parse(expansionInventoryPrice[i]),
//             double.parse(expansionInventoryQuantity[i]));
//       }
//     }
//   }
//
//   addDocumentsToBag() async {
//     if (expansionDocuments.isNotEmpty) {
//       for (int i = 0; i < expansionDocuments.length; i++) {
//         await BaggingDBService().updateBagDocumentsToDB(
//             widget.bagNumber, expansionDocuments[i], 'Y', 'Added');
//       }
//     }
//     final slipDetails = await BOSLIP_DOCUMENT1()
//         .select()
//         .BO_SLIP_NO
//         .equals(boSlipNumber)
//         .toMapList();
//     for (int j = 0; j < slipDetails.length; j++) {
//       if (slipDetails[j]['IS_RCVD'] != 'Y') {
//         await BOSLIP_DOCUMENT1()
//             .select()
//             .BO_SLIP_NO
//             .equals(boSlipNumber)
//             .update({"IS_RCVD": 'Y'});
//       }
//     }
//   }
//
//   addCashMain() async {
//     if (amountController.text.isNotEmpty && amountController.text!="0") {
//       await BaggingDBService()
//           .addCashReceive(amountController.text, widget.bagNumber);
//     }
//   }
//
//   /*------------------------------------------------------------------------------------*/
//
//   void moveToPrevious(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Note!'),
//             content: const Text(
//                 'Do you wish to save the details entered and then leave the page?'),
//             actions: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Button(
//                       buttonText: 'CANCEL',
//                       buttonFunction: () async {
//                         print('Cancel is progress..!');
//                         final bagDetails1 = await BagTable()
//                             .select()
//                             .BagType
//                             .equals('Open')
//                             .toMapList();
//                         print('Bag Open Count- in Revised.');
//                         print(bagDetails1.length);
//
//                         for (int i = 0; i < bagDetails1.length; i++) {
//                           print(bagDetails1[i].toString());
//                         }
//
//                         final bagDetails = await BagTable()
//                             .select()
//                             .BagNumber
//                             .equals(bagController.text)
//                             .delete();
//                         final bagDetails2 = await BagTable()
//                             .select()
//                             .BagType
//                             .equals('Open')
//                             .toMapList();
//                         print('Bag Open Count- in Revised.');
//                         print(bagDetails2.length);
//
//                         for (int i = 0; i < bagDetails2.length; i++) {
//                           print(bagDetails2[i].toString());
//                         }
//
//                         Navigator.pop(context);
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(builder: (_) => BagOpenScreen()),
//                                 (route) => false);
//                       }),
//                   Button(
//                     buttonText: 'SAVE',
//                     buttonFunction: () async {
//                       String amount, commission = "";
//                       selectedEMOArticle == true
//                           ? amount = emoAmountController.text
//                           : amount = "0";
//                       selectedEMOArticle == true
//                           ? commission = vpCommissionController.text
//                           : commission = "0";
//
//                       selectedVPArticle == true
//                           ? amount = vpAmountController.text
//                           : amount = "0";
//                       selectedVPArticle == true
//                           ? commission = vpCommissionController.text
//                           : commission = "0";
//                       await saveArticlesToBag(amount, commission);
//                       await saveInventoryToBag();
//                       Toast.showToast(
//                           'Details has been added for the Bag ${widget.bagNumber}',
//                           context);
//                       Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(builder: (_) => BagOpenScreen()),
//                               (route) => false);
//                     },
//                   )
//                 ],
//               )
//             ],
//           );
//         });
//   }
//
//   /*----------------------------------Saving--------------------------------------------*/
//
//   Future<bool> savingData(String amount, String commission) async {
//     await saveArticlesToBag(amount, commission);
//     await saveInventoryToBag();
//     await saveDocumentsTOBag();
//     return true;
//   }
//
//   saveArticlesToBag(String amount, String commission) async {
//     print("Save articles");
//     if (expansionArticle.isNotEmpty) {
//       // for (int i = 0; i < receivedArticles.length; i++) {
//       //   if (receivedArticles[i] != true) {
//       //     final index = receivedArticles.indexWhere((element) => false);
//       //     unScannedArticles.add(expansionArticle[index]);
//       //   }
//       // }
//       for (int i = 0; i < expansionArticle.length; i++) {
//         if (!jsonBagArticles.contains(expansionArticle[i])) {
//           await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//               expansionArticle[i], expansionArticleType[i], 'Received');
//         }
//         if (receivedArticles[i] == true) {
//           await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
//               expansionArticle[i], expansionArticleType[i], 'Added');
//           await BaggingDBService().addArticlesToDelivery(
//               widget.bagNumber,
//               articlesInBag[i].articleNumber!,
//               articlesInBag[i].articleType!,
//               articlesInBag[i].commission!,
//               articlesInBag[i].amount!);
//         }
//       }
//     }
//   }
//
//   saveInventoryToBag() async {
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
//             'Received');
//       }
//     }
//   }
//
//   saveDocumentsTOBag() async {
//     if (expansionDocuments.isNotEmpty) {
//       for (int i = 0; i < expansionDocuments.length; i++) {
//         await BaggingDBService().updateBagDocumentsToDB(
//             widget.bagNumber, expansionDocuments[i], 'Y', 'Received');
//       }
//     }
//     final slipDetails = await BOSLIP_DOCUMENT1()
//         .select()
//         .BO_SLIP_NO
//         .equals(boSlipNumber)
//         .toMapList();
//     for (int j = 0; j < slipDetails.length; j++) {
//       if (slipDetails[j]['IS_RCVD'] != 'Y') {
//         await BOSLIP_DOCUMENT1()
//             .select()
//             .BO_SLIP_NO
//             .equals(boSlipNumber)
//             .update({"IS_RCVD": 'Y'});
//       }
//     }
//   }
//
// /*------------------------------------------------------------------------------------*/
// }
