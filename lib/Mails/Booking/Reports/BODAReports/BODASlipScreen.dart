import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Reports/BODAReports/BODAPdfScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/ReportsMainScreen.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BODASlipScreen extends StatefulWidget {
  const BODASlipScreen({Key? key}) : super(key: key);

  @override
  _BODASlipScreenState createState() => _BODASlipScreenState();
}

class _BODASlipScreenState extends State<BODASlipScreen> {
  final pdf = pw.Document();

  var font;

  String barCode = '';
  String currentDate = '';
  String previousBalance = '';
  String openingBalance = '';
  String closingBalance = '';
  String mailsBooked = '';
  String registerBooked = '';
  String liabilityDescription = '';
  String liabilityAmount = '';

  double totalReceipts = 0;
  double totalPayments = 0;
  double walletAmount = 0.0;

  int mailsCount = 0;
  int rlMailsCount = 0;
  int speedMailsCount = 0;
  int emoMailsCount = 0;
  int parcelMailsCount = 0;
  int cashTOAO = 0;
  int cashIndent = 0;
  int productsCount = 0;
  int liabilityCount = 0;
  int bankingLiabilityCount = 0;
  int insuranceLiabilityCount = 0;
  int emoLiabilityCount = 0;
  int sbDepositAmount = 0;
  int rdDepositAmount = 0;
  int billTotal = 0;
  int bagCashTotal = 0;
  int ippbDepositAmount = 0;
  int ippbDeposits = 0;
  int sbWithdrawAmount = 0;
  int rdWithdrawAmount = 0;
  int ippbWithdraws = 0;
  int ippbWithdrawAmount = 0;
  int pliDepositAmount = 0;
  int rpliDepositAmount = 0;
  int pliWithdrawAmount = 0;
  int rpliWithdrawAmount = 0;
  int bankDepositAmount = 0;
  int bankWithdrawAmount = 0;
  int insuranceDepositAmount = 0;
  int insuranceWithdrawAmount = 0;

  List mails = [];
  List banking = [];
  List bills = [];
  List bags = [];
  List ippb = [];
  List allBookedMails = [];
  List products = [];
  List liability = [];
  List insurance = [];
  List insurancePolicyNumber = [];
  List insurancePolicyType = [];
  List insurancePolicyAmount = [];
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
  List bankingLiabilityNumber = [];
  List bankingLiabilityAmount = [];
  List insuranceLiabilityNumber = [];
  List insuranceLiabilityAmount = [];
  List mailsLiabilityNumber = [];
  List mailsLiabilityAmount = [];
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
  List<pw.Widget> pdfRLMailReceipts = [];
  List<pw.Widget> pdfParcelMailReceipts = [];
  List<pw.Widget> pdfEMOMailReceipts = [];
  List<pw.Widget> pdfSpeedMailReceipts = [];
  List<pw.Widget> pdfInventory = [];

