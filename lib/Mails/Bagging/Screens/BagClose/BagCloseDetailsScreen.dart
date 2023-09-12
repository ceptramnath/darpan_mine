import 'dart:convert';

import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagCloseModel.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagOpenModel.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Mails/BaggingServices.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Booking/Services/BookingDBService.dart';
import 'package:darpan_mine/Utils/Scan.dart';
import 'package:darpan_mine/Utils/barcodeValidation.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../LogCat.dart';
import '../../../backgroundoperations.dart';
import 'BagCloseScreen.dart';

class BagCloseDetailsScreen extends StatefulWidget {
  final String bagNumber;

  const BagCloseDetailsScreen({Key? key, required this.bagNumber})
      : super(key: key);

  @override
  _BagCloseDetailsScreenState createState() => _BagCloseDetailsScreenState();
}

class _BagCloseDetailsScreenState extends State<BagCloseDetailsScreen> {
  static final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  var typeArticle = null;

  String? articleType;
  String? boSlipNumber;
  String jsonBagCashReceived = '';
  var infer;
  List expansionArticle = [];
  List expansionArticleType = [];
  List expansionAmount = [];

  List<ArticleCloseModel> articlesFetch = [];

  List jsonBagArticles = [];
  List alreadyScannedArticles = [];
  List unScannedArticles = [];

  List<bool> jsonArticles = [];
  List<bool> receivedArticles = [];

  List<bool> alreadyPresentArticles = [];
  List<String> boStampSlipNumber = [];
  List<BagArticlesModel> bagArticlesModel = [];
  List<ArticlesinBag> articlesInBag = [];
  Map<String, dynamic> masterData = {};

  Map<String, bool> articleMap = {};

  bool bagFetched = false;
  bool selectedArticle = false;
  bool selectedRegularArticle = false;

  final bagNumberFocus = FocusNode();
  final articleNumberFocusNode = FocusNode();

  final bagController = TextEditingController();
  final articleNumberController = TextEditingController();
  final editArticleNumberController = TextEditingController();

  final boController = TextEditingController();
  final cashFromController = TextEditingController();
  final cashToController = TextEditingController();
   int i =0;
   Future? rtValue;
  bool visiblty= false;

  @override
  void initState() {
    print('Bag Close Screen.');
    bagController.text = widget.bagNumber;
    articlesFetch.clear();
    super.initState();
    rtValue = fetchDetails();
  }

