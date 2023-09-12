// import 'package:flutter/material.dart';
// import 'package:darpan_mine/vertical_card_pager.dart';
//
// import 'CBS/screens/my_cards_screen.dart';
// import 'package:darpan_mine/INSURANCE/HomeScreen/HomeScreen.dart';
//
// import 'Mails/MailsMainScreen.dart';
//
// class MainHomeScreen extends StatefulWidget {
//
//   @override
//   _MainHomeScreenState createState() => _MainHomeScreenState();
// }
//
// class _MainHomeScreenState extends State<MainHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final List<String> titles = ["Mails", "Banking", "Insurance"];
//     final List<Widget> images = [
//       Image.asset("assets/images/mails.png",color:Color(0xFFB71C1C),fit: BoxFit.contain,),
//       Image.asset("assets/images/bank.png",color:Color(0xFFB71C1C),fit: BoxFit.contain,),
//       Image.asset("assets/images/insurance.png",color:Color(0xFFB71C1C),fit: BoxFit.contain,),
//     ];
//
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//
//                 child: VerticalCardPager(
//                     titles: titles,  // required
//                     images: images,  // required
//                     textStyle: TextStyle(fontSize: 15,color: Color(0xFF984600), fontWeight: FontWeight.bold,), // optional
//                     onPageChanged: (page) { // optional
//                     },
//                     onSelectedItem: (index) { // optional
//                     },
//                     initialPage: 0, // optional
//                     align : ALIGN.CENTER // optional
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
//
// }
