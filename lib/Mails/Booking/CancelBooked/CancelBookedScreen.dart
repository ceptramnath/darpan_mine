import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/CustomPackages/TypeAhead/src/flutter_typeahead.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/FetchArticles.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Widgets/AppAppBar.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../BookingMainScreen.dart';

class CancelBookedScreen extends StatefulWidget {
  const CancelBookedScreen({Key? key}) : super(key: key);

  @override
  _CancelBookedScreenState createState() => _CancelBookedScreenState();
}

class _CancelBookedScreenState extends State<CancelBookedScreen> {
  bool details = false;
  bool otherReason = false;
  bool cancel = false;

  final articleFocus = FocusNode();
  final articleNumberController = TextEditingController();
  final otherReasonController = TextEditingController();

  String status = '';
  String amount = '';
  String bookedOn = '';
  String senderName = '';
  String articleType = '';
  String articleNumber = '';
  String transactionid = '';
  String? _chosenReason;
  String Heading = '';
  String artType = "";

  List articleDetails = [];
  List<String> reasons = ['Wrongly Booked', 'Amount mistake', 'Others'];

  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  scanFunction() async {
    var scan = await Scan().scanBag();
    articleNumberController.text = scan.toString();
  }

  GeneratePDF(String artnumber) async {
    final userDetails = await OFCMASTERDATA().select().toList();

    final letter =
        await LetterBooking().select().ArticleNumber.equals(artnumber).toList();
    final parcel =
        await ParcelBooking().select().ArticleNumber.equals(artnumber).toList();
    final speed =
        await SpeedBooking().select().ArticleNumber.equals(artnumber).toList();
    final emo =
        await EmoBooking().select().ArticleNumber.equals(artnumber).toList();
    final finalList;

    if (letter.length != 0) {
      finalList = letter;
      Heading = "Registered Letter";
      artType = "Regd.Letter";
    } else if (parcel.length != 0) {
      finalList = parcel;
      Heading = "PARCEL";
      artType = "Regd.Parcel";
    } else if (speed.length != 0) {
      finalList = speed;
      Heading = "Inland Speed Post";
      artType = "SPEED";
    } else if (emo.length != 0) {
      finalList = emo;
      Heading = "eMO Receipt";
      artType = "eMO";
    }

    // List<String> finalList = [];

    // if (letter.length!=0) finalList.add(letter[0].toString());
    // else if (parcel.length!=0) finalList.add(parcel[0].toString());
    // else if (speed.length!=0) finalList.add(speed[0].toString());
    // else if (emo.length!=0) finalList.add(emo[0].toString());
    else {
      print('No information found..!');
      return false;
    }

    String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();
    basicInformation.clear();
    basicInformation.add("Transaction Date");
    basicInformation.add(date);
    basicInformation.add("Transaction Time");
    basicInformation.add(time);
    basicInformation.add("Booking Office");
    basicInformation.add(userDetails[0].BOName.toString());
    basicInformation.add("Booking Office PIN");
    basicInformation.add(userDetails[0].Pincode.toString());
    basicInformation.add("BPM");
    basicInformation.add(userDetails[0].EmployeeName.toString());
    basicInformation.add("Article Number");
    basicInformation.add(artnumber);
    basicInformation.add("Service");
    basicInformation.add(artType);
    basicInformation.add("Weight");
    basicInformation.add(finalList[0].Weight); //['Weight']);
    basicInformation.add("Prepaid");
    basicInformation.add(finalList[0].PrepaidAmount);
    basicInformation.add("TAX");
    basicInformation.add(finalList[0].TaxAmount);
    basicInformation.add("Paid Amount");
    basicInformation.add(finalList[0].TotalAmount);
    basicInformation.add("Sender Name");
    basicInformation.add(finalList[0].SenderName);
    basicInformation.add("Addressee Name");
    basicInformation.add(finalList[0].RecipientName);
    basicInformation.add("Delivery Office");
    basicInformation.add(finalList[0].RecipientCity);
    basicInformation.add("Delivery Office Pincode");
    basicInformation.add(finalList[0].RecipientZip);
    basicInformation.add("Track:");
    basicInformation.add("www.indiapost.gov.in");
    basicInformation.add("|< Dial :");
    basicInformation.add("18002666868>|");
    basicInformation.add("|< IVR Track #:");
    basicInformation.add("6975000000028 >|");

    secondReceipt.clear();

    secondReceipt.add("Transaction Date");
    secondReceipt.add(date);
    secondReceipt.add("Booking Office");
    secondReceipt.add(userDetails[0].BOName.toString());
    secondReceipt.add("Booking Office PIN");
    secondReceipt.add(userDetails[0].Pincode.toString());
    secondReceipt.add("BPM");
    secondReceipt.add(userDetails[0].EmployeeName.toString());
    secondReceipt.add("Service");
    secondReceipt.add(artType);
    secondReceipt.add("Article Number");
    secondReceipt.add(artnumber);
    secondReceipt.add("Weight");
    secondReceipt.add(finalList[0].Weight);
    secondReceipt.add("Paid Amount");
    secondReceipt.add(finalList[0].TotalAmount);
    secondReceipt.add("Sender Name");
    secondReceipt.add(finalList[0].SenderName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: const AppAppBar(
        title: 'Search/Cancel/Duplicate',
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                          color: ColorConstants.kSecondaryColor),
                      controller: articleNumberController,
                      autofocus: false,
                      decoration: InputDecoration(
                          prefixIcon: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.toDouble()),
                              margin: EdgeInsets.only(right: 8.0.toDouble()),
                              decoration: const BoxDecoration(
                                color: ColorConstants.kSecondaryColor,
                              ),
                              child: IconButton(
                                onPressed: scanFunction,
                                icon: const Icon(
                                  MdiIcons.barcodeScan,
                                  color: ColorConstants.kWhite,
                                ),
                              )),
                          fillColor: ColorConstants.kWhite,
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstants.kWhite),
                          ),
                          labelText: 'Enter the Article Number',
                          labelStyle: const TextStyle(
                              color: ColorConstants.kAmberAccentColor),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorConstants.kWhite)))),
                  onSuggestionSelected: (Map<String, String> suggestion) async {
                    setState(() {
                      articleNumberController.text = suggestion['article']!;
                    });
                  },
                  itemBuilder: (context, Map<String, String> suggestion) {
                    return ListTile(
                      title: Text(suggestion['article']!),
                    );
                  },
                  suggestionsCallback: (pattern) async {
                    return await FetchArticles.getArticles(pattern);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {}
                  },
                ),
              ),
              Button(buttonText: 'SEARCH', buttonFunction: search),
              Visibility(
                visible: details,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(18),
                          child: Column(
                            children: [
                              tableText('Transaction ID', transactionid),
                              const Space(),
                              tableText('Article No. ', articleNumber),
                              const Space(),
                              tableText('Sender Name', senderName),
                              const Space(),
                              tableText('Amount', '\u{20B9} $amount'),
                              const Space(),
                              tableText('Booked On', bookedOn),
                              const Space(),
                              tableText('Status', status),
                              const DoubleSpace(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Visibility(
                                      visible: cancel,
                                      child: Button(
                                          buttonText: 'CANCEL',
                                          buttonFunction: () =>
                                              conformation())),
                                  Visibility(
                                      visible: true,
                                      child: Button(
                                          buttonText: 'PRINT',
                                          buttonFunction: () async {
                                            await GeneratePDF(articleNumber);
                                            PrintingTelPO printer =
                                                new PrintingTelPO();
                                            //await printer.printThroughUsbPrinter("BOOKING", "Duplicate Receipt",basicInformation, secondReceipt, 1);
                                            await printer
                                                .printThroughUsbPrinter(
                                                    "DUP",
                                                    Heading,
                                                    basicInformation,
                                                    secondReceipt,
                                                    1);
                                          }))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  search() async {
    articleDetails = [];
    articleDetails = await LetterBooking()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text).and.FileCreated.not.equals("Y")
        .toMapList();
    if (articleDetails.isEmpty) {
      articleDetails = await ParcelBooking()
          .select()
          .ArticleNumber
          .equals(articleNumberController.text).and.FileCreated.not.equals("Y")
          .toMapList();
      if (articleDetails.isEmpty) {
        articleDetails = await SpeedBooking()
            .select()
            .ArticleNumber
            .equals(articleNumberController.text).and.FileCreated.not.equals("Y")
            .toMapList();
        if (articleDetails.isNotEmpty) {
          setState(() {
            transactionid = articleDetails[0]['InvoiceNumber'];
            articleNumber = articleDetails[0]['ArticleNumber'];
            senderName = articleDetails[0]['SenderName'];
            amount = articleDetails[0]['TotalAmount'];
            bookedOn = articleDetails[0]['BookingDate'];
            status = articleDetails[0]['Status'];
            if (articleDetails[0]['Status'] != 'Cancelled') {
              if (articleDetails[0]['BookingDate'] ==
                  DateTimeDetails().currentDate()) {
                if (articleDetails[0]['FileCreated'] != 'Y') {
                  if (articleDetails[0]['TenderID'] == 'S') {
                    cancel = true;
                  } else {
                    cancel = false;
                  }
                } else {
                  cancel = false;
                }
              } else {
                cancel = false;
              }
            } else {
              cancel = false;
            }
            details = true;
            articleType = 'Speed Post';
          });
        }
      } else {
        setState(() {
          transactionid = articleDetails[0]['InvoiceNumber'];
          articleNumber = articleDetails[0]['ArticleNumber'];
          senderName = articleDetails[0]['SenderName'];
          amount = articleDetails[0]['TotalAmount'];
          bookedOn = articleDetails[0]['BookingDate'];
          status = articleDetails[0]['Status'];
          details = true;
          if (articleDetails[0]['Status'] != 'Cancelled') {
            if (articleDetails[0]['BookingDate'] ==
                DateTimeDetails().currentDate()) {
              if (articleDetails[0]['FileCreated'] != 'Y') {
                if (articleDetails[0]['TenderID'] == 'S') {
                  cancel = true;
                } else {
                  cancel = false;
                }
              } else {
                cancel = false;
              }
            } else {
              cancel = false;
            }
          } else {
            cancel = false;
          }
          articleType = 'Parcel';
        });
      }
    } else {
      setState(() {
        transactionid = articleDetails[0]['InvoiceNumber'];
        articleNumber = articleDetails[0]['ArticleNumber'];
        senderName = articleDetails[0]['SenderName'];
        amount = articleDetails[0]['TotalAmount'];
        bookedOn = articleDetails[0]['BookingDate'];
        status = articleDetails[0]['Status'];
        details = true;
        if (articleDetails[0]['Status'] != 'Cancelled') {
          if (articleDetails[0]['BookingDate'] ==
              DateTimeDetails().currentDate()) {
            if (articleDetails[0]['FileCreated'] != 'Y') {
              if (articleDetails[0]['TenderID'] == 'S') {
                cancel = true;
              } else {
                cancel = false;
              }
            } else {
              cancel = false;
            }
          } else {
            cancel = false;
          }
        } else {
          cancel = false;
        }
        articleType = 'Register Letter';
      });
    }

    //added below code to check if article is already closed then don't allow for cancellation.
    List articlesinBag = await BagArticlesTable()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text)
        .toList();
    if (articlesinBag.length > 0) {
      UtilFs.showToast("Article is already closed in a Bag..!", context);
      cancel = true;
    }

    //added below code to fetch Biller Collection details
    // print('Going to fetch Biller Data');
    articleDetails = await BillFile()
        .select()
        .startBlock
        .ArticleNumber
        .equals(articleNumberController.text)
        .and
        .IS_COMMUNICATED
        .equalsOrNull("")
        .endBlock
        .and
        .toMapList();

    if (articleDetails.isNotEmpty) {
      setState(() {
        transactionid = articleDetails[0]['InvoiceNumber'];
        articleNumber = articleDetails[0]['ArticleNumber'];
        senderName = articleDetails[0]['BillerName'];
        amount = articleDetails[0]['Value'];
        bookedOn = articleDetails[0]['BookingDate'];
        status = 'Booked';
      });
      articleType = 'Biller';
      details = true;
      cancel = true;
    }
  }

  tableText(String title, String value) {
    return Row(
      children: [
        Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                  color: ColorConstants.kTextColor,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500),
            )),
        SizedBox(
          width: 20,
          child: const Text(':'),
        ),
        Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                  color: ColorConstants.kTextDark,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  void conformation() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Confirmation..!'),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(10.toDouble()))),
              elevation: 0,
              backgroundColor: ColorConstants.kWhite,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select the Reason for cancelling the $articleNumber?',
                      style: TextStyle(
                          letterSpacing: 1,
                          color: ColorConstants.kTextColor),
                    ),
                    FormField<String>(builder: (FormFieldState<String> state) {
                      return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            enabledBorder: InputBorder.none),
                        isExpanded: true,
                        iconEnabledColor: Colors.blueGrey,
                        hint: const Text(
                          "Reason",
                          style: TextStyle(color: Color(0xFFCFB53B)),
                        ),
                        items:
                            reasons.toSet().toList().map((String myMenuItem) {
                          return DropdownMenuItem<String>(
                            value: myMenuItem,
                            child: Text(
                              myMenuItem,
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? valueSelectedByUser) {
                          // setQuantity(valueSelectedByUser!);
                          _chosenReason = valueSelectedByUser;
                          setState(() {
                            valueSelectedByUser == 'Others'
                                ? otherReason = true
                                : otherReason = false;
                          });
                        },
                        value: _chosenReason,
                      ));
                    }),
                    const Space(),
                    otherReason
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: otherReasonController,
                                style: const TextStyle(
                                    color: ColorConstants.kTextColor,
                                    letterSpacing: 1),
                                decoration: const InputDecoration(
                                    counterText: '',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ColorConstants.kWhite),
                                    ),
                                    labelText: 'Reason',
                                    labelStyle: TextStyle(
                                        color:
                                            ColorConstants.kAmberAccentColor),
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants.kWhite))),
                              ),
                            ),
                          )
                        : Container(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Space(),
                        const DoubleSpace(),
                        Button(
                            buttonText: 'CONFIRM',
                            buttonFunction: updateArticle)
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  updateArticle() async {
    await BookingDBService().updateCancelledArticle(
        articleNumber,
        'Cancelled',
        _chosenReason != 'Others'
            ? _chosenReason!
            : otherReasonController.text);
    await BookingDBService()
        .updateCashInDB(double.parse(amount), 'Minus', '$articleType cancelled');
    await BookingDBService().addTransaction(
        'CANCEL${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
        'Cancel Booking',
        'Booking Article Cancel',
        DateTimeDetails().onlyDate(),
        DateTimeDetails().onlyTime(),
        amount,
        'Minus');
    removeArticle(_chosenReason != 'Others'
        ? _chosenReason!
        : otherReasonController.text);
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BookingMainScreen()),
        (route) => false);
  }

  removeArticle(String reason) async {
    final detailsLetter = await LetterBooking()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text)
        .toMapList();

    final detailsParcel = await ParcelBooking()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text)
        .toMapList();
    final detailsSpeed = await SpeedBooking()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text)
        .toMapList();

    final detailsBiller = await BillFile()
        .select()
        .ArticleNumber
        .equals(articleNumberController.text)
        .toMapList();

    if (detailsLetter.isNotEmpty) {
      BookingDBService().addCancelToDB(detailsLetter, reason);
      await LetterBooking()
          .select()
          .ArticleNumber
          .equals(articleNumberController.text)
          .delete();
    } else if (detailsParcel.isNotEmpty) {
      BookingDBService().addCancelToDB(detailsParcel, reason);
      await ParcelBooking()
          .select()
          .ArticleNumber
          .equals(articleNumberController.text)
          .delete();
    } else if (detailsSpeed.isNotEmpty) {
      BookingDBService().addCancelToDB(detailsSpeed, reason);
      await SpeedBooking()
          .select()
          .ArticleNumber
          .equals(articleNumberController.text)
          .delete();
    } else if (detailsBiller.isNotEmpty) {
      BookingDBService().addBillerCancelToDB(detailsBiller, reason);
      await BillFile()
          .select()
          .ArticleNumber
          .equals(articleNumberController.text)
          .delete();
    }
  }
}
