import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DashboardCard.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../HomeScreen.dart';
import 'BookingDBModel/BookingDBModel.dart';
import 'Services/BookingDBService.dart';

// int maxAmount = 2100;
bool booking = false;

class BookingMainScreen extends StatefulWidget {
  const BookingMainScreen({Key? key}) : super(key: key);

  @override
  _BookingMainScreenState createState() => _BookingMainScreenState();
}

class _BookingMainScreenState extends State<BookingMainScreen> {
  bool? dayBegin;
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
  List previousDayClose = [];
  var currentDate = DateTimeDetails().currentDate();
  var currentTime = DateTimeDetails().onlyTime();
  var previousDate = DateTimeDetails().previousDate();
  var previousDay = DateTimeDetails().previousDay();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  late int maxAmount;
  @override
  void initState() {
    dayDetails();
    insertFileMaster();
    super.initState();
  }

  //hardcoded values for file generation by Rohit
  insertFileMaster() async {
    final updateEndDate = await OfficeMasterPinCode().select().update({"EndDate":"31-12-9999"});

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


  }

  dayDetails() async {
    // final ofcMasterData = await OFCMASTERDATA().select().toList();
    // print('EMO Code ---');
    // for (int i =0;i<ofcMasterData.length;i++) {
    //   print(ofcMasterData[i].EMOCODE.toString());
    // }

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

    //get Maximum limit from master data.
    final ofcMaster = await OFCMASTERDATA().select().toList();
    setState(() {
      maxAmount = int.parse(ofcMaster[0].MAXBAL.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppAppBar(title: 'Booking Services'
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () => Navigator.pushAndRemoveUntil(
              //       context,
              //       MaterialPageRoute(builder: (_) => MainHomeScreen(MailsMainScreen(), 0)),
              //       (route) => false),
              // ),
              // title: const Text('Booking Services', style: TextStyle(letterSpacing: 2)),
              // backgroundColor: ColorConstants.kPrimaryColor,
              // actions: [
              //   // Padding(
              //   //   padding: EdgeInsets.only(right: 25.0.w),
              //   //   child: GestureDetector(
              //   //       onTap: () => Toast.showToast(dayBegin == true ? 'Day Begin' : 'Day End', context),
              //   //       child: dayBegin == true ? const Icon(Icons.wb_sunny_outlined) : const Icon(Icons.nightlight_outlined)),
              //   // )
              // ],
              ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              childAspectRatio: 1,
              crossAxisCount:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 2
                      : 3,
              children: [
                // DayCard(
                //     title: 'Day Begin',
                //     image: 'assets/images/day_open.png',
                //     function: () => dayDialog('Begin')),
                const DashboardCard(
                    title: 'Register Letter/\nParcel/Speed Post',
                    image: 'assets/images/regd_letter.png',
                    position: 12),
                // const DashboardCard(title: 'Speed Post', image: 'assets/images/speedpost.png', position: 13),
                const DashboardCard(
                    title: 'EMO', image: 'assets/images/emo.png', position: 14),
                // const DashboardCard(title: 'Register Parcel', image: 'assets/images/regd_parcel.png', position: 15),
                const DashboardCard(
                    title: 'Product Sale',
                    image: 'assets/images/product_sale.png',
                    position: 16),
                const DashboardCard(
                    title: 'Biller',
                    image: 'assets/images/biller.png',
                    position: 17),
                const DashboardCard(
                    title: 'Search/Cancel/\nDuplicate',
                    image: 'assets/images/search.png',
                    position: 18),
                // const DashboardCard(
                //     title: 'Special Remittance',
                //     image: 'assets/images/speedpost.png',
                //     position: 19),
                // const DashboardCard(title: 'Pay Roll', image: 'assets/images/currency.png', position: 110),
                // const DashboardCard(title: 'Leave', image: 'assets/images/leave.png', position: 111),
                // const DashboardCard(title: 'Miscellaneous Transactions', image: 'assets/images/speedpost.png', position: 112),
                const DashboardCard(
                    title: 'Reports',
                    image: 'assets/images/report.png',
                    position: 113),
                // DayCard(
                //     title: 'Day End',
                //     image: 'assets/images/day_end.png',
                //     function: () => dayDialog('End')),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          moveToPrevious(context);
          return true;
        });
  }

  void moveToPrevious(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainHomeScreen(MailsMainScreen(), 1)),
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
    previousDayClose =
        await DayModel().select().DayCloseDate.equals(previousDate).toMapList();
    final bodaDetails =
        await Liability().select().Date.equals(previousDate).toMapList();
    walletAmount = await CashService().cashBalance();

    if (type == 'Begin') {
      print('Day Begin Condition..!');
      final bobalance = await OFCMASTERDATA().select().toList();
      for (int i = 0; i < bobalance.length; i++) {
        print(bobalance[i].toString());
      }
      String cashinHand = bobalance[0].CASHINHAND!;

      print(cashinHand);

      if (dayData.isEmpty) {
        dayMessageDialog(
            'Day Begin of $currentDate happened successfully at $currentTime');

        final dayEntry = DayModel()
          ..DayBeginDate = DateTimeDetails().currentDate()
          ..DayBeginTime = DateFormat('hh:mm:ss').format(DateTime.now())
          ..CashOpeningBalance = cashinHand;
        // walletAmount.toString();
        dayEntry.save();
        final ofcMaster = await OFCMASTERDATA().select().toList();
        final dayData = DayBegin()
          ..BPMId = ofcMaster[0].EMPID
          ..DayBeginTimeStamp1 = DateTimeDetails().currentDateTime()
          ..DayBeginTimeStamp2 = DateTimeDetails().currentDateTime()
          ..FileCreated = 'N'
          ..FileTransmitted = 'N';
        dayData.save();

        ///Recording Inventory
        final inventoryAvailable = await ProductsTable().select().toMapList();
        if (inventoryAvailable.isNotEmpty) {
          for (int i = 0; i < inventoryAvailable.length; i++) {
            final addDailyInventory = InventoryDailyTable()
              ..InventoryId = inventoryAvailable[i]['ProductID']
              ..StampName = inventoryAvailable[i]['Name']
              ..Price = inventoryAvailable[i]['Price']
              ..RecordedDate = DateTimeDetails().currentDate()
              ..OpeningQuantity = inventoryAvailable[i]['Quantity']
              ..OpeningValue = inventoryAvailable[i]['Value'];
            addDailyInventory.save();
          }
        }
        setState(() {
          dayBegin = true;
        });
      } else if (previousDayClose.isEmpty && previousDayBegin.isNotEmpty) {
        dayMessageDialog('Close the Day for $previousDate');
        setState(() {
          dayBegin = false;
        });
      } else if (todayDayBegin.isNotEmpty) {
        dayMessageDialog('Day already opened for $currentDate');
        BookingDBService().updateDailyInventoryData('type', currentDate);
        setState(() {
          dayBegin = true;
        });
      } else {
        dayMessageDialog(
            'Day Begin of $currentDate happened successfully at $currentTime');
        await BookingDBService().updateDay(
            'Begin', currentDate, currentTime, walletAmount.toString()
            //
            );
        await BookingDBService().updateDailyInventoryData(type, currentDate);
        setState(() {
          dayBegin = true;
        });
      }
    } else if (type == 'End') {
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
      if (dayArticles.isNotEmpty) {
        Toast.showFloatingToast('Please take Returns before Day End', context);
      } else {
        if (dayData.isEmpty) {
          dayMessageDialog('Do Day Begin for $currentDate');
          setState(() {
            dayBegin = false;
          });
        } else if (previousDayClose.isEmpty && previousDayBegin.isNotEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('Do you wish to do Day End?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("CANCEL")),
                    TextButton(
                        onPressed: () async {
                          dayMessageDialog(
                              'Day End of $previousDate happened successfully at $currentTime');
                          await BookingDBService().updateDay(
                              'End',
                              previousDate,
                              currentDate + currentTime,
                              walletAmount.toString());
                          await BookingDBService()
                              .updateDailyInventoryData(type, currentDate);
                          setState(() {
                            dayBegin = false;
                          });
                        },
                        child: Text("OKAY")),
                  ],
                );
              });
        } else if (todayDayBegin.isEmpty) {
          dayMessageDialog('Do Day Begin for $currentDate');
        } else if (todayDayEnd.isNotEmpty) {
          dayMessageDialog('Day End already done for $currentDate');
        } else {
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
            ..CashOpeningBalance = dayDetail[0]['CashOpeningBalance']
            ..CashClosingBalance = walletAmount.toString()
            ..DayCloseDate = DateTimeDetails().currentDate()
            ..DayCloseTime = DateTimeDetails().onlyTime();
          updateDayEnd.upsert();
          final day = await DayModel().select().toMapList();
          print("Day details $day");
          await BookingDBService().updateDailyInventoryData(type, currentDate);
          setState(() {
            dayBegin = false;
          });
        }
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
                      buttonFunction: () => Navigator.pop(context))
                ],
              ),
            ),
          );
        });
  }

  nonDeliveredDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Note'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionTile(
                    title: const Text('Articles Pending',
                        style: TextStyle(letterSpacing: 1)),
                    children: [
                      Visibility(
                        visible: registerNonDeliveryArticles.isNotEmpty,
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('Register Letter',
                                  style: TextStyle(letterSpacing: 1)),
                              Text(
                                  registerNonDeliveryArticles.length.toString())
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: registerNonDeliveryArticles
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(e),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: speedPostNonDeliveryArticles.isNotEmpty,
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('Speed Post',
                                  style: TextStyle(letterSpacing: 1)),
                              Text(speedPostNonDeliveryArticles.length
                                  .toString())
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: speedPostNonDeliveryArticles
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(e),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: parcelNonDeliveryArticles.isNotEmpty,
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('Parcel',
                                  style: TextStyle(letterSpacing: 1)),
                              Text(parcelNonDeliveryArticles.length.toString())
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: parcelNonDeliveryArticles
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(e),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: emoNonDeliveryArticles.isNotEmpty,
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text('EMO',
                                  style: TextStyle(letterSpacing: 1)),
                              Text(emoNonDeliveryArticles.length.toString())
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: emoNonDeliveryArticles
                                  .map((e) => Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Text(e),
                                      ))
                                  .toList(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('Total', style: TextStyle(letterSpacing: 2)),
                    trailing: Text(nonDeliveryArticles.length.toString()),
                  )
                ],
              ),
            ),
            actions: [
              Button(
                  buttonText: 'OKAY',
                  buttonFunction: () => Navigator.pop(context))
            ],
          );
        });
  }
}
