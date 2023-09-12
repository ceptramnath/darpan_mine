import 'dart:io';

import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/DatabaseModel/APIErrorCodes.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/INSURANCE/HomeScreen/HomeScreen.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_archive/flutter_archive.dart';
import 'package:intl/intl.dart';

import 'CBS/screens/my_cards_screen.dart';
import 'DatabaseModel/PostOfficeModel.dart';
import 'DatabaseModel/uidaiErrCodes.dart';
import 'Delivery/Screens/db/DarpanDBModel.dart';
import 'LogCat.dart';
import 'Mails/Bagging/Model/BagModel.dart';
import 'Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'Mails/MailsMainScreen.dart';
import 'UtilitiesMainScreen.dart';

class MainHomeScreen extends StatefulWidget {
  Widget? _child;
  int? index;

  MainHomeScreen(this._child, this.index);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  bool added = false;

  @override
  void initState() {
    nonDeliveryReasons();
    checkdb();
    // added == false ? addDummyData() : null;
    // recordDayOpenDetails();
  }

  checkdb() async {
    await rootBundle.load('assets/PostOfficeDB.db').then((content) {
      File newFile = File(
          'storage/emulated/0/Darpan_Mine/Databases/storage/emulated/0/Darpan_Mine/Databases/tariff.db');
      //File newFile = File('storage/emulated/0/Darpan_Mine/Databases/tariff.db');
      newFile.writeAsBytesSync(content.buffer.asUint8List());
      // visionImage = FirebaseVisionImage.fromFile(newFile);
      // _runAnalysis();
    });

    var length = await Vpp().select().toCount();
    print("length of VPP: $length");
  }

  extractDownloadedFile() {
    final zipFile = File('storage/emulated/0/Darpan_Mine/data/Uploads/upload.zip');
    final destinationDir =
        Directory('storage/emulated/0/Darpan_Mine/ExtractedFiles');
    try {
      ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
    } catch (e) {
      print(e.toString());
    }
  }

  createZipFile() async {
    final sourceDirectory = Directory('storage/emulated/0/Darpan_Mine/data/Uploads');
    final List<FileSystemEntity> entities =
        await sourceDirectory.list().toList();
    final storageFile = sourceDirectory.listSync();
    final Iterable<File> file = entities.whereType<File>();
    final zipFile = File('storage/emulated/0/Darpan_Mine/data/Uploads/upload.zip');
    try {
      if (entities.isNotEmpty) {
        ZipFile.createFromFiles(
            sourceDir: sourceDirectory, files: file.toList(), zipFile: zipFile);
      }

      ///For deleting the generated files
      // for (int i = 0; i < storageFile.length; i++) {
      //   storageFile[i].delete();
      // }
    } catch (e) {
      e.toString();
    }
  }

  List subRes = [];

  addDummyData() {
    List accountType = [
      'SB',
      'RD',
      'SB',
      'RD',
      'SB',
      'RD',
      'SB',
      'SB',
      'RD',
      'SB'
    ];
    List accountNumber = [
      12423423,
      2343253,
      345345,
      54645645,
      456456,
      45645645,
      45645654,
      23423423,
      34534534,
      45645654
    ];
    List transactionAmount = [
      4343,
      6786,
      2321,
      2343,
      345,
      5675,
      23434,
      3564,
      6575,
      4523
    ];
    List transactionTypes = [
      'DEPOSIT',
      'DEPOSIT',
      'DEPOSIT',
      'WITHDRAW',
      'WITHDRAW',
      'WITHDRAW',
      'DEPOSIT',
      'DEPOSIT',
      'WITHDRAW',
      'WITHDRAW'
    ];
    List insuranceNames = ['PLI', 'RPLI', 'PLI', 'RPLI'];
    List insuranceNumber = [2342342, 34534564, 456456456, 45645645];
    List insuranceTypes = ['DEPOSIT', 'DEPOSIT', 'WITHDRAW', 'WITHDRAW'];
    List insuranceAmount = [457, 3454, 45632, 45765];
    for (int i = 0; i < accountType.length; i++) {
      final addBanking = TBCBS_TRAN_DETAILS()
        ..ACCOUNT_TYPE = accountType[i]
        ..CUST_ACC_NUM = accountNumber[i].toString()
        ..TRANSACTION_AMT = transactionAmount[i].toString()
        ..TRAN_TYPE = transactionTypes[i];
      addBanking.save();
    }
    for (int i = 0; i < insuranceAmount.length; i++) {
      final addInsurance = Ins_transaction()
        ..policyNumber = insuranceNumber[i].toString()
        ..policyType = insuranceNames[i]
        ..tranType = insuranceTypes[i]
        ..amount = insuranceAmount[i].toString();
      addInsurance.save();
    }
    added = true;
  }

  Future<String> readCSC(String path) async {
    return await rootBundle.loadString(path);
  }

  uploadDownloadedFiles() async {
    final dir = Directory('storage/emulated/0/Darpan_Mine/data');
    final List<FileSystemEntity> entities = await dir.list().toList();
  }

