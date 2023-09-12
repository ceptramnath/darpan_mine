import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool details = false;

  final dateFocus = FocusNode();
  final formGlobalKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List bills = [];

  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  String pdfName = "";

  GeneratePDF(List e) async {
    final userDetails = await OFCMASTERDATA().select().toList();

    String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();

    basicInformation.add("Transaction Date");
    basicInformation.add(date);
    basicInformation.add("Transaction Time");
    basicInformation.add(time);
    basicInformation.add("Booking Office");
    basicInformation.add(userDetails[0].BOName.toString());
    basicInformation.add("Booking Office PIN");
    basicInformation.add(userDetails[0].Pincode.toString());
    basicInformation.add("BPM");
    basicInformation.add(userDetails[0].EmployeeName.toString());
    basicInformation.add("Service");
    basicInformation.add("eBiller");
    basicInformation.add("Biller ID");
    basicInformation.add(e[0]['BillerId']);
    basicInformation.add("Biller Name");
    basicInformation.add(e[0]['BillerName']);
    basicInformation.add("Collected Amount");
    basicInformation.add(e[0]['TotalCashAmount']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 160,
                    child: YearForm(
                        title: 'Select Date',
                        selectYear: () {
                          _selectDate(context);
                        },
                        controller: dateController,
                        focusNode: dateFocus),
                  ),
                ),
                Visibility(
                  visible: details,
                  child: bills.isEmpty
                      ? Column(
                          children: [
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
                      : Scrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Card(
                              child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Text('Account No.'),
                                  ),
                                  DataColumn(
                                    label: Text('Amount',
                                        textAlign: TextAlign.center),
                                  ),
                                  DataColumn(
                                    label: Text('Biller Id',
                                        textAlign: TextAlign.center),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Biller Name',
                                            textAlign: TextAlign.center)),
                                  ),
                                  DataColumn(
                                    label: Text('Created On',
                                        textAlign: TextAlign.center),
                                  ),
                                  DataColumn(
                                    label: Expanded(
                                        child: Text('Print',
                                            textAlign: TextAlign.center)),
                                  ),
                                ],
                                rows: bills
                                    .map((e) => DataRow(cells: <DataCell>[
                                          DataCell(Text(e['ArticleNumber'])),
                                          DataCell(Center(
                                              child:
                                                  Text(e['TotalCashAmount']))),
                                          DataCell(Center(
                                              child: Text(e['BillerId']))),
                                          DataCell(Text(e['BillerName'])),
                                          DataCell(Center(
                                              child: Text(e['BookingDate']))),
                                          DataCell(Center(
                                              child: ElevatedButton(
                                            onPressed: () async {
                                              PrintingTelPO printer =
                                                  new PrintingTelPO();
                                              GeneratePDF(bills);
                                              await printer.printThroughUsbPrinter(
                                                  "BOOKING",
                                                  "Biller Collection- Duplicate",
                                                  basicInformation,
                                                  basicInformation,
                                                  1);
                                            },
                                            child: const Text('PRINT'),
                                          ))),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    String formattedDate = '';
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat formatter = DateFormat('ddMMyyyy');
      formattedDate = formatter.format(selected);
      dateController.text = formattedDate;
    }
    getBills(formattedDate);
  }

  getBills(String date) async {
    bills = await BillFile().select().BookingDate.equals(date).toMapList();
    setState(() {
      details = true;
    });
  }
}
