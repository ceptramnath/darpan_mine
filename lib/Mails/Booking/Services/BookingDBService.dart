import 'dart:convert';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';
import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../LogCat.dart';

class BookingDBService {

  String access_token = "";
  String refresh_token = "";
  String validity = "";

  Future<String> SendBookingSMS(String artType,String ArtNo,String SenderMobile) async {
    //Checking token Validity
    final loginDetails = await USERLOGINDETAILS().select().toList();
    bool rtValue = ls.JwtCheck(loginDetails);
    print('JWT Function return value - ' +
        rtValue.toString());
    //when token is not valid getting token using refresh token
    bool value = false;
    if (!rtValue) {
     var ret= ls.Token_RefreshToken();
    }

    //Get data from database
    print("Inside Send Booking SMS function-$SenderMobile");
    var formatter = new DateFormat('dd/MM/yy');
    String BkgDt ="";
    String BkgTime ="";
    String BkgAmt ="";
    String AddresseeName ="";
    String AddresseeCityPin ="";
    String RecCity ="";
    String EmoValue="";

    String Message = "";
    var artdetail;
    if (artType == 'RL')
    {
      artdetail  = await LetterBooking()
          .select()
          .ArticleNumber
          .equals(ArtNo)
          .and
          .BookingDate
          .equals(DateTimeDetails().currentDate())
          .toMapList();
      print(await LetterBooking()
          .select().ArticleNumber
          .equals(ArtNo).toMapList());
     }
    else if (artType == 'SP') {
      artdetail = await SpeedBooking()
          .select()
          .ArticleNumber
          .equals(ArtNo)
          .and
          .BookingDate
          .equals(DateTimeDetails().currentDate())
          .toMapList();
      print(await SpeedBooking()
          .select().ArticleNumber
          .equals(ArtNo).toMapList());
    }
    else if (artType == 'PL') {
      artdetail = await ParcelBooking()
          .select()
          .ArticleNumber
          .equals(ArtNo)
          .and
          .BookingDate
          .equals(DateTimeDetails().currentDate())
          .toMapList();
      print(await ParcelBooking()
          .select().ArticleNumber
          .equals(ArtNo).toMapList());
    }

    else if (artType == 'EMO') {
      artdetail = await EmoBooking()
          .select()
          .ArticleNumber
          .equals(ArtNo)
          .and
          .BookingDate
          .equals(DateTimeDetails().currentDate())
          .toMapList();
      print(await EmoBooking()
          .select().ArticleNumber
          .equals(ArtNo).toMapList());
    }
    print(artdetail[0]);
    BkgDt = formatter.format(DateFormat('dd-MM-yyyy').parse(artdetail[0]["BookingDate"])) ;
    BkgTime ="${artdetail[0]["BookingTime"].toString().substring(0,2)}:${artdetail[0]["BookingTime"].toString().substring(2,4)}";
    BkgAmt=artdetail[0]["TotalCashAmount"].toString();
    EmoValue=artdetail[0]["SenderMoneyTransferValue"].toString();
    if(artdetail[0]["RecipientName"].toString().length>13)
      AddresseeName=artdetail[0]["RecipientName"].toString().substring(0,13);
    else
      AddresseeName=artdetail[0]["RecipientName"].toString();
    if(artdetail[0]["RecipientCity"].toString().length>8)
      AddresseeCityPin="(${artdetail[0]["RecipientCity"].toString().substring(0,8)}-${artdetail[0]["RecipientZip"].toString()})";
    else
      AddresseeCityPin="(${artdetail[0]["RecipientCity"].toString()}-${artdetail[0]["RecipientZip"].toString()})";
    // if(artType!="EMO")
    // Message = "$artType $ArtNo booked on $BkgDt $BkgTime for Rs $BkgAmt to Mr/Mrs $AddresseeName$AddresseeCityPin. Track your Article @ www.indiapost.gov.in. -INDPOST.";
    // else
    //   Message = "EMO No. $ArtNo booked on $BkgDt $BkgTime for Rs $EmoValue to Mr/Mrs $AddresseeName$AddresseeCityPin. Download postinfo mobile app. -INDPOST.";

    print(Message);

    // var headers = {
    //   'Content-Type': 'application/json'
    // };
    //
    // var request = http.Request('POST', Uri.parse('https://api.cept.gov.in/sendsms/api/values/sendsms'));
    // request.body = json.encode({
    //   "msg":Message,
    //   "phone": SenderMobile,
    //   "templateid": artType=="EMO"?"1007853038473138377" : "1007894198991758629",
    //   "entityid": "1001081725895192800",
    //   "appname": "Darpan Booking $artType"
    // });
    final userdata= await USERLOGINDETAILS().select().toMapList();
    print("Access token available is:${userdata[0]["AccessToken"]}");
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${userdata[0]["AccessToken"]}',
      'Cookie': 'JSESSIONID=0FD0D3C9DE467BB424AE830031187D90'
    };
    var request = http.Request('POST', Uri.parse(APIEndPoints().bookingSMS));
    request.body = json.encode({
      "customername": "$AddresseeName$AddresseeCityPin", //"Sathish(Mysuru-570010)",
      "articletype":  "$artType",
      "articleno": artType=="EMO" ? "$ArtNo" : "$artType $ArtNo",
      "bookingdate": artType=="EMO" ? "$BkgDt $BkgTime for Rs $EmoValue" : "$BkgDt $BkgTime for Rs $BkgAmt",//"30/06/23 11:46 for Rs 35000",
      "mobileno": "$SenderMobile"
    });

