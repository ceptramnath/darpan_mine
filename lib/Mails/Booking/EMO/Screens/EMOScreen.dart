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
// import 'package:darpan_mine/Widgets/LetterForm.dart';
// import 'package:darpan_mine/Widgets/TotalFAB.dart';
// import 'package:darpan_mine/Widgets/TotalToast.dart';
// import 'package:darpan_mine/Widgets/UITools.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//
// class EMOScreen extends StatefulWidget {
//   const EMOScreen({Key? key}) : super(key: key);
//
//   @override
//   _EMOScreenState createState() => _EMOScreenState();
// }
//
// class _EMOScreenState extends State<EMOScreen> {
//   int amountToBeCollected = 0;
//
//   Timer? timer;
//
//   String? _chosenMsg;
//
//   final formGlobalKey = GlobalKey<FormState>();
//
//   bool msgVisibility = false;
//   bool senderFormOpenFlag = false;
//   bool senderNotCompleted = false;
//   bool senderPinCode = false;
//   bool payeeFormOpenFlag = false;
//   bool payeeNotCompleted = false;
//   bool payeePinCode = false;
//
//   Color senderHeadingColor = ColorConstants.kPrimaryAccent;
//   Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;
//
//   final emoValueFocusNode = FocusNode();
//   final commissionFocusNode = FocusNode();
//   final senderNameFocusNode = FocusNode();
//   final senderAddressFocusNode = FocusNode();
//   final senderPinCodeFocusNode = FocusNode();
//   final senderMobileFocusNode = FocusNode();
//   final senderEmailFocusNode = FocusNode();
//   final payeeNameFocusNode = FocusNode();
//   final payeeAddressFocusNode = FocusNode();
//   final payeePinCodeFocusNode = FocusNode();
//   final payeeMobileFocusNode = FocusNode();
//   final payeeEmailFocusNode = FocusNode();
//
//   final emoValueController = TextEditingController();
//   final commissionController = TextEditingController();
//   final senderNameController = TextEditingController();
//   final senderAddressController = TextEditingController();
//   final senderPinCodeController = TextEditingController();
//   final senderCityController = TextEditingController();
//   final senderStateController = TextEditingController();
//   final senderMobileNumberController = TextEditingController();
//   final senderEmailController = TextEditingController();
//   final payeeNameController = TextEditingController();
//   final payeeAddressController = TextEditingController();
//   final payeePinCodeController = TextEditingController();
//   final payeeCityController = TextEditingController();
//   final payeeStateController = TextEditingController();
//   final payeeMobileNumberController = TextEditingController();
//   final payeeEmailController = TextEditingController();
//
//   String date = '';
//   String time = DateTimeDetails().onlyTime();
//   var currentDate =
//       DateTimeDetails().onlyDate().toString().replaceAll(RegExp('-'), '');
//   var currentTime =
//       DateTimeDetails().onlyTime().toString().replaceAll(RegExp(':'), '');
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
//     setState(() {});
//     emoValueFocusNode.addListener(() {
//       var commission = 0;
//       if (!emoValueFocusNode.hasFocus) {
//         commissionAmt = 0;
//         commission = double.parse(emoValueController.text) ~/ 20;
//         double.parse(emoValueController.text) % 20 != 0
//             ? commission += 1
//             : commission += 0;
//         commissionAmt = commission.toInt();
//         setState(() {
//           commissionController.text = commissionAmt.toString();
//         });
//       }
//     });
//     timer =
//         Timer.periodic(const Duration(seconds: 1), (Timer t) => checkColor());
//     super.initState();
//   }
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
//     if (payeeNameController.text.isNotEmpty &&
//         payeeAddressController.text.isNotEmpty &&
//         payeePinCodeController.text.isNotEmpty) {
//       setState(() {
//         payeeNotCompleted = false;
//         addresseeHeadingColor = ColorConstants.kTextColor;
//       });
//     } else {
//       setState(() {
//         addresseeHeadingColor = ColorConstants.kPrimaryAccent;
//       });
//     }
//   }
//
//   getEmoCal() async {
//     emoValueFocusNode.addListener(() {
//       var commission = 0;
//       if (!emoValueFocusNode.hasFocus) {
//         commissionAmt = 0;
//         commission = double.parse(emoValueController.text) ~/ 20;
//         double.parse(emoValueController.text) % 20 != 0
//             ? commission += 1
//             : commission += 0;
//         commissionAmt = commission.toInt();
//         setState(() {
//           commissionController.text = commissionAmt.toString();
//         });
//       }
//     });
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
//       backgroundColor: ColorConstants.kBackgroundColor,
//       floatingActionButton: TotalFAB(
//         title: '\u{20B9} ${getTotalAmount()}',
//         function: () {
//           ToastUtil.show(
//               TotalToast(totalAmount: amountToBeCollected.toString()), context,
//               gravity: ToastGravity.bottom);
//         },
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0.w.toDouble()),
//         child: SingleChildScrollView(
//           child: Form(
//             key: formGlobalKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //Article Details
//                 CAdditionalServiceForm(
//                   labelText: 'EMO Value *',
//                   focusNode: emoValueFocusNode,
//                   controller: emoValueController,
//                   typeValue: 'EMOValue',
//                   iconData: MdiIcons.currencyInr,
//                 ),
//                 Card(
//                   elevation: 0,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: 20.0.w.toDouble(),
//                         vertical: 5.h.toDouble()),
//                     child: DropdownButton<String>(
//                       isExpanded: true,
//                       value: _chosenMsg,
//                       style: const TextStyle(
//                           color: ColorConstants.kSecondaryColor),
//                       underline: Container(),
//                       items: messageCodes
//                           .map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                       hint: const Text(
//                         "Please select the message code",
//                         style: TextStyle(
//                           color: ColorConstants.kAmberAccentColor,
//                         ),
//                       ),
//                       onChanged: (String? value) {
//                         setState(() {
//                           msgVisibility = false;
//                           _chosenMsg = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Visibility(
//                       visible: msgVisibility,
//                       child: Text(
//                         'Please select a message',
//                         style: TextStyle(
//                             fontSize: 10.sp.toDouble(),
//                             color: ColorConstants.kPrimaryColor),
//                       )),
//                 ),
//                 CInputForm(
//                     readOnly: true,
//                     iconData: MdiIcons.currencyInr,
//                     labelText: 'Commission',
//                     controller: commissionController,
//                     textType: TextInputType.text,
//                     typeValue: 'Commission',
//                     focusNode: commissionFocusNode),
//                 const DoubleSpace(),
//
//                 //Sender Details
//                 ExpansionTile(
//                   maintainState: true,
//                   initiallyExpanded: senderExpansion,
//                   title: Text(
//                     'Sender Details',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: senderHeadingColor,
//                         fontSize: 20.sp.toDouble(),
//                         letterSpacing: 1),
//                   ),
//                   trailing: (senderFormOpenFlag == false)
//                       ? Icon(
//                           MdiIcons.toggleSwitchOffOutline,
//                           size: 40.sp.toDouble(),
//                           color: ColorConstants.kTextColor,
//                         )
//                       : Icon(MdiIcons.toggleSwitchOutline,
//                           size: 40.sp.toDouble(),
//                           color: ColorConstants.kPrimaryAccent),
//                   onExpansionChanged: (value) {
//                     setState(() {
//                       senderFormOpenFlag = value;
//                     });
//                   },
//                   children: [
//                     CInputForm(
//                       readOnly: false,
//                       iconData: Icons.person,
//                       labelText: 'Name *',
//                       controller: senderNameController,
//                       textType: TextInputType.text,
//                       typeValue: 'Name',
//                       focusNode: senderNameFocusNode,
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.home,
//                       labelText: 'Address *',
//                       controller: senderAddressController,
//                       textType: TextInputType.multiline,
//                       typeValue: 'Address',
//                       focusNode: senderAddressFocusNode,
//                     ),
//                     Card(
//                       elevation: 0,
//                       child: TypeAheadFormField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: const TextStyle(
//                                 color: ColorConstants.kSecondaryColor),
//                             controller: senderPinCodeController,
//                             autofocus: false,
//                             decoration: const InputDecoration(
//                                 prefixIcon: Icon(
//                                   Icons.location_on_outlined,
//                                   color: ColorConstants.kSecondaryColor,
//                                 ),
//                                 fillColor: ColorConstants.kWhite,
//                                 filled: true,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ColorConstants.kWhite),
//                                 ),
//                                 labelText: 'Pincode/Office Name *',
//                                 labelStyle: TextStyle(
//                                     color: ColorConstants.kAmberAccentColor),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite)))),
//                         onSuggestionSelected:
//                             (Map<String, String> suggestion) async {
//                           senderPinCode = false;
//                           senderPinCodeController.text = suggestion['pinCode']!;
//                           senderCityController.text = suggestion['city']!;
//                           senderStateController.text = suggestion['state']!;
//                         },
//                         itemBuilder: (context, Map<String, String> suggestion) {
//                           return ListTile(
//                             title: Text(suggestion['officeName']! +
//                                 ", " +
//                                 suggestion['pinCode']!),
//                           );
//                         },
//                         suggestionsCallback: (pattern) async {
//                           return await FetchPin.getSuggestions(pattern);
//                         },
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             senderPinCode = true;
//                           }
//                         },
//                       ),
//                     ),
//                     Visibility(
//                         visible: senderPinCode,
//                         child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 15.0.w),
//                               child: Text(
//                                 'Select a Pincode/Office name',
//                                 style: TextStyle(
//                                     color: ColorConstants.kPrimaryColor,
//                                     fontSize: 10.sp),
//                               ),
//                             ))),
//                     Visibility(
//                       visible:
//                           senderPinCodeController.text.isEmpty ? false : true,
//                       child: CInputForm(
//                         readOnly: true,
//                         iconData: Icons.location_city,
//                         labelText: 'City',
//                         controller: senderCityController,
//                         textType: TextInputType.text,
//                         typeValue: 'City',
//                         focusNode: senderPinCodeFocusNode,
//                       ),
//                     ),
//                     Visibility(
//                       visible:
//                           senderPinCodeController.text.isEmpty ? false : true,
//                       child: CInputForm(
//                         readOnly: true,
//                         iconData: Icons.location_city,
//                         labelText: 'State',
//                         controller: senderStateController,
//                         textType: TextInputType.text,
//                         typeValue: 'City',
//                         focusNode: senderPinCodeFocusNode,
//                       ),
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.cellphone,
//                       labelText: 'Mobile Number',
//                       controller: senderMobileNumberController,
//                       textType: TextInputType.number,
//                       typeValue: 'MobileNumber',
//                       focusNode: senderMobileFocusNode,
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.email,
//                       labelText: 'Email',
//                       controller: senderEmailController,
//                       textType: TextInputType.emailAddress,
//                       typeValue: 'Email',
//                       focusNode: senderEmailFocusNode,
//                     )
//                   ],
//                 ),
//                 Visibility(
//                     visible: senderNotCompleted,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 20.0.w.toDouble()),
//                       child: const Text(
//                         'Enter the Sender details',
//                         style: TextStyle(
//                             fontSize: 10, color: ColorConstants.kPrimaryAccent),
//                       ),
//                     )),
//                 const Space(),
//
//                 //Addressee Details
//                 ExpansionTile(
//                   maintainState: true,
//                   initiallyExpanded: addresseeExpansion,
//                   title: Text(
//                     'Payee Details',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: addresseeHeadingColor,
//                         fontSize: 20.sp.toDouble(),
//                         letterSpacing: 1),
//                   ),
//                   trailing: (payeeFormOpenFlag == false)
//                       ? Icon(
//                           MdiIcons.toggleSwitchOffOutline,
//                           size: 40.sp.toDouble(),
//                           color: ColorConstants.kTextColor,
//                         )
//                       : Icon(MdiIcons.toggleSwitchOutline,
//                           size: 40.sp.toDouble(),
//                           color: ColorConstants.kPrimaryAccent),
//                   onExpansionChanged: (value) {
//                     setState(() {
//                       payeeFormOpenFlag = value;
//                     });
//                   },
//                   children: [
//                     CInputForm(
//                       readOnly: false,
//                       iconData: Icons.person,
//                       labelText: 'Name *',
//                       controller: payeeNameController,
//                       textType: TextInputType.text,
//                       typeValue: 'Name',
//                       focusNode: payeeNameFocusNode,
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.home,
//                       labelText: 'Address *',
//                       controller: payeeAddressController,
//                       textType: TextInputType.multiline,
//                       typeValue: 'Address',
//                       focusNode: payeeAddressFocusNode,
//                     ),
//                     Card(
//                       elevation: 0,
//                       child: TypeAheadFormField(
//                         textFieldConfiguration: TextFieldConfiguration(
//                             style: const TextStyle(
//                                 color: ColorConstants.kSecondaryColor),
//                             controller: payeePinCodeController,
//                             autofocus: false,
//                             decoration: const InputDecoration(
//                                 prefixIcon: Icon(
//                                   Icons.location_on_outlined,
//                                   color: ColorConstants.kSecondaryColor,
//                                 ),
//                                 fillColor: ColorConstants.kWhite,
//                                 filled: true,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ColorConstants.kWhite),
//                                 ),
//                                 labelText: 'Pincode/Office Name *',
//                                 labelStyle: TextStyle(
//                                     color: ColorConstants.kAmberAccentColor),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ColorConstants.kWhite)))),
//                         onSuggestionSelected:
//                             (Map<String, String> suggestion) async {
//                           payeePinCode = false;
//                           payeePinCodeController.text = suggestion['pinCode']!;
//                           payeeCityController.text = suggestion['city']!;
//                           payeeStateController.text = suggestion['state']!;
//                         },
//                         itemBuilder: (context, Map<String, String> suggestion) {
//                           return ListTile(
//                             title: Text(suggestion['officeName']! +
//                                 ", " +
//                                 suggestion['pinCode']!),
//                           );
//                         },
//                         suggestionsCallback: (pattern) async {
//                           return await FetchPin.getSuggestions(pattern);
//                         },
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             payeePinCode = true;
//                           }
//                         },
//                       ),
//                     ),
//                     Visibility(
//                         visible: payeePinCode,
//                         child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Padding(
//                               padding: EdgeInsets.only(left: 15.0.w),
//                               child: Text(
//                                 'Select a Pincode/Office name',
//                                 style: TextStyle(
//                                     color: ColorConstants.kPrimaryColor,
//                                     fontSize: 10.sp),
//                               ),
//                             ))),
//                     Visibility(
//                       visible:
//                           payeePinCodeController.text.isEmpty ? false : true,
//                       child: CInputForm(
//                         readOnly: true,
//                         iconData: Icons.location_city,
//                         labelText: 'City',
//                         controller: payeeCityController,
//                         textType: TextInputType.text,
//                         typeValue: 'City',
//                         focusNode: payeePinCodeFocusNode,
//                       ),
//                     ),
//                     Visibility(
//                       visible:
//                           payeePinCodeController.text.isEmpty ? false : true,
//                       child: CInputForm(
//                         readOnly: true,
//                         iconData: Icons.location_city,
//                         labelText: 'State',
//                         controller: payeeStateController,
//                         textType: TextInputType.text,
//                         typeValue: 'City',
//                         focusNode: payeePinCodeFocusNode,
//                       ),
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.cellphone,
//                       labelText: 'Mobile Number',
//                       controller: payeeMobileNumberController,
//                       textType: TextInputType.number,
//                       typeValue: 'MobileNumber',
//                       focusNode: payeeMobileFocusNode,
//                     ),
//                     CInputForm(
//                       readOnly: false,
//                       iconData: MdiIcons.email,
//                       labelText: 'Email',
//                       controller: payeeEmailController,
//                       textType: TextInputType.emailAddress,
//                       typeValue: 'Email',
//                       focusNode: payeeEmailFocusNode,
//                     )
//                   ],
//                 ),
//                 Visibility(
//                     visible: payeeNotCompleted,
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 20.0.w.toDouble()),
//                       child: const Text(
//                         'Enter the Payee details',
//                         style: TextStyle(
//                             fontSize: 10, color: ColorConstants.kPrimaryAccent),
//                       ),
//                     )),
//
//                 //Submit
//                 Padding(
//                   padding: EdgeInsets.all(8.0.w.toDouble()),
//                   child: Center(
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               ColorConstants.kWhite),
//                           shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(10.w.toDouble()),
//                                   side: const BorderSide(
//                                       color: ColorConstants.kSecondaryColor)))),
//                       onPressed: () async {
//                         setState(() {
//                           emoValueFocusNode.unfocus();
//                         });
//                         await getTotalAmount();
//                         if (_chosenMsg.toString() == 'null') {
//                           setState(() {
//                             msgVisibility = true;
//                           });
//                         }
//                         if (senderNameController.text.isEmpty ||
//                             senderAddressController.text.isEmpty ||
//                             senderCityController.text.isEmpty)
//                           senderNotCompleted = true;
//                         if (payeeNameController.text.isEmpty ||
//                             payeeAddressController.text.isEmpty ||
//                             payeeCityController.text.isEmpty) {
//                           payeeNotCompleted = true;
//                         }
//
//                         if (formGlobalKey.currentState!.validate()) {
//                           formGlobalKey.currentState!.save();
//                           showDialog<void>(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (BuildContext context) {
//                                 return EMOConformationDialog(
//                                     pnrNumber: "",
//                                     emoValue: emoValueController.text,
//                                     message: _chosenMsg.toString(),
//                                     commission: commissionAmt.toString(),
//                                     amountToBeCollected:
//                                         (emoValueAmt + commissionAmt)
//                                             .toString(),
//                                     senderName: senderNameController.text,
//                                     senderAddress: senderAddressController.text,
//                                     senderPinCode: senderPinCodeController.text,
//                                     senderCity: senderCityController.text,
//                                     senderState: senderStateController.text,
//                                     senderMobileNumber:
//                                         senderMobileNumberController.text,
//                                     senderEmail: senderEmailController.text,
//                                     addresseeName: payeeNameController.text,
//                                     addresseeAddress:
//                                         payeeAddressController.text,
//                                     addresseePinCode:
//                                         payeePinCodeController.text,
//                                     addresseeCity: payeeCityController.text,
//                                     addresseeState: payeeStateController.text,
//                                     addresseeMobileNumber:
//                                         payeeMobileNumberController.text,
//                                     addresseeEmail: payeeEmailController.text,
//                                     function: () {
//                                       printFunction();
//                                       Navigator.of(context).pop();
//                                     });
//                               });
//                         }
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.all(8.0.w.toDouble()),
//                         child: const Text(
//                           'SUBMIT',
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               color: ColorConstants.kAmberAccentColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   getTotalAmount() {
//     emoValueController.text.isEmpty
//         ? emoValueAmt = 0
//         : emoValueAmt = int.parse(emoValueController.text);
//     setState(() {
//       amountToBeCollected = emoValueAmt + commissionAmt;
//     });
//     if (amountToBeCollected < 0) amountToBeCollected = 0;
//     if (emoValueController.text.isEmpty) amountToBeCollected = 0;
//     return amountToBeCollected.toString();
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
//     //   "totalamount":amountToBeCollected.toString(),
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
//     //   "producttype":"EMO",
//     //   "productcode":"EMO",
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
//     //   "momessage":_chosenMsg,
//     //   "elapsedtime":"",
//     //   "bulkaddresstype":"",
//     //   "vpmoidentifier":"",
//     //   "articleno": "EMO$date$time",
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
//     // BookingDBService().addTransactionToDB(
//     //     date+time, date, time,
//     //     amountToBeCollected.toString(), 'EMO', senderNameController.text,
//     //     payeePinCodeController.text,
//     //     commissionController.text, 'Booked');
//
//     BookingDBService().addEMOToDB(
//         "",
//         DateTimeDetails().dateCharacter(),
//         DateTimeDetails().timeCharacter(),
//         amountToBeCollected.toString(),
//         amountToBeCollected.toString(),
//         'ZFS',
//         'S',
//         'V2',
//         '21',
//         // '57000000003',
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
//         commissionController.text,
//         '21',
//         _chosenMsg!,
//         false);
//
//     BookingDBService().addTransaction(
//         'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
//         'Booking',
//         'EMO Booking',
//         DateTimeDetails().onlyDate(),
//         DateTimeDetails().onlyTime(),
//         amountToBeCollected.toString(),
//         'Add');
//
//     final addCash =  CashTable()
//       ..Cash_ID = date + time
//       ..Cash_Date = DateTimeDetails().currentDate()
//       ..Cash_Time = DateTimeDetails().onlyTime()
//       ..Cash_Type = 'Add'
//       ..Cash_Amount = amountToBeCollected.toDouble()
//       ..Cash_Description = 'EMO Booking';
//     await addCash.save();
//
//     // BookingDBService().addToDB(
//     //     "TRANSEMO${senderNameController.text}", date, time, date+time,
//     //     '', '', '', '0', '0', '0', '0', '0', commissionController.text,
//     //     amountToBeCollected.toString(), _chosenMsg.toString(), senderNameController.text,
//     //     senderAddressController.text, senderPinCodeController.text,
//     //     senderCityController.text, senderStateController.text, 'IN',
//     //     senderEmailController.text, senderMobileNumberController.text,
//     //     payeeNameController.text, payeeAddressController.text,
//     //     payeePinCodeController.text, payeeCityController.text,
//     //     payeeStateController.text, 'IN', payeeEmailController.text,
//     //     payeeMobileNumberController.text, 'EMO');
//   }
// }