  fetchDetails() async {
    i++;
    print('fetchDetails Called at - ');
    print(i);
    articlesFetch.clear();
    // articlesFetch.add(ArticleCloseModel("EKIN", "SPEED", "Booked",false));
    // return true;
    var nonDeliveryArticles = await Delivery()
        .select()
        .ART_STATUS
        .equals('N')
        .and
        .startBlock
        .ACTION
        .equals('11')
        .or
        .ACTION
        .equals('5')
        .or
        .ACTION
        .equals('6')
        .endBlock
        .toMapList();
    print(nonDeliveryArticles.toString());
    print('NON-Delivery Articles - ' + nonDeliveryArticles.length.toString());

    // notDeliveredArticlesCount = nonDeliveryArticles.length;

    print("Fetching Booking Articles");

    final bookedLetter = await LetterBooking()
        .select()
        .startBlock
        .Status
        .not
        .equals('Closed')
        .and
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .endBlock
        .toMapList();
    final bookedParcel = await ParcelBooking()
        .select()
        .startBlock
        .Status
        .not
        .equals('Closed')
        .and
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .endBlock
        .toMapList();
    final bookedSpeed = await SpeedBooking()
        .select()
        .startBlock
        .Status
        .not
        .equals('Closed')
        .and
        .BookingDate
        .equals(DateTimeDetails().currentDate())
        .endBlock
        .toMapList();
    // Getting the articles in deposit more than 7 days
    final moresevendays = await Delivery()
        .select()
        .ART_RECEIVE_DATE
        .lessThan(DateTimeDetails().Dminus7DateOnly())
        .and
        .ART_STATUS
        .equals("N")
        .and
        .MATNR.not.contains("EMO")
        .and
        .startBlock
        .REASON_FOR_NONDELIVERY
        .equals(35)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(36)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(1)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(8)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(3)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(5)
        .or
        .REASON_FOR_NONDELIVERY
        .equals(15)
        .or
        .startBlock
        .REASON_FOR_NONDELIVERY
        .equals(6)
        .and
        .ACTION
        .equals(4)
        .endBlock
        .or
        .startBlock
        .REASON_FOR_NONDELIVERY
        .equals(7)
        .and
        .ACTION
        .equals(4)
        .endBlock
        .endBlock
        .toMapList();
    //print(moresevendays);

    print("Set values..!");

      if (bookedLetter.isNotEmpty) {
        for (int i = 0; i < bookedLetter.length; i++) {
          articlesFetch.add(ArticleCloseModel(bookedLetter[i]['ArticleNumber'],
              bookedLetter[i]['ProductCode'], "Booked", false));
        }
      }
      if (bookedParcel.isNotEmpty) {
        for (int i = 0; i < bookedParcel.length; i++) {
          articlesFetch.add(ArticleCloseModel(bookedParcel[i]['ArticleNumber'],
              bookedParcel[i]['ProductCode'], "Booked", false));
        }
      }
      if (bookedSpeed.isNotEmpty) {
        for (int i = 0; i < bookedSpeed.length; i++) {
          articlesFetch.add(ArticleCloseModel(bookedSpeed[i]['ArticleNumber'],
              bookedSpeed[i]['ProductCode'], "Booked", false));
        }
      }
      bagFetched = true;
      if (nonDeliveryArticles.isNotEmpty) {
        for (int i = 0; i < nonDeliveryArticles.length; i++) {
          print('Article Number - ${nonDeliveryArticles[i]['ART_NUMBER']}');
            articlesFetch.add(ArticleCloseModel(nonDeliveryArticles[i]['ART_NUMBER'],
                nonDeliveryArticles[i]['MATNR'], "Returned",false));
          }
      }
    if (moresevendays.isNotEmpty) {
      for (int i = 0; i < moresevendays.length; i++) {
        articlesFetch.add(ArticleCloseModel(moresevendays[i]['ART_NUMBER'],
            moresevendays[i]['MATNR'], "> 7 Days", false));
      }
    }

    fetchBagData();
    return true;
  }

  fetchBagData() async {
    var bodaDetails = await BodaSlip()
        .select()
        .bodaDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    if (bodaDetails.isNotEmpty) {
      boController.text = bodaDetails[0]['bodaNumber'];
      cashFromController.text = bodaDetails[0]['cashFrom'];
      cashToController.text = bodaDetails[0]['cashTo'];
    }

    final scannedArticles = await CloseArticlesTable()
        .select()
        .BagNumber
        .equals(widget.bagNumber)
        .toMapList();
    if (scannedArticles.isNotEmpty) {
      for (int i = 0; i < scannedArticles.length; i++) {
        articlesFetch.add(ArticleCloseModel(scannedArticles[i]['ArticleNumber'],
            scannedArticles[i]['ArticleType'], "Scanned", false));
      }
    }
    return true;
  }

