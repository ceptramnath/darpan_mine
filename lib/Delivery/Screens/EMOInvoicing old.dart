// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Delivery/Screens/EMOInvoicingCard.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:zxing_scanner/zxing_scanner.dart' as scanner;
// import 'DeliveryScreen.dart';
// import 'EMOCard.dart';
// import 'Styles/NeuromorphicBox.dart';
// import 'db/ArticleModel.dart';
// import 'db/DarpanDBModel.dart';
//
// class EMOInvoicingScreen extends StatefulWidget {
//   @override
//   _EMOInvoicingScreenState createState() => _EMOInvoicingScreenState();
// }
//
// class _EMOInvoicingScreenState extends State<EMOInvoicingScreen> {
//   late String barcodeScanRes;
//   Future? getDetails;
//   List<EMOTable> emoarticles=[];
//   List<Delivery> _articlesToDisplay=[];
//   List<Delivery> mainArticles=[];
//   List<Addres> _address=[];
//   List<Addres> _addressToDisplay=[];
//   bool artvisible=true;
//   @override
//   void initState(){
//     getDetails=getList();
//   }
//
//   db() async{
//     print("Reached DB in EMO");
//     emoarticles=await EMOTable().select().toList();
//     print("EMO ARTICLS TABLE: ");
//     if(emoarticles.length>0)
//     print(emoarticles[0].artNo);
//     return emoarticles.length;
//   }
//   getList() async{
//     emoarticles.clear();
//     mainArticles.clear();
//     _articlesToDisplay.clear();
//     print("Calling DB");
//      await db();
//     print(emoarticles.length);
//     for(int i=0;i<emoarticles.length;i++){
//       mainArticles=await Delivery().select().articleNumber.equals(emoarticles[i].artNo).toList();
//       // print(mainArticles[i].articleNumber);
//       _articlesToDisplay.add(mainArticles[0]);
//     }
//     print("ArticlesToDisplay:");
//     for(int i=0;i<_articlesToDisplay.length;i++)
//     print(_articlesToDisplay[i].articleNumber);
//
//     for(int i=0;i<_articlesToDisplay.length;i++){
//       // print(_articlesToDisplay[i].articleNumber);
//       _address=await Addres().select().articleNumber.equals(_articlesToDisplay[i].articleNumber).toList();
//       // print(_address[0].articleNumber);
//       _addressToDisplay.add(_address[0]);
//     }
//     return _articlesToDisplay.length;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         bool? result = await _onBackPressed();
//         result ??= false;
//         return result;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () => Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => DeliveryScreen()),
//                 (route) => false),
//           ),
//           title: Text("EMO Invoicing"),
//           backgroundColor: ColorConstants.kPrimaryColor,
//         ),
//         body: FutureBuilder(
//         future: getDetails,
//         builder: (BuildContext context, AsyncSnapshot snapshot){
//           if (snapshot.data == null) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           else{
//             return SafeArea(
//               child: ListView(
//                 children: <Widget>[
//                   const Padding(
//                     padding: EdgeInsets.only(top: 5),
//                   ),
//                   Container(
//                     height:
//                     MediaQuery.of(context).orientation == Orientation.portrait
//                         ? MediaQuery.of(context).size.height - 125
//                         : MediaQuery.of(context).size.height - 125,
//                     decoration: const BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(75),
//                         topRight: Radius.circular(2),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           left:
//                           MediaQuery.of(context).size.height > 900 ? 14 : 14),
//                       child: Container(
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(75),
//                             ),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 15),
//                             child: Visibility(
//                               visible: artvisible,
//                               child: Container(
//                                   width: MediaQuery.of(context).size.width,
//                                   height:
//                                   MediaQuery.of(context).size.height * 0.80,
//                                   child:_articlesToDisplay.length>0?
//                                   ListView.builder(
//                                       itemCount: _articlesToDisplay.length+1,
//                                       itemBuilder: (context, index) {
//                                         return index == 0
//                                             ? Container()
//                                             : _listItem(index - 1);
//                                       }):Center(
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Icon(
//                                           Icons.mark_email_unread_outlined,
//                                           size: 50.w.toDouble(),
//                                           color: ColorConstants.kTextColor,
//                                         ),
//                                         const Text(
//                                           'No Records found',
//                                           style: TextStyle(
//                                               letterSpacing: 2, color: ColorConstants.kTextColor),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                               ),
//                             ),
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//         }
//         ),
//         floatingActionButton: new FloatingActionButton(
//             elevation: 0.0,
//             child: Icon(MdiIcons.barcodeScan),
//             backgroundColor: ColorConstants.kPrimaryColor,
//             onPressed: () async {
//               barcodeScanRes = await scanner.scan();
//
//               if (barcodeScanRes != "") {
//                 List<Delivery> scannedResponse = await Delivery()
//                     .select()
//                     .articleNumber
//                     .equals(barcodeScanRes)
//                     .toList();
//                 if (scannedResponse.length > 0) {
//                   setState(() {
//                     artvisible=false;
//                   });
//                   await EMOTable(artNo: barcodeScanRes).upsert();
//                   await getList();
//                   setState(() {
//                     artvisible=true;
//                   });
//                 } else {
//                   UtilFs.showToast("Article is not available", context);
//                 }
//               }
//             }),
//       ),
//     );
//   }
//
//   Future<bool>? _onBackPressed() {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => DeliveryScreen()),
//         (route) => false);
//   }
//
//   _listItem(index) {
//     // _articlesToDisplay[index].addresseeType==null? _articlesToDisplay[index].addresseeType="": _articlesToDisplay[index].addresseeType;
//     // return Column(
//     //   children: [
//     //     EMOInvoicingCard(
//     //       _articlesToDisplay[index].articleNumber!,
//     //       _articlesToDisplay[index].articleType!,
//     //       _articlesToDisplay[index].sourcepin!,
//     //       _articlesToDisplay[index].receiver!,
//     //       _articlesToDisplay[index].invoiceDate!,
//     //       _articlesToDisplay[index].invoiceTime!,
//     //       _articlesToDisplay[index].addresseeType!,
//     //       _articlesToDisplay[index].moneytodeliver!,
//     //     ),
//     //     Divider(),
//     //     Padding(
//     //       padding: const EdgeInsets.all(8.0),
//     //       child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//     //         children: [
//     //           RaisedButton.icon(
//     //               shape: RoundedRectangleBorder(
//     //                 borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
//     //               color: Colors.white70,
//     //               onPressed: () async{
//     //
//     //                 await ScannedArticle().select().articleNumber.equals(_articlesToDisplay[index].articleNumber).update({"invoicedDate":DateTimeDetails().onlyDate()});
//     //                 await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
//     //
//     //               },
//     //               icon: Icon(MdiIcons.check),
//     //               label:  Flexible(
//     //                 child: Text(
//     //                   'Accept',textAlign: TextAlign.center,
//     //                   //overflow: TextOverflow.ellipsis,
//     //                   style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
//     //                 ),
//     //               )
//     //           ),
//     //           RaisedButton.icon(
//     //               shape: RoundedRectangleBorder(
//     //                 borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
//     //               color: Colors.white70,
//     //               onPressed: () async{
//     //
//     //                 await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
//     //               },
//     //               icon: Icon(MdiIcons.cancel),
//     //               label:  Flexible(
//     //                 child: Text(
//     //                   'Reject',textAlign: TextAlign.center,
//     //                   //overflow: TextOverflow.ellipsis,
//     //                   style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
//     //                 ),
//     //               )
//     //           )
//     //         ],),
//     //     ),
//     //   ],
//     // );
//
//     _addressToDisplay[index].sendPin==null?_addressToDisplay[index].sendPin=110001:_addressToDisplay[index].sendPin;
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 10.h),
//       // padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: 1.h),
//       child: Container(
//         decoration: nCDBox,
//         child: Container(
//           decoration: nCIBox,
//           child: Padding(
//             padding: EdgeInsets.only(left: 20.0.w, right: 15.w, bottom: 10.h, top: 10.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Row(
//                         children: [
//                           Icon(
//                             MdiIcons.barcodeScan,
//                             color: Colors.blueGrey,
//                           ),
//                           SizedBox(
//                             width: 20.w,
//                           ),
//                           Flexible(child: Container(child: Text(_articlesToDisplay[index].articleNumber!, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: Colors.black54),))),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Text(
//                           'Article Type',
//                           style: TextStyle(color: Colors.black54, fontSize: 12.sp),
//                         ),
//                         Text(
//                           _articlesToDisplay[index].matnr!,
//                           style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 12.sp),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10.h,
//                 ),
//                 // Row(
//                 //   children: [
//                 //     Expanded(
//                 //       flex: 1,
//                 //       child: Icon(
//                 //         Icons.person_outline,
//                 //         color: Colors.blueGrey,
//                 //         size: 25.h,
//                 //       ),
//                 //     ),
//                 //     SizedBox(
//                 //       width: 20.w,
//                 //     ),
//                 //     Expanded(
//                 //       flex: 10,
//                 //       child: Text(
//                 //         addresseeName,
//                 //         style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 17.sp),
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: 10.0.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           "From: ${_addressToDisplay[index].sendPin.toString()}",
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
//                         ),
//                       ),
//                       SizedBox(width: 10.w,),
//                       Flexible(
//                           child: Icon(
//                               Icons.flight_takeoff
//                           )
//                       ),
//                       SizedBox(width: 20.w,),
//                       Flexible(
//                         child: Text(
//                           "To: ${_addressToDisplay[index].recName.toString()}",
//                           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//                 // Divider(),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 //   children: [
//                 //     FlatButton.icon(
//                 //         onPressed: cardNavigation,
//                 //         icon: Icon(
//                 //           Icons.remove_red_eye,
//                 //           color: Colors.blueGrey,
//                 //         ),
//                 //         label: Text(
//                 //           'View',
//                 //           style: TextStyle(color: Colors.blueGrey),
//                 //         )),
//                 //     FlatButton(
//                 //       onPressed: isListArticle ? null : () {
//                 //         Toast.show('This is a List Article', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
//                 //       },
//                 //       child: Icon(
//                 //         isListArticleIcon,
//                 //         color: Colors.blueGrey,
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: [
//                             Text("Amount to Deliver"),
//                             Text(_articlesToDisplay[index].totalMoney!.toString()),
//                           ],
//                         ),
//                       )
//                     ],),
//                 ),
//                 Divider(),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       RaisedButton.icon(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
//                           color: Colors.white70,
//                           onPressed: () async{
//
//                            var walletAmount = await CashService().cashBalance();
//                            if(walletAmount>_articlesToDisplay[index].totalMoney) {
//                              setState(() {
//                                artvisible=false;
//                              });
//                              await Delivery()
//                                  .select()
//                                  .articleNumber
//                                  .equals(
//                                  _articlesToDisplay[index].articleNumber)
//                                  .update(
//                                  {"invoiceDate": DateTimeDetails().onlyDate(),"moneycollected":int.parse('${_articlesToDisplay[index].totalMoney}')});
//                              await EMOTable()
//                                  .select()
//                                  .artNo
//                                  .equals(
//                                  _articlesToDisplay[index].articleNumber)
//                                  .delete();
//                              final addCash =  CashTable()
//                                ..Cash_ID = _articlesToDisplay[index].articleNumber!
//                                ..Cash_Date = DateTimeDetails().currentDate()
//                                ..Cash_Time = DateTimeDetails().onlyTime()
//                                ..Cash_Type = 'Add'
//                                ..Cash_Amount = int.parse('-${_articlesToDisplay[index].totalMoney}')
//                                ..Cash_Description = "EMO";
//                              await addCash.save();
//                              await getList();
//                              setState(() {
//                                artvisible = true;
//                              });
//                            }
//                            else{
//                              UtilFs.showToast("EMO cash is greater than cash avaialble in hand",context);
//                            }
//                             // setState(() {
//                             //   artvisible=true;
//                             // });
//                           },
//                           icon: Icon(MdiIcons.check),
//                           label:  Flexible(
//                             child: Text(
//                               'Accept',textAlign: TextAlign.center,
//                               //overflow: TextOverflow.ellipsis,
//                               style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
//                             ),
//                           )
//                       ),
//                       RaisedButton.icon(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey),),
//                           color: Colors.white70,
//                           onPressed: () async{
//                             setState(() {
//                               artvisible=false;
//                             });
//                             await EMOTable().select().artNo.equals(_articlesToDisplay[index].articleNumber).delete();
//                             await getList();
//                             setState(() {
//                               artvisible=true;
//                             });
//                           },
//                           icon: Icon(MdiIcons.cancel),
//                           label:  Flexible(
//                             child: Text(
//                               'Reject',textAlign: TextAlign.center,
//                               //overflow: TextOverflow.ellipsis,
//                               style: TextStyle(color: Colors.blueGrey,fontSize: 11.0),
//                             ),
//                           )
//                       )
//                     ],),
//                 ),
//
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
// }