  Future<String> getWalletAmount() async {
    walletAmount = await CashService().cashBalance();

    currentDate = DateTimeDetails().currentDate();

    font = await PdfGoogleFonts.nunitoExtraLight();

    barCode = 'BO213081100010${currentDate.replaceAll(RegExp('-'), '')}';

    var dayReport =
        await DayModel().select().DayBeginDate.equals(currentDate).toMapList();
    openingBalance = dayReport[0]['CashOpeningBalance'];
    closingBalance = dayReport[0]['CashClosingBalance'];

    //Booked Mails Receipt
    var registerLetter = await LetterBooking()
        .select()
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
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
        .BookingDate
        .equals(DateTimeDetails().currentDate())
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
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (speed.isNotEmpty) {
      for (int i = 0; i < speed.length; i++) {
        mailsCount += int.parse(speed[i]['TotalAmount']);
        speedMailsCount += int.parse(speed[i]['TotalAmount']);
        bookedSpeed.add(speed[i]['ArticleNumber']);
        bookedSpeedAmount.add(speed[i]['TotalAmount']);
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
      }
    }

    //Bills
    bills = await BillData()
        .select()
        .BillDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (bills.isNotEmpty) {
      for (int i = 0; i < bills.length; i++) {
        billTotal += int.parse(bills[i]['BillCollectedAmount']);
        billNames.add(bills[i]['BillName']);
        billAmount.add(bills[i]['BillCollectedAmount']);
      }
    }

    //Bag
    bags = await BagCashTable()
        .select()
        .BagDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (bags.isNotEmpty) {
      for (int i = 0; i < bags.length; i++) {
        bagCashTotal += int.parse(bags[i]['CashAmount']);
        bagCash.add(bags[i]['CashAmount']);
        bagNumber.add(bags[i]['BagNumber']);
      }
    }

    //Banking
    banking = await TBCBS_TRAN_DETAILS()
        .select()
        .TRAN_DATE
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (banking.isNotEmpty) {
      for (int i = 0; i < banking.length; i++) {
        bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
        if (banking[i]['REMARKS'] == 'Deposit') {
          if (banking[i]['ACCOUNT_TYPE'] == 'SB') {
            sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbDeposit.add(banking[i]['CUST_ACC_NUM']);
            sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdDeposit.add(banking[i]['CUST_ACC_NUM']);
            rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
        } else if (banking[i]['REMARKS'] == 'Withdrawal') {
          if (banking[i]['ACCOUNT_TYPE'] == 'SB') {
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

    ippb = await IPPBCBS_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (ippb.isNotEmpty) {
      for (int i = 0; i < ippb.length; i++) {
        //if (ippb[i]['TOTAL_DEPOSITS'].toString().isNotEmpty) {
          //ippbDeposits = int.parse(ippb[i]['TOTAL_DEPOSITS']);

          ippbDepositAmount = int.parse(ippb[i]['TOTAL_DEPOSIT_AMOUNT']);

          //ippbWithdraws = int.parse(ippb[i]['TOTAL_WITHDRAWALS']);

          ippbWithdrawAmount = int.parse(ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']);
        //}
      }
    }

    // Insurance
    insurance = await Ins_transaction().select().toMapList();
    for (int i = 0; i < insurance.length; i++) {
      if (insurance[i]['tranType'] == 'InitialPremium' ||
          insurance[i]['tranType'] == 'RevivalPremium') {
        insuranceDepositAmount += int.parse(insurance[i]['amount']);
        if (insurance[i]['policyType'] == 'PLI') {
          pliDepositAmount += int.parse(insurance[i]['amount']);
          pliDeposit.add(insurance[i]['policyNumber']);
          pliAmountDeposit.add(insurance[i]['amount']);
        } else if (insurance[i]['policyType'] == 'RPL') {
          rpliDepositAmount += int.parse(insurance[i]['amount']);
          rpliDeposit.add(insurance[i]['policyNumber']);
          rpliAmountDeposit.add(insurance[i]['amount']);
        }
      } else if (insurance[i]['tranType'] == 'WITHDRAW') {
        insuranceWithdrawAmount += int.parse(insurance[i]['amount']);
        if (insurance[i]['policyType'] == 'PLI') {
          pliWithdrawAmount += int.parse(insurance[i]['amount']);
          pliWithdraw.add(insurance[i]['policyNumber']);
          pliAmountWithdraw.add(insurance[i]['amount']);
        } else if (insurance[i]['policyType'] == 'RPL') {
          rpliWithdrawAmount += int.parse(insurance[i]['amount']);
          rpliWithdraw.add(insurance[i]['policyNumber']);
          rpliAmountWithdraw.add(insurance[i]['amount']);
        }
      }
    }

    totalReceipts = double.parse(openingBalance) +
        mailsCount +
        bankDepositAmount +
        insuranceDepositAmount +
        ippbDepositAmount;
    totalPayments = cashTOAO.toDouble() +
        bankWithdrawAmount +
        insuranceWithdrawAmount +
        ippbWithdrawAmount;

    //Inventory
    products = await ProductsTable().select().toMapList();
    if (products.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        productsCount += int.parse(products[i]['Value']);
        productType.add(products[i]['Name']);
        productAmount.add(products[i]['Value']);
        pdfInventory
            .add(pdfSlipTitleValue(products[i]['Name'], products[i]['Value']));
      }
    }

    //Liability
    liability = await Liability().select().Date.equals(currentDate).toMapList();
    if (liability.isNotEmpty) {
      liabilityAmount = liability[0]['Amount'];
      liabilityDescription = liability[0]['Description'];
    }

    var bodaDetails =
        await BodaSlip().select().bodaDate.equals(currentDate).toMapList();
    cashTOAO = bodaDetails[0]['cashTo'].toString().isEmpty
        ? 0
        : int.parse(bodaDetails[0]['cashTo']);
    cashIndent = bodaDetails[0]['cashFrom'].toString().isEmpty
        ? 0
        : int.parse(bodaDetails[0]['cashFrom']);

    return 'Fetched';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToPrevious(context);
        return true;
      },
      child: FutureBuilder(
        future: getWalletAmount(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: ColorConstants.kBackgroundColor,
                appBar: AppBar(
                  title: const Text('BODA Slip'),
                  elevation: 0,
                  backgroundColor: ColorConstants.kPrimaryColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReportsMainScreen()),
                        (route) => false),
                  ),
                  actions: [
                    IconButton(
                        onPressed: _generatePDF, icon: const Icon(Icons.print))
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child:
                                    Image.asset('assets/images/ic_logo.png')),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INDIA POST',
                                    style: TextStyle(
                                        fontSize: 25.toDouble(),
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Text('Ministry Of Communication')
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: SizedBox(
                              height: 60,
                              width: 200,
                              child: BarcodeWidget(
                                  data: barCode, barcode: Barcode.code128())),
                        ),
                        const DottedLine(),
                        const Space(),
                        Text(
                          'Chamundibetta B.O',
                          style: subTitleStyle(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: DialogText(
                              title: 'Date of Transaction : ',
                              subtitle: currentDate),
                        ),
                        DialogText(
                            title: 'Balance of last daily Account : ',
                            subtitle: '\u{20B9} $openingBalance'),
                        nextSpace('RECEIPTS'),
                        slipTitleValue(
                            'Opening Balance Amount', openingBalance),
                        mailsCount == 0
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue(
                                    'Mails Booked', mailsCount),
                                children: [
                                  bookedRL.isNotEmpty
                                      ? bookedExpansionTile(
                                          'Register Letter',
                                          rlMailsCount,
                                          bookedRL,
                                          bookedRLAmount)
                                      : Container(),
                                  bookedSpeed.isNotEmpty
                                      ? bookedExpansionTile(
                                          'Speed Post',
                                          speedMailsCount,
                                          bookedSpeed,
                                          bookedSpeedAmount)
                                      : Container(),
                                  bookedEMO.isNotEmpty
                                      ? bookedExpansionTile(
                                          'EMO',
                                          emoMailsCount,
                                          bookedEMO,
                                          bookedEMOAmount)
                                      : Container(),
                                  bookedParcel.isNotEmpty
                                      ? bookedExpansionTile(
                                          'Parcel',
                                          parcelMailsCount,
                                          bookedParcel,
                                          bookedParcelAmount)
                                      : Container(),
                                ],
                              ),
                        billTotal == 0
                            ? Container()
                            : billNames.isNotEmpty
                                ? bookedExpansionTile(
                                    'Bills', billTotal, billNames, billAmount)
                                : Container(),
                        sbDeposit.isEmpty && rdDeposit.isEmpty
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue(
                                    'CBS Deposit', bankDepositAmount),
                                children: [
                                  sbDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'SB Deposit',
                                          sbDepositAmount,
                                          sbDeposit,
                                          sbAmountDeposit)
                                      : Container(),
                                  rdDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RD Deposit',
                                          rdDepositAmount,
                                          rdDeposit,
                                          rdAmountDeposit)
                                      : Container(),
                                ],
                              ),
                        pliDeposit.isEmpty && rpliDeposit.isEmpty
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue('Insurance Deposit',
                                    insuranceDepositAmount),
                                children: [
                                  pliDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'PLI Deposit',
                                          pliDepositAmount,
                                          pliDeposit,
                                          pliAmountDeposit)
                                      : Container(),
                                  rpliDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RPLI Deposit',
                                          rpliDepositAmount,
                                          rpliDeposit,
                                          rpliAmountDeposit)
                                      : Container(),
                                ],
                              ),
                        ippbDepositAmount == 0
                            ? Container()
                            : Column(
                                children: [
                                  slipTitleDescription(
                                      'IPPB Deposits', ippbDeposits.toString()),
                                  slipTitleValue(
                                      'Value', ippbDepositAmount.toString()),
                                ],
                              ),
                        bagCashTotal == 0
                            ? Container()
                            : bagNumber.isNotEmpty
                                ? bookedExpansionTile('Bag Cash', bagCashTotal,
                                    bagNumber, bagCash)
                                : Container(),
                        SizedBox(width: 200, child: const Divider()),
                        slipTitleValue(
                            'TOTAL RECEIPTS', totalReceipts.toString()),
                        nextSpace('PAYMENTS'),
                        slipTitleValue('Cash to AO', cashTOAO.toString()),
                        const Space(),
                        sbWithdraw.isEmpty && rdWithdraw.isEmpty
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue('CBS Withdraw',
                                    sbWithdrawAmount + rdWithdrawAmount),
                                children: [
                                  sbWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'SB Withdraw',
                                          sbWithdrawAmount,
                                          sbWithdraw,
                                          sbAmountWithdraw)
                                      : Container(),
                                  rdWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RD Withdraw',
                                          rdWithdrawAmount,
                                          rdWithdraw,
                                          rdAmountWithdraw)
                                      : Container(),
                                ],
                              ),
                        pliWithdraw.isEmpty && rpliWithdraw.isEmpty
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue('Insurance Withdraw',
                                    pliWithdrawAmount + rpliWithdrawAmount),
                                children: [
                                  pliWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'PLI Withdraw',
                                          pliWithdrawAmount,
                                          pliWithdraw,
                                          pliAmountWithdraw)
                                      : Container(),
                                  rpliWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RPLI Withdraw',
                                          rpliWithdrawAmount,
                                          rpliWithdraw,
                                          rpliAmountWithdraw)
                                      : Container(),
                                ],
                              ),
                        ippbWithdrawAmount == 0
                            ? Container()
                            : Column(
                                children: [
                                  slipTitleDescription('IPPB Withdraw',
                                      ippbWithdraws.toString()),
                                  slipTitleValue(
                                      'Value', ippbWithdrawAmount.toString()),
                                ],
                              ),
                        const Space(),
                        SizedBox(width: 200, child: const Divider()),
                        slipTitleValue(
                            'TOTAL PAYMENTS', totalPayments.toString()),
                        nextSpace('CASH BALANCE'),
                        slipTitleValue(
                            'Cash & Currency Notes Amount', closingBalance),
                        nextSpace('INVENTORY'),
                        ExpansionTile(
                          title: expansionTitleValue(
                              'Postage & Revenue Stamps Amount (Equivalent)',
                              productsCount),
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: productType
                                          .map((e) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3.0),
                                                child: Text(
                                                  '• $e',
                                                  style: textStyle(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: productType
                                        .map((e) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3.0),
                                              child: Text(
                                                ':',
                                                style: textStyle(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: productAmount
                                          .map((e) => Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3.0),
                                                child: Text(
                                                  '\u{20B9}$e',
                                                  style: textStyle(),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        nextSpace('LIABILITIES'),
                        slipTitleValue(liabilityDescription, liabilityAmount),
                        // bankingLiabilityNumber.isNotEmpty ? bookedExpansionTile('Banking Liability', bankingLiabilityCount, bankingLiabilityNumber, bankingLiabilityAmount) : Container(),
                        // insuranceLiabilityNumber.isNotEmpty ? bookedExpansionTile('Insurance Liability', insuranceLiabilityCount, insuranceLiabilityNumber, insuranceLiabilityAmount) : Container(),
                        // mailsLiabilityNumber.isNotEmpty ? bookedExpansionTile('Mails Liability', emoLiabilityCount, mailsLiabilityNumber, mailsLiabilityAmount) : Container(),
                        nextSpace('CASH INDENT'),
                        slipTitleValue(
                            'Cash Indent Amount', cashIndent.toString()),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
          return Scaffold(
              backgroundColor: ColorConstants.kBackgroundColor,
              appBar: AppBar(
                title: const Text('BODA Slip'),
                elevation: 0,
                backgroundColor: ColorConstants.kPrimaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReportsMainScreen()),
                      (route) => false),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  Widget nextSpace(String title) {
    return Column(
      children: [
        const Space(),
        const DottedLine(),
        const DoubleSpace(),
        const DottedLine(),
        const Space(),
        Text(
          title,
          style: headingStyle(),
        ),
        SizedBox(width: 150, child: const Divider()),
      ],
    );
  }

  Widget slipTitleValue(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(
                title,
                style: titleStyle(),
              )),
          const Text(' : '),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Text(
                '\u{20B9} $value',
                style: subTitleStyle(),
              )),
        ],
      ),
    );
  }

  Widget expansionTitleValue(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Text(
              title,
              style: titleStyle(),
            )),
        const Text(' : '),
        SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 2,
            child: Text(
              '\u{20B9} $value',
              style: subTitleStyle(),
            ))
      ],
    );
  }

  Widget bookedExpansionTile(
      String title, int totalCount, List bookedLetter, List bookedAmount) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: ExpansionTile(
        title: expansionTitleValue(title, totalCount),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bookedLetter
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Text(
                                e,
                                style: textStyle(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: bookedLetter
                      .map((e) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0),
                            child: Text(
                              ':',
                              style: textStyle(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bookedAmount
                        .map((e) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.0),
                              child: Text(
                                '\u{20B9}$e',
                                style: textStyle(),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  textStyle() {
    return TextStyle(
        letterSpacing: 1, fontSize: 13, color: ColorConstants.kTextColor);
  }

  titleStyle() {
    return TextStyle(
        letterSpacing: 1, fontSize: 13, color: ColorConstants.kTextDark);
  }

  Widget slipTitleDescription(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(
                title,
                style: titleStyle(),
              )),
          const Text(' : '),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Text(
                value,
                style: subTitleStyle(),
              )),
        ],
      ),
    );
  }

  subTitleStyle() {
    return TextStyle(
        fontSize: 13,
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kTextDark);
  }

  headingStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kSecondaryColor);
  }

  void moveToPrevious(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
        (route) => false);
  }

  _generatePDF() async {
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/ic_logo.png'))
            .buffer
            .asUint8List());
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          return pw.Center(
              child: pw.Column(children: [
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(flex: 2, child: pw.Image(logoImage)),
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INDIA POST',
                          style: pw.TextStyle(
                              fontSize: 28.toDouble(),
                              letterSpacing: 2,
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text('Ministry Of Communication',
                            style: pw.TextStyle(fontSize: 15.toDouble()))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]));
        },
        build: (pw.Context context) =>
            [contentDetails(context), pw.SizedBox(height: 20)],
        footer: (pw.Context context) => buildFooter(context)));

    Directory directory = Directory('/storage/emulated/0/Darpan_Mine');
    final path = directory.path;
    if (await directory.exists()) {
    } else {
      await directory.create();
    }

    File file = File("$path/BODA$currentDate.pdf");
    Toast.showFloatingToast(
        'File Saved in Internal storage -> Darpan -> BODA$currentDate.pdf',
        context);
    file.writeAsBytesSync(await pdf.save());
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BODAPdfScreen(path: file.path.toString())));
  }

  pw.Widget contentDetails(pw.Context context) => pw.Center(
          child: pw.Column(children: [
        pw.SizedBox(height: 10),
        pw.BarcodeWidget(
            data: barCode,
            width: 250,
            height: 70,
            barcode: pw.Barcode.code128()),
        pw.Divider(),
        pw.Text('Chamundibetta B.O',
            style: pw.TextStyle(
                letterSpacing: 1,
                fontSize: 14,
                fontWeight: pw.FontWeight.bold)),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 5.0),
          child: pw.RichText(
            textAlign: pw.TextAlign.center,
            text: pw.TextSpan(
                text: 'Date of Transaction : ',
                style: pw.TextStyle(letterSpacing: 1, fontSize: 14),
                children: [
                  pw.TextSpan(
                      text: currentDate,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.toDouble(),
                          fontSize: 14))
                ]),
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 5.0),
          child: pw.RichText(
            textAlign: pw.TextAlign.center,
            text: pw.TextSpan(
                text: 'Balance of last daily Account : ',
                style: pw.TextStyle(letterSpacing: 1, fontSize: 14),
                children: [
                  pw.TextSpan(
                      text: walletAmount.toString(),
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.toDouble(),
                          fontSize: 14))
                ]),
          ),
        ),
        pw.Divider(),
        pdfSlipTitleValue('Cash Opening Balance Amount', '₹$openingBalance'),
        pdfSlipTitleValue('TOTAL RECEIPTS', '₹$totalReceipts'),
        pdfSlipTitleValue('IPPB Deposits', '₹$ippbDepositAmount'),
        heading('PAYMENTS'),
        pdfSlipTitleValue('Cash to AO', '₹$cashTOAO'),
        totalDivider(),
        pdfSlipTitleValue('TOTAL PAYMENTS', '₹$cashTOAO'),
        pdfSlipTitleValue('IPPB Withdraw', '₹$ippbWithdrawAmount'),
        heading('CASH BALANCE'),
        pdfSlipTitleValue('Cash & Currency Notes Amount', '₹$closingBalance'),
        heading('INVENTORY'),
        products.isEmpty
            ? pw.Container()
            : pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey),
                    children: [
                      pw.Expanded(
                          flex: 2,
                          child: pw.Center(
                              child: pw.Column(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Text('Inventory Type'),
                            )
                          ]))),
                      pw.Expanded(
                          flex: 3,
                          child: pw.Center(
                              child: pw.Column(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Text('Name'),
                            )
                          ]))),
                      pw.Expanded(
                          flex: 1,
                          child: pw.Center(
                              child: pw.Column(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Text('Value'),
                            )
                          ]))),
                    ])
              ]),
        for (int i = 0; i < products.length; i++)
          pw.Table(border: pw.TableBorder.all(width: 1), children: [
            pw.TableRow(children: [
              pw.Expanded(
                  flex: 2,
                  child: pw.Center(
                      child: pw.Column(children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Text('Postal Stamp'),
                    )
                  ]))),
              pw.Expanded(
                  flex: 3,
                  child: pw.Center(
                      child: pw.Column(children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Text(products[i]['Name']),
                    )
                  ]))),
              pw.Expanded(
                  flex: 1,
                  child: pw.Center(
                      child: pw.Column(children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Text('₹${products[i]['Value']}',
                          style: pw.TextStyle(font: font)),
                    )
                  ]))),
            ])
          ]),
        heading('LIABILITIES'),
        liability.isEmpty
            ? pw.Container()
            : pdfSlipTitleValue(liabilityDescription, '₹$liabilityAmount'),
        heading('CASH INDENT'),
        pdfSlipTitleValue('Cash Indent Amount', '₹$cashIndent'),
        heading('RECEIPTS'),
        rlMailsCount == 0 &&
                speedMailsCount == 0 &&
                emoMailsCount == 0 &&
                parcelMailsCount == 0
            ? pw.Container()
            : pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey),
                    children: [
                      pw.Expanded(
                          flex: 2,
                          child: pw.Center(
                              child: pw.Column(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Text('Type'),
                            )
                          ]))),
                      pw.Expanded(
                          flex: 1,
                          child: pw.Center(
                              child: pw.Column(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.symmetric(vertical: 5),
                              child: pw.Text('TotalAmount'),
                            )
                          ]))),
                    ])
              ]),
        rlMailsCount != 0
            ? pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('Register Letter'),
                        )
                      ]))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('₹$rlMailsCount',
                              style: pw.TextStyle(font: font)),
                        )
                      ]))),
                ])
              ])
            : pw.Container(),
        speedMailsCount != 0
            ? pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('Speed Post'),
                        )
                      ]))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('₹$speedMailsCount',
                              style: pw.TextStyle(font: font)),
                        )
                      ]))),
                ])
              ])
            : pw.Container(),
        emoMailsCount != 0
            ? pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('EMO'),
                        )
                      ]))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('₹$emoMailsCount',
                              style: pw.TextStyle(font: font)),
                        )
                      ]))),
                ])
              ])
            : pw.Container(),
        parcelMailsCount != 0
            ? pw.Table(border: pw.TableBorder.all(width: 1), children: [
                pw.TableRow(children: [
                  pw.Expanded(
                      flex: 2,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('Parcel'),
                        )
                      ]))),
                  pw.Expanded(
                      flex: 1,
                      child: pw.Center(
                          child: pw.Column(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.symmetric(vertical: 5),
                          child: pw.Text('₹$parcelMailsCount',
                              style: pw.TextStyle(font: font)),
                        )
                      ]))),
                ])
              ])
            : pw.Container(),
        totalDivider(),
      ]));

  pw.Widget heading(String title) {
    return pw.Column(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(5.toDouble()),
        ),
        pw.Container(
          width: MediaQuery.of(context).size.width,
          color: PdfColor.fromHex('#cccccc'),
          child: pw.Text(
            title,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              letterSpacing: 1,
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget buildFooter(pw.Context context) =>
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text('Designed & Developed by C.E.P.T'),
        pw.Text('Page ${context.pageNumber}/${context.pagesCount}')
      ]);

  pw.Widget pdfSlipTitleValue(String title, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
              flex: 3,
              child: pw.Text(title,
                  style: pw.TextStyle(
                    letterSpacing: 1,
                    fontSize: 13,
                  ))),
          pw.Text(' : '),
          pw.SizedBox(
            width: 10,
          ),
          pw.Expanded(
              flex: 1,
              child: pw.Text(value,
                  style: pw.TextStyle(
                      font: font,
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: pw.FontWeight.bold))),
        ],
      ),
    );
  }

  pw.Widget pdfSlipSubTitleValue(String title, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
      child: pw.Row(
        children: [
          pw.Expanded(
              flex: 3,
              child: pw.Text(title,
                  style: pw.TextStyle(
                      letterSpacing: 1,
                      fontSize: 13,
                      color: PdfColor.fromHex('#4d4d4d')))),
          pw.Text(' : '),
          pw.SizedBox(
            width: 10,
          ),
          pw.Expanded(
              flex: 2,
              child: pw.Text(value,
                  style: pw.TextStyle(
                      fontSize: 13,
                      letterSpacing: 1,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#4d4d4d')))),
        ],
      ),
    );
  }

  pw.Widget totalDivider() {
    return pw.SizedBox(width: 200, child: pw.Divider());
  }
}
