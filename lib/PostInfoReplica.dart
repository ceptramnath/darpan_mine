// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_ba Ercode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagCreateScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagDispatchScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagReceiveScreen.dart';
// import 'package:darpan_mine/Mails/Bagging/Screens/BagTrackingScreen.dart';
// import 'package:darpan_mine/Widgets/PostInfoCard.dart';
//
// import 'Constants/Fees.dart';
// import 'Constants/Texts.dart';
// import 'Mails/Bagging/Screens/BagCloseScreen.dart';
// import 'Mails/Bagging/Screens/BagInfoScreen.dart';
// import 'Mails/Bagging/Screens/BagOpenScreen.dart';
// import 'Mails/Booking/EMO/Screens/EMOMainScreen.dart';
// import 'Mails/Booking/Parcel/Screens/ParcelBookingScreen.dart';
// import 'Mails/Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';
// import 'Mails/Booking/SpeedPost/Screens/SpeedPostScreen.dart';
// import 'Mails/Booking/Transactions/TransactionScreen.dart';
//
//
// class PostInfoReplicaHomeScreen extends StatefulWidget {
//   const PostInfoReplicaHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _PostInfoReplicaHomeScreenState createState() => _PostInfoReplicaHomeScreenState();
// }
//
// class _PostInfoReplicaHomeScreenState extends State<PostInfoReplicaHomeScreen> {
//
//   var fees;
//
//
//   @override
//   void initState() {
//     getFees();
//     super.initState();
//   }
//
//   getFees() async {
//     var rlFees = await Fees().getRegistrationFees('LETTER');
//     setState(() {
//       fees = rlFees;
//     });
//   }
//
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
//   String _scanBarcode = 'Unknown';
//
//   final bagOpenController = TextEditingController();
//   final bagCloseController = TextEditingController();
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
//       backgroundColor: ColorConstants.kPrimaryColor,
//       body: SafeArea(
//         child: ListView(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 15.h.toDouble()),
//             ),
//             Container(
//               height: 75.h,
//               child: Card(
//                 elevation: 10.h,
//                 color: ColorConstants.kPrimaryColor,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Expanded(
//                       flex: MediaQuery.of(context).orientation == Orientation.landscape
//                           ? 1
//                           : 2,
//                       child: Image.asset(
//                         'assets/images/Indiapost_logo.png',
//                         width: 80.w,
//                         fit: BoxFit.fitHeight,
//                       ),
//                     ),
//                     Expanded(
//                         flex: 4,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               'Department of Posts',
//                               style: TextStyle(
//                                   //fontSize: 15.0,
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white),
//                             ),
//                             Text(
//                               'Ministry of Communications',
//                               style: TextStyle(fontSize: 12.sp, color: Colors.white),
//                             ),
//                             Text(
//                               'Government of India',
//                               style: TextStyle(fontSize: 10.sp, color: Colors.white),
//                             )
//                           ],
//                         )),
//                     Expanded(
//                       flex: 1,
//                       child: Image.asset(
//                         'assets/images/emblem.png',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Container(
//               height: MediaQuery.of(context).orientation == Orientation.portrait
//                   ? MediaQuery.of(context).size.height - 145.h
//                   : MediaQuery.of(context).size.height - 125.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(75.w),
//                   topRight: Radius.circular(2.w),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: MediaQuery.of(context).size.height > 900 ? 14.w : 14.w),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(75.w),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 25.h),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Column(
//                         children: [
//
//                           Container(
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 18.0),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                   children: [
//                                     GestureDetector(
//                                         onTap: (){
//                                           setState(() {
//                                             mails = true;
//                                             banking = false;
//                                             insurance = false;
//                                             booking = false;
//                                             savingsBank = false;
//                                             delivery = false;
//                                             bagging = false;
//                                             bagOpen = false;
//                                             bagClose = false;
//                                           });
//                                         },
//                                         child: PostInfoCard(title: 'Mails', image: 'assets/images/mails.png')),
//                                     GestureDetector(
//                                         onTap: (){
//                                           setState(() {
//                                             mails = false;
//                                             banking = true;
//                                             insurance = false;
//                                             booking = false;
//                                             savingsBank = false;
//                                             delivery = false;
//                                             bagging = false;
//                                             bagOpen = false;
//                                             bagClose = false;
//                                           });
//                                         },
//                                         child: PostInfoCard(title: 'Banking', image: 'assets/images/bank.png')),
//                                     GestureDetector(
//                                         onTap: (){
//                                           setState(() {
//                                             mails = false;
//                                             banking = false;
//                                             insurance = true;
//                                             booking = false;
//                                             savingsBank = false;
//                                             delivery = false;
//                                             bagging = false;
//                                             bagOpen = false;
//                                             bagClose = false;
//                                           });
//                                         },
//                                         child: PostInfoCard(title: 'insurance', image: 'assets/images/insurance.png')),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           Visibility(
//                             visible: mails,
//                             child: Container(
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(bottom: 18.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Align(
//                                           alignment: Alignment.topLeft,
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: 20.0.w.toDouble(),
//                                                 top: 25.h.toDouble(),
//                                                 bottom: 10.h.toDouble()),
//                                             child: Text(
//                                               heading[0],
//                                               style: TextStyle(
//                                                   fontSize: 20.sp.toDouble(),
//                                                   letterSpacing: 2,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.black54),
//                                             ),
//                                           )),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           GestureDetector(
//                                               onTap: (){
//                                                 setState(() {
//                                                   booking = true;
//                                                   delivery = false;
//                                                   bagging = false;
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                 });
//                                               },
//                                               child: PostInfoCard(title: mailOptions[0], image: mailOptionsImages[0])),
//                                           GestureDetector(
//                                               onTap: (){
//                                                 setState(() {
//                                                   booking = false;
//                                                   delivery = true;
//                                                   bagging = false;
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                 });
//                                               },
//                                               child: PostInfoCard(title: mailOptions[1], image: mailOptionsImages[1])),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   booking = false;
//                                                   delivery = false;
//                                                   bagging = true;
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                 });
//                                               },
//                                               child: PostInfoCard(title: mailOptions[2], image: mailOptionsImages[2])),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Visibility(
//                               visible: banking,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           heading[1],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   Container(
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(bottom: 15.0),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                           children: [
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     savingsBank = true;
//                                                     bagOpen = false;
//                                                     bagClose = false;
//                                                   });
//                                                 },
//                                                 child: PostInfoCard(
//                                                   title: bankingOptions[0],
//                                                   image: bankingOptionsImages[0],
//                                                 )),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     savingsBank = false;
//                                                     bagOpen = false;
//                                                     bagClose = false;
//                                                   });
//                                                 },
//                                                 child: PostInfoCard(title: bankingOptions[1], image: bankingOptionsImages[0])),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     savingsBank = false;
//                                                     bagOpen = false;
//                                                     bagClose = false;
//                                                   });
//                                                 },
//                                                 child: PostInfoCard(title: bankingOptions[2], image: bankingOptionsImages[0])),
//                                             GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     savingsBank = false;
//                                                     bagOpen = false;
//                                                     bagClose = false;
//                                                   });
//                                                 },
//                                                 child: PostInfoCard(title: bankingOptions[3], image: bankingOptionsImages[0])),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           Visibility(
//                               visible: insurance,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           heading[2],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(bottom: 18.0.h),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           GestureDetector(
//                                               onTap: () {},
//                                               child: PostInfoCard(
//                                                 title: insuranceOptions[0],
//                                                 image: insuranceOptionsImages[0],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {},
//                                               child:  PostInfoCard(
//                                                 title: insuranceOptions[1],
//                                                 image: insuranceOptionsImages[1],
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//
//                           //Booking
//                           Visibility(
//                               visible: booking,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           mailOptions[0],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(bottom: 18.0.h),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (_) => RegisterLetterBookingScreen1(fee: fees,)));
//                                               },
//                                               child: PostInfoCard(
//                                                 title: bookingOptions[0],
//                                                 image: bookingOptionsImages[0],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(context,
//                                                     MaterialPageRoute(builder: (_) => SpeedPostScreen()));
//                                               },
//                                               child: PostInfoCard(
//                                                 title: bookingOptions[1],
//                                                 image: bookingOptionsImages[1],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(context,
//                                                     MaterialPageRoute(builder: (_) => EMOMainScreen()));
//                                               },
//                                               child: PostInfoCard(
//                                                 title: bookingOptions[2],
//                                                 image: bookingOptionsImages[2],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (_) => ParcelBookingScreen()));
//                                               },
//                                               child: PostInfoCard(
//                                                 title: bookingOptions[3],
//                                                 image: bookingOptionsImages[3],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                         builder: (_) => TransactionScreen()));
//                                               },
//                                               child: PostInfoCard(
//                                                 title: bookingOptions[4],
//                                                 image: bookingOptionsImages[4],
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           //Delivery
//                           Visibility(
//                               visible: delivery,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           mailOptions[1],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   SingleChildScrollView(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                       children: [
//                                         GestureDetector(
//                                             onTap: () {},
//                                             child: PostInfoCard(
//                                               title: deliveryOptions[0],
//                                               image: deliveryOptionsImages[0],
//                                             )),
//                                         GestureDetector(
//                                             onTap: () {},
//                                             child: PostInfoCard(
//                                               title: deliveryOptions[1],
//                                               image: deliveryOptionsImages[1],
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           //Bagging
//                           Visibility(
//                               visible: bagging,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           mailOptions[2],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   SingleChildScrollView(
//                                     scrollDirection: Axis.horizontal,
//                                     child: Padding(
//                                       padding: EdgeInsets.only(bottom: 18.0.h),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagReceiveScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[0],
//                                                 image: baggingOptionsImages[0],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagOpenScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[1],
//                                                 image: baggingOptionsImages[1],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagCreateScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[2],
//                                                 image: baggingOptionsImages[2],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagCloseScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[3],
//                                                 image: baggingOptionsImages[3],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagDispatchScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[4],
//                                                 image: baggingOptionsImages[4],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagInfoScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[5],
//                                                 image: baggingOptionsImages[5],
//                                               )),
//                                           GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   bagOpen = false;
//                                                   bagClose = false;
//                                                   Navigator.push(context, MaterialPageRoute(builder: (_) => BagTrackingScreen()));
//                                                 });
//                                               },
//                                               child: PostInfoCard(
//                                                 title: baggingOptions[6],
//                                                 image: baggingOptionsImages[6],
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )),
//                           //Savings Bank
//                           Visibility(
//                               visible: savingsBank,
//                               child: Column(
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: 20.0.w.toDouble(),
//                                             top: 25.h.toDouble(),
//                                             bottom: 10.h.toDouble()),
//                                         child: Text(
//                                           bankingOptions[0],
//                                           style: TextStyle(
//                                               fontSize: 20.sp.toDouble(),
//                                               letterSpacing: 2,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.black54),
//                                         ),
//                                       )),
//                                   SingleChildScrollView(
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                       children: [
//                                         GestureDetector(
//                                             onTap: () {},
//                                             child: PostInfoCard(
//                                               title: savingsBankOptions[0],
//                                               image: savingsBankOptionsImages[0],
//                                             )),
//                                         GestureDetector(
//                                             onTap: () {},
//                                             child: PostInfoCard(
//                                               title: savingsBankOptions[1],
//                                               image: savingsBankOptionsImages[1],
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               )),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
