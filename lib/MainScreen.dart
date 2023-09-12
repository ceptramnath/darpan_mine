import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagOpenScreen.dart';
import 'package:darpan_mine/Mails/Booking/Parcel/Screens/ParcelBookingScreen.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/CustomExpansionTIle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:scanner_plugin/scanner_plugin.dart';

import 'Mails/Booking/EMO/Screens/EMOMainScreen.dart';
import 'Mails/Booking/RegisterLetter/Screens/RegisterLetterBookingScreen1.dart';
import 'Mails/Booking/SpeedPost/Screens/SpeedPostScreen.dart';
import 'Widgets/UITools.dart';

class MainScreen extends StatefulWidget {
  // var fees;
  // MainScreen({Key? key, required this.fees}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  String _scanBarcode = 'Unknown';

  bool isSelected = false;
  bool mailsVisibility = false;
  bool bookingVisibility = false;
  bool deliveryVisibility = false;
  bool baggingVisibility = false;
  bool bagOpenVisibility = false;
  bool bagCloseVisibility = false;
  bool bankingVisibility = false;
  bool sbVisibility = false;
  bool insuranceVisibility = false;

  int? _selectedHeadingIndex;
  int? _selectedMailIndex;
  int? _selectedBookingIndex;
  int? _selectedDeliveryIndex;
  int? _selectedBaggingIndex;
  int? _selectedBankingIndex;
  int? _selectedSavingsBankIndex;
  int? _selectedinsuranceIndex;

  final bagOpenController = TextEditingController();
  final bagCloseController = TextEditingController();

  final GlobalKey<FormExpansionTileCardState> mailExpansion = new GlobalKey();
  final GlobalKey<FormExpansionTileCardState> bankingExpansion =
      new GlobalKey();
  final GlobalKey<FormExpansionTileCardState> insuranceExpansion =
      new GlobalKey();

  mailsFalse() {
    mailsVisibility = false;
    bookingVisibility = false;
    deliveryVisibility = false;
    baggingVisibility = false;
    bagOpenVisibility = false;
    bagCloseVisibility = false;
  }

  bankingFalse() {
    bankingVisibility = false;
    sbVisibility = false;
  }

  allFalse() {
    mailsFalse();
    bankingFalse();
    insuranceVisibility = false;
  }

