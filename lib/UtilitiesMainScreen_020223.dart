import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/CBS/leave.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../HomeScreen.dart';
import 'CBS/IPPB daily report.dart';
import 'CBS/db/cbsdb.dart';
import 'DatabaseModel/INSTransactions.dart';
import 'DatabaseModel/ReportsModel.dart';
import 'DatabaseModel/transtable.dart';
import 'INSURANCE/Utils/DateTimeDetails.dart';
import 'INSURANCE/Widget/Loader.dart';
import 'Leave/LeaveManagement.dart';
import 'LogCat.dart';
import 'Mails/Bagging/Model/BagModel.dart';
import 'Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'Mails/Booking/BookingMainScreen.dart';
import 'Mails/Booking/Services/BookingDBService.dart';
import 'Mails/Booking/SpecialRemittance/SpecialRemittanceMainScreen.dart';
import 'Mails/LoginAccessTokenScreen.dart';
import 'Mails/MailsMainScreen.dart';
import 'Mails/Wallet/Cash/CashService.dart';
import 'Mails/backgroundoperations.dart';
import 'Utils/CustomDrawer.dart';
import 'Widgets/Button.dart';
import 'Widgets/DashboardCard.dart';
import 'Widgets/UITools.dart';

class UtilitiesMainScreen extends StatefulWidget {
  @override
  State<UtilitiesMainScreen> createState() => _UtilitiesMainScreen();
}

class _UtilitiesMainScreen extends State<UtilitiesMainScreen> {
  bool _isNewLoading = false;
  bool? dayBegin;
  bool _isbuttondisabled=false;
  var walletAmount;
  List nonDeliveryArticles = [];
  List<String> registerNonDeliveryArticles = [];
  List<String> speedPostNonDeliveryArticles = [];
  List<String> parcelNonDeliveryArticles = [];
  List<String> emoNonDeliveryArticles = [];
  List dayData = [];
  List dayDetail = [];
  List todayDayBegin = [];
  List todayDayEnd = [];
  List previousDayBegin = [];
  List lastCashBalance = [];
  List previousDayClose = [];
  var currentDate = DateTimeDetails().currentDate();
  var currentTime = DateTimeDetails().onlyTime();
  var previousDate = DateTimeDetails().previousDate();
  var previousCloseDate;
  var previousDay = DateTimeDetails().previousDay();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  bool visiblty = false;

  @override
  void initState() {
    dayDetails();
    // checkAccess();

    super.initState();
  }

  // checkAccess(){
  //   if(alertDialogContext!=null)
  //   Navigator.pop(navigatorKey.currentContext!);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Stack(children: <Widget>[
        Scaffold(
          // appBar: AppBar(title: const Text('Darpan-Mails ', textAlign: TextAlign.center,style: TextStyle(fontSize: 22,),),backgroundColor: Color(0xFFB71C1C),
          //   shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(
          //       bottom: Radius.circular(20) )),
          // ),
          appBar: AppAppBar(title: "Utilities"),
          drawer: CustomDrawer(),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Container(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height - 170
                          : MediaQuery.of(context).size.height - 125,
                  decoration: const BoxDecoration(
                    //color:
                    //Colors.white,
                    //Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      topRight: Radius.circular(2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            MediaQuery.of(context).size.height > 900 ? 14 : 14),
                    child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(75),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: GridView.count(
                            childAspectRatio: 1,
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? 2
                                    : 3,
                            children: <Widget>[
                              // MyMenu(
                              //   title: "Operations",
                              //   img: "assets/images/book.png",
                              //   pos: 0,
                              //   bgcolor: Colors.grey[300]!,
                              // ),

                              DayCard(
                                  title: 'Day Begin',
                                  image: 'assets/images/day_open.png',
                                  function: () => dayDialog('Begin')),
                              // MyMenu(
                              //   title: "Leave",
                              //   img: "assets/images/ic_monthly.png",
                              //   pos: 2,
                              //   bgcolor: Colors.grey[300]!,
                              // ),
                              MyMenu(
                                  title: 'Special Remittance',
                                  img: 'assets/images/speedpost.png',
                                  pos: 19),
                              DashboardCard(
                                  title: 'Generate\nBODA',
                                  image: 'assets/images/reports.png',
                                  position: 95),

                              DashboardCard(
                                  title: 'BODA \nReports',
                                  image: 'assets/images/ic_dat.png',
                                  position: 98),

                              MyMenu(
                                title: "IPPB",
                                img: "assets/images/ic_dat.png",
                                pos: 3,
                                bgcolor: Colors.grey[300]!,
                              ),
                              DayCard(
                                  title: 'Day End',
                                  image: 'assets/images/day_end.png',
                                  function: () => dayDialog('End')),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        visiblty == true
            ? Center(
                child: Loader(
                    isCustom: true, loadingTxt: 'Please Wait...Loading..!'))
            : const SizedBox.shrink()
      ]),
    );
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
        (route) => false);
  }

