// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Widgets/AppAppBarWithoutWallet.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class BagScannedDetailsScreen extends StatefulWidget {
//   final String title;
//   final List list;
//
//   const BagScannedDetailsScreen(
//       {Key? key, required this.title, required this.list})
//       : super(key: key);
//
//   @override
//   State<BagScannedDetailsScreen> createState() =>
//       _BagScannedDetailsScreenState();
// }
//
// class _BagScannedDetailsScreenState extends State<BagScannedDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.kBackgroundColor,
//       appBar: AppAppBarWithoutWallet(
//         title: widget.title,
//       ),
//       body: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: widget.list.isNotEmpty
//               ? ListView.builder(
//                   itemCount: widget.list.length,
//                   itemBuilder: (ctx, index) {
//                     return Padding(
//                       padding: EdgeInsets.all(4.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                                   width: 30, child: Text('${index + 1}.')),
//                               const SizedBox(width: 10),
//                               Text(
//                                 '${widget.list[index]}',
//                                 style: const TextStyle(
//                                     letterSpacing: 2,
//                                     color: ColorConstants.kTextDark,
//                                     fontWeight: FontWeight.w500),
//                               )
//                             ],
//                           ),
//                           const Divider()
//                         ],
//                       ),
//                     );
//                   })
//               : Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.mark_email_unread_outlined,
//                         size: 50.toDouble(),
//                         color: ColorConstants.kTextColor,
//                       ),
//                       const Text(
//                         'No Records found',
//                         style: TextStyle(
//                             letterSpacing: 2, color: ColorConstants.kTextColor),
//                       ),
//                     ],
//                   ),
//                 )),
//     );
//   }
// }
