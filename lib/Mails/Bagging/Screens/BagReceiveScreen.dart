import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Widgets/BagReceiveCard.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagReceiveScreen extends StatefulWidget {
  const BagReceiveScreen({Key? key}) : super(key: key);

  @override
  _BagReceiveScreenState createState() => _BagReceiveScreenState();
}

class _BagReceiveScreenState extends State<BagReceiveScreen> {
  final bagController = TextEditingController();
  final weightController = TextEditingController();

  final bagFocus = FocusNode();

  final _weightForm = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _receiveCard = [];

  var date = DateTimeDetails().onlyDate();
  var time = DateTimeDetails().onlyTime();

  scanBarcode() async {
    var scan = await Scan().scanBag();
    setState(() {
      bagController.text = scan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
        title: const Text('Bag Receive'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ColorConstants.kPrimaryColor,
          onPressed: addToBag,
          label: const Text('Receive All Bags')),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ScanTextFormField(
                    type: 'Bag',
                    title: 'Bag Number',
                    focus: bagFocus,
                    controller: bagController,
                    scanFunction: scanBarcode,
                  )),
              Button(
                  buttonText: 'CONFIRM',
                  buttonFunction: () {
                    weightDialog(context);
                  }),
              Container(
                child: Flexible(
                  child: ListView.builder(
                      itemCount: _receiveCard.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BagReceiveCard(
                            bagNumber: _receiveCard[index]['number'],
                            bagWeight: _receiveCard[index]['weight'],
                            deleteFunction: () {
                              setState(() {
                                _receiveCard.removeAt(index);
                              });
                            },
                            receiveFunction: () {
                              addToBag(_receiveCard[index]['number'],
                                  _receiveCard[index]['weight']);
                              setState(() {
                                _receiveCard.removeAt(index);
                              });
                            });
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void weightDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(10.toDouble()))),
            elevation: 0,
            backgroundColor: ColorConstants.kWhite,
            child: Form(
              key: _weightForm,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0x00ffffff),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            child: WeightForm(
                              controller: weightController,
                              title: 'Weight',
                            ),
                          ),
                          const Text('Grams')
                        ],
                      ),
                      Button(
                          buttonText: 'CONFIRM',
                          buttonFunction: () {
                            if (_weightForm.currentState!.validate()) {
                              setState(() {
                                _receiveCard.add({
                                  "number": bagController.text,
                                  "weight": weightController.text
                                });
                              });
                              bagController.clear();
                              Navigator.of(context).pop();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  addToBag([String? bagNumber, String? bagWeight]) async {
    if (bagNumber == null) {
      for (int i = 0; i < _receiveCard.length; i++) {
        final addToBag = BagReceivedTable()
          ..BagNumber = _receiveCard[i]['number']
          ..ReceivedDate = date
          ..ReceivedTime = time
          ..OpenedDate = ''
          ..OpenedTime = ''
          ..ArticlesCount = ''
          ..CashCount = ''
          ..StampsCount = ''
          ..Status = 'Received';
        addToBag.save();
      }
      Toast.showToast('Successfully added the Bags', context);
      setState(() {
        _receiveCard.removeRange(0, _receiveCard.length);
      });
    } else {
      final addToBag = BagReceivedTable()
        ..BagNumber = bagNumber
        ..ReceivedDate = date
        ..ReceivedTime = time
        ..OpenedDate = ''
        ..OpenedTime = ''
        ..ArticlesCount = ''
        ..CashCount = ''
        ..StampsCount = ''
        ..Status = 'Received';
      addToBag.save();
      Toast.showToast('Successfully added the Bag', context);
    }
  }
}
