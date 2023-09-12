// import 'dart:async';
//
// import 'package:darpan_mine/Constants/Calculations.dart';
// import 'package:darpan_mine/Constants/Color.dart';
// import 'package:darpan_mine/Constants/Texts.dart';
// import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
// import 'package:darpan_mine/DatabaseModel/transtable.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
// import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMOConformationDialog.dart';
// import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
// import 'package:darpan_mine/Utils/FetchPin.dart';
// import 'package:darpan_mine/Widgets/CustomToast.dart';
// import 'package:darpan_mine/Widgets/DialogText.dart';
// import 'package:darpan_mine/Widgets/LetterForm.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// class PMOReliefScreen extends StatefulWidget {
//   const PMOReliefScreen({Key? key}) : super(key: key);
//
//   @override
//   _PMOReliefScreenState createState() => _PMOReliefScreenState();
// }
//
// class _PMOReliefScreenState extends State<PMOReliefScreen> {
//   bool senderFormOpenFlag = false;
//   bool senderNotCompleted = false;
//   bool senderPinCode = false;
//   bool payeeFormOpenFlag = false;
//
//   final formGlobalKey = GlobalKey<FormState>();
//
//   Timer? timer;
//
//   Color senderHeadingColor = ColorConstants.kPrimaryAccent;
//   Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;
//
//   final emoValueFocusNode = FocusNode();
//   final senderNameFocusNode = FocusNode();
//   final senderAddressFocusNode = FocusNode();
//   final senderPinCodeFocusNode = FocusNode();
//   final senderMobileFocusNode = FocusNode();
//   final senderEmailFocusNode = FocusNode();
//
//   final emoValueController = TextEditingController();
//   final senderNameController = TextEditingController();
//   final senderAddressController = TextEditingController();
//   final senderPinCodeController = TextEditingController();
//   final senderCityController = TextEditingController();
//   final senderStateController = TextEditingController();
//   final senderMobileNumberController = TextEditingController();
//   final senderEmailController = TextEditingController();
//   final payeeNameController =
//       TextEditingController(text: 'Prime Minister Relief Fund');
//   final payeeAddressController =
//       TextEditingController(text: 'Prime Minister Office');
//   final payeePinCodeController = TextEditingController(text: '110011');
//   final payeeCityController =
//       TextEditingController(text: 'South block, Raisina Hill');
//   final payeeStateController = TextEditingController(text: 'New Delhi');
//   final payeeMobileNumberController = TextEditingController();
//   final payeeEmailController = TextEditingController();
//
//   String date = DateTimeDetails().onlyDate();
//   String time = DateTimeDetails().onlyTime();
//
//   currentDateTime() {
//     var now = DateTime.now();
//     var formatter = DateFormat('dd-MM-yyyy');
//     setState(() {
//       date = formatter.format(now);
//     });
//   }
//
//   @override
//   void initState() {
//     currentDateTime();
//     timer =
//         Timer.periodic(const Duration(seconds: 1), (Timer t) => checkColor());
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer!.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorConstants.kBackgroundColor,
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: ColorConstants.kPrimaryColor.withOpacity(.9),
//           onPressed: () {
//             ToastUtil.show(
//                 ToastDecorator(
//                   widget: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: Colors.white, width: 2)),
//                         child: ListTile(
//                           leading: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(
//                                 MdiIcons.currencyInr,
//                                 size: 30,
//                                 color: ColorConstants.kWhite,
//                               ),
//                               Text(
//                                 emoValueController.text,
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 20.sp.toDouble()),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                           title: const Text('Amount to be collected',
//                               style: TextStyle(
//                                   color: ColorConstants.kWhite,
//                                   letterSpacing: 2)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   backgroundColor: ColorConstants.kGrassGreen,
//                 ),
//                 context,
//                 gravity: ToastGravity.bottom);
//           },
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           label: getTotal(),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(20.0.w.toDouble()),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formGlobalKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //Article Details
//                   DialogText(title: '\tMessage : ', subtitle: '\t $pmoMessage'),
//                   const Space(),
//                   CAdditionalServiceForm(
//                     labelText: 'EMO Value *',
//                     focusNode: emoValueFocusNode,
//                     controller: emoValueController,
//                     typeValue: 'EMOValue',
//                     iconData: MdiIcons.currencyInr,
//                   ),
//
//                   //Sender Details
//                   const DoubleSpace(),
//                   ExpansionTile(
//                     maintainState: true,
//                     initiallyExpanded: senderExpansion,
//                     title: Text(
//                       'Sender Details',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: senderHeadingColor,
//                           fontSize: 20.sp.toDouble(),
//                           letterSpacing: 1),
//                     ),
//                     trailing: (senderFormOpenFlag == false)
//                         ? Icon(
//                             MdiIcons.toggleSwitchOffOutline,
//                             size: 40.sp.toDouble(),
//                             color: ColorConstants.kTextColor,
//                           )
//                         : Icon(MdiIcons.toggleSwitchOutline,
//                             size: 40.sp.toDouble(),
//                             color: ColorConstants.kPrimaryAccent),
//                     onExpansionChanged: (value) {
//                       setState(() {
//                         senderFormOpenFlag = value;
//                       });
//                     },
//                     children: [
//                       CInputForm(
//                         readOnly: false,
//                         iconData: Icons.person,
//                         labelText: 'Name *',
//                         controller: senderNameController,
//                         textType: TextInputType.text,
//                         typeValue: 'Name',
//                         focusNode: senderNameFocusNode,
//                       ),
//                       CInputForm(
//                         readOnly: false,
//                         iconData: MdiIcons.home,
//                         labelText: 'Address *',
//                         controller: senderAddressController,
//                         textType: TextInputType.multiline,
//                         typeValue: 'Address',
//                         focusNode: senderAddressFocusNode,
//                       ),
//                       Card(
//                         elevation: 0,
//                         child: TypeAheadFormField(
//                           textFieldConfiguration: TextFieldConfiguration(
//                               style: const TextStyle(
//                                   color: ColorConstants.kSecondaryColor),
//                               controller: senderPinCodeController,
//                               autofocus: false,
//                               decoration: const InputDecoration(
//                                   prefixIcon: Icon(
//                                     Icons.location_on_outlined,
//                                     color: ColorConstants.kSecondaryColor,
//                                   ),
//                                   fillColor: ColorConstants.kWhite,
//                                   filled: true,
//                                   enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite),
//                                   ),
//                                   labelText: 'Pincode/Office Name *',
//                                   labelStyle: TextStyle(
//                                       color: ColorConstants.kAmberAccentColor),
//                                   border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: ColorConstants.kWhite)))),
//                           onSuggestionSelected:
//                               (Map<String, String> suggestion) async {
//                             senderPinCode = false;
//                             senderPinCodeController.text =
//                                 suggestion['pinCode']!;
//                             senderCityController.text = suggestion['city']!;
//                             senderStateController.text = suggestion['state']!;
//                           },
//                           itemBuilder:
//                               (context, Map<String, String> suggestion) {
//                             return ListTile(
//                               title: Text(suggestion['officeName']! +
//                                   ", " +
//                                   suggestion['pinCode']!),
//                             );
//                           },
//                           suggestionsCallback: (pattern) async {
//                             return await FetchPin.getSuggestions(pattern);
//                           },
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               senderPinCode = true;
//                             }
//                           },
//                         ),
//                       ),
//                       Visibility(
//                           visible: senderPinCode,
//                           child: Align(
//                               alignment: Alignment.topLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 15.0.w),
//                                 child: Text(
//                                   'Select a Pincode/Office name',
//                                   style: TextStyle(
//                                       color: ColorConstants.kPrimaryColor,
//                                       fontSize: 10.sp),
//                                 ),
//                               ))),
//                       Visibility(
//                         visible:
//                             senderPinCodeController.text.isEmpty ? false : true,
//                         child: CInputForm(
//                           readOnly: true,
//                           iconData: Icons.location_city,
//                           labelText: 'City',
//                           controller: senderCityController,
//                           textType: TextInputType.text,
//                           typeValue: 'City',
//                           focusNode: senderPinCodeFocusNode,
//                         ),
//                       ),
//                       Visibility(
//                         visible:
//                             senderPinCodeController.text.isEmpty ? false : true,
//                         child: CInputForm(
//                           readOnly: true,
//                           iconData: Icons.location_city,
//                           labelText: 'State',
//                           controller: senderStateController,
//                           textType: TextInputType.text,
//                           typeValue: 'City',
//                           focusNode: senderPinCodeFocusNode,
//                         ),
//                       ),
//                       CInputForm(
//                         readOnly: false,
//                         iconData: MdiIcons.cellphone,
//                         labelText: 'Mobile Number',
//                         controller: senderMobileNumberController,
//                         textType: TextInputType.number,
//                         typeValue: 'MobileNumber',
//                         focusNode: senderMobileFocusNode,
//                       ),
//                       CInputForm(
//                         readOnly: false,
//                         iconData: MdiIcons.email,
//                         labelText: 'Email',
//                         controller: senderEmailController,
//                         textType: TextInputType.emailAddress,
//                         typeValue: 'Email',
//                         focusNode: senderEmailFocusNode,
//                       )
//                     ],
//                   ),
//                   Visibility(
//                       visible: senderNotCompleted,
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 20.0.w.toDouble()),
//                         child: const Text(
//                           'Enter the Sender details',
//                           style: TextStyle(
//                               fontSize: 10,
//                               color: ColorConstants.kPrimaryAccent),
//                         ),
//                       )),
//                   const Space(),
//
//                   //Payee Details
//                   ExpansionTile(
//                     title: Text(
//                       'Payee Details',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: ColorConstants.kSecondaryColor,
//                           fontSize: 20.sp.toDouble(),
//                           letterSpacing: 1),
//                     ),
//                     trailing: (payeeFormOpenFlag == false)
//                         ? Icon(
//                             MdiIcons.toggleSwitchOffOutline,
//                             size: 40.sp.toDouble(),
//                             color: ColorConstants.kTextColor,
//                           )
//                         : Icon(MdiIcons.toggleSwitchOutline,
//                             size: 40.sp.toDouble(),
//                             color: ColorConstants.kPrimaryAccent),
//                     onExpansionChanged: (value) {
//                       setState(() {
//                         payeeFormOpenFlag = value;
//                       });
//                     },
//                     children: [
//                       InitialTextFormField(
//                           controller: payeeNameController,
//                           iconData: Icons.person,
//                           labelText: 'Name'),
//                       InitialTextFormField(
//                           controller: payeeAddressController,
//                           iconData: MdiIcons.home,
//                           labelText: 'Address'),
//                       InitialTextFormField(
//                           controller: payeePinCodeController,
//                           iconData: Icons.location_on_outlined,
//                           labelText: 'Pincode'),
//                       InitialTextFormField(
//                           controller: payeeCityController,
//                           iconData: Icons.location_city,
//                           labelText: 'City'),
//                       InitialTextFormField(
//                           controller: payeeStateController,
//                           iconData: Icons.location_city,
//                           labelText: 'State'),
//                     ],
//                   ),
//
//                   //Submit
//                   Padding(
//                     padding: EdgeInsets.all(8.0.w.toDouble()),
//                     child: Center(
//                       child: ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 ColorConstants.kWhite),
//                             shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                 RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(10.w.toDouble()),
//                                     side: const BorderSide(
//                                         color:
//                                             ColorConstants.kSecondaryColor)))),
//                         onPressed: () async {
//                           setState(() {
//                             emoValueFocusNode.unfocus();
//                           });
//                           if (senderNameController.text.isEmpty ||
//                               senderAddressController.text.isEmpty ||
//                               senderCityController.text.isEmpty) {
//                             senderNotCompleted = true;
//                           }
//                           if (formGlobalKey.currentState!.validate()) {
//                             formGlobalKey.currentState!.save();
//                             showDialog<void>(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (BuildContext context) {
//                                   return EMOConformationDialog(
//                                       pnrNumber: "",
//                                       emoValue: emoValueController.text,
//                                       message: pmoMessage,
//                                       commission: '',
//                                       amountToBeCollected:
//                                           emoValueController.text,
//                                       senderName: senderNameController.text,
//                                       senderAddress:
//                                           senderAddressController.text,
//                                       senderPinCode:
//                                           senderPinCodeController.text,
//                                       senderCity: senderCityController.text,
//                                       senderState: senderStateController.text,
//                                       senderMobileNumber:
//                                           senderMobileNumberController.text,
//                                       senderEmail: senderEmailController.text,
//                                       addresseeName: payeeNameController.text,
//                                       addresseeAddress:
//                                           payeeAddressController.text,
//                                       addresseePinCode:
//                                           payeePinCodeController.text,
//                                       addresseeCity: payeeCityController.text,
//                                       addresseeState: payeeStateController.text,
//                                       addresseeMobileNumber:
//                                           payeeMobileNumberController.text,
//                                       addresseeEmail: payeeEmailController.text,
//                                       function: () {
//                                         Navigator.of(context).pop();
//                                         printFunction();
//                                       });
//                                 });
//                           }
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0.w.toDouble()),
//                           child: const Text(
//                             'SUBMIT',
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: ColorConstants.kAmberAccentColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
//
//   printFunction() async {
//     // var response = await http.post(Uri.parse(URL.bookingURL) , body: {
//     //   "facilityid":"PO9999999999",
//     //   "bookingfacilityzip":"570010",
//     //   "distributionchannel":"",
//     //   "userid":"",
//     //   "counterno":"",
//     //   "invoiceno":"",
//     //   "totalamount":emoValueController.text,
//     //   "bookingdate":date,
//     //   "bookingtime":time,
//     //   "currencyid":"INR",
//     //   "tenderid":"",
//     //   "totalcashamount":"",
//     //   "roundoffdifferenceamount":"",
//     //   "checkeruserid":"",
//     //   "circlecode":"",
//     //   "lineitemnumber":"",
//     //   "baseprice":"",
//     //   "lineitemtotalamount":"",
//     //   "division":"",
//     //   "ordertype":"",
//     //   "producttype":"PMO",
//     //   "productcode":"PMO",
//     //   "quantity":"",
//     //   "valuecode":"",
//     //   "value":"",
//     //   "sendercustomerid":"",
//     //   "sendercustomername":senderNameController.text,
//     //   "senderaddress1":senderAddressController.text,
//     //   "senderaddress2":"",
//     //   "senderaddress3":"",
//     //   "sendermobile":senderMobileNumberController.text,
//     //   "sendercity":senderCityController.text,
//     //   "senderstate":senderStateController.text,
//     //   "senderzip":senderPinCodeController.text,
//     //   "sendercountry":"INDIA",
//     //   "recipientname":payeeNameController.text,
//     //   "recipientaddress1":payeeAddressController.text,
//     //   "recipientaddress2":"",
//     //   "recipientcity":payeeCityController.text,
//     //   "recipientstate":payeeStateController.text,
//     //   "recipientzip":payeePinCodeController.text,
//     //   "recipientcountry":"INDIA",
//     //   "recipientmobile":payeeMobileNumberController.text,
//     //   "recipientemail":payeeEmailController.text,
//     //   "returncustomername":senderNameController.text,
//     //   "returnaddress1":senderAddressController.text,
//     //   "returncity":senderCityController.text,
//     //   "returnstate":senderStateController.text,
//     //   "returnzip":senderPinCodeController.text,
//     //   "returncountryid":"INDIA",
//     //   "commissionamount":"",
//     //   "materialgroup":"",
//     //   "destinationfacilityid":"",
//     //   "sendermoneytransfervalue":"",
//     //   "motrackingid":"",
//     //   "momessage":'PM Relief Fund',
//     //   "elapsedtime":"",
//     //   "bulkaddresstype":"",
//     //   "vpmoidentifier":"",
//     //   "articleno": "PMO$date$time",
//     //   "weightcode":"",
//     //   "weight": '0',
//     //   "distancecode":"",
//     //   "distance":"",
//     //   "taxamount":serviceTax,
//     //   "postagedue":"",
//     //   "prepaidamount":ppAmt,
//     //   "isfullprepaid":"",
//     //   "vas":"",
//     //   "vasvalue":"",
//     //   "addlbillinfo":"",
//     //   "addlbillamountinfo":"",
//     //   "billerid":"",
//     //   "recipientaddress3":"",
//     //   "repaymentmode":"",
//     //   "isams":"",
//     //   "isonpostalservice":"",
//     //   "parentinvoiceno":"",
//     //   "isreversed":"",
//     //   "serialno":"",
//     //   "clientrequesttime":"$date $time"
//     // });
//     //
//     // if (response.statusCode == 201) {
//     //   Toast.showFloatingToast('Added To Server', context);
//     // }
//
//     BookingDBService().addEMOToDB(
//         "",
//         DateTimeDetails().dateCharacter(),
//         DateTimeDetails().timeCharacter(),
//         emoValueController.text.toString(),
//         emoValueController.text.toString(),
//         'ZFS',
//         'S',
//         'V2',
//         '21',
//         senderNameController.text,
//         senderAddressController.text,
//         senderCityController.text,
//         senderStateController.text,
//         senderPinCodeController.text,
//         payeeNameController.text,
//         payeeAddressController.text,
//         payeeCityController.text,
//         payeeStateController.text,
//         payeePinCodeController.text,
//         payeeMobileNumberController.text,
//         payeeEmailController.text,
//         '0',
//         '21',
//         'PM Relief Fund',
//         false);
//
//     final addCash =  CashTable()
//       ..Cash_ID = senderPinCodeController.text
//       ..Cash_Date = date
//       ..Cash_Time = time
//       ..Cash_Type = 'Add'
//       ..Cash_Amount = double.parse(emoValueController.text)
//       ..Cash_Description = 'PMO Booking';
//     await addCash.save();
//
//     BookingDBService().addTransaction(
//         'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
//         'Booking',
//         'PMO Booking',
//         DateTimeDetails().onlyDate(),
//         DateTimeDetails().onlyTime(),
//         emoValueController.text,
//         'Add');
//
//     // BookingDBService().addToDB(
//     //     "TRANSEMO$date", date, time, date+time,
//     //     '', '', '', '0', '0', '0', '0', '0', '0',
//     //     emoValueController.text, 'PM Relief Fund', senderNameController.text,
//     //     senderAddressController.text, senderPinCodeController.text,
//     //     senderCityController.text, senderStateController.text, 'IN',
//     //     senderEmailController.text, senderMobileNumberController.text,
//     //     payeeNameController.text, payeeAddressController.text,
//     //     payeePinCodeController.text, payeeCityController.text,
//     //     payeeStateController.text, 'IN', payeeEmailController.text,
//     //     payeeMobileNumberController.text, 'PMO');
//   }
//
//   // printFunction() {
//   //   final pmoArticle = EmoTable()
//   //     ..EMOValue = int.parse(emoValueController.text)
//   //     ..EMOAmount = int.parse(emoValueController.text)
//   //     ..Message = pmoMessage
//   //     ..SenderName = senderNameController.text.trim()
//   //     ..SenderAddress = senderAddressController.text.trim()
//   //     ..SenderPincode = int.parse(senderPinCodeCityController.text.trim())
//   //     ..SenderCity = senderCityController.text.trim()
//   //     ..SenderState = senderStateController.text.trim()
//   //     ..SenderMobileNumber = senderMobileNumberController.text.trim()
//   //     ..SenderEmail = senderEmailController.text.trim()
//   //     ..PayeeName = payeeNameController.text.trim()
//   //     ..PayeeAddress = payeeAddressController.text.trim()
//   //     ..PayeePincode = int.parse(payeePinCodeController.text.trim())
//   //     ..PayeeCity = payeeCityController.text.trim()
//   //     ..PayeeState = payeeStateController.text.trim()
//   //     ..PayeeMobileNumber = payeeMobileNumberController.text.trim()
//   //     ..PayeeEmail = payeeEmailController.text.trim()
//   //     ..Type = 'PMO'
//   //   ..RemarkDate = date;
//   //   pmoArticle.save();
//   // }
//
//   checkColor() {
//     if (senderNameController.text.isNotEmpty &&
//         senderAddressController.text.isNotEmpty &&
//         senderCityController.text.isNotEmpty) {
//       setState(() {
//         senderNotCompleted = false;
//         senderHeadingColor = ColorConstants.kTextColor;
//       });
//     } else {
//       setState(() {
//         senderHeadingColor = ColorConstants.kPrimaryAccent;
//       });
//     }
//   }
//
//   Widget getTotal() {
//     if (emoValueController.text.isEmpty) {
//       return Text(
//         '\u{20B9} 0',
//         style: TextStyle(fontSize: 20.sp.toDouble()),
//       );
//     } else {
//       return Text(
//         '\u{20B9} ${emoValueController.text}',
//         style: TextStyle(fontSize: 20.sp.toDouble()),
//       );
//     }
//   }
// }
