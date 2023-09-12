import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingMainScreen.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/Button1.dart';
import 'package:darpan_mine/Widgets/DialogCommonWidgets1.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:darpan_mine/main.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../LogCat.dart';

class EMOConformationDialog extends StatefulWidget {
  final String pnrNumber,
      emoValue,
      message,
      commission,
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
      addresseeEmail;
  final bool isVPP;
  final Function() function;

  EMOConformationDialog(
      {required this.pnrNumber,
      required this.emoValue,
      required this.message,
      required this.commission,
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
        required this.isVPP,
      required this.function
      });

  @override
  _EMOConformationDialogState createState() => _EMOConformationDialogState();
}

class _EMOConformationDialogState extends State<EMOConformationDialog> {
  bool senderMobCheck = false;
  bool senderEmailCheck = false;
  bool addresseeMobCheck = false;
  bool addresseeEmailCheck = false;
  bool visiblty = false;

  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];
  String pdfName = "";
  bool _clicked=false;

  @override
  void initState() {
    checkForTexts();
    // GeneratePDF();
    super.initState();
  }

  GeneratePDF() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    print("PNR received is ${widget.pnrNumber}");
    print(await EmoBooking().select().ArticleNumber.equals(widget.pnrNumber.trim()).toMapList());
    String pnrNumber = "";
    final emoFetch = await EmoBooking().select().ArticleNumber.equals(widget.pnrNumber.trim()).toList();
    pnrNumber = emoFetch[0].ArticleNumber.toString();
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
    basicInformation.add("PNR Number");
    basicInformation.add(pnrNumber);
    basicInformation.add("Service");
    basicInformation.add("eMO");
    basicInformation.add("eMO Value");
    basicInformation.add(widget.emoValue);
    basicInformation.add("Paid Amount");
    basicInformation.add(widget.amountToBeCollected);
    basicInformation.add("Commmission");
    basicInformation.add(widget.commission);
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
    secondReceipt.add("eMO");
    secondReceipt.add("PNR Number");
    secondReceipt.add(pnrNumber);
    secondReceipt.add("eMO Value");
    secondReceipt.add(widget.emoValue);
    secondReceipt.add("Paid Amount");
    secondReceipt.add(widget.amountToBeCollected);
    secondReceipt.add("Commission");
    secondReceipt.add(widget.commission);
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
    return basicInformation;
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
      ret= await bs.SendBookingSMS('EMO',widget.pnrNumber,widget.senderMobileNumber);
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

  /* Don't delete
  // bookFunction(bool isVPP) async {
  //   try {
  //     print('inside bookFunction eMO..!');
  //
  //     final fetchFileMaster =
  //     await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toCount();
  //
  //     if (fetchFileMaster == 0) {
  //       print('Inserting File Master Data..!');
  //       final fileMaster = await FILEMASTERDATA()
  //         ..FILETYPE = "BOOKING"
  //         ..DIVISION = "MO"
  //         ..ORDERTYPE_SP = "ZPP"
  //         ..ORDERTYPE_LETTERPARCEL = "ZAM"
  //         ..ORDERTYPE_EMO = "ZFS"
  //         ..PRODUCT_TYPE = 'S'
  //         ..MATERIALGROUP_SP = "DPM"
  //         ..MATERIALGROUP_LETTER = "DOM"
  //         ..MATERIALGROUP_EMO = "DMR";
  //
  //       fileMaster.save();
  //     }
  //
  //     final fileMaster =
  //     await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
  //     // print(senderAddressController.text.replaceAll('\n', '  ') +
  //     //     " and " +
  //     //     addresseeAddressController.text.replaceAll('\n', '  '));
  //     await BookingDBService().addEMOToDB(
  //         widget.pnrNumber.toString(),
  //         DateTimeDetails().currentDate(),
  //         DateTimeDetails().timeCharacter(),
  //         widget.amountToBeCollected.toString(),
  //         widget.amountToBeCollected.toString(),
  //         fileMaster[0].ORDERTYPE_EMO.toString(),
  //         fileMaster[0].PRODUCT_TYPE.toString(),
  //         'V2'
  //         //valueCode
  //         ,
  //         widget.emoValue.toString(),
  //         widget.senderName.toString(),
  //         widget.senderAddress.toString().replaceAll('\n', '  '),
  //         widget.senderCity.toString(),
  //         widget.senderState.toString(),
  //         widget.senderPinCode.toString(),
  //         widget.addresseeName.toString(),
  //         widget.addresseeAddress.toString().replaceAll('\n', '  '),
  //         widget.addresseeCity.toString(),
  //         widget.addresseeState.toString(),
  //         widget.addresseePinCode.toString(),
  //         widget.addresseeMobileNumber.toString(),
  //         widget.addresseeEmail.toString(),
  //         widget.commission.toString(),
  //         widget.emoValue.toString(),
  //         widget.message.toString(),
  //         widget.isVPP);
  //     final checkeMOTable = await EmoBooking()
  //         .select()
  //         .ArticleNumber
  //         .equals(widget.pnrNumber.toString())
  //         .toList();
  //     print("Check eMO Table");
  //     print(checkeMOTable.length);
  //     if (checkeMOTable.length > 0) {
  //       BookingDBService().addTransaction(
  //           widget.pnrNumber.toString(),
  //           'Booking',
  //           isVPP ? 'VPMO' : 'EMO Booking',
  //           DateTimeDetails().currentDate(),
  //           DateTimeDetails().onlyTime(),
  //           widget.amountToBeCollected.toString(),
  //           'Add');
  //       final checkTransTable = await TransactionTable()
  //           .select()
  //           .tranid
  //           .equals(widget.pnrNumber.toString())
  //           .toList();
  //       print("Check Trans Table");
  //       print(checkTransTable.length);
  //
  //       if (checkTransTable.length > 0) {
  //         final addCash = CashTable()
  //           ..Cash_ID = widget.pnrNumber.toString()
  //           ..Cash_Date = DateTimeDetails().currentDate()
  //           ..Cash_Time = DateTimeDetails().onlyTime()
  //           ..Cash_Type = 'Add'
  //           ..Cash_Amount = double.parse(widget.amountToBeCollected.toString())
  //           ..Cash_Description = isVPP ? 'VPMO' : 'EMO Booking';
  //         addCash.save();
  //       }
  //     }
  //   } catch (e) {
  //     await LogCat()
  //         .writeContent("Error in eMO Booking" + e.toString() + " \n\n");
  //   }
  // }
*/

  checkForTexts() {
    setState(() {
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
        children: [Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
      elevation: 0,
      backgroundColor: ColorConstants.kWhite,
      child: _data(context),
    ), visiblty == true
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
            Padding(
              padding: EdgeInsets.all(8.0.toDouble()),
              child: Row(
                children: [
                  Expanded(
                      flex: 2, child: Image.asset('assets/images/ic_logo.png')),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
            DottedLine(),
            SizedBox(
              height: 20.toDouble(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.commission.isEmpty
                      ? DialogText(
                          title: 'EMO Value :- ',
                          subtitle: '\u{20B9} ${widget.emoValue}')
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            DialogText(
                                title: 'EMO\nValue\n',
                                subtitle: '\u{20B9} ${widget.emoValue}'),
                            DialogText(
                                title: 'Commission\nAmount\n',
                                subtitle: '\u{20B9} ${widget.commission}'),
                          ],
                        ),
                  Space(),
                  DialogText(
                      title: 'Amount to be collected :- ',
                      subtitle: '\u{20B9} ${widget.amountToBeCollected}'),
                  Space(),

                  TitleAndHeading(
                    title: 'Message : -',
                    heading: '\t ${widget.message}',
                  ),
                  Space(),
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
                        // await bookFunction(widget.isVPP);
                       await widget.function();
                      // List res=  await GeneratePDF();
                        await GeneratePDF();
                        print("inside eMO BOOK Button");
                        // if(res.isNotEmpty) {
                         return showDialog<void>(
                              // context: context,
                            context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:  Text('${widget.pnrNumber} Booking Confirmation'),
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
                                                    widget.commission.isEmpty
                                                        ? DialogText(
                                                        title: 'EMO Value :- ',
                                                        subtitle: '\u{20B9} ${widget.emoValue}')
                                                        : Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        DialogText(
                                                            title: 'EMO\nValue\n',
                                                            subtitle: '\u{20B9} ${widget.emoValue}'),
                                                        DialogText(
                                                            title: 'Commission\nAmount\n',
                                                            subtitle: '\u{20B9} ${widget.commission}'),
                                                      ],
                                                    ),
                                                    SmallSpace(),
                                                    DialogText(
                                                        title: 'EMO Number\n',
                                                        subtitle: '\u{20B9} ${widget.pnrNumber}'),
                                                    SmallSpace(),
                                                    // DialogText(
                                                    //     title: 'Amount to be collected :- \n',
                                                    //     subtitle: '\u{20B9} ${widget.amountToBeCollected}'),
                                                  //  SmallSpace(),

                                                    DialogText(
                                                      title: 'Message : -',
                                                      subtitle: '${widget.message}',
                                                    ),
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
                                                        title: 'Addressee : ',subtitle: '${widget.addresseeName}'),

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
                                                   // Space(),
                                                  ],
                                                ),
                                              ),
                                            ])
                                    ),

                                  ),
                                  // Text(
                                  //     'Successfully booked an EMO of \u{20B9}'
                                  //         '${widget.amountToBeCollected}'
                                  //         '\nPNR Number ' +
                                  //         widget.pnrNumber.toString()),
                                  actions: [
                                    // Button(
                                    //     buttonText: 'PRINT',
                                    //     buttonFunction: () async {
                                    //       PrintingTelPO printer =
                                    //       new PrintingTelPO();
                                    //       await printer.printThroughUsbPrinter(
                                    //           "BOOKING",
                                    //           "eMO Receipt",
                                    //           basicInformation,
                                    //           secondReceipt,
                                    //           1);
                                    //     }),
                                    // Button(
                                    //     buttonText: 'OKAY',
                                    //     buttonFunction: () {
                                    //       Navigator.pushAndRemoveUntil(
                                    //           context,
                                    //           MaterialPageRoute(
                                    //               builder: (_) =>
                                    //               const BookingMainScreen()),
                                    //               (route) => false);
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
                                                  "eMO Receipt",
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
                                              if(_clicked==false && widget.isVPP==false)
                                                await SendSms();
                                            }
                                        )
                                      ],),
                                  ],
                                );
                              });
                        // }


                        // if(eMOBooking.length>0) //if data inserted into DB
                        // {
                        //  await LogCat().writeContent("eMO ${widget.pnrNumber} booked.\n\n");

                        // }
                        /*
                        else{
                          await LogCat().writeContent("eMO ${widget.pnrNumber} booking FAILED.\n\n");
                          // if (eMOTransTable.length==1)
                          //   {
                          //     await TransactionTable().select().tranid.equals(widget.pnrNumber).delete();
                          //   }
                          // if (eMOCashTable.length==1)
                          // {
                          //   await CashTable().select().Cash_ID.equals(widget.pnrNumber).delete();
                          // }
                          //
                          // if (eMOBooking.length==1)
                          // {
                          //   await EmoBooking().select().ArticleNumber.equals(widget.pnrNumber).delete();
                          // }

                         print("eMO DB Insertion failed");

                          showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Failed'),
                                  content: Text(
                                      'eMO booking is failed.\n Please try again.'),
                                  actions: [

                                    Button(
                                        buttonText: 'OKAY',
                                        buttonFunction: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                  const BookingMainScreen()),
                                                  (route) => false);
                                        })
                                  ],
                                );
                              });
                        }

                         */



                      }),
                ],
              ),
            )
          ],
        ),
      );

  showBookingDialog() {}
}
