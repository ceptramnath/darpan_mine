import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Reports/GenerateBODA/BODASlipScreen.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../HomeScreen.dart';
import '../../../../UtilitiesMainScreen.dart';

class GenerateBODAReportScreen extends StatefulWidget {
  const GenerateBODAReportScreen({Key? key}) : super(key: key);

  @override
  _GenerateBODAReportScreenState createState() =>
      _GenerateBODAReportScreenState();
}

class _GenerateBODAReportScreenState extends State<GenerateBODAReportScreen> {
  String? selectedLiability;
  String savedCashToAO = '';

  bool _balanceVisible = false;

  double walletAmount = 0.0;
  double liability = 0.0;

  String currentDate = '';
  String previousBalance = '';
  double openingBalance = 0;
  double closingBalance = 0;
  String mailsBooked = '';
  String registerBooked = '';
  String liabilityDescription = '';
  double liabilityAmount = 0;

  double totalReceipts = 0;
  double totalPayments = 0;

  int emoValue = 0;
  int emoCommission = 0;

  int mailsCount = 0;
  int psvalue=0;
  int rlMailsCount = 0;
  int speedMailsCount = 0;
  int emoMailsCount = 0;
  int parcelMailsCount = 0;
  int codReceiptCount = 0;
  int cashTOAO = 0;
  int cashIndent = 0;
  double productsCount = 0;
  int liabilityCount = 0;
  int bankingLiabilityCount = 0;
  int insuranceLiabilityCount = 0;
  int emoLiabilityCount = 0;
  int sbDepositAmount = 0;
  int rdDepositAmount = 0;
  int billTotal = 0;
  double bagCashTotal = 0;
  int ippbDepositAmount = 0;
  int ippbDeposits = 0;
  int otherDepositsAmount=0;
  int cscDepositsAmount=0;
  int sbWithdrawAmount = 0;
  int rdWithdrawAmount = 0;
  int ippbWithdraws = 0;
  int ippbWithdrawAmount = 0;
  int otherWithdrawlAmount=0;
  String othersText="";
  int dcudeWithdrawlAmount=0;
  double pliDepositAmount = 0;
  double rpliDepositAmount = 0;
  double pliWithdrawAmount = 0;
  double rpliWithdrawAmount = 0;
  int bankDepositAmount = 0;
  int bankWithdrawAmount = 0;
  double insuranceDepositAmount = 0;
  double insuranceWithdrawAmount = 0;
  double emoPaid = 0;

  List mails = [];
  List banking = [];
  List bills = [];
  List bags = [];
  List ippb = [];
  List dcube=[];
  List csc=[];
  List others=[];
  List insurance = [];
  List insurancePolicyNumber = [];
  List insurancePolicyType = [];
  List insurancePolicyAmount = [];
  List allBookedMails = [];
  List products = [];
  List bookedRL = [];
  List bookedRLAmount = [];
  List bookedEMO = [];
  List bookedEMOAmount = [];
  List bookedSpeed = [];
  List bookedSpeedAmount = [];
  List bookedParcel = [];
  List bookedParcelAmount = [];
  List billNames = [];
  List billAmount = [];
  List productType = [];
  List productAmount = [];
  List bagNumber = [];
  List bagCash = [];

  List sbDeposit = [];
  List sbAmountDeposit = [];
  List sbWithdraw = [];
  List sbAmountWithdraw = [];
  List rdDeposit = [];
  List rdAmountDeposit = [];
  List rdWithdraw = [];
  List rdAmountWithdraw = [];
  List pliDeposit = [];
  List pliAmountDeposit = [];
  List pliWithdraw = [];
  List pliAmountWithdraw = [];
  List rpliDeposit = [];
  List rpliAmountDeposit = [];
  List rpliWithdraw = [];
  List rpliAmountWithdraw = [];

  List liabilities = [];
  List liabilityCategories = [];
  List liabilityAccountNumber = [];
  List mailsLiability = [];
  List mailsAmountLiability = [];
  List<String> liabilityTypes = ['EMO', 'Banking', 'Insurance'];

  final aoRequestCashController = TextEditingController();
  final aoConfirmCashController = TextEditingController();
  final liabilityReasonController = TextEditingController();
  final documentsReasonController = TextEditingController();
  final weightController = TextEditingController();
  final liabilityAmountController = TextEditingController();
  final liabilityNumberController = TextEditingController();
  final cashReceivedController = TextEditingController();

  final aoRequestCashFocus = FocusNode();
  final aoConfirmCashFocus = FocusNode();
  final liabilityReasonFocus = FocusNode();
  final documentsReasonFocus = FocusNode();
  final weightFocus = FocusNode();
  String? boname, boid, empid, empname;
  double? wal, max;
  int? maxAmount;
  double cashReceived = 0;

