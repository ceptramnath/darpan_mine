import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DigitalReportsScreen extends StatefulWidget {
  const DigitalReportsScreen({Key? key}) : super(key: key);

  @override
  _DigitalReportsScreenState createState() => _DigitalReportsScreenState();
}

class _DigitalReportsScreenState extends State<DigitalReportsScreen> {
  String? _chosenValue;
  String _selectedDate = '';

  List trans = [];
  List letterTransactions = [];
  List speedTransactions = [];
  List parcelTransactions = [];
  List sbTransactions = [];
  List rdTransactions = [];

  bool reports = false;

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
      getTransactions(_selectedDate);
    }
  }

  getTransactions(String date) async {
    letterTransactions = await LetterBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(date)
        .and
        .TenderID
        .equals('8')
        .endBlock
        .toMapList();
    if (letterTransactions.isNotEmpty) {
      for (int i = 0; i < letterTransactions.length; i++) {
        trans.add(letterTransactions[i]);
      }
    }
    parcelTransactions = await ParcelBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(date)
        .and
        .TenderID
        .equals('8')
        .endBlock
        .toMapList();
    if (parcelTransactions.isNotEmpty) {
      for (int i = 0; i < parcelTransactions.length; i++) {
        trans.add(parcelTransactions[i]);
      }
    }
    speedTransactions = await SpeedBooking()
        .select()
        .startBlock
        .BookingDate
        .equals(date)
        .and
        .TenderID
        .equals('8')
        .endBlock
        .toMapList();
    if (speedTransactions.isNotEmpty) {
      for (int i = 0; i < speedTransactions.length; i++) {
        trans.add(speedTransactions[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.kPrimaryColor,
        title: const Text(
          'Digital Report',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Select the Type',
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
                      items: <String>['LETTER', 'Register Parcel', 'Speed Post']
                          .map<DropdownMenuItem<String>>((String value) {
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
              trans.isEmpty
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
                  : Column(
                      children: [
                        ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            'Transactions',
                            style: TextStyle(letterSpacing: 2, fontSize: 14),
                          ),
                          children: [
                            Scrollbar(
                                child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Card(
                                child: Column(
                                  children: [
                                    DataTable(
                                        columns: const <DataColumn>[
                                          DataColumn(label: Text('Sl No.')),
                                          DataColumn(label: Text('Type')),
                                          DataColumn(
                                              label: Text(
                                                  'Date/Time of Transaction')),
                                          DataColumn(
                                              label: Center(
                                                  child:
                                                      Text('Receipt Number'))),
                                          DataColumn(label: Text('Amount')),
                                          DataColumn(label: Text('Sender')),
                                          DataColumn(
                                              label: Text('From Address')),
                                          DataColumn(label: Text('Addressee')),
                                          DataColumn(label: Text('To Address')),
                                        ],
                                        rows: trans
                                            .map((e) =>
                                                DataRow(cells: <DataCell>[
                                                  DataCell(
                                                      Center(child: Text('1'))),
                                                  DataCell(Center(
                                                      child: Text(
                                                          e['ProductCode']))),
                                                  DataCell(Center(
                                                      child: Text(e[
                                                              'BookingDate'] +
                                                          " " +
                                                          e['BookingTime']))),
                                                  DataCell(
                                                      Text(e['InvoiceNumber'])),
                                                  DataCell(Center(
                                                      child: Text(e[
                                                          'TotalCashAmount']))),
                                                  DataCell(
                                                      Text(e['SenderName'])),
                                                  DataCell(Text(
                                                      e['SenderAddress'] +
                                                          ", " +
                                                          e['SenderCity'] +
                                                          ", " +
                                                          e['SenderState'])),
                                                  DataCell(
                                                      Text(e['RecipientName'])),
                                                  DataCell(Text(
                                                      e['RecipientAddress'] +
                                                          ", " +
                                                          e['RecipientCity'] +
                                                          ", " +
                                                          e['RecipientState'])),
                                                ]))
                                            .toList())
                                  ],
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
