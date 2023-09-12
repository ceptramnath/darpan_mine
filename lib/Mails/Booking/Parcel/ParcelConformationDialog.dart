import 'package:darpan_mine/Authentication/RegistrationScreen.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Utils/Receipt.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/Button1.dart';
import 'package:darpan_mine/Widgets/DialogCommonWidgets.dart';
import 'package:darpan_mine/Widgets/DialogCommonWidgets1.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../BookingMainScreen.dart';

class ParcelConformationDialog extends StatefulWidget {
  final String articleNumber,
      weight,
      weightAmount,
      prepaidAmount,
      insurance,
      registrationFee,
      valuePayablePost,
      airMailAmount,
      amountToBeCollected,
      senderName,
      senderAddress,
      senderPinCode,
      senderCity,
      senderState,
      senderMobileNumber,
      senderEmail,
      addresseeName,
      addresseeAddress,
      addresseePinCode,
      addresseeCity,
      addresseeState,
      addresseeMobileNumber,
      addresseeEmail,
      paymentMode;
  final bool acknowledgement;
  final Function() function;

  const ParcelConformationDialog(
      {Key? key,
      required this.articleNumber,
      required this.weight,
      required this.weightAmount,
      required this.prepaidAmount,
      required this.acknowledgement,
      required this.insurance,
      required this.registrationFee,
      required this.valuePayablePost,
      required this.airMailAmount,
      required this.amountToBeCollected,
      required this.senderName,
      required this.senderAddress,
      required this.senderPinCode,
      required this.senderCity,
      required this.senderState,
      required this.senderMobileNumber,
      required this.senderEmail,
      required this.addresseeName,
      required this.addresseeAddress,
      required this.addresseePinCode,
      required this.addresseeCity,
      required this.addresseeState,
      required this.addresseeMobileNumber,
      required this.addresseeEmail,
      required this.function,
      required this.paymentMode})
      : super(key: key);

  @override
  _ParcelConformationDialogState createState() =>
      _ParcelConformationDialogState();
}