  // late int maxAmount=2100;
  getWalletAmount() async {
    print('Inside getWalletAmount in BODA Generation');

    wal = walletAmount;

    //added below code by Rohit to fetch Office Master Data
    final ofcMaster = await OFCMASTERDATA().select().toList();
    boname = ofcMaster[0].BOName.toString();
    boid = ofcMaster[0].BOFacilityID.toString();
    empid = ofcMaster[0].EMPID.toString();
    empname = ofcMaster[0].EmployeeName.toString();

    //fetching Maximum Authorized Amount from Ofc Master Data added by Rohit on 28-01-2023
    maxAmount = int.tryParse(ofcMaster[0].MAXBAL.toString()) != null
        ? int.parse(ofcMaster[0].MAXBAL.toString())
        : 0;

    max = double.parse(maxAmount.toString());

    print('Initialization in BODA generation..!');
    print(wal);
    print(max);
    print('*************');

    final bags = await BagCashTable()
        .select()
        .BagDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (bags.isNotEmpty) {
      print('inside if condition' + bags.length.toString());
      for (int i = 0; i < bags.length; i++) {
        print('inside for loop $i');
        print(bags[i]['CashAmount']);
        print(double.parse(bags[i]['CashAmount'].toString()));

        cashReceived += double.parse(bags[i]['CashAmount']);
      }
    }
    print('Cash received through Special Remittance');
    var cashFromAO = await CashTable()
        .select()
        .Cash_ID
        .equals("CashFromAO_${DateTimeDetails().dateCharacter()}")
        .toList();
    if (cashFromAO.isNotEmpty) {
      cashReceived += cashFromAO[0].Cash_Amount!;
    }

    cashReceivedController.text = cashReceived.toStringAsFixed(2);

    final aoCash = await CashTable()
        .select()
        .Cash_Date
        .equals(DateTimeDetails().currentDate())
        .and
        .Cash_Description
        .equals('Cash To A.O')
        .toMapList();
    if (aoCash.isNotEmpty) {
      savedCashToAO = aoCash[aoCash.length - 1]['Cash_Amount'].toString();
    }
    final liability = await Liability()
        .select()
        .Date
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (liability.isNotEmpty) {
      liabilityReasonController.text = liability[0]['Description'];
    }
    final cashDetails = await BodaSlip()
        .select()
        .bodaDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (cashDetails.isNotEmpty) {
      aoConfirmCashController.text = cashDetails[0]['cashTo'];
      aoRequestCashController.text = cashDetails[0]['cashFrom'];
    }
    final indent = await CashIndent()
        .select()
        .SOGenerationDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (indent.isNotEmpty) {
      weightController.text = indent[0]['Weight'];
    }

    final prefs = await SharedPreferences.getInstance();
    final String? aoRequestValue = prefs.getString('aoRequest');
    final String? aoConfirmValue = prefs.getString('aoConfirm');
    final String? aoWeightValue = prefs.getString('aoWeight');
    if (aoRequestValue.toString() != 'null') {
      aoRequestCashController.text = aoRequestValue!;
    }
    if (aoConfirmValue.toString() != 'null') {
      aoConfirmCashController.text = aoConfirmValue!;
    }
    if (aoWeightValue.toString() != 'null') {
      weightController.text = aoWeightValue!;
    }
    walletAmount = await CashService().cashBalance();
    liabilities = await TempLiability().select().toMapList();
    if (walletAmount > maxAmount!) _balanceVisible = true;
    return maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToPrevious(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
              //     (route) => false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainHomeScreen(UtilitiesMainScreen(), 0)),
              );
            },
          ),
          elevation: 0,
          title: const Text('Branch Office Daily Account'),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: FutureBuilder(
          future: getWalletAmount(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Step 1
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Balance : ${walletAmount.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '(Max amount : ${maxAmount?.toStringAsFixed(2)})',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Container(
                                  width: 90,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: ColorConstants.kPrimaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const DoubleSpace(),
                          Visibility(
                              visible: _balanceVisible,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Excess',
                                        style: headingTextStyle(),
                                      ),
                                      Text(
                                        '\u{20B9}' + getBalance().toString(),
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                ColorConstants.kPrimaryColor),
                                      )
                                    ],
                                  ),
                                  const Space(),
                                  Text(
                                    'Closing balance of ${boname.toString()} exceeds the maximum sanctioned amount of \u{20B9}$maxAmount limit by \u{20B9}${getBalance()}.\n',
                                    style: headingTextStyle(),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('Cash from AO',
                                      style: headingTextStyle())),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text(':'),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0.toDouble(),
                                        horizontal: 2.0.toDouble()),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: cashReceivedController,
                                      style: const TextStyle(
                                          color:
                                              ColorConstants.kSecondaryColor),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          counterText: '',
                                          fillColor: Colors.grey[300],
                                          filled: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorConstants.kWhite),
                                          ),
                                          prefixIcon: const Icon(
                                            MdiIcons.currencyInr,
                                            color:
                                                ColorConstants.kSecondaryColor,
                                          ),
                                          isDense: true,
                                          border: InputBorder.none,
                                          // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorConstants
                                                          .kWhite))),
                                      validator: (text) {},
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('Cash to AO',
                                      style: headingTextStyle())),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text(':'),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0.toDouble(),
                                        horizontal: 2.0.toDouble()),
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: aoConfirmCashController,
                                      style: const TextStyle(
                                          color:
                                              ColorConstants.kSecondaryColor),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          counterText: '',
                                          fillColor: ColorConstants.kWhite,
                                          filled: true,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ColorConstants.kWhite),
                                          ),
                                          prefixIcon: const Icon(
                                            MdiIcons.currencyInr,
                                            color:
                                                ColorConstants.kSecondaryColor,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              MdiIcons.closeCircleOutline,
                                              color: ColorConstants
                                                  .kSecondaryColor,
                                            ),
                                            onPressed: () {
                                              aoConfirmCashController.clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                          isDense: true,
                                          border: InputBorder.none,

                                          // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: ColorConstants
                                                          .kGrassGreen))),
                                      validator: (text) {
                                      print(walletAmount.toStringAsFixed(2));
                                      print(text);
                                      if(text!.length > 0 && double.parse(text!) > walletAmount)
                                      //UtilFs1.showToast("Please enter a valid amount ! ", context);
                                      aoConfirmCashController.clear();
                                         },

                                    ),
                                  ))
                            ],
                          ),

                          // wal! > max! ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Space(),
                              TextFormField(
                                focusNode: liabilityReasonFocus,
                                controller: liabilityReasonController,
                                decoration: const InputDecoration(
                                    counterText: '',
                                    fillColor: ColorConstants.kWhite,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: ColorConstants.kSecondaryColor,
                                    ),
                                    labelStyle: TextStyle(
                                        color:
                                            ColorConstants.kAmberAccentColor),
                                    labelText: 'Liability Reason',
                                    isDense: false,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ColorConstants.kGrassGreen))),
                                minLines: 3,
                                maxLines: null,
                              ),
                              const DoubleSpace(),
                            ],
                          ),
                          // : Container(),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text('Cash Bag Weight ',
                                      style: headingTextStyle())),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text(':'),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0.toDouble(),
                                        horizontal: 3.0.toDouble()),
                                    child: CInputForm(
                                        readOnly: false,
                                        iconData: MdiIcons.weight,
                                        labelText: 'Weight',
                                        controller: weightController,
                                        textType: TextInputType.number,
                                        typeValue: 'Weight',
                                        focusNode: weightFocus),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                      'Cash Indent from AO for Liability',
                                      style: headingTextStyle())),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: const Text(':'),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0.toDouble(),
                                        horizontal: 2.0.toDouble()),
                                    child: CInputForm(
                                        readOnly: false,
                                        iconData: MdiIcons.currencyInr,
                                        labelText: 'Cash',
                                        controller: aoRequestCashController,
                                        textType: TextInputType.number,
                                        typeValue: 'Amount',
                                        focusNode: aoRequestCashFocus),
                                  ))
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Space(),
                              TextFormField(
                                focusNode: documentsReasonFocus,
                                controller: documentsReasonController,
                                decoration: const InputDecoration(
                                    counterText: '',
                                    fillColor: ColorConstants.kWhite,
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: ColorConstants.kSecondaryColor,
                                    ),
                                    labelStyle: TextStyle(
                                        color:
                                            ColorConstants.kAmberAccentColor),
                                    labelText: 'Documents to AO',
                                    isDense: false,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ColorConstants.kGrassGreen))),
                                minLines: 3,
                                maxLines: null,
                              ),
                              // const DoubleSpace(),
                            ],
                          ),
                          // const DoubleSpace(),
                        ],
                      ),
                      const DoubleSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Button(
                              buttonText: 'CANCEL',
                              buttonFunction: () => moveToPrevious(context)),
                          Button(
                              buttonText: 'CONFIRM',
                              buttonFunction: () async {
                                getBODAConfirm();
                              })
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void moveToPrevious(BuildContext context) {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
    //     (route) => false);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MainHomeScreen(UtilitiesMainScreen(), 0)),
    );
  }

  // aoRequestCashController
  void moveToNext(BuildContext context) async {
    await BookingDBService().addCashIndent(
        DateTimeDetails().dateCharacter(),
        aoRequestCashController.text.isNotEmpty
            ? aoRequestCashController.text
            : '',
        weightController.text.isNotEmpty ? weightController.text : '');
    var currentDate = DateTimeDetails().onlyDate();
    final saveBODA = await BodaSlip()
      ..bodaDate = currentDate
      ..bodaNumber = '${boid}${currentDate.replaceAll(RegExp('-'), '')}'
      ..cashFrom = aoRequestCashController.text
      ..cashTo = aoConfirmCashController.text;
    await saveBODA.save();
    final deleteAll = await TempLiability().select().delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BODASlipScreen()),
        (route) => false);
  }

  headingTextStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kTextColor);
  }

  tableHeadingTextStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kTextColor);
  }

  getBalance() {
    int aoAmount = 0;
    int liabilityAmount = 0;
    var balance;
    if (aoConfirmCashController.text.isNotEmpty) {
      aoAmount = int.parse(aoConfirmCashController.text);
    }
    if (liabilityAmountController.text.isNotEmpty) {
      liabilityAmount = int.parse(liabilityAmountController.text);
    }
    if (savedCashToAO.isNotEmpty) {
      if (double.parse(savedCashToAO) ==
          (aoConfirmCashController.text.isNotEmpty
              ? double.parse(aoConfirmCashController.text.trim())
              : 0.0)) {
        balance = walletAmount - maxAmount! - liabilityAmount;
      } else {
        balance = walletAmount - maxAmount! - liabilityAmount - aoAmount;
      }
    } else {
      balance = walletAmount - maxAmount! - liabilityAmount - aoAmount;
    }
    if (balance < 0) {
      return double.parse("0.00").toStringAsFixed(2);
    } else {
      return double.parse(balance.toString()).toStringAsFixed(2);
    }
  }

  getBODAConfirm() async {
    if (savedCashToAO.isNotEmpty) {
      if (aoConfirmCashController.text.isEmpty) {
        aoConfirmCashFocus.requestFocus();
        Toast.showFloatingToast('Enter the Amount', context);
      } else {
        if (double.parse(savedCashToAO) !=
            double.parse(aoConfirmCashController.text.trim())) {
          final savedCashToAO = await CashTable()
              .select()
              .Cash_Date
              .equals(DateTimeDetails().currentDate())
              .and
              .Cash_Description
              .equals('Cash To A.O')
              .toMapList();
          walletAmount = walletAmount + savedCashToAO[0]['Cash_Amount'];
        }
      }
    }
    double excess = double.parse(getBalance());
    if (excess > 0) {
      if (liabilityReasonController.text.isEmpty) {
        liabilityReasonFocus.requestFocus();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Note!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Please fill in the Liability Reason as still \u{20B9} ${getBalance()} is remained as Excess, which will be made as Liability'),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      focusNode: liabilityReasonFocus,
                      controller: liabilityReasonController,
                      decoration: const InputDecoration(
                          counterText: '',
                          fillColor: ColorConstants.kWhite,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.kWhite),
                          ),
                          prefixIcon: Icon(
                            Icons.description,
                            color: ColorConstants.kSecondaryColor,
                          ),
                          labelStyle: TextStyle(
                              color: ColorConstants.kAmberAccentColor),
                          labelText: 'Liability Reason',
                          isDense: true,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.kWhite))),
                      minLines: 2,
                      maxLines: null,
                    ),
                  ],
                ),
                actions: [
                  Button(
                      buttonText: 'OKAY',
                      buttonFunction: () {
                        if (liabilityReasonController.text.isEmpty) {
                          Toast.showFloatingToast('Enter the reason', context);
                        } else {
                          Navigator.pop(context);
                          addBODA();
                        }
                      }),
                  Button(
                      buttonText: 'CANCEL',
                      buttonFunction: () {
                        Navigator.pop(context);
                      }),
                ],
              );
            });
      } else {
        liability = excess.toDouble();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Note!'),
                content: Text(
                    '\u{20B9} $excess is remained as Excess will be made as Liability'),
                actions: [
                  Button(
                      buttonText: 'OKAY',
                      buttonFunction: () {
                        Navigator.pop(context);
                        addBODA();
                      }),
                ],
              );
            });
      }
    } else {
      addBODA();
    }
  }

  addBODA() async {
    var currentDate = DateTimeDetails().currentDate();
    String bodanumber = '${boid}${currentDate.replaceAll(RegExp('-'), '')}';

    if (savedCashToAO.isNotEmpty) {
      if (double.parse(savedCashToAO) !=
          double.parse(aoConfirmCashController.text.trim())) {
        final addAOCash = await CashTable()
          ..Cash_ID = "CASHTOAO" + DateTimeDetails().currentDateTime()
          ..Cash_Date = DateTimeDetails().currentDate()
          ..Cash_Time = DateTimeDetails().onlyTime()
          ..Cash_Type = 'Add'
          ..Cash_Amount = double.parse(savedCashToAO)
          ..Cash_Description = 'Cash To A.O Revert';
        await addAOCash.save();
      }
    }

    if (aoConfirmCashController.text.isNotEmpty) {
      print("Cash to AO in BODA Generation..!");

      final addAOCash = await CashTable()
        ..Cash_ID = "CASHTOAO" + DateTimeDetails().currentDateTime()
        ..Cash_Date = DateTimeDetails().currentDate()
        ..Cash_Time = DateTimeDetails().onlyTime()
        ..Cash_Type = 'Minus'
        ..Cash_Amount = double.parse(aoConfirmCashController.text)
        ..Cash_Description = 'Cash To A.O';
      await addAOCash.save();

      print("Before Calculation");
      setState(() {
        closingBalance = walletAmount -
            double.parse(aoConfirmCashController.text);
      });


      print(closingBalance);

      print(DateTimeDetails().currentDate());
      final updateDayModel= await DayModel()
          .select()
          .DayBeginDate
          .equals(DateTimeDetails().currentDate())
          .update({'CashClosingBalance': closingBalance.toStringAsFixed(2)});

      print(updateDayModel);

      final aoTransaction = await TransactionTable()
          .select()
          .tranDate
          .equals(DateTimeDetails().currentDate())
          .toMapList();
      if (aoTransaction.isEmpty) {
        final addTransaction =await TransactionTable()
          ..tranid = "CASHTOAO" + DateTimeDetails().currentDateTime()
          ..tranType = 'Cash To AO'
          ..tranDescription = 'Cash to A.O'
          ..tranDate = DateTimeDetails().currentDate()
          ..tranTime = DateTimeDetails().onlyTime()
          ..valuation = 'Minus';
        await addTransaction.save();
      } else {
        await TransactionTable()
            .select()
            .tranDate
            .equals(DateTimeDetails().currentDate())
            .delete();
        final addTransaction = await TransactionTable()
          ..tranid = "CASHTOAO" + DateTimeDetails().currentDateTime()
          ..tranType = 'Cash To AO'
          ..tranDescription = 'Cash to A.O'
          ..tranDate = DateTimeDetails().currentDate()
          ..tranTime = DateTimeDetails().onlyTime()
          ..valuation = 'Minus';
        await addTransaction.save();
      }
    }

    //Start Rohit code to get All details in BODA Generation only
    double mailAmount = 0; //added by Rohit to use in BodaBrief table.
    await BookingDBService().addCashIndent(
        DateTimeDetails().dateCharacter(),
        aoRequestCashController.text.isEmpty
            ? '0'
            : aoRequestCashController.text,
        weightController.text.isEmpty ? weightController.text : '');

    var dayReport =
        await DayModel().select().DayBeginDate.equals(currentDate).toMapList();
    openingBalance = double.parse(dayReport[0]['CashOpeningBalance']);
    // print("BODA Booking..!");
    closingBalance = double.parse(dayReport[0]['CashClosingBalance']);
    print("BODA Booking..!");
    //Booked Mails Receipt
    var registerLetter = await LetterBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .and
        .TenderID
        .equals('S')
        .endBlock
        .toMapList();
    // print('Regd. Letter length- ' + registerLetter.length.toString());
    if (registerLetter.isNotEmpty) {
      for (int i = 0; i < registerLetter.length; i++) {
        mailsCount += int.parse(registerLetter[i]['TotalAmount']);
        rlMailsCount += int.parse(registerLetter[i]['TotalAmount']);
        bookedRL.add(registerLetter[i]['ArticleNumber']);
        bookedRLAmount.add(registerLetter[i]['TotalAmount']);
      }
    }
    var parcel = await ParcelBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .and
        .TenderID
        .equals('S')
        .endBlock
        .toMapList();
    if (parcel.isNotEmpty) {
      for (int i = 0; i < parcel.length; i++) {
        mailsCount += int.parse(parcel[i]['TotalAmount']);
        parcelMailsCount += int.parse(parcel[i]['TotalAmount']);
        bookedParcel.add(parcel[i]['ArticleNumber']);
        bookedParcelAmount.add(parcel[i]['TotalAmount']);
      }
    }
    var speed = await SpeedBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .and
        .TenderID
        .equals('S')
        .endBlock
        .toMapList();
    if (speed.isNotEmpty) {
      for (int i = 0; i < speed.length; i++) {
        print(i);
        print(speed[i]['TotalAmount']);
        print("=======");

        print("----------");
        mailsCount += int.parse( speed[i]['TotalCashAmount'].toString().split('.').first);
        speedMailsCount += int.parse(speed[i]['TotalCashAmount'].toString().split('.').first);
        bookedSpeed.add(speed[i]['ArticleNumber']);
        bookedSpeedAmount.add(speed[i]['TotalCashAmount'].toString().split('.').first);
      }
    }
    var emo = await EmoBooking()
        .select()
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (emo.isNotEmpty) {
      for (int i = 0; i < emo.length; i++) {
        mailsCount += int.parse(emo[i]['TotalAmount']);
        emoMailsCount += int.parse(emo[i]['TotalAmount']);
        bookedEMO.add(emo[i]['ArticleNumber']);
        bookedEMOAmount.add(emo[i]['TotalAmount']);
        emoValue += int.parse(emo[i]['Value']);
        emoCommission += int.parse(emo[i]['CommissionAmount']);
      }
    }
// // Getting the Product Sale Details.
//     double ps= 0;
//     var prodsale =await ProductSaleTable().select()
//         .BookingDate
//         .equals(DateTimeDetails().dateCharacter())
//         .toMapList();
//     if (prodsale.isNotEmpty) {
//       for (int i = 0; i < prodsale.length; i++) {
//         psvalue += int.parse(prodsale[i]['TotalCashAmount']);
//       }
//     }
    //COD Receipt
    print('BODA SLip - COD Receipt');
    final codReceipt = await Delivery()
        .select()
        .COD
        .equals('X')
        .and
        .startBlock
        .ART_STATUS
        .equals('D')
        .and
        .invoiceDate
        .equals(DateTimeDetails().currentDate())
        // .and.DEL_DATE.equals(DateTime.parse(DateTimeDetails().headerTime()))
        .and
        .endBlock
        .toMapList();
    print(codReceipt);
    print(codReceipt.length);

    if (codReceipt.isNotEmpty) {
      for (int i = 0; i < codReceipt.length; i++) {
        print(codReceiptCount);
        mailsCount += int.parse(
            codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
        codReceiptCount += int.parse(
            codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
      }
    }

    print('RamNaTh->GenerateBODAReportScreen.dart : BODA Bill Calculation');
    //Bills
    // bills = await BillData().select().BillDate.equals(DateTimeDetails().currentDate()).toMapList();
    bills = await BillFile()
        .select()
        .BookingDate
        .equals(DateTimeDetails().dateCharacter())
        .toMapList();
    if (bills.isNotEmpty) {
      for (int i = 0; i < bills.length; i++) {
        // mailsCount += int.parse(bills[i]['TotalCashAmount']);
        // print(mailsCount);
        billTotal += int.parse(bills[i]['TotalCashAmount']);
        billNames.add(bills[i]['BillerId']);
        billAmount.add(bills[i]['TotalCashAmount']);
      }
    }
    print('RamNaTh->GenerateBODAReportScreen.dart : Bag BODA');
    //Bag
    bags = await BagCashTable()
        .select()
        .BagDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (bags.isNotEmpty) {
      print('inside if condition' + bags.length.toString());
      for (int i = 0; i < bags.length; i++) {
        print('inside for loop $i');
        print(bags[i]['CashAmount']);
        print(double.parse(bags[i]['CashAmount'].toString()));
        print(bags[i]['BagNumber']);

        bagCashTotal += double.parse(bags[i]['CashAmount']);
        bagCash.add(bags[i]['CashAmount']);
        bagNumber.add(bags[i]['BagNumber']);
      }
      print(bagCashTotal);
    }

    print('Cash received through Special Remittance');
    final cashFromAO = await CashTable()
        .select()
        .Cash_ID
        .equals("CashFromAO_${DateTimeDetails().dateCharacter()}")
        .toList();
    if (cashFromAO.isNotEmpty) {
      bagCashTotal += cashFromAO[0].Cash_Amount!;
      bagCash.add(cashFromAO[0].Cash_Amount!);
      bagNumber.add(cashFromAO[0].Cash_ID!);
    }

    print('RamNaTh->GenerateBODAReportScreen.dart : BODA Banking');
    //Banking
    banking = await TBCBS_TRAN_DETAILS()
        .select()
        .TRAN_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .startBlock
        .STATUS
        .equals("SUCCESS")
        .and
        .endBlock
        .toMapList();

    print(banking.length);

    if (banking.isNotEmpty) {
      int counter = 0;
      for (int i = 0; i < banking.length; i++) {
        print('BODA CBS Calculation..!');
        // if (banking[i]['TRAN_TYPE']!.toString() == 'D' || banking[i]['TRAN_TYPE']!.toString() == 'O') {
        if (banking[i]['TRAN_TYPE'] == 'D') {
          print(bankDepositAmount);
          bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN' ||
              banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
            sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbDeposit.add(banking[i]['CUST_ACC_NUM']);
            sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdDeposit.add(banking[i]['CUST_ACC_NUM']);
            rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
        } else if (banking[i]['TRAN_TYPE'] == 'O') {
          print(bankDepositAmount);
          bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN' ||
              banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
            sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbDeposit.add('New Account');
            sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdDeposit.add('New Account');
            rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
        } else if (banking[i]['TRAN_TYPE'] == 'W') {
          print(counter++);
          bankWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN' ||
              banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
            sbWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbWithdraw.add(banking[i]['CUST_ACC_NUM']);
            sbAmountWithdraw.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdWithdraw.add(banking[i]['CUST_ACC_NUM']);
            rdAmountWithdraw.add(banking[i]['TRANSACTION_AMT']);
          }
        }
      }
    }

    print('RamNaTh->GenerateBODAReportScreen.dart : BODA IPPB');
    //IPPB
    ippb = await IPPBCBS_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    print("RamNaTh->GenerateBODAReportScreen.dart : ippb variable => $ippb");

    print("Ramnath->GenerateBODAReportScreen.dart : ippb.length:'${ippb.length}'");

    if (ippb.isNotEmpty) {
      for (int i = 0; i < ippb.length; i++) {
        try {
          //print("'{ippb[$i]['TOTAL_DEPOSITS'].toString().isNotEmpty}'${ippb[i]['TOTAL_DEPOSITS']}");
          //if (ippb[i]['TOTAL_DEPOSITS'].toString().isNotEmpty) {

          print("ippb[$i]['TOTAL_DEPOSITS'] : ${ippb[i]['TOTAL_DEPOSITS']}");
          print("ippb[$i]['TOTAL_DEPOSIT_AMOUNT'] : ${ippb[i]['TOTAL_DEPOSIT_AMOUNT']}");
          print("ippb[$i]['TOTAL_WITHDRAWALS'] : ${ippb[i]['TOTAL_WITHDRAWALS']}");
          print("ippb[$i]['TOTAL_WITHDRAWAL_AMOUNT'] : ${ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']}");

          //ippbDeposits = int.parse(ippb[i]['TOTAL_DEPOSITS']);
          //print("RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_DEPOSITS]: $ippbDeposits");
          if (ippb[i]['TOTAL_DEPOSIT_AMOUNT'].toString().isNotEmpty) {
            ippbDepositAmount = int.parse(ippb[i]['TOTAL_DEPOSIT_AMOUNT']);
            print(
                "RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_DEPOSIT_AMOUNT]: ${ippb[i]['TOTAL_DEPOSIT_AMOUNT']}");
          }else{
            ippbDepositAmount = 0;
          }
          //ippbWithdraws = int.parse(ippb[i]['TOTAL_WITHDRAWALS']);
          //print("RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_WITHDRAWALS] ${ippb[i]['TOTAL_WITHDRAWALS']}");
          if (ippb[i]['TOTAL_WITHDRAWAL_AMOUNT'].toString().isNotEmpty) {
            ippbWithdrawAmount = int.parse(ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']);
            print(
                "RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_WITHDRAWAL_AMOUNT] ${ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']}");
          }else{
            ippbWithdrawAmount = 0;
          }
          //}
        }catch(e){
          print("Ramnath->GenerateBODAReportScreen.dart : Inside Catch{} ");
          //ippbDepositAmount = 0;
          //ippbWithdrawAmount = 0;
        }
      }
    }

    print('RamNaTh->GenerateBODAReportScreen.dart :BODA Dcube');
    dcube = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("DCube")
        .toMapList();
    if (dcube.isNotEmpty)
      dcudeWithdrawlAmount = int.parse(dcube[0]['TOTAL_WITHDRAWAL_AMOUNT']);

    print('BODA CSC');
    csc = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("CSC")
        .toMapList();
    if (csc.isNotEmpty)
      cscDepositsAmount = int.parse(csc[0]['TOTAL_DEPOSIT_AMOUNT']);

    print('BODA OTHERS');
    others = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("Others")
        .toMapList();
    if (others.isNotEmpty){
      otherDepositsAmount = int.parse(others[0]['TOTAL_DEPOSIT_AMOUNT']);
      otherWithdrawlAmount = int.parse(others[0]['TOTAL_WITHDRAWAL_AMOUNT']);
      othersText= others[0]["Remarks"];
    }


    print('BODA Insurance');
    // Insurance
    // insurance = await Ins_transaction().select().toMapList();
    insurance = await DAY_TRANSACTION_REPORT()
        .select()
        .startBlock
        .STATUS
        .equals("SUCCESS")
        .or
        .STATUS
        .equals("Success")
        .endBlock
        .and
        .startBlock
        .TRAN_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .endBlock
        .toMapList();

    for (int i = 0; i < insurance.length; i++) {
      // if (insurance[i]['tranType'] == 'InitialPremium' ||
      //     insurance[i]['tranType'] == 'RevivalPremium') {
      insuranceDepositAmount += double.parse(insurance[i]['AMOUNT']);
      if (insurance[i]['POLICY_TYPE'] == 'PLI') {
        pliDepositAmount += double.parse(insurance[i]['AMOUNT']);
        pliDeposit.add(insurance[i]['POLICY_NO']);
        pliAmountDeposit.add(insurance[i]['AMOUNT']);
      } else if (insurance[i]['POLICY_TYPE'] == 'RPL') {
        rpliDepositAmount += double.parse(insurance[i]['AMOUNT']);
        rpliDeposit.add(insurance[i]['POLICY_NO']);
        rpliAmountDeposit.add(insurance[i]['AMOUNT']);
      }
    }

    //eMO Paid
    print('BODA eMO Paid');
    final emoDelivery = await Delivery()
        .select()
        .startBlock
        .invoiceDate
        .equals(DateTimeDetails().currentDate())
        .and
        .ART_STATUS
        .equals("F")
        .endBlock
        .toList();
    if (emoDelivery.isNotEmpty) {
      for (int i = 0; i < emoDelivery.length; i++) {
        emoPaid += emoDelivery[i].MONEY_DELIVERED!;
        print(emoPaid);
      }
    }
    print('BODA Inventory');
    print('Inventory---');
    //Inventory
    products = await ProductsTable().select().toMapList();
    if (products.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        productsCount += double.parse(products[i]['Value'].toString());
        productType.add(products[i]['Name']);
        productAmount.add(products[i]['Value'].toString());
      }
    }
    print('BODA Liability');
    //Liability
    liabilities =
        await Liability().select().Date.equals(currentDate).toMapList();
    if (liabilities.isNotEmpty) {
      liabilityAmount = double.parse(liabilities[0]['Amount']);
      liabilityDescription = liabilities[0]['Description'];
    }

    print('BODA Total Calculation..!');
    // totalReceipts = double.parse(openingBalance) + mailsCount + bankDepositAmount + insuranceDepositAmount + ippbDepositAmount;
    print('BODA Total Calculation');
    totalReceipts = (bagCashTotal +
            mailsCount +
            billTotal +
            bankDepositAmount +
            insuranceDepositAmount +
            ippbDepositAmount+
            cscDepositsAmount+
           otherDepositsAmount
    )
        .toDouble();
    totalPayments = (cashTOAO +
            emoPaid +
            bankWithdrawAmount +
            insuranceWithdrawAmount +
            ippbWithdrawAmount+
           dcudeWithdrawlAmount+
           otherWithdrawlAmount

    )
        .toDouble();

    //End Rohit code

    final inventory = await BagStampsTable()
        .select()
        .StampDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();

    if (inventory.isNotEmpty) {
      for (int i = 0; i < inventory.length; i++) {
        final bodaInventory = await  BodaInventory()
          ..inventoryid =
              inventory[i]['StampName'] + DateTimeDetails().currentDate()
          ..InventoryName = inventory[i]['StampName']
          ..InventoryDate = DateTimeDetails().currentDate()
          ..InventoryPrice = inventory[i]['StampPrice']
          ..InventoryQuantity = inventory[i]['StampQuantity'];

       await bodaInventory.upsert();
      }
    }

    final saveLiability =await Liability()
      ..Description = liabilityReasonController.text.trim()
      ..Date = DateTimeDetails().currentDate()
      ..Amount = getBalance().toString();
   await saveLiability.upsert();

    final saveBODA =await BodaSlip()
      ..bodaDate = currentDate
      ..bodaNumber = bodanumber
      ..cashFrom = aoRequestCashController.text.isEmpty
          ? '0'
          : aoRequestCashController.text
      ..cashTo = aoConfirmCashController.text.isEmpty
          ? '0'
          : aoConfirmCashController.text;
    await saveBODA.upsert();

    final dailyInventory = await InventoryDailyTable()
        .select()
        .RecordedDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    var fromProductsMain = await ProductsTable().select().toMapList();
    double totalInventoryAmount =
        0; //added this variable by Rohit to use in BodaBrief table in later codes.

    if (dailyInventory.isEmpty) {
      for (int i = 0; i < fromProductsMain.length; i++) {
        final addDailyInventory = await InventoryDailyTable()
          ..InventoryId = fromProductsMain[i]['ProductID']
          ..StampName = fromProductsMain[i]['Name']
          ..Price = fromProductsMain[i]['Price']
          ..RecordedDate = DateTimeDetails().currentDate()
          ..OpeningQuantity = '0'
          ..OpeningValue = '0'
          ..ClosingQuantity = fromProductsMain[i]['Quantity']
          ..ClosingValue = fromProductsMain[i]['Value'];
       await  addDailyInventory.upsert();
        totalInventoryAmount =
            totalInventoryAmount + double.parse(fromProductsMain[i]['Price']);
      }
    }

    //added below code by Rohit to save BODA detailed information in local DB.

    final dayModel = await DayModel()
        .select()
        .DayBeginDate
        .equals(DateTimeDetails().currentDate())
        .toList();

    final saveBODABrief = await BodaBrief()
      ..BodaGeneratedDate = DateTimeDetails().currentDate()
      ..BodaGeneratedTime = DateTimeDetails().oT()
      ..OpeningBalance = dayModel[0].CashOpeningBalance
      ..ClosingBalance = dayModel[0].CashClosingBalance
      ..BodaNumber = bodanumber
      ..MailsAmount = mailAmount.toString()
      ..TotalReceiptsAmount = totalReceipts.toStringAsFixed(2)
      ..CashToAOAmount = aoConfirmCashController.text.toString()
      ..InsuranceAmount = insuranceDepositAmount.toStringAsFixed(2)
      ..BankingAmount = bankDepositAmount.toStringAsFixed(2)
      ..InventoryAmount = totalInventoryAmount.toString()
      ..LiabilitiesAmount = getBalance().toString()
      ..CashIndentAmount = "";
    await saveBODABrief.upsert();

    // to store excess cash details after BODA generation.
    // double excess = double.parse(getBalance());
    // aoConfirmCashController.text.isNotEmpty

    if (aoConfirmCashController.text.isNotEmpty) {
      await BookingDBService().addExcessBagCash(
          bodanumber,
          aoConfirmCashController.text.toString(),
          weightController.text.isEmpty ? weightController.text : '');
    }

    //to store document details
    if (documentsReasonController.text.isNotEmpty) {
      await BaggingDBService().saveDocumentsToDB(
          bodanumber,
          documentsReasonController.text.isEmpty
              ? ''
              : documentsReasonController.text,
          ''); //bag number is empty
    }


    //update Closing balace in DayModel
    final updateClosingBalance = await DayModel()
        .select()
        .DayBeginDate
        .equals(DateTimeDetails().currentDate())
        .update({"CashClosingBalance":walletAmount.toStringAsFixed(2)});

    print(updateClosingBalance.successMessage);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BODASlipScreen()),
        (route) => false);
  }

  walletBalance() {
    if (aoConfirmCashController.text.isNotEmpty) {
      return (walletAmount - int.parse(aoConfirmCashController.text))
          .toString();
    } else {
      return walletAmount.toString();
    }
  }
}
