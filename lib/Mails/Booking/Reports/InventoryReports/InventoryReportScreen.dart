import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool inventoryOpenFlag = false;

  final dateFocus = FocusNode();
  final searchFocus = FocusNode();

  final formGlobalKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final searchController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  List inventory = [];
  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

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
    print("Inventory Load");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const AppAppBar(
        title: 'Inventory Reports',
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
                        inventory.isEmpty
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
                                initiallyExpanded: inventoryOpenFlag,
                                onExpansionChanged: (value) {
                                  setState(() {
                                    inventoryOpenFlag = value;
                                  });
                                },
                                title: Text(
                                  'Item Description',
                                  style: TextStyle(
                                      letterSpacing: 2, fontSize: 14),
                                ),
                                children: [
                                  Scrollbar(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Card(
                                        child: DataTable(
                                          columns: const <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Item\nCode',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text('Item\nName',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('Denomination',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('OB\nBalance',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('OB\nValue',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('Sale\nBalance',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('Sale\nValue',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('Closing\nBalance',
                                                  textAlign: TextAlign.center),
                                            ),
                                            DataColumn(
                                              label: Text('Closing\nValue',
                                                  textAlign: TextAlign.center),
                                            ),
                                          ],
                                          rows: inventory
                                              .map((e) =>
                                                  DataRow(cells: <DataCell>[
                                                    DataCell(Center(
                                                      child: Text(
                                                          e['ProductID']),
                                                    )),
                                                    DataCell(Center(
                                                      child:
                                                          Text(e['Name']),
                                                    )),
                                                    DataCell(Center(
                                                      child: Text(
                                                          '\u{20B9}${e['Denom']}'),
                                                    )),
                                                    DataCell(Center(
                                                      child: Text(
                                                          '${e['OpeningQuantity']}'),
                                                    )),
                                                    DataCell(Center(
                                                      child: Text(
                                                          '\u{20B9} ${e['OpeningValue']}'),
                                                    )),
                                                    DataCell(Center(
                                                      child: Text((double.parse(e['OpeningQuantity'])-double.parse(e['Quantity'])).toString()),

                                                    )),
                                                    DataCell(Center(
                                                      child: Text((double.parse(e['OpeningValue'])-double.parse(e['Value'])).toString()),
                                                    )),
                                                    DataCell(Center(
                                                      child: Text(e['Quantity'].toString()),

                                                    )),
                                                    DataCell(Center(
                                                      child: Text(e['Value'].toString()),
                                                    )),
                                                  ]))
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () async{



                                    final userDetails = await OFCMASTERDATA().select().toList();

                                    basicInformation.clear();

                                    basicInformation.add("Office Name");
                                    basicInformation.add(userDetails[0].BOName.toString());
                                    basicInformation.add("Office ID");
                                    basicInformation.add(userDetails[0].BOFacilityID.toString());

                                    basicInformation.add("Report Date");
                                    basicInformation.add(DateTimeDetails().currentDate());
                                    basicInformation.add("Report Time");
                                    basicInformation.add(DateTimeDetails().oT());
                                    basicInformation.add("................................");
                                    basicInformation.add("");
                                    basicInformation.add("SNo.   Name    Quantity    Value");
                                    basicInformation.add("...............................");
                                    for (int i=0;i<inventory.length;i++)
                                      {

                                        print(inventory[i]["ClosingQuantity"]);
                                        print(inventory[i]["ClosingValue"]);
                                        basicInformation.add("${i+1}.${inventory[i]["StampName"].toString().substring(0,10)}");
                                        basicInformation.add("${inventory[i]["ClosingQuantity"]}          ${inventory[i]["ClosingValue"]}");
                                      }

                                    secondReceipt.clear(); //sending empty list so that it won't print
                                    PrintingTelPO printer = new PrintingTelPO();
                                    await printer.printThroughUsbPrinter(
                                        "BOOKING", "Inventory Report", basicInformation, secondReceipt, 1);



                                  }, child: Text("PRINT"))
                                ],
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
        dateController.text = formattedDate;
      });
    }
    getInventory(dateController.text);
  }

  getInventory(String date) async {
    inventory = await BookingDBService().getInventory(date);

    setState(() {});
  }

  quantityBalance(String openingQuantity, String closingQuantity) {
    print(closingQuantity);
    print("Quantity is $closingQuantity");
    double first = double.parse(openingQuantity);
    double second;
    if (closingQuantity == 'null' || closingQuantity.isEmpty) {
      print('if condition');
      second = 0;
    } else {
      print('else condition');
      second = double.parse(closingQuantity);
    }
    print('out of if else ');
    double totalQuantity = first - second;
    print(totalQuantity);
    return totalQuantity.toString();
  }

  valueBalance(String openingValue, String closingValue) {
    double first = double.parse(openingValue);
    double second;
    if (closingValue == 'null' || closingValue.isEmpty) {
      second = 0;
    } else {
      second = double.parse(closingValue);
    }
    double totalValue = first - second;
    return totalValue.toString();
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
