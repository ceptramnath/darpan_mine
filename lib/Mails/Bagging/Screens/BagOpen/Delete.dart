// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
// import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
// import 'package:darpan_mine/Utils/Scan.dart';
// import 'package:darpan_mine/Widgets/Button.dart';
// import 'package:darpan_mine/Widgets/LetterForm.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'BagDetailsScreen.dart';
// import 'BagOpenScreen.dart';
//
// class Delete extends StatefulWidget {
//   final String bagNumber;
//
//   Delete({Key? key, required this.bagNumber}) : super(key: key);
//
//   @override
//   State<Delete> createState() => _DeleteState();
// }
//
// class _DeleteState extends State<Delete> {
//
//   String? articlesCount;
//   String? documentCount;
//   String? stampCount;
//   String? cashCount;
//
//   getDBData() async {
//     final dbData = await BagReceivedTable().select().BagNumber.equals(widget.bagNumber).toMapList();
//     articlesCount = dbData[0]['ArticlesCount'].toString().isEmpty ? '0' : dbData[0]['ArticlesCount'];
//     documentCount = dbData[0]['DocumentsCount'].toString().isEmpty ? '0' : dbData[0]['DocumentsCount'];
//     stampCount = dbData[0]['StampsCount'].toString().isEmpty ? '0' : dbData[0]['StampsCount'];
//     cashCount = dbData[0]['CashCount'].toString().isEmpty ? '0' : dbData[0]['CashCount'];
//     return dbData;
//   }
//
//   final bool _selected = false;
//
//   String? articleType;
//
//   String typeArticle = '';
//   String? scannedTypeArticle;
//   String? articleTypeError;
//
//   static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
//
//   final stampsKey = GlobalKey<FormState>();
//
//   final articleFocus = FocusNode();
//   final scannedArticleFocus = FocusNode();
//
//   final articleController = TextEditingController();
//   final scannedArticleController = TextEditingController();
//   final documentController = TextEditingController();
//   final stampNameController = TextEditingController();
//   final stampQuantityController = TextEditingController();
//   final stampPriceController = TextEditingController();
//
//   List articles = [];
//   List documents = [];
//   List scannedArticle = [];
//   List scannedArticleType = [];
//   List expansionArticle = [];
//   List expansionArticleType = [];
//   List<String> jsonBagArticles = [];
//   List<String> jsonBagArticleTypes = [];
//   List<String> articleTypes = ['EMO', 'Parcel', 'LETTER', 'Speed Post'];
//   List stampName = [];
//   List stampPrice = [];
//   List stampQuantity = [];
//   List stampTotal = [];
//
//
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
//           if (jsonBagArticleTypes[index].startsWith('E')) {
//             scannedTypeArticle = articleTypes[0];
//             articleTypeError = null;
//           } else if (index.isNegative){
//             // scannedTypeArticle = articleTypes[2];
//             articleTypeError = null;
//           }
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return scannerDialog();
//               });
//         }
//       } else {
//         Toast.showFloatingToast('Not a Valid Article', context);
//       }
//     }
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
//                             const InputDecoration(enabledBorder: InputBorder.none),
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
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushAndRemoveUntil(context,
//             MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false);
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: ColorConstants.kPrimaryColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(30.w),
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pushAndRemoveUntil(context,
//                 MaterialPageRoute(builder: (_) => BagOpenScreen()), (route) => false),
//           ),
//           title: Text('Details of ${widget.bagNumber}'),
//         ),
//         body: FutureBuilder(
//           future: getDBData(),
//           builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               return Padding(
//                 padding: EdgeInsets.all(10.w),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Flexible(
//                             child: ExpansionTile(
//                               title: Text(
//                                 'Articles Received',
//                                 style: TextStyle(fontSize: 16.0.sp),
//                               ),
//                               children: <Widget>[
//                                 Card(
//                                   child: Row(
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: expansionArticleType
//                                             .map((e) => Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text(
//                                             e,
//                                             style: const TextStyle(
//                                                 color: ColorConstants.kTextColor,
//                                                 letterSpacing: 1),
//                                           ),
//                                         ))
//                                             .toList(),
//                                       ),
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: expansionArticle
//                                             .map((e) => Padding(
//                                           padding: EdgeInsets.symmetric(vertical: 8.0.w),
//                                           child: const Text(' : '),
//                                         ))
//                                             .toList(),
//                                       ),
//                                       Column(
//                                         children: expansionArticle
//                                             .map((e) => Padding(
//                                           padding: EdgeInsets.all(8.0.w),
//                                           child: Text(e,
//                                               style: TextStyle(
//                                                   color: ColorConstants.kTextDark,
//                                                   fontWeight: FontWeight.w500,
//                                                   letterSpacing: 1.sp.toDouble())),
//                                         ))
//                                             .toList(),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 typeArticle = '';
//                                 articleController.clear();
//                                 articlesCount == '0' ? showDialog(context: context, builder: (BuildContext context) {
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
//                                           const Text('No Articles has been received in the bag!'),
//                                           Button(
//                                               buttonText: 'OKAY',
//                                               buttonFunction: () {
//                                                 setState(() {
//                                                   Navigator.of(context).pop();
//                                                 });
//                                               }),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }) :
//                                 showDialog(
//                                     context: context,
//                                     barrierDismissible: false,
//                                     builder: (BuildContext context) {
//                                       return Dialog(
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(10.w.toDouble()))),
//                                         elevation: 0,
//                                         backgroundColor: ColorConstants.kWhite,
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Padding(
//                                                 padding: EdgeInsets.all(15.0.w),
//                                                 child: Column(
//                                                   children: [
//                                                     const Space(),
//                                                     ScanTextFormField(
//                                                       type: 'Article',
//                                                       title: 'Article Number',
//                                                       focus: articleFocus,
//                                                       controller: articleController,
//                                                       scanFunction: () {
//                                                         scanBarcode();
//                                                         Navigator.of(context).pop();
//                                                       },
//                                                     ),
//                                                     const Space(),
//                                                     FormField<String>(
//                                                       builder:
//                                                           (FormFieldState<String> state) {
//                                                         return DropdownButtonHideUnderline(
//                                                           child:
//                                                           DropdownButtonHideUnderline(
//                                                             child: DropdownButtonFormField<
//                                                                 String>(
//                                                               decoration:
//                                                               const InputDecoration(
//                                                                   enabledBorder:
//                                                                   InputBorder.none),
//                                                               isExpanded: true,
//                                                               iconEnabledColor:
//                                                               Colors.blueGrey,
//                                                               hint: const Text(
//                                                                 'Article Type',
//                                                                 style: TextStyle(
//                                                                     color:
//                                                                     Color(0xFFCFB53B)),
//                                                               ),
//                                                               items: articleTypes
//                                                                   .map((String myMenuItem) {
//                                                                 return DropdownMenuItem<
//                                                                     String>(
//                                                                   value: myMenuItem,
//                                                                   child: Text(
//                                                                     myMenuItem,
//                                                                     style: const TextStyle(
//                                                                         color: Colors
//                                                                             .blueGrey),
//                                                                   ),
//                                                                 );
//                                                               }).toList(),
//                                                               onChanged: (String?
//                                                               valueSelectedByUser) {
//                                                                 typeArticle =
//                                                                 valueSelectedByUser!;
//                                                                 articleTypeError = null;
//                                                               },
//                                                               value: _selected
//                                                                   ? typeArticle
//                                                                   : articleType,
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                     )
//                                                   ],
//                                                 )),
//                                             Visibility(
//                                               child: Button(
//                                                   buttonText: 'CONFIRM',
//                                                   buttonFunction: () {
//                                                     if (articleController.text.isEmpty) {
//                                                       Toast.showToast('Scan an Article', context);
//                                                     } else if (articleController.text.length != 13
//                                                         || !validCharacters.hasMatch(articleController.text)) {
//                                                       Toast.showToast('Not a valid Article', context);
//                                                     }  else if (typeArticle.isEmpty) {
//                                                       Toast.showToast('Select the Article type', context);
//                                                     } else if (articles.contains(articleController.text)) {
//                                                       Navigator.of(context).pop();
//                                                       Toast.showToast('Article already added', context);
//                                                     } else {
//                                                       setState(() {
//                                                         scannedArticle.add(articleController.text);
//                                                         scannedArticleType.add(typeArticle);
//                                                         expansionArticle.add(articleController.text);
//                                                         expansionArticleType.add(typeArticle);
//                                                         articleController.clear();
//                                                         Navigator.of(context).pop();
//                                                       });
//                                                     }
//                                                   }),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     });
//                               },
//                               icon: const Icon(Icons.add))
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Flexible(child: ExpansionTile(
//                             title: Text('Documents Received', style: TextStyle(fontSize: 16.sp),),
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Card(
//                                   child: SizedBox(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: documents.toSet().toList().map((e) => Padding(
//                                         padding: EdgeInsets.all(8.0.w),
//                                         child: Text(e, style: TextStyle(
//                                           color: ColorConstants.kTextColor,
//                                             letterSpacing: 1.sp
//                                         ),),
//                                       )).toList(),
//                                     ),
//                                   )
//                                 ),
//                               )
//                             ],
//                           )),
//                           IconButton(onPressed: (){
//                             documentCount == "0" ? showDialog(context: context, builder: (BuildContext context) {
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
//                                       const Text('No Documents has been received in the bag!'),
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
//                             }) : showDialog(context: context, builder: (BuildContext context) {
//                               return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
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
//                                         TextFormField(
//                                           controller: documentController,
//                                           decoration: const InputDecoration(hintText: 'Document name', labelText: 'Name', border: InputBorder.none,),
//                                         ),
//                                         Button(buttonText: 'ADD', buttonFunction: (){
//                                           if (documentController.text.isNotEmpty) {
//                                             documents.add(documentController.text);
//                                             documentController.clear();
//                                             Navigator.pop(context);
//                                           } else {
//                                             Navigator.pop(context);
//                                           }
//                                         },)
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               });
//                             });
//                           }, icon: const Icon(Icons.add))
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Flexible(
//                             child: ExpansionTile(
//                               title: Text('Stamps Received', style: TextStyle(fontSize: 16.sp),),
//                               children: [
//                                 Card(
//                                   child: Column(
//                                     children: [
//                                       const Space(),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                               flex: 2,
//                                               child: Text('Stamp Type', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),)),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text('Price', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text('Quantity', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                           Expanded(
//                                               flex: 1,
//                                               child: Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp))),
//                                         ],),
//                                       const Divider(),
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             flex: 2,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: stampName
//                                                   .map((e) => Padding(
//                                                 padding: EdgeInsets.all(8.0.w),
//                                                 child: Text(
//                                                   e, textAlign: TextAlign.center,
//                                                   style: const TextStyle(
//                                                       color: ColorConstants.kTextColor,
//                                                       letterSpacing: 1),
//                                                 ),
//                                               )).toList(),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Column(
//                                               children: stampPrice
//                                                   .map((e) => Padding(
//                                                 padding: EdgeInsets.all(8.0.w),
//                                                 child: Text('\u{20B9} $e', textAlign: TextAlign.center,),
//                                               )).toList(),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Column(
//                                               children: stampQuantity
//                                                   .map((e) => Padding(
//                                                 padding: EdgeInsets.all(8.0.w),
//                                                 child: Text(e, textAlign: TextAlign.center,),
//                                               )).toList(),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             flex: 1,
//                                             child: Column(
//                                               children: stampTotal
//                                                   .map((e) => Padding(
//                                                 padding: EdgeInsets.all(8.0.w),
//                                                 child: Text('\u{20B9} $e',
//                                                     style: TextStyle(
//                                                         color: ColorConstants.kTextDark,
//                                                         fontWeight: FontWeight.w500,
//                                                         letterSpacing: 1.sp.toDouble())),
//                                               )).toList(),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           IconButton(onPressed: (){
//                             stampCount == '0' ?  showDialog(context: context, builder: (BuildContext context) {
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
//                                       const Text('No Stamps has been received in the bag!'),
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
//                             }) : showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
//                               return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
//                                 return Dialog(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(10.w.toDouble()))),
//                                   elevation: 0,
//                                   backgroundColor: ColorConstants.kWhite,
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//                                     child: Form(
//                                       key: stampsKey,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           TextFormField(
//                                             controller: stampNameController,
//                                             decoration: const InputDecoration(hintText: 'Stamp name', labelText: 'Name', border: InputBorder.none,),
//                                           ),
//                                           Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Flexible(
//                                                 child: TextFormField(
//                                                   keyboardType: TextInputType.number,
//                                                   controller: stampPriceController,
//                                                   decoration: const InputDecoration(hintText: 'Stamp Price', labelText: 'Price', border: InputBorder.none,),
//                                                   validator: (value) {
//                                                     if (value!.trim().isEmpty || value == null) return 'Enter the price';
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: TextFormField(
//                                                   keyboardType: TextInputType.number,
//                                                   controller: stampQuantityController,
//                                                   decoration: const InputDecoration(hintText: 'Stamp Quantity', labelText: 'Quantity', border: InputBorder.none,),
//                                                   validator: (value) {
//                                                     if (value!.trim().isEmpty || value == null) return 'Enter the quantity';
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Align(
//                                               alignment: Alignment.center,
//                                               child: Button(buttonText: 'ADD', buttonFunction: (){
//                                                 if (stampNameController.text.isNotEmpty) {
//                                                   if (stampsKey.currentState!.validate()) {
//                                                     var total = int.parse(stampPriceController.text) * int.parse(stampQuantityController.text);
//                                                     stampName.add(stampNameController.text);
//                                                     stampQuantity.add(stampQuantityController.text);
//                                                     stampPrice.add(stampPriceController.text);
//                                                     stampTotal.add(total.toString());
//                                                     stampNameController.clear();
//                                                     stampQuantityController.clear();
//                                                     stampPriceController.clear();
//                                                     Navigator.pop(context);
//                                                   }
//                                                 } else {
//                                                   Navigator.pop(context);
//                                                 }
//                                               },))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               });
//                             });
//                           }, icon: const Icon(Icons.add))
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.h),
//                         child: Text('Cash Received : \u{20B9}$cashCount', style: TextStyle(fontSize: 17.sp),),
//                       ),
//                       SizedBox(height: 40.h,),
//                       Align(
//                           alignment: Alignment.center,
//                           child: Button(buttonText: 'ADD', buttonFunction: () async {
//                             if (articlesCount != scannedArticle.length.toString()) return Toast.showFloatingToast('Articles scanned is not equal to entered number', context);
//                             if (stampCount != stampName.length.toString()) return Toast.showFloatingToast('Stamps entered is not equal to entered number', context);
//                             if (documentCount != documents.length.toString()) return Toast.showFloatingToast('Documents entered is not equal to entered number', context);
//                             await addBagData();
//                             Toast.showToast(
//                                 'Details has been added for the Bag ${widget.bagNumber}',
//                                 context);
//                             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagDetailsScreen(bagNumber: widget.bagNumber, toBeScannedList: scannedArticle,)), (route) => false);
//                           }))
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
//   Future<bool> addBagData() async {
//
//     //Adding Articles
//     for (int i = 0; i < scannedArticle.length; i++) {
//       await BaggingDBService().updateBagArticlesToDB(widget.bagNumber, scannedArticle[i], scannedArticleType[i], 'Added');
//       await BaggingDBService().addArticlesToDelivery(widget.bagNumber, scannedArticle[i], scannedArticleType[i]);
//     }
//
//     //Adding Documents
//     for (int i = 0; i < documents.length; i++) {
//       await BaggingDBService().updateBagDocumentsToDB(widget.bagNumber, documents[i], 'Y', 'Added');
//     }
//
//     //Adding Stamps
//     for (int i = 0; i < stampName.length; i++) {
//       await BaggingDBService().addInventoryFromBagToDB(stampName[i], stampPrice[i], stampQuantity[i], stampTotal[i], widget.bagNumber, 'Added');
//       await BaggingDBService().addProductsMain(stampName[i], int.parse(stampPrice[i]), int.parse(stampQuantity[i]));
//     }
//
//     //Adding Cash
//     await BaggingDBService().addCashReceive(cashCount!, widget.bagNumber);
//     await BaggingDBService().addBagCashToDB(cashCount!, 'Added', widget.bagNumber, cashCount!);
//     return true;
//   }
// }
