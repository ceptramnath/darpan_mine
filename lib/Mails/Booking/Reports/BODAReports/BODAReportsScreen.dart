import 'dart:io';

import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'BODAPdfScreen.dart';
class BODAReportScreen extends StatefulWidget {
  const BODAReportScreen({Key? key}) : super(key: key);

  @override
  _BODAReportScreenState createState() => _BODAReportScreenState();
}

class _BODAReportScreenState extends State<BODAReportScreen> {
  final pdf = pw.Document();

  var font;

  int cashTOAO = 0;
  int cashIndent = 0;
  int mailsAmount = 0;
  double psvalue= 0;
  int bankDepositAmount = 0;
  int ippbDepositAmount = 0;
  int ippbDeposits = 0;
  int otherDeposits=0;
  int otherDepositsAmount=0;
  int cscDeposits=0;
  int cscDepositsAmount=0;
  int bankWithdrawAmount = 0;
  int ippbWithdraws = 0;
  int ippbWithdrawAmount = 0;
  int otherWithdrawl=0;
  int otherWithdrawlAmount=0;
  String othersText = "";
  int dcudeWithdrawl=0;
  int dcudeWithdrawlAmount=0;
  double insuranceDepositAmount = 0;
  int insuranceWithdrawAmount = 0;
  int rlMailsAmount = 0;
  int speedMailsAmount = 0;
  int emoMailsAmount = 0;
  int codReceiptCount =0;
  int parcelMailsAmount = 0;
  int billTotal = 0;
  double productsCount = 0;
  int sbDepositAmount = 0;
  int rdDepositAmount = 0;
  int tdDepositAmount = 0;
  int ssaDepositAmount = 0;
  int sbWithdrawAmount = 0;
  int rdWithdrawAmount = 0;
  double pliDepositAmount = 0;
  double rpliDepositAmount = 0;
  int pliWithdrawAmount = 0;
  int rpliWithdrawAmount = 0;
  double emoPaid = 0;
  double bagCashTotal = 0;

  double totalReceipts = 0;
  double totalPayments = 0;

  double openingBalance = 0;
  double closingBalance = 0;
  double liabilityAmount = 0;
  String liabilityDescription = '';

  bool bodaReport = false;

  final formGlobalKey = GlobalKey<FormState>();

