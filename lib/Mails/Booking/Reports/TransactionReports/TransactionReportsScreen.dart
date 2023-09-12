
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionReportsScreen extends StatefulWidget {
  const TransactionReportsScreen({Key? key}) : super(key: key);

  @override
  _TransactionReportsScreenState createState() =>
      _TransactionReportsScreenState();
}

class _TransactionReportsScreenState extends State<TransactionReportsScreen> {
  bool transactionsOpenFlag = false;
  bool detailsOpenFlag = false;
  bool transactions = false;

  int emoCount = 0;
  int emoAmount = 0;
  int pmoCount = 0;
  int pmoAmount = 0;
  int parcelCount = 0;
  int parcelAmount = 0;
  int speedPostCount = 0;
  int speedPostAmount = 0;
  int registerLetterCount = 0;
  int registerLetterAmount = 0;

  final dateFocus = FocusNode();

  final formGlobalKey = GlobalKey<FormState>();

  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  List trans = [];
  List letterTransactions = [];
  List speedTransactions = [];
  List emoTransactions = [];
  List pmoTransactions = [];
  List vpmoTransactions = [];
  List parcelTransactions = [];
  List registerLetters = [];
  List emoLetters = [];
  List speedPostLetters = [];
  List parcelLetters = [];
  List pmoLetters = [];

