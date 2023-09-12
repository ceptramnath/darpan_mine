//
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'DeliveryScreen.dart';
// import 'SaveScannedArticleScreen.dart';
// import 'Widgets/ArticleCard.dart';
// import 'db/ArticleModel.dart';
//
//
// class SpeedScreen extends StatefulWidget {
//   @override
//   _SpeedScreenState createState() => _SpeedScreenState();
// }
//
// class _SpeedScreenState extends State<SpeedScreen> {
//   List<ScannedArticle> _articlesToDisplay = [];
//   Future? getDetails;
//
//   @override
//   void initState(){
//     getDetails=db();
//   }
//
//   db() async{
//     print("Reached db");
//
//     _articlesToDisplay=await ScannedArticle().select().articleType.startsWith("S").and.articleStatus.equalsOrNull("").toList();
//     // _articlesToDisplay=await ScannedArticle().select().articleNumber.startsWith([0-9]).toList();
//     print(_articlesToDisplay.length);
//     for(int i=0;i<_articlesToDisplay.length;i++){
//       print(_articlesToDisplay[i].articleNumber);
//     }
//     return _articlesToDisplay.length;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           bool? result = await _onBackPressed();
//           result ??= false;
//           return result;
//         },
//         child: Scaffold(
//             appBar: AppBar(
//               leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DeliveryScreen()), (route) => false),),
//               title: Text("Speed"),
//               backgroundColor: ColorConstants.kPrimaryColor,
//             ),
//             body: FutureBuilder(
//               future: getDetails,
//               builder: (BuildContext context, AsyncSnapshot snapshot){
//                 if (snapshot.data == null) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 else{
//                   return SafeArea(
//                     child: ListView(
//                       children: <Widget>[
//                         const Padding(
//                           padding: EdgeInsets.only(top: 5),
//                         ),
//                         Container(
//                           height:
//                           MediaQuery.of(context).orientation == Orientation.portrait
//                               ? MediaQuery.of(context).size.height - 125
//                               : MediaQuery.of(context).size.height - 125,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(75),
//                               topRight: Radius.circular(2),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(
//                                 left:
//                                 MediaQuery.of(context).size.height > 900 ? 14 : 14),
//                             child: Container(
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(75),
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.only(top: 15),
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height:
//                                     MediaQuery.of(context).size.height * 0.80,
//                                     child:_articlesToDisplay.length>0?
//
//                                     ListView.builder(
//                                         itemCount: _articlesToDisplay.length+1,
//                                         itemBuilder: (context, index) {
//                                           return index == 0
//                                               ? Container()
//                                               // : _listItem(index - 1);
//                                           :Text("");
//                                         }):Center(
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.mark_email_unread_outlined,
//                                             size: 50.w.toDouble(),
//                                             color: ColorConstants.kTextColor,
//                                           ),
//                                           const Text(
//                                             'No Records found',
//                                             style: TextStyle(
//                                                 letterSpacing: 2, color: ColorConstants.kTextColor),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             )
//
//
//
//         ));
//   }
//
//   Future<bool>? _onBackPressed() {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => DeliveryScreen()),
//             (route) => false);
//   }
//
//   remarkText(String? reasonCode) {
//     if (reasonCode == "8")
//       return 'Addressee Absent';
//     else if (reasonCode == "7")
//       return 'Addressee cannot be located';
//     else if (reasonCode == "11")
//       return 'Addressee left without Instructions';
//     else if (reasonCode == "2")
//       return 'Addressee Moved';
//     else if (reasonCode == "19")
//       return 'Beat Change';
//     else if (reasonCode == "18")
//       return 'Deceased';
//     else if (reasonCode == "1")
//       return 'Door locked';
//     else if (reasonCode == "6")
//       return 'Insufficient Address';
//     else if(reasonCode=='40')
//       return 'Recalled';
//     else if (reasonCode == "14")
//       return 'No such persons in the address';
//     else if (reasonCode == "9") return 'Refused';
//   }
//
//   // _listItem(index) {
//   //   _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
//   //   return GestureDetector(
//   //     onTap: () async{
//   //       Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(builder: (context) => SaveScannedArticleScreen(3, _articlesToDisplay[index].articleNumber!, "Speed Post",_articlesToDisplay[index].addressee,
//   //               _articlesToDisplay[index].cod!,
//   //               _articlesToDisplay[index].vpp!,
//   //               _articlesToDisplay[index].moneytocollect!)),
//   //               (route) => false);
//   //     },
//   //     child: ArticleCard(
//   //       _articlesToDisplay[index].articleNumber!,
//   //       _articlesToDisplay[index].articleType!,
//   //       _articlesToDisplay[index].reasonCode == null ? 'Delivered to ${_articlesToDisplay[index].deliveredTo}' : remarkText(_articlesToDisplay[index].reasonCode),
//   //       _articlesToDisplay[index].reasonCode == null ? Colors.blueGrey : Color(0xFF990000),
//   //       _articlesToDisplay[index].invoiceDate!,
//   //       _articlesToDisplay[index].invoiceTime!,
//   //       _articlesToDisplay[index].addresseeType!,
//   //       _articlesToDisplay[index].sourcepin!,
//   //       _articlesToDisplay[index].receiver!,
//   //     ),
//   //   );
//   // }
// }
