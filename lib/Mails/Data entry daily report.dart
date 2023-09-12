import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../HomeScreen.dart';
import '../UtilitiesMainScreen.dart';
import 'DataEntryDatReport.dart';

class DataEntry extends StatefulWidget {
  // String? name;
  // String? CIFNumber;
  // String? isminor;
  // String? kycstatus;
  //
  // SelfNewAccount(this.name,this.CIFNumber,this.isminor,this.kycstatus);
  @override
  _DataEntryState createState() => _DataEntryState();
}

class _DataEntryState extends State<DataEntry> {
  int selected = 0;
  String? selectedType;
  List<String> DataEntryTypes = ["DCube","CSC","Others"];
  final dateFocus = FocusNode();

  // bool isVisible = false;
  bool _isVisible = false;
  bool _isDepVisible = false;
  bool _isWdlVisible = false;
  bool _isNewLoading = false;
  final depositTextController = TextEditingController();
  final withdrawalTextController = TextEditingController();
  final depositamountTextController = TextEditingController();
  final withdrawamountTextController = TextEditingController();
  final dateController = TextEditingController();
  final OthersTextController = TextEditingController();
  final OthersTextFocusNode = FocusNode();
  bool _showClearButton = true;
  bool _showDialog = false;
  bool _otherstextbox = false;
  final currentDate = DateTimeDetails().onlyDatewithFormat();
  String? deposit;
  String? withdrawal;
  String? depositAmt;
  String? withdrawalAmt;
  String? remarks;

//  bool _showClearButton = true;
  String? schtype;
 // TextEditingController date = TextEditingController();
  List<DataEntry_DETAILS> DEDetails = [];


  // final bool showCheckboxColumn=false;

