
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMOConformationDialog.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchPin.dart';
import 'package:darpan_mine/Widgets/CustomToast.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../BookingMainScreen.dart';

class PMOUpdatedScreen extends StatefulWidget {
  String? sName;
  String? sAddress;
  String? sPinCode;
  String? sCity;
  String? sState;
  String? sMobile;
  String? sEmail;

  PMOUpdatedScreen(
      {Key? key,
      required this.sName,
      required this.sAddress,
      required this.sPinCode,
      required this.sCity,
      required this.sState,
      required this.sMobile,
      required this.sEmail})
      : super(key: key);

  @override
  _PMOUpdatedScreenState createState() => _PMOUpdatedScreenState();
}

class _PMOUpdatedScreenState extends State<PMOUpdatedScreen> {
  bool senderFormOpenFlag = false;
  bool senderNotCompleted = false;
  bool senderPinCode = false;
  bool addresseeFormOpenFlag = false;

  final formGlobalKey = GlobalKey<FormState>();

  Color senderHeadingColor = ColorConstants.kPrimaryAccent;
  Color addresseeHeadingColor = ColorConstants.kPrimaryAccent;

  final emoValueFocusNode = FocusNode();
  final senderNameFocusNode = FocusNode();
  final senderAddressFocusNode = FocusNode();
  final senderPinCodeFocusNode = FocusNode();
  final senderMobileFocusNode = FocusNode();
  final senderEmailFocusNode = FocusNode();

  final emoValueController = TextEditingController();
  final senderNameController = TextEditingController();
  final senderAddressController = TextEditingController();
  final senderPinCodeController = TextEditingController();
  final senderCityController = TextEditingController();
  final senderStateController = TextEditingController();
  final senderMobileNumberController = TextEditingController();
  final senderEmailController = TextEditingController();
  final addresseeNameController =
      TextEditingController(text: 'Prime Minister Relief Fund');
  final addresseeAddressController =
      TextEditingController(text: 'Prime Minister Office');
  final addresseePinCodeController = TextEditingController(text: '110011');
  final addresseeCityController =
      TextEditingController(text: 'South block, Raisina Hill');
  final addresseeStateController = TextEditingController(text: 'New Delhi');
  final addresseeMobileNumberController = TextEditingController();
  final addresseeEmailController = TextEditingController();

  String date = DateTimeDetails().onlyDate();
  String time = DateTimeDetails().onlyTime();

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
    enterFetchedValuesToTextField();
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ColorConstants.kPrimaryColor.withOpacity(.9),
          onPressed: () {
            ToastUtil.show(
                ToastDecorator(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                MdiIcons.currencyInr,
                                size: 30,
                                color: ColorConstants.kWhite,
                              ),
                              Text(
                                emoValueController.text,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.toDouble()),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          title: const Text('Amount to be collected',
                              style: TextStyle(
                                  color: ColorConstants.kWhite,
                                  letterSpacing: 2)),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: ColorConstants.kGrassGreen,
                ),
                context,
                gravity: ToastGravity.bottom);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          label: getTotal(),
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
                  DialogText(title: '\tMessage : ', subtitle: '\t $pmoMessage'),
                  const Space(),
                  CAdditionalServiceForm(
                    isVPP:false,
                    labelText: 'EMO Value *',
                    focusNode: emoValueFocusNode,
                    controller: emoValueController,
                    typeValue: 'EMOValue',
                    iconData: MdiIcons.currencyInr,
                  ),
                  const DoubleSpace(),
                  const Divider(),

                  //Sender Details
                  const Divider(),
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
                    labelText: 'Mobile Number(for SMS *)',
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
                  InitialTextFormField(
                      controller: addresseeNameController,
                      iconData: Icons.person,
                      labelText: 'Name'),
                  InitialTextFormField(
                      controller: addresseeAddressController,
                      iconData: MdiIcons.home,
                      labelText: 'Address'),
                  InitialTextFormField(
                      controller: addresseePinCodeController,
                      iconData: Icons.location_on_outlined,
                      labelText: 'Pincode'),
                  InitialTextFormField(
                      controller: addresseeCityController,
                      iconData: Icons.location_city,
                      labelText: 'City'),
                  InitialTextFormField(
                      controller: addresseeStateController,
                      iconData: Icons.location_city,
                      labelText: 'State'),

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
                            emoValueFocusNode.unfocus();
                          });
                          if (senderNameController.text.isEmpty ||
                              senderAddressController.text.isEmpty ||
                              senderCityController.text.isEmpty) {
                            senderNotCompleted = true;
                          }
                          if (formGlobalKey.currentState!.validate()) {
                            formGlobalKey.currentState!.save();
                            await PNRGeneration();
                            showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return EMOConformationDialog(
                                      pnrNumber: PNRNumber.toString(),
                                      emoValue: emoValueController.text,
                                      message: pmoMessage,
                                      commission: '',
                                      amountToBeCollected:
                                          emoValueController.text,
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
                                      isVPP: false,
                                      function: () async{
                                      await bookFunction();
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) =>
                                        //             const BookingMainScreen()),
                                        //     (route) => false);
                                      });
                                });
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

  bookFunction() async {
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();

    await BookingDBService().addEMOToDB(
        PNRNumber.toString(),
        DateTimeDetails().currentDate(),
        DateTimeDetails().timeCharacter(),
        emoValueController.text.toString(),
        emoValueController.text.toString(),
        fileMaster[0].ORDERTYPE_EMO.toString(),
        fileMaster[0].PRODUCT_TYPE.toString(),
        'V2'
        //valueCode
        ,
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
        '0'
        //Commission Amount is ZERO (0)
        ,
        emoValueController.text,
        'PM Relief Fund',
        false);

    final addCash =  CashTable()
      ..Cash_ID = senderPinCodeController.text
      ..Cash_Date = date
      ..Cash_Time = time
      ..Cash_Type = 'Add'
      ..Cash_Amount = double.parse(emoValueController.text)
      ..Cash_Description = 'PMO Booking';
    await addCash.save();

    BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().onlyTime()}',
        'Booking',
        'PMO Booking',
        DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(),
        emoValueController.text,
        'Add');
  }

  Widget getTotal() {
    if (emoValueController.text.isEmpty) {
      return Text(
        '\u{20B9} 0',
        style: TextStyle(fontSize: 20.toDouble()),
      );
    } else {
      return Text(
        '\u{20B9} ${emoValueController.text}',
        style: TextStyle(fontSize: 20.toDouble()),
      );
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
