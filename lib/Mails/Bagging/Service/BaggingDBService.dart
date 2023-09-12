
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../LogCat.dart';

class BaggingDBService {
  addBagToDB(
      String bagNumber,
      String receivedDate,
      String receivedTime,
      String openedDate,
      String openedTime,
      String articlesCount,
      String cashCount,
      String stampsCount,
      String documentsCount,
      String status) {
    final addBagToDB = BagReceivedTable()
      ..BagNumber = bagNumber
      ..ReceivedDate = receivedDate
      ..ReceivedTime = receivedTime
      ..OpenedDate = openedDate
      ..OpenedTime = openedTime
      ..ArticlesCount = articlesCount
      ..CashCount = cashCount
      ..StampsCount = stampsCount
      ..DocumentsCount = documentsCount
      ..ArticlesStatus = ""
      ..CashStatus = ""
      ..StampsStatus = ""
      ..DocumentsStatus = ""
      ..Status = status;
    addBagToDB.upsert();
  }

  updateBag(String bagNumber, String status, String openedDate,
      String openedTime) async {
    await BagReceivedTable().select().BagNumber.equals(bagNumber).update({
      'OpenedDate': openedDate,
      'OpenedTime': openedTime,
      'ArticlesStatus': 'Y',
      'CashStatus': 'Y',
      'StampsStatus': 'Y',
      'DocumentsStatus': 'Y',
      'Status': status
    });
  }

  closeBag(String bagNumber, String status, String closedDate,
      String closedTime, String articlesCount, String cashCount) async {
    final closeBag = BagCloseTable()
      ..BagNumber = bagNumber
      ..ClosedDate = closedDate
      ..ClosedTime = closedTime
      ..TotalArticlesCount = articlesCount
      ..CashCount = cashCount
      ..Status = status;
    closeBag.upsert();
  }

  addBagArticlesToDB(String articleNumber, String bagNumber, String articleType,
      String status) async {
    final addArticles = BagArticlesTable()
      ..BagNumber = bagNumber
      ..ArticleNumber = articleNumber
      ..ArticleType = articleType
      ..Status = 'Received';
    addArticles.save();
  }

  updateBagArticlesToDB(String bagNumber, String articleNumber,
      String articleType, String status) async {

    final updateArticle = BagArticlesTable()
      ..BagNumber = bagNumber
      ..ArticleNumber = articleNumber
      ..ArticleType = articleType
      ..Status = status;
    updateArticle.upsert();

    // final articleDetails = await BagArticlesTable().select().ArticleNumber.equals(articleNumber).toMapList();
    // if (articleDetails.isEmpty) {
    //   final addArticles = BagExcessArticlesTable()
    //     ..BagNumber = bagNumber
    //     ..ArticleNumber = articleNumber
    //     ..ArticleType = articleType
    //     ..Status = status;
    //   addArticles.upsert();
    // } else {
    //   final updateArticle = BagArticlesTable()
    //     ..BagNumber = bagNumber
    //     ..ArticleNumber = articleNumber
    //     ..ArticleType = articleType
    //     ..Status = status;
    //   updateArticle.upsert();
    // }

  }

