import 'dart:async';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SMSReading extends StatefulWidget {
  const SMSReading({Key? key}) : super(key: key);

  @override
  State<SMSReading> createState() => _SMSReading();
}

class _SMSReading extends State<SMSReading> {
  final textEditingController1 = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _comingSms = 'Unknown';

  @override
  void initState() {
    super.initState();
    initSmsListener();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms!;
      print("====>Message: ${_comingSms}");
      print("${_comingSms[16]}");

      final split = _comingSms.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      print(values); // {0: grubs, 1:  sheep}

      final firstContent = values[0];
      final secondContent = values[1];
      final thirdContent = values[2];
      // int? l1 = firstContent?.length;
      // int? l2 = secondContent?.length;
      print("...............");

      print(secondContent);
      final otp = secondContent?.substring(
          secondContent.length - 6, secondContent.length);
      print("otp is - " + otp.toString());
      final smsSign =
          thirdContent?.substring(thirdContent.length - 7, thirdContent.length);
      print("SMS Signature is -" + smsSign.toString());
      if (smsSign.toString() == "INDPOST") textEditingController1.text = otp!;
      //+ _comingSms[36] + _comingSms[37]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        inactiveFillColor: Colors.white,
                        inactiveColor: Colors.blueGrey,
                        selectedColor: Colors.blueGrey,
                        selectedFillColor: Colors.white,
                        activeFillColor: Colors.white,
                        activeColor: Colors.blueGrey),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: textEditingController1,
                    keyboardType: TextInputType.number,
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    onCompleted: (v) {
                      //do something or move to next screen when code complete
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        print('$value');
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
