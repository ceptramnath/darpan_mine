import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Calculations.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMOConformationDialog.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Widgets/CustomToast.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/TotalFAB.dart';
import 'package:darpan_mine/Widgets/TotalToast.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:darpan_mine/main.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../LogCat.dart';
import '../../BookingMainScreen.dart';

class EMOUpdatedScreen extends StatefulWidget {
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
  String? emoValue;
  bool? isVPP;
  String? artnumber;

  EMOUpdatedScreen(
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
      required this.emoValue,
      required this.isVPP,
      this.artnumber})
      : super(key: key);

  @override
  _EMOUpdatedScreenState createState() => _EMOUpdatedScreenState();
}

class _EMOUpdatedScreenState extends State<EMOUpdatedScreen> {
  int amountToBeCollected = 0;

  String? _chosenMsg;
  String? _chosenArt;


  final formGlobalKey = GlobalKey<FormState>();

  bool msgVisibility = false;
  bool vpartVisibility = false;
  bool senderFormOpenFlag = false;
  bool senderNotCompleted = false;
  bool senderPinCode = false;
  bool payeeFormOpenFlag = false;
  bool payeeNotCompleted = false;
  bool payeePinCode = false;
  List<String> vplist=[];

  Color senderHeadingColor = ColorConstants.kPrimaryAccent;
  Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;

  final emoValueFocusNode = FocusNode();
  final commissionFocusNode = FocusNode();
  final senderNameFocusNode = FocusNode();
  final senderAddressFocusNode = FocusNode();
  final senderPinCodeFocusNode = FocusNode();
  final senderMobileFocusNode = FocusNode();
  final senderEmailFocusNode = FocusNode();
  final payeeNameFocusNode = FocusNode();
  final payeeAddressFocusNode = FocusNode();
  final payeePinCodeFocusNode = FocusNode();
  final payeeMobileFocusNode = FocusNode();
  final payeeEmailFocusNode = FocusNode();

  final emoValueController = TextEditingController();
  final commissionController = TextEditingController();
  final senderNameController = TextEditingController();
  final senderAddressController = TextEditingController();
  final senderPinCodeController = TextEditingController();
  final senderCityController = TextEditingController();
  final senderStateController = TextEditingController();
  final senderMobileNumberController = TextEditingController();
  final senderEmailController = TextEditingController();
  final addresseeNameController = TextEditingController();
  final addresseeAddressController = TextEditingController();
  final addresseePinCodeController = TextEditingController();
  final addresseeCityController = TextEditingController();
  final addresseeStateController = TextEditingController();
  final addresseeMobileNumberController = TextEditingController();
  final addresseeEmailController = TextEditingController();

  String date = '';
  String time = DateTimeDetails().onlyTime();

  var currentDate =
      DateTimeDetails().onlyDate().toString().replaceAll(RegExp('-'), '');
  var currentTime =
      DateTimeDetails().onlyTime().toString().replaceAll(RegExp(':'), '');

  String PNRNumber = "";

