import 'dart:async';

import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Calculations.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages//TypeAhead/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/AddressModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Parcel/ParcelConformationDialog.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/PdfGeneration.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Widgets/RLConformationDialog.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/Booking/SpeedPost/Widgets/SPConformationDialog.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Utils/Receipt.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Utils/barcodeValidation.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/CustomToast.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/TotalFAB.dart';
import 'package:darpan_mine/Widgets/TotalToast.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../BookingMainScreen.dart';

class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class PaymentMode {
  int index;
  String type;

  PaymentMode({required this.index, required this.type});
}

class _DummyState extends State<Dummy> {
  var typeArticle = null;

  final _articleTypes = ['Regd. Letter', 'Regd. Parcel', 'Speed Post'];

  Timer? timer;

  String date = '';
  String time = '';
  String _selectedPaymentMode = 'Cash';
  String _selectedBookingType = 'Regular';
  String? articleType;
  String? articleTypeError;

  int amountToBeCollected = 0;
  int maximumArticleWeight = 0;
  int maximumInsuranceValue = 600;
  int maximumVPPValue = 5000;

  double podAmount = 0;

  bool _selectedArticle = false;
  bool senderPinCode = false;
  bool addresseePinCode = false;
  bool acknowledgementCheck = false;
  bool podCheck = false;
  bool insuranceCheck = false;
  bool valuePayableCheck = false;
  bool airMailServiceCheck = false;

  final phoneNumberFocusNode = FocusNode();
  final articleNumberFocusNode = FocusNode();
  final weightFocusNode = FocusNode();
  final prepaidAmountFocusNode = FocusNode();
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
  final insuranceFocusNode = FocusNode();
  final parcelInsuranceFocusNode = FocusNode();
  final valuePayableFocusNode = FocusNode();

  final phoneNumberController = TextEditingController();
  final articleNumberController = TextEditingController();
  final weightController = TextEditingController();
  final prepaidAmountController = TextEditingController();
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
  final insuranceController = TextEditingController();
  final parcelInsuranceController = TextEditingController();
  final valuePayablePostController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  List<DeliverAddress>? deliveryAddress = [];
  List<DeliverAddress>? sendingAddress = [];

  Color senderHeadingColor = ColorConstants.kPrimaryAccent;
  Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;

