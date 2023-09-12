import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagClose/BagCloseScreen.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagDispatchScreen.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagOpenScreen.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagReceiveScreen.dart';
import 'package:darpan_mine/Mails/Booking/Biller/BillerMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/CancelBooked/CancelBookedScreen.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Screens/EMOMainUpdatedScreen.dart';
import 'package:darpan_mine/Mails/Booking/Leave/LeaveMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Miscellaneous/MiscellaneousMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Parcel/Screens/ParcelBookingScreen.dart';
import 'package:darpan_mine/Mails/Booking/PayRoll/PayRollScreen.dart';
import 'package:darpan_mine/Mails/Booking/ProductSaleScreen/ProductSaleScreen.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Screens/MailsBookingScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/BODAReports/BODAReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/CancelledReports/CancelledReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/CashBalanceReports/CashBalanceReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/CashCardReports/CashCardReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/DigitalReports/DigitalReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/GenerateBODA/BODASlipScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/GenerateBODA/GenerateBODAReportScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/InventoryReports/InventoryReportScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/MailTransactionsReport/MailsTransactionReportScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/ReportsMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Reports/TransactionReports/TransactionReportsScreen.dart';
import 'package:darpan_mine/Mails/Booking/SpecialRemittance/SpecialRemittanceMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/SpeedPost/Screens/SpeedPostScreen.dart';
import 'package:darpan_mine/Mails/Delivery/DeliveryMainScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String image;
  final int position;

  const DashboardCard(
      {Key? key,
      required this.title,
      required this.image,
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Ink(
            child: InkWell(
              onTap: () async {
                var currentDate = DateTimeDetails().currentDate();
                var previousDate = DateTimeDetails().previousDate();
                final day = await DayModel().select().toMapList();
                final dayDetails = await DayModel()
                    .select()
                    .DayBeginDate
                    .equals(currentDate)
                    .toList();
                final dayAlreadyDone = await DayModel()
                    .select()
                    .DayBeginDate
                    .equals(currentDate)
                    .and
                    .DayCloseDate
                    .equals(currentDate)
                    .toMapList();
                if (dayDetails.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Note'),
                          content: const Text('Do Day begin to continue'),
                          actions: [
                            Button(
                                buttonText: 'OKAY',
                                buttonFunction: () => Navigator.pop(context))
                          ],
                        );
                      });
                }
                else if (dayAlreadyDone.isNotEmpty) {
                  ///Only to Reports if day end has happened
                  if (position == 113) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ReportsMainScreen()));
                  }
                  if (position == 91) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CancelledReportsScreen()));
                  } else if (position == 92) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TransactionReportsScreen()));
                  } else if (position == 93) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InventoryScreen()));
                  } else if (position == 94) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CashCardReportsScreen()));
                  } else if (position == 95) {
                    print('Dashboard - 123 Line');
                    final dayDetails = await DayModel()
                        .select()
                        .DayBeginDate
                        .equals(DateTimeDetails().currentDate())
                        .toMapList();

                    final ippbCheck = await IPPBCBS_DETAILS()
                        .select()
                        .TRANSACTION_DATE.equals(DateTimeDetails().currentDate()).toCount();

                    //Day End Checking..!
                    if (dayDetails[0]['DayCloseDate'].toString() == 'null' ||
                        dayDetails[0]['DayCloseDate'].toString().isEmpty) {
                      Toast.showFloatingToast(
                          'Do Day End of ${dayDetails[0]['DayBeginDate']}',
                          context);
                    }
                    //IPPB Transaction check before BODA Generation
                    else if (ippbCheck==0){
                      UtilFs.showToast("Please enter IPPB Transaction..!", context);
                    }
                    else {
                      // final bagDetails = await BagCloseTable().select().ClosedDate.equals(DateTimeDetails().currentDate()).toMapList();
                      // final bagDetails = await BagCloseTable().select().ClosedDate.equals(DateTimeDetails().previousDate()).toMapList();

                      final bodaDetails = await BodaBrief()
                          .select()
                          .BodaGeneratedDate
                          .equals(DateTimeDetails().currentDate())
                          .toMapList();
                      //when BODA is not Generated
                      if (bodaDetails.isEmpty) {
                        print('Dashboard - 117 Line');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const GenerateBODAReportScreen()));
                      }
                      //when BODA is already Generated
                      else {
                        print('Dashboard - 123 Line');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const BODASlipScreen()));
                      }
                    }
                  } else if (position == 96) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CashBalanceReportsScreen()));
                  } else if (position == 97) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const MailsTransactionReportScreen()));
                  } else if (position == 98) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BODAReportScreen()));
                  } else if (position == 99) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DigitalReportsScreen()));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Note'),
                            content: const Text('Day end has happened'),
                            actions: [
                              Button(
                                  buttonText: 'OKAY',
                                  buttonFunction: () => Navigator.pop(context))
                            ],
                          );
                        });
                  }
                }
                else {
                  if (dayDetails[0].DayBeginDate!.isEmpty) {
                    final previousDayDetails = await DayModel()
                        .select()
                        .DayCloseDate
                        .equals(previousDate)
                        .toList();
                    if (previousDayDetails.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Note'),
                              content: Text(
                                  'Please do the day end of date $previousDate to continue'),
                              actions: [
                                Button(
                                    buttonText: 'OKAY',
                                    buttonFunction: () =>
                                        Navigator.pop(context))
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Note'),
                              content: Text(
                                  'Please do the day begin of date $previousDate to continue'),
                              actions: [
                                Button(
                                    buttonText: 'OKAY',
                                    buttonFunction: () =>
                                        Navigator.pop(context))
                              ],
                            );
                          });
                    }
                  }
                  else {
                    if (position == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BookingMainScreen()));
                    } else if (position == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DeliveryMainScreen()));
                    } else if (position == 12) {
                      showLoaderDialog(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Dummy()
                              // RegisterLetterBookingScreen1(fees: fees)
                              ));
                    } else if (position == 13) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SpeedPostScreen()));
                    } else if (position == 14) {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => const EMOMainScreen()));
                      Navigator.push(
                          // context, MaterialPageRoute(builder: (_) => const EMOInitial()));
                          context,
                          MaterialPageRoute(
                              builder: (_) => EMOMainUpdatedScreen(
                                    sName: '',
                                    sAddress: '',
                                    sPinCode: '',
                                    sCity: '',
                                    sState: '',
                                    sMobile: '',
                                    sEmail: '',
                                    aName: '',
                                    aAddress: '',
                                    aPinCode: '',
                                    aCity: '',
                                    aState: '',
                                    aMobile: '',
                                    aEmail: '',
                                    isVPP: false,
                                    amount: "",
                                    artnumber: "",
                                  )));
                    } else if (position == 15) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ParcelBookingScreen()));
                    } else if (position == 16) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProductSaleScreen()));
                    } else if (position == 17) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BillerMainScreen()));
                    } else if (position == 18) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CancelBookedScreen()));
                    } else if (position == 19) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const SpecialRemittanceMainScreen()));
                    } else if (position == 110) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PayRollScreen()));
                    } else if (position == 111) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LeaveMainScreen()));
                    } else if (position == 112) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MiscellaneousMainScreen()));
                    } else if (position == 113) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ReportsMainScreen()));
                    } else if (position == 91) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CancelledReportsScreen()));
                    } else if (position == 92) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const TransactionReportsScreen()));
                    } else if (position == 93) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const InventoryScreen()));
                    } else if (position == 94) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CashCardReportsScreen()));
                    } else if (position == 95) {
                      print('Dashboard - 248 Line');
                      final dayDetails = await DayModel()
                          .select()
                          .DayBeginDate
                          .equals(DateTimeDetails().currentDate())
                          .toMapList();
                      //Day End Checking..!
                      if (dayDetails[0]['DayCloseDate'].toString() == 'null' ||
                          dayDetails[0]['DayCloseDate'].toString().isEmpty) {
                        Toast.showFloatingToast(
                            'Do Day End of ${dayDetails[0]['DayBeginDate']}',
                            context);
                      } else {
                        // final bagDetails = await BagCloseTable().select().ClosedDate.equals(DateTimeDetails().currentDate()).toMapList();
                        // final bagDetails = await BagCloseTable().select().ClosedDate.equals(DateTimeDetails().previousDate()).toMapList();

                        final bodaDetails = await BodaBrief()
                            .select()
                            .BodaGeneratedDate
                            .equals(DateTimeDetails().currentDate())
                            .toMapList();
                        //when BODA is not Generated
                        if (bodaDetails.isEmpty) {
                          print('Dashboard - 262 Line');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const GenerateBODAReportScreen()));
                        }
                        //when BODA is already Generated
                        else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const BODASlipScreen()));
                        }
                      }
                    } else if (position == 96) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CashBalanceReportsScreen()));
                    } else if (position == 97) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const MailsTransactionReportScreen()));
                    } else if (position == 98) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BODAReportScreen()));
                    } else if (position == 99) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DigitalReportsScreen()));
                    } else if (position == 31) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BagReceiveScreen()));
                    } else if (position == 32) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BagOpenScreen()));
                    } else if (position == 34) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => BagCloseScreen()));
                    } else if (position == 35) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BagDispatchScreen()));
                    }
                  }
                }
                /*------------------------------Home Page-----------------------------*/

                // else if (position == 36) Navigator.push(context, MaterialPageRoute(builder: (_) => BagInfoScreen()));
                // else if (position == 37) Navigator.push(context, MaterialPageRoute(builder: (_) => BagTrackingScreen()));
                /*--------------------------------------------------------------------*/

                // var currentDate = DateTimeDetails().onlyDate();
                // var previousDate = DateTimeDetails().previousDate();
                // final day = await DayModel().select().toMapList();
                // final dayDetails = await DayModel().select().DayBeginDate.equals(currentDate).toList();
                // final dayAlreadyDone = await DayModel().select()
                //     .startBlock.DayBeginDate.equals(currentDate)
                //     .and.DayCloseDate.equals(currentDate).endBlock.toMapList();
                // if (dayDetails.isEmpty) {
                //   showDialog(context: context, builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: const Text('Note'),
                //       content: const Text('Do Day begin to continue'),
                //       actions: [
                //         Button(buttonText: 'OKAY', buttonFunction: () => Navigator.pop(context))
                //       ],
                //     );
                //   });
                // } else if (dayAlreadyDone.isNotEmpty) {
                //   if (position == 113) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsMainScreen()));
                //   } if (position == 91) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelledReportsScreen()));
                //   } else if (position == 92) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionReportsScreen()));
                //   } else if (position == 93) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen()));
                //   } else if (position == 94) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const CashCardReportsScreen()));
                //   } else if (position == 95) {
                //     final bodaDetails = await Liability().select().Date.equals(DateTimeDetails().onlyDate()).toMapList();
                //     final dayDetails = await DayModel().select().DayCloseDate.equals(DateTimeDetails().onlyDate()).toMapList();
                //     if (dayDetails.isNotEmpty) {
                //       if (bodaDetails.isEmpty) {
                //         Navigator.push(context, MaterialPageRoute(builder: (_) => const BODAReplica()));
                //       } else {
                //         Navigator.push(context, MaterialPageRoute(builder: (_) => const BODASlipScreen()));
                //       }
                //     } else {
                //       Toast.showFloatingToast('Do Day End of ${dayDetails[0]['DayBeginDate']}', context);
                //     }
                //   } else if (position == 96) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const CashBalanceReportsScreen()));
                //   } else if (position == 97) {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => const MailsTransactionReportScreen()));
                //   } else {
                //     showDialog(context: context, builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('Note'),
                //         content: const Text('Day end has happened'),
                //         actions: [
                //           Button(buttonText: 'OKAY', buttonFunction: () => Navigator.pop(context))
                //         ],
                //       );
                //     });
                //   }
                // } else {
                //   if (dayDetails[0].DayBeginDate!.isEmpty) {
                //     final previousDayDetails = await DayModel().select().DayCloseDate.equals(previousDate).toList();
                //     if (previousDayDetails.isEmpty) {
                //       showDialog(context: context, builder: (BuildContext context){
                //         return AlertDialog(
                //           title: const Text('Note'),
                //           content: Text('Please do the day end of date $previousDate to continue'),
                //           actions: [
                //             Button(buttonText: 'OKAY', buttonFunction: () => Navigator.pop(context))
                //           ],
                //         );
                //       });
                //     } else {
                //       showDialog(context: context, builder: (BuildContext context){
                //         return AlertDialog(
                //           title: const Text('Note'),
                //           content: Text('Please do the day begin of date $previousDate to continue'),
                //           actions: [
                //             Button(buttonText: 'OKAY', buttonFunction: () => Navigator.pop(context))
                //           ],
                //         );
                //       });
                //     }
                //   } else {
                //     /*------------------------------Home Page-----------------------------*/
                //     if (position == 1) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingMainScreen()));
                //     } else if (position == 2) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliveryMainScreen()));
                //     } else if (position == 12) {
                //       showLoaderDialog(context);
                //       var fees = await Fees().getRegistrationFees('LETTER');
                //       Navigator.pop(context);
                //       Navigator.push(context, MaterialPageRoute(builder: (_) =>
                //       Dummy()
                //           // RegisterLetterBookingScreen1(fees: fees)
                //       ));
                //     } else if (position == 13) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeedPostScreen()));
                //     } else if (position == 14) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const EMOMainScreen()));
                //     } else if (position == 15) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const ParcelBookingScreen()));
                //     } else if (position == 16) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductSaleScreen()));
                //     } else if (position == 17) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const BillerMainScreen()));
                //     } else if (position == 18) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelBookedScreen()));
                //     } else if (position == 19) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialRemittanceMainScreen()));
                //     } else if (position == 110) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const PayRollScreen()));
                //     } else if (position == 111) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveMainScreen()));
                //     } else if (position == 112) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const MiscellaneousMainScreen()));
                //     } else if (position == 113) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsMainScreen()));
                //     } else if (position == 91) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const CancelledReportsScreen()));
                //     } else if (position == 92) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const TransactionReportsScreen()));
                //     } else if (position == 93) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const InventoryScreen()));
                //     } else if (position == 94) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const CashCardReportsScreen()));
                //     } else if (position == 95) {
                //       final bodaDetails = await Liability().select().Date.equals(DateTimeDetails().onlyDate()).toMapList();
                //       final dayDetails = await DayModel().select().DayCloseDate.equals(DateTimeDetails().onlyDate()).toMapList();
                //       if (dayDetails.isNotEmpty) {
                //         if (bodaDetails.isEmpty) {
                //           Navigator.push(context, MaterialPageRoute(builder: (_) => const BODAReplica()));
                //         } else {
                //           Navigator.push(context, MaterialPageRoute(builder: (_) => const BODASlipScreen()));
                //         }
                //       } else {
                //         Toast.showFloatingToast('Do Day End', context);
                //       }
                //     } else if (position == 96) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const CashBalanceReportsScreen()));
                //     } else if (position == 97) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const MailsTransactionReportScreen()));
                //     } else if (position == 31) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const BagReceiveScreen()));
                //     } else if (position == 32) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => BagOpenScreen()));
                //     } else if (position == 34) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => BagCloseScreen()));
                //     } else if (position == 35) {
                //       Navigator.push(context, MaterialPageRoute(builder: (_) => const BagDispatchScreen()));
                //     }
                //     // else if (position == 36) Navigator.push(context, MaterialPageRoute(builder: (_) => BagInfoScreen()));
                //     // else if (position == 37) Navigator.push(context, MaterialPageRoute(builder: (_) => BagTrackingScreen()));
                //     /*--------------------------------------------------------------------*/
                //   }
                // }
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(image, width: 70, color: const Color(0xFFB71C1C)),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF984600),
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}

class DayCard extends StatelessWidget {
  final String title;
  final String image;
  final Function() function;

  const DayCard(
      {Key? key,
      required this.title,
      required this.image,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            color: Colors.grey[300],
          ),
          child: Ink(
            child: InkWell(
              onTap: function,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset(image, width: 70, color: const Color(0xFFB71C1C)),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF984600),
                          fontSize: 17,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
