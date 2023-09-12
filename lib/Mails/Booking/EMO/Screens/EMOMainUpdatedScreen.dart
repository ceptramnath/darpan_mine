import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/AddressModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Screens/EMOUpdatedScreen.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Screens/PMOUpdatedScreen.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/MailsBookingScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/TabIndicator.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class EMOInitial extends StatefulWidget {
  const EMOInitial({Key? key}) : super(key: key);

  @override
  _EMOInitialState createState() => _EMOInitialState();
}

class _EMOInitialState extends State<EMOInitial> {
  String senderJsonName = '';
  String senderJsonAddress = '';
  String senderJsonPinCode = '';
  String senderJsonCity = '';
  String senderJsonState = '';
  String senderJsonMobile = '';
  String senderJsonEmail = '';
  String addresseeJsonName = '';
  String addresseeJsonAddress = '';
  String addresseeJsonPinCode = '';
  String addresseeJsonCity = '';
  String addresseeJsonState = '';
  String addresseeJsonMobile = '';
  String addresseeJsonEmail = '';

  List<DeliverAddress>? deliveryAddress = [];
  List<DeliverAddress>? sendingAddress = [];

  final phoneNumberController = TextEditingController();

  final phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    showPhoneDialog();
    super.initState();
  }

  showPhoneDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.toDouble()))),
            elevation: 0,
            backgroundColor: ColorConstants.kWhite,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 15, left: 8, right: 8, bottom: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter the Mobile number of the Sender',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 15,
                          color: ColorConstants.kTextColor),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: phoneNumberFocusNode,
                        maxLength: 10,
                        controller: phoneNumberController,
                        style: const TextStyle(
                            color: ColorConstants.kSecondaryColor),
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: '',
                            fillColor: ColorConstants.kWhite,
                            filled: true,
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.kWhite),
                            ),
                            prefixIcon: const Icon(Icons.phone_android),
                            labelStyle: const TextStyle(
                                color: ColorConstants.kAmberAccentColor),
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.all(15.0.toDouble()),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstants.kWhite),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0.toDouble()),
                                  bottomLeft:
                                      Radius.circular(30.0.toDouble()),
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ColorConstants.kWhite),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0.toDouble()),
                                  bottomLeft:
                                      Radius.circular(30.0.toDouble()),
                                ))),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                            buttonText: 'CANCEL',
                            buttonFunction: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EMOMainUpdatedScreen(
                                          sName: '',
                                          sAddress: '',
                                          sPinCode: '',
                                          sCity: '',
                                          sState: '',
                                          sMobile: '',
                                          sEmail: '',
                                          aName: '',
                                          aAddress: '',
                                          aPinCode: '',
                                          aCity: '',
                                          aState: '',
                                          aMobile: '',
                                          aEmail: '',
                                          isVPP: false,
                                          amount: "",
                                          artnumber: "",
                                        )))),
                        Button(
                            buttonText: 'CONFIRM',
                            buttonFunction: () {
                              if (phoneNumberController.text.isNotEmpty) {
                                senderJsonMobile = phoneNumberController.text
                                    .replaceAll(' ', '')
                                    .trim();
                                var senderData =
                                    senderAddress['sender_address'];
                                sendingAddress = senderData
                                    ?.map((e) => DeliverAddress.fromJson(e))
                                    .toList();
                                senderJsonName = sendingAddress![0].name;
                                senderJsonAddress = sendingAddress![0].address;
                                senderJsonCity = sendingAddress![0].city;
                                senderJsonState = sendingAddress![0].state;
                                senderJsonPinCode = sendingAddress![0].pincode;
                                var receiverData =
                                    deliverAddress['receiver_address'];
                                deliveryAddress = receiverData
                                    ?.map((e) => DeliverAddress.fromJson(e))
                                    .toList();
                                Navigator.pop(context);
                                showAddressDialog(
                                    sendingAddress![0].name,
                                    sendingAddress![0].address,
                                    sendingAddress![0].city,
                                    sendingAddress![0].state,
                                    sendingAddress![0].pincode,
                                    phoneNumberController.text
                                        .replaceAll(' ', '')
                                        .trim());
                              } else {
                                Toast.showFloatingToast(
                                    'Please enter the phone number', context);
                                phoneNumberFocusNode.requestFocus();
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  showAddressDialog(String name, String address, String city, String state,
      String pinCode, String mobile) async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10.toDouble()))),
                elevation: 0,
                backgroundColor: ColorConstants.kWhite,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 15, left: 8, right: 8, bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0.toDouble()),
                          child: Text(
                            'List of Addresses sent from the entered mobile number',
                            style: TextStyle(
                                letterSpacing: 1,
                                fontSize: 15,
                                color: ColorConstants.kTextColor),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: deliveryAddress!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        CheckboxListTile(
                                            activeColor: Colors.pink[300],
                                            dense: true,
                                            title: Text(
                                              deliveryAddress![index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  DialogListTile(
                                                      title: 'Address : ',
                                                      description:
                                                          deliveryAddress![
                                                                      index]
                                                                  .address +
                                                              ", " +
                                                              deliveryAddress![
                                                                      index]
                                                                  .city +
                                                              ", " +
                                                              deliveryAddress![
                                                                      index]
                                                                  .state +
                                                              " " +
                                                              deliveryAddress![
                                                                      index]
                                                                  .pincode),
                                                  deliveryAddress![index]
                                                          .mobileNumber
                                                          .isNotEmpty
                                                      ? Text(
                                                          deliveryAddress![
                                                                  index]
                                                              .mobileNumber,
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .kTextDark,
                                                              letterSpacing: 1))
                                                      : Container(),
                                                  deliveryAddress![index]
                                                          .email
                                                          .isNotEmpty
                                                      ? Text(
                                                          deliveryAddress![
                                                                  index]
                                                              .email,
                                                          style: const TextStyle(
                                                              color:
                                                                  ColorConstants
                                                                      .kTextDark,
                                                              letterSpacing: 1))
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                            value: deliveryAddress![index]
                                                .checkValue,
                                            onChanged: (bool? val) {
                                              setState(() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            EMOMainUpdatedScreen(
                                                              sName: name,
                                                              sAddress: address,
                                                              sPinCode: pinCode,
                                                              sCity: city,
                                                              sState: state,
                                                              sMobile: mobile,
                                                              sEmail: '',
                                                              aName:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .name,
                                                              aAddress:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .address,
                                                              aPinCode:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .pincode,
                                                              aCity:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .city,
                                                              aState:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .state,
                                                              aMobile:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .mobileNumber,
                                                              aEmail:
                                                                  deliveryAddress![
                                                                          index]
                                                                      .email,
                                                              isVPP: false,
                                                              amount: "",
                                                              artnumber: "",
                                                            )));
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Button(
                            buttonText: 'CANCEL',
                            buttonFunction: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EMOMainUpdatedScreen(
                                          sName: name,
                                          sAddress: address,
                                          sPinCode: pinCode,
                                          sCity: city,
                                          sState: state,
                                          sMobile: mobile,
                                          sEmail: '',
                                          aName: '',
                                          aAddress: '',
                                          aPinCode: '',
                                          aCity: '',
                                          aState: '',
                                          aMobile: '',
                                          aEmail: '',
                                          isVPP: false,
                                          amount: "",
                                          artnumber: "",
                                        ))))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        backgroundColor: ColorConstants.kPrimaryColor,
      ),
    );
  }
}