  PdfGeneration pdfScreen = new PdfGeneration();
  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  String pdfName = "";

/* Old Code for PDF Generation
  GeneratePDF(String Type) async {
    final f = new DateFormat('dd-MM-yyyy hh:mm:ss');
    String date = f.format(new DateTime.now());
    print(date);
    print("-------------");
    basicInformation.add("Transaction Date");
    basicInformation.add(date);
    basicInformation.add("Booking Office");
    basicInformation.add("");
    basicInformation.add("BPM");
    basicInformation.add("");
    basicInformation.add("Article Number");
    basicInformation.add(articleNumberController.text);
    basicInformation.add("Service");
    basicInformation.add("");
    basicInformation.add("Weight");
    basicInformation.add(weightController.text);
    basicInformation.add("Payment Mode");
    basicInformation.add(_selectedPaymentMode.toString());
    basicInformation.add("Paid Amount");
    basicInformation.add(amountToBeCollected.toString());
    basicInformation.add("Delivery Office");
    basicInformation.add(addresseeCityController.text);

    print('basic information is');
    print(basicInformation.toString());

    String generatedPdfFilePath = await pdfScreen.generateExampleDocument(
        Type.toString(),
        basicInformation,
        [],
        [],
        [],
        [],
        "",
        "",
        "",
        "",
        articleNumberController.text);

    print("File Path is - " + generatedPdfFilePath.toString());
    pdfName = generatedPdfFilePath.toString();
    // return  generatedPdfFilePath.toString();
  }

 */

//new code for Printing instead of PDF Generation.
  GeneratePDF(String Type, String artNumber) async {
    final userDetails = await OFCMASTERDATA().select().toList();
    String ArticleFromDB="";
    if (Type =="Regd. Letter"){
      final letterDB = await LetterBooking().select().ArticleNumber.equals(artNumber).toList();
      ArticleFromDB = letterDB[0].ArticleNumber.toString();
    }
    if (Type =="PARCEL")
    {
      final parcelDB = await ParcelBooking().select().ArticleNumber.equals(artNumber).toList();
      ArticleFromDB = parcelDB[0].ArticleNumber.toString();
    }


    String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();

    basicInformation.add("Transaction Date");
    basicInformation.add(date);
    basicInformation.add("Transaction Time");
    basicInformation.add(time);
    basicInformation.add("Booking Office");
    basicInformation.add(userDetails[0].BOName.toString());
    basicInformation.add("Booking Office PIN");
    basicInformation.add(userDetails[0].Pincode.toString());
    basicInformation.add("BPM");
    basicInformation.add(userDetails[0].EmployeeName.toString());
    basicInformation.add("Article Number");
    basicInformation.add(ArticleFromDB);
    basicInformation.add("Service");
    basicInformation.add(Type);
    basicInformation.add("Weight");
    basicInformation.add(weightController.text);
    basicInformation.add("Payment Mode");
    basicInformation.add(_selectedPaymentMode.toString());
    basicInformation.add("Prepaid");
    basicInformation.add(prepaidAmountController.text.isEmpty
        ? '0'
        : prepaidAmountController.text);
    basicInformation.add("Paid Amount");
    basicInformation.add(amountToBeCollected.toString());
    basicInformation.add("Sender Name");
    basicInformation.add(senderNameController.text);
    basicInformation.add("Addressee Name");
    basicInformation.add(addresseeNameController.text);
    basicInformation.add("Delivery Office");
    basicInformation.add(addresseeCityController.text);
    basicInformation.add("Delivery Office Pincode");
    basicInformation.add(addresseePinCodeController.text);
    basicInformation.add("Track - ");
    basicInformation.add("www.indiapost.gov.in");
    basicInformation.add("|< Dial :");
    basicInformation.add("18002666868>|");
    basicInformation.add("|< IVR Track #:");
    basicInformation.add("6975000000028 >|");

    secondReceipt.clear();

    secondReceipt.add("Transaction Date");
    secondReceipt.add(date);
    secondReceipt.add("Booking Office");
    secondReceipt.add(userDetails[0].BOName.toString());
    secondReceipt.add("Booking Office PIN");
    secondReceipt.add(userDetails[0].Pincode.toString());
    secondReceipt.add("BPM");
    secondReceipt.add(userDetails[0].EmployeeName.toString());
    secondReceipt.add("Service");
    secondReceipt.add(Type);
    secondReceipt.add("Article Number");
    secondReceipt.add(ArticleFromDB);
    secondReceipt.add("Weight");
    secondReceipt.add(weightController.text);
    secondReceipt.add("Payment Mode");
    secondReceipt.add(_selectedPaymentMode.toString());
    secondReceipt.add("Paid Amount");
    secondReceipt.add(amountToBeCollected.toString());
    secondReceipt.add("Sender Name");
    secondReceipt.add(senderNameController.text);

    // print('basic information is');
    // print(basicInformation.toString());
    //
    // String generatedPdfFilePath = await pdfScreen.generateExampleDocument(
    //     "PARCEL", basicInformation, [], [], [], [], "", "", "", "",widget.articleNumber);
    //
    // print("File Path is - " + generatedPdfFilePath.toString());
    // pdfName = generatedPdfFilePath.toString();
    // // return  generatedPdfFilePath.toString();
  }

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
    // showPhoneDialog();
    currentDateTime();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => () {});
    super.initState();
  }

  scanBarcode() async {
    var scan = await Scan().scanBag();
    setState(() {
      articleNumberController.text = scan;
    });
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
                            buttonFunction: () => Navigator.pop(context)),
                        Button(
                            buttonText: 'CONFIRM',
                            buttonFunction: () {
                              if (phoneNumberController.text.isNotEmpty) {
                                senderMobileNumberController.text =
                                    phoneNumberController.text
                                        .replaceAll(' ', '')
                                        .trim();
                                var senderData =
                                    senderAddress['sender_address'];
                                sendingAddress = senderData
                                    ?.map((e) => DeliverAddress.fromJson(e))
                                    .toList();
                                senderNameController.text =
                                    sendingAddress![0].name;
                                senderAddressController.text =
                                    sendingAddress![0].address;
                                senderCityController.text =
                                    sendingAddress![0].city;
                                senderStateController.text =
                                    sendingAddress![0].state;
                                senderPinCodeController.text =
                                    sendingAddress![0].pincode;
                                var receiverData =
                                    deliverAddress['receiver_address'];
                                deliveryAddress = receiverData
                                    ?.map((e) => DeliverAddress.fromJson(e))
                                    .toList();
                                Navigator.pop(context);
                                showAddressDialog();
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

  showAddressDialog() async {
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
                                                deliveryAddress![index]
                                                    .checkValue = val!;
                                                addresseeNameController.text =
                                                    deliveryAddress![index]
                                                        .name;
                                                addresseeAddressController
                                                        .text =
                                                    deliveryAddress![index]
                                                        .address;
                                                addresseePinCodeController
                                                        .text =
                                                    deliveryAddress![index]
                                                        .pincode;
                                                addresseeCityController.text =
                                                    deliveryAddress![index]
                                                        .city;
                                                addresseeStateController.text =
                                                    deliveryAddress![index]
                                                        .state;
                                                addresseeMobileNumberController
                                                        .text =
                                                    deliveryAddress![index]
                                                        .mobileNumber;
                                                addresseeEmailController.text =
                                                    deliveryAddress![index]
                                                        .email;
                                                Navigator.pop(context);
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
                            buttonFunction: () => Navigator.pop(context))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  void itemChange(bool val, int index) {
    setState(() {
      deliveryAddress![index].checkValue = val;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _selectedPaymentMode = 'Cash';
    super.dispose();
  }

  getTotalAmount() {
    print('inside getTotalAmount function..!');
    if (_selectedBookingType == "Regular") {
      prepaidAmountController.text.isNotEmpty
          ? ppAmt = double.parse(prepaidAmountController.text)
          : ppAmt = 0.0;

      if (typeArticle == 'Regd. Letter') {
        print('getTotalAmount inside LETTER - ' +
            registrationFee.toString() +
            ' - ' +
            weightAmt.toString());
        acknowledgementCheck ? ackAmt = 3.0 : ackAmt = 0.0;
        insuranceCheck ? insAmt = insAmt : insAmt = 0;
        insuranceCheck ? ackAmt = 0 : null;
        valuePayableCheck ? vppAmt = vppAmt : vppAmt = 0;
        setState(() {
          amountToBeCollected =
              (insAmt + vppAmt + ackAmt + registrationFee + weightAmt - ppAmt)
                  .toInt();
        });
        if (amountToBeCollected < 0) amountToBeCollected = 0;
        return amountToBeCollected.toString();
      }
      if (typeArticle == 'Regd. Parcel') {
        prepaidAmountController.text.isNotEmpty
            ? ppAmt = double.parse(prepaidAmountController.text)
            : ppAmt = 0.0;
        acknowledgementCheck ? ackAmt = 3.0 : ackAmt = 0.0;
        insuranceCheck ? insAmt = insAmt : insAmt = 0;
        insuranceCheck ? ackAmt = 0 : null;
        valuePayableCheck ? vppAmt = vppAmt : vppAmt = 0;
        airMailServiceCheck ? airMailAmt = airMailAmt : airMailAmt = 0;
        setState(() {
          amountToBeCollected = (insAmt +
                  vppAmt +
                  ackAmt +
                  registrationFee +
                  weightAmt +
                  airMailAmt +
                  doorDeliveryFee -
                  ppAmt)
              .toInt();
        });
        if (amountToBeCollected < 0) amountToBeCollected = 0;
        return amountToBeCollected.toString();
      }
      if (typeArticle == 'Speed Post') {
        print('Total Amount Calculation..!');
        print(weightAmt);
        print(registrationFee);
        print(ppAmt);
        print(serviceTax);
        print(podAmount);
        print(insAmt);

        // if (weightController.text.isNotEmpty) {
        //   amountToBeCollected = weightAmt.toInt();
        //   print(distancecode);
        // }
        podCheck ? podAmount = podAmt : podAmount = 0.0;
        insuranceCheck ? insAmt = insAmt : insAmt = 0;
        if (senderPinCodeController.text.isNotEmpty &&
            addresseePinCodeController.text.isNotEmpty) {
          setState(() {
            amountToBeCollected =
                (registrationFee.round() + serviceTax.round() + podAmount + insAmt - ppAmt)
                    .toInt();
          });
        }
        if (amountToBeCollected < 0) amountToBeCollected = 0;

        print('getTotalAmount() value - ' + amountToBeCollected.toString());
        return amountToBeCollected.toString();
      }
      return amountToBeCollected.toString();
    } else if (_selectedBookingType == "Service") {
      // ppAmt = 0.0;
      // ackAmt = 0.0;
      // insAmt = 0;
      // vppAmt = 0;
      // weightAmt = 0;
      // ppAmt = 0;
      // registrationFee = 0;
      // airMailAmt = 0;
      // doorDeliveryFee = 0;
      // serviceTax = 0;
      // podAmount = 0;
      amountToBeCollected = 0;
      return amountToBeCollected.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppAppBar(title: 'Article Booking'
            // title: const Text(
            //   'Article Booking',
            //   style: TextStyle(letterSpacing: 2),
            // ),
            // backgroundColor: ColorConstants.kPrimaryColor,
            // elevation: 0,
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
          padding: EdgeInsets.symmetric(
              vertical: 5.0.toDouble(), horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10),
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            iconEnabledColor: Colors.blueGrey,
                            hint: const Text(
                              'Select an Article Type',
                              style: TextStyle(color: Color(0xFFCFB53B)),
                            ),
                            items: _articleTypes.map((String myMenuItem) {
                              return DropdownMenuItem<String>(
                                value: myMenuItem,
                                child: Text(
                                  myMenuItem,
                                  style:
                                      const TextStyle(color: Colors.blueGrey),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? valueSelectedByUser) async {
                              maximumArticleWeight = 0;
                              if (valueSelectedByUser == 'Regd. Letter') {
                                await Fees().getRegistrationFees('LETTER');
                                maximumArticleWeight =
                                    await Fees().getValidations('LETTER');
                              } else if (valueSelectedByUser ==
                                  'Regd. Parcel') {
                                maximumArticleWeight =
                                    await Fees().getValidations('PARCEL');
                                await Fees().getAcknowledgementFee('PARCEL');
                                await Fees().getRegistrationFees('PARCEL');
                              } else if (valueSelectedByUser == 'Speed Post') {
                                await Fees()
                                    .getProofOfDeliveryFee('SP_INLAND_LETTER');
                                maximumArticleWeight = await Fees()
                                    .getValidations('SP_INLAND_LETTER');
                              }
                              _dropDownItemSelected(valueSelectedByUser!);
                            },
                            value: _selectedArticle ? typeArticle : articleType,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _selectedArticle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScanTextFormField(
                          title: 'Article Number',
                          type: 'LETTER',
                          focus: articleNumberFocusNode,
                          controller: articleNumberController,
                          scanFunction: scanBarcode,
                        ),
                        const Space(),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 5,
                          focusNode: weightFocusNode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onSaved: (val) => getTotalAmount(),
                          onChanged: (text) async {
                            if (typeArticle == 'Regd. Letter') {
                              if (int.parse(weightController.text) >
                                  maximumArticleWeight) {
                                Toast.showFloatingToast(
                                    'Maximum weight of letter is $maximumArticleWeight gms',
                                    context);
                              } else {
                                await Fees().getWeightAmount(
                                    weightController.text.isNotEmpty
                                        ? int.parse(weightController.text)
                                        : 0,
                                    'LETTER');
                              }
                            } else if (typeArticle == 'Regd. Parcel') {
                              if (int.parse(weightController.text) >
                                  maximumArticleWeight) {
                                Toast.showFloatingToast(
                                    'Maximum weight of letter is $maximumArticleWeight gms',
                                    context);
                              } else {
                                await Fees().getWeightAmount(
                                    weightController.text.isNotEmpty
                                        ? int.parse(weightController.text)
                                        : 0,
                                    'PARCEL');
                              }
                              await Fees().getDoorDeliveryFee(
                                  weightController.text.isNotEmpty
                                      ? int.parse(weightController.text)
                                      : 0,
                                  'PARCEL');
                            } else if (typeArticle == 'Speed Post') {
                              print('On weight change in Speed Post');
                              if (int.parse(weightController.text) >
                                  maximumArticleWeight) {
                                Toast.showFloatingToast(
                                    'Maximum weight of letter is $maximumArticleWeight gms',
                                    context);
                              }
                              //may not be required for Speed Post
                              // else {
                              //   await Fees().getWeightAmount(
                              //       weightController.text.isNotEmpty
                              //           ? int.parse(weightController.text)
                              //           : 0,
                              //       'PARCEL');
                              // }
                              if (senderPinCodeController.text.isNotEmpty &&
                                  weightController.text.isNotEmpty &&
                                  addresseePinCodeController.text.isNotEmpty) {
                                print(
                                    'On weight change in Speed Post Calculation call');
                                print(senderPinCodeController.text +
                                    " - " +
                                    addresseePinCodeController.text +
                                    " - " +
                                    weightController.text);

                                await Fees().getSpeedFee(
                                    senderPinCodeController.text,
                                    addresseePinCodeController.text,
                                    int.parse(weightController.text), podAmount);
                                // weightAmt=double.parse(weightController.text);

                              }
                            }
                            getTotalAmount();
                          },
                          controller: weightController,
                          style: const TextStyle(
                              color: ColorConstants.kSecondaryColor),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: '',
                              fillColor: ColorConstants.kWhite,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite),
                              ),
                              prefixIcon: const Icon(
                                MdiIcons.weightGram,
                                color: ColorConstants.kSecondaryColor,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  MdiIcons.closeCircleOutline,
                                  color: ColorConstants.kSecondaryColor,
                                ),
                                onPressed: () {
                                  weightController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                              labelStyle: const TextStyle(
                                  color: ColorConstants.kAmberAccentColor),
                              labelText: 'Weight in gms*',
                              contentPadding: EdgeInsets.all(15.0.toDouble()),
                              isDense: true,
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstants.kWhite)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstants.kWhite))),
                          validator: (text) {
                            if (weightController.text.isEmpty)
                              return 'Enter the Weight';
                          },
                        ),
                        const Space(),
                        TextFormField(

                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLength: 5,
                            focusNode: prepaidAmountFocusNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (val) => getTotalAmount(),
                            onChanged: (text) async {
                              getTotalAmount();
                            },
                            controller: prepaidAmountController,
                            style: const TextStyle(
                                color: ColorConstants.kSecondaryColor),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                counterText: '',
                                fillColor: ColorConstants.kWhite,
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstants.kWhite),
                                ),
                                prefixIcon: const Icon(
                                  MdiIcons.currencyInr,
                                  color: ColorConstants.kSecondaryColor,
                                ),
                                labelStyle: const TextStyle(
                                    color: ColorConstants.kAmberAccentColor),
                                labelText: 'Prepaid Amount',
                                contentPadding:
                                    EdgeInsets.all(15.0.toDouble()),
                                isDense: true,
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.kWhite)))),
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
                        customChips(),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.all(12.0.toDouble()),
                          child: Text(
                            'Payment mode',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.kTextColor,
                                fontSize: 20.toDouble(),
                                letterSpacing: 1),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Radio<String>(
                                  value: 'Cash',
                                  groupValue: _selectedPaymentMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPaymentMode = value!;
                                    });
                                  },
                                ),
                                title: const Text('Cash'),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: Radio<String>(
                                  value: 'Digital',
                                  groupValue: _selectedPaymentMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPaymentMode = value!;
                                    });
                                  },
                                ),
                                title: const Text('Digital'),
                              ),
                            ),
                          ],
                        ),
                        const Space(),
                        const Divider(),
                        typeArticle != "Speed Post"
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0.toDouble()),
                                    child: Text(
                                      'Booking Type',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.kTextColor,
                                          fontSize: 20.toDouble(),
                                          letterSpacing: 1),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: Radio<String>(
                                            value: 'Regular',
                                            groupValue: _selectedBookingType,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedBookingType = value!;
                                              });
                                              getTotalAmount();
                                            },
                                          ),
                                          title: const Text('Regular'),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: Radio<String>(
                                            value: 'Service',
                                            groupValue: _selectedBookingType,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedBookingType = value!;
                                              });
                                              getTotalAmount();
                                            },
                                          ),
                                          title: const Text('Service'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Space(),
                                  const Divider(),
                                ],
                              )
                            : Container(),
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
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite),
                                    ),
                                    labelText: 'Pincode/Office Name *',
                                    labelStyle: TextStyle(
                                        color:
                                            ColorConstants.kAmberAccentColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants.kWhite)))),
                            onSuggestionSelected:
                                (Map<String, String> suggestion) async {
                              setState(() {
                                senderPinCode = false;
                                senderPinCodeController.text =
                                    suggestion['pinCode']!;
                                senderCityController.text = suggestion['city']!;
                                senderStateController.text =
                                    suggestion['state']!;
                                // weightAmt= double.parse(weightController.text);
                              });
                              if (typeArticle == 'Speed Post') {
                                if (senderPinCodeController.text.isNotEmpty &&
                                    weightController.text.isNotEmpty &&
                                    addresseePinCodeController
                                        .text.isNotEmpty) {
                                  // final ofcMaster = await OFCMASTERDATA()
                                  //     .select()
                                  //     .toList();

                                  await Fees().getSpeedFee(
                                      senderPinCodeController.text,
                                      // ofcMaster[0].Pincode.toString(),
                                      addresseePinCodeController.text,
                                      int.parse(weightController.text),podAmount);
                                }
                                getTotalAmount();
                              }
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
                          visible: senderPinCodeController.text.isEmpty
                              ? false
                              : true,
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
                          visible: senderPinCodeController.text.isEmpty
                              ? false
                              : true,
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
                          focusNode: addresseeMobileFocusNode,
                        ),
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
                                        color:
                                            ColorConstants.kAmberAccentColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants.kWhite)))),
                            onSuggestionSelected:
                                (Map<String, String> suggestion) async {
                              setState(() {
                                addresseePinCode = false;
                                addresseePinCodeController.text =
                                    suggestion['pinCode']!;
                                addresseeCityController.text =
                                    suggestion['city']!;
                                addresseeStateController.text =
                                    suggestion['state']!;
                                // weightAmt= double.parse(weightController.text);
                              });
                              if (typeArticle == 'Speed Post') {
                                if (senderPinCodeController.text.isNotEmpty &&
                                    weightController.text.isNotEmpty &&
                                    addresseePinCodeController
                                        .text.isNotEmpty) {
                                  // final ofcMaster = await OFCMASTERDATA().select().toList();

                                  await Fees().getSpeedFee(
                                      senderPinCodeController.text,
                                      //   ofcMaster[0].Pincode.toString(),
                                      addresseePinCodeController.text,
                                      int.parse(weightController.text),podAmount);
                                }
                                getTotalAmount();
                              }
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
                          iconData: MdiIcons.email,
                          labelText: 'Email',
                          controller: addresseeEmailController,
                          textType: TextInputType.emailAddress,
                          typeValue: 'Email',
                          focusNode: addresseeEmailFocusNode,
                        ),
                        const DoubleSpace(),
                        Align(
                            alignment: Alignment.center,
                            child: Button(
                                buttonText: 'BOOK ARTICLE',
                                buttonFunction: () async {
                                  final ifParcelPresent = await ParcelBooking()
                                      .select()
                                      .ArticleNumber
                                      .equals(articleNumberController.text)
                                      .toMapList();
                                  final ifLetterPresent = await LetterBooking()
                                      .select()
                                      .ArticleNumber
                                      .equals(articleNumberController.text)
                                      .toMapList();
                                  final ifSpeedPresent = await SpeedBooking()
                                      .select().ArticleNumber
                                      .equals(articleNumberController.text)
                                      .toMapList();
                                  if (articleNumberController.text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Enter the article number', context);
                                    articleNumberFocusNode.requestFocus();
                                  } else if (ifParcelPresent.isNotEmpty) {
                                    Toast.showFloatingToast(
                                        'Article already booked as Parcel', context);
                                  } else if (ifLetterPresent.isNotEmpty) {
                                    Toast.showFloatingToast(
                                        'Article already booked as Letter', context);
                                  } else if (ifSpeedPresent.isNotEmpty) {
                                    Toast.showFloatingToast(
                                        'Article already booked as Speed Post', context);
                                  }
                                  else if (weightController.text.isEmpty) {
                                    setState(() {
                                      weightFocusNode.requestFocus();
                                    });
                                  } else if (int.parse(weightController.text) >
                                      maximumArticleWeight) {
                                    Toast.showFloatingToast(
                                        'Maximum weight of $typeArticle is $maximumArticleWeight gms',
                                        context);
                                    weightFocusNode.requestFocus();
                                  } else if (insuranceController
                                          .text.isNotEmpty &&
                                      int.parse(insuranceController.text) >
                                          600) {
                                    Toast.showFloatingToast(
                                        'Insurance value cannot be more than \u{20B9}600',
                                        context);
                                  } else if (valuePayablePostController
                                          .text.isNotEmpty &&
                                      int.parse(
                                              valuePayablePostController.text) >
                                          5000) {
                                    Toast.showFloatingToast(
                                        'Insurance value cannot be more than \u{20B9}5000',
                                        context);
                                  } else if (senderNameController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in the Sender Name',
                                        context);
                                  } else if (senderAddressController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in the Sender Address',
                                        context);
                                  } else if (senderCityController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in pincode/Office name of the Sender',
                                        context);
                                  } else if (addresseeNameController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in the Addressee Name',
                                        context);
                                  } else if (addresseeAddressController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in the Addressee Address',
                                        context);
                                  } else if (addresseePinCodeController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in pincode/Office name of the Addressee',
                                        context);
                                  }
                                  else if (addresseeCityController
                                      .text.isEmpty) {
                                    Toast.showFloatingToast(
                                        'Please fill in pincode/Office name of the Addressee',
                                        context);
                                  }
                                  // adding article barcode check
                                  else if(artval.validate(articleNumberController.text) != "Valid")
                                  {
                                    Toast.showFloatingToast(
                                        'Please enter a valid barcode !',
                                        context);
                                    articleNumberFocusNode.requestFocus();
                                  }
                                  else if (typeArticle == 'Regd. Letter') {
                                    setState(() {
                                      insuranceFocusNode.unfocus();
                                      valuePayableFocusNode.unfocus();
                                    });
                                    if (insuranceCheck == true) {
                                      if (insuranceController.text.isEmpty) {
                                        insuranceFocusNode.requestFocus();
                                      } else if (valuePayableCheck == true) {
                                        if (valuePayablePostController
                                            .text.isEmpty) {
                                          valuePayableFocusNode.requestFocus();
                                        } else {
                                          bookLetter();
                                        }
                                      } else {
                                        bookLetter();
                                      }
                                    } else if (valuePayableCheck == true) {
                                      if (valuePayablePostController
                                          .text.isEmpty) {
                                        valuePayableFocusNode.requestFocus();
                                      } else {
                                        bookLetter();
                                      }
                                    } else {
                                      if (formGlobalKey.currentState!
                                          .validate()) {
                                        formGlobalKey.currentState!.save();
                                        bookLetter();
                                      }
                                    }
                                  }
                                  else if (typeArticle == 'Regd. Parcel') {
                                    setState(() {
                                      insuranceFocusNode.unfocus();
                                      valuePayableFocusNode.unfocus();
                                    });
                                    if (insuranceCheck == true) {
                                      if (insuranceController.text.isEmpty) {
                                        insuranceFocusNode.requestFocus();
                                      } else if (valuePayableCheck == true) {
                                        if (valuePayablePostController
                                            .text.isEmpty) {
                                          valuePayableFocusNode.requestFocus();
                                        } else {
                                          bookParcel();
                                        }
                                      } else {
                                        bookParcel();
                                      }
                                    } else if (valuePayableCheck == true) {
                                      if (valuePayablePostController
                                          .text.isEmpty) {
                                        valuePayableFocusNode.requestFocus();
                                      } else {
                                        bookParcel();
                                      }
                                    } else {
                                      if (formGlobalKey.currentState!
                                          .validate()) {
                                        formGlobalKey.currentState!.save();
                                        bookParcel();
                                      }
                                    }
                                  }
                                  else if (typeArticle == 'Speed Post') {
                                    setState(() {
                                      insuranceFocusNode.unfocus();
                                      valuePayableFocusNode.unfocus();
                                    });
                                    if (insuranceCheck == true) {
                                      if (insuranceController.text.isEmpty) {
                                        insuranceFocusNode.requestFocus();
                                      }
                                      else {
                                        if (formGlobalKey.currentState!
                                            .validate()) {
                                          print('<><><><><1');
                                          formGlobalKey.currentState!.save();
                                          showDialog<void>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return SPConformationDialog(
                                                    paymentMode:
                                                        _selectedPaymentMode,
                                                    articleNumber: articleNumberController
                                                        .text,
                                                    weight:
                                                        weightController.text,
                                                    // weightAmt.toString(),
                                                    registrationFee: registrationFee
                                                        .toString(),
                                                    serviceTaxAmount:
                                                        serviceTax.toString(),
                                                    acknowledgement: podCheck
                                                        ? podAmount.toString()
                                                        : '0.0',
                                                    prepaidAmount:
                                                        prepaidAmountController
                                                            .text,
                                                    insurance: insuranceCheck == true
                                                        ? insuranceController
                                                            .text
                                                        : '0',
                                                    amountToBeCollected:
                                                        amountToBeCollected
                                                            .toString(),
                                                    senderName: senderNameController
                                                        .text,
                                                    senderAddress: senderAddressController.text
                                                        .toString()
                                                        .replaceAll("\n", ''),
                                                    senderPinCode:
                                                        senderPinCodeController
                                                            .text,
                                                    senderCity: senderCityController
                                                        .text,
                                                    senderState: senderStateController
                                                        .text,
                                                    senderMobileNumber:
                                                        senderMobileNumberController
                                                            .text,
                                                    senderEmail:
                                                        senderEmailController
                                                            .text,
                                                    addresseeName:
                                                        addresseeNameController
                                                            .text,
                                                    addresseeAddress: addresseeAddressController.text
                                                        .toString()
                                                        .replaceAll("\n", ''),
                                                    addresseePinCode: addresseePinCodeController.text,
                                                    addresseeCity: addresseeCityController.text,
                                                    addresseeState: addresseeStateController.text,
                                                    addresseeMobileNumber: addresseeMobileNumberController.text,
                                                    addresseeEmail: addresseeEmailController.text,
                                                    function: () async{
                                                      await addSpeedBookingData();
                                                      }
                                                    );
                                              }
                                              );
                                        }
                                      }
                                    }
                                    else {
                                      print('<><><><><2');
                                      if (formGlobalKey.currentState!
                                          .validate()) {
                                        formGlobalKey.currentState!.save();
                                        showDialog<void>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return SPConformationDialog(
                                                  paymentMode:
                                                      _selectedPaymentMode,
                                                  articleNumber:
                                                      articleNumberController
                                                          .text,
                                                  weight: weightController.text,
                                                  // weightAmt.toString(),
                                                  registrationFee: registrationFee
                                                      .toString(),
                                                  serviceTaxAmount:
                                                      serviceTax.toString(),
                                                  acknowledgement: podCheck
                                                      ? podAmount.toString()
                                                      : '0.0',
                                                  prepaidAmount:
                                                      prepaidAmountController
                                                              .text.isNotEmpty
                                                          ? prepaidAmountController
                                                              .text
                                                          : '0.0',
                                                  insurance: insuranceCheck == true
                                                      ? insuranceController.text
                                                      : '0',
                                                  amountToBeCollected:
                                                      amountToBeCollected
                                                          .toString(),
                                                  senderName:
                                                      senderNameController.text,
                                                  senderAddress:
                                                      senderAddressController
                                                          .text
                                                          .toString()
                                                          .replaceAll("\n", ''),
                                                  senderPinCode:
                                                      senderPinCodeController
                                                          .text,
                                                  senderCity:
                                                      senderCityController.text,
                                                  senderState:
                                                      senderStateController
                                                          .text,
                                                  senderMobileNumber:
                                                      senderMobileNumberController
                                                          .text,
                                                  senderEmail:
                                                      senderEmailController.text,
                                                  addresseeName: addresseeNameController.text,
                                                  addresseeAddress: addresseeAddressController.text.toString().replaceAll("\n", ''),
                                                  addresseePinCode: addresseePinCodeController.text,
                                                  addresseeCity: addresseeCityController.text,
                                                  addresseeState: addresseeStateController.text,
                                                  addresseeMobileNumber: addresseeMobileNumberController.text,
                                                  addresseeEmail: addresseeEmailController.text,
                                                  function: () async{
                                                    await addSpeedBookingData();
                                                  });
                                            });
                                      }
                                    }
                                  }
                                }))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  addLetterBookingData() async {
    await addTransactionData('Register Letter');
    await BookingDBService().addRegisterLetterToDB(
        DateTimeDetails().currentDate(),
        DateTimeDetails().timeCharacter(),
        articleNumberController.text,
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        'W1',
        //weightCode
        weightController.text,
        senderNameController.text,
        senderAddressController.text.toString().replaceAll("\n", ''),
        senderCityController.text,
        senderStateController.text,
        senderPinCodeController.text,
        senderEmailController.text,
        senderMobileNumberController.text,
        addresseeNameController.text,
        addresseeAddressController.text.toString().replaceAll("\n", ''),
        addresseeCityController.text,
        addresseeStateController.text,
        addresseePinCodeController.text,
        '0',
        //tax amount
        '0',
        //postageDue
        prepaidAmountController.text.isEmpty //prepaidAmount
            ? '0'
            : prepaidAmountController.text,
        'REG',
        //vas
        '',
        //vasValue
        '0',
        //elapsedTime
        _selectedBookingType,
        //isOnPostalService
        _selectedPaymentMode == 'Cash' ? 'S' : '8' //paymentMode
        );
    weightAmt = 0.0;
    insAmt = 0.0;
    vppAmt = 0.0;
    ackAmt = 0.0;
    ppAmt = 0.0;
    registrationFee = 0.0;
  }

  addParcelBookingData() async {
    await addTransactionData('Parcel');
    await BookingDBService().addParcelToDB(
        DateTimeDetails().currentDate(),
        DateTimeDetails().timeCharacter(),
        articleNumberController.text,
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        amountToBeCollected.toString(),
        'W1',
        weightController.text,
        senderNameController.text,
        senderAddressController.text.toString().replaceAll("\n", ''),
        senderCityController.text,
        senderStateController.text,
        senderPinCodeController.text,
        addresseeNameController.text,
        addresseeAddressController.text.toString().replaceAll("\n", ''),
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
        '0',
        //elapsedtime
        '0',
        _selectedBookingType,
        'N',
        _selectedPaymentMode == 'Cash' ? 'S' : '8');
    weightAmt = 0.0;
    insAmt = 0.0;
    vppAmt = 0.0;
    ackAmt = 0.0;
    ppAmt = 0.0;
    registrationFee = 0.0;
  }

  addSpeedBookingData() async {
    print('inside Speed Post save function- MailsBookingScreen.dart');
    print(distancecode);
    print(spdistance);
    print(weightcode);


    //added below variable to calculate total tariff - prepaid amount
    //double totalAmount =double.parse(amountToBeCollected.toString());
    double totalAmount=(double.parse(registrationFee.round().toString())
        + double.parse(serviceTax.toString()));

    String isFullyPrepaid ="0";

    /*
    comment from PoS Team.
    	Field 17, Line_item_total_amount= (Base Price + Tax) – Prepaid Postage Amount, if -ve it should be zero.(it is understood that no bulk booking in single invoice)
    	Field 12, Total_Cash_Amount = Actual cash collected
    	Field 51, Postage_due= As no scenario for due, it should be zero.

     */


    if(prepaidAmountController.text.isNotEmpty) {
      double diff = (
          double.parse(registrationFee.round().toString())
          + double.parse(serviceTax.toString()))-
          double.parse(prepaidAmountController.text);
      print("Difference Amount is ${diff.toStringAsFixed(2)}");
      
      totalAmount = diff<0?0:diff;
      
    }


    //calculation of isFullyPrepaid (only when prepaid amount is more than tariff amount)
    if(prepaidAmountController.text.isNotEmpty)
      {
        isFullyPrepaid= double.parse(prepaidAmountController.text)>(
            double.parse(registrationFee.round().toString())
                + double.parse(serviceTax.toString()))?
            "1":"0";
      }


    print("before storing into DB.");
    print(isFullyPrepaid);
    print(totalAmount);
    print(prepaidAmountController.text);
    print(registrationFee.round().toString());
    print(serviceTax);
    print(amountToBeCollected);
    print("==========================");

    await BookingDBService().addSpeedToDB(
        articleNumberController.text,
        DateTimeDetails().currentDate(),
        DateTimeDetails().timeCharacter(),
        totalAmount.toStringAsFixed(2), //totalAmount
        // double.parse(amountToBeCollected.toString()).round().toString(), //totalCashAmount
        amountToBeCollected.toStringAsFixed(2), //totalCashAmount
        registrationFee.round().toString(), //BasePrice
        totalAmount.toStringAsFixed(2), //lineItemTotalAmount
        weightcode,
        weightController.text,
        distancecode,
        spdistance,
        senderNameController.text,
        senderAddressController.text.toString().replaceAll("\n", ''),
        senderCityController.text,
        senderStateController.text,
        senderPinCodeController.text,
        senderMobileNumberController.text,
        addresseeNameController.text,
        addresseeAddressController.text.toString().replaceAll("\n", ''),
        addresseeCityController.text,
        addresseeStateController.text,
        addresseePinCodeController.text,
        serviceTax.toString(), //TaxAmount
        "0.00", //postage due hardcoded to zero as no use case will come with due amount.
        // registrationFee.round().toString(), //postageDue
        prepaidAmountController.text.toString().isEmpty
            ? '0'
            : prepaidAmountController.text.toString(),
        '', //VAS
        '', //VAS Value
        '000134',
        isFullyPrepaid,//isFullyPrePaid
        '0',
        'N',
        _selectedPaymentMode == 'Cash' ? 'S' : '8');

    print("After storing into Speed Booking Table..!");

    await addTransactionData('Speed');

    weightAmt = 0.0;
    insAmt = 0.0;
    vppAmt = 0.0;
    ackAmt = 0.0;
    ppAmt = 0.0;
    registrationFee = 0.0;
  }

  addTransactionData(String type) async {
    await BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Booking',
        '$type Booking',
        date,
        time,
        amountToBeCollected.toString(),
        'Add');

    if (_selectedPaymentMode == "Cash") {
      final addCash = CashTable()
        ..Cash_ID = articleNumberController.text
        ..Cash_Date = DateTimeDetails().currentDate()
        ..Cash_Time = DateTimeDetails().onlyTime()
        ..Cash_Type = 'Add'
        ..Cash_Amount = amountToBeCollected.toDouble()
        ..Cash_Description = '$type Booking';
      await addCash.save();
    }
  }

  customChips() {
    if (typeArticle == 'Regd. Letter') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                  label: const Text('Acknowledgement'),
                  labelStyle: const TextStyle(
                      letterSpacing: 1, color: ColorConstants.kTextColor),
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
          const Space(),
          Visibility(
            visible: insuranceCheck,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.toDouble()),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 3,
                focusNode: insuranceFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => getTotalAmount(),
                onChanged: (text) async {
                  if (int.parse(insuranceController.text) > 600) {
                    Toast.showFloatingToast(
                        'Insurance value cannot be more than \u{20B9}600',
                        context);
                  }
                  await Fees().getInsuranceAmount(
                      insuranceController.text.isNotEmpty
                          ? int.parse(insuranceController.text)
                          : 0);
                  getTotalAmount();
                },
                controller: insuranceController,
                style: const TextStyle(color: ColorConstants.kSecondaryColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    fillColor: ColorConstants.kWhite,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.kWhite),
                    ),
                    prefixIcon: const Icon(
                      MdiIcons.currencyInr,
                      color: ColorConstants.kSecondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        MdiIcons.closeCircleOutline,
                        color: ColorConstants.kSecondaryColor,
                      ),
                      onPressed: () {
                        insuranceController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    labelStyle: const TextStyle(
                        color: ColorConstants.kAmberAccentColor),
                    labelText: 'Enter Insurance value',
                    contentPadding: EdgeInsets.all(15.0.toDouble()),
                    isDense: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite))),
                validator: (text) {
                  if (insuranceController.text.isEmpty)
                    return 'Enter the Amount';
                },
              ),
            ),
          ),
          const Space(),
          Visibility(
            visible: valuePayableCheck,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 8.0.toDouble(),
                  left: 20.toDouble(),
                  right: 20.toDouble()),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 4,
                focusNode: valuePayableFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => getTotalAmount(),
                onChanged: (text) async {
                  if (int.parse(valuePayablePostController.text) > 5000) {
                    Toast.showFloatingToast(
                        'VPP value cannot be more than \u{20B9}5000', context);
                  }
                  await Fees().getVPPAmount(
                      valuePayablePostController.text.isNotEmpty
                          ? int.parse(valuePayablePostController.text)
                          : 0);
                  if (int.parse(valuePayablePostController.text) > 1500) {
                    insuranceCheck = true;
                  }
                  getTotalAmount();
                },
                controller: valuePayablePostController,
                style: const TextStyle(color: ColorConstants.kSecondaryColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    fillColor: ColorConstants.kWhite,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.kWhite),
                    ),
                    prefixIcon: const Icon(
                      MdiIcons.currencyInr,
                      color: ColorConstants.kSecondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        MdiIcons.closeCircleOutline,
                        color: ColorConstants.kSecondaryColor,
                      ),
                      onPressed: () {
                        valuePayablePostController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    labelStyle: const TextStyle(
                        color: ColorConstants.kAmberAccentColor),
                    labelText: 'Enter value payable',
                    contentPadding: EdgeInsets.all(15.0.toDouble()),
                    isDense: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite))),
                validator: (text) {
                  if (valuePayablePostController.text.isEmpty)
                    return 'Enter the Amount';
                },
              ),
            ),
          ),
        ],
      );
    } else if (typeArticle == 'Regd. Parcel') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                  label: const Text('Acknowledgement'),
                  labelStyle: const TextStyle(
                      letterSpacing: 1, color: ColorConstants.kTextColor),
                  selected: acknowledgementCheck,
                  onSelected: (bool? value) {
                    setState(() {
                      acknowledgementCheck = value!;
                    });
                  }),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                label: const Text('Insurance'),
                labelStyle: const TextStyle(
                    letterSpacing: 1, color: ColorConstants.kTextColor),
                selected: insuranceCheck,
                onSelected: (bool? value) {
                  setState(() {
                    insuranceCheck = value!;
                    acknowledgementCheck = value;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Air Mail Service'),
                labelStyle: const TextStyle(
                    letterSpacing: 1, color: ColorConstants.kTextColor),
                selected: airMailServiceCheck,
                onSelected: (bool? value) async {
                  setState(() {
                    airMailServiceCheck = value!;
                  });

                  print('Airmail Service clicked');
                  print(value);
                  if (value = true) {
                    await Fees()
                        .getAirmailService(int.parse(weightController.text));
                  }
                },
              ),
            ],
          ),
          const Space(),
          Visibility(
            visible: insuranceCheck,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.toDouble()),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 3,
                focusNode: insuranceFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => getTotalAmount(),
                onChanged: (text) async {
                  if (int.parse(insuranceController.text) > 600) {
                    Toast.showFloatingToast(
                        'Insurance value cannot be more than \u{20B9}600',
                        context);
                  }
                  await Fees().getInsuranceAmount(
                      insuranceController.text.isNotEmpty
                          ? int.parse(insuranceController.text)
                          : 0);
                  getTotalAmount();
                },
                controller: insuranceController,
                style: const TextStyle(color: ColorConstants.kSecondaryColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    fillColor: ColorConstants.kWhite,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.kWhite),
                    ),
                    prefixIcon: const Icon(
                      MdiIcons.currencyInr,
                      color: ColorConstants.kSecondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        MdiIcons.closeCircleOutline,
                        color: ColorConstants.kSecondaryColor,
                      ),
                      onPressed: () {
                        insuranceController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    labelStyle: const TextStyle(
                        color: ColorConstants.kAmberAccentColor),
                    labelText: 'Enter Insurance value',
                    contentPadding: EdgeInsets.all(15.toDouble()),
                    isDense: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite))),
                validator: (text) {
                  if (insuranceController.text.isEmpty)
                    return 'Enter the Amount';
                },
              ),
            ),
          ),
          const Space(),
          Visibility(
            visible: valuePayableCheck,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 8.0.toDouble(),
                  left: 20.toDouble(),
                  right: 20.toDouble()),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 4,
                focusNode: valuePayableFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => getTotalAmount(),
                onChanged: (text) async {
                  if (int.parse(valuePayablePostController.text) > 5000) {
                    Toast.showFloatingToast(
                        'VPP value cannot be more than \u{20B9}5000', context);
                  }
                  await Fees().getVPPAmount(
                      valuePayablePostController.text.isNotEmpty
                          ? int.parse(valuePayablePostController.text)
                          : 0);
                  if (int.parse(valuePayablePostController.text) > 1500) {
                    insuranceCheck = true;
                  }
                  getTotalAmount();
                },
                controller: valuePayablePostController,
                style: const TextStyle(color: ColorConstants.kSecondaryColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    fillColor: ColorConstants.kWhite,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.kWhite),
                    ),
                    prefixIcon: const Icon(
                      MdiIcons.currencyInr,
                      color: ColorConstants.kSecondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        MdiIcons.closeCircleOutline,
                        color: ColorConstants.kSecondaryColor,
                      ),
                      onPressed: () {
                        valuePayablePostController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    labelStyle: const TextStyle(
                        color: ColorConstants.kAmberAccentColor),
                    labelText: 'Enter value payable',
                    contentPadding: EdgeInsets.all(15.0.toDouble()),
                    isDense: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite))),
                validator: (text) {
                  if (valuePayablePostController.text.isEmpty)
                    return 'Enter the Amount';
                },
              ),
            ),
          ),
        ],
      );
    } else if (typeArticle == 'Speed Post') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChoiceChip(
                  label: const Text('POD'),
                  labelStyle: const TextStyle(
                      letterSpacing: 1, color: ColorConstants.kTextColor),
                  selected: podCheck,
                  onSelected: (bool? value) {
                    setState(() {
                      podCheck = value!;
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
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 3,
                focusNode: insuranceFocusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSaved: (val) => getTotalAmount(),
                onChanged: (text) async {
                  if (int.parse(insuranceController.text) > 600) {
                    Toast.showFloatingToast(
                        'Insurance value cannot be more than \u{20B9}600',
                        context);
                  }
                  await Fees().getInsuranceAmount(
                      insuranceController.text.isNotEmpty
                          ? int.parse(insuranceController.text)
                          : 0);
                  getTotalAmount();
                },
                controller: insuranceController,
                style: const TextStyle(color: ColorConstants.kSecondaryColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    counterText: '',
                    fillColor: ColorConstants.kWhite,
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.kWhite),
                    ),
                    prefixIcon: const Icon(
                      MdiIcons.currencyInr,
                      color: ColorConstants.kSecondaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        MdiIcons.closeCircleOutline,
                        color: ColorConstants.kSecondaryColor,
                      ),
                      onPressed: () {
                        insuranceController.clear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    labelStyle: const TextStyle(
                        color: ColorConstants.kAmberAccentColor),
                    labelText: 'Enter Insurance value',
                    contentPadding: EdgeInsets.all(15.0.toDouble()),
                    isDense: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.kWhite))),
                validator: (text) {
                  if (insuranceController.text.isEmpty)
                    return 'Enter the Amount';
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  void _dropDownItemSelected(String valueSelectedByUser) {
    setState(() {
      typeArticle = valueSelectedByUser;
      _selectedArticle = true;
    });
  }

  void bookLetter() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return RLConformationDialog(
              articleNumber: articleNumberController.text,
              weight: weightController.text.trim(),
              weightAmount: weightAmt.toString(),
              registrationFee: registrationFee.toString(),
              prepaidAmount: prepaidAmountController.text.isEmpty
                  ? '0.0'
                  : ppAmt.toString(),
              acknowledgement: acknowledgementCheck,
              insurance: insuranceCheck == true ? insAmt.toString() : '',
              valuePayablePost:
                  valuePayableCheck == true ? vppAmt.toString() : '',
              amountToBeCollected: amountToBeCollected.toString(),
              senderName: senderNameController.text,
              senderAddress:
                  senderAddressController.text.toString().replaceAll("\n", ''),
              senderPinCode: senderPinCodeController.text,
              senderCity: senderCityController.text,
              senderState: senderStateController.text,
              senderMobileNumber: senderMobileNumberController.text,
              senderEmail: senderEmailController.text,
              addresseeName: addresseeNameController.text,
              addresseeAddress: addresseeAddressController.text
                  .toString()
                  .replaceAll("\n", ''),
              addresseePinCode: addresseePinCodeController.text,
              addresseeCity: addresseeCityController.text,
              addresseeState: addresseeStateController.text,
              addresseeMobileNumber: addresseeMobileNumberController.text,
              addresseeEmail: addresseeEmailController.text,
              paymentMode: _selectedPaymentMode,
              function: () async{
                print("inside letter booking saving");
                await addLetterBookingData();
                await GeneratePDF("Regd. Letter", articleNumberController.text);
                //Alert is alredy there
                // showDialog<void>(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('Confirmation'),
                //         content: Text(
                //             'Successfully booked a RL of \u{20B9}$amountToBeCollected with Article Number ${articleNumberController.text}'),
                //         actions: [
                //           Button(
                //               buttonText: 'PRINT',
                //               buttonFunction: () async {
                //                 print('inside Print Button');
                //                 PrintingTelPO printer = new PrintingTelPO();
                //                 await printer.printThroughUsbPrinter(
                //                     "BOOKING",
                //                     "Regd. Letter",
                //                     basicInformation,
                //                     secondReceipt,
                //                     1);
                //
                //                 //PDF Code Commented
                //
                //                 // print(pdfName.toString());
                //                 // await OpenFile.open(pdfName);
                //               }),
                //           Button(
                //               buttonText: 'OKAY',
                //               buttonFunction: () {
                //                 Navigator.pushAndRemoveUntil(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (_) =>
                //                             const BookingMainScreen()),
                //                     (route) => false);
                //               })
                //         ],
                //       );
                //     });
              });
        });
  }

  void bookParcel() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ParcelConformationDialog(
              paymentMode: _selectedPaymentMode,
              airMailAmount: airMailAmt.toString(),
              articleNumber: articleNumberController.text,
              weight: weightController.text.trim(),
              weightAmount: weightAmt.toString(),
              registrationFee: registrationFee.toString(),
              prepaidAmount: prepaidAmountController.text.isEmpty
                  ? '0.0'
                  : ppAmt.toString(),
              acknowledgement: acknowledgementCheck,
              insurance: insuranceCheck == true ? insAmt.toString() : '',
              valuePayablePost:
                  valuePayableCheck == true ? vppAmt.toString() : '',
              amountToBeCollected: amountToBeCollected.toString(),
              senderName: senderNameController.text,
              senderAddress:
                  senderAddressController.text.toString().replaceAll("\n", ''),
              senderPinCode: senderPinCodeController.text,
              senderCity: senderCityController.text,
              senderState: senderStateController.text,
              senderMobileNumber: senderMobileNumberController.text,
              senderEmail: senderEmailController.text,
              addresseeName: addresseeNameController.text,
              addresseeAddress: addresseeAddressController.text
                  .toString()
                  .replaceAll("\n", ''),
              addresseePinCode: addresseePinCodeController.text,
              addresseeCity: addresseeCityController.text,
              addresseeState: addresseeStateController.text,
              addresseeMobileNumber: addresseeMobileNumberController.text,
              addresseeEmail: addresseeEmailController.text,
              function: () async {
                await addParcelBookingData();
                await GeneratePDF("PARCEL",articleNumberController.text);
                //Dialog is already there
                // showDialog<void>(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('Confirmation'),
                //         content: Text(
                //             'Successfully booked a Parcel of \u{20B9}$amountToBeCollected with Article Number ${articleNumberController.text}'),
                //         actions: [
                //           Button(
                //               buttonText: 'PRINT',
                //               buttonFunction: () async {
                //                 print('inside Print Button');
                //                 PrintingTelPO printer = new PrintingTelPO();
                //                 await printer.printThroughUsbPrinter(
                //                     "BOOKING",
                //                     "Regd. Parcel",
                //                     basicInformation,
                //                     secondReceipt,
                //                     1);
                //
                //                 //PDF Code commented.
                //                 // print(pdfName.toString());
                //                 // await OpenFile.open(pdfName);
                //               }),
                //           Button(
                //               buttonText: 'OKAY',
                //               buttonFunction: () {
                //                 Navigator.pushAndRemoveUntil(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (_) =>
                //                             const BookingMainScreen()),
                //                     (route) => false);
                //               })
                //         ],
                //       );
                //     });
              });
        });
  }
}

