// import 'dart:io';
// import 'dart:typed_data';
//
//
// import 'package:darpan_mine/Delivery/Screens/singlearticlesync.dart';
// import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
// import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
// import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
//
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'CustomAppBar.dart';
// import 'DeliveryScreen.dart';
// import 'EMOScreen.dart';
// import 'EmptyImage.dart';
// import 'HintPosition.dart';
// import 'ParcelScreen.dart';
// import 'RegisterScreen.dart';
// import 'SpeedScreen.dart';
// import 'db/ArticleModel.dart';
//
//
// class SaveScannedEMOArticleScreen extends StatefulWidget {
//   String? articles;
//   String? articleTypes;
//
//   String? deliverStat;
//   String? addresseeTy;
//   String? deliveredToName;
//   int? amount;
//   String? cod;
//   String? vpp;
//   var signature;
//   bool? witnessSignature;
//   int? pageredirection;
//
//   SaveScannedEMOArticleScreen(
//       this.pageredirection, this.articles, this.articleTypes, this.cod,this.vpp,this.amount,
//       [this.deliverStat,
//         this.addresseeTy,
//         this.deliveredToName,
//         this.signature,
//         this.witnessSignature]);
//
//   @override
//   _SaveScannedEMOArticleScreenState createState() =>
//       _SaveScannedEMOArticleScreenState();
// }
//
// class _SaveScannedEMOArticleScreenState extends State<SaveScannedEMOArticleScreen> {
//   final key = new GlobalKey<ScaffoldState>();
//   final _formKey = GlobalKey<FormState>();
//   final _deliveredFormKey = GlobalKey<FormState>();
//   // final picker = ImagePicker();
//
//   LatLng? currentPosition;
//
//   int? isLTMStatus;
//   int? isListArticleStatus;
//
//   String? generatedPdfFilePath;
//   String? _articleStatusError;
//   String? _addresseeTypeError;
//   String? deliveredToError;
//   String? imageError;
//   String? _remarkError;
//   String? _remarkText;
//   String remarkCode = '';
//   String latitude = '';
//   String longitude = '';
//   String deliveredStatusText = '';
//   String addresseeTypeText = '';
//   String _currentLocation = '';
//   String htmlDoc = '';
//   String articleType = '';
//   String remarkDate = '';
//
//   String _currentDateTime = DateTimeDetails().currentDateTime();
//
//   var base64Str;
//   var _capturedImageBytes;
//   var reasonsResponse;
//   int? scannerValue;
//   List isListArticleList = [];
//   List articleNumber = [];
//   List addresseeName = [];
//   List remark = [];
//   List _nonDeliveryRemark = [];
//   List _nonDeliveryCodes = [];
//   List<String> dbImages = [];
//   List _remark = [
//     'Addressee Absent',
//     'Addressee cannot be located',
//     'Addressee left without Instructions',
//     'Addressee Moved',
//     'Beat Change',
//     'Deceased',
//     'Door locked',
//     'Insufficient Address',
//     'No such persons in the address',
//     'Refused',
//     'Recalled',
//   ];
//
//   List<Logintable> pmdata = [];
//
//   List _deliverStatus = ['Delivered', 'Not Delivered'];
//   String? deliverStatus;
//
//   List _addresseeType = [
//     'Addressee',
//     'Security Personnel',
//     'Article Receipt Room',
//     'Others'
//   ];
//   String? _addresseeTypeText;
//
//   Uint8List _bytesImage = EmptyImage().getEmptyImage();
//
//   File? _image;
//
//   TextEditingController articleNumberController = new TextEditingController();
//   TextEditingController deliveredToNameController = new TextEditingController();
//
//   @override
//   void initState() {
//     deliverStatus = widget.deliverStat;
//     _getPMData();
//     _getData();
//     _getUserLocation();
//     _getReasonCode();
//     _getSignature();
//     super.initState();
//   }
//
//   _getPMData() async {
//     pmdata = await Logintable().select().is_Active.equals("1").toList();
//     // print("Pm Data: ${pmdata.length}");
//     // if(pmdata.length==0){
//     //   pmdata[0].PostmanName="Srujan";
//     //   pmdata[0].BatchNo="1";
//     //   pmdata[0].BeatNo="1";
//     //   pmdata[0].FacilityId="HO233221552";
//     //   pmdata[0].EmpId="10164416";
//     // }
//     // print(pmdata[0].PostmanName);
//     // print(pmdata[0].BatchNo);
//     // print(pmdata[0].BeatNo); print(pmdata[0].EmpId);
//     // print(pmdata[0].FacilityId);
//
//   }
//
//   _getData() async {
//     for (int i = 0; i < 1 ;i++) {
//       final isListArticleResponse = await ScannedArticle()
//           .select()
//           .articleNumber
//           .equals(widget.articles)
//           .toMapList();
//       // final isListArticleResponse = await TakeArticleReturn()
//       //     .select()
//       //     .articleNumber
//       //     .equals(widget.articles[i])
//       //     .toMapList();
//       isListArticleList.add(isListArticleResponse[0]['isListArticle']);
//       final remarkDateResponse = await ScannedArticle()
//           .select()
//           .articleNumber
//           .equals(widget.articles)
//           .toMapList();
//       // final remarkDateResponse = await TakeArticleReturn()
//       //     .select()
//       //     .articleNumber
//       //     .equals(widget.articles[i])
//       //     .toMapList();
//       remarkDate = remarkDateResponse[0]['remarkDate'];
//     }
//     print("Remark Date is " + remarkDate);
//   }
//
//   //Get user Current co-ordinates
//   void _getUserLocation() async {
//     var lpermiss = await Permission.location.status;
//     if (!lpermiss.isGranted) {
//       await Permission.location.request();
//     } else {
//       try {
//         var position = await Geolocator
//             .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//         if (mounted) {
//           setState(() {
//             currentPosition = LatLng(position.latitude, position.longitude);
//             _currentLocation =
//                 '${currentPosition!.latitude.toStringAsFixed(8)} ' +
//                     ' ${currentPosition!.longitude.toStringAsFixed(8)}';
//             latitude = currentPosition!.latitude.toStringAsFixed(8);
//             longitude = currentPosition!.longitude.toStringAsFixed(8);
//           });
//         }
//       } catch (e) {
//
//       }
//     }
//   }
//
//   //Reason code
//   _getReasonCode() async {
//     try {
//       reasonsResponse =
//       await Reason().select().reasonId.greaterThan(0).toMapList();
//       for (int i = 0; i < reasonsResponse.length; i++) {
//         if (mounted) {
//           setState(() {
//             _nonDeliveryRemark.add(reasonsResponse[i]['remarkText']);
//             _nonDeliveryCodes.add(reasonsResponse[i]['remarkCode']);
//           });
//         }
//       }
//     } catch (e) {
//       // await LogCat().writeContent(
//       //     '${DateTimeDetails().currentDateTime()} : $runtimeType : $e.\n\n');
//     }
//   }
//
//   _getSignature() {
//     if (widget.witnessSignature == null) {
//       isLTMStatus = 0;
//     } else if (widget.witnessSignature == false) {
//       isLTMStatus = 0;
//     } else {
//       isLTMStatus = 1;
//     }
//   }
//
//   //Capture an Image from Camera
//   // Future getImage() async {
//   //   try {
//   //     imageCache.clear();
//   //     final image = await picker.getImage(
//   //         source: ImageSource.camera,
//   //         maxHeight: 150.h,
//   //         maxWidth: 150.w,
//   //         imageQuality: 90);
//   //     _capturedImageBytes = await image.readAsBytes();
//   //     File capturedImagePath = File(image.path);
//   //     if (mounted) {
//   //       setState(() {
//   //         _image = capturedImagePath;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     await LogCat().writeContent(
//   //         '${DateTimeDetails().currentDateTime()} : $runtimeType : $e.\n\n');
//   //   }
//   // }
//
//   goingBackText() {
//
//       return '${widget.articles} Article is saved in the Returns not taken';
//
//   }
//
//
//   Future<bool>? _onBackPressed() {
//     if(widget.pageredirection==0)
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => EMOScreen()),
//             (route) => false);
//     if(widget.pageredirection==1)
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => ParcelScreen()),
//               (route) => false);
//     if(widget.pageredirection==2)
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => RegisterScreen()),
//               (route) => false);
//     if(widget.pageredirection==3)
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => SpeedScreen()),
//               (route) => false);
//     if(widget.pageredirection==4)
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => DeliveryScreen()),
//               (route) => false);
//   }
//   @override
//   Widget build(BuildContext context) {
//     if (deliverStatus == null) {
//       print("Delivered status is null");
//     } else {
//       print(deliverStatus);
//     }
//
//     return WillPopScope(
//       onWillPop: () async {
//
//         bool? result = await _onBackPressed();
//         result ??= false;
//         return result;
//
//       },
//       child: Scaffold(
//         key: key,
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           appbarTitle: 'Article Delivery',
//         ),
//         body: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: EdgeInsets.all(20.0.w),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: TextFormField(
//                           initialValue: widget.articles.toString(),
//                           style: TextStyle(color: Colors.blueGrey),
//                           readOnly: true,
//                           enableInteractiveSelection: false,
//                           decoration: InputDecoration(
//                               labelText: 'Article Number',
//                               labelStyle:
//                               TextStyle(color: Color(0xFFd4af37)),
//                               prefixIcon: Icon(
//                                 Icons.email,
//                                 color: Colors.blueGrey,
//                               ),
//                               contentPadding: EdgeInsets.all(15.0.w),
//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blueAccent)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blueGrey))),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: ListTile(
//                           title: Text(
//                             'Article Type',
//                             style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.blueGrey),
//                             textAlign: TextAlign.center,
//                           ),
//                           subtitle: Text(
//                             widget.articleTypes!,
//                             style: TextStyle(
//                                 fontSize: 12.sp,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFFd4af37)),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//
//                   //Date and Time
//                   Row(
//                     children: [
//                       Expanded(
//                           flex: 4,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 height: 60.h,
//                               ),
//                               Positioned(
//                                 bottom: 0,
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width * .7,
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.all(Radius.circular(5.w)),
//                                     border: Border.all(
//                                         color: Colors.blueGrey, width: 1.0.w),
//                                   ),
//                                   child: TextFormField(
//                                     style: TextStyle(color: Colors.blueGrey),
//                                     readOnly: true,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: _currentDateTime,
//                                       focusedBorder: InputBorder.none,
//                                       labelStyle:
//                                       TextStyle(color: Color(0xFFd4af37)),
//                                       contentPadding: EdgeInsets.all(15.0.w),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               CustomHintPosition(
//                                 hintText: 'Remark time',
//                               )
//                             ],
//                           )),
//                       Expanded(
//                           flex: 1,
//                           child: IconButton(
//                             icon: (Icon(
//                               Icons.calendar_today_outlined,
//                               color: Colors.blueGrey,
//                             )),
//                             onPressed: () {
//                               setState(() {
//                                 _currentDateTime =
//                                     DateTimeDetails().currentDateTime();
//                               });
//                             },
//                           )),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//
//                   //GPS Coordinates
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 4,
//                         child: Stack(
//                           children: <Widget>[
//                             Container(
//                               height: 60.h,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width * .7,
//                                 decoration: BoxDecoration(
//                                   borderRadius:
//                                   BorderRadius.all(Radius.circular(5.w)),
//                                   border: Border.all(
//                                       color: Colors.blueGrey, width: 1.0.w),
//                                 ),
//                                 child: TextFormField(
//                                   style: TextStyle(color: Colors.blueGrey),
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: _currentLocation,
//                                     focusedBorder: InputBorder.none,
//                                     labelStyle:
//                                     TextStyle(color: Color(0xFFd4af37)),
//                                     contentPadding: EdgeInsets.all(15.0.w),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CustomHintPosition(
//                               hintText: 'GPS Location',
//                             )
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                           flex: 1,
//                           child: IconButton(
//                             icon: (Icon(
//                               MdiIcons.satelliteVariant,
//                               color: Colors.blueGrey,
//                             )),
//                             onPressed: _getUserLocation,
//                           )),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//
//                   //Delivery Status text
//                   Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.blueGrey,
//                             ),
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(5.w))),
//                         padding: EdgeInsets.symmetric(horizontal: 10.0.w),
//                         child: Row(
//                           children: [
//                             Icon(
//                               MdiIcons.emailMarkAsUnread,
//                               color: Colors.blueGrey,
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 8.0.w),
//                                 child: FormField<String>(
//                                   builder: (FormFieldState<String> state) {
//                                     return DropdownButtonHideUnderline(
//                                       child: DropdownButton(
//                                         iconEnabledColor: Colors.blueGrey,
//                                         value: widget.deliverStat == null
//                                             ? deliverStatus
//                                             : widget.deliverStat,
//                                         hint: Text(
//                                           'Article Status',
//                                           style: TextStyle(
//                                               color: Color(0xFFCFB53B)),
//                                         ),
//                                         onChanged: ( newValue) {
//                                           setState(() {
//                                             deliverStatus = newValue! as String;
//                                             _articleStatusError = null;
//                                           });
//                                         },
//                                         items: _deliverStatus.map((value) {
//                                           return DropdownMenuItem(
//                                               value: value,
//                                               child: Text(
//                                                 value,
//                                                 style: TextStyle(
//                                                     color: Colors.blueGrey),
//                                               ));
//                                         }).toList(),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   _articleStatusError == null
//                       ? SizedBox.shrink()
//                       : Text(
//                     _articleStatusError ?? "",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   SizedBox(height: 20.h),
//
//                   //UI Condition wrt delivery status
//                   deliveryStatusUI(context),
//
//                   SizedBox(height: 20.h),
//
//                   //Button
//                   RaisedButton(
//                     child: Text('DONE'),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.w),
//                         side: BorderSide(color: Colors.blueGrey)),
//                     textColor: Color(0xFFCD853F),
//                     color: Colors.white,
//                     onPressed: () {
//                       validation();
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   validation() {
//     bool _isValid = _formKey.currentState!.validate();
//
//     if (deliverStatus == null) {
//       print('article status validation');
//       setState(() =>
//       _articleStatusError = "Please select the status of the Article!");
//       _isValid = false;
//     } else if (deliverStatus == 'Delivered') {
//       print('form validation');
//       if (_addresseeTypeText == null) {
//         setState(
//                 () => _addresseeTypeError = 'Please select the type of Addressee');
//         _isValid = false;
//       }
//     } else if (deliverStatus == 'Not Delivered') {
//       print('remark validation');
//       if (_remarkText == null) {
//         setState(
//                 () => _remarkError = 'Please select the reason for not delivering');
//         _isValid = false;
//       }
//     }
//     if (_currentLocation == '') {
//       UtilFs.showToast("Location not set", context);
//       _isValid = false;
//     }
//     if (_isValid) {
//       checkStatus();
//       // addToDB();
//     }
//   }
//
//   checkStatus() async {
//     try {
//       if (deliverStatus == 'Not Delivered') {
//         addToDB();
//       } else {
//         if (deliveredToNameController.text == '' &&
//             widget.deliveredToName == null) {
//           key.currentState?.showSnackBar(new SnackBar(
//             content: Text("Delivered to not entered"),
//           ));
//         } else {
//           addToDB();
//         }
//       }
//     } catch (e) {
//
//     }
//   }
//   //
//   // signatureValidation() {
//   //   bool _isValid = _formKey.currentState!.validate();
//   //
//   //   if (deliverStatus == null) {
//   //     print('article status validation');
//   //     setState(() =>
//   //     _articleStatusError = "Please select the status of the Article!");
//   //     _isValid = false;
//   //   } else if (deliverStatus == 'Delivered') {
//   //     print('form validation');
//   //     if (_addresseeTypeText == null) {
//   //       setState(
//   //               () => _addresseeTypeError = 'Please select the type of Addressee');
//   //       _isValid = false;
//   //     }
//   //   }
//   //
//   //   if (_isValid) {
//   //     if (deliveredToNameController.text.isEmpty &&
//   //         widget.deliveredToName == null) {
//   //       key.currentState!.showSnackBar(new SnackBar(
//   //         content: Text("Please enter to whom Article was delivered to"),
//   //       ));
//   //     } else {
//   //       print("Deliver status going through is " + deliverStatus!);
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //               builder: (_) => SignatureScreen(
//   //                   widget.articles,
//   //                   widget.articleTypes,
//   //                   deliverStatus!,
//   //                   _addresseeTypeText!,
//   //                   deliveredToNameController.text == ''
//   //                       ? widget.deliveredToName!
//   //                       : deliveredToNameController.text,
//   //                   widget.addressee!)));
//   //     }
//   //   }
//   // }
//
//   addToDB() {
//     print('adding to db');
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.w),
//             ),
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(
//                       left: 20.w, top: 40.h, right: 20.w, bottom: 20.h),
//                   margin: EdgeInsets.only(top: 40.h),
//                   decoration: BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20.w),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.black,
//                             offset: Offset(0.w, 10.w),
//                             blurRadius: 10.w),
//                       ]),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       Text(
//                         'Return Confirmation',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 18.sp,
//                             color: Colors.blueGrey),
//                       ),
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       ConformationText(),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           RaisedButton.icon(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.w),
//                                   side: BorderSide(color: Colors.blueGrey)),
//                               color: Colors.white70,
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               icon: Icon(
//                                 MdiIcons.emailRemoveOutline,
//                                 color: Color(0xFFd4af37),
//                               ),
//                               label: Text(
//                                 'No',
//                                 style: TextStyle(color: Colors.blueGrey),
//                               )),
//                           RaisedButton.icon(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.w),
//                                   side: BorderSide(color: Colors.blueGrey)),
//                               color: Colors.white70,
//                               onPressed: () async {
//                                 try {
//                                   if (mounted) {
//
//                                     for (int i = 0;
//                                     i < 1;
//                                     i++) {
//                                       String onlyDate =
//                                       DateTimeDetails().onlyDate();
//                                       String onlyTime =
//                                       DateTimeDetails().onlyTime();
//                                       if (widget.articles
//                                           .toString()
//                                           .startsWith('R')) {
//                                         setState(() {
//                                           articleType = 'Registered Letter';
//                                         });
//                                       } else if (widget.articles
//                                           .toString()
//                                           .startsWith('E') &&
//                                           widget.articles
//                                               .toString()
//                                               .startsWith('M', 1)) {
//                                         setState(() {
//                                           articleType = 'EMO';
//                                         });
//                                       } else if (widget.articles
//                                           .toString()
//                                           .startsWith('E')) {
//                                         setState(() {
//                                           articleType = 'Speed Post';
//                                         });
//                                       } else if (widget.articles
//                                           .toString()
//                                           .startsWith('C') ||
//                                           widget.articles
//                                               .toString()
//                                               .startsWith('Y')) {
//                                         setState(() {
//                                           articleType = 'Business Parcel';
//                                         });
//                                       } else {
//                                         setState(() {
//                                           articleType = 'post';
//                                         });
//                                       }
//
//                                       checkWithReturns(widget.articles!);
//
//                                       if (_remarkText == _remark[0]) {
//                                         remarkCode = "8";
//                                       } else if (_remarkText == _remark[1]) {
//                                         remarkCode = "7";
//                                       } else if (_remarkText == _remark[2]) {
//                                         remarkCode = "11";
//                                       } else if (_remarkText == _remark[3]) {
//                                         remarkCode = "2";
//                                       } else if (_remarkText == _remark[4]) {
//                                         remarkCode = "19";
//                                       } else if (_remarkText == _remark[5]) {
//                                         remarkCode = "18";
//                                       } else if (_remarkText == _remark[6]) {
//                                         remarkCode = "1";
//                                       } else if (_remarkText == _remark[7]) {
//                                         remarkCode = "6";
//                                       } else if (_remarkText == _remark[8]) {
//                                         remarkCode = "14";
//                                       } else if (_remarkText == _remark[9]) {
//                                         remarkCode = "9";
//                                       } else if (_remarkText == _remark[10]) {
//                                         remarkCode = "40";
//                                       } else {
//                                         remarkCode = '';
//                                       }
// print("dfkajosljekfdnvjbliguaosdjlmnv");
//                                       final scannedArticle = ScannedArticle()
//                                         ..articleNumber = widget.articles
//                                         ..invoiceDate = onlyDate
//                                         ..beat = "BEAT 1"
//                                         ..batch = "BATCH 1"
//                                         ..facilityID = "HO21531221"
//                                         ..invoiceTime = onlyTime
//                                         ..postmanID = "10164416"
//                                         ..articleType = widget.articleTypes
//                                         ..articleStatus = deliverStatus
//                                       // ..remarkDate = remarkDate
//                                         ..remarkDate=DateTimeDetails().currentDateTime()
//                                         ..reasonCode = remarkCode
//                                         ..actionCode = "0"
//                                         ..addressee = widget.addressee
//                                         ..deliveredTo = deliverStatus ==
//                                             "Delivered"
//                                             ? widget.deliveredToName != null
//                                             ? widget.deliveredToName
//                                             : deliveredToNameController.text
//                                             : ""
//                                         ..addresseeType = _addresseeTypeText
//                                         ..latitude = latitude
//                                         ..longitude = longitude
//                                         ..isLTM = widget.signature == null
//                                             ? 0
//                                             : isLTMStatus
//                                         ..signature =
//                                         deliverStatus == "Delivered"
//                                             ? widget.signature == null
//                                             ? null
//                                             : widget.signature
//                                             : null
//                                         ..isListArticle = isListArticleList[i]
//                                         ..listCode = "N"
//                                         ..customerId = "customer id"
//                                         ..epds = 1
//                                         ..boxID = "box id"
//                                         ..isCommunicated = 0
//                                         ..rubberStamp =
//                                         deliverStatus == "Delivered"
//                                             ? _capturedImageBytes == null
//                                             ? null
//                                             : _capturedImageBytes
//                                             : null
//                                         ..remarkTime = onlyTime
//                                         ..postman = "SRUJAN"
//                                         ..deviceID =
//                                             "a45d6a4f3a15e4f" ..vpp=widget.vpp
//                                         ..sourcepin=110001
//                                         ..destpin=570010
//                                         ..cod=widget.cod
//                                         ..moneytodeliver=widget.amount
//                                         ..moneycollected= deliverStatus=="Delivered"?widget.amount:0;
//                                       scannedArticle.upsert();
//                                       if(deliverStatus=="Delivered"&&(widget.amount!>0)){
//                                         print("Entered cash table");
//
//                                         final addCash =  CashTable()
//                                           ..Cash_ID = widget.articles
//                                           ..Cash_Date = DateTimeDetails().currentDate()
//                                           ..Cash_Time = DateTimeDetails().onlyTime()
//                                           ..Cash_Type = 'Add'
//                                           ..Cash_Amount = int.parse('-${widget.amount}')
//                                           ..Cash_Description = widget.vpp=='Y'?"VPP":"COD";
//                                         await addCash.save();
//                                       }
//                                       if (deliverStatus == "Delivered")
//                                         sas.sadsync(widget.articles!);
//                                       else
//                                         sas.saudsync(widget.articles!);
//
//                                       print("kaslkfjlk");
//
//                                       var result = scannedArticle.toMap();
//                                       print("resulsjdflkasjkdfn");
//                                       printAll(result.toString());
//                                       print(result['isListArticle'].toString() +
//                                           "is the list article status");
//                                       // await TakeArticleReturn().select().articleNumber.equals(widget.articles[i]).delete();
//                                     }
//                                     print("a;ksdjhfjaklsdhfbm");
//                                     if(widget.pageredirection==0)
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => EMOScreen()),
//                                               (route) => false);
//                                     if(widget.pageredirection==1)
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => ParcelScreen()),
//                                               (route) => false);
//                                     if(widget.pageredirection==2)
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => RegisterScreen()),
//                                               (route) => false);
//                                     if(widget.pageredirection==3)
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => SpeedScreen()),
//                                               (route) => false);
//                                     if(widget.pageredirection==4)
//                                       Navigator.pushAndRemoveUntil(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => DeliveryScreen()),
//                                               (route) => false);
//
//                                     UtilFs.showToast(
//                                        'Returns taken for ${widget.articles}',
//                                         context);
//                                   }
//                                 } catch (e) {
// print(e);
//                                 }
//                               },
//                               icon: Icon(
//                                 MdiIcons.emailSendOutline,
//                                 color: Color(0xFFd4af37),
//                               ),
//                               label: Text(
//                                 'Yes',
//                                 style: TextStyle(color: Colors.blueGrey),
//                               )),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   left: 20.w,
//                   right: 20.w,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.red,
//                     radius: 40.w,
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(20.w)),
//                         child: Image.asset(
//                           "assets/images/ic_arrows.png",
//                         )),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//   }
//
//   Widget deliveryStatusUI(BuildContext context) {
//     if (deliverStatus == 'Delivered') {
//       return Form(
//         key: _deliveredFormKey,
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.blueGrey,
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(5.w))),
//                   padding: EdgeInsets.symmetric(horizontal: 10.0.w),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.person,
//                         color: Colors.blueGrey,
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: EdgeInsets.only(left: 8.0.w),
//                           child: FormField<String>(
//                             builder: (FormFieldState<String> state) {
//                               return DropdownButtonHideUnderline(
//                                 child: DropdownButton(
//                                   iconEnabledColor: Colors.blueGrey,
//                                   value: addresseeValue(),
//                                   // value: _addresseeTypeText,
//                                   hint: Text(
//                                     'Addressee Type',
//                                     style: TextStyle(color: Color(0xFFCFB53B)),
//                                   ),
//                                   onChanged: (newValue) {
//                                     setState(() {
//                                       print(newValue);
//                                       _addresseeTypeText = newValue! as String;
//                                       _addresseeTypeError = null;
//                                     });
//                                   },
//                                   items: _addresseeType.map((value) {
//                                     return DropdownMenuItem(
//                                         value: value,
//                                         child: Text(
//                                           value,
//                                           style:
//                                           TextStyle(color: Colors.blueGrey),
//                                         ));
//                                   }).toList(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             _addresseeTypeError == null
//                 ? SizedBox.shrink()
//                 : Text(
//               _addresseeTypeError ?? "",
//               style: TextStyle(color: Color(0xFFCC0000)),
//             ),
//             SizedBox(
//               height: 20.h,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   flex: 4,
//                   child: TextFormField(
//                     readOnly: widget.deliveredToName == null ? false : true,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return 'Please enter to whom Article was delivered to';
//                       }
//                       return null;
//                     },
//                     controller: widget.deliveredToName == null
//                         ? deliveredToNameController
//                         : TextEditingController(text: widget.deliveredToName),
//                     style: TextStyle(color: Colors.blueGrey),
//                     decoration: InputDecoration(
//                         labelText: 'Delivered to',
//                         labelStyle: TextStyle(color: Color(0xFFd4af37)),
//                         contentPadding: EdgeInsets.all(15.0.w),
//                         border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blueAccent)),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blueGrey))),
//                   ),
//                 ),
//                 Expanded(
//                     flex: 1,
//                     child: IconButton(
//                       icon: (Icon(
//                         Icons.person,
//                         color: Colors.blueGrey,
//                       )),
//                       onPressed: () {
//                         DateTimeDetails().onlyTime();
//                       },
//                     )),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//
//             // do not delete this. needed when signature needs to be enabled.
//
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //   children: [
//             //     RaisedButton(
//             //       shape:
//             //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey)),
//             //       color: Colors.white70,
//             //       onPressed: () => _image == null ? signatureValidation() : null,
//             //       child: Row(
//             //         children: [
//             //           Image.asset(
//             //             'assets/images/ic_signature.png',
//             //             color: Color(0xFFd4af37),
//             //             fit: BoxFit.contain,
//             //             width: 30.w,
//             //           ),
//             //           SizedBox(
//             //             width: 10.w,
//             //           ),
//             //           Text(
//             //             'Signature',
//             //             style: TextStyle(color: Colors.blueGrey),
//             //           )
//             //         ],
//             //       ),
//             //     ),
//             //     RaisedButton(
//             //       shape:
//             //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w), side: BorderSide(color: Colors.blueGrey)),
//             //       color: Colors.white70,
//             //       onPressed: () => widget.signature == null ? getImage() : null,
//             //       child: Row(
//             //         children: [
//             //           Image.asset(
//             //             'assets/images/ic_rubber_stamp.png',
//             //             color: Color(0xFFd4af37),
//             //             fit: BoxFit.contain,
//             //             width: 30.w,
//             //           ),
//             //           SizedBox(
//             //             width: 10.w,
//             //           ),
//             //           Text(
//             //             'Rubber Stamp',
//             //             style: TextStyle(color: Colors.blueGrey),
//             //           )
//             //         ],
//             //       ),
//             //     )
//             //   ],
//             // ),
//             SizedBox(
//               height: 20.h,
//             ),
//             _image == null
//                 ? Container()
//                 : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.file(
//                   _image!,
//                   height: 200.h,
//                   width: 200.w,
//                 ),
//                 IconButton(
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.blueGrey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _image?.delete();
//                         imageCache?.clear();
//                         _image = null;
//                         _capturedImageBytes = null;
//                         widget.signature = null;
//                         isLTMStatus = 0;
//                       });
//                     }),
//               ],
//             ),
//             widget.signature == null
//                 ? Container()
//                 : Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.memory(
//                   widget.signature,
//                   width: 200.w,
//                   height: 200.h,
//                 ),
//                 IconButton(
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.blueGrey,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         widget.signature = null;
//                       });
//                     }),
//               ],
//             ),
//           ],
//         ),
//       );
//     } else if (deliverStatus == 'Not Delivered') {
//       return Column(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(),
//             height: 60.h,
//             child: FormField<String>(
//               builder: (FormFieldState<String> state) {
//                 return InputDecorator(
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.person,
//                       color: Colors.blueGrey,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blueGrey),
//                       borderRadius: BorderRadius.circular(5.0),
//                     ),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                       iconEnabledColor: Colors.blueGrey,
//                       value: _remarkText,
//                       hint: Text(
//                         'Remark',
//                         style: TextStyle(color: Color(0xFFCFB53B)),
//                       ),
//                       onChanged: (newValue) {
//                         setState(() {
//                           _remarkText = newValue! as String;
//                           _remarkError = null;
//                         });
//                       },
//                       items: _remark.map((value) {
//                         return DropdownMenuItem(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(color: Colors.blueGrey),
//                             ));
//                       }).toList(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           _remarkError == null
//               ? SizedBox.shrink()
//               : Text(
//             _remarkError ?? "",
//             style: TextStyle(color: Color(0xFFCC0000)),
//           ),
//         ],
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   addresseeValue() {
//     if (widget.deliverStat == null) {
//       return _addresseeTypeText;
//     } else if (widget.addresseeTy!.isNotEmpty) {
//       return _addresseeTypeText ??= widget.addresseeTy;
//     } else {
//       return _addresseeTypeText;
//     }
//   }
//
//   printAll(String text) {
//     final pattern = new RegExp('.{1,800}');
//     pattern.allMatches(text).forEach((element) => print(element.group(0)));
//   }
//
//   checkWithReturns(String articles) async {
//     for (int i = 0; i < 1; i++) {
//       List isListArticleResponse = await ScannedArticle()
//           .select()
//           .articleNumber
//           .equals(articles)
//           .toMapList();
//       print(articles);
//       print("List Article Response");
//       print(isListArticleResponse);
//
//       // final isListArticleResponse = await TakeArticleReturn()
//       //     .select()
//       //     .articleNumber
//       //     .equals(articles)
//       //     .toMapList();
//       // print("Article status is " +
//       //     isListArticleResponse[0]['isListArticle'].toString());
//       if (isListArticleResponse[0]['isListArticle'] == 1) {
//         setState(() {
//           isListArticleStatus = 1;
//         });
//       } else {
//         setState(() {
//           isListArticleStatus = 0;
//         });
//       }
//     }
//   }
//
//   ConformationText() {
//     if ( deliverStatus == 'Delivered') {
//       print("Entered because status is Delivered");
//       return Text(
//         '${widget.articles} will be marked as Delivered/Payment of  ${"\u{20B9} ${widget.amount}"} done to ${deliveredToNameController.text.isEmpty ? widget.deliveredToName : deliveredToNameController.text}. \n \nDo you want to take Final Returns?',
//         style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
//       );
//      }
//
//     else if (
//         deliverStatus == 'Not Delivered') {
//       return Text(
//         '${widget.articles} will be marked as $_remarkText. \n\nDo you want to take Final Returns?',
//         style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
//       );
//     } else {
//       return Text(
//         'All the articles addressed to ${widget.addressee} will be marked as $_remarkText. \n \nDo you want to take Final Returns?',
//         style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
//       );
//     }
//   }
// }
