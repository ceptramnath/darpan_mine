import 'package:darpan_mine/Delivery/Screens/shared_preference_service.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomButton.dart';
import 'SettingsScreen.dart';

class CustomScannerSelectDialog extends StatefulWidget {
  @override
  _CustomScannerSelectDialogState createState() =>
      _CustomScannerSelectDialogState();
}

class _CustomScannerSelectDialogState extends State<CustomScannerSelectDialog> {
  int? selectedRadio;
  int? radioPrefsValue;

  String? selectedRadioString;
  Future? getData;

  @override
  void initState() {
    getData = getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = _prefs.getInt('scanner_value') ?? 4;
      radioPrefsValue = selectedRadio;
      // selectedRadio == 0 ? selectedRadioString = 'QR & Barcode scanner' : selectedRadioString = 'Barras Scanner';
      if (selectedRadio == 0) {
        selectedRadioString = 'Vision Scanner';
      }
      if (selectedRadio == 1) {
        selectedRadioString = 'QR & Barcode scanner';
      }
      if (selectedRadio == 2) {
        selectedRadioString = 'Barras Scanner';
      }
      if (selectedRadio == 3) {
        selectedRadioString = 'ML Scanner';
      }
      if (selectedRadio == 4) {
        selectedRadioString = 'ZXing Scanner';
      }
    });
    return selectedRadio;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text('No data found'),
              ),
            );
          } else {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, top: 40, right: 20, bottom: 20),
                    margin: EdgeInsets.only(top: 40),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 10),
                              blurRadius: 10),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Select the Scanner type',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ListTile(
                          title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setSelectedRadio(0);
                                });
                              },
                              child: const Text('Vision Scanner')),
                          leading: Radio(
                            activeColor: Color(0xFFCC0000),
                            value: 0,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        ListTile(
                          title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setSelectedRadio(1);
                                });
                              },
                              child: const Text('QR & Barcode scanner')),
                          leading: Radio(
                            activeColor: Color(0xFFCC0000),
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        ListTile(
                          title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setSelectedRadio(2);
                                });
                              },
                              child: const Text('Barras Scanner')),
                          leading: Radio(
                            activeColor: Color(0xFFCC0000),
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        ListTile(
                          title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setSelectedRadio(3);
                                });
                              },
                              child: const Text('ML Scanner')),
                          leading: Radio(
                            activeColor: Color(0xFFCC0000),
                            value: 3,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        ListTile(
                          title: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setSelectedRadio(4);
                                });
                              },
                              child: const Text('ZXing Scanner')),
                          leading: Radio(
                            activeColor: Color(0xFFCC0000),
                            value: 4,
                            groupValue: selectedRadio,
                            onChanged: (int? val) {
                              setSelectedRadio(val);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomButton(
                              buttonText: 'CANCEL',
                              buttonFunction: () {
                                // radioPrefsValue == 0 ? selectedRadioString = 'QR & Barcode scanner' : selectedRadioString = 'Barras Scanner';
                                if (radioPrefsValue == 0) {
                                  selectedRadioString = 'Vision Scanner';
                                }
                                if (radioPrefsValue == 1) {
                                  selectedRadioString = 'QR & Barcode scanner';
                                }
                                if (radioPrefsValue == 2) {
                                  selectedRadioString = 'Barras Scanner';
                                }
                                if (radioPrefsValue == 3) {
                                  selectedRadioString = 'ML Scanner';
                                }
                                if (radioPrefsValue == 4) {
                                  selectedRadioString = 'ZXing Scanner';
                                }
                                Navigator.pop(context, selectedRadioString);
                              },
                            ),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.blueGrey)),
                              textColor: Color(0xFFCD853F),
                              color: Colors.white,
                              onPressed: () {
                                // selectedRadio == 0 ? selectedRadioString = 'QR & Barcode scanner' : selectedRadioString = 'Barras Scanner';
                                if (selectedRadio == 0) {
                                  selectedRadioString = 'Vision Scanner';
                                }
                                if (selectedRadio == 1) {
                                  selectedRadioString = 'QR & Barcode scanner';
                                }
                                if (selectedRadio == 2) {
                                  selectedRadioString = 'Barras Scanner';
                                }
                                if (selectedRadio == 3) {
                                  selectedRadioString = 'ML Scanner';
                                }
                                if (selectedRadio == 4) {
                                  selectedRadioString = 'ZXing Scanner';
                                }
                                SharedPreferenceService()
                                    .setScannerType(selectedRadio);
                                Navigator.pop(context, selectedRadioString);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsScreen(selectedRadio)));
                                return;
                              },
                              child: new Text(
                                'ACCEPT',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 40,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Image.asset(
                            "assets/images/ic_arrows.png",
                          )),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  setSelectedRadio(int? val) {
    setState(() {
      selectedRadio = val;
    });
  }
}
