// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Constants/Texts.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagOpenScreen.dart';
// import 'package:darpan_mine/Mails/Booking/EMO/Screens/EMOMainScreen.dart';
// import 'package:darpan_mine/Mails/Booking/Parcel/Screens/ParcelBookingScreen.dart';
// import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';
// import 'package:darpan_mine/Mails/Booking/SpeedPost/Screens/SpeedPostScreen.dart';
// import 'package:darpan_mine/Widgets/HomeCard.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// import 'Mails/Bagging/Screens/BagCloseScreen.dart';
// import 'Widgets/Button.dart';
//
// class DummyMainScreen extends StatefulWidget {
//   @override
//   _DummyMainScreenState createState() => _DummyMainScreenState();
// }
//
// class _DummyMainScreenState extends State<DummyMainScreen> {
//   bool mails = false;
//   bool banking = false;
//   bool insurance = false;
//   bool booking = false;
//   bool delivery = false;
//   bool bagging = false;
//   bool regdLetter = false;
//   bool regdParcel = false;
//   bool emo = false;
//   bool speedPost = false;
//   bool savingsBank = false;
//   bool bagOpen = false;
//   bool bagClose = false;
//
//   final bagOpenController = TextEditingController();
//   final bagCloseController = TextEditingController();
//
//   String _scanBarcode = 'Unknown';
//
//   scanBarcodeNormal() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.BARCODE);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     if (!mounted) return;
//
//     if (barcodeScanRes.length == 13 &&
//         barcodeScanRes.startsWith('R', 0) &&
//         barcodeScanRes.startsWith('I', 11) &&
//         barcodeScanRes.endsWith('N')) {
//       setState(() {
//         bagOpenController.text = barcodeScanRes;
//       });
//     }
//
//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.kBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: ColorConstants.kPrimaryColor,
//         title: Text(
//           'DARPAN',
//           style: TextStyle(letterSpacing: 2),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//
//               //Heading Row
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           mails = true;
//                           banking = false;
//                           insurance = false;
//                           booking = false;
//                           savingsBank = false;
//                           bagging = false;
//                           bagOpen = false;
//                           bagClose = false;
//                         });
//                       },
//                       child: HomeCard(
//                         backgroundColor: mails == true ? Colors.redAccent : Colors.white,
//                         title: heading[0],
//                         textColor: mails == true ? Colors.white : Colors.black,
//                         image: headingImages[0],
//                       )),
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           mails = false;
//                           banking = true;
//                           insurance = false;
//                           booking = false;
//                           savingsBank = false;
//                           bagging = false;
//                           bagOpen = false;
//                           bagClose = false;
//                         });
//                       },
//                       child: HomeCard(
//                         backgroundColor:
//                             banking == true ? Colors.redAccent : Colors.white,
//                         title: heading[1],
//                         textColor: banking == true ? Colors.white : Colors.black,
//                         image: headingImages[1],
//                       )),
//                   GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           mails = false;
//                           banking = false;
//                           insurance = true;
//                           booking = false;
//                           savingsBank = false;
//                           bagging = false;
//                           bagOpen = false;
//                           bagClose = false;
//                         });
//                       },
//                       child: HomeCard(
//                         backgroundColor:
//                             insurance == true ? Colors.redAccent : Colors.white,
//                         title: heading[2],
//                         textColor: insurance == true ? Colors.white : Colors.black,
//                         image: headingImages[2],
//                       )),
//                 ],
//               ),
//
//               //Sub Heading Row1
//               Visibility(
//                   visible: mails,
//                   child: Column(
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.0.w.toDouble(),
//                                 top: 25.h.toDouble(),
//                                 bottom: 10.h.toDouble()),
//                             child: Text(
//                               heading[0],
//                               style: TextStyle(
//                                   fontSize: 20.sp.toDouble(),
//                                   letterSpacing: 2,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black54),
//                             ),
//                           )),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   booking = true;
//                                   delivery = false;
//                                   bagging = false;
//                                   bagOpen = false;
//                                   bagClose = false;
//                                 });
//                               },
//                               child: HomeCard(
//                                 backgroundColor:
//                                     booking == true ? Colors.redAccent : Colors.white,
//                                 title: mailOptions[0],
//                                 textColor: booking == true ? Colors.white : Colors.black,
//                                 image: mailOptionsImages[0],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   booking = false;
//                                   delivery = true;
//                                   bagging = false;
//                                   bagOpen = false;
//                                   bagClose = false;
//                                 });
//                               },
//                               child: HomeCard(
//                                 backgroundColor:
//                                     delivery == true ? Colors.redAccent : Colors.white,
//                                 title: mailOptions[1],
//                                 textColor: delivery == true ? Colors.white : Colors.black,
//                                 image: mailOptionsImages[1],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   booking = false;
//                                   delivery = false;
//                                   bagging = true;
//                                   bagOpen = false;
//                                   bagClose = false;
//                                 });
//                               },
//                               child: HomeCard(
//                                 backgroundColor:
//                                     bagging == true ? Colors.redAccent : Colors.white,
//                                 title: mailOptions[2],
//                                 textColor: bagging == true ? Colors.white : Colors.black,
//                                 image: mailOptionsImages[2],
//                               )),
//                         ],
//                       ),
//                     ],
//                   )),
//               Visibility(
//                   visible: banking,
//                   child: Column(
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.0.w.toDouble(),
//                                 top: 25.h.toDouble(),
//                                 bottom: 10.h.toDouble()),
//                             child: Text(
//                               heading[1],
//                               style: TextStyle(
//                                   fontSize: 20.sp.toDouble(),
//                                   letterSpacing: 2,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black54),
//                             ),
//                           )),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     savingsBank = true;
//                                     bagOpen = false;
//                                     bagClose = false;
//                                   });
//                                 },
//                                 child: HomeCard(
//                                   backgroundColor: savingsBank == true
//                                       ? Colors.redAccent
//                                       : Colors.white,
//                                   title: bankingOptions[0],
//                                   textColor:
//                                       savingsBank == true ? Colors.white : Colors.black,
//                                   image: 'assets/images/bank.png',
//                                 )),
//                             GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     savingsBank = false;
//                                     bagOpen = false;
//                                     bagClose = false;
//                                   });
//                                 },
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: bankingOptions[1],
//                                   textColor: Colors.black,
//                                   image: 'assets/images/bank.png',
//                                 )),
//                             GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     savingsBank = false;
//                                     bagOpen = false;
//                                     bagClose = false;
//                                   });
//                                 },
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: bankingOptions[2],
//                                   textColor: Colors.black,
//                                   image: 'assets/images/bank.png',
//                                 )),
//                             GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     savingsBank = false;
//                                     bagOpen = false;
//                                     bagClose = false;
//                                   });
//                                 },
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: bankingOptions[3],
//                                   textColor: Colors.black,
//                                   image: 'assets/images/bank.png',
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//               Visibility(
//                   visible: insurance,
//                   child: Column(
//                 children: [
//                   Align(
//                       alignment: Alignment.topLeft,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             left: 20.0.w.toDouble(),
//                             top: 25.h.toDouble(),
//                             bottom: 10.h.toDouble()),
//                         child: Text(
//                           heading[2],
//                           style: TextStyle(
//                               fontSize: 20.sp.toDouble(),
//                               letterSpacing: 2,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black54),
//                         ),
//                       )),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       GestureDetector(
//                           onTap: () {},
//                           child: HomeCard(
//                             backgroundColor: Colors.white,
//                             title: insuranceOptions[0],
//                             textColor: Colors.black,
//                             image: insuranceOptionsImages[0],
//                           )),
//                       GestureDetector(
//                           onTap: () {},
//                           child: HomeCard(
//                             backgroundColor: Colors.white,
//                             title: insuranceOptions[1],
//                             textColor: Colors.black,
//                             image: insuranceOptionsImages[1],
//                           )),
//                     ],
//                   ),
//                 ],
//               )),
//
//               //Sub Heading Row2
//
//               //Booking
//               Visibility(
//                 visible: booking,
//                 child: Column(
//                   children: [
//                     Align(
//                         alignment: Alignment.topLeft,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               left: 20.0.w.toDouble(),
//                               top: 25.h.toDouble(),
//                               bottom: 10.h.toDouble()),
//                           child: Text(
//                             mailOptions[0],
//                             style: TextStyle(
//                                 fontSize: 20.sp.toDouble(),
//                                 letterSpacing: 2,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.black54),
//                           ),
//                         )),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => RegisterLetterBookingScreen1(fees: 17,)));
//                               },
//                               child: HomeCard(
//                                 backgroundColor: Colors.white,
//                                 title: bookingOptions[0],
//                                 textColor: Colors.black,
//                                 image: bookingOptionsImages[0],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (_) => SpeedPostScreen()));
//                               },
//                               child: HomeCard(
//                                 backgroundColor: Colors.white,
//                                 title: bookingOptions[1],
//                                 textColor: Colors.black,
//                                 image: bookingOptionsImages[1],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (_) => EMOMainScreen()));
//                               },
//                               child: HomeCard(
//                                 backgroundColor: Colors.white,
//                                 title: bookingOptions[2],
//                                 textColor: Colors.black,
//                                 image: bookingOptionsImages[2],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => ParcelBookingScreen()));
//                               },
//                               child: HomeCard(
//                                 backgroundColor: Colors.white,
//                                 title: bookingOptions[3],
//                                 textColor: Colors.black,
//                                 image: bookingOptionsImages[3],
//                               )),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )),
//               //Delivery
//               Visibility(
//                   visible: delivery,
//                   child: Column(
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.0.w.toDouble(),
//                                 top: 25.h.toDouble(),
//                                 bottom: 10.h.toDouble()),
//                             child: Text(
//                               mailOptions[1],
//                               style: TextStyle(
//                                   fontSize: 20.sp.toDouble(),
//                                   letterSpacing: 2,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black54),
//                             ),
//                           )),
//                       SingleChildScrollView(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                                 onTap: () {},
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: deliveryOptions[0],
//                                   textColor: Colors.black,
//                                   image: deliveryOptionsImages[0],
//                                 )),
//                             GestureDetector(
//                                 onTap: () {},
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: deliveryOptions[1],
//                                   textColor: Colors.black,
//                                   image: deliveryOptionsImages[1],
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//               //Bagging
//               Visibility(
//                   visible: bagging,
//                   child: Column(
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.0.w.toDouble(),
//                                 top: 25.h.toDouble(),
//                                 bottom: 10.h.toDouble()),
//                             child: Text(
//                               mailOptions[2],
//                               style: TextStyle(
//                                   fontSize: 20.sp.toDouble(),
//                                   letterSpacing: 2,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black54),
//                             ),
//                           )),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   bagOpen = true;
//                                   bagClose = false;
//                                 });
//                               },
//                               child: HomeCard(
//                                 backgroundColor:
//                                     bagOpen == true ? Colors.redAccent : Colors.white,
//                                 title: baggingOptions[0],
//                                 textColor: bagOpen == true ? Colors.white : Colors.black,
//                                 image: baggingOptionsImages[0],
//                               )),
//                           GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   bagOpen = false;
//                                   bagClose = true;
//                                 });
//                               },
//                               child: HomeCard(
//                                 backgroundColor:
//                                     bagClose == true ? Colors.redAccent : Colors.white,
//                                 title: baggingOptions[1],
//                                 textColor: bagClose == true ? Colors.white : Colors.black,
//                                 image: baggingOptionsImages[1],
//                               )),
//                         ],
//                       ),
//                     ],
//                   )),
//               //Savings Bank
//               Visibility(
//                   visible: savingsBank,
//                   child: Column(
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left: 20.0.w.toDouble(),
//                                 top: 25.h.toDouble(),
//                                 bottom: 10.h.toDouble()),
//                             child: Text(
//                               bankingOptions[0],
//                               style: TextStyle(
//                                   fontSize: 20.sp.toDouble(),
//                                   letterSpacing: 2,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black54),
//                             ),
//                           )),
//                       SingleChildScrollView(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                                 onTap: () {},
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: savingsBankOptions[0],
//                                   textColor: Colors.black,
//                                   image: savingsBankOptionsImages[0],
//                                 )),
//                             GestureDetector(
//                                 onTap: () {},
//                                 child: HomeCard(
//                                   backgroundColor: Colors.white,
//                                   title: savingsBankOptions[1],
//                                   textColor: Colors.black,
//                                   image: savingsBankOptionsImages[1],
//                                 )),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//
//               //Sub Heading Row3
//               Visibility(
//                 visible: bagOpen,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 40.w.toDouble(), vertical: 20.h.toDouble()),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         focusNode: null,
//                         maxLength: 13,
//                         controller: bagOpenController,
//                         style: TextStyle(color: ColorConstants.kSecondaryColor),
//                         textCapitalization: TextCapitalization.characters,
//                         keyboardType: TextInputType.text,
//                         decoration: InputDecoration(
//                             counterText: '',
//                             fillColor: ColorConstants.kWhite,
//                             filled: true,
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: ColorConstants.kWhite),
//                             ),
//                             prefixIcon: Container(
//                                 padding: EdgeInsets.symmetric(vertical: 5.h.toDouble()),
//                                 margin: EdgeInsets.only(right: 8.0.w.toDouble()),
//                                 decoration: BoxDecoration(
//                                   color: ColorConstants.kSecondaryColor,
//                                 ),
//                                 child: IconButton(
//                                   onPressed: scanBarcodeNormal,
//                                   icon: Icon(
//                                     MdiIcons.barcodeScan,
//                                     color: ColorConstants.kWhite,
//                                   ),
//                                 )),
//                             suffixIcon: bagOpenController.text.isNotEmpty
//                                 ? IconButton(
//                                     icon: Icon(
//                                       MdiIcons.closeCircleOutline,
//                                       color: ColorConstants.kSecondaryColor,
//                                     ),
//                                     onPressed: () {
//                                       bagOpenController.clear();
//                                       FocusScope.of(context).unfocus();
//                                     },
//                                   )
//                                 : null,
//                             labelStyle:
//                                 TextStyle(color: ColorConstants.kAmberAccentColor),
//                             labelText: 'Bag Number',
//                             contentPadding: EdgeInsets.all(15.0.w.toDouble()),
//                             isDense: true,
//                             // border: InputBorder.none
//
//                             border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: ColorConstants.kWhite),
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20.0.w.toDouble()),
//                                   bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                 )),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: ColorConstants.kWhite),
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20.0.w.toDouble()),
//                                   bottomLeft: Radius.circular(30.0.w.toDouble()),
//                                 ))),
//                         validator: (text) {
//                           if (text!.length != 13)
//                             return 'Article length should be of 13 characters';
//                           else if (!text.startsWith('L', 0))
//                             return 'Should start with LBK';
//                           else if (!text.startsWith('B', 1))
//                             return 'Should start with LBK';
//                           else if (!text.startsWith('K', 2))
//                             return 'Should start with LBK';
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         width: 10.w.toDouble(),
//                       ),
//                       Button(
//                           buttonText: 'Bag Open',
//                           buttonFunction: () {
//                             if (bagOpenController.text.isEmpty)
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text('Enter the Bag Number'),
//                                 behavior: SnackBarBehavior.floating,
//                               ));
//                             else if (bagOpenController.text.length != 13 ||
//                                 !bagOpenController.text.startsWith('L', 0) ||
//                                 !bagOpenController.text.startsWith('B', 1) ||
//                                 !bagOpenController.text.startsWith('K', 2)) {
//                             } else {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (_) => BagOpenScreen()));
//                             }
//                           })
//                     ],
//                   ),
//                 )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
