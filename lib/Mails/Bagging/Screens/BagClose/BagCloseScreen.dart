import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Utils/barcodeValidation.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../BaggingServices.dart';
import 'BagCloseDetailsScreen.dart';
//import 'BagCloseDetailsScreen_20112022.dart';

class BagCloseScreen extends StatefulWidget {
  @override
  _BagCloseScreenState createState() => _BagCloseScreenState();
}

class _BagCloseScreenState extends State<BagCloseScreen> {
  final _bagForm = GlobalKey<FormState>();
  final bagFocus = FocusNode();
  final bagController = TextEditingController();

  @override
  void initState() {
    _showDialog();
    super.initState();
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
                    child: Form(
                      key: _bagForm,
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
                                    final checkBag = await BagReceivedTable()
                                        .select()
                                        .BagNumber
                                        .equals(bagController.text)
                                        .toMapList();
                                    final bagCloseDetails =
                                        await BagCloseTable()
                                            .select()
                                            .BagNumber
                                            .equals(bagController.text)
                                            .toMapList();
                                    if(bgval.validate(bagController.text) != "Valid")
                                    {
                                      Toast.showFloatingToast(
                                          'Please enter a valid barcode !',
                                          context);
                                      bagFocus.requestFocus();
                                    }else
                                    if (checkBag.isNotEmpty) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BaggingServices()),
                                          (route) => false);
                                      Toast.showToast(
                                          'Bag number ${bagController.text} is used in Bag Open',
                                          context);
                                    } else if (bagCloseDetails.isNotEmpty &&
                                        bagCloseDetails[0]['Status'] ==
                                            'Closed') {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BaggingServices()),
                                          (route) => false);
                                      Toast.showToast(
                                          'Bag number ${bagController.text} is Closed',
                                          context);
                                    } else {
                                      // only bag scanned for closing not closed yet.
                                      await BaggingDBService().closeBag(
                                          bagController.text,
                                          'Not Closed',
                                          '',
                                          '',
                                          '',
                                          '');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BagCloseDetailsScreen(
                                                    bagNumber:
                                                        bagController.text,
                                                  )));
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
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  scanBarcode() async {
    var scan = await Scan().scanBag();
    setState(() {
      bagController.text = scan.toString();
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
              'Bag Close',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            backgroundColor: const Color(0xFFB71C1C),
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
          ),
          body: Container()),
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
