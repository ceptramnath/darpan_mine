import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashCard.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashModel.dart';
import 'package:darpan_mine/Widgets/AppAppBarWithoutWallet.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CashDetailsScreen extends StatefulWidget {
  const CashDetailsScreen({Key? key}) : super(key: key);

  @override
  _CashDetailsScreenState createState() => _CashDetailsScreenState();
}

class _CashDetailsScreenState extends State<CashDetailsScreen> {
  late Future getCash;
  var cashResponse;
  String _selectedDate = '';

  DateTime selectedDate = DateTime.now();
  final dateFocus = FocusNode();
  final dateController = TextEditingController();

  final List<CashModel> _cash = <CashModel>[];
  List<CashModel> _cashToDisplay = <CashModel>[];
  List<CashModel> cashMain = <CashModel>[];

  _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = DateFormat('yyyy-MM-dd');
        _selectedDate = formatter.format(d);
        dateController.text = _selectedDate;
      });
    }
  }

  Future getCashDetails() async {
    _cashToDisplay.clear();
    print(_selectedDate);
    // final cashSelectedResponse = await CashTable().select().Cash_Date.equals(_selectedDate).toMapList();
    final cashSelectedResponse = await CashTable()
        .select()
        .startBlock
        .Cash_Date
        .equals(_selectedDate)
        .or
        .Cash_Date
        .equals(_selectedDate.split('-').reversed.join('-'))
        .endBlock
        .toMapList();
    print(cashSelectedResponse);
    var cashSelected = <CashModel>[];
    for (var cashSelectedResponse in cashSelectedResponse) {
      cashSelected.add(CashModel.fromDB(cashSelectedResponse));
    }
    dateController.text = _selectedDate;
    _cashToDisplay = cashSelected;
    return cashSelected.reversed.toList();
  }

  @override
  void initState() {
    getCash = getCashList();
    super.initState();
  }

  getCashList() async {
    await fetchTransaction().then((value) {
      setState(() {
        _cash.addAll(value);
        _cashToDisplay = _cash;
      });
    });
  }

  ///Fetching the cash details
  Future<List<CashModel>> fetchTransaction() async {
    // final cashMainResponse = await CashTable().select().Cash_Date.equals(DateTimeDetails().currentDate()).toMapList();
    _selectedDate = DateTimeDetails().currentDate();
    // final cashMainResponse = await CashTable().select().Cash_Date.equals().toMapList();
    final cashMainResponse = await CashTable()
        .select()
        .startBlock
        .Cash_Date
        .equals(_selectedDate)
        .or
        .Cash_Date
        .equals(_selectedDate.split('-').reversed.join('-'))
        .endBlock
        .toMapList();
    for (var cashMainResponse in cashMainResponse) {
      cashMain.add(CashModel.fromDB(cashMainResponse));
    }
    dateController.text = DateTimeDetails().currentDate();
    return cashMain.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBarWithoutWallet(
        title: 'Cash Details',
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: [
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
              _selectedDate.isEmpty
                  ? FutureBuilder(
                      future: getCash,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (_cashToDisplay.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                          );
                        } else {
                          return Flexible(
                            child: ListView.builder(
                                itemCount: _cashToDisplay.length + 1,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container()
                                      : cashListItem(index - 1);
                                }),
                          );
                        }
                      },
                    )
                  : FutureBuilder(
                      future: getCashDetails(),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (_cashToDisplay.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            ),
                          );
                        } else {
                          return Flexible(
                            child: ListView.builder(
                                itemCount: _cashToDisplay.length + 1,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container()
                                      : cashListItem(index - 1);
                                }),
                          );
                        }
                      }),
            ],
          ),
        ),
      ),
    );
  }

  cashListItem(index) {
    return CashCard(
      cashId: _cashToDisplay[index].id,
      date: _cashToDisplay[index].date,
      time: _cashToDisplay[index].time,
      amount: _cashToDisplay[index].amount.toString(),
      description: _cashToDisplay[index].description,
      type: _cashToDisplay[index].type,
    );
  }
}
