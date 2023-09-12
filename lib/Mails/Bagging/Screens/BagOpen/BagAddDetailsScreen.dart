// import 'package:darpan_mine/DatabaseModel/transtable.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagDetailsScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagOpenScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagScannedDetails.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Utils/Scan.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/LetterForm.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
//
// class BagAddDetailsScreen extends StatefulWidget {
//   final String bagNumber;
//
//   const BagAddDetailsScreen({Key? key, required this.bagNumber}) : super(key: key);
//
//   @override
//   _BagAddDetailsScreenState createState() => _BagAddDetailsScreenState();
// }
//
// class _BagAddDetailsScreenState extends State<BagAddDetailsScreen> {
//
//   static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
//
//   var index;
//   var stampsToBeReceived;
//   var priceOfStamp;
//   var valueOfReceive;
//   var valueOfReceived;
//   var differenceReceived;
//   var choosenStamp;
//   var stampsReceived;
//
//   int totalArticles = 0;
//   int? totalCash;
//
//   final articleFocus = FocusNode();
//   final scannedArticleFocus = FocusNode();
//   final cashFocusNode = FocusNode();
//
//   final articleController = TextEditingController();
//   final scannedArticleController = TextEditingController();
//
//   final documentsToBeReceivedController = TextEditingController();
//   final documentReceivedController = TextEditingController();
//
//   final cashController = TextEditingController();
//   final excessCashController = TextEditingController();
//   final cashEnteredController = TextEditingController();
//   final cashToBeReceivedController = TextEditingController();
//
//   final quantityController = TextEditingController();
//   final stampPriceController = TextEditingController();
//   final stampToBeReceivedController = TextEditingController();
//   final stampToBeReceivedValueController = TextEditingController();
//   final stampReceivedController = TextEditingController();
//   final stampReceivedValueController = TextEditingController();
//   final excessStampController = TextEditingController();
//
//   // bool isOpened = false;
//   bool articlesAdded = false;
//   bool inventoryAdded = false;
//   bool cashDetails = false;
//   bool cashAdded = false;
//   bool inventoryDetails = false;
//   bool documentsDetails = false;
//   final bool _selected = false;
//
//   String? articleType;
//   String? _chosenStampType;
//   String? articleTypeError;
//   String excessCash = '';
//   String typeArticle = '';
//   String cashReceived = '';
//   String cashEntered = '';
//   String cashTotal = '';
//   String? scannedTypeArticle;
//   String? totalInventory;
//
//   List articles = [];
//   List scannedArticle = [];
//   List expansionArticle = [];
//   List expansionArticleType = [];
//   List expansionAmount = [];
//   List expansionCommission =[];
//   List scannedArticleType = [];
//   List excessArticlesList = [];
//   List excessArticleType = [];
//   List scannedArticlesList = [];
//   List toBeScannedArticlesList = [];
//
//   List<String> stampPrice = [];
//   List<String> expansionStampPrice = [];
//   List<String> stampName = [];
//   List<String> expansionStampName = [];
//   List<String> excessStampName = [];
//   List<String> excessStamps = [];
//   List<String> stampQuantity = [];
//   List<String> expansionStampQuantity = [];
//   List<String> expansionStampTotal = [];
//   List<int> excessStampQuantity = [];
//   List<String> cashType = [];
//   List<String> cash = [];
//   List<String> cashBag = [];
//   List<String> typeOfArticles = [];
//   List<String> jsonBagArticles = [];
//   List<String> jsonBagArticleTypes = [];
//   List<String> jsonBagStampQuantity = [];
//   List<String> jsonBagStampPrice = [];
//   List<int> jsonStampQuantity = [];
//   List<String> jsonBagDocuments = [];
//   List<String> bagDocs = [];
//   List<String> expansionBagDocs = [];
//   List stampMap = [];
//   List jsonBagDocumentsCheck = [];
//   List bagDocumentsCheck = [];
//   List<String> articleTypes = ['EMO', 'Parcel', 'LETTER', 'Speed Post'];
//
//   final _stampKey = GlobalKey<FormState>();
//   final _cashKey = GlobalKey<FormState>();
//
//   List<CheckBoxListTileModel> checkBoxListTileModel =
//   CheckBoxListTileModel.getUsers();
//
//
//   clearAll() {
//     jsonBagArticles.clear();
//     jsonBagArticleTypes.clear();
//     scannedArticle.clear();
//     scannedArticleType.clear();
//     expansionArticle.clear();
//     expansionArticleType.clear();
//     articlesAdded = false;
//     totalArticles = 0;
//     stampName.clear();
//     jsonBagStampQuantity.clear();
//     jsonBagStampPrice.clear();
//     expansionStampName.clear();
//     expansionStampQuantity.clear();
//     expansionStampPrice.clear();
//     expansionStampTotal.clear();
//   }
//
//   fetchArticles() async {
//
//     // clearAll();
//
//     /*-------------------------------------Articles-------------------------------------*/
//     final bagArticles = await BagArticlesTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for(int i = 0; i< bagArticles.length; i++) {
//       jsonBagArticles.add(bagArticles[i]['ArticleNumber'].toString());
//       jsonBagArticleTypes.add(bagArticles[i]['ArticleType'].toString());
//     }
//
//     final addedArticles = await BagArticlesTable().select().startBlock.BagNumber.
//     equals(widget.bagNumber).and.Status.equals('Added').endBlock.toMapList();
//     if (articlesAdded == false) {
//       for (int i=0; i<addedArticles.length; i++) {
//         scannedArticle.add(addedArticles[i]['ArticleNumber']);
//         scannedArticleType.add(addedArticles[i]['ArticleType']);
//         expansionArticle.add(addedArticles[i]['ArticleNumber']);
//         expansionArticleType.add(addedArticles[i]['ArticleType']);
//       }
//
//       final excessArticles = await BagExcessArticlesTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//       for (int i=0; i<excessArticles.length; i++) {
//         excessArticlesList.add(excessArticles[i]['ArticleNumber']);
//         expansionArticle.add(excessArticles[i]['ArticleNumber']);
//         scannedArticle.add(excessArticles[i]['ArticleNumber']);
//         scannedArticleType.add(excessArticles[i]['ArticleType']);
//         expansionArticleType.add(excessArticles[i]['ArticleType']);
//       }
//       articlesAdded = true;
//     }
//
//     totalArticles = bagArticles.length;
//
//     /*----------------------------------------------------------------------------------*/
//
//     /*----------------------------------Inventory Data----------------------------------*/
//     final bagInventory = await BagInventory().select().BagNumber.equals(widget.bagNumber).toMapList();
//     for (int i = 0; i<bagInventory.length; i++) {
//       stampName.add(bagInventory[i]['InventoryName']);
//       jsonBagStampQuantity.add(bagInventory[i]['InventoryQuantity'].toString());
//       jsonBagStampPrice.add(bagInventory[i]['InventoryPrice'].toString());
//     }
//     if (inventoryAdded == false) {
//       final bagAddedStamps = await BagStampsTable().select().BagNumber
//           .equals(widget.bagNumber).toMapList();
//       if (bagAddedStamps.isNotEmpty) {
//         for (int i = 0; i < bagAddedStamps.length; i++) {
//           expansionStampName.add(bagAddedStamps[i]['StampName']);
//           expansionStampPrice.add(bagAddedStamps[i]['StampPrice']);
//           expansionStampQuantity.add(bagAddedStamps[i]['StampQuantity']);
//           expansionStampTotal.add(bagAddedStamps[i]['StampAmountTotal']);
//         }
//       }
//       final bagExcessStamps = await BagExcessStampsTable().select().BagNumber
//           .equals(widget.bagNumber).toMapList();
//       print("Bag excess stamps $bagExcessStamps");
//       // excessStamps.add('$choosenStamp | Excess => $differenceReceived');
//       if (bagExcessStamps.isNotEmpty) {
//         for (int i=0; i<bagExcessStamps.length; i++) {
//           excessStamps.add('${bagExcessStamps[i]['Name']} | Excess => ${bagExcessStamps[i]['StampQuantity']}');
//         }
//       }
//       inventoryAdded = true;
//     }
//
//     if (inventoryAdded == false) {
//       for (int i = 0; i< bagInventory.length; i++) {
//         stampName.add(bagInventory[i]['InventoryName'].toString());
//         stampQuantity.add(bagInventory[i]['InventoryQuantity'].toString());
//         // if (bagInventory[i].ExcessStampQuantity != '0') {
//         //   excessStampName.add(bagInventory[i].StampName.toString());
//         //   excessStampQuantity.add(int.parse(bagInventory[i].ExcessStampQuantity!));
//         // }
//       }
//       inventoryAdded = true;
//     }
//
//     /*----------------------------------------------------------------------------------*/
//
//     /*------------------------------------Cash Data-------------------------------------*/
//
//     final bagCash = await BagCashTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     if (bagCash.isNotEmpty) {
//       cashReceived = bagCash[0]['CashReceived'];
//       cashToBeReceivedController.text = bagCash[0]['CashReceived'].toString();
//       if (cashAdded == false) {
//         if (bagCash[0]['CashAmount'].toString() != '0') {
//           totalCash = int.parse(bagCash[0]['CashAmount']);
//           cashBag.add(bagCash[0]['CashAmount']);
//           cashController.text = totalCash.toString();
//           cashEnteredController.text = totalCash.toString();
//         }
//         if (bagCash[0]['CashAmount'].toString() != '0') {
//           if (bagCash[0]['CashReceived'] != bagCash[0]['CashAmount']) {
//             excessCash = (int.parse(bagCash[0]['CashAmount']) - int.parse(bagCash[0]['CashReceived'])).toString();
//             excessCashController.text = excessCash;
//           }
//         }
//         cashAdded = true;
//       }
//     }
//
//     /*----------------------------------------------------------------------------------*/
//
//     /*----------------------------------Documents Data----------------------------------*/
//     final bagDocuments = await BagDocumentsTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     documentsToBeReceivedController.text = bagDocuments.length.toString();
//     for (int i = 0; i< bagDocuments.length; i++) {
//       jsonBagDocuments.add(bagDocuments[i]['DocumentName'].toString());
//       if (bagDocuments[i]['IsAdded'] == 'N') {
//         jsonBagDocumentsCheck.add(false);
//       } else {
//         jsonBagDocumentsCheck.add(true);
//         bagDocs.add(bagDocuments[i]['DocumentName'].toString());
//         expansionBagDocs.add(bagDocuments[i]['DocumentName']);
//       }
//     }
//     documentReceivedController.text = expansionBagDocs.toSet().toList().length.toString();
//
//
//     /*----------------------------------------------------------------------------------*/
//
//     return bagArticles;
//   }
//
//
//
//   scanned() {
//
//     for (var scanned in jsonBagArticles) {
//       bool isArticleContain = scannedArticle.any((element) => scanned.contains(element));
//       if (isArticleContain) {
//         scannedArticlesList.add(scanned);
//       }
//     }
//     var scannedList = scannedArticlesList.toSet().toList();
//     return scannedList.length.toString();
//   }
//
//   toBeScanned() {
//     toBeScannedArticlesList = jsonBagArticles.toSet().difference(scannedArticle.toSet()).toList();
//     return toBeScannedArticlesList.length.toString();
//   }
//
//   excessScanned() {
//
//     for (var scanned in scannedArticle) {
//       bool isContains = jsonBagArticles.any((element) => scanned.contains(element));
//       if (!isContains) {
//         excessArticlesList.add(scanned);
//       }
//     }
//     var excessList = excessArticlesList.toSet().toList();
//     return excessList.length.toString();
//   }
//
//   scanBarcode() async {
//     var scan = await Scan().scanBag();
//
//     if (scannedArticle.contains(scan)) {
//       Toast.showToast('Article already scanned', context);
//     } else {
//       if (scan.toString().length == 13 && validCharacters.hasMatch(scan)) {
//         setState(() {
//           scannedArticleController.text = scan.toString();
//         });
//         final index = jsonBagArticles.indexWhere((element) => element == scan.toString());
//         if (!index.isNegative ) {
//           if (jsonBagArticleTypes[index].startsWith('R')) {
//             scannedTypeArticle = articleTypes[2];
//             articleTypeError = null;
//           } else if (jsonBagArticleTypes[index].startsWith('S')) {
//             scannedTypeArticle = articleTypes[3];
//             articleTypeError = null;
//           } else if (jsonBagArticleTypes[index].startsWith('P')) {
//             scannedTypeArticle = articleTypes[1];
//             articleTypeError = null;
//           }
//         } else if (index.isNegative){
//           // scannedTypeArticle = articleTypes[2];
//           articleTypeError = null;
//         }
//         showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return scannerDialog();
//             });
//       } else if (scan.toString().length == 18) {
//         setState(() {
//           scannedArticleController.text = scan.toString();
//         });
//         final index = jsonBagArticles.indexWhere((element) => element == scan.toString());
//         if (!index.isNegative ){
//            if (jsonBagArticleTypes[index].startsWith('E')) {
//               scannedTypeArticle = articleTypes[0];
//               articleTypeError = null;
//            } else if (index.isNegative){
//              // scannedTypeArticle = articleTypes[2];
//              articleTypeError = null;
//            }
//            showDialog(
//                context: context,
//                builder: (BuildContext context) {
//                  return scannerDialog();
//                });
//         }
//       } else {
//         Toast.showFloatingToast('Not a Valid Article', context);
//       }
//     }
//
//
//   }
//
//   scannerDialog() {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.w.toDouble()))),
//       elevation: 0,
//       backgroundColor: ColorConstants.kWhite,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//               padding: EdgeInsets.all(15.0.w),
//               child: Column(
//                 children: [
//                   const Space(),
//                   ScanTextFormField(
//                     type: 'Article',
//                     title: 'Article Number',
//                     focus: scannedArticleFocus,
//                     controller: scannedArticleController,
//                     scanFunction: () {
//                       scanBarcode();
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   const Space(),
//                   FormField<String>(
//                     builder: (FormFieldState<String> state) {
//                       return DropdownButtonHideUnderline(
//                         child: DropdownButtonHideUnderline(
//                           child: DropdownButtonFormField<String>(
//                             decoration:
//                                 const InputDecoration(enabledBorder: InputBorder.none),
//                             isExpanded: true,
//                             iconEnabledColor: Colors.blueGrey,
//                             hint: const Text(
//                               'Article Type',
//                               style: TextStyle(color: Color(0xFFCFB53B)),
//                             ),
//                             items: articleTypes.map((String myMenuItem) {
//                               return DropdownMenuItem<String>(
//                                 value: myMenuItem,
//                                 child: Text(
//                                   myMenuItem,
//                                   style: const TextStyle(color: Colors.blueGrey),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (String? valueSelectedByUser) {
//                               scannedTypeArticle = valueSelectedByUser!;
//                               articleTypeError = null;
//                             },
//                             value: scannedTypeArticle,
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 ],
//               )),
//           Button(
//               buttonText: 'CONFIRM',
//               buttonFunction: () {
//                 if (scannedArticleController.text.isEmpty) {
//                   Toast.showToast('Scan an Article', context);
//                 } else if (scannedArticle.contains(scannedArticleController.text)) {
//                   Navigator.of(context).pop();
//                   Toast.showToast('Article already scanned', context);
//                 } else if (!jsonBagArticles.contains(scannedArticleController.text)) {
//                   Navigator.of(context).pop();
//                   showDialog(context: context, builder: (BuildContext context) {
//                     return AlertDialog(
//                      title: const Text('Note!'),
//                      content: RichText(
//                        text: TextSpan(
//                          text: 'Article ',
//                          style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor, fontSize: 14.sp),
//                          children:  <TextSpan>[
//                            TextSpan(text: scannedArticleController.text, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                            TextSpan(text: ' of type ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                            TextSpan(text: scannedTypeArticle, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                            TextSpan(text: ' is not available in bag, would you still like to ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                            TextSpan(text: 'ADD', style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                            TextSpan(text: ' it ?', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                          ],
//                        ),
//                      ),
//                      actions: [
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceAround,
//                          children: [
//                            Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//                            Button(buttonText: 'CONFIRM', buttonFunction: () {
//                              setState(() {
//                                String amount = "0";
//                                String commission = "0";
//
//                                switch(scannedTypeArticle)
//                                {
//                                  case "EMO":
//                                    amount = emoAmountController.text;
//                                    commission = vpCommissionController.text;
//                                    break;
//                                  case "COD":
//                                    amount = vpAmountController.text;
//                                    commission = "0";
//                                    break;
//                                  case "VPP":
//                                    amount = vpAmountController.text;
//                                    commission = vpCommissionController.text;
//                                    break;
//                                  case "VPL":
//                                    amount = vpAmountController.text;
//                                    commission = vpCommissionController.text;
//                                    break;
//
//                                }
//
//                                scannedArticle.add(scannedArticleController.text);
//                                scannedArticleType.add(scannedTypeArticle);
//                                expansionArticle.add(scannedArticleController.text);
//                                expansionArticleType.add(scannedTypeArticle);
//
//
//                                expansionAmount.add(amount);
//                                expansionCommission.add(commission);
//                                articleController.clear();
//                                Navigator.of(context).pop();
//                                Toast.showToast('Article ${scannedArticleController.text} has been added', context);
//                              });
//                            })
//                          ],
//                        )
//                      ],
//                     );
//                   });
//                 } else {
//                   setState(() {
//                     scannedArticle.add(scannedArticleController.text);
//                     scannedArticleType.add(scannedTypeArticle);
//                     expansionArticle.add(scannedArticleController.text);
//                     expansionArticleType.add(scannedTypeArticle);
//                     articleController.clear();
//                     Navigator.of(context).pop();
//                     Toast.showToast('Article ${scannedArticleController.text} has been added', context);
//                   });
//                 }
//               }),
//         ],
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(child: Scaffold(
//       backgroundColor: ColorConstants.kBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: ColorConstants.kPrimaryColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30.w),
//           ),
//         ),
//         leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () async {
//           showDialog(context: context, builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Note!'),
//               content: const Text('Do you wish to save the details entered and then leave the page?'),
//               actions: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Button(buttonText: 'CANCEL', buttonFunction: () {
//                       Navigator.pop(context);
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false);
//                     }),
//                     Button(buttonText: 'SAVE', buttonFunction: () async {
//                       await addingData();
//                       Toast.showToast(
//                           'Details has been added for the Bag ${widget.bagNumber}',
//                           context);
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false);
//                     },)
//                   ],
//                 )
//               ],
//             );
//           });
//         },),
//         title: Text('Details of ${widget.bagNumber}'),
//       ),
//       body: FutureBuilder(
//         future: fetchArticles(),
//         builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//           if (snapshot.data == null) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return Padding(
//               padding: EdgeInsets.all(10.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Flexible(
//                           child: ExpansionTile(
//                             title: Text(
//                               'Articles Received',
//                               style: TextStyle(fontSize: 16.0.sp),
//                             ),
//                             children: <Widget>[
//                               Card(
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: expansionArticleType
//                                           .map((e) => Padding(
//                                         padding: EdgeInsets.all(8.0.w),
//                                         child: Text(
//                                           e,
//                                           style: const TextStyle(
//                                               color: ColorConstants.kTextColor,
//                                               letterSpacing: 1),
//                                         ),
//                                       ))
//                                           .toList(),
//                                     ),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: expansionArticle
//                                           .map((e) => Padding(
//                                         padding: EdgeInsets.symmetric(vertical: 8.0.w),
//                                         child: const Text(' : '),
//                                       ))
//                                           .toList(),
//                                     ),
//                                     Column(
//                                       children: expansionArticle
//                                           .map((e) => Padding(
//                                         padding: EdgeInsets.all(8.0.w),
//                                         child: Text(e,
//                                             style: TextStyle(
//                                                 color: ColorConstants.kTextDark,
//                                                 fontWeight: FontWeight.w500,
//                                                 letterSpacing: 1.sp.toDouble())),
//                                       ))
//                                           .toList(),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               typeArticle = '';
//                               articleController.clear();
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (BuildContext context) {
//                                     return Dialog(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.w.toDouble()))),
//                                       elevation: 0,
//                                       backgroundColor: ColorConstants.kWhite,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Padding(
//                                               padding: EdgeInsets.all(15.0.w),
//                                               child: Column(
//                                                 children: [
//                                                   const Space(),
//                                                   ScanTextFormField(
//                                                     type: 'Article',
//                                                     title: 'Article Number',
//                                                     focus: articleFocus,
//                                                     controller: articleController,
//                                                     scanFunction: () {
//                                                       scanBarcode();
//                                                       Navigator.of(context).pop();
//                                                     },
//                                                   ),
//                                                   const Space(),
//                                                   FormField<String>(
//                                                     builder:
//                                                         (FormFieldState<String> state) {
//                                                       return DropdownButtonHideUnderline(
//                                                         child:
//                                                         DropdownButtonHideUnderline(
//                                                           child: DropdownButtonFormField<
//                                                               String>(
//                                                             decoration:
//                                                             const InputDecoration(
//                                                                 enabledBorder:
//                                                                 InputBorder.none),
//                                                             isExpanded: true,
//                                                             iconEnabledColor:
//                                                             Colors.blueGrey,
//                                                             hint: const Text(
//                                                               'Article Type',
//                                                               style: TextStyle(
//                                                                   color:
//                                                                   Color(0xFFCFB53B)),
//                                                             ),
//                                                             items: articleTypes
//                                                                 .map((String myMenuItem) {
//                                                               return DropdownMenuItem<
//                                                                   String>(
//                                                                 value: myMenuItem,
//                                                                 child: Text(
//                                                                   myMenuItem,
//                                                                   style: const TextStyle(
//                                                                       color: Colors
//                                                                           .blueGrey),
//                                                                 ),
//                                                               );
//                                                             }).toList(),
//                                                             onChanged: (String?
//                                                             valueSelectedByUser) {
//                                                               typeArticle =
//                                                               valueSelectedByUser!;
//                                                               articleTypeError = null;
//                                                             },
//                                                             value: _selected
//                                                                 ? typeArticle
//                                                                 : articleType,
//                                                           ),
//                                                         ),
//                                                       );
//                                                     },
//                                                   )
//                                                 ],
//                                               )),
//                                           Visibility(
//                                             child: Button(
//                                                 buttonText: 'CONFIRM',
//                                                 buttonFunction: () {
//                                                   if (articleController.text.isEmpty) {
//                                                     Toast.showToast('Scan an Article', context);
//                                                   } else if (articleController.text.length != 13
//                                                       || !validCharacters.hasMatch(articleController.text)) {
//                                                     Toast.showToast('Not a valid Article', context);
//                                                   }  else if (typeArticle.isEmpty) {
//                                                     Toast.showToast('Select the Article type', context);
//                                                   } else if (articles.contains(articleController.text)) {
//                                                     Navigator.of(context).pop();
//                                                     Toast.showToast('Article already added', context);
//                                                   } else if (!jsonBagArticles.contains(articleController.text)) {
//                                                     Navigator.of(context).pop();
//                                                     showDialog(context: context, builder: (BuildContext context) {
//                                                       return AlertDialog(
//                                                         title: const Text('Excess Article!'),
//                                                         content: RichText(
//                                                           text: TextSpan(
//                                                             text: 'Article ',
//                                                             style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor, fontSize: 14.sp),
//                                                             children:  <TextSpan>[
//                                                               TextSpan(text: articleController.text, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                                                               TextSpan(text: ' of type ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                                                               TextSpan(text: typeArticle, style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                                                               TextSpan(text: ' is not available in bag, would you still like to ', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                                                               TextSpan(text: 'ADD it', style: TextStyle(color: ColorConstants.kTextDark, letterSpacing: 1.sp, fontWeight: FontWeight.w500, fontSize: 14.sp)),
//                                                               TextSpan(text: '?', style: TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1.sp, fontSize: 14.sp)),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         // content: Text('Article ${scannedArticleController.text} of type $scannedTypeArticle is not available in bag, would you still like to add it?'),
//                                                         actions: [
//                                                           Row(
//                                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                                             children: [
//                                                               Button(buttonText: 'CANCEL', buttonFunction: () => Navigator.pop(context)),
//                                                               Button(buttonText: 'CONFIRM', buttonFunction: () {
//                                                                 setState(() {
//                                                                   scannedArticle.add(articleController.text);
//                                                                   scannedArticleType.add(typeArticle);
//                                                                   expansionArticle.add(articleController.text);
//                                                                   expansionArticleType.add(typeArticle);
//                                                                   articleController.clear();
//                                                                   Navigator.of(context).pop();
//                                                                   Toast.showToast('Article ${scannedArticleController.text} has been added', context);
//                                                                 });
//                                                               })
//                                                             ],
//                                                           )
//                                                         ],
//                                                       );
//                                                     });
//                                                   } else {
//                                                     setState(() {
//                                                       scannedArticle.add(articleController.text);
//                                                       scannedArticleType.add(typeArticle);
//                                                       expansionArticle.add(articleController.text);
//                                                       expansionArticleType.add(typeArticle);
//                                                       articleController.clear();
//                                                       Navigator.of(context).pop();
//                                                     });
//                                                   }
//                                                 }),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   });
//                             },
//                             icon: const Icon(Icons.add))
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Flexible(child: ExpansionTile(title: Text('Documents Received',
//                             style: TextStyle(fontSize: 16.0.sp)), children: [
//                           Card(
//                             child: SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: expansionBagDocs.toSet().toList()
//                                     .map((e) => Padding(
//                                   padding: EdgeInsets.all(8.0.w),
//                                   child: Text(e, style: const TextStyle(
//                                       color: ColorConstants.kTextColor,
//                                       letterSpacing: 1),
//                                   ),
//                                 )).toList(),
//                               ),
//                             ),
//                           )
//                         ],)),
//                         IconButton(onPressed: (){
//                           jsonBagDocuments.isNotEmpty ? showDialog(context: context, builder: (BuildContext context) {
//                             return StatefulBuilder(
//                                 builder: (BuildContext context, StateSetter setState){
//                                   return Dialog(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10.w.toDouble()))),
//                                     elevation: 0,
//                                     backgroundColor: ColorConstants.kWhite,
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Flexible(
//                                             child: ListView.builder(
//                                                 itemCount: jsonBagDocuments.toSet().toList().length,
//                                                 shrinkWrap: true,
//                                                 itemBuilder: (BuildContext context, int index) {
//                                                   return CheckboxListTile(
//                                                       value: jsonBagDocumentsCheck[index],
//                                                       title: Text(jsonBagDocuments[index]),
//                                                       onChanged: (bool? value){
//                                                         setState(() {
//                                                           checkDocs(value!, index, jsonBagDocuments[index]);
//                                                           jsonBagDocumentsCheck[index] = value;
//                                                           setState(() {
//                                                             documentsToBeReceivedController.text = jsonBagDocuments.toSet().toList().length.toString();
//                                                             documentReceivedController.text = expansionBagDocs.toSet().toList().length.toString();
//                                                           });
//                                                         });
//
//                                                       });
//                                                 }),
//                                           ),
//                                           Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Flexible(
//                                                       flex: 5,
//                                                       child: Text('Documents to be Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                   const Space(),
//                                                   Flexible(
//                                                     flex: 1,
//                                                     child: TextFormField(
//                                                       readOnly: true,
//                                                       style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                       decoration: const InputDecoration(
//                                                         border: InputBorder.none,
//                                                       ),
//                                                       controller: documentsToBeReceivedController,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Flexible(
//                                                       flex: 5,
//                                                       child: Text('Documents Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                   const Space(),
//                                                   Flexible(
//                                                     flex: 1,
//                                                     child: TextFormField(
//                                                       readOnly: true,
//                                                       style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                       decoration: const InputDecoration(
//                                                         border: InputBorder.none,
//                                                       ),
//                                                       controller: documentReceivedController,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const DoubleSpace(),
//                                               Button(buttonText: 'CONFIRM', buttonFunction: () {
//                                                 setState(() {
//                                                   for (int i=0; i<jsonBagDocumentsCheck.toSet().toList().length; i++) {
//                                                     if (jsonBagDocumentsCheck[i].toString() == 'true') {
//                                                       bagDocs.add(jsonBagDocuments[i]);
//                                                     } else if (jsonBagDocumentsCheck[i].toString() == 'false') {
//                                                       for (int i = 0; i < bagDocs.length; i ++) {
//                                                         if (jsonBagDocuments.contains(bagDocs[i])) {
//                                                           bagDocs.remove(bagDocs[i]);
//                                                         }
//                                                       }
//                                                     }
//                                                   }
//                                                 });
//                                                 Navigator.pop(context);
//                                               },)
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }
//                             );
//                           }) : showDialog(context: context, builder: (BuildContext context) {
//                             return Dialog(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(10.w.toDouble()))),
//                               elevation: 0,
//                               backgroundColor: ColorConstants.kWhite,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const Text('No Documents has been received in the bag!'),
//                                     Button(
//                                         buttonText: 'OKAY',
//                                         buttonFunction: () {
//                                           setState(() {
//                                             Navigator.of(context).pop();
//                                           });
//                                         }),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                         }, icon: const Icon(Icons.add))
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Flexible(
//                           child: ExpansionTile(
//                             title: Text(
//                               'Stamps Received',
//                               style: TextStyle(fontSize: 16.0.sp),
//                             ),
//                             children: <Widget>[
//                               Card(
//                                 child: Column(
//                                   children: [
//                                     const Space(),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                             flex: 2,
//                                             child: Text('Stamp Type', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),)),
//                                         Expanded(
//                                             flex: 1,
//                                             child: Text('Price', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                         Expanded(
//                                             flex: 1,
//                                             child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                         Expanded(
//                                             flex: 1,
//                                             child: Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                       ],),
//                                     const Divider(),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           flex: 2,
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: expansionStampName
//                                                 .map((e) => Padding(
//                                               padding: EdgeInsets.all(8.0.w),
//                                               child: Text(
//                                                 e, textAlign: TextAlign.center,
//                                                 style: const TextStyle(
//                                                     color: ColorConstants.kTextColor,
//                                                     letterSpacing: 1),
//                                               ),
//                                             ))
//                                                 .toList(),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Column(
//                                             children: expansionStampPrice
//                                                 .map((e) => Padding(
//                                               padding: EdgeInsets.all(8.0.w),
//                                               child: Text('\u{20B9} $e', textAlign: TextAlign.center,),
//                                             ))
//                                                 .toList(),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Column(
//                                             children: expansionStampQuantity
//                                                 .map((e) => Padding(
//                                               padding: EdgeInsets.all(8.0.w),
//                                               child: Text(e, textAlign: TextAlign.center,),
//                                             ))
//                                                 .toList(),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Column(
//                                             children: expansionStampTotal
//                                                 .map((e) => Padding(
//                                               padding: EdgeInsets.all(8.0.w),
//                                               child: Text('\u{20B9} $e',
//                                                   style: TextStyle(
//                                                       color: ColorConstants.kTextDark,
//                                                       fontWeight: FontWeight.w500,
//                                                       letterSpacing: 1.sp.toDouble())),
//                                             ))
//                                                 .toList(),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () {
//                               stampName.isNotEmpty ?
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (BuildContext context) {
//                                     return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
//                                       return AlertDialog(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.w.toDouble()))),
//                                         elevation: 0,
//                                         backgroundColor: ColorConstants.kWhite,
//                                         content: SingleChildScrollView(
//                                           child: Form(
//                                             key: _stampKey,
//                                             child: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 FormField<String>(builder: (FormFieldState<String> state){
//                                                   return DropdownButtonHideUnderline(child: DropdownButtonFormField<String>(
//                                                     decoration: const InputDecoration(enabledBorder: InputBorder.none),
//                                                     isExpanded: true,
//                                                     iconEnabledColor: Colors.blueGrey,
//                                                     hint: const Text(
//                                                       "Please Select Type of Stamp received",
//                                                       style: TextStyle(color: Color(0xFFCFB53B)),
//                                                     ),
//                                                     items: stampName.toSet().toList().map((String myMenuItem) {
//                                                       return DropdownMenuItem<String>(
//                                                         value: myMenuItem,
//                                                         child: Text(
//                                                           myMenuItem,
//                                                           style: const TextStyle(color: Colors.blueGrey),
//                                                         ),
//                                                       );
//                                                     }).toList(),
//                                                     onChanged: (String? valueSelectedByUser) {
//                                                       setQuantity(valueSelectedByUser!);
//                                                       _chosenStampType = valueSelectedByUser;
//                                                     },
//                                                     value: _chosenStampType,
//                                                   ));
//                                                 }),
//                                                 const Space(),
//                                                 TextFormField(
//                                                   onChanged: (text) async {
//                                                     checkStamp(quantityController.text, _chosenStampType!);
//                                                   },
//                                                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                                                   controller: quantityController,
//                                                   style: const TextStyle(color: ColorConstants.kSecondaryColor),
//                                                   keyboardType: TextInputType.number,
//                                                   decoration: InputDecoration(
//                                                       counterText: '',
//                                                       fillColor: ColorConstants.kWhite,
//                                                       filled: true,
//                                                       enabledBorder: const OutlineInputBorder(
//                                                         borderSide: BorderSide(color: ColorConstants.kWhite),
//                                                       ),
//                                                       prefixIcon: Container(
//                                                         padding: EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                                         margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                                         decoration: const BoxDecoration(
//                                                           color: ColorConstants.kSecondaryColor,
//                                                         ),
//                                                         child: const Icon(
//                                                           MdiIcons.shopping,
//                                                           color: ColorConstants.kWhite,
//                                                         ),
//                                                       ),
//                                                       labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
//                                                       labelText: 'Quantity',
//                                                       contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                                       isDense: true,
//                                                       border: OutlineInputBorder(
//                                                           borderSide: const BorderSide(color: ColorConstants.kWhite),
//                                                           borderRadius: BorderRadius.only(
//                                                             topLeft: Radius.circular(20.0.w.toDouble()),
//                                                             bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                                           )),
//                                                       focusedBorder: OutlineInputBorder(
//                                                           borderSide: const BorderSide(color: ColorConstants.kWhite),
//                                                           borderRadius: BorderRadius.only(
//                                                             topLeft: Radius.circular(20.0.w.toDouble()),
//                                                             bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                                           ))),
//                                                   validator: (text) {
//                                                     if (text!.isEmpty) {
//                                                       return 'Enter the Quantity';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                                 Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   children: [
//                                                     const Space(),
//                                                     Row(
//                                                       children: [
//                                                         Flexible(
//                                                             flex: 5,
//                                                             child: Text('Stamps to be Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                         const Space(),
//                                                         Flexible(
//                                                           flex: 1,
//                                                           child: TextFormField(
//                                                             style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                             decoration: const InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                             controller: stampToBeReceivedController,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Text('Value : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),),
//                                                         Flexible(
//                                                           child: Row(
//                                                             children: [
//                                                               const Text('\u{20B9} '),
//                                                               Flexible(
//                                                                 child: TextFormField(
//                                                                   style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                                   decoration: const InputDecoration(
//                                                                     border: InputBorder.none,
//                                                                   ),
//                                                                   controller: stampToBeReceivedValueController,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         Text('Price : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),),
//                                                         Flexible(
//                                                           child: Row(
//                                                             children: [
//                                                               const Text('\u{20B9} '),
//                                                               Flexible(
//                                                                 child: TextFormField(
//                                                                   style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                                   decoration: const InputDecoration(
//                                                                     border: InputBorder.none,
//                                                                   ),
//                                                                   controller: stampPriceController,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     // DialogText(title: 'Value : ', subtitle: '\u{20B9} $valueOfReceive'),
//                                                     const Space(),
//                                                     Row(
//                                                       children: [
//                                                         Flexible(
//                                                             flex: 5,
//                                                             child: Text('Stamps Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                         const Space(),
//                                                         Flexible(
//                                                           flex: 1,
//                                                           child: TextFormField(
//                                                             style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                             decoration: const InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                             controller: stampReceivedController,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Flexible(
//                                                             flex: 5,
//                                                             child: Text('Value : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                         const Space(),
//                                                         Flexible(
//                                                           flex: 1,
//                                                           child: Row(
//                                                             children: [
//                                                               const Text('\u{20B9} '),
//                                                               Flexible(
//                                                                 child: TextFormField(
//                                                                   style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                                   decoration: const InputDecoration(
//                                                                     border: InputBorder.none,
//                                                                   ),
//                                                                   controller: stampReceivedValueController,
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Flexible(
//                                                             flex: 5,
//                                                             child: Text('Excess Stamps : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                         const Space(),
//                                                         Flexible(
//                                                           flex: 1,
//                                                           child: TextFormField(
//                                                             readOnly: true,
//                                                             style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                             decoration: const InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                             controller: excessStampController,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     // DialogText(title: 'Stamps Received : ', subtitle: '$stampsReceived'),
//                                                     // DialogText(title: 'Value : ', subtitle: '\u{20B9} $valueOfReceived'),
//                                                     // DialogText(title: 'Excess Stamps : ', subtitle: differenceReceived.toString()),
//                                                     const DoubleSpace(),
//                                                     Button(buttonText: 'CONFIRM', buttonFunction: () {
//                                                       if (quantityController.text.isNotEmpty) {
//                                                         var total = int.parse(priceOfStamp) * int.parse(quantityController.text);
//                                                         setState(() {
//                                                           if (expansionStampName.contains(_chosenStampType)) {
//                                                             var ind = expansionStampName.indexWhere((element) => element == _chosenStampType);
//                                                             expansionStampName.removeAt(ind);
//                                                             expansionStampPrice.removeAt(ind);
//                                                             expansionStampQuantity.removeAt(ind);
//                                                             expansionStampTotal.removeAt(ind);
//                                                           }
//                                                           if (excessStampName.contains(_chosenStampType)) {
//                                                             var ind = excessStampName.indexWhere((element) => element == _chosenStampType);
//                                                             excessStampName.removeAt(ind);
//                                                             excessStampQuantity.removeAt(ind);
//                                                             excessStamps.removeAt(ind);
//                                                           }
//                                                           expansionStampName.add(_chosenStampType.toString());
//                                                           expansionStampPrice.add(priceOfStamp);
//                                                           expansionStampQuantity.add(quantityController.text);
//                                                           expansionStampTotal.add(total.toString());
//                                                           inventoryDetails = false;
//                                                           quantityController.clear();
//                                                           if (differenceReceived.toString() != '0') {
//                                                             excessStampName.add(_chosenStampType.toString());
//                                                             excessStampQuantity.add(differenceReceived);
//                                                             excessStamps.add('${_chosenStampType.toString()} | Excess => $differenceReceived');
//                                                           }
//                                                         });
//                                                         Navigator.pop(context);
//                                                       } else {
//                                                         Toast.showToast('Enter the quantity', context);
//                                                       }
//                                                     })
//                                                   ],
//                                                 ),
//                                                 // Button(
//                                                 //     buttonText: 'OKAY',
//                                                 //     buttonFunction: () async {
//                                                 //       setState(() {
//                                                 //         if (_stampKey.currentState!.validate()) {
//                                                 //
//                                                 //           if (expansionStampName.contains(_chosenStampType)) {
//                                                 //             var ind = expansionStampName.indexWhere((element) => element == _chosenStampType);
//                                                 //             expansionStampName.removeAt(ind);
//                                                 //             expansionStampPrice.removeAt(ind);
//                                                 //             expansionStampQuantity.removeAt(ind);
//                                                 //             expansionStampTotal.removeAt(ind);
//                                                 //           }
//                                                 //           if (excessStampName.contains(_chosenStampType)) {
//                                                 //             var ind = excessStampName.indexWhere((element) => element == _chosenStampType);
//                                                 //             excessStampName.removeAt(ind);
//                                                 //             excessStampQuantity.removeAt(ind);
//                                                 //             excessStamps.removeAt(ind);
//                                                 //           }
//                                                 //           index = stampName.indexWhere((element) => element == _chosenStampType);
//                                                 //           stampsToBeReceived = jsonBagStampQuantity[index];
//                                                 //           choosenStamp = _chosenStampType;
//                                                 //           priceOfStamp = jsonBagStampPrice[index];
//                                                 //           stampsReceived = int.parse(quantityController.text);
//                                                 //           valueOfReceive = int.parse(stampsToBeReceived) * int.parse(priceOfStamp);
//                                                 //           valueOfReceived = int.parse(quantityController.text) * int.parse(priceOfStamp);
//                                                 //           differenceReceived = int.parse(quantityController.text) - int.parse(stampsToBeReceived);
//                                                 //           inventoryDetails = true;
//                                                 //         }
//                                                 //       });
//                                                 //     }),
//
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     });
//                                   }) : showDialog(context: context, builder: (BuildContext context) {
//                                 return Dialog(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.w.toDouble()))),
//                                   elevation: 0,
//                                   backgroundColor: ColorConstants.kWhite,
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const Text('No Stamps has been received in the bag!'),
//                                         Button(
//                                             buttonText: 'OKAY',
//                                             buttonFunction: () {
//                                               setState(() {
//                                                 Navigator.of(context).pop();
//                                               });
//                                             }),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               });
//                             },
//                             icon: const Icon(Icons.add))
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Flexible(child: ExpansionTile(
//                           title: Text('Cash Received', style: TextStyle(fontSize: 16.sp),),
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         'Received Cash ',
//                                         style: TextStyle(
//                                             color: ColorConstants.kTextColor,
//                                             letterSpacing: 1.sp),
//                                       ),
//                                       const Text(
//                                         ' : ',
//                                         style: TextStyle(
//                                             color: ColorConstants.kTextColor,
//                                             letterSpacing: 1),
//                                       ),
//                                       Column(
//                                         children: cashBag
//                                             .map((e) => Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text('\u{20B9} $e', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500),),
//                                         ))
//                                             .toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         )),
//                         IconButton(onPressed: () {
//                           if (cashReceived != '0'){
//                             if (cashBag.isNotEmpty) {
//                               cashController.text = cashBag[0].toString();
//                               cashEnteredController.text = cashBag[0].toString();
//                             }
//                             showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (BuildContext context) {
//                                   return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
//                                     return AlertDialog(
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10.w.toDouble()))),
//                                       elevation: 0,
//                                       backgroundColor: ColorConstants.kWhite,
//                                       content: Form(
//                                         key: _cashKey,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             TextFormField(
//                                               onChanged: (text) async {
//                                                 cashCheck(cashController.text);
//                                               },
//                                               autovalidateMode: AutovalidateMode.onUserInteraction,
//                                               focusNode: cashFocusNode,
//                                               controller: cashController,
//                                               style: const TextStyle(color: ColorConstants.kSecondaryColor),
//                                               keyboardType: TextInputType.number,
//                                               decoration: InputDecoration(
//                                                   counterText: '',
//                                                   fillColor: ColorConstants.kWhite,
//                                                   filled: true,
//                                                   enabledBorder: const OutlineInputBorder(
//                                                     borderSide: BorderSide(color: ColorConstants.kWhite),
//                                                   ),
//                                                   prefixIcon: Container(
//                                                     padding: EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                                     margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                                     decoration: const BoxDecoration(
//                                                       color: ColorConstants.kSecondaryColor,
//                                                     ),
//                                                     child: const Icon(
//                                                       MdiIcons.currencyInr,
//                                                       color: ColorConstants.kWhite,
//                                                     ),
//                                                   ),
//                                                   labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
//                                                   labelText: 'Amount',
//                                                   contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                                                   isDense: true,
//                                                   border: OutlineInputBorder(
//                                                       borderSide: const BorderSide(color: ColorConstants.kWhite),
//                                                       borderRadius: BorderRadius.only(
//                                                         topLeft: Radius.circular(20.0.w.toDouble()),
//                                                         bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                                       )),
//                                                   focusedBorder: OutlineInputBorder(
//                                                       borderSide: const BorderSide(color: ColorConstants.kWhite),
//                                                       borderRadius: BorderRadius.only(
//                                                         topLeft: Radius.circular(20.0.w.toDouble()),
//                                                         bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                                       ))),
//                                               validator: (text) {
//                                                 if (text!.isEmpty) {
//                                                   return 'Enter the Amount';
//                                                 } else if (text.isNotEmpty) {
//                                                   cashDetails == true;
//                                                 }
//                                                 return null;
//                                               },
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Flexible(
//                                                         flex: 5,
//                                                         child: Text('Cash to be Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                     Flexible(
//                                                       flex: 1,
//                                                       child: Row(
//                                                         children: [
//                                                           const Text('\u{20B9}'),
//                                                           Flexible(
//                                                             child: TextFormField(
//                                                               style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                               decoration: const InputDecoration(
//                                                                 border: InputBorder.none,
//                                                               ),
//                                                               controller: cashToBeReceivedController,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Flexible(
//                                                         flex: 5,
//                                                         child: Text('Cash Received : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                     const Space(),
//                                                     Flexible(
//                                                       flex: 1,
//                                                       child: TextFormField(
//                                                         style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                         decoration: const InputDecoration(
//                                                           border: InputBorder.none,
//                                                         ),
//                                                         controller: cashEnteredController,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     Flexible(
//                                                         flex: 5,
//                                                         child: Text('Cash Short/Excess : ', style: TextStyle(letterSpacing: 1.sp, color: ColorConstants.kTextColor),)),
//                                                     const Space(),
//                                                     Flexible(
//                                                       flex: 1,
//                                                       child: TextFormField(
//                                                         style: const TextStyle(color: ColorConstants.kTextDark, fontWeight: FontWeight.w500),
//                                                         decoration: const InputDecoration(
//                                                           border: InputBorder.none,
//                                                         ),
//                                                         controller: excessCashController,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 const DoubleSpace(),
//                                                 Button(buttonText: 'CONFIRM', buttonFunction: () {
//                                                   setState(() {
//                                                     cashBag.clear();
//                                                     cashBag.add(cashController.text);
//                                                     totalCash = int.parse(cashController.text);
//                                                   });
//                                                   Navigator.pop(context);
//                                                 },)
//                                               ],
//                                             ),
//                                             // Align(
//                                             //   alignment: Alignment.center,
//                                             //   child: Button(
//                                             //       buttonText: 'OKAY',
//                                             //       buttonFunction: () {
//                                             //         if (_cashKey.currentState!.validate()) {
//                                             //           if (cashController.text.isEmpty) {
//                                             //             Toast.showToast(
//                                             //                 'Enter the amount', context);
//                                             //           } else if (cashController.text.startsWith('-') ||
//                                             //               cashController.text.startsWith('.') || cashController.text == '0') {
//                                             //             Navigator.pop(context);
//                                             //             Toast.showToast('Enter a valid Amount', context);
//                                             //           } else {
//                                             //             totalCash = int.parse(cashController.text);
//                                             //             excessCash = (int.parse(cashController.text) - int.parse(cashReceived)).toString();
//                                             //             setState(() {
//                                             //               cashDetails = true;
//                                             //             });
//                                             //           }
//                                             //         }
//                                             //       }),
//                                             // ),
//
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   });
//                                 });
//                           } else {
//                             showDialog(context: context, builder: (BuildContext context) {
//                               return Dialog(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(10.w.toDouble()))),
//                                 elevation: 0,
//                                 backgroundColor: ColorConstants.kWhite,
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Text('No available Cash has been received in the bag!'),
//                                       Button(
//                                           buttonText: 'OKAY',
//                                           buttonFunction: () {
//                                             setState(() {
//                                               Navigator.of(context).pop();
//                                             });
//                                           }),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             });
//                           }
//                         }, icon: const Icon(Icons.add))
//                       ],
//                     ),
//                     Button(
//                         buttonText: 'ADD',
//                         buttonFunction: () async {
//                           scannedArticlesList.toSet().toList();
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return const Center(child: CircularProgressIndicator(),);
//                               });
//                           await addingData();
//                           Toast.showToast(
//                               'Details has been added for the Bag ${widget.bagNumber}',
//                               context);
//                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//                               builder: (_) => BagDetailsScreen(bagNumber: widget.bagNumber, toBeScannedList: toBeScannedArticlesList,)), (route) => false);
//                         }),
//                     const DoubleSpace(),
//                     Card(
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0.w),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             titleValueText('No. of Articles expected to be scanned', totalArticles.toString()),
//                             titleValueText('No. of Articles scanned', scannedArticle.toSet().toList().length.toString()),
//                             // titleValueText('Scanned Articles from Bag', scanned()),
//                             titleValueText('No. of Articles yet to be Scanned', toBeScanned()),
//                             const Space(),
//                             Visibility(
//                                 visible: excessArticlesList.isNotEmpty || excessStampQuantity.isNotEmpty || excessCash.isNotEmpty,
//                                 child: const Divider()),
//                             const Space(),
//                             Visibility(
//                                 visible: excessArticlesList.isNotEmpty,
//                                 child: titleValueText('Excess Articles', excessScanned())),
//                             Visibility(
//                                 visible: excessStamps.isNotEmpty,
//                                 child: titleValueText('Excess/Short Stamps', excess())),
//                             Visibility(
//                                 visible: excessCash.isNotEmpty,
//                                 child: titleValueText1('Excess/Short Cash', '\u{20B9} $excessCash')),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     ), onWillPop: () async {
//       moveToPrevious(context);
//       return true;
//     });
//   }
//
//   excess() {
//     var total = 0;
//     if (excessStampQuantity.isEmpty) {
//       for ( int i = 0; i<excessStamps.length; i++) {
//         total = excessStamps.length;
//       }
//     } else {
//       for (int i = 0; i<excessStampQuantity.length; i++) {
//         total += excessStampQuantity[i];
//       }
//     }
//
//     return total.toString();
//   }
//
//   Widget titleValueText(String title, String value) {
//     return Padding(
//       padding:  EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                     color: ColorConstants.kTextColor,
//                     letterSpacing: 1, fontSize: 15.sp),
//               )),
//           const SizedBox(
//             child: Text(' : '),
//           ),
//           Expanded(
//               flex: 1,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(value,
//                       style: TextStyle(fontSize: 15.sp,
//                           color: ColorConstants.kTextDark,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 1)),
//                   IconButton(onPressed: (){
//                     var listToBeSent = [];
//                     if (title == 'No. of Articles expected to be scanned'){
//                       listToBeSent = jsonBagArticles.toSet().toList();
//                     } else if (title == 'No. of Articles scanned') {
//                       listToBeSent = scannedArticle.toSet().toList();
//                     } else if (title == 'No. of Articles yet to be Scanned') {
//                       listToBeSent = toBeScannedArticlesList.toSet().toList();
//                     } else if (title == 'Excess Articles') {
//                       listToBeSent = excessArticlesList.toSet().toList();
//                     } else if (title == 'Excess/Short Stamps') {
//                       listToBeSent = excessStamps.toSet().toList();
//                     }
//                     else {
//                       listToBeSent = [];
//                     }
//                     Navigator.push(context, MaterialPageRoute(builder: (_) =>
//                         BagScannedDetailsScreen(title: title, list: listToBeSent,)));
//                   }, icon: const Icon(Icons.keyboard_arrow_right_outlined))
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   Widget titleValueText1(String title, String value) {
//     return Padding(
//       padding:  EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Text(
//                 title,
//                 style: TextStyle(
//                     color: ColorConstants.kTextColor,
//                     letterSpacing: 1, fontSize: 15.sp),
//               )),
//           const SizedBox(
//             child: Text(' : '),
//           ),
//           Expanded(
//               flex: 1,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(value,
//                       style: TextStyle(fontSize: 15.sp,
//                           color: ColorConstants.kTextDark,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 1)),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//
//   addCashToBag(String amount, String articleNumber) async {
//     if (totalCash.toString() != 'null') {
//       await BaggingDBService().addBagCashToDB(totalCash.toString(), 'Added', widget.bagNumber, cashReceived);
//       for (int i=0;i<cash.length; i++) {
//         await BaggingDBService().addCashFromBagToDB(i.toString() , cash[i], widget.bagNumber);
//       }
//       final addCash =  CashTable()
//         ..Cash_ID = widget.bagNumber
//         ..Cash_Date = DateTimeDetails().currentDate()
//         ..Cash_Time = DateTimeDetails().onlyTime()
//         ..Cash_Type = 'Add'
//         ..Cash_Amount = totalCash!.toDouble()
//         ..Cash_Description = 'Bag Receive';
//       addCash.upsert();
//       cashAdded = false;
//     }
//     if (amount.isNotEmpty) {
//       final addCash =  CashTable()
//         ..Cash_ID = articleNumber+'EMO'
//         ..Cash_Date = DateTimeDetails().currentDate()
//         ..Cash_Time = DateTimeDetails().onlyTime()
//         ..Cash_Type = 'Add'
//         ..Cash_Amount = double.parse(amount)
//         ..Cash_Description = 'EMO';
//       addCash.upsert();
//     }
//
//   }
//
//   addCashMain() async {
//     for (int i =0; i< cash.length; i++) {
//       await BaggingDBService().addCashReceive(cash[i], widget.bagNumber);
//     }
//   }
//
//   addInventoryToBag() async {
//     final receivedInventory = await BagInventory().select().BagNumber.equals(widget.bagNumber).toMapList();
//     List receivedStamps = [];
//     for (int i =0; i<receivedInventory.length; i++) {
//       receivedStamps.add(receivedInventory[i]['InventoryName']);
//     }
//     for (int i = 0;i < expansionStampName.toSet().toList().length; i++) {
//       await BaggingDBService().addInventoryFromBagToDB(expansionStampName[i],
//           expansionStampPrice[i], expansionStampQuantity[i], expansionStampTotal[i],
//           widget.bagNumber, 'Added');
//       await BaggingDBService().addProductsMain(expansionStampName[i],
//           int.parse(expansionStampPrice[i]), int.parse(expansionStampQuantity[i]));
//     }
//     print("Excess stamp name is $excessStampName");
//     for (int i = 0; i < excessStamps.toSet().toList().length; i++) {
//       final isPresent = receivedStamps.indexWhere((element) => element == excessStampName[i].toString());
//       var total = int.parse(receivedInventory[isPresent]['InventoryPrice']) * excessStampQuantity[i];
//       await BaggingDBService().addExcessInventoryFromBagToDB(expansionStampName[i], excessStampName[i],
//           receivedInventory[isPresent]['InventoryPrice'], excessStampQuantity[i].toString(),
//           total.toString(), widget.bagNumber, 'Added');
//     }
//   }
//
//   addArticlesToBag() async {
//     for (int i = 0; i < scannedArticle.length; i++) {
//       await BaggingDBService().updateBagArticlesToDB(widget.bagNumber, scannedArticle[i], scannedArticleType[i], 'Added');
//       await BaggingDBService().addArticlesToDelivery(widget.bagNumber, scannedArticle[i], scannedArticleType[i]);
//       print("Scanned Article Type of ${scannedArticle[i]} is ${scannedArticleType[i]}");
//       if (scannedArticleType[i] == 'EMO') {
//         addCashToBag('1000', scannedArticle[i]);
//       }
//     }
//   }
//
//   addDocumentsToBag() async {
//     if (expansionBagDocs.isNotEmpty) {
//       for (int i = 0; i < expansionBagDocs.length; i++) {
//         await BaggingDBService().updateBagDocumentsToDB(widget.bagNumber, expansionBagDocs[i], 'Y', 'Added');
//       }
//     }
//
//     // if (bagDocs.isNotEmpty) {
//     //   for (int i = 0; i < bagDocs.toSet().toList().length; i++) {
//     //     await BaggingDBService().updateBagDocumentsToDB(
//     //         bagDocs[i].toString().replaceAll(' ', ''), widget.bagNumber, bagDocs[i], 'Y');
//     //   }
//     // }
//
//   }
//
//
//
//   Future<bool> addingData() async {
//     await addDocumentsToBag();
//     await addArticlesToBag();
//     await addCashToBag('', '');
//     await addCashMain();
//     await addInventoryToBag();
//     return true;
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
//                 scannedArticlesList.toSet().toList();
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
//
//
//   checkStamp(String quantity, String stamp) {
//     index = stampName.indexWhere((element) => element == _chosenStampType);
//     priceOfStamp = jsonBagStampPrice[index];
//     valueOfReceive = int.parse(jsonBagStampQuantity[index]) * int.parse(priceOfStamp);
//     valueOfReceived = int.parse(quantityController.text) * int.parse(priceOfStamp);
//     differenceReceived = int.parse(quantityController.text) - int.parse(jsonBagStampQuantity[index]);
//      if (differenceReceived != 0) {
//
//      }
//     setState(() {
//       stampToBeReceivedController.text = jsonBagStampQuantity[index];
//       stampToBeReceivedValueController.text = valueOfReceive.toString();
//       stampPriceController.text = priceOfStamp.toString();
//       stampReceivedController.text = quantity;
//       stampReceivedValueController.text = valueOfReceived.toString();
//       excessStampController.text = differenceReceived.toString();
//     });
//   }
//
//   checkDocs(bool value, int index, String doc) {
//     jsonBagDocumentsCheck[index] = value;
//     if (jsonBagDocumentsCheck[index] == true) {
//      setState(() {
//        expansionBagDocs.add(jsonBagDocuments[index]);
//      });
//     } else if (jsonBagDocumentsCheck[index] == false) {
//       if (expansionBagDocs.contains(doc)) {
//        setState(() {
//          expansionBagDocs.removeWhere((element) => element == doc);
//        });
//       }
//     }
//     // setState(() {
//     //   documentsToBeReceivedController.text = jsonBagDocuments.toSet().toList().length.toString();
//     //   documentReceivedController.text = expansionBagDocs.toSet().toList().length.toString();
//     // });
//   }
//
//   setQuantity(String stampType) {
//     if (expansionStampName.contains(stampType)) {
//       final index = expansionStampName.indexWhere((element) => element == stampType);
//       priceOfStamp = jsonBagStampPrice[index];
//       valueOfReceive = int.parse(jsonBagStampQuantity[index]) * int.parse(priceOfStamp);
//       valueOfReceived = int.parse(expansionStampQuantity[index]) * int.parse(priceOfStamp);
//       differenceReceived = int.parse(expansionStampQuantity[index]) - int.parse(jsonBagStampQuantity[index]);
//       setState(() {
//         quantityController.text = expansionStampQuantity[index].toString();
//         stampToBeReceivedController.text = jsonBagStampQuantity[index];
//         stampPriceController.text = priceOfStamp.toString();
//         stampToBeReceivedValueController.text = valueOfReceive.toString();
//         stampReceivedController.text = expansionStampQuantity[index].toString();
//         stampReceivedValueController.text = valueOfReceived.toString();
//         excessStampController.text = differenceReceived.toString();
//       });
//     } else {
//       final index = stampName.indexWhere((element) => element == stampType);
//       priceOfStamp = jsonBagStampPrice[index];
//       valueOfReceive = int.parse(jsonBagStampQuantity[index]) * int.parse(priceOfStamp);
//       setState(() {
//         quantityController.text = '';
//         stampPriceController.text = priceOfStamp.toString();
//         stampToBeReceivedController.text = jsonBagStampQuantity[index];
//         stampToBeReceivedValueController.text = valueOfReceive.toString();
//       });
//     }
//   }
//
//   cashCheck(String cash) {
//     setState(() {
//       cashEnteredController.text = cash;
//       excessCash = (int.parse(cashController.text) - int.parse(cashReceived)).toString();
//       excessCashController.text = excessCash;
//     });
//     // if (cash.isEmpty) {
//     //   if (cashBag.isNotEmpty) {
//     //     setState(() {
//     //       cashController.text = cashBag[0].toString();
//     //       cashEnteredController.text = cashBag[0].toString();
//     //     });
//     //   }
//     // } else {
//     //   setState(() {
//     //     cashEnteredController.text = cash;
//     //     excessCash = (int.parse(cashController.text) - int.parse(cashReceived)).toString();
//     //     excessCashController.text = excessCash;
//     //   });
//     // }
//   }
//
//
// }
//
// class CheckBoxListTileModel {
//   int userId;
//   String img;
//   String title;
//   bool isCheck;
//
//   CheckBoxListTileModel({required this.userId, required this.img, required this.title, required this.isCheck});
//
//   static List<CheckBoxListTileModel> getUsers() {
//     return <CheckBoxListTileModel>[
//       CheckBoxListTileModel(
//           userId: 1,
//           img: 'assets/images/android_img.png',
//           title: "Android",
//           isCheck: true),
//       CheckBoxListTileModel(
//           userId: 2,
//           img: 'assets/images/flutter.jpeg',
//           title: "Flutter",
//           isCheck: false),
//       CheckBoxListTileModel(
//           userId: 3,
//           img: 'assets/images/ios_img.webp',
//           title: "IOS",
//           isCheck: false),
//       CheckBoxListTileModel(
//           userId: 4,
//           img: 'assets/images/php_img.png',
//           title: "PHP",
//           isCheck: false),
//       CheckBoxListTileModel(
//           userId: 5,
//           img: 'assets/images/node_img.png',
//           title: "Node",
//           isCheck: false),
//     ];
//   }
// }
//
// class StampsOfExcess {
//
//   String? name;
//   int? quantity;
//
//   StampsOfExcess({required this.name, required this.quantity});
//
//   @override
//   String toString() {
//     return '{${this.name}, ${this.quantity}';
//   }
// }
