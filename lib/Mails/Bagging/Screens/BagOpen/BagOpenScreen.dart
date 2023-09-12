import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Utils/barcodeValidation.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../BaggingServices.dart';
import 'BagAddDetailsReplicaLatest.dart';
import 'BagAddDetailsReplicaLatest.dart';

class BagOpenScreen extends StatefulWidget {
  @override
  _BagOpenScreenState createState() => _BagOpenScreenState();
}

class _BagOpenScreenState extends State<BagOpenScreen> {
  final bagController = TextEditingController();

  final bagFocus = FocusNode();

  var date = DateTimeDetails().onlyDate();
  var time = DateTimeDetails().onlyTime();
  final boslipController = TextEditingController();
  FocusNode boslipfocus = FocusNode();

  @override
  void initState() {
    _showDialog();
    super.initState();
  }

  scanBarcode() async {
    var scan = await Scan().scanBag();
    setState(() {
      bagController.text = scan;
    });
  }

  _showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.toDouble()))),
            elevation: 0,
            backgroundColor: ColorConstants.kWhite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0.toDouble()),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Image.asset('assets/images/ic_logo.png')),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'INDIA POST',
                                style: TextStyle(
                                    fontSize: 25,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text('Ministry Of Communication')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const DottedLine(),
                  SizedBox(
                    height: 20.toDouble(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Enter the Bag Details',
                              style: TextStyle(
                                  color: ColorConstants.kTextDark,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w500),
                            )),
                        const Space(),
                        ScanTextFormField(
                          type: 'Bag',
                          title: 'Bag Number',
                          focus: bagFocus,
                          controller: bagController,
                          scanFunction: scanBarcode,
                        ),
                        const Space(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Button(
                                buttonText: 'CONFIRM',
                                buttonFunction: () async {
                                  if (bagController.text.isEmpty) {
                                    // Navigator.of(context).pop();
                                    Toast.showFloatingToast(
                                        'Bag number cannot be empty..!',
                                        context);
                                  }
                                  //adding Bag Barcode validation
                                  else if(bgval.validate(bagController.text) != "Valid")
                                  {
                                  Toast.showFloatingToast(
                                  'Please enter a valid barcode !',
                                  context);
                                  bagFocus.requestFocus();
                                  }
                                  else {
                                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => BagAddDetailsReplica(bagNumber: bagController.text.toUpperCase(),)), (route) => false);
                                    final isBagPresent = await BagTable()
                                        .select()
                                        .BagNumber
                                        .equals(bagController.text)
                                        .toMapList();
                                    print('bag Details in local DB- ' +
                                        isBagPresent.length.toString());
                                    if (isBagPresent.isEmpty) {
                                      print(
                                          'when bag is not present inside if condition');
                                      final bag = BagTable()
                                        ..BagNumber =
                                            bagController.text.toUpperCase()
                                        ..BagDate =
                                            DateTimeDetails().currentDate()
                                        ..BagTime = DateTimeDetails().onlyTime()
                                        ..BagType = 'Open';

                                      bag.save();
                                      print('after save');

                                      print('checking in Delivery Table..!');
                                      final isVirtualReceived = await Delivery()
                                          .select()
                                          .BAG_ID
                                          .equals(bagController.text)
                                          .toList();

                                      print(isVirtualReceived);
                                      if (isVirtualReceived.isEmpty) {
                                        Toast.showFloatingToast(
                                            'Bag number not available..!',
                                            context);
                                        print('before alert');

                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(32.0))),
                                            // backgroundColor: Colors.transparent,
                                            title: const Text('Alert..!'),
                                            content: Container(
                                              height: 150,
                                              child: Column(
                                                children: [
                                                  Text(
                                                      'Virtual Data Not Received.'
                                                      '\nPlease Enter BO Slip Number'
                                                      ' and peform data entry.'),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        boslipController,
                                                    focusNode: boslipfocus,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    // maxLength: 10,
                                                    // maxLengthEnforced: true,
                                                    // readOnly: true,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "BO Slip Number *",
                                                      hintStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: Color.fromARGB(
                                                            255, 2, 40, 86),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      border: InputBorder.none,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .blueGrey,
                                                                  width: 3)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width:
                                                                          3)),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20,
                                                              left: 20,
                                                              right: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Button(
                                                  buttonText: 'OKAY',
                                                  buttonFunction: () {
                                                    print(
                                                        'Bag Data Entry Alert..!');

                                                    if (boslipController
                                                        .text.isEmpty)
                                                      boslipfocus
                                                          .requestFocus();
                                                    else {
                                                      print('Not Empty');
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      BagAddDetailsReplica(
                                                                        bagNumber: bagController
                                                                            .text
                                                                            .toUpperCase(),
                                                                        isDataEntry:
                                                                            true,
                                                                      )),
                                                              (route) => false);
                                                    }
                                                  })
                                            ],
                                          ),
                                        );
                                      }
                                      else {
                                        print('Bag Received Virtually..!');
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    BagAddDetailsReplica(
                                                      bagNumber: bagController
                                                          .text
                                                          .toUpperCase(),
                                                      isDataEntry: false,
                                                    )),
                                            (route) => false);
                                      }
                                    }

                                    else if (isBagPresent[0]['BagType'] ==
                                        'Close') {
                                      print('Bag is used as Bag-Close');
                                      Toast.showFloatingToast(
                                          'Bag is used as Bag-Close', context);
                                    }
                                    // else if (isBagPresent[0]['BagType'] == 'Open')
                                    // {
                                    //   print('Bag is already opened');
                                    //   Toast.showFloatingToast('Bag is already opened', context);
                                    // }
                                    //commented above code to allow already Opened Bag
                                    // commented below condition and added above condition for Opened Bag
                                    else if (isBagPresent[0]['BagDate'] !=
                                        DateTimeDetails().currentDate()) {
                                      print('Bag is already opened');
                                      Toast.showFloatingToast(
                                          'Bag is already opened', context);
                                    } else {
                                      print('last else statement');
                                      print(bagController.text);
                                      final isVirtualReceived = await Delivery()
                                          .select()
                                          .BAG_ID
                                          .equals(bagController.text)
                                          .toList();
                                      print(
                                          isVirtualReceived.length.toString());
                                      if (isVirtualReceived.isEmpty) {
                                        print('<><><><><><>');
                                        Toast.showFloatingToast(
                                            'Bag number not available..!',
                                            context);
                                        print('before alert');

                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Alert..!'),
                                            content: Text(
                                                'Virtual Data Not Received.\nPlease Perform Data Entry.'),
                                            actions: [
                                              Button(
                                                  buttonText: 'OKAY',
                                                  buttonFunction: () {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    BagAddDetailsReplica(
                                                                      bagNumber: bagController
                                                                          .text
                                                                          .toUpperCase(),
                                                                      isDataEntry:
                                                                          true,
                                                                    )),
                                                            (route) => false);
                                                  })
                                            ],
                                          ),
                                        );
                                      } else {
                                        print('<*********>');
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    BagAddDetailsReplica(
                                                      bagNumber: bagController
                                                          .text
                                                          .toUpperCase(),
                                                      isDataEntry: false,
                                                    )),
                                            (route) => false);
                                      }

                                      // Navigator.pushAndRemoveUntil(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) =>
                                      //             BagAddDetailsReplica(
                                      //               bagNumber: bagController
                                      //                   .text
                                      //                   .toUpperCase(),
                                      //               isDataEntry: false,
                                      //             )),
                                      //     (route) => false);

                                    }
                                  }
                                }),
                            Button(
                                buttonText: 'CANCEL',
                                buttonFunction: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => BaggingServices()),
                                      (route) => false);
                                })
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => BaggingServices()),
                (route) => false),
          ),
          title: const Text(
            'Bag Open',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          backgroundColor: const Color(0xFFB71C1C),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
        body: Container(),
      ),
      onWillPop: () async {
        moveToPrevious(context);
        return true;
      },
    );
  }

  void moveToPrevious(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => BaggingServices()), (route) => false);
  }
}

class AdditionalBagTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  AdditionalBagTextField(
      {Key? key, required this.controller, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                title,
                style: TextStyle(letterSpacing: 1),
              )),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: '0'),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