  nonDeliveryReasons() async {
    // await uploadDownloadedFiles();
    // await extractDownloadedFile();
    // await createZipFile();

    var ercount = await API_Error_code().select().toCount();
    print("API ERROR COUNT: $ercount");
    final sqlapierror =
        "INSERT INTO API_Error_codes VALUES ('202','No Content'),('204','No Content'),('400','Bad Request. Try Again'),('401','unauthorised'),('500','Unable to Connect to server'),('502','Gateway error'),('503','API not responding'),('504','API not responding'),('404','Unable to Connect');";
    if (ercount == 0) {
      print("API ERROR CODES");
      final result = await APIErrorCodes().execSQL(sqlapierror);
      print(result);
    }
    var count = await Reason().select().toCount();
    final sql =
        "INSERT INTO REASON (MANDT,REASON_FOR_NDELI,APPLICABLE_FOR,REASON_TYPE,ACTION,REASON_NDEL_TEXT,APPL_FOR_TEXT,REASON_TYPE_TEXT,ACTION_TEXT,DELE_FLAG,SERIAL) VALUES ('100','35','3','1','1','INTIMATION DELIVERED','ALL','INTIMATION SERVED','KEEP IN DEPOSIT','NULL','1'),('100','36','3','1','1','PAYMENT OF CHARGES','ALL','INTIMATION SERVED','KEEP IN DEPOSIT','NULL','1'),('100','1','3','1','1','DOOR LOCKED','ALL','INTIMATION SERVED','KEEP IN DEPOSIT','NULL','1'),('100','8','3','1','1','ADDRESSEE ABSENT','ALL','INTIMATION SERVED','KEEP IN DEPOSIT','NULL','1'),('100','3','3','2','1','ON ADDRESSEE INSTRUCTIONS','ALL','DEPOSIT','KEEP IN DEPOSIT','NULL','2'),('100','5','3','2','2','LOCAL HOLIDAY','ALL','DEPOSIT','KEEP IN DEPOSIT AND ATTEMPT DELIVERY ON NEXT WORKING DAY','NULL','2'),('100','15','3','2','2','OFFICE CLOSED','ALL','DEPOSIT','KEEP IN DEPOSIT AND ATTEMPT DELIVERY ON NEXT WORKING DAY','NULL','2'),('100','30','3','7','11','MISSENT','ALL','MISCELLANEOUS','REDIRECT THE ARTICLE TO THE CORRECT PO ON THE SAME DAY','NULL','3'),('100','6','3','4','4','INSUFFICIENT ADDRESS','ALL','FOR ENQUIRY','ATTEMPT DELIVERY ON NEXT WORKING DAY','NULL','3'),('100','7','3','4','4','ADDRESSEE CANNOT BE LOCATED','ALL','FOR ENQUIRY','ATTEMPT DELIVERY ON NEXT WORKING DAY','NULL','3'),('100','6','3','3','11','INSUFFICIENT ADDRESS','ALL','FOR REDIRECTION','REDIRECT THE ARTICLE TO THE CORRECT PO ON THE SAME DAY','NULL','4'),('100','2','3','3','11','ADDRESSEE MOVED','ALL','FOR REDIRECTION','REDIRECT THE ARTICLE TO THE CORRECT PO ON THE SAME DAY','NULL','4'),('100','2','3','5','5','ADDRESSEE MOVED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','1','3','5','5','DOOR LOCKED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','7','3','5','5','ADDRESSEE CANNOT BE LOCATED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','6','3','5','6','INSUFFICIENT ADDRESS','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER AFTER THE COMPLETION OF PERIOD OF RETE','NULL','5'),('100','14','3','5','6','NO SUCH PERSON IN THE ADDRESS','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER AFTER THE COMPLETION OF PERIOD OF RETE','NULL','5'),('100','9','3','5','5','REFUSED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','11','3','5','6','ADDRESSEE LEFT WITHOUT INSTRUCTIONS','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER AFTER THE COMPLETION OF PERIOD OF RETE','NULL','5'),('100','17','1','5','6','UNCLAIMED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER AFTER THE COMPLETION OF PERIOD OF RETE','NULL','5'),('100','18','3','5','5','DECEASED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','27','2','5','5','VALIDITY PERIOD EXCEEDED','MONEY ORDER','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5'),('100','40','3','5','5','RECALLED','ALL','RETURNED TO SENDER (RTS)','RETURN TO THE SENDER','NULL','5');";
    print("Non Delivery Reasons: " + count.toString());
    if (count == 0) {
      final result = await DeliveryModel().execSQL(sql);
      print(result);
    }
    final finsql =
        "Insert into CBS_ERROR_CODES ([Error_code],[Error_message]) VALUES ('111','Invalid scheme type'),	('114','Entered account number does not exist'),	('115','Requested function not supported'),	('116','Insufficient funds'),	('119','Transaction not permitted to card holder'),	('121','Withdrawal amount limit exceeded.'),	('163','Invalid Cheque Status'),	('180','Transfer Limit Exceeded'),	('181','Cheques are in different books'),	('182','Not all cheques could be stopped'),	('183','Cheque not issued to this account'),	('184','Requested Block operation failed since Account is closed/frozen.'),	('185','Invalid Currency/Transaction Amount'),	('186','Block does not exist'),	('187','Cheque Stopped'),	('188','Invalid Rate Currency Combination'),	('189','Cheque Book Already Issued'),	('190','DD Already Paid'),	('800','Network message was accepted'),	('902','Invalid transaction'),	('904','Format Error'),	('906','Cut-over in progress'),	('907','Card issuer inoperative'),	('909','System malfunction'),	('911','Card issuer timed out'),	('913','Duplicate transmission.'),	('9999','Service is  down OR  data is passed in the expected format OR fatal error');";
    var cbsCount = await CBS_ERROR_CODES().select().toCount();
    if (cbsCount == 0) final cbserrormaster = await CBS().execSQL(finsql);


    var insofccount=await INS_CIRCLE_CODES().select().toCount();

    final sqlinsofccount =
        '''INSERT INTO "INS_CIRCLE_CODES" ("Circle_code","CO_CODE") VALUES ('JK-JK010100000','JK000000000'),
 ('AM-GU091600000','GU000000000'),
 ('AP-KU090100000','AP000000000'),
 ('BI-PT080100000','BI000000000'),
 ('CG-RP080100000','CG000000000'),
 ('DL-DL070100000','DL000000000'),
 ('GJ-VD071700000','GJ000000000'),
 ('HP-HP080200000','HP000000000'),
 ('HY-HR010200000','HY000000000'),
 ('JH-RN040100000','JH000000000'),
 ('KA-SK093700000','KN000000000'),
 ('KL-CC030100000','KL000000000'),
 ('MH-PR810100000','MH000000000'),
 ('MP-BH010700000','MP000000000'),
 ('NE-NN020100000','NE000000000'),
 ('OI-BN070200000','OI000000000'),
 ('PB-JL050200000','PB000000000'),
 ('RJ-JD070200000','RJ000000000'),
 ('TL-PA010100000','TL000000000'),
 ('TN-PM100100000','TN000000000'),
 ('UP-GR040200000','UP000000000'),
 ('UT-DN110100000','UT000000000'),
 ('WB-SG030100000','WB000000000');''';

    if (insofccount == 0) {
      final result = await InsTran().execSQL(sqlinsofccount);
      print("INS OFFICE CODES");
      print(result);
    }

    final fininssql =
        "insert into INS_ERROR_CODES ([Error_code],[Error_message]) values  ('NO_TRAN_FOR_DATE ',' No transactions available for the selected date.'),('SELECT_INDEX',' Please select one transaction to proceed.'),('TRAN_SUCCESS_0 ',' Transaction status updated as - '),('TRAN_SUCCESS_1 ','  for Account No. - '),('TRAN_SUCCESS_2 ','  for Receipt No. - '),('TRAN_SUCCESS_3 ','  and Transaction id - '),('INSTALLMENT_ERR','Please pay for the installments being calculated'),('INSTALLMENT_ERR_MAT','Please pay for the installments not exceeding maturity date'),('ENVIRONMENT_ERROR ',' Transaction is not processed. Kindly restart the application and try again.'),('DATE_ERR ',' Date entered is greater than current date.'),('INVALID_POLICY ',' Invalid policy number.'),('INVALID_QUOTE_TYPE ',' Please select quote type.'),('INVALID_AMT ',' Amount paid cannot be less than Total Amount.'),('INVALID_DATE ',' Invalid To Date.'),('POLICY_NOT_ELIGIBLE ',' Policy Status is not eligible.'),('ACTIVE_LAPSE ',' Policy in lapsed status cannot collect.'),('POLICY_NOT_FOUND ',' Policy Details not found.'),('FINACIAL_REQUEST_PENDING ',' Financial Request is already pending so this request cannot be processed.'),('MATURITY_ERROR ',' Maturity request cannot be accepted 30 days before maturity date.'),('PREMIUM_DATE_ISSUE ',' Premium paid Till Date and Pass Book Premium Paid Date are not equal.'),('PREMIUM_DURATION_ERROR ',' Policy duration or Premium paid duration is less than required.'),('UNPROCESSED_STATUS ',' Some pending event exists with unprocessed status.'),('MATURITY_NOT_ELIGIBLE ',' Policy Type is Not Eligible.'),('INVALID_INPUT ',' Policy Number cannot be blank.'),('Name_Err ',' Name cannot be blank.'),('0004 ',' Incorrect input screen name.'),('0007 ',' Policy status is not eligible.'),('F017 ',' Invalid policy number.'),('1157 ',' Prdmktinfoext data not found.'),('0035 ',' Paid to date is blank'),('0063 ',' Previous Revival/Reinstatement request has exceeded 30 days. Please index a new request'),('1314 ',' Policy in lapsed status cannot collect.'),('0057 ',' Policy is in Inactive/Void status Request you to Reinstate the policy'),('0053 ',' Policy is not eligible for premium collection'),('INT.0000 ',' Success'),('INT.1001 ',' Invalid Policy Number.'),('INT.1002 ',' Policy Number should be alpha-numeric with '-' (hyphen)accepted.'),('INT.1003 ',' Invalid Service Request Date.'),('INT.1004 ',' Invalid Office Code.'),('INT.1005 ',' Invalid Operation center code.'),('INT.1006 ',' Invalid User Name'),('INT.1007 ',' Invalid Request Type.'),('INT.1008 ',' Premium paid till date and pass book premium paid date are not equal.'),('INT.1009 ',' PassBook Paid To Date does not match System Paid To Date.'),('INT.1010 ',' Maturity Claim is already Pending for this policy number.'),('INT.1011 ',' Policy Number is not present in System.'),('INT.1012 ',' A same pending event exists with unprocessed status'),('INT.1013 ',' Input Policy Number is not available in the system.'),('INT.1014 ',' Policy Type is Not Eligible.'),('INT.1015 ',' Policy duration or Premium paid duration is less than required.'),('INT.1016 ',' Maturity request cannot be accepted 30 days before maturity date.'),('INT.1017 ',' Policy status is not pending maturity or maturity is greater than 30 days from today'),('INT.1018 ',' A same pending event exists with unprocessed status.'),('INT.1019 ',' Policy status is not eligible.'),('INT.1020 ',' Policy is already surrendered and not eligible.'),('INT.1021 ',' Surrender request should be withdrawn for a death claim request.'),('INT.1022 ',' Death occurs after the month of surrender then claim not registered.'),('INT.1023 ',' Surrender request date is blank.'),('INT.1024 ',' Surrender request date is less than Policy Issue date.'),('INT.1025 ',' P300 event which precedes Loan/Surrender/Survival/Death/Maturity Claim exists. Not allowed to undo this P300.'),('INT.1026 ',' Surrender factor not available.'),('INT.1027 ',' Policy Status is not eligible for Surrender as Policy is in terminated status.'),('INT.1028 ',' Conversion record exists for Policy after Notification Date'),('INT.1029 ',' Policy not eligible for conversion due to duration restrictions'),('INT.1030 ',' Product not eligible for conversion'),('INT.1031 ',' Invalid Policy Conversion Product Age Rule'),('INT.1032 ',' Insure Issue Age Exceeds Conversion Product Limitations'),('INT.1033 ',' Insure Attained Age Exceeds Conversion Product Limitations'),('INT.1034 ',' Start Date must be greater than conversion (cell conversion) date. '),('INT.1035 ',' Conversion-Policy must be Paid upto Previous Month of Anniversary'),('INT.1036 ',' Policy Terminated and Conversion Effective Date Less than Date Of Death.'),('INT.1037 ',' Conversion is processed hence refund is not allowed'),('INT.1038 ',' Conversion not allowed until all revival installments have been paid.'),('INT.1039 ',' Conversion request Pending on this policy-Service Request indexing not allowed.'),('INT.1040 ',' Conversion request not allowed -Pay Recovery Policy Premiums not paid till date.'),('INT.1041 ',' Conversion request is indexed Quote generation not allowed.'),('INT.1042 ',' Conversion request approved on this policy - Commutation not allowed.'),('INT.1043 ',' Policy type is not eligible for Commutation.'),('INT.1044 ',' Commutation allowed only once in a policy term.'),('INT.1045 ',' Policy not eligible for billing frequency change as Commutation is not yet completed.'),('INT.1046 ',' Policy is not eligible for premium payment as Commutation request  is not yet Completed.'),('INT.1047 ',' The Maximum number of Revival requests for the policy have been exceeded'),('INT.1048 ',' The policy is eligible for Revival'),('INT.1049 ',' Revival installment is not allowed on this policy. '),('INT.1050 ',' Previous Revival/Reinstatemnt request has exceeded 30 days. Please index a new request. '),('INT.1051 ',' Installment Revival cannot be allowed since selected installments is taking revival payments beyond date of last payment'),('INT.1052 ',' Policy Converted - Revivals not allowed'),('INT.1053 ',' Loan disbursement is still Pending. Collection cannot be done.'),('INT.1054 ',' Policy Loan Interest Exceeds Maxium Limitations'),('INT.1055 ',' Policy Loan Amount Exceeds Product Maxium'),('INT.1056 ',' Amount less than minimum Loan amount.'),('INT.1057 ',' Loan Already exist.'),('INT.1058 ',' 1 year not completed after previous Loan paid-off'),('INT.1059 ',' Policy loan is either paid off or not issued on the Policy selected'),('INT.1060 ',' Policy is assigned to President Of India And Loan exist on Policy.'),('INT.1061 ',' Policy is assigned to President Of India And Loan exist on Policy.'),('INT.1062 ',' There is no  Loan on the selected Policy hence the Loan Repayment Quote cannot be generated'),('INT.1063 ',' Loan Repayment is under process for same day'),('INT.1064 ',' RPU cannot be indexed Billing method change request is pending.'),('INT.1065 ',' Reduced Paid Up request is indexed Quote generation not allowed.'),('INT.1066 ',' The Maximum number of Survival requests for the policy have been exceeded'),('INT.1067 ',' RPU request is pending for approval'),('INT.1068 ',' Free look/Policy cancellation request is pending'),('INT.1069 ',' Surrender on child policy cannot be allowed with effect from 28 April 2011.'),('INT.1070 ',' Error in ip_getmthsroundup in util-dates.p'),('INT.1071 ',' Error in Creating Cecovlayer Increase Layer'),('INT.1072 ',' Product Market Info record not found.'),('INT.1073 ',' Invalid Product ID'),('INT.1074 ',' Policy Ceasing Year is less than 1 Year'),('INT.9999 ',' Internal Server Exception. Please contact System administrator.'),('INT.10002 ',' Death Claim Request Submitted for this Policy so this request cannot be submitted. '),('INT.10003 ',' Financial Request is already Pending so this request cannot be processed.'),('INT.10004 ',' Please select Died Insured.'),('INT.10005 ',' Missing Claim Intimation form.'),('INT.10006 ',' Missing Death Claim Certificate.'),('INT.10008 ',' Missing Reason For Disputed.'),('INT.10009 ',' Missing FIRST NAME'),('INT.10010 ',' First Name should be in proper format.'),('INT.10011 ',' Middle Name should be in proper format.'),('INT.10012 ',' Last Name should be in proper format.'),('INT.10013 ',' INVALID PHONENUMBER.'),('INT.10014 ',' Missing Relationship to the Insured.'),('INT.10015 ',' Relationship to the Insured should be in alphabet format.'),('INT.10016 ',' Missing Date of Death.'),('INT.10017 ',' Date of Death should be in DD/MM/YYYY format.'),('INT.10018 ',' Date of Death should be greater than or equal to policy issuance date.'),('INT.10019 ',' Date should not be greater than today''s date.'),('INT.2001 ',' Insured Age should be minimum of 21 years and maximum of 45 years'),('INT.2002 ',' Age less than minimum specified age (i.e. 21 years) for Secondary Insured is not allowed.'),('INT.2003 ',' Age is greater than required (i.e.45) for Primary Insured. Enter valid date of Birth.'),('INT.2004 ',' Age is greater than required (i.e.45) for Secondary Insured. Enter valid date of Birth.'),('INT.2005 ',' future date is not allowed.'),('INT.2006 ',' Age is Greater then Required! Enter valid'),('INT.2007 ',' Age is Less then Required! Enter valid '),('INT.2008 ',' vpas exception'),('INT.2009 ',' Service exception'),('INT.2010 ',' data access exception through hibernate '),('INT.2011 ',' system error '),('INT.2012 ',' Office code missing'),('INT.99999 ',' Invalid Proposal Number'),('CONNECTION_ERROR ',' Unable to establish connection. Kindly exit the application and try again.'),('AMOUNT_ERROR ',' Valid amount can contain only numbers'),('INSTRUMNT_ERROR ',' Instrument number can contain only numeric value'),('ACC_NOT_WIT_BO ',' Entered policy is not linked to this BO. Please contact home branch.'),('RSI.1015 ',' Policy duration or Premium paid duration is less than required.'),('UNABLE_TO_PRINT_ERROR ',' Not able to print your transaction.'),('ENVIRONMENT_ERROR ',' Transaction is not processed. Kindly restart the application and try again.'),('SIM_ERROR ',' SIM services are not available. Kindly re-start SIM services and try again.'),('NO_ERROR ',' Number of installment can contain only numbers'),('AMT_ERROR ',' Amount received should not be less than total amount.'),('LOAN_AMT_MIN ',' Loan amount should be between min and max loan amount.'),('LOAN_AMT_MULT ',' Pleae ensure loan amount is in multiple of 100'),('LOAN_TERM_MAND ',' Please enter the valid loan term.'),('LOAN_FREQ_MAND ',' Please enter the valid loan frequency.'),('INVALID_PTYPE_LOAN ',' Policy type is not eligible for loan request.'),('QUATERLY_LOAN_TERM ',' Invalid repayment term. Repayment term should be multiple of 3 for quarterly.'),('SEMI_ANNUAL_LOAN_TERM ',' Invalid repayment term. Repayment term should be multiple of 6 for semi annually.'),('AMT_ERROR_EXTRA ',' Amount received cannot be greater than total amount.'),('CHEQUE_AMOUT ',' Please use payment mode as cheque for amount greater than Rs.50000'),('CHEQUE_NUMERIC ',' Cheque number should be numeric.'),('CHEQUE_NUM_LIMIT ',' Cheque number should be six digits.'),('MICR_LIMIT ',' MICR code should be nine digit.'),('MICR_NUM ',' MICR code should be numeric.'),('BRANCH_CODE ',' Branch code should be six digit.'),('BRANCH_NUMERIC ',' Branch code should be numeric.'),('IFSC_LENGTH ',' IFSC code should be eleven digit alphanumeric code.'),('IFSC_SPECIFICATION ',' First four characters of the IFSC code should be alphabets and it should identify bank'),('IFSC_LAST_NUM ',' last seven characters of the ifsc code should be numbers or alphanumeric endig with DOP'),('IFSC_LAST_DOP ',' IFSC code ending with DOP should contain 4 digits bfore DOP'),('DRAWEE_ALPHA ',' Drawee Bank name should contain only alphabets.'),('CHEQUE_DATE_LIMIT ',' Cheque date should be within the past 3 months.'),('CHEQUE_DATE_ERROR ',' Cheque date cannot be a future date.'),('PREMIUM_POLICY ',' Policy is not eligible for premium collection'),('NON_INDEXING_POLICY ',' Policy status not Eligible'),('MATURITY_POLICY ',' Policy is not eligible for maturity'),('MIN_DIFF ',' Date entered should be greater than or equal to'),('SQLITE_ERROR ',' Unable to connect to local database.'),('DB_INSERT_ERROR ',' Failed to update data in local database.'),('INVALID_DB_RESPONSE ',' Invalid response from local database.'),('NO_RECORDS_FOUND ',' No records found'),('RICTADMIN_NO_ACCESS ',' *********** ACCESS DENIED *********** \n\nPLI Application is not accessible for RICT ADMIN.'),('INITIAL_PAYMENT_STATUS_ERROR',' Transaction with pending status exist with same proposal number.'),('RENEWAL_PAYMENT_STATUS_ERROR','Transaction with pending status exist with same policy number.'),('PLI_AMOUNT_MULTIPLIER_ERROR ',' Sum assured should be in multiple of 10000 for PLI policies'),('RPLI_AMOUNT_MULTIPLIER_ERROR ',' Sum assured should be in multiple of 5000 for RPLI policies'),('AGE_DIFF_ERROR ',' Your age on next birthday should be >= 19 or <= 55 years'),('AGE_DIFF_ERROR_3 ',' Your age on next birthday should be >= 19 or <= 45 years'),('AGE_DIFF_ERROR_2 ',' Your age on next birthday should be >= 19 or <= 40 years'),('AGE_DIFF_ERROR_4 ',' Your age on next birthday should be >= 19 or <= 50 years'),('AGE_DIFF_ERROR_5 ',' Your age on next birthday should be >= 20 or <= 45 years'),('AGE_DIFF_ERROR_6 ',' Your age on next birthday should be >= 21 or <= 45 years'),('VALID_DATE_ERROR ',' Please enter a valid date'),('AMOUNT_ERROR_1 ',' Please enter a value between 20000 and 5000000.'),('AMOUNT_ERROR_2 ',' Please enter a value between 10000 and 1000000.'),('AMOUNT_ERROR_3 ',' For PLI child policies please enter a value between 20000 and 300000.'),('AMOUNT_ERROR_4 ',' For RPLI child policies please enter a value between 20000 and 100000.'),('PARENT_AGE_DIFF_ERROR ',' Parent age must be less than 44 years'),('PARENT_POLICY_ERROR ',' Parent Policy should be Suraksha/Santosh Or Gram Suraksha/Gram Santosh only'),('SPOUSE_AGE_DIFF_ERROR ',' Spouse age on next birthday should be >= 21 or <= 45 years'),('CHILD_AGE_DIFF_ERROR ',' child age should be >=5 or <= 20 Years'),('CHILD_PARENT_SUMASSURED_ERROR ',' child sum assured should be less than Parent sum assured'),('INVALID_INPUT2 ',' Proposal number cannot be blank.'),('DATE_ERROR_1 ',' Date of Proposal greater than Date of Indexing'),('DATE_ERROR_2 ',' Date of Proposal greater than Date of Declaration Date'),('DATE_ERROR_3 ',' Date of Proposal greater than Application Receipt Date'),('DATE_ERROR_4 ',' Date of Declaration greater than Date of Indexing'),('DATE_ERROR_5 ',' Date of Declaration greater than Application Receipt Date'),('DATE_ERROR_6 ',' In Date of Declaration future date is not allowed'),('DATE_ERROR_7 ',' Application Receipt Date greater than Date of Indexing'),('DATE_ERROR_8 ',' In Application Receipt Date future date is not allowed'),('DATE_ERROR_9 ',' In Date of Indexing future date is not allowed'),('DATE_ERROR_10 ',' Application date cannot be less then birth date'),('DATE_ERROR_11 ',' Proposal date cannot be less then birth datee'),('DATE_ERROR_12 ',' Declaration date cannot be less then birth date'),('DATE_ERROR_13 ',' Indexing date cannot be less then birth date'),('NAME_ERROR ',' Valid name can contain only alphabets'),('POLICY_ERROR ',' Policy number should be only alphanumeric and '-''),('PROPOSAL_ERROR ',' Proposal number should be alphanumeric and '-''),('5001 ',' User doesnt have access for collection'),('5002 ',' UserName is empty.'),('5003 ',' Proposal is not eligible.'),('5004 ',' Ifsc code is not valid'),('5005 ',' account number is invalid'),('5006 ',' Office code is not valid for user'),('5007 ',' UserName is incorrect(Not present in the Mccamish system)'),('5008 ',' Proposal number is incorrect'),('5009 ',' Proposal number is empty'),('5010 ',' Proposal has been already converted into policy'),('sa_error ',' Sum Assured is missing'),('aam_error ',' Please select age at maturity'),('pt_error ',' Please select Policy term'),('pca_error ',' Please select Premium ceasing age'),('payment_freq_error ',' Please select payment frequency'),('productNameError ',' Product name is missing'),('INVALID_RECEIPT ',' Please select one receipt number to proceed.'),('CANCELLATION_ERROR_1_1 ',' No collection are done for this policy'),('CANCELLATION_ERROR_1_2 ',' No collection are done for this proposal'),('CANCELLATION_ERROR_2_1 ',' cancellation request is already submitted for this policy'),('CANCELLATION_ERROR_2_2 ',' cancellation request is already submitted for this proposal'),('CANCELLATION_ERROR_3 ',' Proposal has already been approved and cannot be cancelled.'),('COLLECTION_ERROR ',' No collection are done for this policy today'),('INT.3001 ',' Cancellation request is already submitted for this proposal number.'),('INT.3002 ',' No Collections Are done on this policy or proposal Today.'),('INT.3003 ',' Policy number or proposal number both are missing.'),('INT.3004 ',' Collection cancellation not possible for this receipt as receipt number is incorrect or missing.'),('INT.3005 ',' Collection cancellation not possible for this receipt.'),('INT.3006 ',' Proposal Has been Approved Can not Cancel Collection.'),('QUOTE_ERROR ',' Unable to generate quote with the details provided'),('QUOTE_POLICY ',' Policy is not eligible for quote'),('0001 ',' Search Criteria results in more than 50 records. Re-enter the criteria.'),('0002 ',' Incorrect Input parameters.'),('0003 ',' Incorrect Input Mode.'),('0005 ',' Incorrect column updated for input parameter & parameter_name.'),('0006 ',' Given Policy Number is not available in the system.'),('0006ep ',' Given Policy Number is not available in the system.'),('0007ep ',' Policy has invalid Policy Status.'),('0008 ',' Dear Customer policy revival can be done only for two times. Since you have already reached the maximum revival limit we cannot go ahead with the revival of the selected policy.'),('0009 ',' Policy Type is Not Eligible.'),('0010 ',' The policy age is less than the minimum policy age required for eligibility of this service request.'),('0011 ',' The policy has already been assigned and hence not eligible for this request.'),('0012 ',' Maturity request cannot be accepted <days> before maturity date.'),('0013 ',' Number of premium payment less than required.'),('0014 ',' The policy has already been surrendered and hence not eligible for this request.'),('0015 ',' Please withdraw the already existing Surrender request.'),('0016 ',' Product Market Info record not found'),('0017 ',' The selected policy is not eligible for this request since the policy age is less than 6 months.'),('0018 ',' The policy is not eligible for the request since the policy has lapsed.'),('0019 ',' Cell Status is Inactive.'),('0020 ',' Payee details not found.'),('0021 ',' Policy status is not pending maturity or maturity is greater than 30 days from today'),('0022 ',' No Output Data.'),('0023 ',' Invalid Input Date'),('0024 ',' A same pending event exists with unprocessed status.'),('0030 ',' No Policy record found for given search criteria.'),('0031 ',' Product record not found'),('0032 ',' Premium Ceasing Age not found'),('0033 ',' Alpha Record does not exist for Policy Holder'),('0034 ',' No Billing Record Found for policy'),('2176',' Input Parameters are blank.'),('2177',' No request type available for the mentioned policy number'),('2178',' No disbursement detail available for request type and policy number'),('0036 ',' Cell Bill record is not available.'),('0037 ',' Product Market Info Extension record not found'),('0038 ',' The policy is eligible for Reinstatement'),('0039 ',' The policy is eligible for Revival'),('0045 ',' XML not available for given SERVICE_REQUEST_ID'),('0046 ',' Could not upload the XML to REQUEST_DATA'),('0047 ',' Unable to convert tag value in XML to date'),('0048 ',' No Base Coverage Found for Requested Policy'),('0048 ',' No Base Coverage Found for Requested Policy'),('0049 ',' Error Parsing the XML file'),('0052 ',' Unknown Policy Paid to Date'),('0055 ',' Policy Less than 60 Days old'),('0056 ',' Premium Paid Date is after the effective date.'),('//0057 ',' Policy is in Inactive/Void status Request you to Reinstate the policy'),('0058 ',' Policy is in Lapsed status Request you to Revive the policy'),('0065 ',' Policy has already maturedcannot surrender'),('1001 ',' Invalid Policy Term'),('1002 ',' Dates are blank Cannot calculate paid up value.'),('1011 ',' Invalid  baseamount for bonus calculation'),('1012 ',' Bonus Rates not available'),('1013 ',' No PrdMktInfoExt for Bonus EndDate Rule'),('1014 ',' No PrdMktInfoExt for Revisionary Code'),('1015 ',' Policy Not eligible for terminal bonus'),('1016 ',' No PrdMktInfoExt for Terminalcode'),('1101 ',' Invalid date of death.'),('1102 ',' Invalid date of Notification.'),('1103 ',' Error assigning data to Policy.'),('1104 ',' Error creating PendEvntInfo.'),('1105 ',' Error in creating evnt for child policy.'),('1106 ',' Error creating tt_PendEvnt.'),('1107 ',' Death Claim Process has already been initiated .'),('1108 ',' Date Of Death is less than policy issue date.'),('1109 ',' Date of death is after Maturity Date.'),('1110 ',' Policy is Active Paid Up and Death Date is after TermEndDate.'),('1111 ',' Already a pending event exist for the policy.'),('1112 ',' Cell is on hold.'),('1113 ',' Policy within suicide exclusion period.'),('1114 ',' S200 PendEvnt not available.'),('1115 ',' Error creating S200.'),('1116 ',' S202 already exists.'),('1117 ',' CeFinHst exists after date of death.'),('1118 ',' ipUndoIPS200  Undo Exists.'),('1119 ',' ipUndoIPS200  RSA Warning.'),('1120 ',' ipUndoIPS200  Error in valundo000.p.'),('1121 ',' Error creating Undo Record.'),('1122 ',' Policy is under incostestability period'),('1123 ',' Policy is under sucide exlusion period'),('1124 ',' An Undo without a scheduled Redo'),('1125 ',' Policy is under hold state'),('1126 ',' Billing Method  EFT or credit card  has been selected'),('1127 ',' Death occurs after the month of surrender then claim not registered'),('1128 ',' Pend event record not available'),('1129 ',' Financial history record not available'),('1130 ',' Product record not available'),('1131 ',' Conversion record exists for Policy after Notification Date'),('1132 ',' Blank Request Type'),('1151 ',' The loan interest on the selected loan amount exceeds the maximum eligibility for the policy held by you.'),('1152 ',' The loan amount selected is lower than the minimum acceptable loan amount on this policy. '),('1153 ',' Dear Customer the selected policy is not eligible for a loan request.'),('1154 ',' Dear Customer you had availed of a loan on this policy and made the repayment. However you can be eligible for a loan only after 1 year has passed after the loan closure'),('1155 ',' The loan amount selected is higher than the maximum acceptable loan amount on this policy.'),('1156 ',' Dear Customer please select the date to get the quote. Kindly ensure that the date is equal to todays date or more'),('//1157 ',' PrdmktInfoExt data not found'),('1175 ',' policy status does not allow policy to mature'),('1201 ',' Billing Frequency is fixed for this product.'),('1202 ',' Invalid Billing Frequency Information'),('1203 ',' Error in Billing Frequency Validation'),('1204 ',' Error in Billing Frequency Change'),('1212 ',' Customer ID is not available.'),('1213 ',' Error in updating Address1'),('1214 ',' Error in updating phonetype1 in Address1'),('1215 ',' Error in updating PhoneType2 in Address 1'),('1216 ',' Error in updating Email Address in Address1'),('1217 ',' Error in updating Address2'),('1218 ',' Error in updating phonetype1 in Address2'),('1219 ',' Error in updating PhoneType2 in Address 2'),('1220 ',' Error in updating Email Address in Address2'),('1221 ',' Error in Changing the name.'),('1222 ',' Customer Records Not Found'),('1223 ',' Error in Creating Non-Fin Event for Name Change'),('1261 ',' Policy not eligible for conversion due to duration restrictions'),('1262 ',' The loan amount selected is higher than the maximum acceptable loan amount on this policy.'),('1263 ',' Product not eligible for conversion'),('1264 ',' Invalid Policy Conversion Product Age Rule'),('1265 ',' Insure Issue Age Exceeds Conversion Product Limitations'),('1266 ',' Policy Must be Paid to Date'),('1266 ',' The policy is not eligible for the selected request since all the premiums have not been paid up'),('1266ep ',' Policy has a pending premium.Past payment is due.'),('1267 ',' Insure Attained Age Exceeds Conversion Product Limitations'),('1267 ',' Insure Exceed Required Number of Conversion Options'),('1268 ',' Invalid Factor 1'),('1269 ',' Invalid Factor 2'),('1270 ',' Policy Ceasing Year is less than 1 Year'),('1271 ',' Policy Maturity Year is less than 1 Year'),('1272 ',' No record available in optt_prem'),('1281 ',' Blank Request Type'),('1282 ',' Blank Stage ID from Workflow'),('1283 ',' Blank Signal Name from Workflow'),('1291 ',' Blank Request Type'),('1291 ',' Error in ip_fixpremamts in Util-FixPrem.p'),('1292 ',' Blank Stage ID from Workflow'),('1293 ',' Blank Signal Name from Workflow'),('1301 ',' Error in ip_fixpremamts in Util-FixPrem.p'),('1302 ',' Error in Bonuscalc.p'),('1303 ',' Error in Codemod.p'),('1304 ',' Invalid ProductID'),('1305 ',' Error in ip_PuClcDur in util-dates.p'),('1306 ',' No Record available in SurvClaimSched'),('1307 ',' Error in ip_RtnCovID in RtnCovID.p'),('1308 ',' Error in ip_CalcFace in util-policy.p'),('1309 ',' Error in surv_clc.p'),('1310 ',' Error in procedure WFPreCrtS621'),('1311 ',' Invalid Date.'),('1316 ',' Service Tax/GST rates not available'),('1401 ',' Dear Customer please select the date to get the quote. Kindly ensure that the date is equal to todays date or more'),('1402 ',' Surrender request date is less than Policy Issue date'),('1403 ',' Policy is already Terminated'),('1405 ',' SurrenderRequest date is greater than Termenddate'),('1406 ',' No PrdMktInfoExt for SurrChgDur'),('1410 ',' Error in ip_ValidateDisb in util-disb'),('1411 ',' Error in WFPrecrts220'),('1421 ',' Revised Prem Amt AND Revised Sum Assured Amt both Zero One must be populated'),('1422 ',' Revised Sum Assured Amt is Greater than current amount.  Increase not allowed at this time.'),('1423 ',' Revised Premium Amount is Greater than current amount.  Increase not allowed at this time.'),('1424 ',' The Revised Sum Assured Amt is less than the Minimum required for this product '),('1425 ',' Applied Sum Assured is greater than current Sum Assured'),('1426 ',' RtPremSel Not available for that tablecode.'),('1427 ',' Current Paid up value is greater than reduced sum assured.'),('1428 ',' Applied Sum Assured less than the allowed limit for this product'),('1429 ',' Policy type is not eligible for Commutation.'),('1531ep ',' Policy has invalid Special Group.'),('1533ep ',' Policy number already exist in special group.Policy already mapped to special group'),('1533ep ',' Policy status not Eligible.'),('1707 ',' Policy Dispatch Date is null'),('1760ep ',' Policy have same DDO Code as of logged in user.'),('1761ep ',' DDO Code is not available for the given policy number.'),('1762ep ',' Premium of this policy is already paid for this period.'),('1921 ',' Premium for 36 months not received. Hence surrender not allowed '),('1923 ',' Policy status is not eligible.'),('5656ep ',' Policy Details were not found.Please Check policy number and DDO Code.'),('9999 ',' Success.'),('9999ep ',' Success '),('//F017 ',' Cell not found for CellID'),('F030 ',' Error in Creating Cecovlayer Increase Layer'),('F146 ',' Product not found for CarrID'),('F269 ',' Incorrect Bill Schedule data'),('F289 ',' PrdMktSurrChg record not available'),('F316 ',' RTPremSel not found for'),('F382 ',' Surrender factor not available'),('LOAN_QUOTE_CUSTOM_ERROR_001 ',' Technical difficulty while fetching the data. Please try again  later.'),('INT.4075 ',' Search Criteria results in more than 50 records. Re-enter the criteria.'),('INT.4076 ',' Incorrect Input parameters.'),('INT.4077 ',' Incorrect Input Mode.'),('INT.4078 ',' Incorrect Input Screen Name.'),('INT.4079 ',' Incorrect column updated for input parameter & parameter_name.'),('INT.4080 ',' Policy already assigned and not eligible.'),('INT.4081 ',' Number of premium payment less than required.'),('INT.4082 ',' This is a duplicate claim for the policy indexing is not allowed.'),('INT.4083 ',' Death claim is not allowed for this policy after remission period for the status of VL/IL/AL'),('INT.4084 ',' Cell Status is Inactive.'),('INT.4085 ',' Payee details not found.'),('INT.4086 ',' No Output Data.'),('INT.4087 ',' Invalid Input Date'),('INT.4088 ',' No Policy record found for given search criteria.'),('INT.4089 ',' Product record not found'),('INT.4090 ',' Premium Ceasing Age not found'),('INT.4091 ',' Alpha Record does not exist for Policy Holder'),('INT.4092 ',' Paid to Date is blank.'),('INT.4093 ',' No Billing Record Found for policy'),('INT.4094 ',' Cell Bill record is not available.'),('INT.4095 ',' Product Market Info Extension record not found'),('INT.4096 ',' The policy is eligible for Reinstatement'),('INT.4097 ',' XML not available for given SERVICE_REQUEST_ID'),('INT.4098 ',' Could not upload the XML to REQUEST_DATA'),('INT.4099 ',' Unable to convert tag value in XML to date'),('INT.40100 ',' No Base Coverage Found for Requested Policy'),('INT.40101 ',' Error Parsing the XML file'),('INT.40102 ',' Unknown Policy Paid to Date'),('INT.40103 ',' Policy Less than 60 Days old'),('INT.40104 ',' Success.'),('INT.40105 ',' Invalid date of death.'),('INT.40106 ',' Invalid date of Notification.'),('INT.40107 ',' Error assigning data to Policy.'),('INT.40108 ',' Error creating PendEvntInfo.'),('INT.40109 ',' Error in creating evnt for child policy.'),('INT.40110 ',' Error creating tt_PendEvnt.'),('INT.40111 ',' Death Claim Process has already been initiated .'),('INT.40112 ',' Date Of Death is less than policy issue date.'),('INT.40113 ',' Date of death is after Maturity Date.'),('INT.40114 ',' Policy is Active Paid Up and Death Date is after TermEndDate.'),('INT.40115 ',' Already a pending event exist for the policy.'),('INT.40116 ',' Cell is on hold.'),('INT.40117 ',' Policy within suicide exclusion period.'),('INT.40118 ',' S200 PendEvnt not available.'),('INT.40119 ',' Error creating S200.'),('INT.40120 ',' S202 already exists.'),('INT.40121 ',' CeFinHst exists after date of death.'),('INT.40122 ',' ipUndoIPS200  Undo Exists.'),('INT.40123 ',' ipUndoIPS200  RSA Warning.'),('INT.40124 ',' ipUndoIPS200  Error in valundo000.p.'),('INT.40125 ',' Error creating Undo Record.'),('INT.40126 ',' Policy is under incostestability period'),('INT.40127 ',' Policy is under sucide exlusion period'),('INT.40128 ',' An Undo without a scheduled Redo'),('INT.40129 ',' Policy is under hold state'),('INT.40130 ',' Billing Method  EFT or credit card  has been selected'),('INT.40131 ',' Pend event record not available'),('INT.40132 ',' Financial history record not available'),('INT.40133 ',' Product record not available'),('INT.40134 ',' Blank Request Type'),('INT.40135 ',' Blank Stage ID from Workflow'),('INT.40136 ',' Blank Signal Name from Workflow'),('INT.40137 ',' Blank Request Type'),('INT.40138 ',' Policy Anniversary is greater than paid to date'),('INT.40139 ',' Blank Request Type'),('INT.40140 ',' Blank Stage ID from Workflow'),('INT.40141 ',' Blank Signal Name from Workflow'),('INT.40142 ',' Error in ip_fixpremamts in Util-FixPrem.p'),('INT.40143 ',' Error in Bonuscalc.p'),('INT.40144 ',' Error in Codemod.p'),('INT.40145 ',' Error in ip_PuClcDur in util-dates.p'),('INT.40146 ',' No Record available in SurvClaimSched'),('INT.40147 ',' Error in ip_RtnCovID in RtnCovID.p'),('INT.40148 ',' Error in ip_CalcFace in util-policy.p'),('INT.40149 ',' Error in surv_clc.p'),('INT.40150 ',' Error in procedure WFPreCrtS621'),('INT.40151 ',' Invalid Policy Term'),('INT.40152 ',' Dates are blank Cannot calculate paid up value.'),('INT.40153 ',' Invalid  baseamount for bonus calculation'),('INT.40154 ',' Bonus Rates not available'),('INT.40155 ',' No PrdMktInfoExt for Bonus EndDate Rule'),('INT.40156 ',' No PrdMktInfoExt for Revisionary Code'),('INT.40157 ',' No PrdMktInfoExt for Terminalcode'),('INT.40158 ',' Policy Not eligible for terminal bonus'),('INT.40159 ',' Error in ip_ValidateDisb in util-disb'),('INT.40160 ',' Error in WFPrecrts220'),('INT.40161 ',' Policy is already Terminated'),('INT.40162 ',' SurrenderRequest date is greater than Termenddate'),('INT.40163 ',' No PrdMktInfoExt for SurrChgDur'),('INT.40164 ',' PrdMktSurrChg record not available '),('INT.40165 ',' policy status does not allow policy to mature'),('INT.40166 ',' Billing Frequency is fixed for this product.'),('INT.40167 ',' Invalid Billing Frequency Information'),('INT.40168 ',' Error in Billing Frequency Validation '),('INT.40169 ',' Error in Billing Frequency Change'),('INT.40170 ',' Customer ID is not available.'),('INT.40171 ',' Error in updating Address1'),('INT.40172 ',' Error in updating phonetype1 in Address1'),('INT.40173 ',' Error in updating PhoneType2 in Address 1'),('INT.40174 ',' Error in updating Email Address in Address1'),('INT.40175 ',' Error in updating Address2'),('INT.40176 ',' Error in updating phonetype1 in Address2'),('INT.40177 ',' Error in updating PhoneType2 in Address 2'),('INT.40178 ',' Error in updating Email Address in Address2'),('INT.40179 ',' Error in Changing the name.'),('INT.40180 ',' Customer Records Not Found'),('INT.40181 ',' Error in Creating Non-Fin Event for Name Change'),('INT.40182 ',' Revised Prem Amt AND Revised Sum Assured Amt both Zero One must be populated'),('INT.40183 ',' Revised Sum Assured Amt is Greater than current amount.  Increase not allowed at this time.'),('INT.40184 ',' Revised Premium Amount is Greater than current amount.  Increase not allowed at this time.'),('INT.40185 ',' The Revised Sum Assured Amt is less than the Minimum required for this product '),('INT.40186 ',' Applied amount is greater than maximum amount allowed'),('INT.40187 ',' Request date is Null.'),('INT.40188 ',' PrdmktInfoExt data not found'),('INT.40189 ',' Applied Sum Assured should be less than current Sum Assured.'),('INT.40190 ',' RtPremSel Not available for that tablecode.'),('INT.40191 ',' Current Paid up value is greater than reduced sum assured.'),('INT.40192 ',' Incorrect Bill Schedule data '),('INT.40193 ',' Premium Paid Date is after the effective date.'),('INT.40194 ',' Policy is in Inactive/Void status Request you to Reinstate the policy'),('INT.40195 ',' Death Claim is not allowed for Policy status TD'),('INT.40196 ',' Invalid Factor 1'),('INT.40197 ',' Invalid Factor 2'),('INT.40198 ',' Policy Maturity Year is less than 1 Year'),('INT.40199 ',' No record available in optt_prem'),('INT.40200 ',' Invalid Date.'),('INT.40201 ',' Applied Sum Assured less than the allowed limit for this product'),('INT.40202 ',' Policy Number not found'),('INT.40203 ',' Product not found for CarrID'),('INT.40204 ',' RTPremSel not found for'),('INT.40205 ',' Policy is in Lapsed status Request you to Revive the policy'),('INT.40206 ',' InvPolYrDate'),('INT.40207 ',' InvPTD'),('INT.40208 ',' A Frequency change has been submitted on <NextAnniv>   to change from <CurBillFreq> to <NewSchedFreq>.'),('INT.40209 ',' Credit Card has been charged.  Need to wait until payment is processed.'),('INT.40210 ',' No BillControl record available.'),('INT.40211 ',' Effective date must be greater then BillSchedule StartDate.'),('INT.40212 ',' Unpaid invoices exist.'),('INT.40213 ',' Effective date has to be on current Anniversary  <CurrAnnvDate> or next billing date <NextEffDate>'),('INT.40214 ',' Effective date has to be on the current billing  <BillToDate> or <nextbillingdate> or <NextEffDate>'),('INT.40215 ',' Bill To Date cant be greater  <PaidToDate> . Billing frequency change rollback needs to process to correct Bill To Date.'),('INT.40216 ',' Billing Status is <BillingStatus>'),('INT.40217 ',' Policy status is  <PolicyStatus>'),('INT.40218 ',' Change not allowed until pending premium is processed.  Change can be processed after  <EffDate>'),('INT.40219 ',' Invalid Special Group ID'),('INT.40220 ',' Policy is Not Registered under a Special Group. So cannot be added to a New Special Group. '),('INT.40221 ',' Policy Tried to Add is already Registered under the Same Special Group'),('INT.40222 ',' The pending requests exists for the policy number '),('INT.40223 ',' The unprocessed financial events exists for the policy number'),('INT.40224 ',' No undo history for the policy number'),('INT.40225 ',' Error in the creation of pending event details'),('INT.40226 ',' Error in decoding CLOB/screen  data'),('INT.40227 ',' Undo Validation shown error '),('INT.40228 ',' Error in REDO event process'),('INT.40229 ',' Screen Data Not available'),('INT.40230 ',' Undo record(s) exists with status other than \u201CUNDONE(\u2018U\u2019)\u201D or \u201CREDONE(\u2018R\u2019)\u201D  for CASE or CASE VERSION'),('INT.40231 ',' Undo record(s) exists with status other than \u201CUNDONE(\u2018U\u2019)\u201D or \u201CREDONE(\u2018R\u2019)\u201D  for CELL'),('INT.40232 ',' Undo status is not \u201CSUBMITTED(\u2018S\u2019)\u201D'),('INT.40233 ',' Invalid Undo status'),('INT.40234 ',' Already submitted for REDO and is under process.'),('INT.40235 ',' Already REDONE'),('INT.40236 ',' Internal Error not able submit REDO'),('INT.40237 ',' Frequency not changed'),('INT.40238 ',' Effective date may not be blank'),('INT.40239 ',' New Frequency may not be blank.'),('INT.40240 ',' New Frequency may not be the same as the current frequency.'),('INT.40241 ',' No Bill Schedule record available.'),('INT.40242 ',' Invalid Input Parameter'),('INT.40243 ',' Invalid Product ID for Change of Nomination.'),('INT.40244 ',' Billing method change not allowed for selected product.'),('INT.40245 ',' Policy has already maturedcannot index new service request.'),('INT.40246 ',' Death occurs after the maturity date. Process maturity claim.'),('INT.40247 ',' Sum Assured should be in multiples of 10000 for PLI products and 5000 for RPLI products'),('INT.40248 ',' Age Should not be change.Please correct Date of Birth.'),('INT.40249 ',' Remaining duration is less than the stipulated limit for the requested transaction'),('INT.40250 ',' Indexing is not allowed after maturity date'),('INT.40251 ',' FOR RPLI New Sum Assured should not be less than 10000'),('INT.40252 ',' FOR PLI New Sum Assured should not be less than 20000'),('INT.40253 ',' Suspense entry not found'),('INT.40254 ',' Suspense status is not eligible for Reversal'),('INT.40255 ',' Suspense status is not eligible for Transfer'),('INT.40256 ',' To Policy number status is not eligible for Transfer'),('INT.40257 ',' Policy Status is not eligible for Transfer'),('INT.40258 ',' Other Financial Requests are processed in the 5th to 6th year'),('INT.40259 ',' Policy not paid for 5 Years'),('INT.40260 ',' Duplicate policy bond fee should be remitted before accepting the service request'),('INT.40261 ',' Incomplete agent details in the system.'),('INT.40262 ',' Error assigning new agent'),('INT.40263 ',' Invalid agent'),('INT.40264 ',' Service Request is not Approved Cannot Collect.'),('INT.40265 ',' Date should not be greater than Maturity Date'),('INT.40266 ',' Date should not be greater than Premium Ceasing Date    '),('INT.40267 ',' Surrender for this policy is not allowed.'),('INT.40268 ',' Parent policy for Child policy not found or has invalid policy status.'),('INT.40269 ',' Policy bond not yet received by customer.'),('INT.40270 ',' Freelook cancellation period is over.'),('INT.40271 ',' Selected Policy falls under Joint life. Hence cannot be merged'),('INT.40272 ',' Selected Policy belongs to HUF. Hence cannot be merged'),('INT.40273 ',' Selected Policy falls under MWPA Act. Hence cannot be merged'),('INT.40274 ',' Policy entered does not match with the Date of Birth of Primary Customer'),('INT.40275 ',' Policy entered does not match with the PAN Number of Primary Customer'),('INT.40276 ',' Policy entered does not match with the Passport Number of Primary Customer'),('INT.40277 ',' Policy entered does not match with the Aadhar ID of Primary Customer'),('INT.40278 ',' Policy entered does not match with the Driving License of Primary Customer'),('INT.40279 ',' Selected Customer is not available for Merging with Primary Customer'),('INT.40280 ',' Insured is already dead hence refund is not allowed'),('INT.40281 ',' In Prior to premium status hence refund is not allowed'),('INT.40282 ',' Policy is in incomplete status hence refund is not allowed'),('INT.40283 ',' Surrender under process hence refund is not allowed'),('INT.40284 ',' Death claim under process hence refund is not allowed'),('INT.40285 ',' Maturity claim under process hence refund is not allowed'),('INT.40286 ',' Cannot do Refund of Premium indexing  on special group policy. Policy is not eligible for excess refund.'),('INT.40287 ',' Proposal number is approved.'),('INT.40288 ',' Proposal Number is Rejected/Withdrawn.'),('INT.40289 ',' Entered proposal number is incorrect.'),('INT.40290 ',' No Collection done on proposal number.'),('INT.40291 ',' Financial EVENT Already Exists'),('INT.40292 ',' This task cannot be processed now as the Cheque is Pending for Clearing.'),('INT.40293 ',' Please Pay Cheque dishonour Charges.'),('INT.40294 ',' Selected Policy has Premium Pending. Hence cannot be merged'),('INT.40295 ',' Please contact to System Administrator.'),('INT.40296 ',' Premium for 36 months not received. Hence surrender not allowed.'),('INT.40297 ',' Transaction cannot be processed. Financial request is pending.'),('INT.40298 ',' Selected Policy falls under Joint life. Hence cannot be merged.'),('INT.40299 ',' not allowed - Only Cash/Cheque Billing Method allowed for Professional.'),('INT.40300 ',' GST number not available.'),('INT.40301 ',' Billing frequency cannot be changed for the selected policy only monthly frequency is applicable for this product.'),('INT.40302 ',' Invalid Application Receipt Date'),('INT.40303 ',' Invalid Date Of Proposal'),('INT.40304 ',' Invalid Date of Indexing'),('INT.40305 ',' Invalid Date Of Declaration'),('INT.40306 ',' Date of Proposal greater than Application Receipt date'),('INT.40307 ',' Date of declaration greater than Application Receipt date'),('INT.40308 ',' Date of Proposal greater than Date of Declaration'),('INT.40309 ',' Application Receipt date greater than Date of Indexing'),('INT.40310 ',' Date of Proposal greater than Date of Indexing'),('INT.40311 ',' Date of declaration greater than Date of Indexing'),('INT.40312 ',' Invalid Date Of Birth'),('INT.40313 ',' Invalid Date Of Birth Of Spouse'),('PHONEFORMATERROR ',' Phone number should contains 10 digits only'),('genderError ',' Gender is required'),('firstNameError ',' First Name is required'),('relationshipError ',' Relationship is required'),('phoneNumberError ',' Phone Number must be 10 digits'),('amountReceivedError ',' Amount received is required'),('draweeError ',' Drawee Bank / PO is required'),('micrError ',' MICR code is required'),('instrumentNoError ',' Cheque Number is required'),('ifscError ',' IFSC Number is required'),('1407 ',' Surrender for this policy is not allowed. '),('1924 ',' Policy Status is not eligible for Surrender as Policy is in terminated status.'),('1651 ',' Date should not be greater than Maturity Date.'),('2185 ',' Number of the premium selected is greater than the maturity date.'),('90010 ',' User doesnt exists in system.'),('90011 ',' Office Code doesnt exist in system.'),('90008',' Transaction has already processed ! Kindly Change From Date to Proceed.'),('90009',' Transaction has already processed ! '),('90004',' Invalid Payment Type.'),('2174','Invalid transaction type'),('2175','One or more input parameter is blank'),('//00000',' Transaction Successfull'),('payment_timeout ',' Your request is submitted. Please check the status of transaction after 15 minutes.')";
    var insCount = await INS_ERROR_CODES().select().toCount();
    print("INS Error codes count: $insCount");
    if (insCount == 0) {
      final inserrormaster = await InsTran().execSQL(fininssql);
      print("INS ERROR MASTER: $inserrormaster");
    }
    final removespacesins =
        'update INS_ERROR_CODES set Error_code=Replace(Error_code, " ", "")';
    final insremovespaces = await InsTran().execSQL(removespacesins);
    print("Removal INS Error Master: $insremovespaces");
    final sql1 =
        "INSERT INTO  ARTICLEMASTER ([ARTICLETYPE], [ARTICLECODE]) VALUES ('REGISTER', 'AEROGRAMME_INTL'),('PARCEL', 'BL'),('PARCEL', 'BP'),('SPEED', 'BRSP'),('PARCEL', 'BUSINESS_PARCEL'),('EMO', 'EMO'),('PARCEL', 'EXPRESS_ONP'),('PARCEL', 'EXPRESS_PARCEL'),('PARCEL', 'FGN_AIR_PARCEL'),('REGISTER', 'FGN_BL'),('PARCEL', 'FGN_BULKBAG'), ('REGISTER', 'FGN_LETTER'),('REGISTER', 'FGN_PRINTEDPAPERS'),('PARCEL', 'FGN_SAL_PARCEL'),('REGISTER', 'FGN_SMALLPACKETS'),('SPEED', 'FGN_SP_DOCUMENT'),('SPEED', 'FGN_SP_MERCHANDISE'),('PARCEL', 'FLATRATEBOX_INTL_S'),('PARCEL', 'FRPARCEL_INTL_L'),('PARCEL', 'FRPARCEL_INTL_M'),('PARCEL', 'FRPARCEL_INTL_S'),('EMO', 'INTL_MO_IN'),('REGISTER', 'LETTER'),('REGISTER', 'LETTER_CARD_S'),('PARCEL', 'P_SP'),('PARCEL', 'PARCEL'),('REGISTER', 'PB'),('PARCEL', 'PERIODICAL'),('EMO', 'SMO'),('SPEED', 'SP_INLAND'),('EMO', 'EMON');";
    var count1 = await ARTICLEMASTER().select().toCount();
    if (count1 == 0) final result1 = await DeliveryModel().execSQL(sql1);
    // final sql2="INSERT INTO Delivery (articleNumber,invoiceDate,invoiced,bagID,dateofDelivery,reasonType,artStatus,artReceiveDate, TransactionDate,emomessage,matnr,totalMoney,moneytobecollected,postDue,demCharge,commission,bookID,cod,vpp) VALUES  ('RK969339380IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,120,0,0,6,'4',null,'X'),('RK969339265IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,0,0,0,0,'4',null,null),('RK969339504IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,500,0,0,25,'4',null,'X'),('RK969337830IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,0,0,0,0,'4',null,null),('RK969338146IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,219,0,0,11,'4',null,'X'),('RK969338132IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,50,0,0,3,'4',null,'X'),('RK969338129IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,750,0,0,38,'4',null,'X'),('CK628484296IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,1499,0,0,0,'5','X',null),('CK628484512IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,600,0,0,30,'5',null,'X'),('CK627123129IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('CK628484279IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('CK628484375IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,499,0,0,0,'5','X',null),('CK628484490IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,1200,0,0,60,'5',null,'X'),('CK628484398IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('EK954375669IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954377792IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,299,0,0,0,'6','X',null),('EK954375964IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,5,0,0,'6',null,null),('EK954375774IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954375686IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,10,0,0,'6',null,null),('EK954375690IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954377789IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,2,0,0,'6',null,null);";

    final sql2 =
        "INSERT INTO Delivery (ART_NUMBER,invoiceDate,invoiced,BAG_ID,DATE_OF_DELIVERY,REASON_TYPE,ART_STATUS,ART_RECEIVE_DATE, TRANSACTION_DATE,EMO_MESSAGE,MATNR,TOTAL_MONEY,MONEY_TO_BE_COLLECTED,POST_DUE,DEM_CHARGE,COMMISSION,BOOK_ID,COD,VPP) VALUES  ('RK969339380IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,120,0,0,6,'4',null,'X'),('RK969339265IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,0,0,0,0,'4',null,null),('RK969339504IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,500,0,0,25,'4',null,'X'),('RK969337830IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,0,0,0,0,'4',null,null),('RK969338146IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,219,0,0,11,'4',null,'X'),('RK969338132IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,50,0,0,3,'4',null,'X'),('RK969338129IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'LETTER',0,750,0,0,38,'4',null,'X'),('CK628484296IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,1499,0,0,0,'5','X',null),('CK628484512IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,600,0,0,30,'5',null,'X'),('CK627123129IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('CK628484279IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('CK628484375IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,499,0,0,0,'5','X',null),('CK628484490IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,1200,0,0,60,'5',null,'X'),('CK628484398IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'PARCEL',0,0,0,0,0,'5',null,null),('EK954375669IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954377792IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,299,0,0,0,'6','X',null),('EK954375964IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,5,0,0,'6',null,null),('EK954375774IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954375686IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,10,0,0,'6',null,null),('EK954375690IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,0,0,0,'6',null,null),('EK954377789IN','${DateTimeDetails().onlyDate()}','Y','RBK3004710751',null,null,null,null,null,null,'SP_INLAND',0,0,2,0,0,'6',null,null);";
    var count2 = await Delivery().select().toCount();
    // final sql5="INSERT INTO Delivery (articleNumber,invoiced,invoiceDate,bagID,dateofDelivery,reasonType,artStatus,artReceiveDate, TransactionDate,emomessage,matnr,totalMoney,moneytobecollected,postDue,demCharge,commission,bookID,cod,vpp) VALUES ('744363011474967377','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Happy Diwali','EMON',1200,0,0,0,0,'3',null,null),('744363011474967383','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'New Mobile','INTL_MO_IN',500,0,0,0,0,'3',null,null),('744363011474967396','Y','${DateTimeDetails().onlyDate()}','N',NULL,null,NULL,NULL,null,'November Trip','SMO',900,0,0,0,0,'3',null,null),('744363011474967405','Y','${DateTimeDetails().onlyDate()}','N',NULL,NULL,null,NULL,null,'Diwali Shopping','EMON',2000,0,0,0,0,'3',null,null),('744363011474967419','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Exam Fees','EMON',1600,0,0,0,0,'3',null,null),('744363011474967423','Y','${DateTimeDetails().onlyDate()}','N',NULL,null,NULL,NULL,null,'Tuition Fees','SMO',3000,0,0,0,0,'3',null,null),('744363011474967433','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Happy BirthDay 2 U','EMON',2500,0,0,0,0,'3',null,null);";
    // final sql5="INSERT INTO Delivery (ART_NUMBER,invoiced,invoiceDate,BAG_ID,DATE_OF_DELIVERY,REASON_TYPE,ART_STATUS,ART_RECEIVE_DATE, TRANSACTION_DATE,EMO_MESSAGE,MATNR,TOTAL_MONEY,MONEY_TO_BE_COLLECTED,POST_DUE,DEM_CHARGE,COMMISSION,BOOK_ID,COD,VPP) VALUES ('744363011474967377','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Happy Diwali','EMON',1200,0,0,0,0,'3',null,null),('744363011474967383','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'New Mobile','INTL_MO_IN',500,0,0,0,0,'3',null,null),('744363011474967396','Y','${DateTimeDetails().onlyDate()}','N',NULL,null,NULL,NULL,null,'November Trip','SMO',900,0,0,0,0,'3',null,null),('744363011474967405','Y','${DateTimeDetails().onlyDate()}','N',NULL,NULL,null,NULL,null,'Diwali Shopping','EMON',2000,0,0,0,0,'3',null,null),('744363011474967419','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Exam Fees','EMON',1600,0,0,0,0,'3',null,null),('744363011474967423','Y','${DateTimeDetails().onlyDate()}','N',NULL,null,NULL,NULL,null,'Tuition Fees','SMO',3000,0,0,0,0,'3',null,null),('744363011474967433','Y','${DateTimeDetails().onlyDate()}','N',null,NULL,NULL,NULL,null,'Happy BirthDay 2 U','EMON',2500,0,0,0,0,'3',null,null);";
    final sql5 =
        "INSERT INTO Delivery (ART_NUMBER,BAG_ID,DATE_OF_DELIVERY,REASON_TYPE,ART_STATUS,ART_RECEIVE_DATE, TRANSACTION_DATE,EMO_MESSAGE,MATNR,TOTAL_MONEY,MONEY_TO_BE_COLLECTED,POST_DUE,DEM_CHARGE,COMMISSION,BOOK_ID,COD,VPP) VALUES ('744363011474967377','N',null,NULL,NULL,NULL,null,'Happy Diwali','EMON',1200,0,0,0,0,'3',null,null),('744363011474967383','N',null,NULL,NULL,NULL,null,'New Mobile','INTL_MO_IN',500,0,0,0,0,'3',null,null),('744363011474967396','N',NULL,null,NULL,NULL,null,'November Trip','SMO',900,0,0,0,0,'3',null,null),('744363011474967405','N',NULL,NULL,null,NULL,null,'Diwali Shopping','EMON',2000,0,0,0,0,'3',null,null),('744363011474967419','N',null,NULL,NULL,NULL,null,'Exam Fees','EMON',1600,0,0,0,0,'3',null,null),('744363011474967423','N',NULL,null,NULL,NULL,null,'Tuition Fees','SMO',3000,0,0,0,0,'3',null,null),('744363011474967433','N',null,NULL,NULL,NULL,null,'Happy BirthDay 2 U','EMON',2500,0,0,0,0,'3',null,null);";

    print("Articles Count: $count2");
    // final sql4="INSERT INTO Delivery (articleNumber,invoiceDate,bagID,dateofDelivery,reasonType,artStatus,artReceiveDate, TransactionDate,emomessage,matnr,totalMoney,moneytobecollected,postDue,demCharge,commission,bookID,cod,vpp,reasonNonDelivery) VALUES  ('RK961239265IN','10-02-2022','RBK3004710751',null,null,'N',null,null,null,'LETTER',0,0,0,0,0,'4',null,null,35),('RK492536265IN','05-02-2022','RBK3004710751',null,null,'N',null,null,null,'LETTER',0,0,0,0,0,'4',null,null,36),('EK492216265IN','01-02-2022','RBK3004710751',null,null,'N',null,null,null,'SP_INLAND',0,0,0,0,0,'4',null,null,1)";
    final sql4 =
        "INSERT INTO Delivery (ART_NUMBER,invoiceDate,BAG_ID,DATE_OF_DELIVERY,REASON_TYPE,ART_STATUS,ART_RECEIVE_DATE, TRANSACTION_DATE,EMO_MESSAGE,MATNR,TOTAL_MONEY,MONEY_TO_BE_COLLECTED,POST_DUE,DEM_CHARGE,COMMISSION,BOOK_ID,COD,VPP,REASON_FOR_NONDELIVERY) VALUES  ('RK961239265IN','2022-02-10','RBK3004710751',null,null,'N',null,null,null,'LETTER',0,0,0,0,0,'4',null,null,35),('RK492536265IN','2022-02-05','RBK3004710751',null,null,'N',null,null,null,'LETTER',0,0,0,0,0,'4',null,null,36),('EK492216265IN','2022-02-01','RBK3004710751',null,null,'N',null,null,null,'SP_INLAND',0,0,0,0,0,'4',null,null,1)";

    /*if (count2 == 0) {
      final result2 = await DeliveryModel().execSQL(sql2);
      final result4 = await DeliveryModel().execSQL(sql4);
      final result5 = await DeliveryModel().execSQL(sql5);
      print(result2);
      print(result4);
      print(result5);
    }*/

    final sql3 =
        "INSERT INTO Address (SEND_CUST_N, SEND_ADD1, SEND_ADD2, SEND_ADD3, SEND_STREET, SEND_CITY, SEND_COUNTRY, SEND_STATE, SEND_EMAIL, SEND_PIN, SEND_FAX, SEND_MOB, REC_NAME, REC_ADDRESS1, REC_ADDRESS2, REC_ADDRESS3, REC_COUNTRY, REC_STATE, REC_STREET, REC_CITY, REC_PIN, MOD_PIN, REC_MOB, REC_EMAIL, REC_FAX, RECIPIENT_NAME, REDIRECT_REC_ADD1, REDIRECT_REC_ADD2,REDIRECT_REC_ADD3, REDIRECT_REC_STREET, REDIRECT_REC_CITY, REDIRECT_REC_COUNTRY, REDIRECT_REC_STATE, REDIRECT_REC_PIN, REDIRECT_REC_MOB, REDIRECT_REC_EMAIL, REDIRECT_REC_FAX, REDIRECT_FROM_PIN, REDIRECT_FROM_BO_ID, ART_NUMBER, BOOK_ID) VALUES ('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK961239265IN', '3'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK492536265IN', '3'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK492216265IN', '3'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967377', '3'),('Nagendra', '222,2nd FLOOR', 'Siddhartha Nagar', 'T N Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Dheeraj', 'Door No.201', 'Hebbal Cross', 'Electronic City', 'INDIA', 'Karnataka', 'Huskur Gate', 'Bangalore', 560039 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967383', '3'),('Raveesh', 'Ground Floor Type 1', 'PTC Quarters', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Shivani', 'House No.69', 'M G Road', 'Bankers Colony', 'INDIA', 'Uttar Pradesh', NULL, 'Meerut', 110179 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967396', '3'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Susamarani', 'Isanendi', 'Dharampur', 'Raj Berhampur', 'INDIA', 'Odisha', NULL, 'Balasore', 756058 , NULL, 9938694169 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967405', '3'),('Nibin', '2nd Floor', 'CEPT Main Building', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Yasna', 'Type1 Quarter PTC', 'NAZARBAD', 'Ittigegud', 'INDIA', 'Karnataka', NULL, 'Mysore', 570010 , NULL, 9995557818 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967419', '3'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Aditya Narayan', 'San Bisol', 'Bisol', 'Kaptipada', 'INDIA', 'Odisha', NULL, 'Mayurbhanj', 757040 , NULL, 9438791888 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967423', '3'),('K Balasubramanyam', 'GM CEPT', 'GM Quarter', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'B V Sudhakar', 'Secretary DoP', 'Dak Bhawan', 'Parliament Road', 'INDIA', 'Delhi', NULL, 'New Delhi', 110010 , NULL, 7978029920 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '744363011474967433', '3'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969339380IN', '4'),('Nagendra', '222,2nd FLOOR', 'Siddhartha Nagar', 'T N Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Dheeraj', 'Door No.201', 'Hebbal Cross', 'Electronic City', 'INDIA', 'Karnataka', 'Huskur Gate', 'Bangalore', 560039 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969339265IN', '4'),('Raveesh', 'Ground Floor Type 1', 'PTC Quarters', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Shivani', 'House No.69', 'M G Road', 'Bankers Colony', 'INDIA', 'Uttar Pradesh', NULL, 'Meerut', 110179 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969339504IN', '4'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Susamarani', 'Isanendi', 'Dharampur', 'Raj Berhampur', 'INDIA', 'Odisha', NULL, 'Balasore', 756058 , NULL, 9938694169 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969337830IN', '4'),('Nibin', '2nd Floor', 'CEPT Main Building', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Yasna', 'Type1 Quarter PTC', 'NAZARBAD', 'Ittigegud', 'INDIA', 'Karnataka', NULL, 'Mysore', 570010 , NULL, 9995557818 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969338146IN', '4'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Aditya Narayan', 'San Bisol', 'Bisol', 'Kaptipada', 'INDIA', 'Odisha', NULL, 'Mayurbhanj', 757040 , NULL, 9438791888 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969338132IN', '4'),('K Balasubramanyam', 'GM CEPT', 'GM Quarter', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'B V Sudhakar', 'Secretary DoP', 'Dak Bhawan', 'Parliament Road', 'INDIA', 'Delhi', NULL, 'New Delhi', 110010 , NULL, 7978029920 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RK969338129IN', '4'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484296IN', '5'),('Nagendra', '222,2nd FLOOR', 'Siddhartha Nagar', 'T N Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Dheeraj', 'Door No.201', 'Hebbal Cross', 'Electronic City', 'INDIA', 'Karnataka', 'Huskur Gate', 'Bangalore', 560039 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484512IN', '5'),('Raveesh', 'Ground Floor Type 1', 'PTC Quarters', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Shivani', 'House No.69', 'M G Road', 'Bankers Colony', 'INDIA', 'Uttar Pradesh', NULL, 'Meerut', 110179 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK627123129IN', '5'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Susamarani', 'Isanendi', 'Dharampur', 'Raj Berhampur', 'INDIA', 'Odisha', NULL, 'Balasore', 756058 , NULL, 9938694169 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484279IN', '5'),('Nibin', '2nd Floor', 'CEPT Main Building', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Yasna', 'Type1 Quarter PTC', 'NAZARBAD', 'Ittigegud', 'INDIA', 'Karnataka', NULL, 'Mysore', 570010 , NULL, 9995557818 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484375IN', '5'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Aditya Narayan', 'San Bisol', 'Bisol', 'Kaptipada', 'INDIA', 'Odisha', NULL, 'Mayurbhanj', 757040 , NULL, 9438791888 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484490IN', '5'),('K Balasubramanyam', 'GM CEPT', 'GM Quarter', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'B V Sudhakar', 'Secretary DoP', 'Dak Bhawan', 'Parliament Road', 'INDIA', 'Delhi', NULL, 'New Delhi', 110010 , NULL, 7978029920 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CK628484398IN', '5'),('RAGHURAM', '231,Ist FLOOR', 'NR.NIMBUJA DEVI TEMPLE', 'NAZARBAD 2ND CROSS', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'SANTHOSH', 'PLOTNO.231', 'GREEN HILLS COLONY', 'DILSUKHNAGAR', 'INDIA', 'TELANGANA', 'HOSPITAL STREET', 'HYDERABAD', 500030 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954375669IN', '6'),('Nagendra', '222,2nd FLOOR', 'Siddhartha Nagar', 'T N Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Dheeraj', 'Door No.201', 'Hebbal Cross', 'Electronic City', 'INDIA', 'Karnataka', 'Huskur Gate', 'Bangalore', 560039 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954377792IN', '6'),('Raveesh', 'Ground Floor Type 1', 'PTC Quarters', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Shivani', 'House No.69', 'M G Road', 'Bankers Colony', 'INDIA', 'Uttar Pradesh', NULL, 'Meerut', 110179 , NULL, 8550898231 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954375964IN', '6'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Susamarani', 'Isanendi', 'Dharampur', 'Raj Berhampur', 'INDIA', 'Odisha', NULL, 'Balasore', 756058 , NULL, 9938694169 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954375774IN', '6'),('Nibin', '2nd Floor', 'CEPT Main Building', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Yasna', 'Type1 Quarter PTC', 'NAZARBAD', 'Ittigegud', 'INDIA', 'Karnataka', NULL, 'Mysore', 570010 , NULL, 9995557818 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954375686IN', '6'),('Debashis', '3rd Floor', 'Plot No.739/2', 'Band Bunglow Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'Aditya Narayan', 'San Bisol', 'Bisol', 'Kaptipada', 'INDIA', 'Odisha', NULL, 'Mayurbhanj', 757040 , NULL, 9438791888 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954375690IN', '6'),('K Balasubramanyam', 'GM CEPT', 'GM Quarter', 'PTC Campus Road', 'NAZARBAD', 'MYSORE', 'INDIA', 'KARNATAKA', NULL, NULL, NULL, NULL, 'B V Sudhakar', 'Secretary DoP', 'Dak Bhawan', 'Parliament Road', 'INDIA', 'Delhi', NULL, 'New Delhi', 110010 , NULL, 7978029920 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'EK954377789IN', '6');";
    var count3 = await Addres().select().toCount();
    // if (count3 == 0)
    // final result3 = await DeliveryModel().execSQL(sql3);
    final artmastersql =
        "INSERT INTO  ARTICLEMASTER ([ARTICLETYPE], [ARTICLECODE]) VALUES ('REGISTER', 'AEROGRAMME_INTL'),('PARCEL', 'BL'),('PARCEL', 'BP'),('SPEED', 'BRSP'),('PARCEL', 'BUSINESS_PARCEL'),('EMO', 'EMO'),('PARCEL', 'EXPRESS_ONP'),('PARCEL', 'EXPRESS_PARCEL'),('PARCEL', 'FGN_AIR_PARCEL'),('REGISTER', 'FGN_BL'),('PARCEL', 'FGN_BULKBAG'), ('REGISTER', 'FGN_LETTER'),('REGISTER', 'FGN_PRINTEDPAPERS'),('PARCEL', 'FGN_SAL_PARCEL'),('REGISTER', 'FGN_SMALLPACKETS'),('SPEED', 'FGN_SP_DOCUMENT'),('SPEED', 'FGN_SP_MERCHANDISE'),('PARCEL', 'FLATRATEBOX_INTL_S'),('PARCEL', 'FRPARCEL_INTL_L'),('PARCEL', 'FRPARCEL_INTL_M'),('PARCEL', 'FRPARCEL_INTL_S'),('EMO', 'INTL_MO_IN'),('REGISTER', 'LETTER'),('REGISTER', 'LETTER_CARD_S'),('PARCEL', 'P_SP'),('PARCEL', 'PARCEL'),('REGISTER', 'PB'),('PARCEL', 'PERIODICAL'),('EMO', 'SMO'),('SPEED', 'SP_INLAND'),('EMO', 'EMON');";
    final artmaster = await DeliveryModel().execSQL(artmastersql);
    // var walletAmount = await CashService().cashBalance();
    // if (walletAmount == 0){
    //   final addCash =  CashTable()
    //     ..Cash_ID = "CASH FROM AO"
    //     ..Cash_Date = DateTimeDetails().currentDate()
    //     ..Cash_Time = DateTimeDetails().onlyTime()
    //     ..Cash_Type = 'Add'
    //     ..Cash_Amount = 2100.0
    //     ..Cash_Description = "Cash From AO";
    //   await addCash.save();
    // }
  }