  bool _isTotal = false;

//  bool _isDepositTotal=false;
  // bool _isWithdrawalTotal=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Entry Daily Transaction Report',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFB71C1C),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: SingleChildScrollView(
        child: (Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true),
                          isExpanded: true,
                          iconEnabledColor: Colors.blueGrey,
                          hint: const Text(
                            'Entry Type',
                            style: TextStyle(color: Color(0xFFCFB53B)),
                          ),
                          items: DataEntryTypes.map((String myMenuItem) {
                            return DropdownMenuItem<String>(
                              value: myMenuItem,
                              child: Text(
                                myMenuItem,
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? valueSelectedByUser) {
                            setState(() {
                              selectedType = valueSelectedByUser!;
                              if(selectedType=="DCube")
                                {
                                  _isWdlVisible=true;
                                  _isDepVisible = false;
                                  _otherstextbox=false;
                                }else if(selectedType=="CSC")
                              {
                                _isWdlVisible=false;
                                _isDepVisible = true;
                                _otherstextbox=false;
                              }
                              else{
                                 _isWdlVisible=true;
                                _isDepVisible = true;
                                 _otherstextbox=true;
                              }
                              deposit = null;
                              withdrawal = null;
                              depositAmt = null;
                              withdrawalAmt = null;
                              depositTextController.text = "";
                              depositamountTextController.text = "";
                              withdrawalTextController.text = "";
                              withdrawamountTextController.text = "";
                              OthersTextController.text="";
                            });
                          },
                          value: selectedType,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
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
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
           children: [
             RaisedButton(
              child: Text('Search',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontFamily: "Georgia",
                      letterSpacing: 1)),
              color: Color(0xFFB71C1C),
              //Colors.green,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () async {
                if (dateController.text.isEmpty ||
                    selectedType=="") {
                  print(dateController.text);
                  print(selectedType);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Please select Entry Type and Date..!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        );
                      });}
                else{
                DEDetails = await DataEntry_DETAILS()
                    .select()
                    .TRANSACTION_DATE
                    .equals(dateController.text)
                    .and
                    .ENTRY_TYPE
                    .equals(selectedType)
                    .toList();
                if (DEDetails.isNotEmpty) {
                      deposit = DEDetails[0].TOTAL_DEPOSITS;
                      withdrawal = DEDetails[0].TOTAL_WITHDRAWALS;
                      depositAmt = DEDetails[0].TOTAL_DEPOSIT_AMOUNT;
                      withdrawalAmt = DEDetails[0].TOTAL_WITHDRAWAL_AMOUNT;
                      remarks=DEDetails[0].Remarks;
                      depositTextController.text = deposit!;
                      depositamountTextController.text = depositAmt!;
                      withdrawalTextController.text = withdrawal!;
                      withdrawamountTextController.text = withdrawalAmt!;
                      OthersTextController.text= remarks!;

                } else {
                  deposit = null;
                  withdrawal = null;
                  depositAmt = null;
                  withdrawalAmt = null;
                  depositTextController.text = "";
                  depositamountTextController.text = "";
                  withdrawalTextController.text = "";
                  withdrawamountTextController.text = "";
                  OthersTextController.text="";
                }
                setState(() {
                  // selected = index;
                  // print(selected);
                  _isVisible = true;
                 });
              }
              }),
             SizedBox(
               width: 15,
             ),
             RaisedButton(
               child: Text('Back',
                   style: TextStyle(
                       fontStyle: FontStyle.italic,
                       fontFamily: "Georgia",
                       letterSpacing: 1)),
               color: Color(0xFFB71C1C),
               //Colors.green,
               textColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20),
               ),
               onPressed: () async {
                 Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(
                         builder: (context) =>
                             MainHomeScreen(UtilitiesMainScreen(), 0)),
                         (route) => false);
               }),]
          ),
          Visibility(
            visible: _isVisible,
            child: Column(
              children: [
                Text('$selectedType Transaction Details',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    Visibility(
                      visible:_otherstextbox ,
                      child: CInputForm(
                        readOnly: false,
                        iconData: MdiIcons.textBox,
                        labelText: 'Enter others details',
                        controller: OthersTextController,
                        textType: TextInputType.text,
                        typeValue: 'Others',
                        focusNode: OthersTextFocusNode,
                      ),
                    ),
                    Visibility(
                      visible:_isDepVisible ,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            style: TextStyle(color: Colors.blueGrey),
                            controller: depositTextController,
                            readOnly: currentDate != dateController.text ? true : false,
                            keyboardType:
                            // TextInputType.phone,
                                      TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.account_balance_outlined,
                                  size: 22,
                                ),
                              ),

                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              //      hintText: ' Enter No.of Deposits',

                              hintText: deposit != null
                                  ? deposit
                                  : ' Enter No.of Deposits/Receipts',
                              labelText: "Number of Deposits/Receipts",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              //       suffixIcon: _getClearButton(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isDepVisible,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            style: TextStyle(color: Colors.blueGrey),
                            controller: depositamountTextController,
                            readOnly: currentDate != dateController.text ? true : false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.money_off_sharp,
                                  size: 22,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              //  hintText: ' Enter Deposit Amount',
                              hintText: depositAmt != null
                                  ? depositAmt
                                  : ' Enter Deposit/Receipt Amount',
                              labelText: "Total Deposit/Receipt Amount",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              //    suffixIcon: _getdepositamountClearButton(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 8,),
                    Visibility(
                      visible:_isWdlVisible,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            style: TextStyle(color: Colors.blueGrey),
                            controller: withdrawalTextController,
                            readOnly: currentDate != dateController.text ? true : false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.account_balance_outlined,
                                  size: 22,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              //   hintText: ' Enter No.of Withdrawals',
                              hintText: withdrawal != null
                                  ? withdrawal
                                  : ' Enter No.of Withdrawals',
                              labelText: "Number of withdrawals",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              //    suffixIcon: _getwithdrawClearButton(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isWdlVisible,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextFormField(
                            style: TextStyle(color: Colors.blueGrey),
                            controller: withdrawamountTextController,
                            readOnly: currentDate != dateController.text ? true : false,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.money_off_sharp,
                                  size: 22,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 2, 40, 86),
                                fontWeight: FontWeight.w500,
                              ),
                              // hintText: ' Enter Withdrawal Amount',

                              hintText: withdrawalAmt != null
                                  ? withdrawalAmt
                                  : ' Enter Withdrawal Amount',
                              labelText: "Total Withdrawal Amount",
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.green, width: 1)),
                              contentPadding: EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              //     suffixIcon: _getwithdrawamountClearButton(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),


                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      RaisedButton(
                          child: Text('Submit',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Georgia",
                                  letterSpacing: 1)),
                          color: Color(0xFFB71C1C),
                          //Colors.green,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () async {
                            print("inside submit");
                            _showDialog =false;
                            print("Deposit fields visibility:$_isDepVisible");
                            print("Withdrawl fields visibility:$_isWdlVisible");
                            //if(selectedType=="DCube")
                            if(_isWdlVisible==true && _isDepVisible==false)
                            {
                              if (withdrawalTextController.text.isEmpty ||
                                  withdrawamountTextController.text.isEmpty){
                                _showDialog =true;
                                depositTextController.text ="0";
                                depositamountTextController.text = "0";
                              }

                            }
                            else //if(selectedType=="CSC")
                            if(_isWdlVisible==false && _isDepVisible==true)
                            {
                              if (depositTextController.text.isEmpty ||
                                  depositamountTextController.text.isEmpty) {
                                _showDialog = true;
                                withdrawalTextController.text="0";
                                withdrawamountTextController.text= "0";
                              }
                            }
                            else
                              //if(selectedType=="Others")
                            if(_isWdlVisible==true && _isDepVisible==true)
                            {
                              print("inside others");
                              print(_showDialog);
                              print(depositamountTextController.text);
                              print(depositTextController.text);
                              print(withdrawalTextController.text);
                              print(withdrawamountTextController.text);
                              print(OthersTextController.text);
                              if (depositTextController.text.isEmpty ||
                              depositamountTextController.text.isEmpty ||
                              withdrawalTextController.text.isEmpty ||
                              withdrawamountTextController.text.isEmpty||OthersTextController.text.isEmpty){
                              print(depositamountTextController.text);
                              print(depositTextController.text);
                              print(withdrawalTextController.text);
                              print(withdrawamountTextController.text);
                              print(OthersTextController.text);
                              _showDialog =true;
                              }
                              }
                            else
                              _showDialog =false;
                            if (_showDialog == true) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('Please Enter the Data in all fields..!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.redAccent),
                                      ),
                                    );
                                  });
                              //   UtilFs.showToast("No data found", context);
                            }
                            else {
                              print("inside else");
                              DEDetails = await DataEntry_DETAILS()
                                  .select()
                                  .TRANSACTION_DATE
                                  .equals(dateController.text)
                                  .and
                                  .ENTRY_TYPE
                                  .equals(selectedType)
                                  .toList();
                              print("DEDetails are $DEDetails");
                              if (DEDetails.isEmpty) {
                                final tranDetails = DataEntry_DETAILS()
                                  ..TRANSACTION_DATE = dateController.text
                                  ..TRANSACTION_TIME = DateTimeDetails().oT()
                                  ..ENTRY_TYPE=selectedType
                                  ..TOTAL_DEPOSITS = depositTextController.text
                                  ..TOTAL_DEPOSIT_AMOUNT =
                                      depositamountTextController.text
                                  ..TOTAL_WITHDRAWALS = withdrawalTextController.text
                                  ..TOTAL_WITHDRAWAL_AMOUNT =
                                      withdrawamountTextController.text
                                  ..Remarks= selectedType=="Others" ? OthersTextController.text : "";
                               await tranDetails.save();
                               print(tranDetails);
                                //if(selectedType=="CSC" || selectedType=="Others")
                                if(_isDepVisible==true)
                                {
                                  //Adding to Cash Table
                                  final addCash = CashTable()
                                    ..Cash_ID = '${selectedType}_' +
                                        DateTimeDetails().dateCharacter()
                                    ..Cash_Date = DateTimeDetails()
                                        .currentDate()
                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                    ..Cash_Type = 'Add'
                                    ..Cash_Amount = double.parse(
                                        depositamountTextController.text)
                                    ..Cash_Description = '${selectedType} Deposit';
                                  await addCash.save();

                                  final addTransaction = TransactionTable()
                                    ..tranid = '${selectedType}${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}'
                                    ..tranDescription = "${selectedType} Deposit"
                                    ..tranAmount = double.parse(depositamountTextController.text)
                                    ..tranType = "${selectedType}"
                                    ..tranDate = DateTimeDetails().currentDate()
                                    ..tranTime = DateTimeDetails().onlyTime()
                                    ..valuation = "Add";

                                  await addTransaction.save();
                                }
                                //if(selectedType=="DCube" || selectedType=="Others")
                                if(_isWdlVisible==true)
                                {
                                  //Adding to Cash Table
                                  final minusCash = CashTable()
                                    ..Cash_ID = '${selectedType}_' +
                                        DateTimeDetails().dateCharacter()
                                    ..Cash_Date = DateTimeDetails()
                                        .currentDate()
                                    ..Cash_Time = DateTimeDetails().onlyTime()
                                    ..Cash_Type = 'Add'
                                    ..Cash_Amount = double.parse(
                                        "-${withdrawamountTextController.text}")
                                    ..Cash_Description = '${selectedType} Withdraw';
                                 await  minusCash.save();


                                  var now = DateTime.now();
                                  var formatter = DateFormat('dd-MM-yyyy');
                                  final String formattedTime = DateFormat.jm()
                                      .format(now)
                                      .toString();

                                  //Adding to Transaction Table


                                  final minusTransaction = TransactionTable()
                                    ..tranid = '${selectedType}${DateTimeDetails()
                                        .dateCharacter()}${DateTimeDetails()
                                        .timeCharacter()}'
                                    ..tranDescription = "${selectedType} Withdraw"
                                    ..tranAmount = double.parse(
                                        "-${withdrawamountTextController.text}")
                                    ..tranType = "${selectedType}"
                                    ..tranDate = DateTimeDetails().currentDate()
                                    ..tranTime = DateTimeDetails().onlyTime()
                                    ..valuation = "Add";
                                await  minusTransaction.save();
                                }
                              }
                              else {
                                // currentDate=    await DateTimeDetails().onlyDatewithFormat();
                                if (currentDate != dateController.text) {
                                  UtilFs.showToast("Modification not allowed for previous date",
                                      context);
                                  depositTextController.text = deposit!;
                                  depositamountTextController.text = depositAmt!;
                                  withdrawalTextController.text = withdrawal!;
                                  withdrawamountTextController.text = withdrawalAmt!;
                                  OthersTextController.text=remarks!;
                                  //  isredirect=false;
                                }
                                else {
                                  final result = await DataEntry_DETAILS()
                                      .select()
                                      .TRANSACTION_DATE
                                      .equals(dateController.text)
                                      .and
                                      .ENTRY_TYPE
                                      .equals(selectedType)
                                      .update({
                                    "TOTAL_DEPOSITS": depositTextController.text,
                                    "TOTAL_DEPOSIT_AMOUNT":
                                    depositamountTextController.text,
                                    "ENTRY_TYPE" :selectedType,
                                    "TOTAL_WITHDRAWALS":
                                    withdrawalTextController.text,
                                    "TOTAL_WITHDRAWAL_AMOUNT":
                                    withdrawamountTextController.text,
                                    "Remarks": selectedType=="Others" ? OthersTextController.text : "",
                                    "TRANSACTION_TIME" : DateTimeDetails().oT()
                                  });
                                  print(result.toString());
                                  //if(selectedType=="CSC" || selectedType=="Others")
                                  if(_isDepVisible==true)
                                  {
                                    //Adding to Cash Table
                                    final updateaddCash = await CashTable()
                                        .select()
                                        .Cash_ID
                                        .equals('${selectedType}_' +
                                        DateTimeDetails().dateCharacter())
                                        .and
                                        .startBlock
                                        .Cash_Description
                                        .equals('${selectedType} Deposit')
                                        .endBlock
                                        .update({
                                      "Cash_Amount": double.parse(
                                          depositamountTextController.text),
                                      "CASH_TIME":DateTimeDetails().onlyTime()
                                    });
                                    print(updateaddCash);

                                    final updateaddTransaction = await TransactionTable().select()
                                         .tranType.equals(selectedType)
                                         .and.tranDate.equals(dateController.text)
                                        .and.tranDescription.contains("Deposit")
                                        // .tranid.equals('${selectedType}${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}')
                                        // .and.startBlock.tranDescription.equals("${selectedType} Deposit").endBlock
                                        .update({"tranAmount":double.parse(depositamountTextController.text),
                                        "tranid":'${selectedType}${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
                                         "trantime": DateTimeDetails().onlyTime() });

                                    print(updateaddTransaction);
                                  }
                                  //if( selectedType=="DCube" || selectedType=="Others")
                                  if(_isWdlVisible==true)
                                  {
                                    final updateminusCash = await CashTable()
                                        .select()
                                        .Cash_ID
                                        .equals('${selectedType}_' +
                                        DateTimeDetails().dateCharacter())
                                        .and
                                        .startBlock
                                        .Cash_Description
                                        .equals('${selectedType} Withdraw')
                                        .endBlock
                                        .update({
                                      "Cash_Amount": double.parse(
                                          "-${withdrawamountTextController
                                              .text}"),
                                      "CASH_TIME":DateTimeDetails().onlyTime()
                                    });
                                    print(updateminusCash);
                                    final updateminusTransaction = await TransactionTable().select()
                                        .tranType.equals(selectedType)
                                        .and.tranDate.equals(dateController.text)
                                        .and.tranDescription.contains("Withdraw")
                                        // .tranid.equals('${selectedType}${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}')
                                        // .and.startBlock.tranDescription.equals("${selectedType} Withdraw").endBlock
                                        .update({"tranAmount":double.parse("-${withdrawamountTextController.text}"),
                                      "tranid":'${selectedType}${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
                                      "trantime": DateTimeDetails().onlyTime()});
                                    print(updateminusTransaction);
                                  }
                                }
                              }

                              //print all table details
                              print("DataEntry_DETAILS are:");
                             print(await DataEntry_DETAILS()
                                 .select().toMapList());
                              print("Cash details are:");
                              print(await CashTable()
                                  .select().toMapList());
                              print("Transaction details are:");
                              print(await TransactionTable()
                                  .select().toMapList());
                              UtilFs.showToast("Data Submitted Sucessfully.. !", context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DataEntryDatReport( )));

                            } //      bool isredirect=true;
                                }
                          ),

                      SizedBox(
                        width: 15,
                      ),
                      RaisedButton(
                        child: Text('Cancel',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontFamily: "Georgia",
                                letterSpacing: 1)),

                        color: Color(0xFFB71C1C),

                        //Colors.green,

                        textColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),

                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyCardsScreen(false)));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MainHomeScreen(UtilitiesMainScreen(), 0)),
                              (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        ])),
      ),
    );
  }

  Widget? _getClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   isVisible=false;
          // }),
          depositTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Future<void> _selectDailyTranReportDate(BuildContext context) async {
    try {
      final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2003),
        lastDate: DateTime.now(),
      );
      if (d != null) {
        setState(() {
          var formatter = new DateFormat('dd-MM-yyyy');
          dateController.text = formatter.format(d);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Widget? _getwithdrawClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          withdrawalTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget? _getdepositamountClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          depositamountTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }

  Widget? _getwithdrawamountClearButton() {
    if (!_showClearButton) {
      return null;
    }
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: IconButton(
        //onPressed: () => widget.controller.clear(),
        onPressed: () => {
          // setState(() {
          //   _isVisible=false;
          // }),
          withdrawamountTextController.clear()
        },
        icon: Icon(
          Icons.clear,
          color: Colors.black,
          size: 22,
        ),
      ),
    );
  }
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
        dateController.text = formatter.format(d);
      });
    }
  }
}
