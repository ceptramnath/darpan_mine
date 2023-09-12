import 'dart:async';

import 'package:darpan_mine/Constants/Calculations.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages//TypeAhead/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Widgets/CustomToast.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/TotalFAB.dart';
import 'package:darpan_mine/Widgets/TotalToast.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../Widgets/RLConformationDialog.dart';
import 'MailsBookingScreen.dart';

double? maxWeight;

class RegisterLetterBookingScreen1 extends StatefulWidget {
  var fees;

  RegisterLetterBookingScreen1({required this.fees});

  @override
  _RegisterLetterBookingScreen1State createState() =>
      _RegisterLetterBookingScreen1State();
}

class _RegisterLetterBookingScreen1State
    extends State<RegisterLetterBookingScreen1> {
  String date = '';
  String time = '';

  currentDateTime() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    final String formattedTime = DateFormat.jm().format(now).toString();
    setState(() {
      date = formatter.format(now);
      time = formattedTime;
    });
  }

  @override
  void initState() {
    currentDateTime();
    senderNotCompleted = false;
    addresseeNotCompleted = false;
    Fees().getRegistrationFees('LETTER');
    Fees().getValidations('LETTER');
    weightFocusNode.addListener(() {
      if (!weightFocusNode.hasFocus) {
        Fees().getWeightAmount(int.parse(weightController.text), 'LETTER');
      }
    });
    insuranceFocusNode.addListener(() {
      if (!insuranceFocusNode.hasFocus) {
        Fees().getInsuranceAmount(int.parse(insuranceController.text));
      }
    });
    valuePayableFocusNode.addListener(() {
      if (!valuePayableFocusNode.hasFocus) {
        Fees().getVPPAmount(int.parse(valuePayablePostController.text));
      }
    });
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => checkColor());
    super.initState();
  }

  getTotalAmount() {
    prepaidAmountController.text.isNotEmpty
        ? ppAmt = double.parse(prepaidAmountController.text)
        : ppAmt = 0.0;
    acknowledgementCheck ? ackAmt = 3.0 : ackAmt = 0.0;
    insuranceCheck ? insAmt = insAmt : insAmt = 0;
    insuranceCheck ? ackAmt = 0 : null;
    valuePayableCheck ? vppAmt = vppAmt : vppAmt = 0;
    setState(() {
      amountToBeCollected =
          (weightAmt + insAmt + vppAmt + ackAmt - ppAmt + registrationFee)
              .toInt();
    });
    if (amountToBeCollected < 0) amountToBeCollected = 0;
    if (articleNumberController.text.isEmpty) amountToBeCollected = 0;
    return amountToBeCollected.toString();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Timer? timer;
  var count;

  final formGlobalKey = GlobalKey<FormState>();

  int amountToBeCollected = 0;
  String _scanBarcode = 'Unknown';

  bool isLoading = false;
  bool acknowledgementCheck = false;
  bool insuranceCheck = false;
  bool valuePayableCheck = false;
  bool senderFormOpenFlag = false;
  bool senderNotCompleted = false;
  bool senderPinCode = false;
  bool addresseeFormOpenFlag = false;
  bool addresseeNotCompleted = false;
  bool addresseePinCode = false;

  Color senderHeadingColor = ColorConstants.kPrimaryAccent;
  Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;

  final articleNumberFocusNode = FocusNode();
  final weightFocusNode = FocusNode();
  final prepaidAmountFocusNode = FocusNode();
  final insuranceFocusNode = FocusNode();
  final valuePayableFocusNode = FocusNode();
  final senderNameFocusNode = FocusNode();
  final senderAddressFocusNode = FocusNode();
  final senderPinCodeFocusNode = FocusNode();
  final senderMobileFocusNode = FocusNode();
  final senderEmailFocusNode = FocusNode();
  final addresseeNameFocusNode = FocusNode();
  final addresseeAddressFocusNode = FocusNode();
  final addresseePinCodeFocusNode = FocusNode();
  final addresseeMobileFocusNode = FocusNode();
  final addresseeEmailFocusNode = FocusNode();

  final articleNumberController = TextEditingController();
  final weightController = TextEditingController();
  final prepaidAmountController = TextEditingController();
  final amountToBeCollectedController = TextEditingController();
  final insuranceController = TextEditingController();
  final valuePayablePostController = TextEditingController();
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

  scanBarcode() async {
    var scan = await Scan().scanBag();
    setState(() {
      articleNumberController.text = scan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Register Letter',
            style: TextStyle(letterSpacing: 2),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Dummy()));
                },
                child: const Text(
                  'Dummy',
                  style: TextStyle(color: ColorConstants.kWhite),
                ))
          ],
          backgroundColor: ColorConstants.kPrimaryColor,
          elevation: 0,
        ),
        floatingActionButton: TotalFAB(
          title: '\u{20B9} ${getTotalAmount()}',
          function: () {
            ToastUtil.show(
                TotalToast(
                  totalAmount: amountToBeCollected.toString(),
                ),
                context,
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
                  ScanTextFormField(
                    title: 'Article Number',
                    type: 'Register Letter',
                    focus: articleNumberFocusNode,
                    controller: articleNumberController,
                    scanFunction: scanBarcode,
                  ),
                  const Space(),
                  CAdditionalServiceForm(
                    labelText: 'Weight *',
                    focusNode: weightFocusNode,
                    controller: weightController,
                    typeValue: 'Weight',
                    iconData: MdiIcons.weightGram,
                  ),
                  CInputForm(
                    readOnly: false,
                    iconData: MdiIcons.currencyInr,
                    labelText: 'Prepaid Amount',
                    controller: prepaidAmountController,
                    textType: TextInputType.number,
                    typeValue: 'PrepaidAmount',
                    focusNode: prepaidAmountFocusNode,
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.all(12.0.toDouble()),
                    child: Text(
                      'Additional Services',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.kTextColor,
                          fontSize: 20.toDouble(),
                          letterSpacing: 1),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                          label: const Text('Acknowledgement'),
                          labelStyle: const TextStyle(
                              letterSpacing: 1,
                              color: ColorConstants.kTextColor),
                          selected: acknowledgementCheck,
                          onSelected: (bool? value) {
                            setState(() {
                              acknowledgementCheck = value!;
                            });
                          }),
                      ChoiceChip(
                        label: const Text('Insurance'),
                        labelStyle: const TextStyle(
                            letterSpacing: 1, color: ColorConstants.kTextColor),
                        selected: insuranceCheck,
                        onSelected: (bool? value) {
                          setState(() {
                            insuranceCheck = value!;
                            acknowledgementCheck = value;
                            insuranceFocusNode.requestFocus();
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('VPP'),
                        labelStyle: const TextStyle(
                            letterSpacing: 1, color: ColorConstants.kTextColor),
                        selected: valuePayableCheck,
                        onSelected: (bool? value) {
                          setState(() {
                            valuePayableCheck = value!;
                            valuePayableFocusNode.requestFocus();
                          });
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: insuranceCheck,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.toDouble()),
                      child: CAdditionalServiceForm(
                        focusNode: insuranceFocusNode,
                        controller: insuranceController,
                        labelText: 'Enter Insurance value',
                        typeValue: 'Insurance',
                        iconData: MdiIcons.currencyInr,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: valuePayableCheck,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 8.0.toDouble(),
                          left: 20.toDouble(),
                          right: 20.toDouble()),
                      child: CAdditionalServiceForm(
                        focusNode: valuePayableFocusNode,
                        typeValue: 'ValuePayable',
                        labelText: 'Enter Value Payable value',
                        controller: valuePayablePostController,
                        iconData: MdiIcons.currencyInr,
                      ),
                    ),
                  ),
                  const Divider(),

                  //Sender Details
                  const DoubleSpace(),
                  ExpansionTile(
                    maintainState: true,
                    initiallyExpanded: senderExpansion,
                    title: Text(
                      'Sender Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: senderHeadingColor,
                          fontSize: 20.toDouble(),
                          letterSpacing: 1),
                    ),
                    trailing: (senderFormOpenFlag == false)
                        ? Icon(
                            MdiIcons.toggleSwitchOffOutline,
                            size: 40.toDouble(),
                            color: ColorConstants.kTextColor,
                          )
                        : Icon(MdiIcons.toggleSwitchOutline,
                            size: 40.toDouble(),
                            color: ColorConstants.kPrimaryAccent),
                    onExpansionChanged: (value) {
                      setState(() {
                        senderFormOpenFlag = value;
                      });
                    },
                    children: [
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
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite),
                                  ),
                                  labelText: 'Pincode/Office Name *',
                                  labelStyle: TextStyle(
                                      color: ColorConstants.kAmberAccentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite)))),
                          onSuggestionSelected:
                              (Map<String, String> suggestion) async {
                            senderPinCode = false;
                            senderPinCodeController.text =
                                suggestion['pinCode']!;
                            senderCityController.text = suggestion['city']!;
                            senderStateController.text = suggestion['state']!;
                          },
                          itemBuilder:
                              (context, Map<String, String> suggestion) {
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
                        visible:
                            senderPinCodeController.text.isEmpty ? false : true,
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
                        visible:
                            senderPinCodeController.text.isEmpty ? false : true,
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
                        iconData: MdiIcons.cellphone,
                        labelText: 'Mobile Number',
                        controller: senderMobileNumberController,
                        textType: TextInputType.number,
                        typeValue: 'MobileNumber',
                        focusNode: senderMobileFocusNode,
                      ),
                      CInputForm(
                        readOnly: false,
                        iconData: MdiIcons.email,
                        labelText: 'Email',
                        controller: senderEmailController,
                        textType: TextInputType.emailAddress,
                        typeValue: 'Email',
                        focusNode: senderEmailFocusNode,
                      )
                    ],
                  ),
                  Visibility(
                      visible: senderNotCompleted,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0.toDouble()),
                        child: const Text(
                          'Enter the Sender details',
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.kPrimaryAccent),
                        ),
                      )),
                  const Space(),

                  //Addressee Details
                  ExpansionTile(
                    maintainState: true,
                    initiallyExpanded: addresseeExpansion,
                    title: Text(
                      'Addressee Details',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: addresseeHeadingColor,
                          fontSize: 20.toDouble(),
                          letterSpacing: 1),
                    ),
                    trailing: (addresseeFormOpenFlag == false)
                        ? Icon(
                            MdiIcons.toggleSwitchOffOutline,
                            size: 40.toDouble(),
                            color: ColorConstants.kTextColor,
                          )
                        : Icon(MdiIcons.toggleSwitchOutline,
                            size: 40.toDouble(),
                            color: ColorConstants.kPrimaryAccent),
                    onExpansionChanged: (value) {
                      setState(() {
                        addresseeFormOpenFlag = value;
                      });
                    },
                    children: [
                      CInputForm(
                        readOnly: false,
                        iconData: Icons.person,
                        labelText: 'Name *',
                        controller: addresseeNameController,
                        textType: TextInputType.text,
                        typeValue: 'Name',
                        focusNode: addresseeNameFocusNode,
                      ),
                      CInputForm(
                        readOnly: false,
                        iconData: MdiIcons.home,
                        labelText: 'Address *',
                        controller: addresseeAddressController,
                        textType: TextInputType.multiline,
                        typeValue: 'Address',
                        focusNode: addresseeAddressFocusNode,
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
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite),
                                  ),
                                  labelText: 'Pincode/Office Name *',
                                  labelStyle: TextStyle(
                                      color: ColorConstants.kAmberAccentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite)))),
                          onSuggestionSelected:
                              (Map<String, String> suggestion) async {
                            addresseePinCode = false;
                            addresseePinCodeController.text =
                                suggestion['pinCode']!;
                            addresseeCityController.text = suggestion['city']!;
                            addresseeStateController.text =
                                suggestion['state']!;
                          },
                          itemBuilder:
                              (context, Map<String, String> suggestion) {
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
                              addresseePinCode = true;
                            }
                          },
                        ),
                      ),
                      Visibility(
                          visible: addresseePinCode,
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
                        visible: addresseePinCodeController.text.isEmpty
                            ? false
                            : true,
                        child: CInputForm(
                          readOnly: true,
                          iconData: Icons.location_city,
                          labelText: 'City',
                          controller: addresseeCityController,
                          textType: TextInputType.text,
                          typeValue: 'City',
                          focusNode: addresseePinCodeFocusNode,
                        ),
                      ),
                      Visibility(
                        visible: addresseePinCodeController.text.isEmpty
                            ? false
                            : true,
                        child: CInputForm(
                          readOnly: true,
                          iconData: Icons.location_city,
                          labelText: 'State',
                          controller: addresseeStateController,
                          textType: TextInputType.text,
                          typeValue: 'City',
                          focusNode: addresseePinCodeFocusNode,
                        ),
                      ),
                      CInputForm(
                        readOnly: false,
                        iconData: MdiIcons.cellphone,
                        labelText: 'Mobile Number',
                        controller: addresseeMobileNumberController,
                        textType: TextInputType.number,
                        typeValue: 'MobileNumber',
                        focusNode: addresseeMobileFocusNode,
                      ),
                      CInputForm(
                        readOnly: false,
                        iconData: MdiIcons.email,
                        labelText: 'Email',
                        controller: addresseeEmailController,
                        textType: TextInputType.emailAddress,
                        typeValue: 'Email',
                        focusNode: addresseeEmailFocusNode,
                      )
                    ],
                  ),
                  Visibility(
                      visible: addresseeNotCompleted,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0.toDouble()),
                        child: const Text(
                          'Enter the Addressee details',
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorConstants.kPrimaryAccent),
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10.toDouble()),
                                    side: const BorderSide(
                                        color:
                                            ColorConstants.kSecondaryColor)))),
                        onPressed: () async {
                          setState(() {
                            insuranceFocusNode.unfocus();
                            valuePayableFocusNode.unfocus();
                          });
                          final ifPresent = await LetterBooking()
                              .select()
                              .ArticleNumber
                              .equals(articleNumberController.text)
                              .toMapList();
                          if (ifPresent.isNotEmpty) {
                            Toast.showFloatingToast(
                                'Article Already Scanned', context);
                          } else {
                            if (weightController.text.isEmpty) {
                              setState(() {
                                weightFocusNode.requestFocus();
                              });
                            } else if (insuranceCheck == true) {
                              if (insuranceController.text.isEmpty) {
                                insuranceFocusNode.requestFocus();
                              }
                            } else if (valuePayableCheck == true) {
                              if (valuePayablePostController.text.isEmpty) {
                                valuePayableFocusNode.requestFocus();
                              }
                            }
                            if (senderNameController.text.isEmpty ||
                                senderAddressController.text.isEmpty ||
                                senderCityController.text.isEmpty) {
                              senderNotCompleted = true;
                            }
                            if (addresseeNameController.text.isEmpty ||
                                addresseeAddressController.text.isEmpty ||
                                addresseeCityController.text.isEmpty) {
                              addresseeNotCompleted = true;
                            }

                            if (formGlobalKey.currentState!.validate()) {
                              formGlobalKey.currentState!.save();

                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return RLConformationDialog(
                                        paymentMode: 'S',
                                        articleNumber:
                                            articleNumberController.text,
                                        weight: weightController.text.trim(),
                                        weightAmount: weightAmt.toString(),
                                        registrationFee: widget.fees.toString(),
                                        prepaidAmount:
                                            prepaidAmountController.text.isEmpty
                                                ? '0.0'
                                                : ppAmt.toString(),
                                        acknowledgement: acknowledgementCheck,
                                        insurance: insuranceCheck == true
                                            ? insAmt.toString()
                                            : '',
                                        valuePayablePost:
                                            valuePayableCheck == true
                                                ? vppAmt.toString()
                                                : '',
                                        amountToBeCollected: total(),
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
                                            addresseeMobileNumberController
                                                .text,
                                        addresseeEmail:
                                            addresseeEmailController.text,
                                        function: () {
                                          Navigator.of(context).pop();
                                          printFunction();
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
        ));
  }

  resetAll() {
    articleNumberController.clear();
    weightController.clear();
    prepaidAmountController.clear();
    amountToBeCollectedController.clear();
    insuranceController.clear();
    valuePayablePostController.clear();
    senderNameController.clear();
    senderAddressController.clear();
    senderPinCodeController.clear();
    senderCityController.clear();
    senderStateController.clear();
    senderMobileNumberController.clear();
    senderEmailController.clear();
    addresseeNameController.clear();
    addresseeAddressController.clear();
    addresseePinCodeController.clear();
    addresseeCityController.clear();
    addresseeStateController.clear();
    addresseeMobileNumberController.clear();
    addresseeEmailController.clear();
  }

  printFunction() async {
    // var response = await http.post(Uri.parse(URL.bookingURL) , body: {
    //   "facilityid":"PO9999999999",
    //   "bookingfacilityzip":"570010",
    //   "distributionchannel":"",
    //   "userid":"",
    //   "counterno":"",
    //   "invoiceno":"",
    //   "totalamount":amountToBeCollected.toString(),
    //   "bookingdate":date,
    //   "bookingtime":time,
    //   "currencyid":"INR",
    //   "tenderid":"",
    //   "totalcashamount":"",
    //   "roundoffdifferenceamount":"",
    //   "checkeruserid":"",
    //   "circlecode":"",
    //   "lineitemnumber":"",
    //   "baseprice":"",
    //   "lineitemtotalamount":"",
    //   "division":"",
    //   "ordertype":"",
    //   "producttype":"LETTER",
    //   "productcode":"RL",
    //   "quantity":"",
    //   "valuecode":"",
    //   "value":"",
    //   "sendercustomerid":"",
    //   "sendercustomername":senderNameController.text,
    //   "senderaddress1":senderAddressController.text,
    //   "senderaddress2":"",
    //   "senderaddress3":"",
    //   "sendermobile":senderMobileNumberController.text,
    //   "sendercity":senderCityController.text,
    //   "senderstate":senderStateController.text,
    //   "senderzip":senderPinCodeController.text,
    //   "sendercountry":"INDIA",
    //   "recipientname":addresseeNameController.text,
    //   "recipientaddress1":addresseeAddressController.text,
    //   "recipientaddress2":"",
    //   "recipientcity":addresseeCityController.text,
    //   "recipientstate":addresseeStateController.text,
    //   "recipientzip":addresseePinCodeController.text,
    //   "recipientcountry":"INDIA",
    //   "recipientmobile":addresseeMobileNumberController.text,
    //   "recipientemail":addresseeEmailController.text,
    //   "returncustomername":senderNameController.text,
    //   "returnaddress1":senderAddressController.text,
    //   "returncity":senderCityController.text,
    //   "returnstate":senderStateController.text,
    //   "returnzip":senderPinCodeController.text,
    //   "returncountryid":"INDIA",
    //   "commissionamount":"",
    //   "materialgroup":"",
    //   "destinationfacilityid":"",
    //   "sendermoneytransfervalue":"",
    //   "motrackingid":"",
    //   "momessage":"",
    //   "elapsedtime":"",
    //   "bulkaddresstype":"",
    //   "vpmoidentifier":"",
    //   "articleno":articleNumberController.text,
    //   "weightcode":"",
    //   "weight":weightController.text,
    //   "distancecode":"",
    //   "distance":"",
    //   "taxamount":serviceTax,
    //   "postagedue":"",
    //   "prepaidamount":ppAmt,
    //   "isfullprepaid":"",
    //   "vas":"",
    //   "vasvalue":"",
    //   "addlbillinfo":"",
    //   "addlbillamountinfo":"",
    //   "billerid":"",
    //   "recipientaddress3":"",
    //   "repaymentmode":"",
    //   "isams":"",
    //   "isonpostalservice":"",
    //   "parentinvoiceno":"",
    //   "isreversed":"",
    //   "serialno":"",
    //   "clientrequesttime":"$date $time"
    // });

    // if (response.statusCode == 201) {
    //   Toast.showFloatingToast('Added To Server', context);
    // }

    BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Booking',
        'Register Letter Booking',
        date,
        time,
        amountToBeCollected.toString(),
        'Add');

    final addCash =  CashTable()
      ..Cash_ID = articleNumberController.text
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = 'Add'
      ..Cash_Amount = amountToBeCollected.toDouble()
      ..Cash_Description = 'Register Letter Booking';
    await addCash.save();

    BookingDBService().addRegisterLetterToDB(
        DateTimeDetails().dateCharacter(),
        DateTimeDetails().timeCharacter(),
        articleNumberController.text,
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        '0',
        amountToBeCollected.toString(),
        '1',
        weightController.text,
        senderNameController.text,
        senderAddressController.text.replaceAll('\n', '  '),
        senderCityController.text,
        senderStateController.text,
        senderPinCodeController.text,
        senderEmailController.text,
        senderMobileNumberController.text,
        addresseeNameController.text,
        addresseeAddressController.text.replaceAll('\n', '  '),
        addresseeCityController.text,
        addresseeStateController.text,
        addresseePinCodeController.text,
        '0',
        '0',
        prepaidAmountController.text.isEmpty
            ? '0'
            : prepaidAmountController.text,
        'REG',
        '',
        '0',
        '1',
        'S');

    weightAmt = 0.0;
    insAmt = 0.0;
    vppAmt = 0.0;
    ackAmt = 0.0;
    ppAmt = 0.0;
    registrationFee = 0.0;
  }

  checkColor() {
    if (senderNameController.text.isNotEmpty &&
        senderAddressController.text.isNotEmpty &&
        senderCityController.text.isNotEmpty) {
      setState(() {
        senderNotCompleted = false;
        senderHeadingColor = ColorConstants.kTextColor;
      });
    } else {
      setState(() {
        senderHeadingColor = ColorConstants.kPrimaryAccent;
      });
    }
    if (addresseeNameController.text.isNotEmpty &&
        addresseeAddressController.text.isNotEmpty &&
        addresseePinCodeController.text.isNotEmpty) {
      setState(() {
        addresseeNotCompleted = false;
        addresseeHeadingColor = ColorConstants.kTextColor;
      });
    } else {
      setState(() {
        addresseeHeadingColor = ColorConstants.kPrimaryAccent;
      });
    }
  }

  total() {
    var weightAmount = weightAmt;
    var prepaidAmount = prepaidAmountController.text.isEmpty ? 0.0 : ppAmt;
    var acknowledgeAmount = acknowledgementCheck == true ? 3.0 : 0;
    var insuranceAmt = insuranceCheck == true ? insAmt : 0;
    insuranceCheck == true ? acknowledgeAmount = 0 : null;
    var valuePayablePost = valuePayableCheck == true ? vppAmt : 0;
    var total = weightAmount -
        prepaidAmount +
        acknowledgeAmount +
        insuranceAmt +
        valuePayablePost +
        widget.fees;
    if (total < 0) total = 0.0;
    return total.toString();
  }
}
