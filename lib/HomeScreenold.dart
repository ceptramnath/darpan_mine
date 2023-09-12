// import 'package:flutter/material.dart';
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
//     return Scaffold(
//       appBar: AppBar(title: const Text('RICT', textAlign: TextAlign.center,style: TextStyle(fontSize: 22,),),backgroundColor: Color(0xFFB71C1C),
//         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20) )),
//       ),
//       body: SafeArea(
//         child: ListView(
//           children: <Widget>[
//             const Padding(
//               padding: EdgeInsets.only(top: 5),
//             ),
//             Container(
//               height: MediaQuery.of(context).orientation ==
//                   Orientation.portrait ?MediaQuery.of(context).size.height - 125:MediaQuery.of(context).size.height - 125,
//               decoration: const BoxDecoration(
//                 //color:
//                 //Colors.white,
//                 //Colors.grey[300],
//                 borderRadius: BorderRadius.only(topLeft: Radius.circular(75),topRight: Radius.circular(2),),
//               ),
//               child:Padding(
//                 padding:  EdgeInsets.only(left: MediaQuery.of(context).size.height>900?14:14),
//                 child: Container(
//                     decoration: const BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(75),),
//                     ),
//
//                     child: Padding(
//                       padding:  EdgeInsets.only(top:15),
//
//                       child: GridView.count(
//                         childAspectRatio:1.29,
//                         crossAxisCount:MediaQuery.of(context).orientation ==Orientation.portrait? 2: 3,
//                         children: <Widget>[
//                           MyMenu(
//                             title: "Mails",
//                             img: "assets/images/mails.png",
//                             pos: 1,
//                             bgcolor: Colors.grey[300]!,
//                           ),
//
//                           MyMenu(
//                             title: "Banking",
//                             img: "assets/images/bank.png",
//                             pos: 2,
//                             bgcolor: Colors.grey[300]!,
//                           ),
//
//                           MyMenu(
//                             title: "insurance",
//                             img: "assets/images/insurance.png",
//                             pos: 3,
//                             bgcolor: Colors.grey[300]!,
//                           ),
//                         ],
//                       ),
//                     )
//
//                 ),
//               ),
//
//             ) ,
//           ],
//         ),
//       ),
//     );
//   }
//
// }
// class MyMenu extends StatelessWidget {
//   MyMenu({this.title, this.img, this.pos, this.bgcolor});
//   final String? title;
//   final Color? bgcolor;
//
//   final int? pos;
//   final String? img;
//   static const _kFontFam = 'MyHomePage';
//   static const _kFontPkg = null;
//   static const IconData ic_article_tracking = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.only(top:8,bottom: 8,left: 8,right: 8),
//       child:Container(
//
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(40)),
//           //color:
//           // Colors.white,
//           //Colors.grey[300],
//
//         ),
//
//         child: Container(
//
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(40)),
//             color: Colors.grey[300],
//           ),
//
//           child: Container(
//
//             child: Ink(
//               //color:Colors.red,
//               child: InkWell(
//                 //splashColor: Colors.red,
//                 onTap: () async{
//
//                   if(pos.toString()=='1') {
//                     Navigator.push(context,MaterialPageRoute(builder: (context) => MailsMainScreen()),);
//                   }
//                   if(pos.toString()=='2') {
//                     Navigator.push(context,MaterialPageRoute(builder: (context) => MyCardsScreen()),);
//                   }
//                   if(pos.toString()=='3') {
//                     Navigator.push(context,MaterialPageRoute(builder: (context) => UserPage()),);
//                   }
//                 },
//
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Image.asset(
//                         img!,
//                         width: 70,
//                         color:Color(0xFFB71C1C)
//
//                     ),
//                     Text(
//                         title!,textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             color: Color(0xFF984600),
//                             //  color: Colors.black,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600)),
//
//                   ],
//                 ),
//                 //),
//               ),
//             ),
//
//           ),
//         ),
//
//       ),
//
//     );
//     //)
//     //);
//   }
// }
