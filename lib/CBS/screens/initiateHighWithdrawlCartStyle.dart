//
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:flutter/material.dart';
//
// import '../../HomeScreen.dart';
// import 'my_cards_screen.dart';
// class HighCashWithdrawlAmount extends StatefulWidget {
//   String? tran_Id;
//   String? TRANSACTION_AMT;
//   String? tran_Date;
//   String? tran_Time;
//   String? cus_Acct_Num;
//   String? acct_Type;
//   String? remarks;
//   String? balAftTrn;
//   HighCashWithdrawlAmount(this.tran_Id,this.TRANSACTION_AMT,this.tran_Date,this.tran_Time,this.cus_Acct_Num,this.acct_Type,this.remarks,this.balAftTrn);
//
//   @override
//   _HighCashWithdrawlAmountState createState() => _HighCashWithdrawlAmountState();
// }
// class _HighCashWithdrawlAmountState extends State<HighCashWithdrawlAmount> {
//   Future<bool>? _onBackPressed() {
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//             builder: (context) => MainHomeScreen(MyCardsScreen(false), 1)),
//             (route) => false);}
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//       bool? result = await _onBackPressed();
//       result ??= false;
//       return result;
//     },
//     child:Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       appBar: AppBar(title: Text("Cash Withdrawl Amount"),backgroundColor: ColorConstants.kPrimaryColor,),
//       body: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Table(
//                 defaultColumnWidth: FixedColumnWidth(200),
//                 children: [
//
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.blue[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Transaction ID_Date",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.tran_Id!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Account Number",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.cus_Acct_Num!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.grey[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Amount Withdrawn",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.TRANSACTION_AMT!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Balance After Transaction",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.balAftTrn!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.grey[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Mode of Transaction",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("BY CASH",textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.grey[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Transaction Processing Date",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.tran_Date!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.grey[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Transaction Processing Time",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.tran_Time!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   ),
//                   TableRow(
//                     // decoration: BoxDecoration(color: Colors.grey[200]),
//                       children:[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Transaction Type",textScaleFactor: 1.3,),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(widget.remarks!,textScaleFactor: 1.3,),
//                         ),
//                       ]
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//     );
//   }
//
// }
