//
//
// import 'package:flutter/material.dart';
// import 'package:darpan_mine/INSURANCE/ScreenUtils/size_extension.dart';
//
// class HomeCard extends StatefulWidget {
//   final String? cardName;
//   final String? cardImage;
//
//   Widget Function()? cardNavigation;
//
//   HomeCard({this.cardName, this.cardImage, this.cardNavigation});
//
//   @override
//   _HomeCardState createState() => _HomeCardState();
// }
//
// class _HomeCardState extends State<HomeCard> {
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//       return GestureDetector(
//         onTap: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (_) => widget.cardNavigation()));
//         },
//         child: Container(
//           margin: EdgeInsets.all(10.w),
//           decoration: nCDBox,
//           child: Container(
//             decoration: nCIBox,
//             child: Padding(
//               //padding: EdgeInsets.all(18.w),
//               padding:EdgeInsets.only(top:12.h,left:18.w,right:18.w,bottom: 1.w),
//               child: Column(
//                 children: [
//                   Expanded(
//                       flex: 3,
//                       child: Image.asset(widget.cardImage,
//                           fit: BoxFit.contain, color: Color(0xFFCC0000))),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   Expanded(
//                       flex: 2,
//                       child: Padding(
//                         padding: EdgeInsets.only(top: 2.0.h),
//                         child: Text(
//                           widget.cardName,
//                           style: TextStyle(
//                               color: Colors.black54,
//                               fontWeight: FontWeight.w500),
//                           textAlign: TextAlign.center,
//                         ),
//                       ))
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//   }
// }