  final dateFocus = FocusNode();

  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  List products = [];
  List articles = [];
  List bills = [];
  List banking = [];
  List bagCash = [];
  List bagNumber = [];
  List bags = [];
  List ippb = [];
  List dcube=[];
  List csc=[];
  List others=[];
  List insurance = [];
  List inventory = [];
  List liability = [];
  List bookedRL = [];
  List bookedRLAmount = [];
  List bookedEMO = [];
  List bookedEMOAmount = [];
  List bookedSpeed = [];
  List bookedSpeedAmount = [];
  List bookedParcel = [];
  List bookedParcelAmount = [];
  List sbDeposit = [];
  List sbAmountDeposit = [];
  List sbWithdraw = [];
  List sbAmountWithdraw = [];
  List rdDeposit = [];
  List rdAmountDeposit = [];
  List tdDeposit = [];
  List tdAmountDeposit = [];
  List ssaDeposit = [];
  List ssaAmountDeposit = [];
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
  List productType = [];
  List productAmount = [];
  List billNames = [];
  List billAmount = [];
  String barCode = '';

  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(selected);
      setState(() {
        dateController.text = formattedDate;
      });
    }
    print("BODA Report for "+ dateController.text);
    getBODA(dateController.text);
  }

  getBODA(String date) async {

    print("BODA Report for $date");
    final dayDetails = await BodaBrief()
        .select()
        .BodaGeneratedDate
        .equals(date)
        .toMapList();
    if (dayDetails.isNotEmpty) {
      barCode = '${dayDetails[0]['BodaNumber']}';
      openingBalance = double.parse(dayDetails[0]['OpeningBalance']);
      closingBalance = double.parse(dayDetails[0]['ClosingBalance']);
      print("BODA Booking..!");
      //Booked Mails Receipt
      var registerLetter = await LetterBooking()
          .select()
          .startBlock
          .BookingDate
          .equals(date)
          .and
          .TenderID
          .equals('S')
          .endBlock
          .toMapList();
      // print('Regd. Letter length- ' + registerLetter.length.toString());
      if (registerLetter.isNotEmpty) {
        for (int i = 0; i < registerLetter.length; i++) {
          mailsAmount += int.parse(registerLetter[i]['TotalAmount']);
          rlMailsAmount += int.parse(registerLetter[i]['TotalAmount']);
          bookedRL.add(registerLetter[i]['ArticleNumber']);
          bookedRLAmount.add(registerLetter[i]['TotalAmount']);
        }
      }
      var parcel = await ParcelBooking()
          .select()
          .startBlock
          .BookingDate
          .equals(date)
          .and
          .TenderID
          .equals('S')
          .endBlock
          .toMapList();
      if (parcel.isNotEmpty) {
        for (int i = 0; i < parcel.length; i++) {
          mailsAmount += int.parse(parcel[i]['TotalAmount']);
          parcelMailsAmount += int.parse(parcel[i]['TotalAmount']);
          bookedParcel.add(parcel[i]['ArticleNumber']);
          bookedParcelAmount.add(parcel[i]['TotalAmount']);
        }
      }
      var speed = await SpeedBooking()
          .select()
          .startBlock
          .BookingDate
          .equals(date)
          .and
          .TenderID
          .equals('S')
          .endBlock
          .toMapList();
      if (speed.isNotEmpty) {
        for (int i = 0; i < speed.length; i++) {
          mailsAmount += int.parse(speed[i]['TotalCashAmount'].toString().split('.').first);
          speedMailsAmount += int.parse(speed[i]['TotalCashAmount'].toString().split('.').first);
          bookedSpeed.add(speed[i]['ArticleNumber']);
          bookedSpeedAmount.add(speed[i]['TotalCashAmount'].toString().split('.').first);
        }
      }
      var emo = await EmoBooking()
          .select()
          .BookingDate
          .equals(date)
          .toMapList();
      if (emo.isNotEmpty) {
        for (int i = 0; i < emo.length; i++) {
          mailsAmount += int.parse(emo[i]['TotalAmount']);
          emoMailsAmount += int.parse(emo[i]['TotalAmount']);
          bookedEMO.add(emo[i]['ArticleNumber']);
          bookedEMOAmount.add(emo[i]['TotalAmount']);
          // emoValue += int.parse(emo[i]['Value']);
          // emoCommission += int.parse(emo[i]['CommissionAmount']);

        }
      }
// Getting the Product Sale Details.
   String dte = '${date.substring(0,2)}${date.substring(3,5)}${date.substring(6)}';
      var prodsale =await ProductSaleTable().select()
          .BookingDate
          .equals(dte)
          .toMapList();
      if (prodsale.isNotEmpty) {
        for (int i = 0; i < prodsale.length; i++) {
          psvalue += double.parse(prodsale[i]['TotalCashAmount']);
        }
      }
      //COD Receipt
      print('BODA SLip - COD Receipt');
      // print(DateTimeDetails().onlyDate());
      final codReceipt = await Delivery().select()
          .COD.equals('X').and
          .startBlock.ART_STATUS.equals('D')
          .and.invoiceDate.equals(date)
      // DEL_DATE.startsWith(DateTime.parse(DateTimeDetails().onlyDate()))
          .and.endBlock.toMapList();
      print(codReceipt);
      print(codReceipt.length);

      if(codReceipt.isNotEmpty){
        for (int i = 0; i < codReceipt.length; i++) {
          mailsAmount += int.parse(codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
          codReceiptCount += int.parse(codReceipt[i]['MONEY_COLLECTED'].toString().split('.').first);
        }
      }

      print('BODA Bill Calculation');
      //Bills
      // bills = await BillData().select().BillDate.equals(DateTimeDetails().currentDate()).toMapList();
      bills = await BillFile()
          .select()
          .BookingDate
          .equals(date)
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

      /*
    // //Articles
    // articles = await BodaArticle().select().BodaDate.equals(date).toMapList();
    // if (articles.isNotEmpty) {
    //   for (int i = 0; i < articles.length; i++) {
    //     mailsAmount += int.parse(articles[i]['ArticleAmount']);
    //     if (articles[i]['ArticleType'] == 'LETTER') {
    //       rlMailsAmount += int.parse(articles[i]['ArticleAmount']);
    //       bookedRL.add(articles[i]['ArticleNumber']);
    //       bookedRLAmount.add(articles[i]['ArticleAmount']);
    //     } else if (articles[i]['ArticleType'] == 'SP_INLAND') {
    //       speedMailsAmount += int.parse(articles[i]['ArticleAmount']);
    //       bookedSpeed.add(articles[i]['ArticleNumber']);
    //       bookedSpeedAmount.add(articles[i]['ArticleAmount']);
    //     } else if (articles[i]['ArticleType'] == 'EMO') {
    //       emoMailsAmount += int.parse(articles[i]['ArticleAmount']);
    //       bookedEMO.add(articles[i]['ArticleNumber']);
    //       bookedEMOAmount.add(articles[i]['ArticleAmount']);
    //     } else if (articles[i]['ArticleType'] == 'PARCEL') {
    //       parcelMailsAmount += int.parse(articles[i]['ArticleAmount']);
    //       bookedParcel.add(articles[i]['ArticleNumber']);
    //       bookedParcelAmount.add(articles[i]['ArticleAmount']);
    //     }
    //   }
    // }
    //


     */

      // //Bag
      // bags = await BagCashTable()
      //     .select()
      //     .BagDate
      //     .equals(date)
      //     .toMapList();
      // if (bags.isNotEmpty) {
      //   for (int i = 0; i < bags.length; i++) {
      //     bagCashTotal += double.parse(bags[i]['CashAmount']);
      //     bagCash.add(bags[i]['CashAmount']);
      //     bagNumber.add(bags[i]['BagNumber']);
      //   }
      // }

      print('Bag BODA');
      //Bag
      bags = await BagCashTable()
          .select()
          .BagDate
          .equals(date)
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

      // print(date);
      var formatter = DateFormat('ddMMyyyy');
      // print(formatter.format(DateTime.parse(date)));


      final cashFromAO = await CashTable()
          .select()
          .Cash_ID.equals("CashFromAO_${date.toString().replaceAll('-', '')}")
          .toList();
      if(cashFromAO.isNotEmpty)
      {
        bagCashTotal += cashFromAO[0].Cash_Amount!;
        bagCash.add(cashFromAO[0].Cash_Amount!);
        bagNumber.add(cashFromAO[0].Cash_ID!);
      }


      print('RamNaTh=>BODAReportsScreen.dart => BODA Banking');
      //Banking
      banking = await TBCBS_TRAN_DETAILS()
          .select()
          .TRAN_DATE
          .equals(date)
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
            if (banking[i]['ACCOUNT_TYPE'].toString().contains('SB')) {
              sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
              sbDeposit.add(banking[i]['CUST_ACC_NUM']);
              sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
            } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
              rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
              rdDeposit.add(banking[i]['CUST_ACC_NUM']);
              rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
            }
            else if (banking[i]['ACCOUNT_TYPE'] == 'TD') {
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
            if (banking[i]['ACCOUNT_TYPE'].toString().contains('SB')) {
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
            if (banking[i]['ACCOUNT_TYPE'].toString().contains('SB')) {
              sbWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
              sbWithdraw.add(banking[i]['CUST_ACC_NUM']);
              sbAmountWithdraw.add(banking[i]['TRANSACTION_AMT']);
            }
          }
        }
      }

      print('RamNaTh=>BODAReportsScreen.dart => BODA IPPB');
      //IPPB
      ippb = await IPPBCBS_DETAILS()
          .select()
          .TRANSACTION_DATE
          .equals(date)
          .toMapList();
      print('RamNaTh=>BODAReportsScreen.dart => ippb{$ippb}');
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
      print('BODA Dcube');
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

      print('BODA CSC');
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
        otherDeposits = int.parse(others[0]['TOTAL_DEPOSITS']);
        otherDepositsAmount = int.parse(others[0]['TOTAL_DEPOSIT_AMOUNT']);
        otherWithdrawl = int.parse(others[0]['TOTAL_WITHDRAWALS']);
        otherWithdrawlAmount = int.parse(others[0]['TOTAL_WITHDRAWAL_AMOUNT']);
        othersText = others[0]['Remarks'];
      }
      print('BODA Insurance');
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
          .startBlock.TRAN_DATE.equals(date).and.endBlock
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
          .equals(date)
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
      liability = await Liability().select().Date.equals(date).toMapList();
      if (liability.isNotEmpty) {
        liabilityAmount = double.parse(liability[0]['Amount']);
        liabilityDescription = liability[0]['Description'];
      }
      print('BODA Details');
      var bodaDetails =
      await BodaSlip().select().bodaDate.equals(date).toMapList();
      cashTOAO = bodaDetails[0]['cashTo'].toString().isEmpty
          ? 0
          : int.parse(bodaDetails[0]['cashTo']);
      cashIndent = bodaDetails[0]['cashFrom'].toString().isEmpty
          ? 0
          : int.parse(bodaDetails[0]['cashFrom']);
      print('BODA Total Calculation..!');
      // totalReceipts = double.parse(openingBalance) + mailsCount + bankDepositAmount + insuranceDepositAmount + ippbDepositAmount;
      print('BODA Total Calculation');


      totalReceipts = (openingBalance+bagCashTotal +
          mailsAmount +
          psvalue+
          billTotal +
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
      print(totalReceipts.toStringAsFixed(2));
      print(totalPayments.toStringAsFixed(2));
      setState(() {
        bodaReport = true;
      });
    }
    else{
      setState(() {
        bodaReport=false;
      });
    }

    //
    //
    // print('BODA Banking');
    // //Banking
    // banking = await TBCBS_TRAN_DETAILS()
    //     .select()
    //     .TRAN_DATE
    //     .equals(date)
    //     .and.startBlock.STATUS.equals("SUCCESS").and.endBlock
    //     .toMapList();
    // print(banking.length);
    // if (banking.isNotEmpty) {
    //   for (int i = 0; i < banking.length; i++) {
    //     print('BODA CBS Calculation..!');
    //     // if (banking[i]['TRAN_TYPE']!.toString() == 'D' || banking[i]['TRAN_TYPE']!.toString() == 'O') {
    //     if (banking[i]['TRAN_TYPE'] == 'D') {
    //       print(bankDepositAmount);
    //       bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //       if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN') {
    //         sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         sbDeposit.add(banking[i]['CUST_ACC_NUM']);
    //         sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
    //       } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
    //         rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         rdDeposit.add(banking[i]['CUST_ACC_NUM']);
    //         rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
    //       }
    //     } else if (banking[i]['TRAN_TYPE'] == 'O') {
    //       print(bankDepositAmount);
    //       bankDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //       if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN') {
    //         sbDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         sbDeposit.add('New Account');
    //         sbAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
    //       } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
    //         rdDepositAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         rdDeposit.add('New Account');
    //         rdAmountDeposit.add(banking[i]['TRANSACTION_AMT']);
    //       }
    //     } else if (banking[i]['TRAN_TYPE'] == 'W') {
    //       bankWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //       if (banking[i]['ACCOUNT_TYPE'] == 'SBGEN') {
    //         sbWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         sbWithdraw.add(banking[i]['CUST_ACC_NUM']);
    //         sbAmountWithdraw.add(banking[i]['TRANSACTION_AMT']);
    //       } else if (banking[i]['ACCOUNT_TYPE'] == 'RD') {
    //         rdWithdrawAmount += int.parse(banking[i]['TRANSACTION_AMT']);
    //         rdWithdraw.add(banking[i]['CUST_ACC_NUM']);
    //         rdAmountWithdraw.add(banking[i]['TRANSACTION_AMT']);
    //       }
    //     }
    //   }
    // }
    //
    // ippb = await IPPBCBS_DETAILS()
    //     .select()
    //     .TRANSACTION_DATE
    //     .equals(date)
    //     .toMapList();
    // if (ippb.isNotEmpty) {
    //   for (int i = 0; i < ippb.length; i++) {
    //     if (ippb[i]['TOTAL_DEPOSITS'].toString().isNotEmpty) {
    //       ippbDeposits = int.parse(ippb[i]['TOTAL_DEPOSITS']);
    //       ippbDepositAmount = int.parse(ippb[i]['TOTAL_DEPOSIT_AMOUNT']);
    //       ippbWithdraws = int.parse(ippb[i]['TOTAL_WITHDRAWALS']);
    //       ippbWithdrawAmount = int.parse(ippb[i]['TOTAL_WITHDRAWAL_AMOUNT']);
    //     }
    //   }
    // }
    //
    // // Insurance
    // // insurance = await Ins_transaction().select().toMapList();
    // insurance = await DAY_TRANSACTION_REPORT().select().STATUS.equals("SUCCESS").and
    // .startBlock.TRAN_DATE.equals(DateTimeDetails().currentDate()).and.endBlock
    // .toMapList();
    //
    // for (int i = 0; i < insurance.length; i++) {
    //   // if (insurance[i]['tranType'] == 'InitialPremium' ||
    //   //     insurance[i]['tranType'] == 'RevivalPremium') {
    //     insuranceDepositAmount += int.parse(insurance[i]['AMOUNT']);
    //     if (insurance[i]['POLICY_TYPE'] == 'PLI') {
    //       pliDepositAmount += int.parse(insurance[i]['AMOUNT']);
    //       pliDeposit.add(insurance[i]['POLICY_NO']);
    //       pliAmountDeposit.add(insurance[i]['AMOUNT']);
    //     } else if (insurance[i]['POLICY_TYPE'] == 'RPL') {
    //       rpliDepositAmount += int.parse(insurance[i]['AMOUNT']);
    //       rpliDeposit.add(insurance[i]['POLICY_NO']);
    //       rpliAmountDeposit.add(insurance[i]['AMOUNT']);
    //     }
    //
    // }
    //
    // totalReceipts = (bagCashTotal +
    //         mailsAmount +
    //         bankDepositAmount +
    //         insuranceDepositAmount +
    //         ippbDepositAmount)
    //     .toDouble();
    //
    // totalPayments = (cashTOAO +
    //         emoPaid +
    //         bankWithdrawAmount +
    //         insuranceWithdrawAmount +
    //         ippbWithdrawAmount)
    //     .toDouble();
    //
    // // Inventory
    // inventory =
    //     await BodaInventory().select().InventoryDate.equals(date).toMapList();
    // if (inventory.isNotEmpty) {
    //   for (int i = 0; i < inventory.length; i++) {
    //     productsCount += (int.parse(inventory[i]['InventoryPrice']) *
    //         int.parse(inventory[i]['InventoryQuantity']));
    //     productType.add(inventory[i]['InventoryName']);
    //     productAmount.add(int.parse(inventory[i]['InventoryPrice']) *
    //         int.parse(inventory[i]['InventoryQuantity']));
    //   }
    // }
    //
    // //Liability
    // liability = await Liability()
    //     .select()
    //     .Date
    //     .equals(DateTimeDetails().currentDate())
    //     .toMapList();
    // if (liability.isNotEmpty) {
    //   liabilityAmount = liability[0]['Amount'];
    //   liabilityDescription = liability[0]['Description'];
    // }
    //
    // //BODA Details
    // var bodaDetails = await BodaSlip()
    //     .select()
    //     .bodaDate
    //     .equals(DateTimeDetails().currentDate())
    //     .toMapList();
    // if (bodaDetails.isNotEmpty) {
    //   cashTOAO = bodaDetails[0]['cashTo'].toString().isEmpty
    //       ? 0
    //       : int.parse(bodaDetails[0]['cashTo']);
    //   cashIndent = bodaDetails[0]['cashFrom'].toString().isEmpty
    //       ? 0
    //       : int.parse(bodaDetails[0]['cashFrom']);
    // }

  }

  String ofcID = " ";
  String ofcName = " ";
  String empID = " ";
  String empName = " ";
  Future? getUserDetails;

  @override
  void initState() {
    // TODO: implement initState

    getUserDetails = getData();
    super.initState();
  }

  getData() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    ofcID = userDetails[0].BOFacilityID.toString();
    ofcName = userDetails[0].BOName.toString();
    empID = userDetails[0].EMPID.toString();
    empName = userDetails[0].EmployeeName.toString();
    return userDetails.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.kPrimaryColor,
        actions: [
          IconButton(
            onPressed: _pdfPrinting, icon: const Icon(Icons.print)),
          IconButton(
              onPressed: _generatePDF,
              icon: const Icon(Icons.file_copy)),],
        title: Text('BODA Report'),
      ),
      body: FutureBuilder(
          future: getUserDetails,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Form(
                    key: formGlobalKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'BODA Report ($ofcName)',
                          style: TextStyle(letterSpacing: 2, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const Space(),
                        Text(
                          'User Name : $empName ( $empID )',
                          style: TextStyle(letterSpacing: 2, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const Space(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Report On',
                              style:
                                  TextStyle(fontSize: 14, letterSpacing: 2),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: 150,
                              child: YearForm(
                                  title: 'Date',
                                  selectYear: () {
                                    _selectDate(context);
                                  },
                                  controller: dateController,
                                  focusNode: dateFocus),
                            ),
                          ],
                        ),
                        const DoubleSpace(),
                        Visibility(
                            visible: bodaReport,
                            child: bodaReport==false
                            // articles.isEmpty && inventory.isEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Icon(
                                        Icons.mark_email_unread_outlined,
                                        size: 50.toDouble(),
                                        color: ColorConstants.kTextColor,
                                      ),
                                      const Text(
                                        'No Records found',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            color: ColorConstants.kTextColor),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      nextSpace('Opening Balance - ${openingBalance.toStringAsFixed(2)}'),

                                      nextSpace('RECEIPTS'),
                                      // slipTitleValue('Opening Balance Amount',
                                      //     openingBalance.toStringAsFixed(2)),
                                      const Space(),
                                      mailsAmount == 0
                                          ? Container()
                                          : ExpansionTile(
                                              title: expansionTitleValue(
                                                  'Mails Booked', mailsAmount),
                                              children: [
                                                bookedRL.isNotEmpty
                                                    ? bookedExpansionTile(
                                                        'Register Letter',
                                                        rlMailsAmount,
                                                        bookedRL,
                                                        bookedRLAmount)
                                                    : Container(),
                                                bookedSpeed.isNotEmpty
                                                    ? bookedExpansionTile(
                                                        'Speed Post',
                                                        speedMailsAmount,
                                                        bookedSpeed,
                                                        bookedSpeedAmount)
                                                    : Container(),
                                                bookedEMO.isNotEmpty
                                                    ? bookedExpansionTile(
                                                        'EMO',
                                                        emoMailsAmount,
                                                        bookedEMO,
                                                        bookedEMOAmount)
                                                    : Container(),
                                                bookedParcel.isNotEmpty
                                                    ? bookedExpansionTile(
                                                        'Parcel',
                                                        parcelMailsAmount,
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
                                      const Space(),
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
                                                  'CBS Deposit',
                                                  bankDepositAmount),
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
                                              title: expansionTitleValue(
                                                  'Insurance Deposit',
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
                                                slipTitleValue(
                                                    'IPPB Deposits Value',
                                                    ippbDepositAmount
                                                        .toString()),
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
                                      const Space(),
                                      SizedBox(
                                          width: 200, child: const Divider()),
                                      slipTitleValue('TOTAL RECEIPTS',
                                          totalReceipts.toString()),
                                      const Space(),
                                      nextSpace('PAYMENTS'),
                                      slipTitleValue(
                                          'Cash to AO', cashTOAO.toString()),
                                      const Space(),
                                      sbWithdraw.isEmpty && rdWithdraw.isEmpty
                                          ? Container()
                                          : ExpansionTile(
                                              title: expansionTitleValue(
                                                  'CBS Withdraw',
                                                  sbWithdrawAmount +
                                                      rdWithdrawAmount),
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

                                      ippbWithdrawAmount == 0
                                          ? Container()
                                          : Column(
                                              children: [
                                                slipTitleValue(
                                                    'IPPB Withdraw Value',
                                                    ippbWithdrawAmount
                                                        .toString()),
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
                                      SizedBox(
                                          width: 200, child: const Divider()),
                                      slipTitleValue('TOTAL PAYMENTS',
                                          totalPayments.toString()),
                                      nextSpace('INVENTORY'),
                                      ExpansionTile(
                                        title: expansionTitleValue(
                                            'Postage & Revenue Stamps Amount (Equivalent)',
                                            productsCount.toInt()),
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 30.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: productType
                                                        .map((e) => Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          3.0),
                                                              child: Text(
                                                                '• $e',
                                                                style:
                                                                    textStyle(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
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
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        3.0),
                                                            child: Text(
                                                              ':',
                                                              style:
                                                                  textStyle(),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: productAmount
                                                        .map((e) => Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          3.0),
                                                              child: Text(
                                                                '\u{20B9}$e',
                                                                style:
                                                                    textStyle(),
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
                                      const Space(),
                                      nextSpace('LIABILITY'),
                                      slipTitleDescription('Liability Amount',
                                          '\u{20B9} $liabilityAmount'),
                                      const Space(),
                                      slipTitleDescription(
                                          'Liability Description',
                                          liabilityDescription),
                                      nextSpace('CASH BALANCE'),
                                      slipTitleValue(
                                          'Cash & Currency Notes Amount',
                                          closingBalance.toStringAsFixed(2)),
                                    ],
                                  )),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  textStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 13,
        color: ColorConstants.kTextColor,
        fontWeight: FontWeight.w500);
  }

  titleStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        color: Colors.blueGrey,
        fontWeight: FontWeight.w500);
  }

  headingStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kSecondaryColor);
  }

  subTitleStyle() {
    return TextStyle(
        fontSize: 13,
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kTextDark);
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

  Widget slipTitleDescription(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
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

  // _pdfPrinting() async {
  //   final userDetails = await OFCMASTERDATA().select().toList();
  //   String date = DateTimeDetails().currentDate();
  //   String time = DateTimeDetails().oT();
  //
  //   basicInformation.clear();
  //
  //   basicInformation.add("Office Name");
  //   basicInformation.add(userDetails[0].BOName.toString());
  //   basicInformation.add("Office ID");
  //   basicInformation.add(userDetails[0].BOFacilityID.toString());
  //
  //   basicInformation.add("Report Date");
  //   basicInformation.add(date);
  //   basicInformation.add("Report Time");
  //   basicInformation.add(time);
  //   basicInformation.add("Opening Cash Balance:");
  //   basicInformation.add("₹$openingBalance");
  //   // basicInformation.add("Opening Inventory Bal:");
  //   // basicInformation.add("₹");
  //
  //   basicInformation.add("................................");
  //   basicInformation.add("");
  //
  //   basicInformation.add("------------RECEIPTS-----------");
  //   basicInformation.add("");
  //
  //   basicInformation.add("Cash from AO");
  //   basicInformation.add("$bagCashTotal");
  //   basicInformation.add("Mails Receipts");
  //   basicInformation.add("$mailsAmount");
  //   basicInformation.add("SB Deposit");
  //   print('BODA Printing SB Deposit' + bankDepositAmount.toString());
  //
  //   basicInformation.add("₹$bankDepositAmount");
  //   basicInformation.add("Insurance Receipts");
  //   basicInformation.add("$insuranceDepositAmount");
  //   basicInformation.add("IPPB Deposit");
  //   basicInformation.add("₹$ippbDepositAmount");
  //   basicInformation.add("Total Receipts");
  //   basicInformation.add("$totalReceipts");
  //
  //   basicInformation.add("------------PAYMENTS-----------");
  //   basicInformation.add("");
  //
  //   basicInformation.add("Cash to AO");
  //   basicInformation.add("₹$cashTOAO");
  //   basicInformation.add("Mails Payments");
  //   basicInformation.add("₹$emoPaid");
  //   basicInformation.add("SB Withdraw");
  //   basicInformation.add("₹$bankWithdrawAmount");
  //   basicInformation.add("Insurance Payments");
  //   basicInformation.add("₹$insuranceWithdrawAmount");
  //   basicInformation.add("IPPB Withdraw");
  //   basicInformation.add("₹$ippbWithdrawAmount");
  //   basicInformation.add("Total Payments");
  //   basicInformation.add("₹$totalPayments");
  //
  //   basicInformation.add("----------CASH BALANCE---------");
  //   basicInformation.add("");
  //
  //   basicInformation.add("Cash & Currency Notes");
  //   basicInformation.add("₹$closingBalance");
  //
  //   basicInformation.add("------------INVENTORY----------");
  //   basicInformation.add("");
  //
  //   if (inventory.length > 0) {
  //     for (int i = 0; i < inventory.length; i++) {
  //       basicInformation.add("${inventory[0]['Name']}");
  //       basicInformation.add("₹${inventory[0]['Value']}");
  //     }
  //   } else {
  //     basicInformation.add("NIL");
  //     basicInformation.add("₹");
  //   }
  //
  //   basicInformation.add("------------LIABILITIES---------");
  //   basicInformation.add("");
  //
  //   basicInformation.add("$liabilityDescription");
  //   basicInformation.add("");
  //   basicInformation.add("Amount:");
  //   basicInformation.add("₹$liabilityAmount");
  //
  //   basicInformation.add("-----------CASH INDENT---------");
  //   basicInformation.add("");
  //   basicInformation.add("Amount:");
  //   basicInformation.add("₹$cashIndent");
  //
  //   basicInformation.add("------------------------------");
  //   basicInformation.add("");
  //   basicInformation.add("Closing Cash Balance:");
  //   basicInformation.add("₹$closingBalance");
  //
  //   secondReceipt.clear(); //sending empty list so that it won't print
  //
  //   PrintingTelPO printer = new PrintingTelPO();
  //   await printer.printThroughUsbPrinter(
  //       "BOOKING", "Office Daily Account", basicInformation, secondReceipt, 1);
  // }
  _pdfPrinting() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    // String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();

    basicInformation.clear();

    basicInformation.add("Office Name");
    basicInformation.add(userDetails[0].BOName.toString());
    basicInformation.add("Office ID");
    basicInformation.add(userDetails[0].BOFacilityID.toString());

    basicInformation.add("Report Date");
    basicInformation.add(dateController.text);
    // basicInformation.add("Report Time");
    // basicInformation.add(time);
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
    if(rlMailsAmount>0) {
      basicInformation.add("RL Booking");
      basicInformation.add(rlMailsAmount.toDouble().toStringAsFixed(2));
    }
    if(parcelMailsAmount>0)
    {
      basicInformation.add("Parcel Booking");
      basicInformation.add(parcelMailsAmount.toDouble().toStringAsFixed(2));
    }
    if(speedMailsAmount>0) {
      basicInformation.add("SP Booking");
      basicInformation.add(speedMailsAmount.toDouble().toStringAsFixed(2));
    }
    if(emoMailsAmount>0) {
      basicInformation.add("eMO Value");
      basicInformation.add(emoMailsAmount.toDouble().toStringAsFixed(2));
      // basicInformation.add("eMO Commission");
      // basicInformation.add(emo.toDouble().toStringAsFixed(2));
    }
    if(psvalue>0)
    {
      basicInformation.add("Product Sale");
      basicInformation.add("${psvalue}");
    }

    // basicInformation.add("$totalMails");

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
      basicInformation.add("$StdioType.other Deposit");
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
    basicInformation.add("${closingBalance.toStringAsFixed(2)}");

    secondReceipt.clear(); //sending empty list so that it won't print

    PrintingTelPO printer = new PrintingTelPO();
    await printer.printThroughUsbPrinter(
        "BODA", barCode, basicInformation, secondReceipt, 1);
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

    File file = File("$path/BODA${DateTimeDetails().dateCharacter()}.pdf");
    Toast.showFloatingToast(
        'File Saved in Internal storage -> Darpan -> BODA${DateTimeDetails().dateCharacter()}.pdf',
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
        pw.Text('${ofcName}',
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
                      text: DateTimeDetails().currentDate(),
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
                      text: closingBalance.toStringAsFixed(2),
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.toDouble(),
                          fontSize: 14))
                ]),
          ),
        ),
        pw.Divider(),
        pdfSlipTitleValue('Cash Opening Balance Amount', '₹${openingBalance.toStringAsFixed(2)}'),
        pdfSlipTitleValue('TOTAL RECEIPTS', '₹${totalReceipts.toStringAsFixed(2)}'),
        if(ippbDepositAmount != 0)pdfSlipTitleValue('IPPB Deposits', '₹${ippbDepositAmount.toStringAsFixed(2)}'),
        if(cscDepositsAmount != 0)pdfSlipTitleValue('CSC Deposits', '₹${cscDepositsAmount.toStringAsFixed(2)}'),
        if(otherDepositsAmount != 0)pdfSlipTitleValue('Other Deposits', '₹${otherDepositsAmount.toStringAsFixed(2)}'),
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
        rlMailsAmount == 0 &&
            speedMailsAmount == 0 &&
            emoMailsAmount == 0 &&
            parcelMailsAmount == 0
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
        rlMailsAmount != 0
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
                        child: pw.Text('₹$rlMailsAmount',
                            style: pw.TextStyle(font: font)),
                      )
                    ]))),
          ])
        ])
            : pw.Container(),
        speedMailsAmount != 0
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
                        child: pw.Text('₹$speedMailsAmount',
                            style: pw.TextStyle(font: font)),
                      )
                    ]))),
          ])
        ])
            : pw.Container(),
        emoMailsAmount != 0
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
                        child: pw.Text('₹$emoMailsAmount',
                            style: pw.TextStyle(font: font)),
                      )
                    ]))),
          ])
        ])
            : pw.Container(),
        parcelMailsAmount != 0
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
                        child: pw.Text('₹$parcelMailsAmount',
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

}
