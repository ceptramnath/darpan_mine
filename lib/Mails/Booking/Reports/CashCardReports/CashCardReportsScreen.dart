import 'package:collection/src/iterable_extensions.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashCardReportsScreen extends StatefulWidget {
  const CashCardReportsScreen({Key? key}) : super(key: key);

  @override
  _CashCardReportsScreenState createState() => _CashCardReportsScreenState();
}

class _CashCardReportsScreenState extends State<CashCardReportsScreen> {
  DateTime selectedDate = DateTime.now();
  final formGlobalKey = GlobalKey<FormState>();
  final dateFocus = FocusNode();
  final dateController = TextEditingController();

  List<double> receive = [];

  bool reportDetails = false;

  String? openingBalance;
  String? closingBalance;

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
      dateController.text = formattedDate;
      final allCash = await CashTable().select().toMapList();
      print("All cash $allCash");
      final receivedTransaction = await CashTable()
          .select()
          .Cash_Date
          .equals(formattedDate)
          .toMapList();
      print("Received Transactions $receivedTransaction");
      if (receivedTransaction.isNotEmpty) {
        receive.clear();
        for (int i = 0; i < receivedTransaction.length; i++) {
          if (receivedTransaction[i]['Cash_Type'] == 'Add') {
            receive.add(receivedTransaction[i]['Cash_Amount']);
          }
        }
      } else {
        receive.clear();
      }
      var dayReport = await DayModel()
          .select()
          .DayBeginDate
          .equals(dateController.text)
          .toMapList();
      if (dayReport[0]['CashOpeningBalance'].toString() != 'null') {
        setState(() {
          openingBalance = formatCurrency
              .format(double.parse(dayReport[0]['CashOpeningBalance']));
          closingBalance =
              dayReport[0]['CashClosingBalance'].toString() != 'null'
                  ? formatCurrency
                      .format(double.parse(dayReport[0]['CashClosingBalance']))
                  : 'NA';
          reportDetails = true;
        });
      } else {
        setState(() {
          reportDetails = false;
        });
      }
      /* if (dayReport[0]['CashClosingBalance'].toString() != 'null') {
        setState(() {
          openingBalance = formatCurrency.format(double.parse(dayReport[0]['CashOpeningBalance']));
          closingBalance = formatCurrency.format(double.parse(dayReport[0]['CashClosingBalance']));
          reportDetails = true;
        });
      } else if (dayReport[0]['CashClosingBalance'].toString() == 'null') {
        Toast.showFloatingToast('Day end not done', context);
        setState(() {
          reportDetails = false;
        });
      } else {
        setState(() {
          reportDetails = false;
        });
      }*/
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
        title: 'Cash/Card Report',
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
                          'Inventory Report ($ofcName)',
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
                            visible:
                                dateController.text.isNotEmpty ? true : false,
                            child: reportDetails == false
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
                                          headingText('Cash'),
                                          const Space(),
                                          titleText('Opening Balance',
                                              openingBalance!),
                                          titleText(
                                              'Amount Received',
                                              formatCurrency
                                                  .format(receive.sum)
                                                  .toString()),
                                          titleText('Closing Balance',
                                              closingBalance!),
                                          const Space(),
                                          const Divider(),
                                          const Space(),
                                          headingText('Card'),
                                          const Space(),
                                          titleText('Amount Received', '0.00'),
                                          const DoubleSpace(),
                                          Button(
                                              buttonText: 'PRINT',
                                              buttonFunction: () {})
                                        ],
                                      ),
                                    ),
                                  ))
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
          SizedBox(width: 15, child: Text(':')),
          Expanded(
              flex: 1,
              child: Text(
                value,
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