    request.headers.addAll(headers);
    print(request.body);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      return "Success";
    }
    else {
      print(response.reasonPhrase);
      await LogCat().writeContent(
          "${DateTimeDetails()
              .currentDateTime()}: Cannot Send SMS-$ArtNo-$SenderMobile-${response.stream.bytesToString()}");
      return "Failed";
    }

  }


  addFileToDB(String fileName, String filePath, String serviceText,
      String updatedAt) async {
    final addFileToDB = FileSyncDetail()
      ..FileName = fileName
      ..FilePath = filePath
      ..ServiceText = serviceText
      ..Status = 'Added To DB'
      ..UpdatedAt = updatedAt
      ..Processed = 'Y';
    await addFileToDB.save();
  }

  addRegisterLetterToDB(
      String date,
      String time,
      String articleNumber,
      String totalAmount,
      String totalCashAmount,
      String basePrice,
      String lineItemTotalAmount,
      String weightCode,
      String weight,
      String senderName,
      String senderAddress,
      String senderCity,
      String senderState,
      String senderZip,
      String senderEmail,
      String senderMobile,
      String recipientName,
      String recipientAddress,
      String recipientCity,
      String recipientState,
      String recipientZip,
      String taxAmount,
      String postageDue,
      String prepaidAmount,
      String vas,
      String vasValue,
      String elapsedTime,
      String isOnPostalService,
      String paymentMode) async {

    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();

    // var destOfcQuery = "SELECT * FROM OfficeMasterPinCode WHERE Pincode ='"+ recipientZip +
    // "' and Delivery='Delivery' and Region IS NOT NULL";
    // final destExec=await UserDB().execDataTable(destOfcQuery);
    // Map destOfc=destExec.asMap();

    print('Destination Pincode');
    print(recipientZip);

    final destOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(recipientZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .startBlock.OfficeType.equals("PO").or.OfficeType.equals("HO").endBlock
        .and
        .endBlock
        .toList();

    final orgOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(senderZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .endBlock
        .toList();

    // print(destOfc.length);
    // var orgOfcQuery = "SELECT * FROM OfficeMasterPinCode WHERE Pincode ='"+ senderZip +
    //     "' and Delivery='Delivery' and Region IS NOT NULL";
    // final orgExec=await UserDB().execDataTable(orgOfcQuery);
    // Map orgOfc=orgExec.asMap();

    print(senderZip);

    print('Origin Ofc Details');
    print(orgOfc.length);

    print("inside Letter Booking DB Save..!");

    final registerLetterBooking = await LetterBooking()
      ..ArticleNumber = articleNumber
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserID = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount = totalAmount
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyID = 'INR'
      ..TenderID = paymentMode
      ..TotalCashAmount = totalCashAmount
      ..RoundOffDifference = '0.0'
      ..CircleCode =ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..BasePrice = basePrice
      ..LineItemTotalAmount = totalAmount
      ..Division = fileMaster[0].DIVISION
      ..OrderType = fileMaster[0].ORDERTYPE_LETTERPARCEL
      ..Quantity = '1'
      ..ProductType = fileMaster[0].PRODUCT_TYPE
      ..ProductCode = 'LETTER'
      ..WeightCode = weightCode
      ..Weight = weight
      ..SenderCustomerNumber = ofcMaster[0].ONETIMECUSTCODE
      ..SenderName = senderName
      ..SenderAddress = senderAddress
      ..SenderZip = senderZip
      ..SenderCity = senderCity
      ..SenderState = orgOfc[0].Region.toString()
      ..SenderCountry = 'IN'
      ..RecipientName = recipientName
      ..RecipientAddress = recipientAddress
      ..RecipientCity = recipientCity
      ..RecipientZip = recipientZip
      ..RecipientState = destOfc[0].Region.toString()
      ..RecipientCountryID = 'IN'
      ..ReturnName = senderName
      ..ReturnAddress = senderAddress
      ..ReturnCity = senderCity
      ..ReturnZip = senderZip
      ..ReturnState = orgOfc[0].Region.toString()
      ..ReturnCountryID = 'IN'
      ..CommissionAmount = ''
      ..TaxAmount = taxAmount
      ..RepaymentMode = 'EMO'
      ..PostageDue = postageDue
      ..PrepaidAmount = prepaidAmount
      ..MaterialGroup = fileMaster[0].MATERIALGROUP_LETTER
      ..DestinationFacility = destOfc.isEmpty ? "" : destOfc[0].FacilityID
      ..VAS = vas
      ..VASValue = vasValue
      ..ElapsedTime = '000037'
      ..IsFullyPrepaid = '0'
      ..IsOnPostalService = isOnPostalService == 'Regular' ? '0' : '1'
      ..FileCreated = 'N'
      ..Status = 'Booked'
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = "N";
    await registerLetterBooking.save();
    // addFileToDB(file.toString(), path.toString(), 'Register Letter Booking', DateTimeDetails().currentDateTime());
  }

  addParcelToDB(
      String date,
      String time,
      String articleNumber,
      String totalAmount,
      String totalCashAmount,
      String basePrice,
      String lineItemTotalAmount,
      String weightCode,
      String weight,
      String customerName,
      String customerAddress,
      String customerCity,
      String customerState,
      String customerZip,
      String recipientName,
      String recipientAddress,
      String recipientCity,
      String recipientState,
      String recipientZip,
      String taxAmount,
      String postageDue,
      String prepaidAmount,
      String vas,
      String vasValue,
      String isAMS,
      String elapsedTime,
      String isFullyPrepaid,
      String isOnPostalService,
      String isFileCreated,
      String paymentMode) async {
    // List<List<dynamic>> rows=[];
    // List bookedParcel = [articleNumber, 'BO11304216001', '570001', 'PS', '54600012',
    //   '000', 'SL$date$articleNumber', totalAmount, date, time, 'INR', 'S',
    //   totalCashAmount, '0.0', '50015379', '11', '1', basePrice, totalAmount, 'MO',
    //   'ZAM', 'S', 'PARCEL', weightCode, weight, '1', customerNumber, customerName,
    //   customerAddress, customerCity, customerZip, customerState, 'IN', recipientName,
    //   recipientAddress, recipientCity, recipientZip, recipientState, 'IN', customerName,
    //   customerAddress, customerCity, customerZip, customerState, 'IN', '0.0', 'DOM',
    //   'PO22201301000', taxAmount, 'EMO', postageDue, prepaidAmount, 'REG', '', isAMS,
    //   elapsedTime, isFullyPrepaid, isOnPostalService];
    // rows.add(bookedParcel);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_PL_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);
    print("Selected Booking type is  $isOnPostalService");
    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    print("Printing Time Stamp");
    print(sec);
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
    final destOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(recipientZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .startBlock.OfficeType.equals("PO").or.OfficeType.equals("HO").endBlock
        .and
        .endBlock
        .toList();

    final orgOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(customerZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .endBlock
        .toList();

    final parcelBooking = await ParcelBooking()
      ..ArticleNumber = articleNumber
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserID = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount = totalAmount
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyID = 'INR'
      ..TenderID = paymentMode
      ..TotalCashAmount = totalCashAmount
      ..RoundOffDifference = '0.0'
      ..CheckerUserID = ofcMaster[0].EMPID
      ..CircleCode =ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..BasePrice = basePrice
      ..LineItemTotalAmount = totalAmount
      ..Division = fileMaster[0].DIVISION
      ..OrderType = fileMaster[0].ORDERTYPE_LETTERPARCEL
      ..ProductType = fileMaster[0].PRODUCT_TYPE
      ..ProductCode = 'PARCEL'
      ..WeightCode = weightCode
      ..Weight = weight
      ..Quantity = '1'
      ..SenderCustomerNumber =  ofcMaster[0].ONETIMECUSTCODE
      ..SenderName = customerName
      ..SenderAddress = customerAddress.isEmpty?"":customerAddress
      ..SenderCity = customerCity
      ..SenderZip = customerZip
      ..SenderState = orgOfc[0].Region.toString()
      ..SenderCountry = 'IN'
      ..RecipientName = recipientName
      ..RecipientAddress = recipientAddress.isEmpty?"":recipientAddress
      ..RecipientCity = recipientCity
      ..RecipientZip = recipientZip
      ..RecipientState = destOfc[0].Region.toString()
      ..RecipientCountryID = 'IN'
      ..ReturnName = customerName
      ..ReturnAddress = customerAddress.isEmpty?"":customerAddress
      ..ReturnCity = customerCity
      ..ReturnZip = customerZip
      ..ReturnState = orgOfc[0].Region.toString()
      ..ReturnCountryID = 'IN'
      ..CommissionAmount = '0.0'
      ..MaterialGroup = fileMaster[0].MATERIALGROUP_LETTER
      ..DestinationFacility = destOfc[0].FacilityID
      ..TaxAmount = taxAmount
      ..RepaymentMode = 'EMO'
      ..PostageDue = postageDue
      ..PrepaidAmount = prepaidAmount
      ..VAS = 'REG'
      ..VASValue = ''
      ..IsAMS = isAMS
      ..ElapsedTime = '000037'
      ..IsFullPrepaid = isFullyPrepaid
      ..IsOnPostalService = isOnPostalService == 'Regular' ? '0' : '1'
      ..FileCreated = 'N'
      ..Status = 'Booked'
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = "N";
    await parcelBooking.save();
    // addFileToDB(file.toString(), path.toString(), 'Parcel Booking', DateTimeDetails().currentDateTime());
  }

  addSpeedToDB(
      String articleNumber,
      String date,
      String time,
      String totalAmount,
      String totalCashAmount,
      String basePrice,
      String lineItemTotalAmount,
      String weightCode,
      String weight,
      String distancecode,
      String distance,
      String customerName,
      String customerAddress,
      String customerCity,
      String customerState,
      String customerZip,
      String customerMobile,
      String recipientName,
      String recipientAddress,
      String recipientCity,
      String recipientState,
      String recipientZip,
      String taxAmount,
      String postageDue,
      String prepaidAmount,
      String vas,
      String vasValue,
      String elapsedTime,
      String isFullyPrepaid,
      String isOnPostalService,
      String isFileCreated,
      String paymentMode) async {
    // List<List<dynamic>> rows=[];
    // List bookedSpeed = [articleNumber, 'BO11304216001', '570001', 'PS', '54600012', '000',
    //   'SL$date$articleNumber', totalAmount, date, time, 'INR', 'S',
    //   totalCashAmount, '0.0', '11', '1', basePrice, totalAmount, 'MO', 'ZPP', 'S',
    //   'SP_INLAND', weightCode, weight, 'NL2', distance, '1', customerNumber, customerName,
    //   customerAddress, customerCity, customerState, customerZip, 'IN', customerMobile,
    //   recipientName, recipientAddress, recipientCity, recipientState, recipientZip, 'IN',
    //   customerName, customerAddress, customerCity, customerState, customerZip, 'IN',
    //   taxAmount, postageDue, prepaidAmount, 'DOM', 'PO22201301000', elapsedTime,
    //   isFullyPrepaid, '', '', 'N'];
    // rows.add(bookedSpeed);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_SP_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);
    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    print("Printing Time Stamp");
    print(sec);

    print(recipientZip);
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
    final destOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(recipientZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .startBlock.OfficeType.equals("PO").or.OfficeType.equals("HO").endBlock
        .and
        .endBlock
        .toList();

    final orgOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(customerZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .endBlock
        .toList();

    print("SPEED POST DB Insertion..!");
    print(totalAmount);
    print(totalCashAmount);
    print(taxAmount);
    print(basePrice);

    final speedBooking = await SpeedBooking()
      ..ArticleNumber = articleNumber
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserID = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount =totalAmount
      // (double.parse(basePrice)+ double.parse(taxAmount)).toStringAsFixed(2)
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyID = 'INR'
      ..TenderID = paymentMode
      ..TotalCashAmount = totalCashAmount
      ..RoundOffDifference = isFullyPrepaid=="1"?"0.0":"0."+taxAmount.split('.').last.toString()
      // (double.parse(taxAmount).round()-double.parse(taxAmount)).toStringAsFixed(2)
      //BO21308110002
      ..CircleCode = ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..BasePrice = basePrice
      ..LineItemTotalAmount = lineItemTotalAmount
      ..Division = fileMaster[0].DIVISION
      ..OrderType = fileMaster[0].ORDERTYPE_SP
      ..ProductType = fileMaster[0].PRODUCT_TYPE
      ..ProductCode = 'SP_INLAND'
      ..WeightCode = weightCode
      ..Weight = weight
      ..DistanceCode = distancecode
      ..Distance = distance
      ..Quantity = '1'
      ..SenderCustomerNumber = ofcMaster[0].ONETIMECUSTCODE
      ..SenderName = customerName
      ..SenderAddress = customerAddress
      ..SenderCity = customerCity
      ..SenderState = orgOfc[0].Region.toString()
      ..SenderZip = customerZip
      ..SenderCountry = 'IN'
      ..SenderMobile = customerMobile
      ..RecipientName = recipientName
      ..RecipientAddress = recipientAddress
      ..RecipientCity = recipientCity
      ..RecipientState = destOfc[0].Region.toString()
      ..RecipientZip = recipientZip
      ..RecipientCountryID = 'IN'
      ..ReturnName = customerName
      ..ReturnAddress = customerAddress
      ..ReturnCity = customerCity
      ..ReturnState = orgOfc[0].Region.toString()
      ..ReturnZip = customerZip
      ..ReturnCountryID = 'IN'
      ..TaxAmount = taxAmount
      ..PostageDue = postageDue
      ..PrepaidAmount = prepaidAmount
      ..MaterialGroup = fileMaster[0].MATERIALGROUP_SP
      ..DestinationFacility = destOfc[0].FacilityID
      ..ElapsedTime = elapsedTime
      ..IsFullPrepaid = isFullyPrepaid
      ..VAS = vas
      ..VASValue = vasValue
      ..FileCreated = 'N'
      ..Status = 'Booked'
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = "N";
    await speedBooking.save();
    // addFileToDB(file.toString(), path.toString(), 'Speed Post Booking', DateTimeDetails().currentDateTime());
  }

  addEMOToDB(
      String pnrnumber,
      String date,
      String time,
      String totalAmount,
      String basePrice,
      String orderType,
      String productType,
      String valueCode,
      String value,
      String customerName,
      String customerAddress,
      String customerCity,
      String customerState,
      String customerZip,
      String recipientName,
      String recipientAddress,
      String recipientCity,
      String recipientState,
      String recipientZip,
      String recipientMobile,
      String recipientEmail,
      String commissionAmount,
      String senderMoneyTransferValue,
      String moMessage,
      bool isVPP) async {
    // List<List<dynamic>> rows=[];
    // List bookedEMO = ['$date$time',
    //   'BO11304216001', '570010', 'PS', '54600012', '000',
    //   'SL00$date$time', totalAmount, date, time,
    //   'INR', 'S', totalAmount, '0.00', '50015379', '11', '1', basePrice,
    //   totalAmount, 'MO', orderType, productType, 'EMO', valueCode, value, '1',
    //   customerNumber, customerName, customerAddress, customerCity, customerState,
    //   customerZip, 'IN', recipientName, recipientAddress, recipientCity,
    //   recipientState, recipientZip, 'IN', recipientMobile, recipientEmail, customerName,
    //   customerAddress, customerCity, customerState, customerZip, 'IN', commissionAmount,
    //   'DMR', 'PO21310210000', senderMoneyTransferValue, 'MOID$date$time', moMessage,
    //   '', '0', ''];
    // rows.add(bookedEMO);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_MO_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);
    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    print("Printing Time Stamp");
    print(sec);
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
    final destOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(recipientZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .startBlock.OfficeType.equals("PO").or.OfficeType.equals("HO").endBlock
        .and
        .endBlock
        .toList();

    final orgOfc = await OfficeMasterPinCode()
        .select()
        .Pincode
        .equals(customerZip)
        .and
        .startBlock
        .Delivery
        .equals("Delivery")
        .and
        .Region
        .not
        .equalsOrNull(" ")
        .and
        .endBlock
        .toList();

    final emoBooking = await EmoBooking()
      ..ArticleNumber = pnrnumber
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserID = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount = totalAmount
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyID = 'INR'
      ..TenderID = 'S'
      ..TotalCashAmount = totalAmount
      ..RoundOffDifference = "0.00"
      ..CheckerUserID = ofcMaster[0].EMPID
      ..CircleCode = ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..BasePrice = basePrice
      ..LineItemTotalAmount = totalAmount
      ..Division = fileMaster[0].DIVISION
      ..OrderType = orderType
      ..ProductType = productType
      ..ProductCode = 'EMO'
      ..ValueCode = valueCode
      ..Value = value
      ..Quantity = '1'
      ..SenderCustomerNumber = ofcMaster[0].ONETIMECUSTCODE
      ..SenderName = customerName
      ..SenderAddress = customerAddress
      ..SenderCity = customerCity
      //..SenderState = customerState
      ..SenderState = orgOfc[0].Region.toString()
      ..SenderZip = customerZip
      ..SenderCountry = 'IN'
      ..RecipientName = recipientName
      ..RecipientAddress = recipientAddress
      ..RecipientCity = recipientCity
      // ..RecipientState = recipientState
      ..RecipientState = destOfc[0].Region.toString()
      ..RecipientZip = recipientZip
      ..RecipientCountryID = 'IN'
      ..RecipientMobile = recipientMobile
      ..RecipientEmail = recipientEmail
      ..ReturnName = customerName
      ..ReturnAddress = customerAddress
      ..ReturnCity = customerCity
      // ..ReturnState = customerState
      ..ReturnState = orgOfc[0].Region.toString()
      ..ReturnZip = customerZip
      ..ReturnCountryID = 'IN'
      ..CommissionAmount = commissionAmount
      ..MaterialGroup = fileMaster[0].MATERIALGROUP_EMO
      ..DestinationFacility = destOfc[0].FacilityID
      ..SenderMoneyTransferValue = senderMoneyTransferValue
      ..MOTrackingID = pnrnumber
      ..MOMessage = moMessage
      ..ElapsedTime = '000134'
      ..BulkAddressType = '0'
      ..VPMOIdentifier = isVPP ? 'X' : ''
      ..FileCreated = 'N'
      ..Status = 'Booked'
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = "N";
   await emoBooking.save();
    // addFileToDB(file.toString(), path.toString(), 'MO Booking', DateTimeDetails().currentDateTime());
  }

  //Commented below function by Rohit as it's not being used
  /*
  addPMOToDB(String totalAmount, String basePrice, String orderType, String productType,
      String valueCode, String value, String customerNumber, String customerName,
      String customerAddress, String customerCity, String customerState,
      String customerZip, String recipientName, String recipientAddress,
      String recipientCity, String recipientState, String recipientZip,
      String recipientMobile, String recipientEmail, String senderMoneyTransferValue,
      String moMessage, String articleNumber) async {
    // List<List<dynamic>> rows=[];
    // List bookedPMO = [DateTimeDetails().dateCharacter() + DateTimeDetails().timeCharacter(),
    //   'BO11304216001', '570010', 'PS', '54600012', '000',
    //   'SL00${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
    //   totalAmount, DateTimeDetails().dateCharacter(), DateTimeDetails().timeCharacter(),
    //   'INR', 'S', totalAmount, '0.00', '50015379', '11', '1', basePrice,
    //   totalAmount, 'MO', orderType, productType, 'PMO', valueCode, value, '1',
    //   customerNumber, customerName, customerAddress, customerCity, customerState,
    //   customerZip, 'IN', recipientName, recipientAddress, recipientCity,
    //   recipientState, recipientZip, 'IN', recipientMobile, recipientEmail, customerName,
    //   customerAddress, customerCity, customerState, customerZip, 'IN', '0', 'DMR',
    //   'PO21310210000', senderMoneyTransferValue,
    //   'MOID${DateTimeDetails().dateCharacter()}${DateTimeDetails().timeCharacter()}',
    //   moMessage, '', '0', ''];
    // rows.add(bookedPMO);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_MO_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);

    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode().select().FacilityID.equals(ofcMaster[0].BOFacilityID).toList();
    final fileMaster = await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
    final destOfc = await await OfficeMasterPinCode().select().Pincode.equals(recipientZip).toList();

    final emoBooking = EmoBooking()
      ..ArticleNumber = articleNumber
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserID = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL'+ofcMaster[0].EMOCODE.toString()+'$time'
      ..TotalAmount = totalAmount
      ..BookingDate = DateTimeDetails().dateCharacter()
      ..BookingTime = DateTimeDetails().timeCharacter()
      ..CurrencyID = 'INR'
      ..TenderID = 'S'
      ..TotalCashAmount = totalAmount
      ..RoundOffDifference = "0.00"
      ..CheckerUserID = ofcMaster[0].EMPID
      ..CircleCode = pincodeMaster[0].FacilityID
      ..LineItemNumber = '1'
      ..BasePrice = basePrice
      ..LineItemTotalAmount = totalAmount
      ..Division = fileMaster[0].DIVISION
      ..OrderType = orderType
      ..ProductType = productType
      ..ProductCode = 'PMO'
      ..ValueCode = valueCode
      ..Value = value
      ..Quantity = '1'
      ..SenderCustomerNumber = customerNumber
      ..SenderName = customerName
      ..SenderAddress = customerAddress
      ..SenderCity = customerCity
      ..SenderState = customerState
      ..SenderZip = customerZip
      ..SenderCountry = 'IN'
      ..RecipientName = recipientName
      ..RecipientAddress = recipientAddress
      ..RecipientCity = recipientCity
      ..RecipientState = recipientState
      ..RecipientZip = recipientZip
      ..RecipientCountryID = 'IN'
      ..RecipientMobile = recipientMobile
      ..RecipientEmail = recipientEmail
      ..ReturnName = customerName
      ..ReturnAddress = customerAddress
      ..ReturnCity = customerCity
      ..ReturnState = customerState
      ..ReturnZip = customerZip
      ..ReturnCountryID = 'IN'
      ..CommissionAmount = '0'
      ..MaterialGroup = 'DMR'
      ..DestinationFacility = 'PO21310210000'
      ..SenderMoneyTransferValue = senderMoneyTransferValue
      ..MOTrackingID = 'MOID$articleNumber'
      ..MOMessage = 'PM Relief Fund'
      ..ElapsedTime = ''
      ..BulkAddressType = '0'
      ..VPMOIdentifier = ''
      ..FileCreated = 'N'
      ..Status = 'Booked'
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = "N";
    emoBooking.save();
    // addFileToDB(file.toString(), path.toString(), 'MO Booking', DateTimeDetails().currentDateTime());
  }
   */
  addCancelToDB(List articleDetails, String reason) async {
    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    final ofcMaster = await OFCMASTERDATA().select().toList();
    final addToCancel = await CancelBooking()
      ..FacilityId = articleDetails[0]['FacilityId']
      ..BookingFacilityZip = articleDetails[0]['BookingFacilityZip']
      ..DistributionChannel = articleDetails[0]['DistributionChannel']
      ..UserId = articleDetails[0]['UserID']
      ..CounterNumber = articleDetails[0]['CounterNumber']
      ..InvoiceNumber = 'CN' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount = articleDetails[0]['TotalAmount']
      ..BookingDate = articleDetails[0]['BookingDate']
      ..BookingTime = articleDetails[0]['BookingTime']
      ..CurrencyId = articleDetails[0]['CurrencyID']
      ..TenderId = articleDetails[0]['TenderID']
      ..TotalCashAmount = articleDetails[0]['TotalCashAmount']
      ..RoundOffDifferenceAmount = articleDetails[0]['RoundOffDifference']
      ..ParentInvoiceNumber = articleDetails[0]['InvoiceNumber']
      ..CircleCode = articleDetails[0]['CircleCode']
      ..LineItemNumber = articleDetails[0]['LineItemNumber']
      ..BasePrice = articleDetails[0]['BasePrice']
      ..LineItemTotalAmount = articleDetails[0]['LineItemTotalAmount']
      ..ArticleNumber = articleDetails[0]['ArticleNumber']
      ..Division = articleDetails[0]['Division']
      ..OrderType = articleDetails[0]['OrderType']
      ..ProductType = articleDetails[0]['ProductType']
      ..ProductCode = articleDetails[0]['ProductCode']
      ..WeightCode = articleDetails[0]['WeightCode']
      ..Weight = articleDetails[0]['Weight']
      ..Quantity = articleDetails[0]['Quantity']
      ..DistanceCode = articleDetails[0]['DistanceCode'] ?? ''
      ..Distance = articleDetails[0]['Distance'] ?? ''
      ..SenderCustomerId = articleDetails[0]['SenderCustomerNumber']
      ..RecipientCountryId = articleDetails[0]['RecipientCountryID']
      ..TaxAmount = articleDetails[0]['TaxAmount']
      ..PostageDue = articleDetails[0]['PostageDue']
      ..PrepaidAmount = articleDetails[0]['PrepaidAmount'] ?? '0'
      ..MaterialGroup = articleDetails[0]['MaterialGroup']
      ..IsFullPrepaid = articleDetails[0]['IsFullyPrepaid']
      ..VAS = articleDetails[0]['VAS']
      ..VASValue = articleDetails[0]['VASValue']
      // ..FileName = fileName
      ..FileCreated = 'N'
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = 'N'
      ..CancellationReason = reason;
    await addToCancel.save();
    // addFileToDB(file.toString(), path.toString(), 'Cancel Booking', DateTimeDetails().currentDateTime());
  }

  addBillerCancelToDB(List articleDetails, String reason) async {
    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    final ofcMaster = await OFCMASTERDATA().select().toList();
    final fileMaster = await FILEMASTERDATA().select().toList();
    final addToCancel = await CancelBiller()
      ..FacilityId = articleDetails[0]['FacilityId']
      ..BookingFacilityZip = articleDetails[0]['Zip']
      ..DistributionChannel = articleDetails[0]['Channel']
      ..UserId = ofcMaster[0].EMPID
      ..CounterNumber = articleDetails[0]['CounterNumber']
      ..InvoiceNumber = 'CN' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()
      ..TotalAmount = articleDetails[0]['TotalAmount']
      ..BookingDate = articleDetails[0]['BookingDate']
      ..BookingTime = articleDetails[0]['BookingTime']
      ..CurrencyId = articleDetails[0]['CurrencyId']
      ..TenderId = articleDetails[0]['TenderId']
      ..TotalCashAmount = articleDetails[0]['TotalCashAmount']
      ..RoundOffDifferenceAmount = articleDetails[0]['RoundOffDifference']
      ..ParentInvoiceNumber = articleDetails[0]['InvoiceNumber']
      ..CircleCode = articleDetails[0]['CircleCode']
      ..LineItemNumber = articleDetails[0]['LineItemNumber']
      ..LineItemTotalAmount = articleDetails[0]['LineItemTotalAmount']
      ..ArticleNumber = articleDetails[0]['ArticleNumber']
      ..Division = articleDetails[0]['Division']
      ..OrderType = articleDetails[0]['OrderType']
      ..ProductType = articleDetails[0]['ProductType']
      ..ProductCode = articleDetails[0]['ProductCode']
      ..ValueCode = articleDetails[0]['ValueCode']
      ..Value = articleDetails[0]['Value']
      ..Quantity = articleDetails[0]['Quantity']
      ..SenderCustomerId = articleDetails[0]['CustomerId']
      ..IsReversed = "1"
      ..MaterialGroup = articleDetails[0]['MaterialGroup']
      ..SerialNumber = "1"
      ..AddlBillInfo = articleDetails[0]['AdditionalBillInfo']
      ..AddlBillAmountInfo = articleDetails[0]['AdditionalBillAmountInfo']
      ..BillerID = articleDetails[0]['BillerId']
      ..BillerName = articleDetails[0]['BillerName']
      ..FileCreated = 'N'
      ..FileTransmitted = 'N'
      ..CancellationReason = reason;

   await  addToCancel.save();
    // addFileToDB(file.toString(), path.toString(), 'Cancel Booking', DateTimeDetails().currentDateTime());
  }

  // addTransactionToDB(String articleNumber, String date,
  //     String time, String totalAmount, String articleType, String senderName,
  //     String receiverPinCode, String additionalServiceAmount,
  //     String status) {
  //   final addTransaction = BookingTransactionTable()
  //     ..TransactionID = articleNumber
  //     ..Date = date
  //     ..Time = time
  //     ..TotalAmount = totalAmount
  //     ..ArticleType = articleType
  //     ..SenderName = senderName
  //     ..ReceiverPinCode = receiverPinCode
  //     ..AdditionalServiceAmount = additionalServiceAmount
  //     ..Status = status;
  //   addTransaction.save();
  // }

  // addCashToDB(String transactionNumber, String articleNumber, String articleType,
  //     String cashAmount, String cashType, String date, String time) {
  //   final addCash = BookingCashTable()
  //     ..CashTransactionID = transactionNumber
  //     ..ArticleNumber = articleNumber
  //     ..ArticleType = articleType
  //     ..CashAmount = cashAmount
  //     ..CashType = cashType
  //     ..CashTransactionDate = date
  //     ..CashTransactionTime = time;
  //   addCash.save();
  // }

  // updateArticle(String articleNumber, String status) async {
  //   final articleDetails = await MailBooking()
  //       .select()
  //       .ArticleNumber
  //       .equals(articleNumber)
  //       .toMapList();
  //   final addToDB = MailBooking()
  //     ..TransactionNumber = articleDetails[0]['TransactionNumber']
  //     ..InvoiceDate = articleDetails[0]['InvoiceDate']
  //     ..InvoiceTime = articleDetails[0]['InvoiceTime']
  //     ..ArticleNumber = articleNumber
  //     ..Type = articleDetails[0]['Type']
  //     ..ArticleWeight = articleDetails[0]['ArticleWeight']
  //     ..WeightAmount = articleDetails[0]['WeightAmount']
  //     ..PrepaidAmount = articleDetails[0]['PrepaidAmount'] ?? '0'
  //     ..RegistrationFee = articleDetails[0]['RegistrationFee']
  //     ..AcknowledgeAmount = articleDetails[0]['AcknowledgeAmount']
  //     ..InsuranceAmount = articleDetails[0]['InsuranceAmount']
  //     ..VPPAmount = articleDetails[0]['VPPAmount']
  //     ..AirMailServiceAmount = articleDetails[0]['AirMailServiceAmount']
  //     ..CommissionAmount = articleDetails[0]['CommissionAmount']
  //     ..TotalAmount = articleDetails[0]['TotalAmount']
  //     ..EMOMessage = articleDetails[0]['EMOMessage']
  //     ..SenderName = articleDetails[0]['SenderName']
  //     ..SenderAddress = articleDetails[0]['SenderAddress']
  //     ..SenderPinCode = articleDetails[0]['SenderPinCode']
  //     ..SenderCity = articleDetails[0]['SenderCity']
  //     ..SenderState = articleDetails[0]['SenderState']
  //     ..SenderCountry = articleDetails[0]['SenderCountry']
  //     ..SenderEmail = articleDetails[0]['SenderEmail']
  //     ..SenderPhone = articleDetails[0]['SenderPhone']
  //     ..AddresseeName = articleDetails[0]['AddresseeName']
  //     ..AddresseeAddress = articleDetails[0]['AddresseeAddress']
  //     ..AddresseePinCode = articleDetails[0]['AddresseePinCode']
  //     ..AddresseeCity = articleDetails[0]['AddresseeCity']
  //     ..AddresseeState = articleDetails[0]['AddresseeState']
  //     ..AddresseeCountry = articleDetails[0]['AddresseeCountry']
  //     ..AddresseeEmail = articleDetails[0]['AddresseeEmail']
  //     ..AddresseePhone = articleDetails[0]['AddresseePhone']
  //     ..Status = status;
  //   addToDB.upsert();
  // }

  updateArticle(String articleNumber, String status, String bagNumber) async {
    final letterDetails = await LetterBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (letterDetails.isNotEmpty) {
      await LetterBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'BagNumber': bagNumber});
    }
    final speedDetails = await SpeedBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (speedDetails.isNotEmpty) {
      await SpeedBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'BagNumber': bagNumber});
    }
    final parcelDetails = await ParcelBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (parcelDetails.isNotEmpty) {
      await ParcelBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'BagNumber': bagNumber});
    }
    final emoDetails = await EmoBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (emoDetails.isNotEmpty) {
      await EmoBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'BagNumber': bagNumber});
    }
  }

  updateCancelledArticle(
      String articleNumber, String status, String reason) async {
    final letterDetails = await LetterBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (letterDetails.isNotEmpty) {
      await LetterBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'CancellationReason': reason});
    }
    final speedDetails = await SpeedBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (speedDetails.isNotEmpty) {
      await SpeedBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'CancellationReason': reason});
    }
    final parcelDetails = await ParcelBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (parcelDetails.isNotEmpty) {
      await ParcelBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'CancellationReason': reason});
    }
    final emoDetails = await EmoBooking()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (emoDetails.isNotEmpty) {
      await EmoBooking()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'CancellationReason': reason});
    }
    final billerDetails = await BillFile()
        .select()
        .ArticleNumber
        .equals(articleNumber)
        .toMapList();
    if (billerDetails.isNotEmpty) {
      await BillFile()
          .select()
          .ArticleNumber
          .equals(articleNumber)
          .update({'Status': status, 'CancellationReason': reason});
    }
  }

  addProductSaleToDB(String totalPrice, String date, String time,
      double productPrice, String productName, String quantity) async {

    int sec = (DateTime.now().millisecondsSinceEpoch / 1000).toInt();

    print("Printing Time Stamp");
    print(sec);

    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();

    final productSold = ProductSaleTable()
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..BookingFacilityZip = ofcMaster[0].Pincode
      ..DistributionChannel = 'PS'
      ..UserId = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      // ..InvoiceNumber = 'SL' + ofcMaster[0].EMOCODE.toString() + '$time'
      ..InvoiceNumber = 'SL' +
          ofcMaster[0]
              .EMOCODE
              .toString()
              .substring(0, ofcMaster[0].EMOCODE.toString().length - 2) +
          ofcMaster[0].BOFacilityID.toString().substring(
              ofcMaster[0].BOFacilityID.toString().length - 3,
              ofcMaster[0].BOFacilityID.toString().length) +
          sec.toString()

      ..TotalAmount = totalPrice
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyId = 'INR'
      ..TenderId = 'S'
      ..TotalCashAmount = totalPrice
      ..RoundOffDifference = '0'
      ..CircleCode = ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..BasePrice = productPrice.toString()
      ..LineItemTotalAmount = totalPrice
      ..Division = 'PH'
      ..OrderType = 'ZRP'
      ..ProductType = 'NS'
      ..ProductCode = '$productName'
      ..Quantity = quantity
      ..SenderCustomerId = ofcMaster[0].ONETIMECUSTCODE
      ..MaterialGroup = 'PST'
      ..DestinationFacilityId = ofcMaster[0].BOFacilityID
      ..UoM = 'EA'
      ..ElapsedTime = '000037'
      ..FileCreated = "N"
      // ..FileCreatedDate = DateTimeDetails().currentDateTime()
      // ..FileName = fileName
      ..FileTransmitted = 'N';
    await productSold.save();
    // addFileToDB(file.toString(), path.toString(), 'Product Sale', DateTimeDetails().currentDateTime());
  }

  updateCashInDB(double amount, String type, String description) async {
    final addCash = CashTable()
      ..Cash_ID = description +
          DateTimeDetails().onlyTime().toString().replaceAll(':', '').trim()
      ..Cash_Date = DateTimeDetails().currentDate()
      ..Cash_Time = DateTimeDetails().onlyTime()
      ..Cash_Type = type
      ..Cash_Amount = amount.toDouble()
      ..Cash_Description = description;
    await addCash.upsert();
  }

  updateDay(String type, String date, String time, String amount) async
  {
    final dayDetail = await DayModel().select().DayBeginDate.equals(date).toMapList();

    final dayDetails = DayModel()
      ..DayBeginDate = type != 'End' ? date : dayDetail[0]['DayBeginDate']
      ..DayBeginTime = type != 'End' ? time : dayDetail[0]['DayBeginTime']
      ..CashOpeningBalance =
          type != 'End' ? amount : dayDetail[0]['CashOpeningBalance']
      ..CashClosingBalance = type == 'End' ? amount : ''
      ..DayCloseDate = type == 'End' ? date : ''
      ..DayBeginTime = type == 'End' ? time : '';
    await dayDetails.upsert();
    final dayDetail1 = await DayModel().select().toMapList();
    print("Day details $dayDetail1");
  }

  addBillFile(String accountNumber, String amount, String date, String time,
      String name, String id) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final pincodeMaster = await OfficeMasterPinCode()
        .select()
        .FacilityID
        .equals(ofcMaster[0].BOFacilityID)
        .toList();
    final fileMaster =
        await FILEMASTERDATA().select().FILETYPE.equals("BOOKING").toList();
    // final destOfc = await await OfficeMasterPinCode().select().Pincode.equals(recipientZip).toList();

    final billFile = BillFile()
      ..FacilityId = ofcMaster[0].BOFacilityID
      ..Zip = ofcMaster[0].Pincode
      ..Channel = 'PS'
      ..UserId = ofcMaster[0].EMPID
      ..CounterNumber = '000'
      ..InvoiceNumber = 'SL' + ofcMaster[0].EMOCODE.toString() + '$time'
      ..TotalAmount = amount
      ..BookingDate = date
      ..BookingTime = time
      ..CurrencyId = 'INR'
      ..TenderId = 'S'
      ..TotalCashAmount = amount
      ..RoundOffDifference = '0.00'
      ..CircleCode = ofcMaster[0].BOFacilityID.toString().substring(2,4)
      //pincodeMaster[0].Region.toString()
      ..LineItemNumber = '1'
      ..LineItemTotalAmount = amount
      ..ArticleNumber = accountNumber
      ..Division = 'MO'
      ..OrderType = 'ZAS'
      ..ProductType = 'S'
      ..ProductCode = 'E_PAYMENT'
      ..ValueCode = 'V0'
      ..Value = amount
      ..Quantity = '1'
      ..CustomerId = ofcMaster[0].ONETIMECUSTCODE
      ..MaterialGroup = 'DPM'
      ..DestinationFacilityId = ofcMaster[0].BOFacilityID
      ..ElapsedTime = '000037'
      ..AdditionalBillInfo =
          '1|' + accountNumber + '|2|' + DateTimeDetails().currentDate()
      ..AdditionalBillAmountInfo = '1|$amount'
      ..BillerId = id
      ..BillerName = name;
   await billFile.save();

  }

  addDayBegin(String timeStamp1) async {
    String timeStamp2 = DateTimeDetails().currentDateTime();
    // List<List<dynamic>> rows=[];
    // List dayDetail = ['BO11304216001', timeStamp1, timeStamp2];
    // rows.add(dayDetail);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_DB_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final dayBegin = DayBegin()
      ..BPMId = ofcMaster[0].EMPID
      //'BO11304216001'
      ..DayBeginTimeStamp1 = timeStamp1
      ..DayBeginTimeStamp2 = timeStamp2
      ..FileCreated = "N"
      // ..FileName = fileName
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      ..FileTransmitted = 'N';
    await dayBegin.save();
    // addFileToDB(file.toString(), path.toString(), 'Day Begin Upload', DateTimeDetails().currentDateTime());
  }

  addCashIndent(String date, String cash, String weight) async {
    // List<List<dynamic>> rows=[];
    // List indentCash = ['BO11304216001$date', date, '', 'Chamundi B.O', 'Mysuru S.O',
    //   cash, '', '0,0', 'CASH'];
    // rows.add(indentCash);
    // String csv= const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
    // String fileName = 'OUT_CI_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}_968.csv';
    // final path = '$dataDirectory/Uploads/$fileName';
    // final File file = File(path);
    // await file.writeAsString(csv);
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final cashIndent = CashIndent()
      ..SOSlipNumber = ofcMaster[0].BOFacilityID.toString() + date.toString()
      ..SOGenerationDate = date
      ..ChequeNumber = ''
      ..BOName = ofcMaster[0].BOName
      ..SOName = ofcMaster[0].AOName
      ..CashAmount = cash
      ..Weight = ''
      ..ChequeAmount = '0.0'
      ..AmountType = 'CASH'
      ..FileCreated = 'N'
      // ..FileCreatedDateTime = DateTimeDetails().currentDateTime()
      // ..FileName = fileName
      ..FileTransmitted = 'N';
    await cashIndent.upsert();
    // addFileToDB(file.toString(), path.toString(), 'Cash Indent Upload', DateTimeDetails().currentDateTime());
  }

  addExcessBagCash(String slipnumber, String cash, String weight) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final excessCash = await ExcessBagCashTable()
      ..SOSlipNumber = slipnumber
      ..ChequeNumber = ''
      ..GenerationDate = DateTimeDetails().currentDate()
      ..BOName = ofcMaster[0].BOName
      ..SOName = ofcMaster[0].AOName
      ..CashAmount = cash
      ..Weight = weight
      ..ChequeAmount = ''
      ..TypeOfPayment = ''
      ..Miscellaneous = ''
      ..BagNumber = ''
      ..FileCreated = 'N'
      ..FileTransmitted = 'N';

    await excessCash.save();
  }

  getInventory(String date) async {
    print(await(InventoryDailyTable().select().toMapList()));
    print(await(ProductsTable().select().toMapList()));
    List inv =await InventoryDailyTable().select().toMapList();
    List product =await ProductsTable().select().toMapList();
    List<Map<String, dynamic>> res = [];
    inv.forEach((element){
      product.forEach((e){
        if(e["ProductID"]==element["InventoryId"]){
          res.add(
              getExtendedWallet(e["ProductID"] ,
                  e["Name"],
                  e["Price"],
                  element["OpeningQuantity"],
                  element["OpeningValue"],
                  e["Quantity"],
                  e["Value"]
              )

          );
        }
      });
    });

    print(res);
    // var inventory = await InventoryDailyTable()
    //     .select()
    //     .RecordedDate
    //     .equals(date)
    //     .toMapList();
    return res;
  }

  Map<String, dynamic> getExtendedWallet(String a,String b,String c,String d,String e,String f,String g){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ProductID"] = a;
    data["Name"] = b.toString();
    data["Denom"] = c.toString();
    data["OpeningQuantity"] = d;
    data["OpeningValue"] = e;
    data["Quantity"] = f;
    data["Value"] = g;

    return data;
  }


  updateDailyInventoryData(String type, String date) async {
    if (type == 'Begin') {
      final inventoryAvailable = await ProductsTable().select().toMapList();
      for (int i = 0; i < inventoryAvailable.length; i++) {
        final addDailyInventory = InventoryDailyTable()
          ..InventoryId = inventoryAvailable[i]['ProductID']
          ..StampName = inventoryAvailable[i]['Name']
          ..Price = inventoryAvailable[i]['Price']
          ..RecordedDate = date
          ..OpeningQuantity = inventoryAvailable[i]['Quantity']
          ..OpeningValue = inventoryAvailable[i]['Value']
          ..ClosingQuantity = ''
          ..ClosingValue = '';
        await addDailyInventory.upsert();
      }
    }
    else if (type == 'End') {
      final dailyInventory = await InventoryDailyTable()
          .select()
          .RecordedDate
          .equals(date)
          .toMapList();
      var fromProductsMain = await ProductsTable().select().toMapList();
      if (dailyInventory.isEmpty) {
        for (int i = 0; i < fromProductsMain.length; i++) {
          final addDailyInventory = InventoryDailyTable()
            ..InventoryId = fromProductsMain[i]['ProductID']
            ..StampName = fromProductsMain[i]['Name']
            ..Price = fromProductsMain[i]['Price']
            ..RecordedDate = date
            ..OpeningQuantity = '0'
            ..OpeningValue = '0'
            ..ClosingQuantity = fromProductsMain[i]['Quantity']
            ..ClosingValue = fromProductsMain[i]['Value'];
         await addDailyInventory.upsert();
        }
      }
      List allProducts = [];
      for (int i = 0; i < fromProductsMain.length; i++) {
        allProducts.add(fromProductsMain[i]['ProductID']);
      }
      for (int i = 0; i < dailyInventory.length; i++) {
        if (allProducts.contains(dailyInventory[i]['InventoryId'])) {
          var alreadyInProducts = await ProductsTable()
              .select()
              .ProductID
              .equals(dailyInventory[i]['InventoryId'])
              .toMapList();
          final updateDailyInventory = InventoryDailyTable()
            ..InventoryId = dailyInventory[i]['InventoryId']
            ..StampName = dailyInventory[i]['StampName']
            ..Price = dailyInventory[i]['Price']
            ..RecordedDate = dailyInventory[i]['RecordedDate']
            ..OpeningQuantity = dailyInventory[i]['OpeningQuantity']
            ..OpeningValue = dailyInventory[i]['OpeningValue']
            ..ClosingQuantity = alreadyInProducts[0]['Quantity']
            ..ClosingValue = alreadyInProducts[0]['Value'];
         await updateDailyInventory.upsert();
        }
      }
    }
  }

  addTransaction(String id, String type, String description, String date,
      String time, String amount, String valuation) async {
    // print("Inside PMO transaction");
    final transaction = TransactionTable()
      ..tranid = id
      ..tranType = type
      ..tranDescription = description
      ..tranDate = date
      ..tranTime = time
      ..tranAmount = double.parse(amount)
      ..valuation = valuation;
   await transaction.save();
  }
}
