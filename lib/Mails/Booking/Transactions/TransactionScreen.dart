import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Model/EMOBookingModel.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Model/EMODBModel.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMODetailsDialog.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMOListCard.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Model/RegisterLetterBookingModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Model/RegisterLetterDBModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Widgets/RLDetailsDialog.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Widgets/RegisterLetterListCard.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  String? _chosenValue;

  bool registerLetter = false;
  bool emo = false;

  @override
  void initState() {
    getRegisterLetter = getRegisterBookedList();
    getEMODetails = getEMOBookedList();
    super.initState();
  }

  late Future getRegisterLetter;
  late Future getEMODetails;
  var emoResponse;
  var registerLetterResponse;

  List<EMOModel> _emoArticles = <EMOModel>[];
  List<EMOModel> _emoArticlesToDisplay = <EMOModel>[];
  List<RegisterLetterModel> _registerArticles = <RegisterLetterModel>[];
  List<RegisterLetterModel> _registerArticlesToDisplay =
      <RegisterLetterModel>[];

  getRegisterBookedList() async {
    await fetchRegisterData().then((value) {
      setState(() {
        _registerArticles.addAll(value);
        _registerArticlesToDisplay = _registerArticles;
      });
    });
  }

  getEMOBookedList() async {
    await fetchEMOData().then((value) {
      setState(() {
        _emoArticles.addAll(value);
        _emoArticlesToDisplay = _emoArticles;
      });
    });
  }

  Future<List<RegisterLetterModel>> fetchRegisterData() async {
    registerLetterResponse = await RegisterLetterTable().select().toMapList();

    var articles = <RegisterLetterModel>[];
    for (var registerLetterResponse in registerLetterResponse) {
      articles.add(RegisterLetterModel.fromDB(registerLetterResponse));
    }
    return articles;
  }

  Future<List<EMOModel>> fetchEMOData() async {
    emoResponse = await EmoTable().select().toMapList();

    var articles = <EMOModel>[];
    for (var emoResponse in emoResponse) {
      articles.add(EMOModel.fromDB(emoResponse));
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstants.kPrimaryColor,
        title: Text(
          'Booked Articles',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Select the type of Article',
                    style: TextStyle(letterSpacing: 1),
                  ),
                  DropdownButton<String>(
                    underline: SizedBox(),
                    focusColor: Colors.white,
                    value: _chosenValue,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      'LETTER',
                      'Register Parcel',
                      'Speed Post',
                      'EMO'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Type",
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _chosenValue = value;
                        if (_chosenValue == 'LETTER') {
                          registerLetter = true;
                          emo = false;
                        } else if (_chosenValue == 'EMO') {
                          registerLetter = false;
                          emo = true;
                        }
                      });
                    },
                  ),
                ],
              ),
              Visibility(
                visible: registerLetter,
                child: FutureBuilder(
                  future: getRegisterLetter,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.data.toString().length == 0) {
                      return Center(
                        child: Text('No Records found'),
                      );
                    } else if (_registerArticlesToDisplay.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mark_email_unread_outlined,
                              size: 50.toDouble(),
                              color: ColorConstants.kTextColor,
                            ),
                            Text(
                              'No Records found',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: ColorConstants.kTextColor),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        child: Flexible(
                          child: ListView.builder(
                              itemCount: _registerArticlesToDisplay.length + 1,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Container()
                                    : registerListItem(index - 1);
                              }),
                        ),
                      );
                    }
                  },
                ),
              ),
              Visibility(
                visible: emo,
                child: FutureBuilder(
                  future: getEMODetails,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.data.toString().length == 0) {
                      return Center(
                        child: Text('No Records found'),
                      );
                    } else if (_emoArticlesToDisplay.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mark_email_unread_outlined,
                              size: 50.toDouble(),
                              color: ColorConstants.kTextColor,
                            ),
                            Text(
                              'No Records found',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: ColorConstants.kTextColor),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        child: Flexible(
                          child: ListView.builder(
                              itemCount: _emoArticlesToDisplay.length + 1,
                              itemBuilder: (context, index) {
                                return index == 0
                                    ? Container()
                                    : emoListItem(index - 1);
                              }),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  registerListItem(index) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return RLDetailsDialog(
                  articleNumber:
                      _registerArticlesToDisplay[index].articleNumber,
                  weight: _registerArticlesToDisplay[index].weight,
                  weightAmount: _registerArticlesToDisplay[index].weightAmount,
                  prepaidAmount: _registerArticlesToDisplay[index]
                      .prepaidAmount
                      .toString(),
                  acknowledgement: _registerArticlesToDisplay[index]
                      .acknowledgementAmount
                      .toString(),
                  insurance: _registerArticlesToDisplay[index]
                      .insuranceAmount
                      .toString(),
                  valuePayablePost:
                      _registerArticlesToDisplay[index].vppAmount.toString(),
                  registrationFee: _registerArticlesToDisplay[index]
                      .registrationFee
                      .toString(),
                  amountToBeCollected:
                      _registerArticlesToDisplay[index].amountToBeCollected,
                  senderName: _registerArticlesToDisplay[index].senderName,
                  senderAddress:
                      _registerArticlesToDisplay[index].senderAddress,
                  senderPinCode: _registerArticlesToDisplay[index]
                      .senderPinCode
                      .toString(),
                  senderCity: _registerArticlesToDisplay[index].senderCity,
                  senderState: _registerArticlesToDisplay[index].senderState,
                  senderMobileNumber:
                      _registerArticlesToDisplay[index].senderMobileNumber,
                  senderEmail: _registerArticlesToDisplay[index].senderEmail,
                  addresseeName:
                      _registerArticlesToDisplay[index].addresseeName,
                  addresseeAddress:
                      _registerArticlesToDisplay[index].addresseeAddress,
                  addresseePinCode: _registerArticlesToDisplay[index]
                      .addresseePinCode
                      .toString(),
                  addresseeCity:
                      _registerArticlesToDisplay[index].addresseeCity,
                  addresseeState:
                      _registerArticlesToDisplay[index].addresseeState,
                  addresseeMobileNumber:
                      _registerArticlesToDisplay[index].addresseeMobileNumber,
                  addresseeEmail:
                      _registerArticlesToDisplay[index].addresseeEmail);
            });
      },
      child: RegisterListCard(
          articleNumber: _registerArticlesToDisplay[index].articleNumber,
          weight: _registerArticlesToDisplay[index].weight,
          prepaidAmount:
              _registerArticlesToDisplay[index].prepaidAmount.toString(),
          acknowledgement: _registerArticlesToDisplay[index]
              .acknowledgementAmount
              .toString(),
          insurance:
              _registerArticlesToDisplay[index].insuranceAmount.toString(),
          valuePayablePost:
              _registerArticlesToDisplay[index].vppAmount.toString(),
          amountToBeCollected:
              _registerArticlesToDisplay[index].amountToBeCollected,
          senderName: _registerArticlesToDisplay[index].senderName,
          senderAddress: _registerArticlesToDisplay[index].senderAddress,
          senderPinCode:
              _registerArticlesToDisplay[index].senderPinCode.toString(),
          senderCity: _registerArticlesToDisplay[index].senderCity,
          senderState: _registerArticlesToDisplay[index].senderState,
          senderMobileNumber:
              _registerArticlesToDisplay[index].senderMobileNumber,
          senderEmail: _registerArticlesToDisplay[index].senderEmail,
          addresseeName: _registerArticlesToDisplay[index].addresseeName,
          addresseeAddress: _registerArticlesToDisplay[index].addresseeAddress,
          addresseePinCode:
              _registerArticlesToDisplay[index].addresseePinCode.toString(),
          addresseeCity: _registerArticlesToDisplay[index].addresseeCity,
          addresseeState: _registerArticlesToDisplay[index].addresseeState,
          addresseeMobileNumber:
              _registerArticlesToDisplay[index].addresseeMobileNumber,
          addresseeEmail: _registerArticlesToDisplay[index].addresseeEmail),
    );
  }

  emoListItem(index) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return EMODetailsDialog(
                  emoValue: _emoArticlesToDisplay[index].emoValue.toString(),
                  commission:
                      _emoArticlesToDisplay[index].commission.toString(),
                  amountPaid: _emoArticlesToDisplay[index]
                      .amountToBeCollected
                      .toString(),
                  senderName: _emoArticlesToDisplay[index].senderName,
                  senderAddress: _emoArticlesToDisplay[index].senderAddress,
                  senderPinCode:
                      _emoArticlesToDisplay[index].senderPinCode.toString(),
                  senderCity: _emoArticlesToDisplay[index].senderCity,
                  senderState: _emoArticlesToDisplay[index].senderState,
                  senderMobileNumber:
                      _emoArticlesToDisplay[index].senderMobileNumber,
                  senderEmail: _emoArticlesToDisplay[index].senderEmail,
                  payeeName: _emoArticlesToDisplay[index].payeeName,
                  payeeAddress: _emoArticlesToDisplay[index].payeeAddress,
                  payeePinCode:
                      _emoArticlesToDisplay[index].payeePinCode.toString(),
                  payeeCity: _emoArticlesToDisplay[index].payeeCity,
                  payeeState: _emoArticlesToDisplay[index].payeeState,
                  payeeMobileNumber:
                      _emoArticlesToDisplay[index].payeeMobileNumber,
                  payeeEmail: _emoArticlesToDisplay[index].payeeEmail);
            });
      },
      child: EMOListCard(
          emoValue: _emoArticlesToDisplay[index].emoValue.toString(),
          commission: _emoArticlesToDisplay[index].commission.toString(),
          amountPaid:
              _emoArticlesToDisplay[index].amountToBeCollected.toString(),
          senderName: _emoArticlesToDisplay[index].senderName,
          senderAddress: _emoArticlesToDisplay[index].senderAddress,
          senderPinCode: _emoArticlesToDisplay[index].senderPinCode.toString(),
          senderCity: _emoArticlesToDisplay[index].senderCity,
          senderState: _emoArticlesToDisplay[index].senderState,
          senderMobileNumber: _emoArticlesToDisplay[index].senderMobileNumber,
          senderEmail: _emoArticlesToDisplay[index].senderEmail,
          payeeName: _emoArticlesToDisplay[index].payeeName,
          payeeAddress: _emoArticlesToDisplay[index].payeeAddress,
          payeePinCode: _emoArticlesToDisplay[index].payeePinCode.toString(),
          payeeCity: _emoArticlesToDisplay[index].payeeCity,
          payeeState: _emoArticlesToDisplay[index].payeeState,
          payeeMobileNumber: _emoArticlesToDisplay[index].payeeMobileNumber,
          payeeEmail: _emoArticlesToDisplay[index].payeeEmail),
    );
  }
}
