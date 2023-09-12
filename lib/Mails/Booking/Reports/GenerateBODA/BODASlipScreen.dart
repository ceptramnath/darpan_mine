import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Reports/GenerateBODA/BODAPdfScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/ReportsMainScreen.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../HomeScreen.dart';
import '../../../../UtilitiesMainScreen.dart';

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
  double openingBalance = 0;
  double closingBalance = 0;
  String mailsBooked = '';
  String registerBooked = '';
  String liabilityDescription = '';
  double liabilityAmount=0;

  double totalReceipts = 0;
  double totalPayments = 0;
  double walletAmount = 0;

  int emoValue =0;
  int emoCommission =0;

  int mailsCount = 0;
  double psvalue= 0;
  int rlMailsCount = 0;
  int speedMailsCount = 0;
  int emoMailsCount = 0;
  int parcelMailsCount = 0;
  int codReceiptCount =0;
  int cashTOAO = 0;
  int cashIndent = 0;
  double productsCount = 0;
  int liabilityCount = 0;
  int bankingLiabilityCount = 0;
  int insuranceLiabilityCount = 0;
  int emoLiabilityCount = 0;
  int sbDepositAmount = 0;
  int rdDepositAmount = 0;
  int tdDepositAmount = 0;
  int ssaDepositAmount = 0;
  int billTotal = 0;
  double bagCashTotal = 0;
  int ippbDepositAmount = 0;
  int ippbDeposits = 0;
  int otherDeposits=0;
  int otherDepositsAmount=0;
  int cscDeposits=0;
  int cscDepositsAmount=0;
  int sbWithdrawAmount = 0;
  int rdWithdrawAmount = 0;
  int ippbWithdraws = 0;
  int ippbWithdrawAmount = 0;
  int otherWithdrawl=0;
  int otherWithdrawlAmount=0;
  String othersText="";
  int dcudeWithdrawl=0;
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
  List tdDeposit = [];
  List tdAmountDeposit = [];
  List ssaDeposit = [];
  List ssaAmountDeposit = [];
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
  String? boname, boid, empid, empname;

  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  Future<String> getWalletAmount() async {
    print('BODA getWalletAmount');
    walletAmount = await CashService().cashBalance();

    print(walletAmount);
    
    currentDate = DateTimeDetails().currentDate();

    font = await PdfGoogleFonts.nunitoExtraLight();

    //added below code by Rohit to fetch Office Master Data
    final ofcMaster = await OFCMASTERDATA().select().toList();
    boname = ofcMaster[0].BOName.toString();
    boid = ofcMaster[0].BOFacilityID.toString();
    empid = ofcMaster[0].EMPID.toString();
    empname = ofcMaster[0].EmployeeName.toString();

    barCode = '${boid}${currentDate.replaceAll(RegExp('-'), '')}';

    var dayReport =
        await DayModel().select().DayBeginDate.equals(currentDate).toMapList();
    openingBalance =double.parse(dayReport[0]['CashOpeningBalance']);
    // print("BODA Booking..!");
    closingBalance =double.parse(dayReport[0]['CashClosingBalance']);
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
        mailsCount += int.parse(speed[i]['TotalCashAmount'].toString().split('.').first);
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
// Getting the Product Sale Details.

    var prodsale =await ProductSaleTable().select()
        .BookingDate
        .equals(DateTimeDetails().dateCharacter())
        .toMapList();
    if (prodsale.isNotEmpty) {
      for (int i = 0; i < prodsale.length; i++) {
        psvalue += double.parse(prodsale[i]['TotalCashAmount']);
      }
    }
    //COD Receipt
    print('BODA SLip - COD Receipt');
    print(DateTimeDetails().onlyDate());
    final codReceipt = await Delivery().select()
        .COD.equals('X').and
        .startBlock.ART_STATUS.equals('D')
        .and.invoiceDate.equals(DateTimeDetails().currentDate())
    // DEL_DATE.startsWith(DateTime.parse(DateTimeDetails().onlyDate()))
        .and.endBlock.toMapList();
    print(codReceipt);
    print(codReceipt.length);

    if(codReceipt.isNotEmpty){
      for (int i = 0; i < codReceipt.length; i++) {
        print(codReceiptCount);
        mailsCount += int.parse(codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
        codReceiptCount += int.parse(codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
      }
    }


    print('BODA Bill Calculation');
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
  print('Bag BODA');
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
    final cashFromAO = await CashTable().select().Cash_ID.equals("CashFromAO_${DateTimeDetails().dateCharacter()}").toList();
    if(cashFromAO.isNotEmpty)
      {
        bagCashTotal += cashFromAO[0].Cash_Amount!;
        bagCash.add(cashFromAO[0].Cash_Amount!);
        bagNumber.add(cashFromAO[0].Cash_ID!);
      }

    print('BODA Banking');
    //Banking
    banking = await TBCBS_TRAN_DETAILS()
        .select()
        .TRAN_DATE
        .equals(DateTimeDetails().currentDate())
        .and.startBlock.STATUS.equals("SUCCESS").and.endBlock
        .toMapList();
    print(banking.length);
    if (banking.isNotEmpty) {
      int counter=0;
      for (int i = 0; i < banking.length; i++) {
        print('BODA CBS Calculation..!');
        // if (banking[i]['TRAN_TYPE']!.toString() == 'D' || banking[i]['TRAN_TYPE']!.toString() == 'O') {
        if (banking[i]['TRAN_TYPE'] == 'D') {
          print(bankDepositAmount);
          bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN' || banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
            sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbDeposit.add(banking[i]['CUST_ACC_NUM']);
            sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdDeposit.add(banking[i]['CUST_ACC_NUM']);
            rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }else if (banking[i]['ACCOUNT_TYPE'] == 'TD') {
            tdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            tdDeposit.add(banking[i]['CUST_ACC_NUM']);
            tdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }else if (banking[i]['ACCOUNT_TYPE'].toString().trim() == 'SSA') {
            ssaDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            ssaDeposit.add(banking[i]['CUST_ACC_NUM']);
            ssaAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }

        } else if (banking[i]['TRAN_TYPE'] == 'O') {
          print(bankDepositAmount);
          bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN' || banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
            sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            sbDeposit.add('New Account');
            sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
            rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            rdDeposit.add('New Account');
            rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
          else if (banking[i]['ACCOUNT_TYPE'] == 'TD') {
            tdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            tdDeposit.add('New Account');
            tdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
          else if (banking[i]['ACCOUNT_TYPE'].toString().trim() == 'SSA') {
            ssaDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
            ssaDeposit.add('New Account');
            ssaAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
          }
        } else if (banking[i]['TRAN_TYPE'] == 'W') {
          print(counter++);
          bankWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
          if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN'|| banking[i]['ACCOUNT_TYPE'] == 'SBBAS') {
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

    print('Ramnath->BODASlipScreent.dart : BODA IPPB');
    //IPPB
    ippb = await IPPBCBS_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    print("Ramnath->BODASlipScreent.dart : ippb:{$ippb}");
    print("Ramnath->BODASlipScreent.dart : ippb.length:'${ippb.length}'");
    if (ippb.isNotEmpty) {
      for (int i = 0; i < ippb.length; i++) {
        try {
          //if (ippb[i]['TOTAL_DEPOSITS'].toString().isNotEmpty) {
          //ippbDeposits = int.parse(ippb[i]['TOTAL_DEPOSITS']);
          //print("Ramnath->BODASlipScreent.dart: ippb[$i][TOTAL_DEPOSITS] ${ippb[i]['TOTAL_DEPOSITS']}");

          if (ippb[i]['TOTAL_DEPOSIT_AMOUNT'].toString().isNotEmpty) {
            ippbDepositAmount = int.parse(ippb[i]['TOTAL_DEPOSIT_AMOUNT']);
            print(
                "RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_DEPOSIT_AMOUNT]: ${ippb[i]['TOTAL_DEPOSIT_AMOUNT']}");
          } else {
            ippbDepositAmount = 0;
          }
          //ippbWithdraws = int.parse(ippb[i]['TOTAL_WITHDRAWALS']);
          //print("RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_WITHDRAWALS] ${ippb[i]['TOTAL_WITHDRAWALS']}");
          if (ippb[i]['TOTAL_WITHDRAWAL_AMOUNT'].toString().isNotEmpty) {
            ippbWithdrawAmount = int.parse(ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']);
            print(
                "RamNaTh->GenerateBODAReportScreen.dart : ippb[$i][TOTAL_WITHDRAWAL_AMOUNT] ${ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']}");
          } else {
            ippbWithdrawAmount = 0;
          }
        }catch(e){
          print("Ramnath->GenerateBODAReportScreen.dart : Inside Catch{} ");
          //ippbDepositAmount = 0;
          //ippbWithdrawAmount = 0;
        }
        //}
      }
    }
    print('Ramnath->BODASlipScreent.dart :BODA Dcube');
    dcube = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("DCube")
        .toMapList();
    if (dcube.isNotEmpty) {
      dcudeWithdrawl = int.parse(dcube[0]['TOTAL_WITHDRAWALS']);
      dcudeWithdrawlAmount = int.parse(dcube[0]['TOTAL_WITHDRAWAL_AMOUNT']);
    }

    print('Ramnath->BODASlipScreent.dart :BODA CSC');
    csc = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("CSC")
        .toMapList();
    if (csc.isNotEmpty) {
      cscDeposits = int.parse(csc[0]['TOTAL_DEPOSITS']);
      cscDepositsAmount = int.parse(csc[0]['TOTAL_DEPOSIT_AMOUNT']);
    }

    print('Ramnath->BODASlipScreent.dart :BODA OTHERS');
    others = await DataEntry_DETAILS()
        .select()
        .TRANSACTION_DATE
        .equals(DateTimeDetails().currentDate())
        .and
        .ENTRY_TYPE
        .equals("Others")
        .toMapList();
    if (others.isNotEmpty){
     otherDeposits = int.parse(others[0]['TOTAL_DEPOSITS']);
      otherDepositsAmount = int.parse(others[0]['TOTAL_DEPOSIT_AMOUNT']);
     otherWithdrawl = int.parse(others[0]['TOTAL_WITHDRAWALS']);
      otherWithdrawlAmount = int.parse(others[0]['TOTAL_WITHDRAWAL_AMOUNT']);
      othersText=others[0]["Remarks"];
    }
    print('Ramnath->BODASlipScreent.dart :BODA Insurance');
    // Insurance
    // insurance = await Ins_transaction().select().toMapList();
    insurance = await DAY_TRANSACTION_REPORT().select().startBlock
        .STATUS
        .equals("SUCCESS")
        .or
        .STATUS
        .equals("Success")
        .endBlock
        .and
        .startBlock.TRAN_DATE.equals(DateTimeDetails().currentDate()).and.endBlock
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
      // }
      // } else if (insurance[i]['tranType'] == 'WITHDRAW') {
      //   insuranceWithdrawAmount += int.parse(insurance[i]['amount']);
      //   if (insurance[i]['policyType'] == 'PLI') {
      //     pliWithdrawAmount += int.parse(insurance[i]['amount']);
      //     pliWithdraw.add(insurance[i]['policyNumber']);
      //     pliAmountWithdraw.add(insurance[i]['amount']);
      //   } else if (insurance[i]['policyType'] == 'RPL') {
      //     rpliWithdrawAmount += int.parse(insurance[i]['amount']);
      //     rpliWithdraw.add(insurance[i]['policyNumber']);
      //     rpliAmountWithdraw.add(insurance[i]['amount']);
      //   }
      // }
    }

    //eMO Paid
    print('Ramnath->BODASlipScreent.dart :BODA eMO Paid');
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
    print('Ramnath->BODASlipScreent.dart : BODA Inventory');
    print('Inventory---');
    //Inventory
    products = await ProductsTable().select().toMapList();
    if (products.isNotEmpty) {
      for (int i = 0; i < products.length; i++) {
        productsCount += double.parse(products[i]['Value'].toString());
        productType.add(products[i]['Name']);
        productAmount.add(products[i]['Value'].toString());
        pdfInventory
            .add(pdfSlipTitleValue(products[i]['Name'], products[i]['Value']));
      }
    }
    print('Ramnath->BODASlipScreent.dart : BODA Liability');
    //Liability
    liability = await Liability().select().Date.equals(currentDate).toMapList();
    if (liability.isNotEmpty) {
      liabilityAmount = double.parse(liability[0]['Amount']);
      liabilityDescription = liability[0]['Description'];
    }
    print('Ramnath->BODASlipScreent.dart : BODA Details');
    var bodaDetails =
        await BodaSlip().select().bodaDate.equals(currentDate).toMapList();
    cashTOAO = bodaDetails[0]['cashTo'].toString().isEmpty
        ? 0
        : int.parse(bodaDetails[0]['cashTo']);
    cashIndent = bodaDetails[0]['cashFrom'].toString().isEmpty
        ? 0
        : int.parse(bodaDetails[0]['cashFrom']);
    print('BODA Total Calculation..!');
    // totalReceipts = double.parse(openingBalance) + mailsCount + bankDepositAmount + insuranceDepositAmount + ippbDepositAmount;
    print('BODA Total Calculation');
    totalReceipts = (bagCashTotal +
            mailsCount +
            billTotal +
            psvalue+
            bankDepositAmount +
            insuranceDepositAmount +
            ippbDepositAmount+
          cscDepositsAmount+
           otherDepositsAmount)
        .toDouble();
    totalPayments = (cashTOAO +
            emoPaid +
            bankWithdrawAmount +
            insuranceWithdrawAmount +
            ippbWithdrawAmount+
            dcudeWithdrawlAmount+
            otherWithdrawlAmount)
        .toDouble();

    print('mails count');
    print(mailsCount);

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
                    onPressed: () =>
                        // Navigator.pushAndRemoveUntil(
                        // context,
                        // MaterialPageRoute(
                        //     builder: (_) => const ReportsMainScreen()),
                        // (route) => false),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainHomeScreen(
                                  UtilitiesMainScreen(),
                                  0)),
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: _pdfPrinting, icon: const Icon(Icons.print)),
                    IconButton(
                        onPressed: _generatePDF,
                        icon: const Icon(Icons.file_copy)),
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
                          boname.toString(),
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
                            subtitle: '\u{20B9} ${openingBalance.toStringAsFixed(2)}'),
                        nextSpace('RECEIPTS'),
                        slipTitleValue(
                            'Opening Balance Amount', openingBalance.toStringAsFixed(2)),
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
                                  codReceiptCount!=0
                                      ?bookedExpansionTile(
                                      'COD Receipt',
                                      codReceiptCount,
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
                        psvalue == 0
                            ? Container()
                            : Column(
                          children: [
                            // slipTitleDescription(
                            //     'IPPB Deposits', ippbDeposits.toString()),
                            slipTitleValue(
                                'Product Sale', psvalue.toString()),
                          ],
                        ),
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
                                  tdDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                      'TD Deposit',
                                      tdDepositAmount,
                                      tdDeposit,
                                      tdAmountDeposit)
                                      : Container(),
                                  ssaDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                      'SSA Deposit',
                                      ssaDepositAmount,
                                      ssaDeposit,
                                      ssaAmountDeposit)
                                      : Container(),
                                ],
                              ),
                        pliDeposit.isEmpty && rpliDeposit.isEmpty
                            ? Container()
                            : ExpansionTile(
                                title: expansionTitleValue('Insurance Deposit',
                                    insuranceDepositAmount.toInt()),
                                children: [
                                  pliDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'PLI Deposit',
                                          pliDepositAmount.toInt(),
                                          pliDeposit,
                                          pliAmountDeposit)
                                      : Container(),
                                  rpliDeposit.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RPLI Deposit',
                                          rpliDepositAmount.toInt(),
                                          rpliDeposit,
                                          rpliAmountDeposit)
                                      : Container(),
                                ],
                              ),
                        ippbDepositAmount == 0
                            ? Container()
                            : Column(
                                children: [
                                  // slipTitleDescription(
                                  //     'IPPB Deposits', ippbDeposits.toString()),
                                  slipTitleValue(
                                      'IPPB Deposits Value', ippbDepositAmount.toString()),
                                ],
                              ),
                        cscDepositsAmount == 0
                            ? Container()
                            : Column(
                          children: [
                            slipTitleDescription(
                                'CSC Deposits', cscDeposits.toString()),
                            slipTitleValue(
                                'Value', cscDepositsAmount.toString()),
                          ],
                        ),
                        otherDepositsAmount == 0
                            ? Container()
                            : Column(
                          children: [
                            slipTitleDescription(
                                '$othersText Deposits', otherDeposits.toString()),
                            slipTitleValue(
                                'Value', otherDepositsAmount.toString()),
                          ],
                        ),

                        bagCashTotal == 0
                            ? Container()
                            : bagNumber.isNotEmpty
                                ? bookedExpansionTile('Bag Cash', bagCashTotal.toInt(),
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
                                title: expansionTitleValue(
                                    'Insurance Withdraw',
                                    pliWithdrawAmount.toInt() +
                                        rpliWithdrawAmount.toInt()),
                                children: [
                                  pliWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'PLI Withdraw',
                                          pliWithdrawAmount.toInt(),
                                          pliWithdraw,
                                          pliAmountWithdraw)
                                      : Container(),
                                  rpliWithdraw.isNotEmpty
                                      ? bookedExpansionTile(
                                          'RPLI Withdraw',
                                          rpliWithdrawAmount.toInt(),
                                          rpliWithdraw,
                                          rpliAmountWithdraw)
                                      : Container(),
                                ],
                              ),
                        ippbWithdrawAmount == 0
                            ? Container()
                            : Column(
                                children: [
                                  // slipTitleDescription('IPPB Withdraw',
                                  //     ippbWithdraws.toString()),
                                  slipTitleValue(
                                      'IPPB Withdraw Value', ippbWithdrawAmount.toString()),
                                ],
                              ),
                        dcudeWithdrawlAmount == 0
                            ? Container()
                            : Column(
                          children: [
                            slipTitleDescription(
                                'Dcube Withdrawl', dcudeWithdrawl.toString()),
                            slipTitleValue(
                                'Value', dcudeWithdrawlAmount.toString()),
                          ],
                        ),
                        otherWithdrawlAmount == 0
                            ? Container()
                            : Column(
                          children: [
                            slipTitleDescription(
                                '$othersText Withdrawl', otherWithdrawl.toString()),
                            slipTitleValue(
                                'Value', otherWithdrawlAmount.toString()),
                          ],
                        ),
                        const Space(),
                        SizedBox(width: 200, child: const Divider()),

                        slipTitleValue(
                            'TOTAL PAYMENTS', totalPayments.toString()),
                        nextSpace('CASH BALANCE'),
                        slipTitleValue(
                            'Cash & Currency Notes Amount', closingBalance.toStringAsFixed(2)),
                        nextSpace('INVENTORY'),
                        ExpansionTile(
                          title: expansionTitleValue(
                              'Postage & Revenue Stamps Amount (Equivalent)',
                              productsCount.toInt()),
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
                        slipTitleValue(liabilityDescription, liabilityAmount.toStringAsFixed(2)),
                        // bankingLiabilityNumber.isNotEmpty ? bookedExpansionTile('Banking Liability', bankingLiabilityCount, bankingLiabilityNumber, bankingLiabilityAmount) : Container(),
                        // insuranceLiabilityNumber.isNotEmpty ? bookedExpansionTile('Insurance Liability', insuranceLiabilityCount, insuranceLiabilityNumber, insuranceLiabilityAmount) : Container(),
                        // mailsLiabilityNumber.isNotEmpty ? bookedExpansionTile('Mails Liability', emoLiabilityCount, mailsLiabilityNumber, mailsLiabilityAmount) : Container(),
                        nextSpace('CASH INDENT'),
                        slipTitleValue(
                            'Cash Indent Amount', cashIndent.toString()),
                        nextSpace('CLOSING BALANCE'),
                        slipTitleValue(
                            'Closing Balance', walletAmount.toStringAsFixed(2)),
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
                  onPressed: () =>
                      // Navigator.pushAndRemoveUntil(
                      // context,
                      // MaterialPageRoute(
                      //     builder: (_) => const ReportsMainScreen()),
                      // (route) => false),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MainHomeScreen(
                                UtilitiesMainScreen(),
                                0)),
                  ),
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
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (_) => const ReportsMainScreen()),
    //     (route) => false);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              MainHomeScreen(
                  UtilitiesMainScreen(),
                  0)),
    );
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

    Directory directory = Directory('/storage/emulated/0/Darpan');
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
        pw.Text('${boname}',
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
                      text: walletAmount.toStringAsFixed(2),
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
        if(ippbDepositAmount != 0)pdfSlipTitleValue('IPPB Deposits', '₹$ippbDepositAmount'),
        if(cscDepositsAmount != 0)pdfSlipTitleValue('CSC Deposits', '₹$cscDepositsAmount'),
        if(otherDepositsAmount != 0)pdfSlipTitleValue('Other Deposits', '₹$otherDepositsAmount'),
        heading('PAYMENTS'),
        pdfSlipTitleValue('Cash to AO', '₹$cashTOAO'),
        totalDivider(),
        pdfSlipTitleValue('TOTAL PAYMENTS', '₹$cashTOAO'),
        if(ippbWithdrawAmount != 0)pdfSlipTitleValue('IPPB Withdraw', '₹$ippbWithdrawAmount'),
        if(dcudeWithdrawlAmount != 0)pdfSlipTitleValue('Dcube Withdraw', '₹$dcudeWithdrawlAmount'),
        if(otherWithdrawlAmount != 0)pdfSlipTitleValue('Other Withdraw', '₹$otherWithdrawlAmount'),
        heading('CASH BALANCE'),
        pdfSlipTitleValue('Cash & Currency Notes Amount', '₹${closingBalance.toStringAsFixed(2)}'),
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

            codReceiptCount != 0
                ? pw.Table(border: pw.TableBorder.all(width: 1), children: [
              pw.TableRow(children: [
                pw.Expanded(
                    flex: 2,
                    child: pw.Center(
                        child: pw.Column(children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            child: pw.Text('COD Receipt'),
                          )
                        ]))),
                pw.Expanded(
                    flex: 1,
                    child: pw.Center(
                        child: pw.Column(children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.symmetric(vertical: 5),
                            child: pw.Text('₹$codReceiptCount',
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
        pw.Text('Designed & Developed by C.E.P.T.'),
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

  _pdfPrinting() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();

    basicInformation.clear();

    basicInformation.add("Office Name");
    basicInformation.add(userDetails[0].BOName.toString());
    basicInformation.add("Office ID");
    basicInformation.add(userDetails[0].BOFacilityID.toString());

    basicInformation.add("Report Date");
    basicInformation.add(date);
    basicInformation.add("Report Time");
    basicInformation.add(time);
    basicInformation.add("Opening Cash Balance:");
    basicInformation.add("${openingBalance.toStringAsFixed(2)}");
    // basicInformation.add("Opening Inventory Bal:");
    // basicInformation.add("₹");

    basicInformation.add("................................");
    basicInformation.add("");

    basicInformation.add("------------RECEIPTS-----------");
    basicInformation.add("");

    basicInformation.add("Cash from AO");
    basicInformation.add("${bagCashTotal.toStringAsFixed(2)}");
    // basicInformation.add("Mails Receipts");
    // int totalMails = mailsCount + billTotal;
    if(rlMailsCount>0) {
      basicInformation.add("RL Booking");
      basicInformation.add(rlMailsCount.toDouble().toStringAsFixed(2));
    }
    if(parcelMailsCount>0)
    {
      basicInformation.add("Parcel Booking");
      basicInformation.add(parcelMailsCount.toDouble().toStringAsFixed(2));
    }
    if(speedMailsCount>0) {
      basicInformation.add("SP Booking");
      basicInformation.add(speedMailsCount.toDouble().toStringAsFixed(2));
    }
    if(emoMailsCount>0) {
      basicInformation.add("eMO Value");
      basicInformation.add(emoValue.toDouble().toStringAsFixed(2));
      basicInformation.add("eMO Commission");
      basicInformation.add(emoCommission.toDouble().toStringAsFixed(2));
    }
    if(codReceiptCount>0)
      {
        basicInformation.add("COD Receipt");
        basicInformation.add(codReceiptCount.toDouble().toStringAsFixed(2));
      }

    // basicInformation.add("$totalMails");
    if(psvalue>0)
      {
        basicInformation.add("Product Sale");
        basicInformation.add("${psvalue}");
      }
    basicInformation.add("CBS Deposit");
    // print('BODA Printing SB Deposit' + bankDepositAmount.toString());
    basicInformation.add("${bankDepositAmount.toStringAsFixed(2)}");


    basicInformation.add("Insurance Receipts");
    basicInformation.add("${insuranceDepositAmount.toStringAsFixed(2)}");
    basicInformation.add("IPPB Deposit");
    basicInformation.add("${ippbDepositAmount.toStringAsFixed(2)}");
    if(cscDepositsAmount>0)
      {
        basicInformation.add("CSC Deposit");
        basicInformation.add("${cscDepositsAmount.toStringAsFixed(2)}");
      }
    if(otherDepositsAmount>0)
    {
      basicInformation.add("$othersText Deposit");
      basicInformation.add("${otherDepositsAmount.toStringAsFixed(2)}");
    }
    basicInformation.add("===============");
    basicInformation.add("===============");
    basicInformation.add("Total Receipts");
    basicInformation.add("${totalReceipts.toStringAsFixed(2)}");

    basicInformation.add("------------PAYMENTS-----------");
    basicInformation.add("");

    basicInformation.add("Cash to AO");
    basicInformation.add("${cashTOAO.toStringAsFixed(2)}");
    basicInformation.add("eMO Payments");
    basicInformation.add("${emoPaid.toStringAsFixed(2)}");
    basicInformation.add("CBS Withdraw");
    basicInformation.add("${bankWithdrawAmount.toStringAsFixed(2)}");
    basicInformation.add("Insurance Payments");
    basicInformation.add("${insuranceWithdrawAmount.toStringAsFixed(2)}");
    basicInformation.add("IPPB Withdraw");
    basicInformation.add("${ippbWithdrawAmount.toStringAsFixed(2)}");
    if(dcudeWithdrawlAmount>0)
    {
      basicInformation.add("Dcube Withdraw");
      basicInformation.add("${dcudeWithdrawlAmount.toStringAsFixed(2)}");
    }
    if(otherWithdrawlAmount>0)
    {
      basicInformation.add("$othersText Withdraw");
      basicInformation.add("${otherWithdrawlAmount.toStringAsFixed(2)}");
    }
    basicInformation.add("===============");
    basicInformation.add("===============");
    basicInformation.add("Total Payments");
    basicInformation.add("${totalPayments.toStringAsFixed(2)}");

    basicInformation.add("----------CASH BALANCE---------");
    basicInformation.add("");

    basicInformation.add("Cash & Currency Notes");
    basicInformation.add("${closingBalance.toStringAsFixed(2)}");

    basicInformation.add("------------INVENTORY----------");
    basicInformation.add("");

    double inventoryTotal=0;
    if (products.length > 0) {
      for (int i = 0; i < products.length; i++) {
        basicInformation.add("${i+1}.${products[i]['Name'].toString().substring(0,10)}");
        basicInformation.add("${double.parse(products[i]['Value']).toStringAsFixed(2)}");
        inventoryTotal = inventoryTotal+ double.parse(products[i]['Value']);
      }
      basicInformation.add("===============");
      basicInformation.add("===============");
      basicInformation.add("Total Inventory");
      basicInformation.add("${inventoryTotal.toStringAsFixed(2)}");

    } else {
      basicInformation.add("NIL");
      basicInformation.add("₹");
    }

    basicInformation.add("------------LIABILITIES---------");
    basicInformation.add("");

    basicInformation.add("Description:");
    basicInformation.add("$liabilityDescription");
    basicInformation.add("Amount:");
    basicInformation.add("₹${liabilityAmount.toStringAsFixed(2)}");

    basicInformation.add("-----------CASH INDENT---------");
    basicInformation.add("");
    basicInformation.add("Amount:");
    basicInformation.add("${cashIndent.toStringAsFixed(2)}");

    basicInformation.add("------------------------------");
    basicInformation.add("");
    basicInformation.add("Closing Cash Balance:");
    basicInformation.add("${walletAmount.toStringAsFixed(2)}");

    secondReceipt.clear(); //sending empty list so that it won't print

    PrintingTelPO printer = new PrintingTelPO();
    await printer.printThroughUsbPrinter(
        "BODA", barCode, basicInformation, secondReceipt, 1);
  }
}
