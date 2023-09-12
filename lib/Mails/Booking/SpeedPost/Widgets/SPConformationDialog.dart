
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
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

import '../../BookingMainScreen.dart';

class SPConformationDialog extends StatefulWidget {

  String articleNumber;
  String weight;
  String serviceTaxAmount;
  String prepaidAmount;
  String insurance, registrationFee;
  String amountToBeCollected,
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
      acknowledgement,
      paymentMode;
  final Function() function;

  SPConformationDialog(
      {required this.articleNumber,
      required this.weight,
      required this.serviceTaxAmount,
      required this.prepaidAmount,
      required this.registrationFee,
      required this.insurance,
      required this.acknowledgement,
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
      required this.paymentMode,
      required this.addresseeEmail,
      required this.function});

  @override
  State<SPConformationDialog> createState() => _SPConformationDialogState();
}

class _SPConformationDialogState extends State<SPConformationDialog> {
  bool acknowledgementCheck = false;
  bool insuranceCheck = false;
  bool senderMobCheck = false;
  bool senderEmailCheck = false;
  bool addresseeMobCheck = false;
  bool addresseeEmailCheck = false;
  PdfGeneration pdfScreen = new PdfGeneration();
  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];

  String pdfName = "";
  bool visiblty = false;
  bool _clicked=false;

  GeneratePDF() async {
    print("inside GeneratePDF function..!" + widget.articleNumber);
    final userDetails = await OFCMASTERDATA().select().toList();
    String ArticleFromDB="";
      final speedDB = await SpeedBooking().select().ArticleNumber.equals(widget.articleNumber).toList();
      ArticleFromDB = speedDB[0].ArticleNumber.toString();

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
    basicInformation.add(ArticleFromDB);
    basicInformation.add("Service");
    basicInformation.add("SP");
    basicInformation.add("Weight");
    basicInformation.add(widget.weight);
    basicInformation.add("Payment Mode");
    basicInformation.add(widget.paymentMode);
    basicInformation.add("Prepaid");
    basicInformation.add(widget.prepaidAmount);
    basicInformation.add("TAX");
    basicInformation.add(widget.serviceTaxAmount);
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
    secondReceipt.add("SP");
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
    //     "Speed Letter", basicInformation, [], [], [], [], "", "", "", "",widget.articleNumber);
    //
    //
    //
    // print("File Path is - " + generatedPdfFilePath.toString());
    // pdfName=generatedPdfFilePath.toString();
    // return  generatedPdfFilePath.toString();
  }
  SendSms()  async {
    //Checking whether Mobile Number entered or not

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
      ret= await bs.SendBookingSMS('SP',widget.articleNumber,widget.senderMobileNumber);
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
    print("Dialog call");
     GeneratePDF();
    checkForTexts();
    print("initState file path-" + pdfName);
    super.initState();
  }

  checkForTexts() {

    setState(() {
      widget.acknowledgement == true
          ? acknowledgementCheck = true
          : acknowledgementCheck = false;
      widget.insurance.isNotEmpty
          ? insuranceCheck = true
          : insuranceCheck = false;
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
            DialogHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DialogText(
                      title: 'Article Number : ',
                      subtitle: widget.articleNumber),
                  Space(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DialogText(
                          title: 'Weight\n(Gms.)\n',
                          subtitle: '${widget.weight}'),
                      DialogText(
                          title: 'Registration\nFee\n',
                          subtitle: '\u{20B9} ${widget.registrationFee}'),
                      DialogText(
                          title: 'GST\n Amount\n',
                          subtitle: '\u{20B9} ${widget.serviceTaxAmount}'),
                    ],
                  ),
                  Space(),
                  DialogText(
                      title: 'Prepaid Amount : ',
                      subtitle: '\u{20B9} ${widget.prepaidAmount}'),
                  Space(),
                  DialogText(
                      title: 'Acknowledge Amount : ',
                      subtitle: '\u{20B9} ${widget.acknowledgement}'),
                  // Container(
                  //   child: Row(
                  //
                  //     children: [
                  //       Expanded(
                  //         flex: widget.acknowledgement.isNotEmpty ? 1 : 0,
                  //         child: Visibility(
                  //           visible: widget.acknowledgement.isNotEmpty,
                  //           child: DialogText(
                  //               title: 'Acknowledge Amount: ',
                  //               subtitle: widget.insurance.isEmpty
                  //                   ? '\u{20B9} 0'
                  //                   : '\u{20B9} ${widget.acknowledgement}'),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                      buttonFunction: () async{
                        setState(() {
                          visiblty =true;
                        });
                        await widget.function();
                        print("BOOK Button after DB insertion");
                        await GeneratePDF();
                        showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return  AlertDialog(
                                title: Text('${widget.articleNumber} Booking Confirmation'),
                                content:
                                Container(
                                child:
                                SingleChildScrollView(
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
                                        DialogText(
                                            title: 'Article Number : ',
                                            subtitle: widget.articleNumber),
                                        SmallSpace(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            DialogText(
                                                title: 'Weight\n(Gms.)\n',
                                                subtitle: '${widget.weight}'),
                                            DialogText(
                                                title: 'Registration\nFee\n',
                                                subtitle: '\u{20B9} ${widget.registrationFee}'),
                                            DialogText(
                                                title: 'GST\n Amount\n',
                                                subtitle: '\u{20B9} ${widget.serviceTaxAmount}'),
                                          ],
                                        ),
                                        SmallSpace(),
                                        DialogText(
                                            title: 'Prepaid Amount : ',
                                            subtitle: '\u{20B9} ${widget.prepaidAmount}'),
                                        SmallSpace(),
                                        DialogText(
                                            title: 'Acknowledge Amount : ',
                                            subtitle: '\u{20B9} ${widget.acknowledgement}'),
                                        SmallSpace(),
                                        DialogText(
                                            title: 'Insurance Amount : ',
                                            subtitle: '\u{20B9} ${widget.insurance}'),
                                        // Container(
                                        //   child: Row(
                                        //
                                        //     children: [
                                        //       Expanded(
                                        //         flex: widget.acknowledgement.isNotEmpty ? 1 : 0,
                                        //         child: Visibility(
                                        //           visible: widget.acknowledgement.isNotEmpty,
                                        //           child: DialogText(
                                        //               title: 'Acknowledge Amount: ',
                                        //               subtitle: widget.insurance.isEmpty
                                        //                   ? '\u{20B9} 0'
                                        //                   : '\u{20B9} ${widget.acknowledgement}'),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
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
                                        //DoubleSpace(),
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
                                        //DoubleSpace(),
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
                                        SmallSpace(),
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
                                                               // content: Text(
                                //     'Successfully booked a Speed post of \u{20B9}${widget.amountToBeCollected} with Article Number ${widget.articleNumber}'),
                                actions: [
                                  // Button(
                                  //     buttonText: 'PRINT',
                                  //     buttonFunction: () async {
                                  //       PrintingTelPO printer =
                                  //           new PrintingTelPO();
                                  //       await printer.printThroughUsbPrinter(
                                  //           "BOOKING",
                                  //           "Inland Speed Post",
                                  //           basicInformation,
                                  //           secondReceipt,
                                  //           1);
                                  //       // print('inside Print Button');
                                  //       // print(pdfName.toString());
                                  //       // await OpenFile.open(pdfName);
                                  //       //print command commented as there is no printer available in mobile device
                                  //       // final pdf = await rootBundle.load(generatedPdfFilePath.toString());
                                  //       // await Printing.layoutPdf(onLayout: (_) => pdf.buffer.asUint8List());
                                  //
                                  //       // Navigator.pushAndRemoveUntil(
                                  //       //     context,
                                  //       //     MaterialPageRoute(
                                  //       //         builder: (_) => const BookingMainScreen()), (route) => false);
                                  //     }),
                                  // // Button(
                                  // //     buttonText: 'OPEN',
                                  // //     buttonFunction: () async {
                                  // //       await OpenFile.open(
                                  // //           "storage/emulated/0/Darpan_Mine/Reports/example.pdf");
                                  // //     }),
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
                                                "Inland Speed Post",
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
                                            // //Checking whether Mobile Number entered or not
                                            // //print(widget.senderMobileNumber);
                                            // if(widget.senderMobileNumber.length !=10) {
                                            //   print(widget.senderMobileNumber);
                                            //   showDialog<void>(
                                            //     context: context,
                                            //     barrierDismissible: false,
                                            //     builder: (BuildContext context)
                                            //   {
                                            //     return AlertDialog(
                                            //       title: const Text(
                                            //           'Information'),
                                            //       content: Text(
                                            //           'Invalid Mobile Number!'),
                                            //       actions: [
                                            //         Button(
                                            //             buttonText: 'OKAY',
                                            //             buttonFunction: () =>
                                            //                 Navigator.of(context)
                                            //                     .pop()
                                            //         )
                                            //
                                            //
                                            //       ],
                                            //     );
                                            //   });
                                            // }
                                            // else
                                            // {
                                            //   //Send SMS
                                            //   //Get Details from the Database
                                            //   print("Inside Send Booking SMS");
                                            //   String ret="";
                                            //   String poptext="";
                                            //   BookingDBService bs= new BookingDBService();
                                            //   ret= await bs.SendBookingSMS('RL',widget.articleNumber,widget.senderMobileNumber);
                                            //   print(ret);
                                            //   //print("xvacvsdhvcsj");
                                            //   if(ret=="Success")
                                            //     poptext="SMS Sent Successfully!";
                                            //   else
                                            //     poptext="Unable to send SMS !";
                                            //
                                            //   showDialog<void>(
                                            //       context: context,
                                            //       barrierDismissible: false,
                                            //       builder: (BuildContext context)
                                            //       {
                                            //         return AlertDialog(
                                            //           title: const Text(
                                            //               'Information'),
                                            //           content: Text(
                                            //               poptext),
                                            //           actions: [
                                            //             Button(
                                            //                 buttonText: 'OKAY',
                                            //                 buttonFunction: () =>
                                            //                     Navigator.of(context)
                                            //                         .pop()
                                            //             )
                                            //           ],
                                            //         );
                                            //       }
                                            //       );
                                            // }
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
                                          }
                                      )
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
