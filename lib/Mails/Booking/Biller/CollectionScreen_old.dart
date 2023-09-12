import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/flutter_typeahead.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchBillerData.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../BookingMainScreen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  bool billerResult = false;

  DateTime selectedDate = DateTime.now();

  final _billKey = GlobalKey<FormState>();

  final dateFocus = FocusNode();
  final collectedAmountFocus = FocusNode();

  final idController = TextEditingController();
  final dateController = TextEditingController();
  final accountNumberController = TextEditingController();
  final payableAmountController = TextEditingController();
  final collectedAmountController = TextEditingController();

  String billerId = '';
  String billerName = '';
  String billDate = '';

  List<String> basicInformation = <String>[];

  @override
  void initState() {
    GeneratePDF();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                    style:
                        const TextStyle(color: ColorConstants.kSecondaryColor),
                    controller: idController,
                    autofocus: false,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          MdiIcons.identifier,
                          color: ColorConstants.kSecondaryColor,
                        ),
                        fillColor: ColorConstants.kWhite,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorConstants.kWhite),
                        ),
                        labelText: 'Enter the Biller ID/Name',
                        labelStyle:
                            TextStyle(color: ColorConstants.kAmberAccentColor),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.kWhite)))),
                onSuggestionSelected: (Map<String, String> suggestion) async {
                  setState(() {
                    billerId = suggestion['id'].toString();
                    billerName = suggestion['name'].toString();
                  });
                },
                itemBuilder: (context, Map<String, String> suggestion) {
                  return ListTile(
                    title:
                        Text(suggestion['id']! + " -> " + suggestion['name']!),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return await BillerDetails.getBillerData(pattern);
                },
                validator: (value) {
                  if (value!.isEmpty) {}
                },
              ),
            ),
            Visibility(
              visible: idController.text.isEmpty ? false : true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _billKey,
                  child: Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(columnSpacing: 5.0, columns: const <
                              DataColumn>[
                            DataColumn(
                              label: Text('Cancellation ID'),
                            ),
                            DataColumn(
                              label: Text('Tracking No.',
                                  textAlign: TextAlign.center),
                            ),
                          ], rows: <DataRow>[
                            DataRow(cells: [
                              const DataCell(Text('Biller Id')),
                              DataCell(Text(billerId)),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Biller Name')),
                              DataCell(Text(
                                billerName,
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Account No.')),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: accountNumberController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.trim().isEmpty) {
                                      return 'Enter the Account number';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Bill Date')),
                              DataCell(TextButton(
                                child: Text(
                                  billDate.isEmpty ? 'Select Date' : billDate,
                                  style: TextStyle(
                                      color: billDate.isEmpty
                                          ? ColorConstants.kAmberAccentColor
                                          : Colors.black),
                                ),
                                onPressed: () => _selectDate(context),
                              ))
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Amount Payable')),
                              DataCell(SizedBox(

                                width: MediaQuery.of(context).size.width / 2,
                                child: TextFormField(
                                  controller: payableAmountController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  //initialValue: 'Payable Amount',
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.blueGrey),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.trim().isEmpty) {
                                      return 'Enter the Payable amount';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                            ]),
                          ]),
                          const Space(),
                          SizedBox(
                            width: 200,
                            child: CInputForm(
                                readOnly: false,
                                iconData: MdiIcons.currencyInr,
                                labelText: 'Collected Amount',
                                controller: collectedAmountController,
                                textType: TextInputType.number,
                                typeValue: 'Collected Amount',
                                focusNode: collectedAmountFocus),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Button(
                                buttonText: 'SUBMIT',
                                buttonFunction: () {
                                  if (_billKey.currentState!.validate()) {
                                    if (billDate.isEmpty) {
                                      Toast.showFloatingToast(
                                          'Select the Bill Date', context);
                                    } else {
                                      addCollection();
                                      BookingDBService().addBillFile(
                                          accountNumberController.text,
                                          collectedAmountController.text,
                                          DateTimeDetails().dateCharacter(),
                                          DateTimeDetails().timeCharacter(),
                                          billerName,
                                          billerId);
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: const Text(
                                                'Bill Collected Successfully..!',
                                                style:
                                                    TextStyle(letterSpacing: 2),
                                              ),
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      basicInformation.clear();
                                                      final userDetails =
                                                          await OFCMASTERDATA()
                                                              .select()
                                                              .toList();
                                                      String date =
                                                          DateTimeDetails()
                                                              .currentDate();
                                                      String time =
                                                          DateTimeDetails()
                                                              .oT();

                                                      basicInformation.add(
                                                          "Transaction Date");
                                                      basicInformation
                                                          .add(date);
                                                      basicInformation.add(
                                                          "Transaction Time");
                                                      basicInformation
                                                          .add(time);
                                                      basicInformation.add(
                                                          "Booking Office");
                                                      basicInformation.add(
                                                          userDetails[0]
                                                              .BOName
                                                              .toString());
                                                      basicInformation.add(
                                                          "Booking Office PIN");
                                                      basicInformation.add(
                                                          userDetails[0]
                                                              .Pincode
                                                              .toString());
                                                      basicInformation
                                                          .add("BPM");
                                                      basicInformation.add(
                                                          userDetails[0]
                                                              .EmployeeName
                                                              .toString());
                                                      basicInformation
                                                          .add("Service");
                                                      basicInformation
                                                          .add("eBiller");
                                                      basicInformation
                                                          .add("Biller ID");
                                                      basicInformation
                                                          .add(billerId);
                                                      basicInformation
                                                          .add("Biller Name");
                                                      basicInformation
                                                          .add(billerName);
                                                      basicInformation
                                                          .add("Account No.");
                                                      basicInformation.add(
                                                          accountNumberController
                                                              .text);
                                                      basicInformation.add(
                                                          "Payable Amount");
                                                      basicInformation.add(
                                                          payableAmountController
                                                              .text);
                                                      basicInformation.add(
                                                          "Collected Amount");
                                                      basicInformation.add(
                                                          collectedAmountController
                                                              .text);
                                                      PrintingTelPO printer =
                                                          new PrintingTelPO();
                                                      await printer
                                                          .printThroughUsbPrinter(
                                                              "BOOKING",
                                                              "Biller Collection",
                                                              basicInformation,
                                                              basicInformation,
                                                              1);
                                                    },
                                                    child: const Text('PRINT'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const BookingMainScreen()),
                                                          (route) => false);
                                                    },
                                                    child: const Text('OKAY'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1850),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(selected);
      setState(() {
        billDate = formattedDate;
      });
    }
  }

  void addCollection() async {
    final addBill = BillData()
      ..BillId =
          billerId + DateTimeDetails().onlyDate() + DateTimeDetails().onlyTime()
      ..BillName = billerName
      ..BillCode = billerId
      ..BillAccountNumber = accountNumberController.text
      ..BillDate = billDate
      ..BillPayableAmount = payableAmountController.text
      ..BillCollectedAmount = collectedAmountController.text;
    addBill.save();

    final addCash =  CashTable()
      ..Cash_ID =
          DateTimeDetails().dateCharacter() + DateTimeDetails().timeCharacter()
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = 'Add'
      ..Cash_Amount = double.parse(collectedAmountController.text)
      ..Cash_Description = 'Biller Collection';
    await addCash.save();

    BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Booking',
        'Biller Collection',
        DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(),
        collectedAmountController.text,
        'Add');
  }

  GeneratePDF() async {
    basicInformation.clear();
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
    basicInformation.add(billerId);
    basicInformation.add("Biller Name");
    basicInformation.add(billerName);
    basicInformation.add("Account No.");
    basicInformation.add(accountNumberController.text);
    basicInformation.add("Payable Amount");
    basicInformation.add(payableAmountController.text);
    basicInformation.add("Collected Amount");
    basicInformation.add(collectedAmountController.text);
  }
}
