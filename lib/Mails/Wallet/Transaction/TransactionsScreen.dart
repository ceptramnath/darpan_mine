import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/Reports/TransactionReports/AllTransactionsModel.dart';
import 'package:darpan_mine/Mails/Wallet/Transaction/TransactionCard.dart';
import 'package:darpan_mine/Widgets/AppAppBarWithoutWallet.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  @override
  _TransactionDetailsScreenState createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  var transactionsResponse;
  late Future getTransactions;
  String _selectedDate = '';

  DateTime selectedDate = DateTime.now();
  final dateFocus = FocusNode();
  final dateController = TextEditingController();

  final List<AllTransactionsModel> _transactions = <AllTransactionsModel>[];
  List<AllTransactionsModel> _transactionsToDisplay = <AllTransactionsModel>[];
  List<AllTransactionsModel> transactions = <AllTransactionsModel>[];

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

  Future getTransactionDetails() async {
    _transactionsToDisplay.clear();

    print(_selectedDate);
    // final transactionSelectedResponse = await TransactionTable().select().tranDate.equals(_selectedDate).toMapList();
    final transactionSelectedResponse = await TransactionTable()
        .select()
        .startBlock
        .tranDate
        .equals(_selectedDate)
        .or
        .tranDate
        .equals(_selectedDate.split('-').reversed.join('-'))
        .endBlock
        .toMapList();
    print(transactionSelectedResponse);

    var transactionSelected = <AllTransactionsModel>[];
    for (var transactionSelectedResponse in transactionSelectedResponse) {
      transactionSelected
          .add(AllTransactionsModel.fromDB(transactionSelectedResponse));
    }
    dateController.text = _selectedDate;
    _transactionsToDisplay = transactionSelected;
    return transactionSelected.reversed.toList();
  }

  @override
  void initState() {
    getTransactions = getTransactionList();
    super.initState();
  }

  getTransactionList() async {
    await fetchTransaction().then((value) {
      setState(() {
        _transactions.addAll(value);
        _transactionsToDisplay = _transactions;
      });
    });
  }

  Future<List<AllTransactionsModel>> fetchTransaction() async {
    _selectedDate = DateTimeDetails().currentDate();

    print(_selectedDate);
    // transactionsResponse = await TransactionTable().select().tranDate.equals(DateTimeDetails().currentDate()).toMapList();
    // transactionsResponse=await TransactionTable().select().startBlock.tranDate.equals(_selectedDate).or.tranDate.equals(_selectedDate.split('-').reversed.join('-')).endBlock.toMapList();

    transactionsResponse = await TransactionTable().select().toMapList();

    print("Transaction response $transactionsResponse");
    for (var transactionResponse in transactionsResponse) {
      transactions.add(AllTransactionsModel.fromDB(transactionResponse));
    }
    dateController.text = DateTimeDetails().currentDate();
    return transactions.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBarWithoutWallet(
        title: 'Transaction Details',
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
                      future: getTransactions,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (_transactionsToDisplay.isEmpty) {
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
                                  itemCount: _transactionsToDisplay.length + 1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Container()
                                        : transactionsListItem(index - 1);
                                  }));
                        }
                      },
                    )
                  : FutureBuilder(
                      future: getTransactionDetails(),
                      builder: (ctx, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (_transactionsToDisplay.isEmpty) {
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
                                  itemCount: _transactionsToDisplay.length + 1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Container()
                                        : transactionsListItem(index - 1);
                                  }));
                        }
                      }),
            ],
          ),
        ),
      ),
    );
  }

  transactionsListItem(index) {
    return TransactionCard(
      id: _transactionsToDisplay[index].id,
      date: _transactionsToDisplay[index].date,
      time: _transactionsToDisplay[index].time,
      type: _transactionsToDisplay[index].type,
      description: _transactionsToDisplay[index].description,
      valuation: _transactionsToDisplay[index].valuation,
    );
  }
}
