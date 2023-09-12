import 'package:darpan_mine/CBS/NewAccountOpening/sbaccopen.dart';
import 'package:darpan_mine/CBS/screens/my_cards_screen.dart';

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../../HomeScreen.dart';

class AccountOpenMain extends StatefulWidget {
  @override
  _AccountOpenMainState createState() => _AccountOpenMainState();
}

enum Schemes { sb, rd, td, ssa }

class _AccountOpenMainState extends State<AccountOpenMain> {
  String _verticalGroupValue = "SB";

  List<String> _status = ["SB", "RD", "TD", "SSA"];

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(MyCardsScreen(false), 2)),
            (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Schemes? _selectedScheme=Schemes.sb;
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'New A/C Opening',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: const Color(0xFFB71C1C),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Column(
              //    children: [
              //      ListTile(
              //        title: const Text('SB'),
              //        leading: Radio(
              //          value: Schemes.sb,
              //          groupValue: _selectedScheme,
              //          onChanged: (Schemes? value) {
              //            setState(() {
              //              _selectedScheme = value;
              //            });
              //          },
              //        ),
              //      ),
              //      ListTile(
              //        title: const Text('RD'),
              //        leading: Radio(
              //          value: Schemes.rd,
              //          groupValue: _selectedScheme,
              //          onChanged: (Schemes? value) {
              //            setState(() {
              //              _selectedScheme = value!;
              //            });
              //            print(value);
              //            print(_selectedScheme);
              //          },
              //        ),
              //      ),
              //      ListTile(
              //        title: const Text('TD'),
              //        leading: Radio(
              //          value: Schemes.td,
              //          groupValue: _selectedScheme,
              //          onChanged: (Schemes? value) {
              //            setState(() {
              //              _selectedScheme = value;
              //            });
              //          },
              //        ),
              //      ),
              //      ListTile(
              //        title: const Text('SSA'),
              //        leading: Radio(
              //          value: Schemes.ssa,
              //          groupValue: _selectedScheme,
              //          onChanged: (Schemes? value) {
              //            setState(() {
              //              _selectedScheme = value;
              //            });
              //          },
              //        ),
              //      ),
              //    ],
              // ),

              RadioGroup<String>.builder(
                direction: Axis.horizontal,
                groupValue: _verticalGroupValue,
                onChanged: (value) => setState(() {
                  _verticalGroupValue = value!;
                }),
                items: _status,
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
              TextButton(
                child: Text("Proceed"),
                style: TextButton.styleFrom(
                    elevation: 5.0,
                    textStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontFamily: "Georgia",
                        letterSpacing: 1),
                    backgroundColor: Color(0xFFCC0000),
                    primary: Colors.white),
                onPressed: () async {
                  // if(_selectedscheme==Schemes.SB){
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => ()
                  //       )
                  //   );
                  // }
                  // if(_selectedscheme==Schemes.RD){
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => ()
                  //       )
                  //   );
                  // }
                  // if(_selectedscheme==Schemes.TD){
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => ()
                  //       )
                  //   );
                  // }
                  // if(_verticalGroupValue=="SSA"){
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => SSAAccountOpenMain()
                  //       )
                  //   );
                  // }
                  // if(_verticalGroupValue=="RD"){
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (_) => RDAccountOpenMain()
                  //       )
                  //   );
                  // }
                  // else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              SBAccountOpenMain(_verticalGroupValue)));
                  // }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