var deliverAddress = {
  "receiver_address": [
    {
      "name": "Subosh",
      "address": "1st phase, 2nd cross, Ramakrishnanagara",
      "pincode": "570022",
      "city": "Mysuru",
      "state": "Karnataka",
      "mobile_number": "9876543210",
      "email": "Subosh@gmail.com",
      "isCheck": false
    },
    {
      "name": "Niranjan",
      "address": "4th phase, Sector 2, HSR Layout",
      "pincode": "560026",
      "city": "Bengaluru",
      "state": "Karnataka",
      "mobile_number": "9876123210",
      "email": "niranjan@gmail.com",
      "isCheck": false
    },
    {
      "name": "Adhvik",
      "address": "#34, 3rd cross, Vijayanagar 1st stage",
      "pincode": "560016",
      "city": "Bengaluru",
      "state": "Karnataka",
      "mobile_number": "9845123210",
      "email": "",
      "isCheck": false
    },
    {
      "name": "HP PETROL PUMP VITTA BHIMAIAH SETTY CO",
      "address": "Hospet Road",
      "pincode": "583101",
      "city": "Ballari",
      "state": "Karnataka",
      "mobile_number": "",
      "email": "",
      "isCheck": false
    },
  ]
};

var senderAddress = {
  "sender_address": [
    {
      "name": "Niroop",
      "address": "#1384/1 Renukacharya temple road, KR Mohalla",
      "pincode": "570004",
      "city": "Mysuru",
      "state": "Karnataka",
      "mobile_number": "9741814444",
      "email": "niroop@gmail.com",
      "isCheck": false
    }
  ]
};
