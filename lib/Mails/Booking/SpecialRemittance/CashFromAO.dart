import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../HomeScreen.dart';
import '../../../UtilitiesMainScreen.dart';

class CashFromAOScreen extends StatefulWidget {
  const CashFromAOScreen({Key? key}) : super(key: key);

  @override
  _CashFromAOScreenState createState() => _CashFromAOScreenState();
}

class _CashFromAOScreenState extends State<CashFromAOScreen> {
  final remittanceFocus = FocusNode();

  final remittanceController = TextEditingController();

  int fetchCash =0;




  void conformation() async {

    fetchCash = await CashTable().select()
        .Cash_ID.equals("CashFromAO_${DateTimeDetails().dateCharacter()}").toCount();

    final fetchBoda = await BodaBrief().select()
        .BodaGeneratedDate.equals(DateTimeDetails().currentDate()).toCount();


    if (remittanceController.text.isEmpty || remittanceController.text=="0")
      {
        UtilFs.showToast("Please enter Amount received from Account Office..!", context);
      }

    //if already Cash from AO for the day is already entered.
    else if (fetchCash>0)
      {
        UtilFs.showToast("Already amount is received from Account Office for the day..!", context);

      }
    // if BODA is generated for the day.
    else if(fetchBoda>0)
      {
        UtilFs.showToast("Cash can't be received after BODA generation..!", context);
      }
    else {
      var dateTimeId = DateTimeDetails().cbsdatetime();

      BookingDBService().addTransaction(
        'CashFromAO_${DateTimeDetails().dateCharacter()}',
        'Special Remittance', 'Cash From AO', DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(), remittanceController.text, 'Add');

    final addCash =  CashTable()
      ..Cash_ID = "CashFromAO_${DateTimeDetails().dateCharacter()}"
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = 'Add'
      ..Cash_Amount = double.parse(remittanceController.text)
      ..Cash_Description = 'Cash From AO';
    await addCash.save();

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'Rs. ${remittanceController
                    .text} received successfully from Account Office.',
                style: TextStyle(letterSpacing: 2),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainHomeScreen(MailsMainScreen(), 1)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),

              Text("Please Note:",
                  style: TextStyle(color: Colors.redAccent,fontSize: 16,fontWeight: FontWeight.w600)),

              SizedBox(height: 5,),

              Text("Amount once received can't be modified.\n"
                  "Amount can't be received after BODA Generation.",
                  style: TextStyle(color: Colors.blueGrey,fontSize: 16)),
              // Text("* Amount can't be received once BODA Generated.", style: TextStyle(color: Colors.blueGrey,fontSize: 16)),

              SizedBox(height: 10,),

              CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.currencyInr,
                  labelText: 'Cash From AO',
                  controller: remittanceController,
                  textType: TextInputType.number,
                  typeValue: 'Remittance',
                  focusNode: remittanceFocus),

              Button(buttonText: 'SUBMIT', buttonFunction: () => conformation())
            ],
          ),
        ),
      ),
    );
  }
}