  _buildHeadingChips() {
    List<Widget> chips = [];
    for (int i = 0; i < heading.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(heading[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedHeadingIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedHeadingIndex = i;
              print(_selectedHeadingIndex);
              if (_selectedHeadingIndex == 0) {
                mailsVisibility = true;
                bankingFalse();
                insuranceVisibility = false;
              } else if (_selectedHeadingIndex == 1) {
                mailsFalse();
                bankingVisibility = true;
                insuranceVisibility = false;
              } else if (_selectedHeadingIndex == 2) {
                mailsFalse();
                bankingFalse();
                insuranceVisibility = true;
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildMailChips() {
    List<Widget> chips = [];
    for (int i = 0; i < mailOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(mailOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedMailIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedMailIndex = i;
              if (_selectedMailIndex == 0) {
                bookingVisibility = true;
                deliveryVisibility = false;
                bankingVisibility = false;
              } else if (_selectedMailIndex == 1) {
                bookingVisibility = false;
                deliveryVisibility = true;
                baggingVisibility = false;
              } else if (_selectedMailIndex == 2) {
                bookingVisibility = false;
                deliveryVisibility = false;
                baggingVisibility = true;
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildBookingChips() {
    List<Widget> chips = [];
    for (int i = 0; i < bookingOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(bookingOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedBookingIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedBookingIndex = i;
              if (_selectedBookingIndex == 0) {
                _selectedBookingIndex = null;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RegisterLetterBookingScreen1(
                              fees: 17,
                            )));
              } else if (_selectedBookingIndex == 1) {
                _selectedBookingIndex = null;
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SpeedPostScreen()));
              } else if (_selectedBookingIndex == 2) {
                _selectedBookingIndex = null;
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EMOMainScreen()));
              } else if (_selectedBookingIndex == 3) {
                _selectedBookingIndex = null;
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ParcelBookingScreen()));
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildDeliveryChips() {
    List<Widget> chips = [];
    for (int i = 0; i < deliveryOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(deliveryOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedDeliveryIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedDeliveryIndex = i;
              if (_selectedDeliveryIndex == 0) {
                print("Accountable Articles");
              } else if (_selectedMailIndex == 1) {
                print("EMO");
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildBaggingChips() {
    List<Widget> chips = [];
    for (int i = 0; i < baggingOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(baggingOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedBaggingIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedBaggingIndex = i;
              if (_selectedBaggingIndex == 0) {
                print("Bag Open");
                bagOpenVisibility = true;
                bagCloseVisibility = false;
              } else if (_selectedBaggingIndex == 1) {
                print("Bag Close");
                bagOpenVisibility = false;
                bagCloseVisibility = true;
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildBankingChips() {
    List<Widget> chips = [];
    for (int i = 0; i < bankingOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(bankingOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedBankingIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedBankingIndex = i;
              if (_selectedBankingIndex == 0) {
                sbVisibility = true;
              } else if (_selectedBankingIndex == 1) {
                sbVisibility = false;
                print("RD");
              } else if (_selectedBankingIndex == 2) {
                sbVisibility = false;
                print("SSA");
              } else if (_selectedBankingIndex == 3) {
                sbVisibility = false;
                print("TD");
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildSBChips() {
    List<Widget> chips = [];
    for (int i = 0; i < savingsBankOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(savingsBankOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedSavingsBankIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedSavingsBankIndex = i;
              if (_selectedBankingIndex == 0) {
                print("Premium Collector");
              } else if (_selectedBankingIndex == 1) {
                print("Index");
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  _buildinsuranceChips() {
    List<Widget> chips = [];
    for (int i = 0; i < insuranceOptions.length; i++) {
      ChoiceChip chip = ChoiceChip(
        label: Text(insuranceOptions[i]),
        labelStyle: TextStyle(
            fontSize: 15.toDouble(),
            color: Colors.black54,
            letterSpacing: 1),
        selected: _selectedinsuranceIndex == i,
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.black54,
        backgroundColor: Colors.redAccent.withOpacity(.2),
        selectedColor: ColorConstants.kPrimaryAccent,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedinsuranceIndex = i;
              if (_selectedBankingIndex == 0) {
                print("Premium Calculator");
              } else if (_selectedBankingIndex == 1) {
                print("Index");
              }
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.toDouble()),
        child: chip,
      ));
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.kPrimaryColor,
        title: Text(
          'DARPAN',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.toDouble()),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DoubleSpace(),

                //Heading
                Wrap(children: _buildHeadingChips()),
                DoubleSpace(),

                /*---------------Mails---------------*/
                Visibility(
                  visible: mailsVisibility,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Mails',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.kSecondaryColor,
                                fontSize: 20.toDouble(),
                                letterSpacing: 1),
                          ),
                        ),
                        Wrap(
                          children: _buildMailChips(),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: bookingVisibility,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                      child: Column(
                        children: [
                          DoubleSpace(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Booking',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.kSecondaryColor,
                                  fontSize: 20.toDouble(),
                                  letterSpacing: 1),
                            ),
                          ),
                          Space(),
                          Wrap(
                            children: _buildBookingChips(),
                          )
                        ],
                      ),
                    )),
                Visibility(
                    visible: deliveryVisibility,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                      child: Column(
                        children: [
                          DoubleSpace(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Delivery',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.kSecondaryColor,
                                  fontSize: 20.toDouble(),
                                  letterSpacing: 1),
                            ),
                          ),
                          Space(),
                          Wrap(
                            children: _buildDeliveryChips(),
                          )
                        ],
                      ),
                    )),
                Visibility(
                    visible: baggingVisibility,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                      child: Column(
                        children: [
                          DoubleSpace(),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Bagging',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.kSecondaryColor,
                                  fontSize: 20.toDouble(),
                                  letterSpacing: 1),
                            ),
                          ),
                          Space(),
                          Wrap(
                            children: _buildBaggingChips(),
                          )
                        ],
                      ),
                    )),
                Visibility(
                  visible: bagOpenVisibility,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.toDouble(), vertical: 20.toDouble()),
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: null,
                          maxLength: 13,
                          controller: bagOpenController,
                          style:
                              TextStyle(color: ColorConstants.kSecondaryColor),
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              counterText: '',
                              fillColor: ColorConstants.kWhite,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstants.kWhite),
                              ),
                              prefixIcon: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.toDouble()),
                                  margin:
                                      EdgeInsets.only(right: 8.0.toDouble()),
                                  decoration: BoxDecoration(
                                    color: ColorConstants.kSecondaryColor,
                                  ),
                                  child: IconButton(
                                    onPressed: scanBarcodeNormal,
                                    icon: Icon(
                                      MdiIcons.barcodeScan,
                                      color: ColorConstants.kWhite,
                                    ),
                                  )),
                              suffixIcon: bagOpenController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        MdiIcons.closeCircleOutline,
                                        color: ColorConstants.kSecondaryColor,
                                      ),
                                      onPressed: () {
                                        bagOpenController.clear();
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : null,
                              labelStyle: TextStyle(
                                  color: ColorConstants.kAmberAccentColor),
                              labelText: 'Bag Number',
                              contentPadding: EdgeInsets.all(15.0.toDouble()),
                              isDense: true,
                              // border: InputBorder.none

                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstants.kWhite),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0.toDouble()),
                                    bottomLeft:
                                        Radius.circular(30.0.toDouble()),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorConstants.kWhite),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0.toDouble()),
                                    bottomLeft:
                                        Radius.circular(30.0.toDouble()),
                                  ))),
                          validator: (text) {
                            if (text!.length != 13)
                              return 'Bag length should be of 13 characters';
                            else if (!text.startsWith('L', 0))
                              return 'Should start with LBK';
                            else if (!text.startsWith('B', 1))
                              return 'Should start with LBK';
                            else if (!text.startsWith('K', 2))
                              return 'Should start with LBK';
                            return null;
                          },
                        ),
                        SizedBox(
                          width: 10.toDouble(),
                        ),
                        Button(
                            buttonText: 'Bag Open',
                            buttonFunction: () {
                              if (bagOpenController.text.isEmpty)
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Enter the Bag Number'),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              else if (bagOpenController.text.length != 13 ||
                                  !bagOpenController.text.startsWith('L', 0) ||
                                  !bagOpenController.text.startsWith('B', 1) ||
                                  !bagOpenController.text.startsWith('K', 2)) {
                                print("Not Valid");
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BagOpenScreen()));
                              }
                            })
                      ],
                    ),
                  ),
                ),
                /*-----------------------------------*/

                /*--------------Banking--------------*/
                Visibility(
                    visible: bankingVisibility,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Banking',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.kSecondaryColor,
                                fontSize: 20.toDouble(),
                                letterSpacing: 1),
                          ),
                        ),
                        Space(),
                        Wrap(
                          children: _buildBankingChips(),
                        )
                      ],
                    )),
                Visibility(
                    visible: sbVisibility,
                    child: Column(
                      children: [
                        DoubleSpace(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Savings Bank',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.kSecondaryColor,
                                fontSize: 20.toDouble(),
                                letterSpacing: 1),
                          ),
                        ),
                        Space(),
                        Wrap(
                          children: _buildSBChips(),
                        )
                      ],
                    )),
                /*-----------------------------------*/

                /*-------------insurance-------------*/
                Visibility(
                    visible: insuranceVisibility,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'insurance',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.kSecondaryColor,
                                fontSize: 20.toDouble(),
                                letterSpacing: 1),
                          ),
                        ),
                        Space(),
                        Wrap(
                          children: _buildinsuranceChips(),
                        )
                      ],
                    )),
                /*-----------------------------------*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await ScannerPlugin.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes.length == 13 &&
        barcodeScanRes.startsWith('L', 0) &&
        barcodeScanRes.startsWith('B', 1) &&
        barcodeScanRes.startsWith('K', 2)) {
      setState(() {
        bagOpenController.text = barcodeScanRes;
      });
    }

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
