import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RequestCreationScreen extends StatefulWidget {
  const RequestCreationScreen({Key? key}) : super(key: key);

  @override
  _RequestCreationScreenState createState() => _RequestCreationScreenState();
}

class _RequestCreationScreenState extends State<RequestCreationScreen> {
  final remittanceFocus = FocusNode();

  final remittanceController = TextEditingController();

  void conformation() async {
    final ofcMaster = await OFCMASTERDATA().select().toList();

    var dateTimeId = DateTimeDetails().filetimeformat();
    final addSpecialRemittance = SpecialRemittanceFile()
      ..SlipNumber = 'SR$dateTimeId'
      ..Date = DateTimeDetails().oD()
      ..ChequeNumber = ''
      ..BOProfitName = ofcMaster[0].BOName
      ..SOProfitName = ofcMaster[0].AOName
      ..CashAmount = remittanceController.text
      ..Weight = ''
      ..ChequeAmount = '0.00'
      ..ChequeCash = 'CASH';
    await addSpecialRemittance.save();

    /*BookingDBService().addTransaction(
        'BOOK${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Booking', 'Special Remittance', DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(), remittanceController.text, 'Add');

    final addCash =  CashTable()
      ..Cash_ID = DateTimeDetails().dateCharacter()+DateTimeDetails().timeCharacter()
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = 'Add'
      ..Cash_Amount = double.parse(remittanceController.text)
      ..Cash_Description = 'Special Remittance';
    await addCash.save();*/

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Special Remittance Request Generated Successfully.\n\nReference ID - SR$dateTimeId',
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
                            builder: (_) => const BookingMainScreen()),
                        (route) => false);
                  },
                  child: const Text('OKAY'),
                ),
              ),
            ],
          );
        });
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
              CInputForm(
                  readOnly: false,
                  iconData: MdiIcons.currencyInr,
                  labelText: 'Remittance Cash',
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