  addArticlesToDelivery(String bagNumber, String articleNumber,
      String articleType, String commission, String moneytobecollected) async {
    print("Entered aadd articles to delivery");
    final ifPresent =
        await Delivery().select().ART_NUMBER.equals(articleNumber).toMapList();
    final ofcMaster = await OFCMASTERDATA().select().toList();

    print(ifPresent);

    String isCOD = "";
    String isVPP = "";
    print("Bag Open storing in Delivery Table..!");
    print(articleNumber);
    print(articleType);
    switch (articleType) {
      case "COD":
        isCOD = "X";
        break;
      case "SP-COD":
        isCOD = "X";
        break;
      case "BP-COD":
        isCOD = "X";
        break;
      case "VPP":
        isVPP = "X";
        break;
      case "VPL":
        isVPP = "X";
        break;
    }

    if (ifPresent.isNotEmpty && articleType!="EMO") {
      //when virtual data received.
      print("Entered as virtual data is received");
      await Delivery().select().ART_NUMBER.equals(articleNumber).update({
        "invoiceDate": DateTimeDetails().currentDate(),
        "invoiced": "Y",
        "ART_RECEIVE_DATE": DateTimeDetails().onlyDate(),
        "ART_RECEIVE_TIME": DateTimeDetails().oT(),
        //Added Status for old/closed articles if recived again should be available for delivery.
        'ART_STATUS': null,

      });
    }
    else {
      //when virtual data not received.
      print("DB Services Else Statement");
      print(commission + " " + moneytobecollected);

      final addDeliveryArticles = await Delivery()
        ..ART_NUMBER = articleNumber
        ..invoiceDate =
            articleType == 'EMO' ? null : DateTimeDetails().currentDate()
        ..invoiced = articleType == 'EMO' ? null : 'Y'
        ..BAG_ID = bagNumber
        ..DATE_OF_DELIVERY = null
        ..REASON_TYPE = null
        ..ART_STATUS = null
        ..ART_RECEIVE_DATE = DateTimeDetails().onlyDate()
        ..ART_RECEIVE_TIME = DateTimeDetails().oT()
        ..TRANSACTION_DATE = null
        ..EMO_MESSAGE = null
        ..MATNR =
          articleType =='SP-COD' ?"SP_INLAND_PARCEL":
          articleType =='BP-COD' ?"BUSINESS_PARCEL": articleType
        ..TOTAL_MONEY = double.parse(moneytobecollected.toString())
        ..MONEY_TO_BE_COLLECTED = double.parse(moneytobecollected.toString())
        ..POST_DUE = 0
        ..DEM_CHARGE = 0
        ..COMMISSION = double.parse(commission.toString())
        ..BOOK_ID = null
        ..COD = isCOD
        ..VPP = isVPP
        ..BO_ID= ofcMaster[0].BOFacilityID
        ..REPORTING_SO_ID = ofcMaster[0].AOCode
        ..SOFFICE_ID = ofcMaster[0].AOCode
        ..DOFFICE_ID = ofcMaster[0].BOFacilityID
      ;
      await addDeliveryArticles.save();

      final addDeliveryArticleAddress = await Addres()
        ..REC_NAME = ''
        ..REC_PIN = int.parse(ofcMaster[0].Pincode.toString())
        ..REDIRECT_REC_PIN = 0
        ..REDIRECT_FROM_PIN = 0
        ..REDIRECT_FROM_BO_ID = null
        ..ART_NUMBER = articleNumber;
     await addDeliveryArticleAddress.save();

    }
  }