  currentDateTime() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    setState(() {
      date = formatter.format(now);
    });
  }

  @override
  void initState() {
    currentDateTime();
    emoValueController.text = widget.emoValue.toString();
    setState(() {});
    emoValueFocusNode.addListener(() {
      var commission = 0;
      if (!emoValueFocusNode.hasFocus && emoValueController.text.length>0) {
        commissionAmt = 0;
        commission = double.parse(emoValueController.text) ~/ 20;
        double.parse(emoValueController.text) % 20 != 0
            ? commission += 1
            : commission += 0;
        commissionAmt = commission.toInt();
        setState(() {
          commissionController.text = commissionAmt.toString();
        });
      }

    });
    enterFetchedValuesToTextField();
    super.initState();
  }

  getEmoCal() async {
    emoValueFocusNode.addListener(() {
      var commission = 0;
      if (!emoValueFocusNode.hasFocus) {
        commissionAmt = 0;
        commission = double.parse(emoValueController.text) ~/ 20;
        double.parse(emoValueController.text) % 20 != 0
            ? commission += 1
            : commission += 0;
        commissionAmt = commission.toInt();
        setState(() {
          commissionController.text = commissionAmt.toString();
        });
      }
    });
  }

  getCommission() {
    var commission = 0;

    commissionAmt = 0;
    commission = double.parse(emoValueController.text) ~/ 20;
    double.parse(emoValueController.text) % 20 != 0
        ? commission += 1
        : commission += 0;
    commissionAmt = commission.toInt();
    setState(() {
      commissionController.text = commissionAmt.toString();
    });
  }

  enterFetchedValuesToTextField() {
    widget.sName!.isNotEmpty ? senderNameController.text = widget.sName! : null;
    widget.sAddress!.isNotEmpty
        ? senderAddressController.text = widget.sAddress!
        : null;
    widget.sPinCode!.isNotEmpty
        ? senderPinCodeController.text = widget.sPinCode!
        : null;
    widget.sCity!.isNotEmpty ? senderCityController.text = widget.sCity! : null;
    widget.sState!.isNotEmpty
        ? senderStateController.text = widget.sState!
        : null;
    widget.sMobile!.isNotEmpty
        ? senderMobileNumberController.text = widget.sMobile!
        : null;
    widget.sEmail!.isNotEmpty
        ? senderEmailController.text = widget.sEmail!
        : null;
    widget.aName!.isNotEmpty
        ? addresseeNameController.text = widget.aName!
        : null;
    widget.aAddress!.isNotEmpty
        ? addresseeAddressController.text = widget.aAddress!
        : null;
    widget.aPinCode!.isNotEmpty
        ? addresseePinCodeController.text = widget.aPinCode!
        : null;
    widget.aCity!.isNotEmpty
        ? addresseeCityController.text = widget.aCity!
        : null;
    widget.aState!.isNotEmpty
        ? addresseeStateController.text = widget.aState!
        : null;
    widget.aMobile!.isNotEmpty
        ? addresseeMobileNumberController.text = widget.aMobile!
        : null;
    widget.aEmail!.isNotEmpty
        ? addresseeEmailController.text = widget.aEmail!
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      floatingActionButton: TotalFAB(
        title: '\u{20B9} ${getTotalAmount()}',
        function: () {
          ToastUtil.show(
              TotalToast(totalAmount: amountToBeCollected.toString()), context,
              gravity: ToastGravity.bottom);
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.toDouble()),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Article Details
                /*
                CInputForm(
                    readOnly: widget.isVPP!,
                    iconData: MdiIcons.currencyInr,
                    labelText: 'EMO Value *',
                    controller: emoValueController,
                    textType: TextInputType.text,
                    typeValue: 'EMOValue',
                    focusNode: emoValueFocusNode),
*/

                Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.toDouble(), vertical: 5.toDouble()),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _chosenMsg,
                      style: const TextStyle(
                          color: ColorConstants.kSecondaryColor),
                      underline: Container(),
                      items: messageCodes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        "Please select the message code",
                        style: TextStyle(
                          color: ColorConstants.kAmberAccentColor,
                        ),
                      ),
                      onChanged: (String? value) async {
                        if(value=="VPMO")
                          {
                            emoValueController.text="";
                            commissionController.text= "";
                            final vpselect =(await VPPEMO().select()
                                .EMO_NUMBER.isNull()
                                .and
                                .DATE_OF_DELIVERY
                                .equals(DateTimeDetails().onlyDate()).toMapList()) ;

                        if(vpselect.length > 0) {
                        for(int i=0;i<vpselect.length;i++)
                        vplist.add(vpselect[i]["VP_ART"].toString());

                        vpartVisibility = true;

                        }
                        else
                        {
                          UtilFs.showToast("NO Pending VP articles", context);
                        setState(() {
                          vpartVisibility = false;
                          _chosenMsg = "";

                        });

                        }

                          }
                        else
                          {
                            setState(() {
                              vpartVisibility = false;
                              vplist=[];
                              emoValueFocusNode.requestFocus();
                              widget.isVPP=false;
                            });
                            emoValueController.text="";
                            commissionController.text= "";

                          }
                        if(value=="VPMO")
                          setState(() {
                            widget.isVPP=true;
                          });

                        // if (widget.isVPP == true) {
                        //   getCommission();
                        // }
                        setState(() {
                          msgVisibility = false;
                          _chosenMsg = value;
                        });

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Visibility(
                      visible: widget.isVPP == true ? false : msgVisibility,
                      child: Text(
                        'Please select a message',
                        style: TextStyle(
                            fontSize: 10.toDouble(),
                            color: ColorConstants.kPrimaryColor),
                      )),
                ),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.0.toDouble(), vertical: 5.toDouble()),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _chosenArt,
                      style: const TextStyle(
                          color: ColorConstants.kSecondaryColor),
                      underline: Container(),
                      items: vplist
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: const Text(
                        "Please select the VP article",
                        style: TextStyle(
                          color: ColorConstants.kAmberAccentColor,
                        ),
                      ),
                      onChanged: (String? value) async {
                        setState(() {
                          _chosenArt = value;

                        });
                        print(await VPPEMO().select()
                           .toMapList());
                        final vpdetail =(await VPPEMO().select()
                            .EMO_NUMBER.isNull()
                            .and
                            .VP_ART.equals(_chosenArt)
                            .and
                            .DATE_OF_DELIVERY
                            .equals(DateTimeDetails().onlyDate()).toMapList()) ;
                        emoValueController.text= vpdetail[0]["MONEY_TO_BE_COLLECTED"].toString().split('.').first;
                        commissionController.text= vpdetail[0]["COMMISSION"].toString().split('.').first;
                        await getCommission();
                        await getTotalAmount();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Visibility(
                      visible: vpartVisibility,
                      child: Text(
                        'Please select the VP article',
                        style: TextStyle(
                            fontSize: 10.toDouble(),
                            color: ColorConstants.kPrimaryColor),
                      )),
                ),
                CAdditionalServiceForm(
                  isVPP: widget.isVPP,
                  labelText: 'EMO Value *',
                  focusNode: emoValueFocusNode,
                  controller: emoValueController,
                  typeValue: 'EMOValue',
                  iconData: MdiIcons.currencyInr,
                ),
                CInputForm(
                    readOnly: true,
                    iconData: MdiIcons.currencyInr,
                    labelText: 'Commission',
                    controller: commissionController,
                    textType: TextInputType.text,
                    typeValue: 'Commission',
                    focusNode: commissionFocusNode),
                const DoubleSpace(),

                //Sender Details
                const Divider(),
                Text(
                  'Sender Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: senderHeadingColor,
                      fontSize: 20.toDouble(),
                      letterSpacing: 1),
                ),
                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.cellphone,
                  labelText: 'Mobile Number(for SMS *)',
                  controller: senderMobileNumberController,
                  textType: TextInputType.number,
                  typeValue: 'MobileNumber',
                  focusNode: senderMobileFocusNode,
                ),
                CInputForm(
                  readOnly: false,
                  iconData: Icons.person,
                  labelText: 'Name *',
                  controller: senderNameController,
                  textType: TextInputType.text,
                  typeValue: 'Name',
                  focusNode: senderNameFocusNode,
                ),
                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.home,
                  labelText: 'Address *',
                  controller: senderAddressController,
                  textType: TextInputType.multiline,
                  typeValue: 'Address',
                  focusNode: senderAddressFocusNode,
                ),
                Card(
                  elevation: 0,
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: const TextStyle(
                            color: ColorConstants.kSecondaryColor),
                        controller: senderPinCodeController,
                        autofocus: false,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: ColorConstants.kSecondaryColor,
                            ),
                            fillColor: ColorConstants.kWhite,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.kWhite),
                            ),
                            labelText: 'Pincode/Office Name *',
                            labelStyle: TextStyle(
                                color: ColorConstants.kAmberAccentColor),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite)))),
                    onSuggestionSelected:
                        (Map<String, String> suggestion) async {
                      senderPinCode = false;
                      senderPinCodeController.text = suggestion['pinCode']!;
                      senderCityController.text = suggestion['city']!;
                      senderStateController.text = suggestion['state']!;
                    },
                    itemBuilder: (context, Map<String, String> suggestion) {
                      return ListTile(
                        title: Text(suggestion['officeName']! +
                            ", " +
                            suggestion['pinCode']!),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      return await FetchPin.getSuggestions(pattern);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        senderPinCode = true;
                      }
                    },
                  ),
                ),
                Visibility(
                    visible: senderPinCode,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Select a Pincode/Office name',
                            style: TextStyle(
                                color: ColorConstants.kPrimaryColor,
                                fontSize: 10),
                          ),
                        ))),
                Visibility(
                  visible: true,
                  // senderPinCodeController.text.isEmpty ? false : true,
                  child: CInputForm(
                    readOnly: true,
                    iconData: Icons.location_city,
                    labelText: 'City',
                    controller: senderCityController,
                    textType: TextInputType.text,
                    typeValue: 'City',
                    focusNode: senderPinCodeFocusNode,
                  ),
                ),
                Visibility(
                  visible: true,
                  // senderPinCodeController.text.isEmpty ? false : true,
                  child: CInputForm(
                    readOnly: true,
                    iconData: Icons.location_city,
                    labelText: 'State',
                    controller: senderStateController,
                    textType: TextInputType.text,
                    typeValue: 'City',
                    focusNode: senderPinCodeFocusNode,
                  ),
                ),

                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.email,
                  labelText: 'Email',
                  controller: senderEmailController,
                  textType: TextInputType.emailAddress,
                  typeValue: 'Email',
                  focusNode: senderEmailFocusNode,
                ),
                const Space(),

                //Addressee Details
                Text(
                  'Addressee Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: senderHeadingColor,
                      fontSize: 20.toDouble(),
                      letterSpacing: 1),
                ),
                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.cellphone,
                  labelText: 'Mobile Number',
                  controller: addresseeMobileNumberController,
                  textType: TextInputType.number,
                  typeValue: 'MobileNumber',
                  focusNode: payeeMobileFocusNode,
                ),
                CInputForm(
                  readOnly: false,
                  iconData: Icons.person,
                  labelText: 'Name *',
                  controller: addresseeNameController,
                  textType: TextInputType.text,
                  typeValue: 'Name',
                  focusNode: payeeNameFocusNode,
                ),
                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.home,
                  labelText: 'Address *',
                  controller: addresseeAddressController,
                  textType: TextInputType.multiline,
                  typeValue: 'Address',
                  focusNode: payeeAddressFocusNode,
                ),
                Card(
                  elevation: 0,
                  child: TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                        style: const TextStyle(
                            color: ColorConstants.kSecondaryColor),
                        controller: addresseePinCodeController,
                        autofocus: false,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: ColorConstants.kSecondaryColor,
                            ),
                            fillColor: ColorConstants.kWhite,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.kWhite),
                            ),
                            labelText: 'Pincode/Office Name *',
                            labelStyle: TextStyle(
                                color: ColorConstants.kAmberAccentColor),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite)))),
                    onSuggestionSelected:
                        (Map<String, String> suggestion) async {
                      payeePinCode = false;
                      addresseePinCodeController.text = suggestion['pinCode']!;
                      addresseeCityController.text = suggestion['city']!;
                      addresseeStateController.text = suggestion['state']!;
                    },
                    itemBuilder: (context, Map<String, String> suggestion) {
                      return ListTile(
                        title: Text(suggestion['officeName']! +
                            ", " +
                            suggestion['pinCode']!),
                      );
                    },
                    suggestionsCallback: (pattern) async {
                      return await FetchPin.getSuggestions(pattern);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        payeePinCode = true;
                      }
                    },
                  ),
                ),
                Visibility(
                    visible: payeePinCode,
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Select a Pincode/Office name',
                            style: TextStyle(
                                color: ColorConstants.kPrimaryColor,
                                fontSize: 10),
                          ),
                        ))),
                Visibility(
                  visible: true,
                  // addresseePinCodeController.text.isEmpty ? false : true,
                  child: CInputForm(
                    readOnly: true,
                    iconData: Icons.location_city,
                    labelText: 'City',
                    controller: addresseeCityController,
                    textType: TextInputType.text,
                    typeValue: 'City',
                    focusNode: payeePinCodeFocusNode,
                  ),
                ),
                Visibility(
                  visible: true,
                  // addresseePinCodeController.text.isEmpty ? false : true,
                  child: CInputForm(
                    readOnly: true,
                    iconData: Icons.location_city,
                    labelText: 'State',
                    controller: addresseeStateController,
                    textType: TextInputType.text,
                    typeValue: 'City',
                    focusNode: payeePinCodeFocusNode,
                  ),
                ),

                CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.email,
                  labelText: 'Email',
                  controller: addresseeEmailController,
                  textType: TextInputType.emailAddress,
                  typeValue: 'Email',
                  focusNode: payeeEmailFocusNode,
                ),
                Visibility(
                    visible: payeeNotCompleted,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0.toDouble()),
                      child: const Text(
                        'Enter the Payee details',
                        style: TextStyle(
                            fontSize: 10, color: ColorConstants.kPrimaryAccent),
                      ),
                    )),

                //Submit
                Padding(
                  padding: EdgeInsets.all(8.0.toDouble()),
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorConstants.kWhite),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.toDouble()),
                                      side: const BorderSide(
                                          color: ColorConstants
                                              .kSecondaryColor)))),
                      onPressed: () async {
                        if (!messageCodes.contains(_chosenMsg)) {
                          UtilFs.showToast("Please select proper eMO message..!", context);
                        }
                        else {
                          setState(() {
                            emoValueFocusNode.unfocus();
                          });
                          await getTotalAmount();
                          if (_chosenMsg.toString() == 'null') {
                            setState(() {
                              msgVisibility = true;
                            });
                          }
                          if (senderNameController.text.isEmpty ||
                              senderAddressController.text.isEmpty ||
                              senderCityController.text.isEmpty)
                            senderNotCompleted = true;
                          if (addresseeNameController.text.isEmpty ||
                              addresseeAddressController.text.isEmpty ||
                              addresseeCityController.text.isEmpty) {
                            payeeNotCompleted = true;
                          }

                          if(senderNameController.text.isEmpty ||
                              senderAddressController.text.isEmpty ||
                              senderCityController.text.isEmpty|| senderPinCodeController.text.isEmpty)
                            {
                              UtilFs.showToast("Please enter Sender Details!", context);
                            }
                          if(addresseeNameController.text.isEmpty ||
                              addresseeAddressController.text.isEmpty ||
                              addresseeCityController.text.isEmpty|| addresseePinCodeController.text.isEmpty)
                          {
                            UtilFs.showToast("Please enter Addressee Details!", context);
                          }

                          if (formGlobalKey.currentState!.validate()) {
                            formGlobalKey.currentState!.save();
                            await PNRGeneration();
                            showDialog<void>(
                                context: context,
                                // context: navigatorKey.currentContext!,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  print('PNR Number before dialog' +
                                      PNRNumber.toString());
                                  return EMOConformationDialog(
                                      pnrNumber: PNRNumber.toString(),
                                      emoValue: emoValueController.text,
                                      message: widget.isVPP ==true ? _chosenArt.toString() : _chosenMsg.toString(),
                                      commission: commissionAmt.toString(),
                                      amountToBeCollected:
                                          (emoValueAmt + commissionAmt)
                                              .toString(),
                                      senderName: senderNameController.text,
                                      senderAddress:
                                          senderAddressController.text,
                                      senderPinCode:
                                          senderPinCodeController.text,
                                      senderCity: senderCityController.text,
                                      senderState: senderStateController.text,
                                      senderMobileNumber:
                                          senderMobileNumberController.text,
                                      senderEmail: senderEmailController.text,
                                      addresseeName:
                                          addresseeNameController.text,
                                      addresseeAddress:
                                          addresseeAddressController.text,
                                      addresseePinCode:
                                          addresseePinCodeController.text,
                                      addresseeCity:
                                          addresseeCityController.text,
                                      addresseeState:
                                          addresseeStateController.text,
                                      addresseeMobileNumber:
                                          addresseeMobileNumberController.text,
                                      addresseeEmail:
                                          addresseeEmailController.text,
                                      isVPP: widget.isVPP!,
                                      function: () async {
                                        await bookFunction(widget.isVPP!);
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             const BookingMainScreen()),
                                        //     (route) => false);
                                      });
                                });
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0.toDouble()),
                        child: const Text(
                          'SUBMIT',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ColorConstants.kAmberAccentColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getTotalAmount() {
    emoValueController.text.isEmpty
        ? emoValueAmt = 0
        : emoValueAmt = int.parse(emoValueController.text);
    setState(() {
      amountToBeCollected = emoValueAmt + commissionAmt;
    });
    if (amountToBeCollected < 0) amountToBeCollected = 0;
    if (emoValueController.text.isEmpty) amountToBeCollected = 0;
    print("EMO Value Details are:$emoValueAmt $commissionAmt");
    return amountToBeCollected.toString();
  }

  bookFunction(bool isVPP) async {
    try {
      print('inside bookFunction eMO..!');

      final fetchFileMaster =
          await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toCount();

      if (fetchFileMaster == 0) {
        print('Inserting File Master Data..!');
        final fileMaster = await FILEMASTERDATA()
          ..FILETYPE = "BOOKING"
          ..DIVISION = "MO"
          ..ORDERTYPE_SP = "ZPP"
          ..ORDERTYPE_LETTERPARCEL = "ZAM"
          ..ORDERTYPE_EMO = "ZFS"
          ..PRODUCT_TYPE = 'S'
          ..MATERIALGROUP_SP = "DPM"
          ..MATERIALGROUP_LETTER = "DOM"
          ..MATERIALGROUP_EMO = "DMR";

        fileMaster.save();
      }

      final fileMaster =
          await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
      // print(senderAddressController.text.replaceAll('\n', '  ') +
      //     " and " +
      //     addresseeAddressController.text.replaceAll('\n', '  '));

      print("Value of Is VPP is: $isVPP");
      await BookingDBService().addEMOToDB(
          PNRNumber.toString(),
          DateTimeDetails().currentDate(),
          DateTimeDetails().timeCharacter(),
          amountToBeCollected.toString(),
          amountToBeCollected.toString(),
          fileMaster[0].ORDERTYPE_EMO.toString(),
          fileMaster[0].PRODUCT_TYPE.toString(),
          'V2', //valueCode
          // //Changed for resolving the VPMON issue
          // isVPP ? 'V44' : 'V2',//valueCode
          emoValueController.text,
          senderNameController.text,
          senderAddressController.text.replaceAll('\n', '  '),
          senderCityController.text,
          senderStateController.text,
          senderPinCodeController.text,
          addresseeNameController.text,
          addresseeAddressController.text.replaceAll('\n', '  '),
          addresseeCityController.text,
          addresseeStateController.text,
          addresseePinCodeController.text,
          addresseeMobileNumberController.text,
          addresseeEmailController.text,
          commissionController.text,
          emoValueController.text,
          isVPP ==true ? _chosenArt.toString() : _chosenMsg.toString(),
          isVPP);
      final checkeMOTable = await EmoBooking()
          .select()
          .ArticleNumber
          .equals(PNRNumber.toString())
          .toList();
      print("Check eMO Table");
      print(checkeMOTable.length);
      if (checkeMOTable.length > 0) {
        BookingDBService().addTransaction(
            PNRNumber.toString(),
            'Booking',
            isVPP ? 'VPMO' : 'EMO Booking',
            DateTimeDetails().currentDate(),
            DateTimeDetails().onlyTime(),
            amountToBeCollected.toString(),
            'Add');
        final checkTransTable = await TransactionTable()
            .select()
            .tranid
            .equals(PNRNumber.toString())
            .toList();
        print("Check Trans Table");
        print(checkTransTable.length);

        if (checkTransTable.length > 0) {
          final addCash =  CashTable()
            ..Cash_ID = isVPP ? widget.artnumber : PNRNumber.toString()
            ..Cash_Date = DateTimeDetails().currentDate()
            ..Cash_Time = DateTimeDetails().onlyTime()
            ..Cash_Type = 'Add'
            ..Cash_Amount = amountToBeCollected.toDouble()
            ..Cash_Description = isVPP ? 'VPMO' : 'EMO Booking';
          await addCash.save();

          // Updating the emo number in the VPEMO table after VPMO booking.
          if(isVPP == true)
            {
              await VPPEMO()
                  .select()
                  .VP_ART
                  .equals(_chosenArt)
                  .update({'EMO_NUMBER': PNRNumber.toString()});
              print(await VPPEMO().select()
                  .toMapList());
              print(await EmoBooking().select().ArticleNumber.equals(PNRNumber.toString())
                  .toMapList());
            }
        }
      }
    } catch (e) {
      await LogCat()
          .writeContent("Error in eMO Booking" + e.toString() + " \n\n");
    }
  }

  PNRGeneration() async {
    final eMOCode = await OFCMASTERDATA().select().toList();
    String legacycode = eMOCode[0].EMOCODE.toString();
    print("Unix Time Stamp- ");
    String date = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    print(date);
    print(date.substring(0, date.length - 3));

    String unixTime = date.substring(0, date.length - 3);

    PNRNumber = legacycode + unixTime; //+'001';

    print("PNR Number inside function - " + PNRNumber);
    // return PNRNumber;
  }
}