  void dayDialog(String type) async {
    dayData = await DayModel().select().toMapList();
    todayDayBegin =
        await DayModel().select().DayBeginDate.equals(currentDate).toMapList();
    todayDayEnd =
        await DayModel().select().DayCloseDate.equals(currentDate).toMapList();
    previousDayBegin =
        await DayModel().select().DayBeginDate.equals(previousDate).toMapList();
    String lastClosingBalance = "0";
    print("Last Day End Fetching..!");
    var test =
        '''select MAX(substr(DayCloseDate,7,4)|| '-'||substr(DayCloseDate,4,2)||'-' ||substr(DayCloseDate,1,2)) as LastClosedDate from DayModel''';
    final lastDayClose = await BookingModel().execDataTable(test);
    print(lastDayClose.toString());
    print(lastDayClose.length.toString());
    print(lastDayClose[0]["LastClosedDate"]);

    if (lastDayClose.length > 0 && lastDayClose[0]["LastClosedDate"] != null) {
      print(lastDayClose[0]["LastClosedDate"].toString());
      lastCashBalance = await DayModel()
          .select()
          .DayBeginDate
          .equals(lastDayClose[0]["LastClosedDate"]
              .toString()
              .split('-')
              .reversed
              .join('-'))
          .toMapList();
      //print(lastCashBalance[0]["CashClosingBalance"].toString());

      if (lastCashBalance[0]["CashClosingBalance"].toString() != null) {
        lastClosingBalance =
            lastCashBalance[0]["CashClosingBalance"].toString();
      }
    }

    // Map deldata = lastDayClose.asMap();
    //  print(lastDayClose.toString());

    // var testksjd=await DayModel().select(columnsToSelect: [DayModelFields.DayCloseDate.max("DayCloseDate")]).toList();
    // print("Max Date is: ${testksjd[0].DayCloseDate}");
    previousDayClose =
        await DayModel().select().DayCloseDate.equals(previousDate).toMapList();
    print('Printing Previous Day..!');
    print(previousDayClose);
    print(previousDayClose[0]["DayCloseDate"]);

    final bodaDetails =
        await Liability().select().Date.equals(previousDate).toMapList();

    if (type == 'Begin') {
      // setState(() {
      //   visiblty =true;
      // });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context,setState) {
                return Stack(
                  children: [
                    AlertDialog(
                      content: Text('Do you wish to do Day Begin?'),
                      actions: [
                        _isbuttondisabled==false?  TextButton(
                            onPressed: () => Navigator.pop(context), child: Text("No")):TextButton(child: Text("No"), onPressed: (){},),
                        _isbuttondisabled==false?
                        TextButton(

                            onPressed: () async {
                              setState(() {
                                _isbuttondisabled=true;
                                _isNewLoading =true;
                              });
                              final ofcMaster = await OFCMASTERDATA().select().toList();
                              print('Day Begin Condition..!');
                              final bobalance = await OFCMASTERDATA().select().toList();
                              for (int i = 0; i < bobalance.length; i++) {
                                print(bobalance[i].toString());
                              }
                              String cashinHand = bobalance[0].CASHINHAND!;

                              print(cashinHand);

                              if (dayData.isEmpty) {
                                print("Day Begin for the first time..!");
                                print("Office Rolled Out..!");
                                dayMessageDialog(
                                    'Day Begin of $currentDate happened successfully at $currentTime');

                                final dayEntry = DayModel()
                                  ..DayBeginDate = DateTimeDetails().currentDate()
                                  ..DayBeginTime =
                                      DateFormat('hh:mm:ss').format(DateTime.now())
                                  ..CashOpeningBalance = cashinHand;
                                // walletAmount.toString();
                                await dayEntry.save();

                                final dayData = DayBegin()
                                  ..BPMId = ofcMaster[0].EMPID
                                  ..DayBeginTimeStamp1 =
                                      DateTimeDetails().currentDateTime()
                                  ..DayBeginTimeStamp2 =
                                      DateTimeDetails().currentDateTime()
                                  ..FileCreated = 'N'
                                  ..FileTransmitted = 'N';
                                await dayData.save();

                                ///Recording Inventory
                                final inventoryAvailable =
                                    await ProductsTable().select().toMapList();
                                if (inventoryAvailable.isNotEmpty) {
                                  for (int i = 0; i < inventoryAvailable.length; i++) {
                                    final addDailyInventory = InventoryDailyTable()
                                      ..InventoryId = inventoryAvailable[i]['ProductID']
                                      ..StampName = inventoryAvailable[i]['Name']
                                      ..Price = inventoryAvailable[i]['Price']
                                      ..RecordedDate = DateTimeDetails().currentDate()
                                      ..OpeningQuantity =
                                          inventoryAvailable[i]['Quantity']
                                      ..OpeningValue = inventoryAvailable[i]['Value'];
                                    addDailyInventory.save();
                                  }
                                }
                                setState(() {
                                  dayBegin = true;
                                });
                              }
                              else if (previousDayClose.isEmpty &&
                                  previousDayBegin.isNotEmpty) {
                                dayMessageDialog('Close the Day for $previousDate');
                                setState(() {
                                  dayBegin = false;
                                });
                              }
                               else if (todayDayBegin.isNotEmpty) {
                                dayMessageDialog('Day already opened for $currentDate');
                                await BookingDBService()
                                    .updateDailyInventoryData('type', currentDate);
                                setState(() {
                                  dayBegin = true;
                                });
                              }
                               else {
                                print("Day Begin for $currentDate");
                                print(double.parse(lastClosingBalance)
                                    .toStringAsFixed(2));
                                await BookingDBService().updateDay(
                                    'Begin',
                                    currentDate,
                                    currentTime,
                                    double.parse(lastClosingBalance).toStringAsFixed(2)
                                    //walletAmount.toString()
                                    //
                                    );

                                //added DayBegin Table by Rohit on 30122022
                                final dayData = DayBegin()
                                  ..BPMId = ofcMaster[0].EMPID
                                  ..DayBeginTimeStamp1 =
                                      DateTimeDetails().currentDateTime()
                                  ..DayBeginTimeStamp2 =
                                      DateTimeDetails().currentDateTime()
                                  ..FileCreated = 'N'
                                  ..FileTransmitted = 'N';
                                await dayData.save();

                                //insert previous date CB into Wallet and clear all information from CashTable & Transaction Table.

                                //before deletion insert into Backup Table available in Report DB.
                                final fetchCashTable =
                                    await CashTable().select().toList();
                                if (fetchCashTable.length > 0) {
                                  for (int i = 0; i < fetchCashTable.length; i++) {
                                    final a = await CashTableBackup()
                                      ..Sl = fetchCashTable[i].Sl
                                      ..Cash_ID = fetchCashTable[i].Cash_ID
                                      ..Cash_Amount = fetchCashTable[i].Cash_Amount
                                      ..Cash_Date = fetchCashTable[i].Cash_Date
                                      ..Cash_Time = fetchCashTable[i].Cash_Time
                                      ..Cash_Description =
                                          fetchCashTable[i].Cash_Description
                                      ..Cash_Type = fetchCashTable[i].Cash_Type;
                                    await a.save();
                                  }
                                }

                                final fetchTransTable =
                                    await TransactionTable().select().toList();

                                if (fetchTransTable.length > 0) {
                                  for (int i = 0; i < fetchTransTable.length; i++) {
                                    final b = await TransactionTableBackup()
                                      ..Sl = fetchTransTable[i].Sl
                                      ..tranid = fetchTransTable[i].tranid
                                      ..tranType = fetchTransTable[i].tranType
                                      ..tranDescription =
                                          fetchTransTable[i].tranDescription
                                      ..tranDate = fetchTransTable[i].tranDate
                                      ..tranTime = fetchTransTable[i].tranTime
                                      ..tranAmount = fetchTransTable[i].tranAmount
                                      ..valuation = fetchTransTable[i].valuation;
                                    await b.save();
                                  }
                                }

                                //delete all information from CashTable which is not performed today.
                                final deleteCash = await CashTable()
                                    .select()
                                    .Cash_Date
                                    .not
                                    .equals(DateTimeDetails().currentDate())
                                    .delete();
                                await LogCat().writeContent(deleteCash.toString());
                                //delete all information from CashTable which is not performed today.
                                final deleteTrans = await TransactionTable()
                                    .select()
                                    .tranDate
                                    .not
                                    .equals(DateTimeDetails().currentDate())
                                    .delete();
                                await LogCat().writeContent(deleteTrans.toString());

                                //check Cash table should be empty before inserting.
                                int cashCount = await CashTable().select().toCount();
                                if (cashCount == 0) {
                                  final addCash =  CashTable()
                                    ..Cash_ID =
                                        'OB_${DateTimeDetails().dateCharacter()}'
                                    ..Cash_Date = DateTimeDetails().currentDate()
                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                    ..Cash_Type = 'Add'
                                    ..Cash_Amount = double.parse(
                                        double.parse(lastClosingBalance)
                                            .toStringAsFixed(2))
                                    ..Cash_Description = "Previous Day CB";
                                  await addCash.save();
                                  await LogCat().writeContent(
                                      'Rs.${double.parse(lastClosingBalance).toStringAsFixed(2)} added as OB in Cash.');
                                } else {
                                  await LogCat().writeContent(
                                      'Cash Table already having $cashCount records.');
                                }

                                int transCount =
                                    await TransactionTable().select().toCount();
                                if (transCount == 0) {
                                  final addTransaction = TransactionTable()
                                    ..tranid = 'OB_${DateTimeDetails().dateCharacter()}'
                                    ..tranDescription = "Previous Day CB"
                                    ..tranAmount = double.parse(
                                        double.parse(lastClosingBalance)
                                            .toStringAsFixed(2))
                                    ..tranType = "OB"
                                    ..tranDate = DateTimeDetails().currentDate()
                                    ..tranTime = DateTimeDetails().onlyTime()
                                    ..valuation = "Add";
                                  await addTransaction.save();
                                  await LogCat().writeContent(
                                      'Rs.${double.parse(lastClosingBalance).toStringAsFixed(2)} added as OB in Transaction.');
                                } else {
                                  await LogCat().writeContent(
                                      'Transaction Table already having $transCount records.');
                                }

                                await BookingDBService()
                                    .updateDailyInventoryData(type, currentDate);

                                await LogCat().writeContent('Day Begin Successful.');

                                // //check if Cash and Transaction table inserted multiple times.
                                // final cashDuplicate=await CashTable().select().Cash_ID.equals('OB_${DateTimeDetails().dateCharacter()}').toCount();

                                dayMessageDialog(
                                    'Day Begin of $currentDate happened successfully at $currentTime');

                                setState(() {
                                  dayBegin = true;
                                });
                              }
                              setState(() {
                                _isNewLoading = false;
                              });
                            },
                            child: Text("Yes")):
                        TextButton(child: Text("Yes"), onPressed: (){},)
                      ],
                    ),
                    _isNewLoading == true
                        ? Loader(
                        isCustom: true,
                        loadingTxt:
                        'Please Wait...Loading...')
                        : Container()
                  ],
                );
              }
            );
          });
    } else if (type == 'End') {
      walletAmount = await CashService().cashBalance();

      final dayArticles = await Delivery()
          .select()
          .startBlock
          .invoiceDate
          .equals(DateTimeDetails().currentDate())
          .and
          .ART_STATUS
          .isNull()
          .endBlock
          .toMapList();

      final cbstrans =
          await TBCBS_TRAN_DETAILS().select().STATUS.equals("PENDING").toList();
      final instrans = await DAY_TRANSACTION_REPORT()
          .select()
          .STATUS
          .equals("PENDING")
          .toList();

      if (cbstrans.length > 0) {
        Toast.showFloatingToast(
            "Please Clear the transactions of CBS which are in pending state",
            context);
      } else if (instrans.length > 0) {
        Toast.showFloatingToast(
            "Please Clear the transactions of Insurance which are in pending state",
            context);
      } else if (dayArticles.isNotEmpty) {
        Toast.showFloatingToast('Please take Returns before Day End', context);
      } else {
        if (dayData.isEmpty) {
          dayMessageDialog('Do Day Begin for $currentDate');
          setState(() {
            dayBegin = false;
          });
        } else if (previousDayClose.isEmpty && previousDayBegin.isNotEmpty) {
          print('Condition ---1');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                      'Do you wish to do \nDAY END for date: $previousDate'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No")),
                    TextButton(
                        onPressed: () async {
                          dayMessageDialog(
                              'Day End of $previousDate happened successfully at $currentTime');
                          await BookingDBService().updateDay(
                              'End',
                              previousDate,
                              currentDate + currentTime,
                              double.parse(walletAmount.toString())
                                  .toStringAsFixed(2));
                          await BookingDBService()
                              .updateDailyInventoryData(type, currentDate);
                          setState(() {
                            dayBegin = false;
                          });
                        },
                        child: Text("Yes")),
                  ],
                );
              });
        } else if (todayDayBegin.isEmpty) {
          dayMessageDialog('Do Day Begin for $currentDate');
        } else if (todayDayEnd.isNotEmpty) {
          dayMessageDialog('Day End already done for $currentDate');
        } else {
          print('Condition ---2');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('Do you wish to do Day End?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No")),
                    TextButton(
                        onPressed: () async {
                          dayMessageDialog(
                              'Day End of $currentDate happened successfully at $currentTime');
                          final dayDetail = await DayModel()
                              .select()
                              .DayBeginDate
                              .equals(DateTimeDetails().currentDate())
                              .toMapList();
                          final updateDayEnd = DayModel()
                            ..DayBeginDate = dayDetail[0]['DayBeginDate']
                            ..DayBeginTime = dayDetail[0]['DayBeginTime']
                            ..CashOpeningBalance =
                                dayDetail[0]['CashOpeningBalance']
                            ..CashClosingBalance =
                                double.parse(walletAmount.toString())
                                    .toStringAsFixed(2)
                            ..DayCloseDate = DateTimeDetails().currentDate()
                            ..DayCloseTime = DateTimeDetails().onlyTime();
                          updateDayEnd.upsert();
                          final day = await DayModel().select().toMapList();
                          print("Day details $day");
                          await BookingDBService()
                              .updateDailyInventoryData(type, currentDate);
                          setState(() {
                            dayBegin = false;
                          });
                        },
                        child: Text("Yes")),
                  ],
                );
              });
        }
      }
    }
  }

  dayDetails() async {
    dayDetail = await DayModel()
        .select()
        .startBlock
        .DayBeginDate
        .equals(DateTimeDetails().currentDate())
        .and
        .DayCloseDate
        .equals(DateTimeDetails().currentDate())
        .endBlock
        .toMapList();
    nonDeliveryArticles =
        await Delivery().select().ART_STATUS.equalsOrNull('').toMapList();
    for (int i = 0; i < nonDeliveryArticles.length; i++) {
      if (nonDeliveryArticles[i]['matnr'] == 'Registered Letter' ||
          nonDeliveryArticles[i]['matnr'] == 'LETTER') {
        registerNonDeliveryArticles
            .add(nonDeliveryArticles[i]['articleNumber']);
      } else if (nonDeliveryArticles[i]['matnr'] == 'Speed Post' ||
          nonDeliveryArticles[i]['matnr'] == 'SP_INLAND') {
        speedPostNonDeliveryArticles
            .add(nonDeliveryArticles[i]['articleNumber']);
      } else if (nonDeliveryArticles[i]['matnr'] == 'Parcel' ||
          nonDeliveryArticles[i]['matnr'] == 'PARCEL') {
        parcelNonDeliveryArticles.add(nonDeliveryArticles[i]['articleNumber']);
      } else if (nonDeliveryArticles[i]['matnr'] == 'EMO' ||
          nonDeliveryArticles[i]['matnr'] == 'INTL_MO_IN' ||
          nonDeliveryArticles[i]['matnr'] == 'SMO' ||
          nonDeliveryArticles[i]['matnr'] == 'EMON') {
        emoNonDeliveryArticles.add(nonDeliveryArticles[i]['articleNumber']);
      }
    }
  }

  dayMessageDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(text),
                  ),
                  Button(
                      buttonText: 'OKAY',
                      buttonFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MainHomeScreen(UtilitiesMainScreen(), 0)),
                        );
                      }
                      // buttonFunction: () => Navigator.pop(context))
                      ),
                ],
              ),
            ),
          );
        });
  }
}