  addExcessCashToDB(String date, String excessAmount, String bagNumber) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final excessCash = ExcessBagCashTable()
      ..SOSlipNumber = '${ofcMaster[0].BOFacilityID}$date'
      ..GenerationDate = date
      ..ChequeNumber = ''
      ..BOName = ofcMaster[0].BOName
      ..SOName = ofcMaster[0].AOName
      ..CashAmount = excessAmount
      ..Weight = ''
      ..ChequeAmount = '0.0'
      ..TypeOfPayment = 'CASH'
      ..Miscellaneous = '0.0'
      ..BagNumber = bagNumber
      ..FileCreated = 'N'
      ..FileTransmitted = 'N';
    excessCash.save();
  }

  addInventoryFromBag(String bagNumber, String id, String code,
      String denomination, String name, String balance) async {
    final addInventory = BagStampsTable()
      ..StampID = bagNumber + name
      ..BagNumber = bagNumber
      ..StampName = name
      ..StampPrice = denomination
      ..StampQuantity = balance
      ..StampAmountTotal =
          (int.parse(denomination) * int.parse(balance)).toString()
      ..Status = 'Received';
    addInventory.upsert();
  }

  addInventoryToDB(String bagNumber, String id, String code,
      String denomination, String name, String balance) async {
    final addInventory = BagStampsTable()
      ..StampID = bagNumber + name
      ..BagNumber = bagNumber
      ..StampName = name
      ..StampPrice = denomination
      ..StampQuantity = balance
      ..StampAmountTotal =
          (int.parse(denomination) * int.parse(balance)).toString()
      ..Status = 'Added';
    addInventory.upsert();

    final ifPresent =
        await InventoryMainTable().select().ItemCode.equals(code).toMapList();
    if (ifPresent.isNotEmpty) {
      for (int i = 0; i < ifPresent.length; i++) {
        var priorQuantity = ifPresent[i]['ItemBalance'];
        int totalQuantity = int.parse(priorQuantity) + int.parse(balance);
        final updateToInventory = InventoryMainTable()
          ..InventoryID = id
          ..ItemCode = code
          ..ItemDenomination = denomination
          ..ItemName = name
          ..ItemBalance = totalQuantity.toString();
        updateToInventory.upsert();

        final addInventory = BagInventory()
          ..BagNumber = bagNumber
          ..InventoryID = id + bagNumber
          ..InventoryPrice = denomination
          ..InventoryQuantity = balance
          ..InventoryName = name;
        addInventory.save();
      }
    } else {
      final updateToInventory = InventoryMainTable()
        ..InventoryID = id
        ..ItemCode = code
        ..ItemDenomination = denomination
        ..ItemName = name
        ..ItemBalance = balance;
      updateToInventory.upsert();

      final addInventory = BagInventory()
        ..BagNumber = bagNumber
        ..InventoryID = id + bagNumber
        ..InventoryPrice = denomination
        ..InventoryQuantity = balance
        ..InventoryName = name;
      addInventory.save();
    }
  }

  addCashFromBagToDB(String id, String amount, String bagNumber) async {

    final addCashBag = BagCashTable()
      ..CashID = bagNumber
      ..BagNumber = bagNumber
      ..CashType = 'Cash'
      ..CashReceived = amount
      ..CashAmount = '0'
      ..Status = 'Received';
    addCashBag.save();
  }

  addBAGDETAILS_NEW(String bagnumber, String count) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();
    final checkbag =
        await BAGDETAILS_NEW().select().BAGNUMBER.equals(bagnumber).toList();

    if (checkbag.length > 0) //BagDetails already available
    {
      final updateBag = await BAGDETAILS_NEW()
          .select()
          .BAGNUMBER
          .equals(bagnumber)
          .update({'BAGSTATUS': 'R'});
    } else {
      //when bag is received through data entry
      final bagdetails = await BAGDETAILS_NEW()
        ..FROMOFFICE = ofcMaster[0].AOCode
        ..TOOFFICE = ofcMaster[0].BOFacilityID
        ..TDATE = DateTimeDetails().proposalDate()
        ..BAGNUMBER = bagnumber
        ..BOSLIPNO = ofcMaster[0].BOFacilityID.toString() +
            DateTimeDetails().currentDate()
        ..NO_OF_ARTICLES = count
        ..BAGSTATUS = 'R';
      bagdetails.save();
    }
  }

  addBagDocumentsToDB(String id, String document, String bagNumber) async {
    final addDocuments = BagDocumentsTable()
      ..DocumentID = id
      ..BagNumber = bagNumber
      ..DocumentName = document
      ..DocumentStatus = 'Received';
    addDocuments.save();
  }

  saveDocumentsToDB(String boslip, String description, String bagNumber) async {
    final ofcMaster = await OFCMASTERDATA().select().toList();

    final saveDocument = DocumentTable()
      ..BOAccountNumber = boslip
      ..CreatedOn = DateTimeDetails().currentDate()
      ..FromOffice = ofcMaster[0].BOFacilityID
      ..DocumentDetails = description
      ..BagNumber = bagNumber
      ..FileCreated = 'N'
      ..FileTransmitted = "N";
    saveDocument.save();
  }

  closeBagInDB(String bagNumber, String bagWeight, String receivedDate,
      String receivedTime, String openedDate, String openedTime) {
    final closeBag = BagReceivedTable()
      ..BagNumber = bagNumber
      ..ReceivedDate = receivedDate
      ..ReceivedTime = receivedTime
      ..OpenedDate = openedDate
      ..OpenedTime = openedTime
      ..ArticlesCount = ''
      ..StampsCount = ''
      ..CashCount = ''
      ..Status = 'Closed';
    closeBag.upsert();
  }

  addCashReceive(String cashAmount, String bagNumber) async {
    print("Adding Cash Received..!");
    print(cashAmount);
    print(bagNumber);
    if (cashAmount!="0" || cashAmount.isNotEmpty|| cashAmount!="") {
      final walletAmount = await CashService().cashBalance();
      print(walletAmount);

      final checkIfAdded = await CashReceiveTable()
          .select()
          .CashOpeningDate
          .equals(DateTimeDetails().onlyTime())
          .toMapList();
      if (checkIfAdded.isEmpty) {
        print("inside if ");
        double balance = double.parse(walletAmount.toString())+ double.parse(cashAmount);
            // double.parse(double.parse(walletAmount).toStringAsFixed(2)) +
            // double.parse(double.parse(cashAmount).toStringAsFixed(2));
        print(balance);
        final addCashReceive = CashReceiveTable()
          ..CashID = DateTimeDetails().currentDateTime() + cashAmount
          ..CashOpeningDate = DateTimeDetails().onlyDate()
          ..CashClosingTime = DateTimeDetails().onlyTime()
          ..CashOpeningBalance = balance.toString()
          ..CashClosingDate = ''
          ..CashClosingTime = ''
          ..CashOpeningBalance = '';
       await addCashReceive.save();
      }
      print("out of if ");
      final bagCash = BagCashTable()
        ..BagDate = DateTimeDetails().currentDate()
        ..CashID = bagNumber
        ..BagNumber = bagNumber
        ..CashReceived = cashAmount
        ..CashAmount = cashAmount
        ..CashType = 'Cash'
        ..Status = 'Received';
      await bagCash.upsert();

      final checkCash = await CashTable().select().Cash_ID.equals(bagNumber).toCount();

      if(checkCash==0) {
        final bagCashToWallet = CashTable()
          ..Cash_ID = bagNumber
          ..Cash_Amount = double.parse(cashAmount)
          ..Cash_Description = 'Cash Received from Bag $bagNumber'
          ..Cash_Type = 'Add'
          ..Cash_Date = DateTimeDetails().currentDate()
          ..Cash_Time = DateTimeDetails().onlyTime();
        await bagCashToWallet.upsert();
        await LogCat().writeContent("Cash added in wallet from - $bagNumber. \n\n");
      }
      else{
        await LogCat().writeContent("Cash is already available for $bagNumber. \n\n");
      }
    }
    else{
      print("Cash Received is ZERO..!");
      await LogCat().writeContent("Cash Received is ZERO..! \n\n");
    }
  }

  addInventoryFromBagToDB(String name, String price, String quantity,
      String total, String bagNumber, String status) async {

    final addInventory = BagStampsTable()
      ..StampID = bagNumber + name
      ..BagNumber = bagNumber
      ..StampName = name
      ..StampPrice = price
      ..StampQuantity = quantity
      ..StampAmountTotal = total
      ..StampDate = DateTimeDetails().currentDate()
      ..StampTime = DateTimeDetails().onlyTime()
      ..Status = status;
    addInventory.upsert();

  }

  addExcessInventoryFromBagToDB(String name, String stampName, String price,
      String quantity, String total, String bagNumber, String status) async {
    final addExcessInventory = BagExcessStampsTable()
      ..StampID = bagNumber + name
      ..BagNumber = bagNumber
      ..StampName = name
      ..Name = stampName
      ..StampPrice = price
      ..StampQuantity = quantity
      ..StampAmountTotal = total
      ..Status = status;
    addExcessInventory.upsert();
  }

  addProductsMain(String name, double price, double quantity) async {
    var total = price * quantity;
    String productid ='';
    final productMaster = await ProductsMaster().select().ShortDescription.contains(name).toList();
    if(productMaster.length>0){
      productid= productMaster[0].ItemCode.toString();
    }
// Rakesh- Need to add stamps intsead of upsert
    // Checking whether any product is there or not
    final prod = await ProductsTable().select().ProductID.contains(productid).toList();

    if(prod.length>0)
      {//Adding in Products Master
        print("existing Product details:${prod[0].Quantity.toString()}");
        quantity = quantity+ double.parse(prod[0].Quantity.toString());
        total = price * quantity;
        final addProduct = ProductsTable()
          ..ProductID = productid
          ..Name = name
          ..Price = price.toString()
          ..Quantity = quantity.toString()
          ..Value = total.toString();
        addProduct.upsert();

      }
    else {
      // Addition ended
      final addProduct = ProductsTable()
        ..ProductID = productid
        ..Name = name
        ..Price = price.toString()
        ..Quantity = quantity.toString()
        ..Value = total.toString();
      addProduct.upsert();
    }

    final inv = await InventoryDailyTable().select().InventoryId.contains(productid).toList();

    if(inv.length>0)
    {//Adding in Products Master
      print("existing Inventory details:${inv[0].OpeningQuantity.toString()}");
      quantity = quantity+ double.parse(inv[0].OpeningQuantity.toString());
      total = price * quantity;
      final addinv = InventoryDailyTable()
        ..InventoryId = productid
        ..StampName = name
        ..Price = price.toString()
        ..OpeningQuantity = quantity.toString()
        ..OpeningValue = total.toString();
      addinv.upsert();

    }
    else {
      // Addition ended
      final addinv = InventoryDailyTable()
        ..InventoryId = productid
        ..StampName = name
        ..Price = price.toString()
        ..OpeningQuantity = quantity.toString()
        ..OpeningValue = total.toString();
      addinv.upsert();
    }
  }

  addDocumentsToDB(String document, String bagNumber) async {
    final addDocuments = DocumentsTable()
      ..DocumentID = bagNumber + document
      ..BagNumber = bagNumber
      ..DocumentName = document;
    addDocuments.upsert();
  }

  updateBagDocumentsToDB(
      String bagNumber, String document, String isAdded, String status) async {
    final addDocuments = BagDocumentsTable()
      ..DocumentID = document.replaceAll(" ", '')
      ..BagNumber = bagNumber
      ..DocumentName = document
      ..ReceivedDate = DateTimeDetails().onlyDate()
      ..ReceivedTime = DateTimeDetails().onlyTime()
      ..IsAdded = isAdded
      ..DocumentStatus = status;
    addDocuments.upsert();
  }

  closeBagArticlesInDB(String bagNumber, String articleNumber,
      String articleType, String status) {
    final closeArticle = CloseArticlesTable()
      ..BagNumber = bagNumber
      ..ArticleNumber = articleNumber
      ..ArticleType = articleType
      ..IsBooked = ''
      ..IsExcess = ''
      ..IsScanned = ''
      ..Status = status;
    closeArticle.upsert();
  }

  addBagCashToDB(String amount, String status, String bagNumber,
      String cashReceived) async {
    final addCashBag = BagCashTable()
      ..CashID = bagNumber
      ..BagNumber = bagNumber
      ..CashType = 'Cash'
      ..CashReceived = cashReceived
      ..CashAmount = amount
      ..Status = status;
    addCashBag.upsert();
  }

  updateNotDeliveredArticle(String articleNumber, String status) async {
    final notDeliveredArticle =
        await Delivery().select().ART_NUMBER.equals(articleNumber).toMapList();
    final updateArticle = await Delivery()
      ..ART_NUMBER = notDeliveredArticle[0]['ART_NUMBER']
      ..invoiceDate = notDeliveredArticle[0]['invoiceDate']
      ..invoiced = notDeliveredArticle[0]['invoiced']
      ..SOFFICE_ID = notDeliveredArticle[0]['SOFFICE_ID']
      ..DOFFICE_ID = notDeliveredArticle[0]['DOFFICE_ID']
      ..BOOK_DATE = notDeliveredArticle[0]['BOOK_DATE']
      ..BOOK_ID = notDeliveredArticle[0]['BOOK_ID']
      ..LINE_ITEM = notDeliveredArticle[0]['LINE_ITEM']
      ..BAG_ID = notDeliveredArticle[0]['BAG_ID']
      ..INSURANCE = notDeliveredArticle[0]['INSURANCE']
      ..ON_HOLD = notDeliveredArticle[0]['ON_HOLD']
      ..HOLD_DATE = notDeliveredArticle[0]['HOLD_DATE']
      ..HOLD_TILL_DATE = notDeliveredArticle[0]['HOLD_TILL_DATE']
      ..PENSIONER_ID = notDeliveredArticle[0]['PENSIONER_ID']
      ..REASON_FOR_NONDELIVERY =
          notDeliveredArticle[0]['REASON_FOR_NONDELIVERY']
      ..REASON_TYPE = notDeliveredArticle[0]['REASON_TYPE']
      ..ACTION = notDeliveredArticle[0]['ACTION']
      ..MONEY_TO_BE_COLLECTED = notDeliveredArticle[0]['MONEY_TO_BE_COLLECTED']
      ..MONEY_COLLECTED = notDeliveredArticle[0]['MONEY_COLLECTED']
      ..POST_DUE = notDeliveredArticle[0]['POST_DUE']
      ..DEM_CHARGE = notDeliveredArticle[0]['DEM_CHARGE']
      ..COMMISSION = notDeliveredArticle[0]['COMMISSION']
      ..MONEY_TO_BE_DELIVERED = notDeliveredArticle[0]['MONEY_TO_BE_DELIVERED']
      ..MONEY_DELIVERED = notDeliveredArticle[0]['MONEY_DELIVERED']
      ..NO_OF_HOLD_DAYS = notDeliveredArticle[0]['NO_OF_HOLD_DAYS']
      ..DATE_OF_DELIVERY = notDeliveredArticle[0]['DATE_OF_DELIVERY']
      ..DATE_OF_DELIVERY_CONFIRM =
          notDeliveredArticle[0]['DATE_OF_DELIVERY_CONFIRM']
      ..TIME_OF_DELIVERY_CONFIRM =
          notDeliveredArticle[0]['TIME_OF_DELIVERY_CONFIRM']
      ..DATE_OF_1ST_DELIVERY_CONFIRM =
          notDeliveredArticle[0]['DATE_OF_1ST_DELIVERY_CONFIRM']
      ..DATE_OF_2ND_DELIVERY_CONFIRM =
          notDeliveredArticle[0]['DATE_OF_2ND_DELIVERY_CONFIRM']
      ..DATE_OF_3RD_DELIVERY_CONFIRM =
          notDeliveredArticle[0]['DATE_OF_3RD_DELIVERY_CONFIRM']
      ..DELIVERY_TIME = notDeliveredArticle[0]['DELIVERY_TIME']
      ..DEL_DATE = notDeliveredArticle[0]['DEL_DATE']
      ..ID_PROOF_DOC = notDeliveredArticle[0]['ID_PROOF_DOC']
      ..ID_PROOF_NMBR = notDeliveredArticle[0]['ID_PROOF_NMBR']
      ..ISSUING_AUTHORITY = notDeliveredArticle[0]['ISSUING_AUTHORITY']
      ..ID_PROOF_VALIDITY_DATE =
          notDeliveredArticle[0]['ID_PROOF_VALIDITY_DATE']
      ..WINDOW_DELIVERY = notDeliveredArticle[0]['WINDOW_DELIVERY']
      ..REDIRECTION_FEE = notDeliveredArticle[0]['REDIRECTION_FEE']
      ..RETRN_DATE = notDeliveredArticle[0]['RETRN_DATE']
      ..RETRN_TIME = notDeliveredArticle[0]['RETRN_TIME']
      ..BEAT_NO = notDeliveredArticle[0]['BEAT_NO']
      ..PERNR = notDeliveredArticle[0]['PERNR']
      // ..ART_STATUS = notDeliveredArticle[0]['artStatus']
      ..ART_RECEIVE_DATE = notDeliveredArticle[0]['ART_RECEIVE_DATE']
      ..ART_RECEIVE_TIME = notDeliveredArticle[0]['ART_RECEIVE_TIME']
      ..REMARKS = notDeliveredArticle[0]['REMARKS']
      ..ZCONDITION = notDeliveredArticle[0]['ZCONDITION']
      ..TOTAL_MONEY = notDeliveredArticle[0]['TOTAL_MONEY']
      ..POSTAGE_NOT_COLLECTED = notDeliveredArticle[0]['POSTAGE_NOT_COLLECTED']
      ..MOP = notDeliveredArticle[0]['MOP']
      ..VPP = notDeliveredArticle[0]['VPP']
      ..BATCH_ID = notDeliveredArticle[0]['BATCH_ID']
      ..SHIFT_NO = notDeliveredArticle[0]['SHIFT_NO']
      ..RET_RCL_RDL_STOPDELV_STATUS2 =
          notDeliveredArticle[0]['RET_RCL_RDL_STOPDELV_STATUS2']
      ..TYPE_OF_PAYEE = notDeliveredArticle[0]['TYPE_OF_PAYEE']
      ..REDIRECT_PIN = notDeliveredArticle[0]['REDIRECT_PIN']
      ..MOD_PIN = notDeliveredArticle[0]['MOD_PIN']
      ..SOURCE_PINCODE = notDeliveredArticle[0]['SOURCE_PINCODE']
      ..DESTN_PINCODE = notDeliveredArticle[0]['DESTN_PINCODE']
      ..EMO_MESSAGE = notDeliveredArticle[0]['EMO_MESSAGE']
      ..REGISTERED = notDeliveredArticle[0]['REGISTERED']
      ..RETURN_SERVICE = notDeliveredArticle[0]['RETURN_SERVICE']
      ..COD = notDeliveredArticle[0]['COD']
      ..RT = notDeliveredArticle[0]['RT']
      ..RT_DATE = notDeliveredArticle[0]['RT_DATE']
      ..RT_TIME = notDeliveredArticle[0]['RT_TIME']
      ..RD = notDeliveredArticle[0]['RD']
      ..RD_DATE = notDeliveredArticle[0]['RD_DATE']
      ..RD_TIME = notDeliveredArticle[0]['RD_TIME']
      ..SP = notDeliveredArticle[0]['SP']
      ..SP_DATE = notDeliveredArticle[0]['SP_DATE']
      ..SP_TIME = notDeliveredArticle[0]['SP_TIME']
      ..POSTE_RESTANTE = notDeliveredArticle[0]['POSTE_RESTANTE']
      ..BO_ID = notDeliveredArticle[0]['BO_ID']
      ..LAST_CHANGED_USER = notDeliveredArticle[0]['LAST_CHANGED_USER']
      ..BELNR = notDeliveredArticle[0]['BELNR']
      ..ALREADY_RTN_FLAG = notDeliveredArticle[0]['ALREADY_RTN_FLAG']
      ..ALREADY_RD_FLAG = notDeliveredArticle[0]['ALREADY_RD_FLAG']
      ..REDIRECT_BO_ID = notDeliveredArticle[0]['REDIRECT_BO_ID']
      ..IFS_SOFFICE_NAME = notDeliveredArticle[0]['IFS_SOFFICE_NAME']
      ..CHECT = notDeliveredArticle[0]['CHECT']
      ..TREASURY_SUBMIT_DONE = notDeliveredArticle[0]['TREASURY_SUBMIT_DONE']
      ..TREASURY_SUBMIT_DATE = notDeliveredArticle[0]['TREASURY_SUBMIT_DATE']
      ..REDIRECTION_SL = notDeliveredArticle[0]['REDIRECTION_SL']
      ..TRANSACTION_DATE = notDeliveredArticle[0]['TRANSACTION_DATE']
      ..TRANSACTION_TIME = notDeliveredArticle[0]['TRANSACTION_TIME']
      ..IS_COMMUNICATED = notDeliveredArticle[0]['IS_COMMUNICATED']
      ..IS_PREVIOUS_DAY_DEPOSIT =
          notDeliveredArticle[0]['IS_PREVIOUS_DAY_DEPOSIT']
      ..E_PROOF = notDeliveredArticle[0]['E_PROOF']
      ..MATNR = notDeliveredArticle[0]['MATNR']
      ..CASH_ID = notDeliveredArticle[0]['CASH_ID']
      ..REMARK_DATE = notDeliveredArticle[0]['REMARK_DATE']
      ..CASH_RETURNED = notDeliveredArticle[0]['CASH_RETURNED']
      ..FILE_NAME = notDeliveredArticle[0]['FILE_NAME']
      ..REPORTING_SO_ID = notDeliveredArticle[0]['REPORTING_SO_ID']
      ..despatchStatus = notDeliveredArticle[0]['despatchStatus']
      ..CUST_DUTY = notDeliveredArticle[0]['CUST_DUTY']
      ..BO_SLIP = notDeliveredArticle[0]['BO_SLIP']
      ..ART_STATUS = status;
    updateArticle.upsert();
  }


  updateNotDeliveredArticleBag(String articleNumber, String status) async {
    final notDeliveredArticle =
    await Delivery().select().ART_NUMBER.equals(articleNumber).update({'ART_STATUS':status});
    }
}
