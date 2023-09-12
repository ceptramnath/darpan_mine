import 'package:darpan_mine/Delivery/Screens/CustomAppBar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomScannerSelectDialog.dart';
import 'HeadingBox.dart';

class SettingsScreen extends StatefulWidget {
  int? selectedScanner;

  SettingsScreen([this.selectedScanner]);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? scannerType = "Vision Scanner";
  Future? getData;

  @override
  void initState() {
    getData = getSharedPreferences();
    super.initState();
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int scannerValue = prefs.getInt('scanner_value') ?? 4;
    setState(() {
      // scannerValue == 0
      //     ? scannerType = 'QR & Barcode scanner'
      //     : scannerType = 'Barras Scanner';

      if (scannerValue == 0) {
        scannerType = 'Vision Scanner';
      } else if (scannerValue == 1) {
        scannerType = 'QR & Barcode scanner';
      } else if (scannerValue == 2) {
        scannerType = 'Barras Scanner';
      } else if (scannerValue == 3) {
        scannerType = 'ML Scanner';
      } else if (scannerValue == 4) {
        scannerType = 'ZXing Scanner';
      }
    });

    return scannerValue;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(
        appbarTitle: 'Settings',
      ),
      body: FutureBuilder(
          future: getData,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    HeadingBox(
                      headingTitle: 'Barcode Scanner',
                    ),
                    Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            MdiIcons.scanner,
                            color: Colors.greenAccent,
                          ),
                          title: GestureDetector(
                            onTap: _showScannerSelectionDialog,
                            child: Text(
                              'Use',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: _showScannerSelectionDialog,
                            child: Text(
                              scannerType!,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  _showScannerSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomScannerSelectDialog();
      },
    ).then((value) {
      setState(() {
        scannerType = value ?? scannerType;
      });
    });
  }
}
