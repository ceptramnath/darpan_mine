import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Model/EMOBookingModel.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Model/EMODBModel.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMODetailsDialog.dart';
import 'package:darpan_mine/Mails/Booking/EMO/Widgets/EMOListCard.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookedEMOScreen extends StatefulWidget {
  const BookedEMOScreen({Key? key}) : super(key: key);

  @override
  _BookedEMOScreenState createState() => _BookedEMOScreenState();
}

class _BookedEMOScreenState extends State<BookedEMOScreen> {
  @override
  void initState() {
    getDetails = getBookedList();
    super.initState();
  }

  late Future getDetails;
  var emoResponse;

  List<EMOModel> _articles = <EMOModel>[];
  List<EMOModel> _articlesToDisplay = <EMOModel>[];

  getBookedList() async {
    await fetchData().then((value) {
      setState(() {
        _articles.addAll(value);
        _articlesToDisplay = _articles;
      });
    });
  }

  Future<List<EMOModel>> fetchData() async {
    emoResponse = await EmoTable().select().toMapList();

    var articles = <EMOModel>[];
    for (var emoResponse in emoResponse) {
      articles.add(EMOModel.fromDB(emoResponse));
    }
    print(articles.length);
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
                    }));
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
              return EMODetailsDialog(
                  emoValue: _articlesToDisplay[index].emoValue.toString(),
                  commission: _articlesToDisplay[index].commission.toString(),
                  amountPaid:
                      _articlesToDisplay[index].amountToBeCollected.toString(),
                  senderName: _articlesToDisplay[index].senderName,
                  senderAddress: _articlesToDisplay[index].senderAddress,
                  senderPinCode:
                      _articlesToDisplay[index].senderPinCode.toString(),
                  senderCity: _articlesToDisplay[index].senderCity,
                  senderState: _articlesToDisplay[index].senderState,
                  senderMobileNumber:
                      _articlesToDisplay[index].senderMobileNumber,
                  senderEmail: _articlesToDisplay[index].senderEmail,
                  payeeName: _articlesToDisplay[index].payeeName,
                  payeeAddress: _articlesToDisplay[index].payeeAddress,
                  payeePinCode:
                      _articlesToDisplay[index].payeePinCode.toString(),
                  payeeCity: _articlesToDisplay[index].payeeCity,
                  payeeState: _articlesToDisplay[index].payeeState,
                  payeeMobileNumber:
                      _articlesToDisplay[index].payeeMobileNumber,
                  payeeEmail: _articlesToDisplay[index].payeeEmail);
            });
      },
      child: EMOListCard(
          emoValue: _articlesToDisplay[index].emoValue.toString(),
          commission: _articlesToDisplay[index].commission.toString(),
          amountPaid: _articlesToDisplay[index].amountToBeCollected.toString(),
          senderName: _articlesToDisplay[index].senderName,
          senderAddress: _articlesToDisplay[index].senderAddress,
          senderPinCode: _articlesToDisplay[index].senderPinCode.toString(),
          senderCity: _articlesToDisplay[index].senderCity,
          senderState: _articlesToDisplay[index].senderState,
          senderMobileNumber: _articlesToDisplay[index].senderMobileNumber,
          senderEmail: _articlesToDisplay[index].senderEmail,
          payeeName: _articlesToDisplay[index].payeeName,
          payeeAddress: _articlesToDisplay[index].payeeAddress,
          payeePinCode: _articlesToDisplay[index].payeePinCode.toString(),
          payeeCity: _articlesToDisplay[index].payeeCity,
          payeeState: _articlesToDisplay[index].payeeState,
          payeeMobileNumber: _articlesToDisplay[index].payeeMobileNumber,
          payeeEmail: _articlesToDisplay[index].payeeEmail),
    );
  }
}
