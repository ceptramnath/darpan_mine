import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'CustomAppBar.dart';
import 'DeliveryScreen.dart';
import 'EMOScreen.dart';
import 'HintPosition.dart';
import 'ParcelScreen.dart';
import 'RegisterScreen.dart';
import 'SpeedScreen.dart';

class SaveScannedEMOArticleScreen extends StatefulWidget {
  String? articles;
  String? articleTypes;
  String? deliverStat;
  String? addresseeTy;
  String? deliveredToName;
  String? cod;
  String? vpp;
  double? amount;
  var signature;
  bool? witnessSignature;
  int? pageredirection;
  double? commission;

  SaveScannedEMOArticleScreen(this.pageredirection, this.articles,
      this.articleTypes, this.cod, this.vpp, this.amount, this.commission,
      [this.deliverStat,
      this.addresseeTy,
      this.deliveredToName,
      this.signature,
      this.witnessSignature]);

  @override
  _SaveScannedEMOArticleScreenState createState() =>
      _SaveScannedEMOArticleScreenState();
}

class _SaveScannedEMOArticleScreenState
    extends State<SaveScannedEMOArticleScreen> {
  final _deliveredFormKey = GlobalKey<FormState>();
  LatLng? currentPosition;
  final key = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  List<Reason> reasons = [];
  String _currentDateTime = DateTimeDetails().currentDateTime();
  String _currentLocation = '';
  List reasonTypes = [];
  List _deliverStatus = [
    'INTIMATION SERVED',
    'DEPOSIT',
    'FOR ENQUIRY',
    'FOR REDIRECTION',
    'RETURNED TO SENDER (RTS)',
    'DELIVERY'
  ];
  String? deliverStatus;
  String? reason;
  String? action;
  List<Reason> actionText = [];
  String latitude = '';
  String longitude = '';
  Future? getDetails;
  bool actionvisible = false;

  @override
  void initState() {
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        key: key,
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appbarTitle: 'Article Delivery',
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: widget.articles.toString(),
                          style: TextStyle(color: Colors.blueGrey),
                          readOnly: true,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                              labelText: 'Article Number',
                              labelStyle: TextStyle(color: Color(0xFFd4af37)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blueGrey,
                              ),
                              contentPadding: EdgeInsets.all(15.0),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueGrey))),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                            'Article Type',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.blueGrey),
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            widget.articleTypes!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFd4af37)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //Date and Time
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Stack(
                            children: [
                              Container(
                                height: 60,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .7,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                        color: Colors.blueGrey, width: 1.0),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.blueGrey),
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: _currentDateTime,
                                      focusedBorder: InputBorder.none,
                                      labelStyle:
                                          TextStyle(color: Color(0xFFd4af37)),
                                      contentPadding: EdgeInsets.all(15.0),
                                    ),
                                  ),
                                ),
                              ),
                              CustomHintPosition(
                                hintText: 'Remark time',
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: (Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blueGrey,
                            )),
                            onPressed: () {
                              setState(() {
                                _currentDateTime =
                                    DateTimeDetails().currentDateTime();
                              });
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //GPS Coordinates
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 60,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .7,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 1.0),
                                ),
                                child: TextFormField(
                                  style: TextStyle(color: Colors.blueGrey),
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: _currentLocation,
                                    focusedBorder: InputBorder.none,
                                    labelStyle:
                                        TextStyle(color: Color(0xFFd4af37)),
                                    contentPadding: EdgeInsets.all(15.0),
                                  ),
                                ),
                              ),
                            ),
                            CustomHintPosition(
                              hintText: 'GPS Location',
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: (Icon(
                              MdiIcons.satelliteVariant,
                              color: Colors.blueGrey,
                            )),
                            onPressed: _getUserLocation,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //Delivery Status text
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blueGrey,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5))),
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.emailMarkAsUnread,
                              color: Colors.blueGrey,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        iconEnabledColor: Colors.blueGrey,
                                        value: widget.deliverStat == null
                                            ? deliverStatus
                                            : widget.deliverStat,
                                        hint: Text(
                                          'Article Status',
                                          style: TextStyle(
                                              color: Color(0xFFCFB53B)),
                                        ),
                                        onChanged: (newValue) async {
                                          setState(() {
                                            actionvisible = false;
                                            deliverStatus = newValue! as String;

                                            if (deliverStatus != "DELIVERY") {
                                              getDetails = getreasons();
                                            }
                                          });
                                        },
                                        items: _deliverStatus.map((value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ));
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  deliveryStatusUI(context),
                  //Button
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Text('SUBMIT'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blueGrey)),
                    textColor: Color(0xFFCD853F),
                    color: Colors.white,
                    onPressed: () {
                      validation();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget deliveryStatusUI(BuildContext context) {
    if (deliverStatus == "DELIVERY") {
      return Form(
        key: _deliveredFormKey,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.23,
          // width: MediaQuery.of(context).size.width*15.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: "\u{20B9} ${widget.amount}",
                    style: TextStyle(color: Colors.blueGrey),
                    readOnly: true,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                        labelText: 'EMO Amount',
                        labelStyle: TextStyle(color: Color(0xFFd4af37)),
                        contentPadding: EdgeInsets.all(15.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey))),
                  ))
            ],
          ),
        ),
      );
    } else if (deliverStatus == null) {
      return SizedBox(height: 20);
    } else {
      return FutureBuilder(
          future: getDetails,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Icon(
                                MdiIcons.emailMarkAsUnread,
                                color: Colors.blueGrey,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: FormField<String>(
                                    builder: (FormFieldState<String> state) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          iconEnabledColor: Colors.blueGrey,
                                          value: reason,
                                          hint: Text(
                                            'Reason Type',
                                            style: TextStyle(
                                                color: Color(0xFFCFB53B)),
                                          ),
                                          onChanged: (newValue) async {
                                            setState(() {
                                              actionvisible = false;
                                              reason = newValue! as String;
                                              print(
                                                  "Reason in dropdown: $reason");
                                            });
                                            actionText = await Reason()
                                                .select()
                                                .REASON_TYPE_TEXT
                                                .equals(deliverStatus)
                                                .and
                                                .REASON_NDEL_TEXT
                                                .equals(reason)
                                                .toList();
                                            print(
                                                actionText[0].REASON_NDEL_TEXT);
                                            action = actionText[0].ACTION_TEXT;
                                            setState(() {
                                              actionvisible = true;
                                            });
                                          },
                                          items: reasonTypes.map((value) {
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                      color: Colors.blueGrey),
                                                ));
                                          }).toList(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: actionvisible,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.emailMarkAsUnread,
                            color: Colors.blueGrey,
                          ),
                          Expanded(
                            flex: 1,
                            child: ListTile(
                              title: Text(
                                action!,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFd4af37)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          });
    }
  }

  validation() {
    bool _isValid = _formKey.currentState!.validate();
    if (_currentLocation == '') {
      UtilFs.showToast("Location not set", context);
      _isValid = false;
    }
    if (_isValid) {
      checkStatus();
      // addToDB();
    }
  }

  checkStatus() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 20, top: 40, right: 20, bottom: 20),
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            blurRadius: 10),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Return Confirmation',
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ConformationText(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.blueGrey)),
                              color: Colors.white70,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                MdiIcons.emailRemoveOutline,
                                color: Color(0xFFd4af37),
                              ),
                              label: Text(
                                'No',
                                style: TextStyle(color: Colors.blueGrey),
                              )),
                          RaisedButton.icon(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.blueGrey)),
                              color: Colors.white70,
                              onPressed: () async {
                                List<Reason> finalresult = [];
                                if (deliverStatus != "DELIVERY")
                                  finalresult = await Reason()
                                      .select()
                                      .REASON_TYPE_TEXT
                                      .equals(deliverStatus)
                                      .and
                                      .startBlock
                                      .REASON_NDEL_TEXT
                                      .equals(reason)
                                      .and
                                      .ACTION_TEXT
                                      .equals(action)
                                      .endBlock
                                      .toList();
                                print("finalresult");
                                print(finalresult);
                                try {
                                  // final scannedArticle=Delivery()
                                  //     ..artStatus=deliverStatus=="Delivery"?"D":"N"
                                  //     ..reasonNonDelivery=finalresult[0].resonfornonDelivery
                                  //     ..reasonType=finalresult[0].reasonType
                                  //     ..action=finalresult[0].action
                                  //     ..dateofDelivery=DateTimeDetails().oD()
                                  //     ..deliverytime=DateTimeDetails().oT()
                                  //     ..deliveryDate=DateTimeDetails().oD()
                                  //     ..beatno="BO"
                                  //     ..totalMoney=widget.amount
                                  //     ..dateofDeliveryConfirm=DateTimeDetails().oD()
                                  //     ..timeofDeliveryConfirm=DateTimeDetails().oT()
                                  //     ..postDue=0
                                  //     ..demCharge=0
                                  //     ..commission=widget.commission;
                                  print("Entered for saving");
                                  print(deliverStatus);
                                  print(widget.articles);

                                  final scannedArticle = await Delivery()
                                      .select()
                                      .ART_NUMBER
                                      .equals(widget.articles)
                                      .update({
                                    "ART_STATUS":
                                        deliverStatus == "DELIVERY" ? "F" : "G",
                                    "invoiced":deliverStatus == "DELIVERY" ? "Y":null,
                                    // "invoicedDate":deliverStatus == "DELIVERY" ? DateTimeDetails().currentDate():null,
                                    "REASON_FOR_NONDELIVERY":
                                        deliverStatus == "DELIVERY"
                                            ? null
                                            : finalresult[0].REASON_FOR_NDELI,
                                    "REASON_TYPE": deliverStatus == "DELIVERY"
                                        ? null
                                        : finalresult[0].REASON_TYPE,
                                    "ACTION": deliverStatus == "DELIVERY"
                                        ? null
                                        : finalresult[0].ACTION,
                                    "DATE_OF_DELIVERY":
                                        DateTimeDetails().onlyDate(),
                                    "DELIVERY_TIME":
                                        DateTimeDetails().dbdatetime(),
                                    'REMARK_DATE':
                                        DateTimeDetails().dbdatetime(),
                                    "DEL_DATE": DateTimeDetails().onlyDate(),
                                    "BEAT_NO": "BO",
                                    "MONEY_DELIVERED":
                                        deliverStatus == "DELIVERY"
                                            ? widget.amount
                                            : 0,
                                    "MONEY_COLLECTED":
                                        deliverStatus == "DELIVERY"
                                            ? widget.amount
                                            : 0,
                                    "DATE_OF_DELIVERY_CONFIRM":
                                        DateTimeDetails().onlyDate(),
                                    "TIME_OF_DELIVERY_CONFIRM":
                                        DateTimeDetails().oT(),
                                    "POST_DUE": 0,
                                    "DEM_CHARGE": 0,
                                    "COMMISSION": widget.commission
                                  });

//commented below code by Rakesh and added above code.
//                                      final scannedArticle=
//                                     await Delivery().select().ART_NUMBER.equals(widget.articles).
//                                     update({"ART_STATUS":deliverStatus=="DELIVERY"?"D":"N","REASON_FOR_NONDELIVERY":deliverStatus=="DELIVERY"?null:finalresult[0].REASON_FOR_NDELI,
//                                       "REASON_TYPE":deliverStatus=="DELIVERY"?null:finalresult[0].REASON_TYPE,"ACTION":deliverStatus=="DELIVERY"?null:finalresult[0].ACTION,"DATE_OF_DELIVERY":DateTimeDetails().onlyDate(),"DELIVERY_TIME":DateTimeDetails().onlyTime(),
//                                       "DEL_DATE":DateTimeDetails().onlyDate(),"BEAT_NO":"BO","MONEY_DELIVERED":deliverStatus=="DELIVERY"?widget.amount:0,"MONEY_COLLECTED":deliverStatus=="DELIVERY"?widget.amount:0,"DATE_OF_DELIVERY_CONFIRM":DateTimeDetails().onlyDate(),"TIME_OF_DELIVERY_CONFIRM":DateTimeDetails().oT(),
//                                       "POST_DUE":0,"DEM_CHARGE":0,"COMMISSION":widget.commission});

                                  print(scannedArticle.toString());
                                  if (deliverStatus != "DELIVERY") {
                                    print("Entered cash table");

                                    final addCash =  CashTable()
                                      ..Cash_ID = widget.articles
                                      ..Cash_Date = DateTimeDetails().currentDate()
                                      ..Cash_Time = DateTimeDetails().onlyTime()
                                      ..Cash_Type = 'Add'
                                      ..Cash_Amount = widget.amount!.toDouble()
                                      ..Cash_Description =
                                          "EMO Undelivered ${widget.articles}";
                                    await addCash.save();
                                    final addTransaction = TransactionTable()
                                      ..tranid =
                                          'DEL${DateTimeDetails().filetimeformat()}'
                                      ..tranDescription =
                                          "Undelivered ${widget.articles}"
                                      ..tranAmount = widget.amount!.toDouble()
                                      ..tranType = "Delivery"
                                      ..tranDate = DateTimeDetails().currentDate()
                                      ..tranTime = DateTimeDetails().onlyTime()
                                      ..valuation = "Minus";

                                    await addTransaction.save();
                                  }
                                  if (widget.pageredirection == 0)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EMOScreen()),
                                        (route) => false);
                                  if (widget.pageredirection == 1)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ParcelScreen()),
                                        (route) => false);
                                  if (widget.pageredirection == 2)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()),
                                        (route) => false);
                                  if (widget.pageredirection == 3)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SpeedScreen()),
                                        (route) => false);
                                  if (widget.pageredirection == 4)
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveryScreen()),
                                        (route) => false);
                                } catch (e) {}
                              },
                              icon: Icon(
                                MdiIcons.emailSendOutline,
                                color: Color(0xFFd4af37),
                              ),
                              label: Text(
                                'Yes',
                                style: TextStyle(color: Colors.blueGrey),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 40,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(
                          "assets/images/ic_arrows.png",
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  getreasons() async {
    reasonTypes.clear();
    reasons.clear();
    reasons =
        await Reason().select().REASON_TYPE_TEXT.equals(deliverStatus).toList();
    for (int i = 0; i < reasons.length; i++) {
      reasonTypes.add(reasons[i].REASON_NDEL_TEXT);
    }
    reason = reasonTypes[0];
    actionText = await Reason()
        .select()
        .REASON_TYPE_TEXT
        .equals(deliverStatus)
        .and
        .REASON_NDEL_TEXT
        .equals(reason)
        .toList();
    print(actionText[0].REASON_NDEL_TEXT);
    action = actionText[0].ACTION_TEXT;
    return reasonTypes.length;
  }

// Get user Current co-ordinates
  void _getUserLocation() async {
    var lpermiss = await Permission.location.status;
    if (!lpermiss.isGranted) {
      await Permission.location.request();
    } else {
      try {
        var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        if (mounted) {
          setState(() {
            currentPosition = LatLng(position.latitude, position.longitude);
            _currentLocation =
                '${currentPosition!.latitude.toStringAsFixed(8)} ' +
                    ' ${currentPosition!.longitude.toStringAsFixed(8)}';
            latitude = currentPosition!.latitude.toStringAsFixed(8);
            longitude = currentPosition!.longitude.toStringAsFixed(8);
          });
        }
      } catch (e) {}
    }
  }

  Future<bool>? _onBackPressed() {
    if (widget.pageredirection == 0)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => EMOScreen()),
          (route) => false);
    if (widget.pageredirection == 1)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ParcelScreen()),
          (route) => false);
    if (widget.pageredirection == 2)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (route) => false);
    if (widget.pageredirection == 3)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SpeedScreen()),
          (route) => false);
    if (widget.pageredirection == 4)
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => DeliveryScreen()),
          (route) => false);
  }

  ConformationText() {
    if (deliverStatus == 'DELIVERY' &&
        (widget.cod == "X" || widget.vpp == "X")) {
      return Text(
        '${widget.articles} will be marked as Delivered/Payment of ${"\u{20B9} ${widget.amount}"} collected . \n \nDo you want to take Final Returns?',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
      );
    } else if (deliverStatus == "DELIVERY") {
      return Text(
        '${widget.articles} will be marked as Delivered \n\nDo you want to take Final Returns?',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
      );
    } else if (deliverStatus != 'DELIVERY') {
      return Text(
        '${widget.articles} will be marked as $reason-$action. \n\nDo you want to take Final Returns?',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
      );
    }
    // else {
    //   return Text(
    //     'All the articles addressed to ${widget.addressee} will be marked as $_remarkText. \n \nDo you want to take Final Returns?',
    //     style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
    //   );
    // }
  }
}
