import 'package:flutter/material.dart';
import 'package:darpan_mine/Constants/Color.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Model/RegisterLetterBookingModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Model/RegisterLetterDBModel.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Widgets/RLDetailsDialog.dart';
import 'package:darpan_mine/Mails/Booking/RegisterLetter/Widgets/RegisterLetterListCard.dart';

class RegisterLetterBookedListScreen extends StatefulWidget {
  const RegisterLetterBookedListScreen({Key? key}) : super(key: key);

  @override
  _RegisterLetterBookedListScreenState createState() =>
      _RegisterLetterBookedListScreenState();
}

class _RegisterLetterBookedListScreenState
    extends State<RegisterLetterBookedListScreen> {
  @override
  void initState() {
    getDetails = getBookedList();
    super.initState();
  }

  late Future getDetails;
  var registerLetterResponse;

  List<RegisterLetterModel> _articles = <RegisterLetterModel>[];
  List<RegisterLetterModel> _articlesToDisplay = <RegisterLetterModel>[];

  getBookedList() async {
    await fetchData().then((value) {
      setState(() {
        _articles.addAll(value);
        _articlesToDisplay = _articles;
      });
    });
  }

  Future<List<RegisterLetterModel>> fetchData() async {
    registerLetterResponse = await RegisterLetterTable().select().toMapList();

    var articles = <RegisterLetterModel>[];
    for (var registerLetterResponse in registerLetterResponse) {
      articles.add(RegisterLetterModel.fromDB(registerLetterResponse));
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
        title: Text('Booked Articles'),
      ),
      body: FutureBuilder(
        future: getDetails,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.data.toString().length == 0) {
            return Center(
              child: Text('No Records found'),
            );
          } else if (_articlesToDisplay.isEmpty) {
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
                        letterSpacing: 2, color: ColorConstants.kTextColor),
                  ),
                ],
              ),
            );
          } else {
            return Scrollbar(
              child: ListView.builder(
                  itemCount: _articlesToDisplay.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0 ? Container() : listItem(index - 1);
                  }),
            );
          }
        },
      ),
    );
  }

  listItem(index) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return RLDetailsDialog(
                  articleNumber: _articlesToDisplay[index].articleNumber,
                  weight: _articlesToDisplay[index].weight,
                  weightAmount: _articlesToDisplay[index].weightAmount,
                  prepaidAmount:
                      _articlesToDisplay[index].prepaidAmount.toString(),
                  acknowledgement: _articlesToDisplay[index]
                      .acknowledgementAmount
                      .toString(),
                  insurance:
                      _articlesToDisplay[index].insuranceAmount.toString(),
                  valuePayablePost:
                      _articlesToDisplay[index].vppAmount.toString(),
                  registrationFee:
                      _articlesToDisplay[index].registrationFee.toString(),
                  amountToBeCollected:
                      _articlesToDisplay[index].amountToBeCollected,
                  senderName: _articlesToDisplay[index].senderName,
                  senderAddress: _articlesToDisplay[index].senderAddress,
                  senderPinCode:
                      _articlesToDisplay[index].senderPinCode.toString(),
                  senderCity: _articlesToDisplay[index].senderCity,
                  senderState: _articlesToDisplay[index].senderState,
                  senderMobileNumber:
                      _articlesToDisplay[index].senderMobileNumber,
                  senderEmail: _articlesToDisplay[index].senderEmail,
                  addresseeName: _articlesToDisplay[index].addresseeName,
                  addresseeAddress: _articlesToDisplay[index].addresseeAddress,
                  addresseePinCode:
                      _articlesToDisplay[index].addresseePinCode.toString(),
                  addresseeCity: _articlesToDisplay[index].addresseeCity,
                  addresseeState: _articlesToDisplay[index].addresseeState,
                  addresseeMobileNumber:
                      _articlesToDisplay[index].addresseeMobileNumber,
                  addresseeEmail: _articlesToDisplay[index].addresseeEmail);
            });
      },
      child: RegisterListCard(
          articleNumber: _articlesToDisplay[index].articleNumber,
          weight: _articlesToDisplay[index].weight,
          prepaidAmount: _articlesToDisplay[index].prepaidAmount.toString(),
          acknowledgement:
              _articlesToDisplay[index].acknowledgementAmount.toString(),
          insurance: _articlesToDisplay[index].insuranceAmount.toString(),
          valuePayablePost: _articlesToDisplay[index].vppAmount.toString(),
          amountToBeCollected: _articlesToDisplay[index].amountToBeCollected,
          senderName: _articlesToDisplay[index].senderName,
          senderAddress: _articlesToDisplay[index].senderAddress,
          senderPinCode: _articlesToDisplay[index].senderPinCode.toString(),
          senderCity: _articlesToDisplay[index].senderCity,
          senderState: _articlesToDisplay[index].senderState,
          senderMobileNumber: _articlesToDisplay[index].senderMobileNumber,
          senderEmail: _articlesToDisplay[index].senderEmail,
          addresseeName: _articlesToDisplay[index].addresseeName,
          addresseeAddress: _articlesToDisplay[index].addresseeAddress,
          addresseePinCode:
              _articlesToDisplay[index].addresseePinCode.toString(),
          addresseeCity: _articlesToDisplay[index].addresseeCity,
          addresseeState: _articlesToDisplay[index].addresseeState,
          addresseeMobileNumber:
              _articlesToDisplay[index].addresseeMobileNumber,
          addresseeEmail: _articlesToDisplay[index].addresseeEmail),
    );
  }
}
