import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Reports/MailTransactionsReport/Widgets/EMOCardd.dart';
import 'package:darpan_mine/Mails/Booking/Reports/MailTransactionsReport/Widgets/LetterReportCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'Widgets/EMOReportDialog.dart';

class MailsTransactionReportScreen extends StatefulWidget {
  const MailsTransactionReportScreen({Key? key}) : super(key: key);

  @override
  _MailsTransactionReportScreenState createState() =>
      _MailsTransactionReportScreenState();
}

class _MailsTransactionReportScreenState
    extends State<MailsTransactionReportScreen> {
  String? _chosenValue;
  String _selectedDate = '';

  // late Future getReport;

  bool reports = false;

  List mailReport = [];

  _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = DateFormat('dd-MM-yyyy');
        _selectedDate = formatter.format(d);
      });
    }
  }

  Future getReport() async {
    String date = _selectedDate;
    if (_chosenValue == 'LETTER') {
      mailReport =
          await LetterBooking().select().BookingDate.equals(date).toMapList();
    } else if (_chosenValue == 'Register Parcel') {
      mailReport =
          await ParcelBooking().select().BookingDate.equals(date).toMapList();
    } else if (_chosenValue == 'Speed Post') {
      mailReport =
          await SpeedBooking().select().BookingDate.equals(date).toMapList();
    } else if (_chosenValue == 'EMO') {
      mailReport =
          await EmoBooking().select().BookingDate.equals(date).toMapList();
    }
    return mailReport;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.kPrimaryColor,
        title: const Text(
          'Booked Articles',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Select the type of Article',
                style: TextStyle(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.kTextColor),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      border: Border.all(
                          color: ColorConstants.kSecondaryColor, width: 1)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      underline: const SizedBox(),
                      focusColor: Colors.white,
                      value: _chosenValue,
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        'LETTER',
                        'Register Parcel',
                        'Speed Post',
                        'EMO'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 2,
                                fontSize: 15),
                          ),
                        );
                      }).toList(),
                      hint: const Text(
                        "Select Type",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _chosenValue == null ? false : true,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20, top: 8),
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: GestureDetector(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                key: Key(_selectedDate),
                                initialValue:
                                    _selectedDate == '' ? '' : _selectedDate,
                                readOnly: true,
                                style: const TextStyle(
                                    color: ColorConstants.kAmberAccentColor),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)),
                                      borderSide: BorderSide(
                                          width: 1,
                                          color:
                                              ColorConstants.kSecondaryColor),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      color: ColorConstants.kAmberAccentColor,
                                    ),
                                    labelStyle: const TextStyle(
                                        color: ColorConstants.kTextColor,
                                        fontWeight: FontWeight.bold),
                                    labelText: 'Select Date',
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: ColorConstants
                                                .kSecondaryColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: ColorConstants
                                                .kSecondaryColor))),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 1, child: Container()),
                  ],
                ),
              ),
              FutureBuilder(
                future: getReport(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    } else if (snapshot.data.toString().length == 2) {
                      return Column(
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
                      );
                    } else if (snapshot.hasData) {
                      return Flexible(
                        child: ListView.builder(
                          itemCount: mailReport.length,
                          itemBuilder: (context, index) {
                            return reportCards(index);
                          },
                        ),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
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
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  reportCards(index) {
    if (_chosenValue == 'EMO') {
      return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return EMOReportDialog(
                    emoValue: mailReport[index]['TotalAmount'],
                    commission: mailReport[index]['CommissionAmount'],
                    amountPaid: mailReport[index]['TotalAmount'],
                    senderName: mailReport[index]['SenderName'],
                    senderAddress: mailReport[index]['SenderAddress'],
                    senderPinCode: mailReport[index]['SenderZip'],
                    senderCity: mailReport[index]['SenderCity'],
                    senderState: mailReport[index]['SenderState'],
                    payeeName: mailReport[index]['RecipientName'],
                    payeeAddress: mailReport[index]['RecipientAddress'],
                    payeePinCode: mailReport[index]['RecipientZip'],
                    payeeCity: mailReport[index]['RecipientCity'],
                    payeeState: mailReport[index]['RecipientState']);
              });
        },
        child: EMOReportCard(
          emoValue: mailReport[index]['TotalAmount'],
          commission: mailReport[index]['CommissionAmount'],
          amountPaid: mailReport[index]['TotalAmount'],
          senderName: mailReport[index]['SenderName'],
          payeeName: mailReport[index]['RecipientName'],
          payeeAddress: mailReport[index]['RecipientAddress'],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {},
        child: LetterReportCard(
            articleNumber: mailReport[index]['ArticleNumber'],
            weight: mailReport[index]['Weight'],
            prepaidAmount: mailReport[index]['PrepaidAmount'],
            amountToBeCollected: mailReport[index]['TotalCashAmount'],
            senderName: mailReport[index]['SenderName'],
            addresseeName: mailReport[index]['RecipientName']),
      );
    }
  }
}
