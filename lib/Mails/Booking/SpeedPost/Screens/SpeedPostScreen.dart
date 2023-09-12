import 'dart:async';

import 'package:darpan_mine/Constants/Calculations.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/Booking/SpeedPost/Widgets/SPConformationDialog.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/TotalFAB.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SpeedPostScreen extends StatefulWidget {
  const SpeedPostScreen({Key? key}) : super(key: key);

  @override
  _SpeedPostScreenState createState() => _SpeedPostScreenState();
}

class _SpeedPostScreenState extends State<SpeedPostScreen> {
  String date = '';
  String time = '';

  int amountToBeCollected = 0;

  Timer? timer;

  bool isLoading = false;
  bool acknowledgementCheck = false;
  bool insuranceCheck = false;
  bool senderFormOpenFlag = false;
  bool senderNotCompleted = false;
  bool addresseeFormOpenFlag = false;
  bool addresseeNotCompleted = false;
  double podAmount = 0;

  Color senderHeadingColor = ColorConstants.kPrimaryAccent;
  Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;

  final articleNumberFocusNode = FocusNode();
  final weightFocusNode = FocusNode();
  final prepaidAmountFocusNode = FocusNode();
  final insuranceFocusNode = FocusNode();
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

  final formGlobalKey = GlobalKey<FormState>();
  final articleNumberController = TextEditingController();
  final weightController = TextEditingController();
  final prepaidAmountController = TextEditingController();
  final insuranceController = TextEditingController();
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
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Fees().getProofOfDeliveryFee('SP_INLAND_LETTER');
    Fees().getRegistrationFees('SP_INLAND_LETTER');
    currentDateTime();
    senderNotCompleted = false;
    addresseeNotCompleted = false;
    Fees().getValidations('SP_INLAND_LETTER');
    weightFocusNode.addListener(() {
      if (!weightFocusNode.hasFocus) {
        Fees().getWeightAmount(int.parse(weightController.text), 'PARCEL');
      }
    });
    insuranceFocusNode.addListener(() {
      if (!insuranceFocusNode.hasFocus) {
        Fees().getInsuranceAmount(int.parse(insuranceController.text));
      }
    });
    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => checkColor());
    super.initState();
  }

  currentDateTime() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    setState(() {
      date = formatter.format(now);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const AppAppBar(
        title: 'Speed Post',
      ),
      floatingActionButton:
          TotalFAB(function: () {}, title: '\u{20B9} ${getTotalAmount()}'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0.toDouble()),
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Article Details
                ScanTextFormField(
                    title: 'Article Number',
                    type: 'Speed Post',
                    controller: articleNumberController,
                    scanFunction: scanBarcode,
                    focus: articleNumberFocusNode),
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
                        label: const Text('POD'),
                        labelStyle: const TextStyle(
                            letterSpacing: 1, color: ColorConstants.kTextColor),
                        selected: acknowledgementCheck,
                        onSelected: (bool? value) {
                          setState(() {
                            acknowledgementCheck = value!;
                            acknowledgementCheck ? podAmount = podAmt : podAmount = 0.0;
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
                          insuranceFocusNode.requestFocus();
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: insuranceCheck,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.toDouble()),
                    child: CAdditionalServiceForm(
                      focusNode: insuranceFocusNode,
                      controller: insuranceController,
                      labelText: 'Enter Insurance value',
                      typeValue: 'Insurance',
                      iconData: MdiIcons.currencyInr,
                    ),
                  ),
                ),
                const Divider(),

                //Sender Details
                const DoubleSpace(),
                ExpansionTile(
                  initiallyExpanded: senderFormOpenFlag,
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
                                  borderSide:
                                      BorderSide(color: ColorConstants.kWhite),
                                ),
                                labelText: 'Pincode/Office Name *',
                                labelStyle: TextStyle(
                                    color: ColorConstants.kAmberAccentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite)))),
                        onSuggestionSelected:
                            (Map<String, String> suggestion) async {
                          senderPinCodeController.text = suggestion['pinCode']!;
                          senderCityController.text = suggestion['city']!;
                          senderStateController.text = suggestion['state']!;
                          if (addresseePinCodeController.text.isNotEmpty &&
                              weightController.text.isNotEmpty &&
                              addresseePinCodeController.text.isNotEmpty) {
                            Fees().getSpeedFee(
                                senderPinCodeController.text,
                                addresseePinCodeController.text,
                                int.parse(weightController.text),podAmount);
                          }
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
                            isLoading = false;
                            return 'Select a Pincode/Office name';
                          }
                        },
                      ),
                    ),
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
                            fontSize: 10, color: ColorConstants.kPrimaryAccent),
                      ),
                    )),
                const Space(),

                //Addressee Details
                ExpansionTile(
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
                    TypeAheadFormField(
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
                                  borderSide: BorderSide(
                                      color: ColorConstants.kWhite)))),
                      onSuggestionSelected:
                          (Map<String, String> suggestion) async {
                        addresseePinCodeController.text =
                            suggestion['pinCode']!;
                        addresseeCityController.text = suggestion['city']!;
                        addresseeStateController.text = suggestion['state']!;
                        if (senderPinCodeController.text.isNotEmpty &&
                            weightController.text.isNotEmpty &&
                            addresseePinCodeController.text.isNotEmpty) {
                          Fees().getSpeedFee(
                              senderPinCodeController.text,
                              addresseePinCodeController.text,
                              int.parse(weightController.text),podAmount);
                        }
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
                          isLoading = false;
                          return 'Select a Pincode/Office name';
                        }
                      },
                    ),
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
                    ),
                  ],
                ),
                Visibility(
                    visible: addresseeNotCompleted,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0.toDouble()),
                      child: Text(
                        'Enter the Addressee details',
                        style: TextStyle(
                            fontSize: 10.toDouble(),
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
                                      color: ColorConstants.kSecondaryColor)))),
                      onPressed: () async {
                        setState(() {
                          insuranceFocusNode.unfocus();
                        });
                        final ifPresent = await SpeedBooking()
                            .select()
                            .ArticleNumber
                            .equals(articleNumberController.text)
                            .toMapList();
                        if (ifPresent.isNotEmpty) {
                          Toast.showFloatingToast(
                              'Article Already Scanned', context);
                        } else {
                          if (articleNumberController.text.isEmpty) {
                            setState(() {
                              articleNumberFocusNode.requestFocus();
                            });
                          } else if (weightController.text.isEmpty) {
                            setState(() {
                              weightFocusNode.requestFocus();
                            });
                          } else if (insuranceCheck == true) {
                            if (insuranceController.text.isEmpty) {
                              insuranceFocusNode.requestFocus();
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
                                builder: (BuildContext context) {
                                  return SPConformationDialog(
                                      paymentMode: 'S',
                                      articleNumber:
                                          articleNumberController.text,
                                      weight: weightController.text,
                                      registrationFee:
                                          registrationFee.toString(),
                                      serviceTaxAmount: serviceTax.toString(),
                                      acknowledgement: ackAmt.toString(),
                                      prepaidAmount:
                                          prepaidAmountController.text,
                                      insurance: insuranceCheck == true
                                          ? insuranceController.text
                                          : '0',
                                      amountToBeCollected:
                                          amountToBeCollected.toString(),
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
      ),
    );
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
    //   "producttype":"Speed Post",
    //   "productcode":"SP",
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
    //   "articleno": articleNumberController.text,
    //   "weightcode":"",
    //   "weight": '0',
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
    //
    // if (response.statusCode == 201) {
    //   Toast.showFloatingToast('Added To Server', context);
    // }

    // final addTransaction = BookingTransactionTable()
    //   ..TransactionID = articleNumberController.text
    //   ..Date = date
    //   ..Time = time
    //   ..TotalAmount = amountToBeCollected.toString()
    //   ..ArticleType = 'Speed Post'
    //   ..SenderName = senderNameController.text
    //   ..ReceiverPinCode = addresseePinCodeController.text
    //   ..AdditionalServiceAmount = (weightAmt + ackAmt + vppAmt).toString()
    //   ..Status = 'Booked';
    // await addTransaction.save();

    final addCash =  CashTable()
      ..Cash_ID = articleNumberController.text
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = 'Add'
      ..Cash_Amount = amountToBeCollected.toDouble()
      ..Cash_Description = 'Speed Post Booking';
    await addCash.save();

    BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Booking',
        'Speed Post Booking',
        DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(),
        amountToBeCollected.toString(),
        'Add');

    // BookingDBService().addToDB(
    //     "TRANS${articleNumberController.text}", date, time, articleNumberController.text,
    //     weightController.text, weightAmt.toString(), prepaidAmountController.text,
    //     acknowledgementCheck == true ? insuranceCheck == true ? '0' : ackAmt.toString() : '0',
    //     insuranceCheck == true ? insuranceController.text : '0',
    //     '0', '0', '0', '0',
    //     amountToBeCollected.toString(), '', senderNameController.text,
    //     senderAddressController.text, senderPinCodeController.text,
    //     senderCityController.text, senderStateController.text, 'IN',
    //     senderEmailController.text, senderMobileNumberController.text,
    //     addresseeNameController.text, addresseeAddressController.text,
    //     addresseePinCodeController.text, addresseeCityController.text,
    //     addresseeStateController.text, 'IN', addresseeEmailController.text,
    //     addresseeMobileNumberController.text, 'Speed Post');

    BookingDBService().addSpeedToDB(
        articleNumberController.text,
        DateTimeDetails().currentDate(),
        DateTimeDetails().timeCharacter(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        weightcode,
        weightController.text,
        distancecode,
        spdistance,
        senderNameController.text,
        senderAddressController.text.replaceAll('\n', '  '),
        senderCityController.text,
        senderStateController.text,
        senderPinCodeController.text,
        senderMobileNumberController.text,
        addresseeNameController.text,
        addresseeAddressController.text.replaceAll('\n', '  '),
        addresseeCityController.text,
        addresseeStateController.text,
        addresseePinCodeController.text,
        '0',
        '0',
        prepaidAmountController.text.toString().isEmpty
            ? '0'
            : prepaidAmountController.text.toString(),
        '',
        '',
        '000134',
        '0',
        '0',
        'N',
        'S');
  }

  getTotalAmount() {
    if (weightController.text.isNotEmpty) {
      amountToBeCollected = weightAmt.toInt();
    }
    if (senderPinCodeController.text.isNotEmpty &&
        addresseePinCodeController.text.isNotEmpty) {
      setState(() {
        amountToBeCollected =
            (weightAmt + registrationFee - ppAmt + serviceTax).toInt();
      });
    }
    return amountToBeCollected.toString();
  }
}