  scanArticles() async {
    print('scanArticles function');
    var scan = await Scan().scanBag();
    print(scan.toString());
    if(articlesFetch.length>0) {
      for (int i = 0; i < articlesFetch.length; i++) {
        if(articlesFetch[i].ArticleNumber==scan && articlesFetch[i].Scanned==true)
          {
            Toast.showFloatingToast('$scan has been already added', context);
          }
        else if(articlesFetch[i].ArticleNumber==scan && articlesFetch[i].Scanned==false)
        {
          setState(() {
            articlesFetch[i].Scanned=true;
          });
          Toast.showFloatingToast('$scan has been added', context);
        }

      }
    }
    else {
      articleNumberController.text = scan;
      Toast.showFloatingToast('$scan is not valid..!', context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        moveToPrevious(context);
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ColorConstants.kBackgroundColor,
            appBar: AppBar(
              backgroundColor: ColorConstants.kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Note!'),
                          content: const Text(
                              'Do you wish to save the details entered and then leave the page?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Button(
                                    buttonText: 'CANCEL',
                                    buttonFunction: () async {
                                      print('Cancel is progress..!');
                                      final bagDetails1 = await BagTable()
                                          .select()
                                          .BagType
                                          .equals('Open')
                                          .toMapList();
                                      print('Bag Open Count- in Revised.');
                                      print(bagDetails1.length);

                                      for (int i = 0; i < bagDetails1.length; i++) {
                                        print(bagDetails1[i].toString());
                                      }

                                      final bagDetails = await BagTable()
                                          .select()
                                          .BagNumber
                                          .equals(bagController.text)
                                          .delete();
                                      final bagDetails2 = await BagTable()
                                          .select()
                                          .BagType
                                          .equals('Open')
                                          .toMapList();
                                      print('Bag Open Count- in Revised.');
                                      print(bagDetails2.length);

                                      for (int i = 0; i < bagDetails2.length; i++) {
                                        print(bagDetails2[i].toString());
                                      }

                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => BagCloseScreen()),
                                          (route) => false);
                                    }),
                                Button(
                                  buttonText: 'SAVE',
                                  buttonFunction: () async {
                                    Toast.showToast(
                                        'Details has been added for the Bag ${widget.bagNumber}',
                                        context);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BagCloseScreen()),
                                        (route) => false);
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      });
                },
              ),
              title: Text('Bag Number -  ${widget.bagNumber}'),
            ),
            body: FutureBuilder(
              future: rtValue,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Space(),
                          Visibility(
                            visible: true,
                            // selectedRegularArticle,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    focusNode: articleNumberFocusNode,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: articleNumberController,
                                    style: TextStyle(
                                        color: ColorConstants.kSecondaryColor,
                                        letterSpacing: 1),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText: 'Article Number',
                                        hintStyle: const TextStyle(
                                            color:
                                                ColorConstants.kAmberAccentColor),
                                        counterText: '',
                                        fillColor: ColorConstants.kWhite,
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorConstants.kWhite),
                                        ),
                                        prefixIcon: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.toDouble()),
                                            margin: EdgeInsets.only(
                                                right: 8.0.toDouble()),
                                            decoration: const BoxDecoration(
                                              color: ColorConstants.kSecondaryColor,
                                            ),
                                            child: IconButton(
                                              onPressed: scanArticles,
                                              icon: const Icon(
                                                MdiIcons.barcodeScan,
                                                color: ColorConstants.kWhite,
                                              ),
                                            )),
                                        contentPadding:
                                            EdgeInsets.all(15.0.toDouble()),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: ColorConstants.kWhite),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  20.0.toDouble()),
                                              bottomLeft: Radius.circular(
                                                  30.0.toDouble()),
                                            ))),
                                    validator: (text) {
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorConstants.kWhite),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.toDouble()),
                                                  side: const BorderSide(
                                                      color: ColorConstants
                                                          .kSecondaryColor)))),
                                      onPressed: () {
                                        if (articleNumberController.text.isEmpty) {
                                          articleNumberFocusNode.requestFocus();
                                          Toast.showFloatingToast(
                                              'Enter the Article Number', context);
                                        }// Checking the article Barcode  normal or emo
                                        else if(articleNumberController.text.length != 13 && articleNumberController.text.length != 18 )
                                          {
                                            Toast.showFloatingToast(
                                                'Enter a valid article number', context);
                                          }
                                        else if(articleNumberController.text.length == 13 && artval.validate(articleNumberController.text) != "Valid")
                                        {
                                          Toast.showFloatingToast(
                                              artval.validate(articleNumberController.text),
                                              context);

                                          Toast.showFloatingToast(
                                              'Please enter a valid Article Number !',
                                              context);
                                          articleNumberFocusNode.requestFocus();
                                        }
                                        else if(articleNumberController.text.length == 18 && emoval.validate(articleNumberController.text) != "Valid")
                                        {
                                          Toast.showFloatingToast(
                                              emoval.validate(articleNumberController.text),
                                              context);

                                          Toast.showFloatingToast(
                                              'Please enter a valid Article Number !',
                                              context);
                                          articleNumberFocusNode.requestFocus();
                                        }
                                        else if(articlesFetch.length>0){
                                          for (int i =0;i<articlesFetch.length;i++){

                                            if(articlesFetch[i].ArticleNumber==articleNumberController.text
                                                && articlesFetch[i].Scanned==true
                                                )
                                              {
                                                Toast.showFloatingToast(
                                                    'Article ${articlesFetch[i].ArticleNumber} is already added..!', context);
                                              }
                                            else if(articlesFetch[i].ArticleNumber==articleNumberController.text
                                                && articlesFetch[i].Scanned==false){

                                              setState(() {
                                                articlesFetch[i].Scanned=true;
                                                });
                                              Toast.showFloatingToast(
                                                  'Article ${articlesFetch[i].ArticleNumber} is added..!', context);
                                            }


                                          }

                                            articleNumberController.clear();

                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 18.0.toDouble()),
                                        child: const Text(
                                          'ADD',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color:
                                                  ColorConstants.kAmberAccentColor),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          const SmallSpace(),

                          const SmallSpace(),


                          const Divider(),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text(
                                'Article Number',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 12),
                              ),
                              SizedBox(width: 25,),
                              Text('Remark',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 12),),
                              SizedBox(width: 35,),
                              Text('Type',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 12),)
                            ],
                          ),
                          const Divider(),
                          //Article list field
                          articlesFetch.isEmpty
                              ? Container()
                              : Container(
                                  constraints: BoxConstraints(maxHeight: 400),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Scrollbar(
                                    showTrackOnHover: true,
                                    child: ListView.builder(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: articlesFetch.length,
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      articlesFetch[index]
                                                          .ArticleNumber,
                                                      style: TextStyle(
                                                          letterSpacing: 1,
                                                          color: articlesFetch[
                                                                          index]
                                                                      .Scanned ==
                                                                  true
                                                              ? ColorConstants
                                                                  .kTextColor
                                                              : Colors.blue[300],
                                                          fontWeight: articlesFetch[
                                                                          index]
                                                                      .Scanned ==
                                                                  true
                                                              ? FontWeight.w500
                                                              : FontWeight.bold),
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      articlesFetch[index]
                                                          .Remark,
                                                      style: TextStyle(
                                                          letterSpacing: 1,
                                                          color: articlesFetch[
                                                          index]
                                                              .Scanned ==
                                                              true
                                                              ? ColorConstants
                                                              .kTextColor
                                                              : Colors.blue[300],
                                                          fontWeight: articlesFetch[
                                                          index]
                                                              .Scanned ==
                                                              true
                                                              ? FontWeight.w500
                                                              : FontWeight.bold),
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        articlesFetch[index]
                                                            .ArticleType,
                                                        style: TextStyle(
                                                            letterSpacing: 1,
                                                            color: articlesFetch[
                                                                            index]
                                                                        .Scanned ==
                                                                    true
                                                                ? ColorConstants
                                                                    .kTextColor
                                                                : Colors.blue[300],
                                                            fontWeight: articlesFetch[
                                                                            index]
                                                                        .Scanned ==
                                                                    true
                                                                ? FontWeight.w500
                                                                : FontWeight
                                                                    .bold))
                                                ),

                                                articlesFetch[index].Scanned == true
                                                    ? Expanded(
                                                  flex: 1,
                                                        child: Checkbox(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15),
                                                        ),
                                                        onChanged: (bool? value) {},
                                                        value: articlesFetch[index]
                                                            .Scanned,
                                                      ))
                                                    : Expanded(
                                                    flex: 1,
                                                    child: Checkbox(
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                      ),
                                                      onChanged: (bool? value) {},
                                                      value: articlesFetch[index]
                                                          .Scanned,
                                                    ))
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                          const Divider(),
                          const SmallSpace(),


                          Align(
                              alignment: Alignment.center,
                              child: Button(
                                  buttonText: 'CLOSE BAG',
                                  buttonFunction: () async {
                                    setState(() {
                                      visiblty=true;
                                    });
                                    try {
                                      await dataSync.upload();
                                    }
                                    catch (error1) {
                                      print("Error Response in Upload call-BagClose");
                                      print(error1);
                                      await LogCat().writeContent(
                                          "Error Response in Upload call-BagClose: $error1");
                                    }
                                    int unScannedArticles=0;
                                    print(unScannedArticles);
                                    for(int i =0;i<articlesFetch.length;i++)
                                      {
                                        if(articlesFetch[i].Scanned==false) {
                                          unScannedArticles = unScannedArticles + 1;
                                        }
                                      }
                                    print(unScannedArticles);
                                    if(unScannedArticles>0)
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Note!"),
                                            content: Text(
                                                "You still have ${unScannedArticles} articles to be scanned, would you like to skip it?"),
                                            actions: <Widget>[
                                              Button(
                                                buttonFunction: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                buttonText: "CANCEL",
                                              ),
                                              Button(
                                                buttonFunction: () async {
                                                  // await dataSync.upload();

                                                  final isBagPresent = await BagTable()
                                                      .select()
                                                      .BagNumber
                                                      .equals(bagController.text)
                                                      .toMapList();
                                                  if (isBagPresent.isEmpty) {
                                                    //when bag details not available in local DB.

                                                    final bag = BagTable()
                                                      ..BagNumber = bagController.text
                                                      ..BagDate =
                                                      DateTimeDetails().currentDate()
                                                      ..BagTime = DateTimeDetails().onlyTime()
                                                      ..BagType = 'Close';
                                                    bag.save();


                                                    await closeBag();
                                                    setState(() {
                                                      visiblty=false;
                                                    });
                                                    Toast.showToast(
                                                        'Bag ${widget.bagNumber} is Successfully Closed',
                                                        context);
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => BaggingServices()),
                                                            (route) => false);
                                                  }
                                                  else {
                                                    await closeBag();
                                                    setState(() {
                                                      visiblty=false;
                                                    });
                                                    Toast.showToast(
                                                        'Bag ${widget
                                                            .bagNumber} is Successfully Closed',
                                                        context);

                                                    Navigator.of(ctx).pop();
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                BaggingServices()),
                                                            (route) => false);
                                                  }
                                                },
                                                buttonText: "CONFIRM",
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    else {
                                      final isBagPresent = await BagTable()
                                          .select()
                                          .BagNumber
                                          .equals(bagController.text)
                                          .toMapList();
                                      if (isBagPresent.isEmpty) {
                                        //when bag details not available in local DB.

                                        final bag = BagTable()
                                          ..BagNumber = bagController.text
                                          ..BagDate =
                                          DateTimeDetails().currentDate()
                                          ..BagTime = DateTimeDetails().onlyTime()
                                          ..BagType = 'Close';
                                        bag.save();
                                        await closeBag();
                                        setState(() {
                                          visiblty=false;
                                        });
                                        Toast.showToast(
                                            'Bag ${widget.bagNumber} is Successfully Closed',
                                            context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BaggingServices()),
                                                (route) => false);
                                      }
                                      else {
                                        await closeBag();
                                        setState(() {
                                          visiblty=false;
                                        });
                                        Toast.showToast(
                                            'Bag ${widget
                                                .bagNumber} is Successfully Closed',
                                            context);

                                        // UtilFsNav.showToast("Bag ${widget.bagNumber} is successfully CLosed",context,BaggingServices());

                                        Navigator.of(ctx).pop();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    BaggingServices()),
                                                (route) => false);
                                      }
                                    }
                                    setState(() {
                                      visiblty=false;
                                    });
                                  }
                                  )
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          visiblty == true
              ? Center(
              child: Loader(
                  isCustom: true, loadingTxt: 'Please Wait...Loading...'))
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  /*----------------------------------Adding--------------------------------------------*/
  closeBag() async {
    await BaggingDBService().closeBag(
        widget.bagNumber,
        'Closed',
        DateTimeDetails().currentDate(),
        DateTimeDetails().onlyTime(),
        articlesFetch.length.toString(),
        cashToController.text);

    if (articlesFetch.isNotEmpty) {
      print("Articles is not empty");
      for (int i = 0; i < articlesFetch.length; i++) {
        if (articlesFetch[i].Remark=="Booked" && articlesFetch[i].Scanned==true) {
          await BookingDBService()
              .updateArticle(articlesFetch[i].ArticleNumber, 'Closed', widget.bagNumber);
        }
        if ((articlesFetch[i].Remark=="Returned" || articlesFetch[i].Remark=="> 7 Days" ) && articlesFetch[i].Scanned==true) {
          await BaggingDBService()
              .updateNotDeliveredArticleBag(articlesFetch[i].ArticleNumber, 'Closed');
        }
        if(articlesFetch[i].Scanned==true) {
          final closedArticles = BagArticlesTable()
            ..BagNumber = widget.bagNumber
            ..ArticleNumber = articlesFetch[i].ArticleNumber
            ..ArticleType = articlesFetch[i].ArticleType
            ..Status = 'Closed';
          closedArticles.save();
        }
      }
    }
  }



  /*------------------------------------------------------------------------------------*/

  void moveToPrevious(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Note!'),
            content: const Text(
                'Do you wish to save the details entered and then leave the page?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Button(
                      buttonText: 'CANCEL',
                      buttonFunction: () async {
                        print('Cancel is progress..!');
                        final bagDetails1 = await BagTable()
                            .select()
                            .BagType
                            .equals('Open')
                            .toMapList();
                        print('Bag Open Count- in Revised.');
                        print(bagDetails1.length);

                        for (int i = 0; i < bagDetails1.length; i++) {
                          print(bagDetails1[i].toString());
                        }

                        final bagDetails = await BagTable()
                            .select()
                            .BagNumber
                            .equals(bagController.text)
                            .delete();
                        final bagDetails2 = await BagTable()
                            .select()
                            .BagType
                            .equals('Open')
                            .toMapList();
                        print('Bag Open Count- in Revised.');
                        print(bagDetails2.length);

                        for (int i = 0; i < bagDetails2.length; i++) {
                          print(bagDetails2[i].toString());
                        }

                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => BagCloseScreen()),
                            (route) => false);
                      }),
                  Button(
                    buttonText: 'SAVE',
                    buttonFunction: () async {
                      Toast.showToast(
                          'Details has been added for the Bag ${widget.bagNumber}',
                          context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => BagCloseScreen()),
                          (route) => false);
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  /*----------------------------------Saving--------------------------------------------*/

  Future<bool> savingData(String amount, String commission) async {
    await saveArticlesToBag(amount, commission);

    return true;
  }

  saveArticlesToBag(String amount, String commission) async {
    print("Save articles");
    if (expansionArticle.isNotEmpty) {
      // for (int i = 0; i < receivedArticles.length; i++) {
      //   if (receivedArticles[i] != true) {
      //     final index = receivedArticles.indexWhere((element) => false);
      //     unScannedArticles.add(expansionArticle[index]);
      //   }
      // }
      for (int i = 0; i < expansionArticle.length; i++) {
        if (!jsonBagArticles.contains(expansionArticle[i])) {
          await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
              expansionArticle[i], expansionArticleType[i], 'Received');
        }
        if (receivedArticles[i] == true) {
          await BaggingDBService().updateBagArticlesToDB(widget.bagNumber,
              expansionArticle[i], expansionArticleType[i], 'Added');
          await BaggingDBService().addArticlesToDelivery(
              widget.bagNumber,
              articlesInBag[i].articleNumber!,
              articlesInBag[i].articleType!,
              articlesInBag[i].commission!,
              articlesInBag[i].amount!);
        }
      }
    }
  }
}