  recordDayOpenDetails() async {
    final day = await DayModel().select().toMapList();
    if (day.isEmpty) {}

    final dayBalance = await DayModel()
        .select()
        .DayBeginDate
        .equals(DateTimeDetails().currentDate())
        .toMapList();
    var balance = await CashService().cashBalance();
    String walletBalance = balance.toString();
    if (dayBalance.isEmpty) {
      /// Recording Day Opening balance
      final dayEntry = DayModel()
        ..DayBeginDate = DateTimeDetails().currentDate()
        ..DayBeginTime = DateFormat('hh:mm:ss').format(DateTime.now())
        ..CashOpeningBalance = walletBalance;
      dayEntry.save();
      final dayBegin = DayBegin()
        ..BPMId = 'BO11304216001'
        ..DayBeginTimeStamp1 = DateTimeDetails().currentDateTime()
        ..DayBeginTimeStamp2 = DateTimeDetails().currentDateTime()
        ..FileCreated = 'N'
        ..FileTransmitted = 'N';
      dayBegin.save();

      ///Recording Inventory
      final inventoryAvailable = await ProductsTable().select().toMapList();
      if (inventoryAvailable.isNotEmpty) {
        for (int i = 0; i < inventoryAvailable.length; i++) {
          final addDailyInventory = InventoryDailyTable()
            ..InventoryId = inventoryAvailable[i]['ProductID']
            ..StampName = inventoryAvailable[i]['Name']
            ..Price = inventoryAvailable[i]['Price']
            ..RecordedDate = DateTimeDetails().currentDate()
            ..OpeningQuantity = inventoryAvailable[i]['Quantity']
            ..OpeningValue = inventoryAvailable[i]['Value'];
          addDailyInventory.save();
        }
      }
    }

    final previousDayDetails = await DayModel()
        .select()
        .DayBeginDate
        .equals(DateTimeDetails().previousDate())
        .toMapList();
    if (previousDayDetails[0]['DayCloseDate'].isEmpty) {
      await DayModel()
          .select()
          .DayBeginDate
          .equals(DateTimeDetails().previousDate())
          .update({
        "CashClosingBalance": previousDayDetails[0]['CashOpeningBalance'],
        "DayCloseDate": previousDayDetails[0]['DayBeginDate'],
        "DayCloseTime": "23:59:59"
      });
    }
  }