class EMOMainUpdatedScreen extends StatefulWidget {
  String? sName;
  String? sAddress;
  String? sPinCode;
  String? sCity;
  String? sState;
  String? sMobile;
  String? sEmail;
  String? aName;
  String? aAddress;
  String? aPinCode;
  String? aCity;
  String? aState;
  String? aMobile;
  String? aEmail;
  bool isVPP;
  String? amount;
  String? artnumber;

  EMOMainUpdatedScreen(
      {Key? key,
      required this.sName,
      required this.sAddress,
      required this.sPinCode,
      required this.sCity,
      required this.sState,
      required this.sMobile,
      required this.sEmail,
      required this.aName,
      required this.aAddress,
      required this.aPinCode,
      required this.aCity,
      required this.aState,
      required this.aMobile,
      required this.aEmail,
      required this.isVPP,
      required this.amount,
      required this.artnumber})
      : super(key: key);

  @override
  _EMOMainUpdatedScreenState createState() => _EMOMainUpdatedScreenState();
}

class _EMOMainUpdatedScreenState extends State<EMOMainUpdatedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const BookingMainScreen()),
              (route) => false);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => BookingMainScreen()),
                  (route) => false),
            ),
            backgroundColor: ColorConstants.kPrimaryColor,
            bottom: TabBar(
              controller: _controller,
              indicator: CircleTabIndicator(color: Colors.white, radius: 3),
              tabs: const [
                Tab(
                  child: TabTextStyle(
                    title: 'EMO',
                  ),
                ),
                Tab(
                  child: TabTextStyle(
                    title: 'PMO Relief Fund',
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _controller,
            children: [
              EMOUpdatedScreen(
                sName: widget.sName,
                sAddress: widget.sAddress,
                sPinCode: widget.sPinCode,
                sCity: widget.sCity,
                sState: widget.sState,
                sMobile: widget.sMobile,
                sEmail: widget.sEmail,
                aName: widget.aName,
                aAddress: widget.aAddress,
                aPinCode: widget.aPinCode,
                aCity: widget.aCity,
                aState: widget.aState,
                aMobile: widget.aMobile,
                aEmail: widget.aEmail,
                emoValue: widget.amount,
                isVPP: widget.isVPP,
                artnumber: "",
              ),
              PMOUpdatedScreen(
                  sName: widget.sName,
                  sAddress: widget.sAddress,
                  sPinCode: widget.sPinCode,
                  sCity: widget.sCity,
                  sState: widget.sState,
                  sMobile: widget.sMobile,
                  sEmail: widget.sEmail)
            ],
          ),
        ),
      ),
    );
  }
}
