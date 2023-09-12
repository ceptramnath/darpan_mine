import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final amountFocus = FocusNode();
  final reasonFocus = FocusNode();

  final amountController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                CInputForm(
                    readOnly: false,
                    iconData: MdiIcons.currencyInr,
                    labelText: 'Miscellaneous Payments*',
                    controller: amountController,
                    textType: TextInputType.number,
                    typeValue: 'Amount',
                    focusNode: amountFocus),
                Space(),
                CInputForm(
                    readOnly: false,
                    iconData: Icons.help_outline,
                    labelText: 'Reason*',
                    controller: reasonController,
                    textType: TextInputType.text,
                    typeValue: 'Reason',
                    focusNode: reasonFocus),
                DoubleSpace(),
                Button(
                    buttonText: 'SUBMIT', buttonFunction: () => conformation())
              ],
            ),
          ),
        ),
      ),
    );
  }

  void conformation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Data Saved Successfully',
              style: TextStyle(letterSpacing: 2),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OKAY'),
                ),
              ),
            ],
          );
        });
  }
}