  Widget? _child = MailsMainScreen();

  Future<bool>? _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit App?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () async {
                  //await cron.close();
                  // await LogCat().writeContent("${DateTimeDetails().currentDateTime()}:Scheduler closed\n\n");
                  //exit(0);
                  SystemNavigator.pop();
                },
                /*Navigator.of(context).pop(true)*/
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        // appBar: AppAppBar( title:"Darpan"),
        // drawer: Drawer(),
        body: widget._child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                svgPath: "assets/images/bank.svg",
                // iconPath: "assets/images/mails.png",
                // backgroundColor: Color(0xFF4285F4),
                backgroundColor: Color(0xFFFCBA02),
                selectedForegroundColor: Colors.blue,
                extras: {"label": "utilities"}),
            FluidNavBarIcon(
                svgPath: "assets/images/mails.svg",
                // iconPath: "assets/images/mails.png",
                // backgroundColor: Color(0xFF4285F4),
                backgroundColor: Color(0xFFFCBA02),
                selectedForegroundColor: Colors.blue,
                extras: {"label": "home"}),
            FluidNavBarIcon(
                svgPath: "assets/images/bank.svg",
                // iconPath:"assets/images/bank.png",
                backgroundColor: Color(0xFFFCBA02),
                selectedForegroundColor: Colors.blue,
                extras: {"label": "bookmark"}),
            FluidNavBarIcon(
                svgPath: "assets/images/insurance.svg",
                // iconPath: "assets/images/insurance.png",
                backgroundColor: Color(0xFFFCBA02),
                selectedForegroundColor: Colors.blue,
                extras: {"label": "partner"}),
          ],
          onChange: _handleNavigationChange,
          style: FluidNavBarStyle(
              iconUnselectedForegroundColor: Colors.red,
              barBackgroundColor: Color(0xFFB71C1C)),
          scaleFactor: 1.5,
          defaultIndex: widget.index!,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras!["label"],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {

        case 0:
          widget._child = UtilitiesMainScreen();
          break;
        case 1:
          widget._child = MailsMainScreen();
          break;
        case 2:
          widget._child = MyCardsScreen(true);
          break;
        case 3:
          widget._child = UserPage(true);
          break;
      }
      widget._child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: widget._child,
      );
    });
  }
}