class _ParcelConformationDialogState extends State<ParcelConformationDialog> {
  PdfGeneration pdfScreen = new PdfGeneration();
  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];
  String pdfName = "";
  bool visiblty = false;
  bool _clicked = false;
  GeneratePDF() async {
    final userDetails = await OFCMASTERDATA().select().toList();


    String date = DateTimeDetails().currentDate();
    String time = DateTimeDetails().oT();

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
    basicInformation.add(widget.articleNumber);
    basicInformation.add("Service");
    basicInformation.add("Parcel");
    basicInformation.add("Weight");
    basicInformation.add(widget.weight);
    basicInformation.add("Payment Mode");
    basicInformation.add(widget.paymentMode);
    basicInformation.add("Prepaid");
    basicInformation.add(widget.prepaidAmount);

    basicInformation.add("Paid Amount");
    basicInformation.add(widget.amountToBeCollected);
    basicInformation.add("Sender Name");
    basicInformation.add(widget.senderName);
    basicInformation.add("Addressee Name");
    basicInformation.add(widget.addresseeName);
    basicInformation.add("Delivery Office");
    basicInformation.add(widget.addresseeCity);
    basicInformation.add("Delivery Office Pincode");
    basicInformation.add(widget.addresseePinCode);
    basicInformation.add("Track - ");
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
    secondReceipt.add("Parcel");
    secondReceipt.add("Article Number");
    secondReceipt.add(widget.articleNumber);
    secondReceipt.add("Weight");
    secondReceipt.add(widget.weight);
    secondReceipt.add("Payment Mode");
    secondReceipt.add(widget.paymentMode);
    secondReceipt.add("Paid Amount");
    secondReceipt.add(widget.amountToBeCollected);
    secondReceipt.add("Sender Name");
    secondReceipt.add(widget.senderName);

    // print('basic information is');
    // print(basicInformation.toString());
    //
    // String generatedPdfFilePath = await pdfScreen.generateExampleDocument(
    //     "PARCEL", basicInformation, [], [], [], [], "", "", "", "",widget.articleNumber);
    //
    // print("File Path is - " + generatedPdfFilePath.toString());
    // pdfName = generatedPdfFilePath.toString();
    // // return  generatedPdfFilePath.toString();
  }
  SendSms()  async {//Checking whether Mobile Number entered or not
    //print(widget.senderMobileNumber);
    if(widget.senderMobileNumber.length !=10) {
      print(widget.senderMobileNumber);
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)
          {
            return AlertDialog(
              title: const Text(
                  'Information'),
              content: Text(
                  'Invalid Mobile Number!'),
              actions: [
                Button(
                    buttonText: 'OKAY',
                    buttonFunction: () =>
                        Navigator.of(context)
                            .pop()
                )


              ],
            );
          });
    }
    else
    {
      //Send SMS
      //Get Details from the Database
      print("Inside Send Booking SMS");
      String ret="";
      String poptext="";
      BookingDBService bs= new BookingDBService();
      ret= await bs.SendBookingSMS('PL',widget.articleNumber,widget.senderMobileNumber);
      print(ret);
      //print("xvacvsdhvcsj");
      if(ret=="Success") {
        poptext = "SMS Sent Successfully!";
        _clicked=true;
      }
      else
        poptext="Unable to send SMS !";

      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)
          {
            return AlertDialog(
              title: const Text(
                  'Information'),
              content: Text(
                  poptext),
              actions: [
                Button(
                    buttonText: 'OKAY',
                    buttonFunction: () =>
                        Navigator.of(context)
                            .pop()
                )
              ],
            );
          }
      );
    }}

  @override
  void initState() {
    checkForTexts();
    GeneratePDF();
    print("initState file path-" + pdfName);
    super.initState();
  }

  bool acknowledgementCheck = false;
  bool insuranceCheck = false;
  bool vppCheck = false;
  bool senderMobCheck = false;
  bool senderEmailCheck = false;
  bool addresseeMobCheck = false;
  bool addresseeEmailCheck = false;

  checkForTexts() {
    setState(() {
      widget.acknowledgement == true
          ? acknowledgementCheck = true
          : acknowledgementCheck = false;
      widget.insurance.isNotEmpty
          ? insuranceCheck = true
          : insuranceCheck = false;
      widget.valuePayablePost.isNotEmpty ? vppCheck = true : vppCheck = false;
      widget.senderMobileNumber.isNotEmpty
          ? senderMobCheck = true
          : senderMobCheck = false;
      widget.senderEmail.isNotEmpty
          ? senderEmailCheck = true
          : senderEmailCheck = false;
      widget.addresseeMobileNumber.isNotEmpty
          ? addresseeMobCheck = true
          : addresseeMobCheck = false;
      widget.addresseeEmail.isNotEmpty
          ? addresseeEmailCheck = true
          : addresseeEmailCheck = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[ Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
        elevation: 0,
        backgroundColor: ColorConstants.kWhite,
        child: _data(context),
      ),
        visiblty == true
            ? Center(
            child: Loader(
                isCustom: true, loadingTxt: 'Please Wait...Loading...'))
            : const SizedBox.shrink()
    ]
    );
  }

  _data(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DialogHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Article Details
                  DialogText(
                      title: 'Article Number : ',
                      subtitle: widget.articleNumber),
                  const Space(),
                  DialogText(
                      title: 'Weight : ', subtitle: '${widget.weight} gms'),
                  Space(),
                  DialogText(
                      title: 'Prepaid Amount : ',
                      subtitle: '\u{20B9} ${widget.prepaidAmount}'),
                  Space(),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: widget.acknowledgement ? 1 : 0,
                          child: Visibility(
                            visible: widget.acknowledgement,
                            child: DialogText(
                                title: 'Acknowledge\nAmount\n',
                                subtitle: widget.insurance.isNotEmpty
                                    ? '\u{20B9} 0'
                                    : '\u{20B9} 3'),
                          ),
                        ),
                        Expanded(
                          flex: widget.insurance != '' ? 1 : 0,
                          child: Visibility(
                            visible: widget.insurance != '',
                            child: DialogText(
                                title: 'Insurance\nAmount\n',
                                subtitle: '\u{20B9} ${widget.insurance}'),
                          ),
                        ),
                        Expanded(
                          flex: widget.valuePayablePost != '' ? 1 : 0,
                          child: Visibility(
                            visible:
                                widget.valuePayablePost != '' ? true : false,
                            child: DialogText(
                                title: 'VPP \nAmount\n',
                                subtitle:
                                    '\u{20B9} ${widget.valuePayablePost}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Space(),
                  DialogText(
                      title: 'Register Letter fee : ',
                      subtitle: '\u{20B9} ${widget.registrationFee}'),
                  Space(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'Amount to be paid : ',
                        style: TextStyle(
                            fontSize: 15.toDouble(),
                            color: ColorConstants.kTextColor,
                            letterSpacing: 1),
                        children: [
                          TextSpan(
                              text: '\u{20B9} ${widget.amountToBeCollected}',
                              style: TextStyle(
                                  fontSize: 15.toDouble(),
                                  color: ColorConstants.kTextDark,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.toDouble()))
                        ]),
                  ),
                  Space(),
                  DialogText(
                      title: 'Payment Mode : ', subtitle: widget.paymentMode),
                  DoubleSpace(),

                  //Sender Details
                  DialogText(
                      title: 'Sender : ', subtitle: '${widget.senderName}'),
                  Space(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.toDouble()),
                      child: Text(widget.senderAddress +
                          ", " +
                          widget.senderCity +
                          ", " +
                          widget.senderState +
                          ", " +
                          widget.senderPinCode),
                    ),
                  ),
                  Space(),
                  Visibility(
                      visible: senderMobCheck,
                      child: DialogText(
                        title: 'Mob# : ',
                        subtitle: widget.senderMobileNumber,
                      )),
                  Space(),
                  Visibility(
                      visible: senderEmailCheck,
                      child: DialogText(
                        title: 'Email ID : ',
                        subtitle: widget.senderEmail,
                      )),
                  DoubleSpace(),

                  //Addressee Details
                  DialogText(
                      title: 'Addressee : ',
                      subtitle: '${widget.addresseeName}'),
                  Space(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.toDouble()),
                      child: Text(widget.addresseeAddress +
                          ", " +
                          widget.addresseeCity +
                          ", " +
                          widget.addresseeState +
                          ", " +
                          widget.addresseePinCode),
                    ),
                  ),
                  Space(),
                  Visibility(
                      visible: addresseeMobCheck,
                      child: DialogText(
                        title: 'Mob# : ',
                        subtitle: widget.addresseeMobileNumber,
                      )),
                  Space(),
                  Visibility(
                      visible: addresseeEmailCheck,
                      child: DialogText(
                        title: 'Email ID : ',
                        subtitle: widget.addresseeEmail,
                      )),
                  Space(),
                ],
              ),
            ),
            Space(),
            Container(
              decoration: BoxDecoration(
                  color: ColorConstants.kPrimaryAccent,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.toDouble()),
                      bottomRight: Radius.circular(10.toDouble()))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                      buttonText: 'CANCEL',
                      buttonFunction: () => Navigator.of(context).pop()),
                  Button(
                      buttonText: 'BOOK',
                      buttonFunction: () {
                        setState(() {
                          visiblty =true;
                        });
                        widget.function();
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title:  Text('${widget.articleNumber} Booking Confirmation'),
                                content:
                                Container(
                                  child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .stretch,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          mainAxisSize:
                                          MainAxisSize.min,
                                          children: [
                                            DialogHeader1(),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  //Article Details
                                                  DialogText(
                                                      title: 'Article Number : ',
                                                      subtitle: widget.articleNumber),
                                                  const Space(),
                                                  DialogText(
                                                      title: 'Weight : ', subtitle: '${widget.weight} gms'),
                                                  SmallSpace(),
                                                  DialogText(
                                                      title: 'Prepaid Amount : ',
                                                      subtitle: '\u{20B9} ${widget.prepaidAmount}'),
                                                  SmallSpace(),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: widget.acknowledgement ? 1 : 0,
                                                          child: Visibility(
                                                            visible: widget.acknowledgement,
                                                            child: DialogText(
                                                                title: 'Acknowledge\nAmount\n',
                                                                subtitle: widget.insurance.isNotEmpty
                                                                    ? '\u{20B9} 0'
                                                                    : '\u{20B9} 3'),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: widget.insurance != '' ? 1 : 0,
                                                          child: Visibility(
                                                            visible: widget.insurance != '',
                                                            child: DialogText(
                                                                title: 'Insurance\nAmount\n',
                                                                subtitle: '\u{20B9} ${widget.insurance}'),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: widget.valuePayablePost != '' ? 1 : 0,
                                                          child: Visibility(
                                                            visible:
                                                            widget.valuePayablePost != '' ? true : false,
                                                            child: DialogText(
                                                                title: 'VPP \nAmount\n',
                                                                subtitle:
                                                                '\u{20B9} ${widget.valuePayablePost}'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SmallSpace(),
                                                  DialogText(
                                                      title: 'Registration fee : ',
                                                      subtitle: '\u{20B9} ${widget.registrationFee}'),
                                                  SmallSpace(),
                                                  RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                        text: 'Amount paid : ',
                                                        style: TextStyle(
                                                            fontSize: 15.toDouble(),
                                                            color: ColorConstants.kTextColor,
                                                            letterSpacing: 1),
                                                        children: [
                                                          TextSpan(
                                                              text: '\u{20B9} ${widget.amountToBeCollected}',
                                                              style: TextStyle(
                                                                  fontSize: 15.toDouble(),
                                                                  color: ColorConstants.kTextDark,
                                                                  fontWeight: FontWeight.bold,
                                                                  letterSpacing: 1.toDouble()))
                                                        ]),
                                                  ),
                                                  SmallSpace(),
                                                  DialogText(
                                                      title: 'Payment Mode : ', subtitle: widget.paymentMode),
                                                  SmallSpace(),
                                                  //Sender Details
                                                  DialogText(
                                                      title: 'Sender : ', subtitle: '${widget.senderName}'),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 8.0.toDouble()),
                                                      child: Text(widget.senderAddress +
                                                          ", " +
                                                          widget.senderCity +
                                                          ", " +
                                                          widget.senderState +
                                                          ", " +
                                                          widget.senderPinCode),
                                                    ),
                                                  ),
                                                  SmallSpace(),
                                                  Visibility(
                                                      visible: senderMobCheck,
                                                      child: DialogText(
                                                        title: 'Mob# : ',
                                                        subtitle: widget.senderMobileNumber,
                                                      )),
                                                  SmallSpace(),
                                                  Visibility(
                                                      visible: senderEmailCheck,
                                                      child: DialogText(
                                                        title: 'Email ID : ',
                                                        subtitle: widget.senderEmail,
                                                      )),
                                                  SmallSpace(),

                                                  //Addressee Details
                                                  DialogText(
                                                      title: 'Addressee : ',
                                                      subtitle: '${widget.addresseeName}'),

                                                  Flexible(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 8.0.toDouble()),
                                                      child: Text(widget.addresseeAddress +
                                                          ", " +
                                                          widget.addresseeCity +
                                                          ", " +
                                                          widget.addresseeState +
                                                          ", " +
                                                          widget.addresseePinCode),
                                                    ),
                                                  ),
                                                  Space(),
                                                  Visibility(
                                                      visible: addresseeMobCheck,
                                                      child: DialogText(
                                                        title: 'Mob# : ',
                                                        subtitle: widget.addresseeMobileNumber,
                                                      )),
                                                  SmallSpace(),
                                                  Visibility(
                                                      visible: addresseeEmailCheck,
                                                      child: DialogText(
                                                        title: 'Email ID : ',
                                                        subtitle: widget.addresseeEmail,
                                                      )),
                                                  SmallSpace(),
                                                ],
                                              ),
                                            ),
                                          ])
                                  ),

                                ),
                                // Text(
                                //     'Successfully booked a Parcel of \u{20B9}${widget.amountToBeCollected} with Article Number ${widget.articleNumber}'),
                                actions: [
                                  // Button(
                                  //     buttonText: 'PRINT',
                                  //     buttonFunction: () async {
                                  //       PrintingTelPO printer =
                                  //           new PrintingTelPO();
                                  //       await printer.printThroughUsbPrinter(
                                  //           "BOOKING",
                                  //           "PARCEL",
                                  //           basicInformation,
                                  //           secondReceipt,
                                  //           1);
                                  //
                                  //       /* Working PDF Code
                                  //       print('inside Print Button');
                                  //       print(pdfName.toString());
                                  //       await OpenFile.open(pdfName);
                                  //       */
                                  //
                                  //       //print command commented as there is no printer available in mobile device
                                  //       // final pdf = await rootBundle.load(generatedPdfFilePath.toString());
                                  //       // await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
                                  //
                                  //       // Navigator.pushAndRemoveUntil(
                                  //       //     context,
                                  //       //     MaterialPageRoute(
                                  //       //         builder: (_) => const BookingMainScreen()), (route) => false);
                                  //     }),
                                  // Button(
                                  //     buttonText: 'OKAY',
                                  //     buttonFunction: () {
                                  //       Navigator.pushAndRemoveUntil(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (_) =>
                                  //                   const BookingMainScreen()),
                                  //           (route) => false);
                                  //     })
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Button1(
                                          buttonText: 'PRINT',
                                          buttonFunction: () async {
                                            PrintingTelPO printer =
                                            new PrintingTelPO();
                                            await printer.printThroughUsbPrinter(
                                                "BOOKING",
                                                "PARCEL",
                                                basicInformation,
                                                secondReceipt,
                                                1);

                                            /* Working PDF Code
                                        print('inside Print Button');
                                        print(pdfName.toString());
                                        await OpenFile.open(pdfName);

                                         */

                                            //print command commented as there is no printer available in mobile device
                                            // final pdf = await rootBundle.load(generatedPdfFilePath.toString());
                                            // await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());

                                            // Navigator.pushAndRemoveUntil(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (_) => const BookingMainScreen()), (route) => false);
                                          }),
                                      Button1(
                                          buttonText: 'OK',
                                          buttonFunction: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                    const BookingMainScreen()),
                                                    (route) => false);
                                          }),
                                      Button1(

                                          buttonText: 'Send\nSMS',
                                          buttonFunction: () async {
                                            print(_clicked);
                                            // Checking internet availability
                                            bool netresult = false;
                                              netresult =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                              if (netresult) {
                                            if(_clicked==false)
                                              await SendSms();
                                              }
                                              else{
                                                showDialog<void>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context)
                                                    {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Information'),
                                                        content: Text(
                                                            'Internet connection is not available..!'),
                                                        actions: [
                                                          Button(
                                                              buttonText: 'OKAY',
                                                              buttonFunction: () =>
                                                                  Navigator.of(context)
                                                                      .pop()
                                                          )
                                                        ],
                                                      );
                                                    });
                                              }
                                          })
                                    ],),
                                ],
                              );
                            });
                      }),
                ],
              ),
            )
          ],
        ),
      );
}
