import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CancelledReportsScreen extends StatefulWidget {
  const CancelledReportsScreen({Key? key}) : super(key: key);

  @override
  _CancelledReportsScreenState createState() => _CancelledReportsScreenState();
}

class _CancelledReportsScreenState extends State<CancelledReportsScreen> {
  bool cancelledOpenFlag = false;
  bool cancelledReports = false;

  final dateFocus = FocusNode();
  final formGlobalKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String ofcID = " ";
  String ofcName = " ";
  String empID = " ";
  String empName = " ";

  List reports = [];
  Future? getUserDetails;

  @override
  void initState() {
    // TODO: implement initState

    getUserDetails = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const AppAppBar(
        title: 'Cancelled Reports',
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
                          'Cancelled Articles wise Report ($ofcName)',
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
                              width: 140,
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
                            visible: cancelledReports,
                            child: reports.isEmpty
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
                                : ExpansionTile(
                                    initiallyExpanded: cancelledOpenFlag,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        cancelledOpenFlag = value;
                                      });
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Cancelled Articles',
                                          style: TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 14),
                                        ),
                                        Text(
                                          '${reports.length}',
                                          style: TextStyle(
                                              letterSpacing: 2,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Scrollbar(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Card(
                                            child: DataTable(
                                              columns: const <DataColumn>[
                                                DataColumn(
                                                    label: Text('Category')),
                                                DataColumn(
                                                    label: Text(
                                                        'Cancellation ID')),
                                                DataColumn(
                                                    label: Text('Tracking No.',
                                                        textAlign:
                                                            TextAlign.center)),
                                                DataColumn(
                                                  label: Text(
                                                      'Total Amount\n(\u{20B9})',
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                      'Reason for Cancellation',
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                                DataColumn(
                                                  label: Text('Recipient No.',
                                                      textAlign:
                                                          TextAlign.center),
                                                ),
                                              ],
                                              rows: reports
                                                  .map(
                                                      (e) => DataRow(
                                                              cells: <DataCell>[
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        e['ProductCode']))),
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        'CN${e['ArticleNumber']}'))),
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        e['ArticleNumber']))),
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        '\u{20B9} ${e['TotalAmount']}',
                                                                        textAlign:
                                                                            TextAlign.center))),
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        e[
                                                                            'CancellationReason'],
                                                                        textAlign:
                                                                            TextAlign.center))),
                                                                DataCell(Center(
                                                                    child: Text(
                                                                        e['InvoiceNumber']))),
                                                              ]))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        const DoubleSpace(),
                        Visibility(
                            visible: reports.isNotEmpty,
                            child: Button(
                              buttonText: 'PRINT',
                              buttonFunction: () {},
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
    }
    getReports(dateController.text);
  }

  getReports(String date) async {
    reports =
        await CancelBooking().select().BookingDate.equals(date).toMapList();
    setState(() {
      cancelledReports = true;
    });
  }

  getData() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    ofcID = userDetails[0].BOFacilityID.toString();
    ofcName = userDetails[0].BOName.toString();
    empID = userDetails[0].EMPID.toString();
    empName = userDetails[0].EmployeeName.toString();
    return userDetails.length;
  }
}