  String ofcID = " ";
  String ofcName = " ";
  String empID = " ";
  String empName = " ";
  Future? getUserDetails;


  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

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
        title: 'Transaction Reports',
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
                          'Detailed Transaction wise Report ($ofcName)',
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
                              'Report',
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
                                    initiallyExpanded: transactionsOpenFlag,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        transactionsOpenFlag = value;
                                      });
                                    },
                                    title: Text(
                                      'Detailed Report',
                                      style: TextStyle(
                                          letterSpacing: 2, fontSize: 14),
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
                                                    DataColumn(
                                                      label: Text(
                                                        'Category',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label:
                                                          Text('Invoice No.'),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                          'Tracking \nNumber',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                          'Recipient \nName',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                          'Delivery \nPin',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                          'Prepaid \nAmount\n(\u{20B9})',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                          'Total\nAmount\n(\u{20B9})',
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                  ],
                                                  rows: trans
                                                      .map(
                                                          (e) => DataRow(
                                                                  cells: <
                                                                      DataCell>[
                                                                    DataCell(Text(
                                                                        e['ProductCode'])),
                                                                    DataCell(Text(
                                                                        e['InvoiceNumber'])),
                                                                    DataCell(Text(
                                                                        e['ArticleNumber'])),
                                                                    DataCell(Text(
                                                                        e['RecipientName'])),
                                                                    DataCell(Center(
                                                                        child: Text(e['RecipientZip'] ??
                                                                            'NA'))),
                                                                    DataCell(Center(
                                                                        child: Text(e['PrepaidAmount'] ??
                                                                            '0'))),
                                                                    DataCell(Center(
                                                                        child: Text(
                                                                            e['TotalAmount']))),
                                                                  ]))
                                                      .toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const DoubleSpace(),
                                  ExpansionTile(
                                    initiallyExpanded: detailsOpenFlag,
                                    onExpansionChanged: (value) {
                                      setState(() {
                                        detailsOpenFlag = value;
                                      });
                                    },
                                    title: Text(
                                      'Consolidated Report',
                                      style: TextStyle(
                                          letterSpacing: 2, fontSize: 14),
                                    ),
                                    children: [
                                      Card(
                                        child: DataTable(columns: const <
                                            DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Service\nName',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text('Total\nQuantity'),
                                          ),
                                          DataColumn(
                                            label: Text('Total\nAmount',
                                                textAlign: TextAlign.center),
                                          ),
                                        ], rows: <DataRow>[
                                          DataRow(cells: [
                                            const DataCell(Text('EMO')),
                                            DataCell(Center(
                                                child:
                                                    Text(emoCount.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    '\u{20B9} ${emoAmount.toString()}'))),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                                Text('REGISTER LETTER')),
                                            DataCell(Center(
                                                child: Text(registerLetterCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    '\u{20B9} ${registerLetterAmount.toString()}'))),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text('SPEED POST')),
                                            DataCell(Center(
                                                child: Text(speedPostCount
                                                    .toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    '\u{20B9} ${speedPostAmount.toString()}'))),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(Text('PARCEL')),
                                            DataCell(Center(
                                                child: Text(
                                                    parcelCount.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    '\u{20B9} ${parcelAmount.toString()}'))),
                                          ]),
                                          const DataRow(cells: [
                                            DataCell(Text('SERVICE LETTER')),
                                            DataCell(Center(child: Text('0'))),
                                            DataCell(Center(
                                                child: Text('\u{20B9} 0'))),
                                          ]),
                                          const DataRow(cells: [
                                            DataCell(Text('SERVICE PARCEL')),
                                            DataCell(Center(child: Text('0'))),
                                            DataCell(Center(
                                                child: Text('\u{20B9} 0'))),
                                          ]),
                                          DataRow(cells: [
                                            const DataCell(
                                                Text('PM RELIEF FUND MO')),
                                            DataCell(Center(
                                                child:
                                                    Text(pmoCount.toString()))),
                                            DataCell(Center(
                                                child: Text(
                                                    '\u{20B9} ${pmoAmount.toString()}'))),
                                          ]),
                                          const DataRow(cells: [
                                            DataCell(Text('VPMO')),
                                            DataCell(Center(child: Text('0'))),
                                            DataCell(Center(
                                                child: Text('\u{20B9} 0'))),
                                          ]),
                                        ]),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                        Visibility(
                          visible: trans.isNotEmpty,
                          child: Button(
                            buttonText: 'PRINT',
                            buttonFunction: () async{
                              final userDetails = await OFCMASTERDATA().select().toList();
                              basicInformation.clear();
                              basicInformation.add("Office Name");
                              basicInformation.add(userDetails[0].BOName.toString());
                              basicInformation.add("Office ID");
                              basicInformation
                                  .add(userDetails[0].BOFacilityID.toString());

                              basicInformation.add("Report Date");
                              basicInformation.add(DateTimeDetails().currentDate());
                              basicInformation.add("Report Time");
                              basicInformation.add(DateTimeDetails().oT());
                              basicInformation
                                  .add("................................");
                              basicInformation.add("");

                              basicInformation
                                  .add("Service -- Quantity -- Amount");
                              basicInformation.add("");

                              basicInformation.add("EMO               "+ emoCount.toString()+"    "+emoAmount.toString());
                              basicInformation.add("");

                              basicInformation.add("Regd.Letter       "+registerLetterCount.toString()+"    "+registerLetterAmount.toString());
                              basicInformation.add("");

                              basicInformation.add("Regd.Parcel       "+parcelCount.toString()+"    "+parcelAmount.toString());
                              basicInformation.add("");

                              basicInformation.add("Speed Post        "+speedPostCount.toString()+"    "+speedPostAmount.toString());
                              basicInformation.add("");
                              //
                              // basicInformation.add("VPMO");
                              // basicInformation.add(+" --  " +);

                              // basicInformation.add("Total");

                              PrintingTelPO printer = new PrintingTelPO();
                              await printer.printThroughUsbPrinter("BOOKING",
                                  "Booking Consolidated Report", basicInformation, secondReceipt, 1);

                            },
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
        dateController.text = formattedDate.toString();
      });
      getTransactions(dateController.text);
    }
  }

  getTransactions(String date) async {

    // trans.clear();
    // letterTransactions.clear();
    // speedTransactions.clear();
    // emoTransactions.clear();
    // vpmoTransactions.clear();
    // parcelTransactions.clear();
    // registerLetters.clear();
    // emoLetters.clear();
    // speedPostLetters.clear();
    // parcelLetters.clear();
    // pmoLetters.clear();

    letterTransactions =
        await LetterBooking().select().BookingDate.equals(date).toMapList();
    if (letterTransactions.isNotEmpty) {
      for (int i = 0; i < letterTransactions.length; i++) {
        registerLetterCount++;
        registerLetterAmount += int.parse(letterTransactions[i]['TotalAmount']);
        trans.add(letterTransactions[i]);
      }
    }
    parcelTransactions =
        await ParcelBooking().select().BookingDate.equals(date).toMapList();
    if (parcelTransactions.isNotEmpty) {
      for (int i = 0; i < parcelTransactions.length; i++) {
        parcelCount++;
        parcelAmount += int.parse(parcelTransactions[i]['TotalAmount']);
        trans.add(parcelTransactions[i]);
      }
    }
    emoTransactions =
        await EmoBooking().select().BookingDate.equals(date).and.MOMessage.not.equals("PM Relief Fund").toMapList();
    if (emoTransactions.isNotEmpty) {
      for (int i = 0; i < emoTransactions.length; i++) {
        emoCount++;
        emoAmount += int.parse(emoTransactions[i]['TotalAmount']);
        trans.add(emoTransactions[i]);
      }
    }
    pmoTransactions =
    await EmoBooking().select().BookingDate.equals(date).and.MOMessage.equals("PM Relief Fund").toMapList();
    if (pmoTransactions.isNotEmpty) {
      for (int i = 0; i < pmoTransactions.length; i++) {
        pmoCount++;
        pmoAmount += int.parse(pmoTransactions[i]['TotalAmount']);
        trans.add(pmoTransactions[i]);
      }
    }
    speedTransactions =
        await SpeedBooking().select().BookingDate.equals(date).toMapList();
    if (speedTransactions.isNotEmpty) {
      for (int i = 0; i < speedTransactions.length; i++) {
        speedPostCount++;
        speedPostAmount += int.parse(speedTransactions[i]['TotalCashAmount'].toString().split('.').first);
        // print(speedPostAmount);
        trans.add(speedTransactions[i]);
      }
    }
    setState(() {
      transactions = true;
    });
  }

  getData() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    ofcID = userDetails[0]
        .BOFacilityID
        .toString(); //==null?"":userDetails[0].BOFacilityID.toString();
    ofcName = userDetails[0]
        .BOName
        .toString(); //==null?"":userDetails[0].BOName.toString();
    empID = userDetails[0]
        .EMPID
        .toString(); //==null?"":userDetails[0].EMPID.toString();
    empName = userDetails[0]
        .EmployeeName
        .toString(); //==null?"":userDetails[0].EmployeeName.toString();
    return userDetails.length;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
