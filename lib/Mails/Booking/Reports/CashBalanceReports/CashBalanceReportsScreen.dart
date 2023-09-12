import 'package:collection/collection.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashBalanceReportsScreen extends StatefulWidget {
  const CashBalanceReportsScreen({Key? key}) : super(key: key);

  @override
  _CashBalanceReportsScreenState createState() =>
      _CashBalanceReportsScreenState();
}

class _CashBalanceReportsScreenState extends State<CashBalanceReportsScreen> {
  DateTime selectedDate = DateTime.now();

  List<int> letter = [];
  List<int> speed = [];
  List<int> parcel = [];
  List<int> emo = [];
  List<double> prepaidAmount = [];

  final formGlobalKey = GlobalKey<FormState>();
  final dateFocus = FocusNode();
  final dateController = TextEditingController();

  bool balanceData = false;

  String? cashOB;
  String? cashCB;
  String? stampOB;
  String cashTOAO = '';

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(selected);
      setState(() {
        dateController.text = formattedDate;
      });
      int inventoryOB = 0;
      final dayBalance = await DayModel()
          .select()
          .DayBeginDate
          .equals(formattedDate)
          .toMapList();
      final inventoryReport =
          await BookingDBService().getInventory(formattedDate);
      final letterResponse = await LetterBooking()
          .select()
          .BookingDate
          .equals(formattedDate)
          .toMapList();
      final bodaDetails =
          await BodaSlip().select().bodaDate.equals(formattedDate).toMapList();
      if (bodaDetails.isNotEmpty) {
        if (bodaDetails[0]['cashTo'].toString().isNotEmpty) {
          cashTOAO = bodaDetails[0]['cashTo'].toString();
        }
      }
      if (letterResponse.isNotEmpty) {
        for (int i = 0; i < letterResponse.length; i++) {
          letter.add(int.parse(letterResponse[i]['TotalCashAmount']));
          prepaidAmount
              .add(double.parse(letterResponse[i]['PrepaidAmount'] ?? 0.0));
        }
      } else {
        letter.clear();
      }
      final speedResponse = await SpeedBooking()
          .select()
          .BookingDate
          .equals(formattedDate)
          .toMapList();
      if (speedResponse.isNotEmpty) {
        for (int i = 0; i < speedResponse.length; i++) {
          speed.add(int.parse(speedResponse[i]['TotalCashAmount']));
          prepaidAmount
              .add(double.parse(speedResponse[i]['PrepaidAmount'] ?? 0.0));
        }
      } else {
        speed.clear();
      }
      final parcelResponse = await ParcelBooking()
          .select()
          .BookingDate
          .equals(formattedDate)
          .toMapList();
      if (parcelResponse.isNotEmpty) {
        for (int i = 0; i < parcelResponse.length; i++) {
          parcel.add(int.parse(parcelResponse[i]['TotalCashAmount']));
          prepaidAmount
              .add(double.parse(parcelResponse[i]['PrepaidAmount'] ?? 0.0));
        }
      } else {
        parcel.clear();
      }
      final emoResponse = await EmoBooking()
          .select()
          .BookingDate
          .equals(formattedDate)
          .toMapList();
      if (emoResponse.isNotEmpty) {
        for (int i = 0; i < emoResponse.length; i++) {
          emo.add(int.parse(emoResponse[i]['TotalAmount']));
        }
      } else {
        emo.clear();
      }
      if (dayBalance[0]['CashOpeningBalance'].toString() != 'null') {
        setState(() {
          cashOB = formatCurrency
              .format(double.parse(dayBalance[0]['CashOpeningBalance']));
          cashCB = dayBalance[0]['CashClosingBalance'].toString() != 'null'
              ? formatCurrency
                  .format(double.parse(dayBalance[0]['CashClosingBalance']))
              : '-';
          balanceData = true;
          if (inventoryReport.isNotEmpty) {
            for (int i = 0; i < inventoryReport.length; i++) {
              inventoryOB += int.parse(inventoryReport[i]['OpeningValue']);
            }
          }
          stampOB = formatCurrency.format(inventoryOB);
        });
      } else {
        setState(() {
          balanceData = false;
        });
      }
    }
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
      appBar: const AppAppBar(
        title: 'Cash Balance Report',
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
                      children: [
                        Text(
                          'Cash Balance Report ($ofcName)',
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
                              width: 160,
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
                          visible: dateController.text.isNotEmpty,
                          child: balanceData == false
                              ? Column(
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
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        const Space(),
                                        headingText('Opening Balance'),
                                        const Space(),
                                        titleText('Cash Opening Balance',
                                            cashOB ?? '0'),
                                        titleText('Stamp Opening Balance',
                                            stampOB ?? '0'),
                                        const Space(),
                                        const Divider(),
                                        const Space(),
                                        headingText('Receipt'),
                                        const Space(),
                                        letter.isNotEmpty
                                            ? titleText(
                                                'Letter',
                                                formatCurrency
                                                    .format(letter.sum)
                                                    .toString())
                                            : Container(),
                                        speed.isNotEmpty
                                            ? titleText(
                                                'Speed Post',
                                                formatCurrency
                                                    .format(speed.sum)
                                                    .toString())
                                            : Container(),
                                        parcel.isNotEmpty
                                            ? titleText(
                                                'Parcel',
                                                formatCurrency
                                                    .format(parcel.sum)
                                                    .toString())
                                            : Container(),
                                        emo.isNotEmpty
                                            ? titleText(
                                                'EMO',
                                                formatCurrency
                                                    .format(emo.sum)
                                                    .toString())
                                            : Container(),
                                        const Space(),
                                        const Divider(),
                                        const Space(),
                                        headingText('Payment'),
                                        cashTOAO.isNotEmpty
                                            ? titleText('Cash to A.O', cashTOAO)
                                            : Container(),
                                        const Space(),
                                        const Divider(),
                                        const Space(),
                                        headingText('Closing Balance'),
                                        const Space(),
                                        titleText(
                                            'Cash Closing Balance', cashCB!),
                                        titleText(
                                            'Prepaid Amount',
                                            formatCurrency
                                                .format(prepaidAmount.sum)
                                                .toString()),
                                        const DoubleSpace(),
                                        Button(
                                            buttonText: 'PRINT',
                                            buttonFunction: () {})
                                      ],
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  headingText(String text) {
    return Align(
        alignment: Alignment.topLeft,
        child: Text(
          text,
          style: TextStyle(
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.blueGrey),
        ));
  }

  titleText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  title,
                  style: TextStyle(
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 15),
                ),
              )),
          SizedBox(width: 15, child: const Text(':')),
          Expanded(
              flex: 1,
              child: Text(
                '$value',
                style: TextStyle(
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              )),
        ],
      ),
    );
  }
}