class MyMenu extends StatelessWidget {
  MyMenu({this.title, this.img, this.pos, this.bgcolor});

  final String? title;
  final Color? bgcolor;
  int? scannerValue = 4;
  final int? pos;
  final String? img;
  static const _kFontFam = 'MyHomePage';
  static const _kFontPkg = null;
  static const IconData ic_article_tracking =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: Colors.white,
          // Colors.grey[300],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Container(
            child: Ink(
              //color:Colors.red,
              child: InkWell(
                //splashColor: Colors.red,
                onTap: () async {
                  var currentDate = DateTimeDetails().currentDate();
                  final dayDetails = await DayModel()
                      .select()
                      .DayBeginDate
                      .equals(currentDate)
                      .toList();
                  if (dayDetails.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Note'),
                            content: const Text('Do Day Begin to continue!'),
                            actions: [
                              Button(
                                  buttonText: 'OKAY',
                                  buttonFunction: () => Navigator.pop(context))
                            ],
                          );
                        });
                  } else {
                    if (pos.toString() == '1') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingMainScreen()),
                      );
                    }
                    if (pos.toString() == '2') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => leaveManagement()),
                      );
                    } else if (pos.toString() == '3') {
                      final bodaDetails = await BodaBrief()
                          .select()
                          .BodaGeneratedDate
                          .equals(DateTimeDetails().currentDate())
                          .toCount();
                      if (bodaDetails > 0) {
                        UtilFs.showToast(
                            "BODA is already generated for the day..!",
                            context);
                      } else if (bodaDetails == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IPPB()),
                        );
                      }
                    }
                    if (pos.toString() == '4') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginAccessTokenScreen()),
                      );
                    }
                    if (pos.toString() == '5') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => leaveScreen()),
                      );
                    }
                    if (pos.toString() == '99') {
                      await dataSync.download();
                      // PrintingTelPO printer = new PrintingTelPO();
                      // await printer.printImage();
                    }
                    if (pos.toString() == '19') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const SpecialRemittanceMainScreen()));
                    }
                    if (pos.toString() == 'theame') {
                      print('Set Light Theme');
                    }
                  }
                },

                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(img!, width: 70, color: Color(0xFFB71C1C)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF984600),
                            //  color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                //),
              ),
            ),
          ),
        ),
      ),
    );
    //)
    //);
  }
}
