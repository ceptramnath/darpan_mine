import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/LogCat.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:dio/dio.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:newenc/newenc.dart';

import '../AlertDialogChecker.dart';
import '../main.dart';
import 'Booking/BookingDBModel/BookingDBModel.dart';

class DataSync {
  var frm1 = "%d/%m/%Y %H:%M";
  var frm2 = "%d/%m/%Y";
  var frm3 = "%Y%m%d";
  List subRes = [];

  addFileToDB(String fileName, String filePath, String serviceText,
      String updatedAt) async {
    final addFileToDB = FileSyncDetail()
      ..FileName = fileName
      ..FilePath = filePath
      ..ServiceText = serviceText
      ..Status = 'Added To DB'
      ..UpdatedAt = updatedAt
      ..Processed = 'Y';
    addFileToDB.upsert();
  }
  bool JwtCheck(List<USERLOGINDETAILS> loginDetails) {
    print('JWT Checking..!');
    bool rtValue = false;
    String accessToken = loginDetails[0].AccessToken.toString();
    // print(accessToken.isNotEmpty.toString());

    if (accessToken != "null") {
      bool hasExpired = JwtDecoder.isExpired(accessToken);

      if (!hasExpired) {
        rtValue = true;
      } else
        rtValue = false;
    }
    print(accessToken);
    print(rtValue.toString());
    return rtValue;
  }
  Future<void> download() async {
    List<USERLOGINDETAILS> acctoken =
        await USERLOGINDETAILS().select().toList();
    ByteData secdata;
    //String officeId='BO20105103005';
    final ofcMaster = await OFCMASTERDATA().select().toList();
    print("Inside download Before Try");
    //Rakesh Checking whether there is a row in the Master data
    if (ofcMaster.length > 0) {
      var officeId = ofcMaster[0].BOFacilityID.toString();
      //var officeId='1234';
      // var officeId =
      //     // 'BO52104101001'; //'BO20105103005';//'BO20105103005';
      // 'BO21308110002';
      // 'BO20105103005';
      print("Office ID is: " + officeId);
      secdata =
      await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
      print("Security Context");
      print(SecurityContext.defaultContext.toString());
      // if(SecurityContext.defaultContext.toString()!=null) {
      try {
        SecurityContext.defaultContext
            .setTrustedCertificatesBytes(secdata.buffer.asUint8List());
      } catch (Error) {
        SecurityContext.defaultContext
            .useCertificateChainBytes(secdata.buffer.asUint8List());
      }

      // }
      print("Entered Download API function");

      var dio = Dio();
      bool rtValue = JwtCheck(acctoken);
      if (!rtValue) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (BuildContext dialogContext) {
            return WillPopScope(
              onWillPop: () async => false,
              child: MyAlertDialog(
                title: 'Title',
                content: 'Dialog content',
              ),
            );
          },
        );
      }

      //Try for Delivery
      else {
        try {
          await LogCat().writeContent(
              "${DateTimeDetails().currentDateTime()}: Delivery File Download");
          Response response = await dio.get(
            // "https://gateway.cept.gov.in/signewtest/download?filename=$officeId&type=DELAPPS",
            "https://gateway.cept.gov.in/signewlive/download?filename=$officeId&type=DELAPPS",
            options: Options(
                responseType: ResponseType.bytes,
                headers: {
                  'filename': '$officeId',
                  'Authorization': 'Bearer ${acctoken[0].AccessToken}',
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }),
          );
          print(response.statusCode);

          if (response.statusCode == 200) {
            // File file = await File("storage/emulated/0/Darpan_Mine/DownloadCSV/DEL-$officeId.zip");
            File file =
            await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
            var raf = await file.openSync(mode: FileMode.write);

            raf.writeFromSync(response.data);
            await raf.close();
            print("Before unZipping");

            // Added by Rakesh 30082022 for ACk
            var resheaders = response.headers;
            print(resheaders['Sign']);
            print(resheaders['Sign']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .trim());
            String filesign = resheaders['Sign']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .trim();
            print("FileSign");
            print(filesign);
            // String? value = await Newenc.verifyfiles(
            //     filesign, "storage/emulated/0/Darpan_Mine/DownloadCSV/DEL-$officeId.zip");
            String? value = await Newenc.verifyfiles(
                filesign,
                "storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");

            print("Response received back in signature verification: $value");
            if (value == "Verified") {
              await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip")
                  .rename(
                  "storage/emulated/0/Darpan_Mine/DownloadCSV/DEL-$officeId.zip");
              final zipFile = await File(
                  "storage/emulated/0/Darpan_Mine/DownloadCSV/Del-$officeId.zip");
              final destinationDir =
              await Directory("storage/emulated/0/Darpan_Mine/DownloadCSV/");
              try {
                await ZipFile.extractToDirectory(
                    zipFile: zipFile, destinationDir: destinationDir);
                // await zipFile.delete();
              } catch (e) {
                print(e);
              }
            } else {
              // UtilFs.showToast("Signature Verification Failed! Try Again",context);
              await LogCat().writeContent(
                  '${DateTimeDetails()
                      .currentDateTime()} :BackGround operations File Downloading Delivery: Signature Verification Failed.\n\n');
            }
            //Delete the files from the extracted folder
            // await Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId').delete(recursive: true);
            //await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip").delete(recursive: true);
          }
          else if (response.statusCode == 401) {
            showDialog(
              barrierDismissible: false,
              context: navigatorKey.currentContext!,
              builder: (BuildContext dialogContext) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: MyAlertDialog(
                    title: 'Title',
                    content: 'Dialog content',
                  ),
                );
              },
            );
          }

          else {
            // String res=response.data;
            await LogCat().writeContent(
                "${DateTimeDetails()
                    .currentDateTime()}: No Delivery File to Download");
            // await LogCat().writeContent("${DateTimeDetails().currentDateTime()}: Error in File acknowledgement: $officeId: ${response.data} ");

          }
        } on DioError catch (error) {
          print("Error Response");
          print(error);
        }
      }

      bool rtValue1 = JwtCheck(acctoken);
      if (!rtValue1) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (BuildContext dialogContext) {
            return WillPopScope(
              onWillPop: () async => false,
              child: MyAlertDialog(
                title: 'Title',
                content: 'Dialog content',
              ),
            );
          },
        );
      }

      //Try for Booking
      else {
        try {
          Response response = await dio.get(
            //"https://gateway.cept.gov.in/signewtest/download?filename=$officeId&type=DEMOBOOKING",
            "https://gateway.cept.gov.in/signewlive/download?filename=$officeId&type=DEMOBOOKING",
            options: Options(
                responseType: ResponseType.bytes,
                headers: {
                  'filename': '$officeId',
                  'Authorization': 'Bearer ${acctoken[0].AccessToken}',
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! < 500;
                }),
          );
          print(response.statusCode);

          if (response.statusCode == 200) {
            // File file = await File("storage/emulated/0/Darpan_Mine/DownloadCSV/BOOK-$officeId.zip");
            File file =
            await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");

            var raf = await file.openSync(mode: FileMode.write);

            raf.writeFromSync(response.data);
            await raf.close();
            print("Before unZipping");

            // Added by Rakesh 30082022 for ACk
            var resheaders = response.headers;
            print(resheaders['Sign']);
            print(resheaders['Sign']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .trim());
            String filesign = resheaders['Sign']
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .trim();
            print("FileSign");
            print(filesign);
            // String? value = await Newenc.verifyfiles(
            //     filesign, "storage/emulated/0/Darpan_Mine/DownloadCSV/BOOK-$officeId.zip");
            String? value = await Newenc.verifyfiles(
                filesign,
                "storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");

            print("Response received back in signature verification: $value");
            if (value == "Verified") {
              await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip")
                  .rename(
                  "storage/emulated/0/Darpan_Mine/DownloadCSV/BOOK-$officeId.zip");

              final zipFile = await File(
                  "storage/emulated/0/Darpan_Mine/DownloadCSV/BOOK-$officeId.zip");
              final destinationDir =
              await Directory("storage/emulated/0/Darpan_Mine/DownloadCSV/");

              try {
                await ZipFile.extractToDirectory(
                    zipFile: zipFile, destinationDir: destinationDir);
                // await zipFile.delete();
              } catch (e) {
                print(e);
              }
            } else {
              // UtilFs.showToast("Signature Verification Failed! Try Again",context);
              await LogCat().writeContent(
                  '${DateTimeDetails()
                      .currentDateTime()} :BackGround operations File Downloading Booking: Signature Verification Failed.\n\n');
            }
            //Delete the files from the extracted folder
            // await Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId').delete(recursive: true);
            //await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip").delete(recursive: true);
          }
          else if (response.statusCode == 401) {
            showDialog(
              barrierDismissible: false,
              context: navigatorKey.currentContext!,
              builder: (BuildContext dialogContext) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: MyAlertDialog(
                    title: 'Title',
                    content: 'Dialog content',
                  ),
                );
              },
            );
          }
          else {
            // String res=response.data;
            await LogCat().writeContent(
                "${DateTimeDetails()
                    .currentDateTime()}: Error in File acknowledgement: $officeId: ${response
                    .data} ");
          }
        } on DioError catch (error) {
          print("Error Response");
          print(error);
        }
      }

      bool rtValue2 = JwtCheck(acctoken);
      if (!rtValue2) {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (BuildContext dialogContext) {
            return WillPopScope(
              onWillPop: () async => false,
              child: MyAlertDialog(
                title: 'Title',
                content: 'Dialog content',
              ),
            );
          },
        );
      }

    else{
      try {
        await LogCat().writeContent(
            "File Acknowledgement Process Started \n\n");
        final dir = Directory(
            'storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId');
        print('File Acknowledgement Process Started');
        print(dir.toString());
        print("Before file processing");
        final List<FileSystemEntity> entities = await dir.list().toList();
        print(entities.length);
        print(entities);

        for (int i = 0; i < entities.length; i++) {
          // print("lkajslf"+entities[i].toString());
          String fileName = entities[i].toString().substring(
              entities[i]
                  .toString()
                  .length - 8,
              entities[i]
                  .toString()
                  .length - 5);
          // if(entities[i].toString().endsWith("950"))
          // print("fileName: $fileName");

          if (fileName == "950") {
            print("Inside 950 file name");
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();

            // print(fields.length);
            // print(fields[0]);
            // print(fields[1]);
            // print(fields[2]);
            // List resm=[];
            // // print(fields[0][0]);
            // // print(fields[0][1]);
            // // print(fields[0][0].split("\n"));
            // // print(fields[0][0].split("\n").length);
            // for(int i=0;i<fields.length;i++){
            // resm.add(fields[i]);
            //
            // }
            // print("Resm length: "+resm.length.toString());
            // List res=fields[0][0].split("‡");
            // print("Res is: "+res[0]);
            // print("Resm is: "+resm[0].toString());
            // print("Resm is: "+resm[1].toString());
            // print("Resm is: "+resm[2].toString());

            try {
              for (int i = 0; i < fields.length; i++) {
                print("Entered Loop");
                //text = textList.toString().replace("[", "").replace("]", "");
                List finalresult = fields[i]
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "")
                    .trim()
                    .split("‡");
                // List finalresult=fields[0][0].split("‡");
                print(finalresult);
                await Delivery(
                    BO_SLIP: finalresult[0],
                    SOFFICE_ID: finalresult[1],
                    DOFFICE_ID: finalresult[2],
                    BOOK_DATE: finalresult[3],
                    ART_NUMBER: finalresult[4],
                    BOOK_ID: finalresult[5],
                    LINE_ITEM: double.parse(finalresult[6]),
                    MATNR: finalresult[7],
                    BAG_ID: finalresult[8],
                    INSURANCE: finalresult[9],
                    TOTAL_MONEY: double.parse(finalresult[10]),
                    POST_DUE: double.parse(finalresult[11]),
                    DEM_CHARGE: double.parse(finalresult[12]),
                    COMMISSION: double.parse(finalresult[13]),
                    SOURCE_PINCODE: int.parse(finalresult[14]),
                    DESTN_PINCODE: int.parse(finalresult[15]),
                    BO_ID: finalresult[16],
                    REGISTERED: finalresult[17],
                    RETURN_SERVICE: finalresult[18],
                    COD: finalresult[19],
                    VPP: finalresult[20],
                    MONEY_TO_BE_COLLECTED: double.parse(finalresult[22]),
                    REDIRECTION_FEE: double.parse(finalresult[50]),
                    CUST_DUTY: double.parse(finalresult[51]),
                    REPORTING_SO_ID: finalresult[52])
                    .upsert1();
                await Addres(
                  BO_SLIP: finalresult[0],
                  ART_NUMBER: finalresult[4],
                  BOOK_ID: finalresult[5],
                  BAG_ID: finalresult[8],
                  SEND_CUST_N: finalresult[23],
                  SEND_ADD1: finalresult[24],
                  SEND_ADD2: finalresult[25],
                  SEND_ADD3: finalresult[26],
                  SEND_STREET: finalresult[27],
                  SEND_CITY: finalresult[28],
                  SEND_COUNTRY: finalresult[29],
                  SEND_STATE: finalresult[30],
                  SEND_EMAIL: finalresult[31],
                  SEND_PIN: int.parse(finalresult[32]),
                  SEND_FAX: finalresult[33],
                  SEND_MOB: finalresult[34],
                  REC_NAME: finalresult[35],
                  REC_ADDRESS1: finalresult[36],
                  REC_ADDRESS2: finalresult[37],
                  REC_ADDRESS3: finalresult[38],
                  REC_COUNTRY: finalresult[39],
                  REC_STATE: finalresult[40],
                  REC_STREET: finalresult[41],
                  REC_CITY: finalresult[42],
                  REC_PIN: int.parse(finalresult[43]),
                  REC_MOB: finalresult[44],
                  REC_EMAIL: finalresult[45],
                  REC_FAX: finalresult[46],
                ).upsert1();
                print("Insertion completed");
              }
            } catch (e) {
              await DeliveryModel().execSQL('ROLLBACK');
            }
            print("Exited insertion loop");
          } else if (fileName == "953") {
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            //print(fields[0][0].split("\n").length);
            for (int i = 0; i < fields.length; i++) {
              print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);
              await Delivery(
                BO_SLIP: finalresult[0],
                SOFFICE_ID: finalresult[1],
                DOFFICE_ID: finalresult[2],
                BOOK_DATE: finalresult[3],
                ART_NUMBER: finalresult[4],
                BOOK_ID: finalresult[5],
                MATNR: finalresult[6],
                LINE_ITEM: double.parse(finalresult[7]),
                COMMISSION: double.parse(finalresult[8]),
                TOTAL_MONEY: double.parse(finalresult[9]),
                SOURCE_PINCODE: int.parse(finalresult[10]),
                DESTN_PINCODE: int.parse(finalresult[11]),
                EMO_MESSAGE: finalresult[12],
                BO_ID: finalresult[13],
                REDIRECTION_SL: double.parse(finalresult[14]),
                MOD_PIN: int.parse(finalresult[36]),
                REPORTING_SO_ID: finalresult[42],
                ART_RECEIVE_DATE: DateTimeDetails().oD(),
                ART_RECEIVE_TIME: DateTimeDetails().oT(),
              ).upsert1();

              await Addres(
                  BO_SLIP: finalresult[0],
                  ART_NUMBER: finalresult[4],
                  BOOK_ID: finalresult[5],
                  SEND_CUST_N: finalresult[15],
                  SEND_ADD1: finalresult[16],
                  SEND_ADD2: finalresult[17],
                  SEND_ADD3: finalresult[18],
                  SEND_STREET: finalresult[19],
                  SEND_CITY: finalresult[20],
                  SEND_COUNTRY: finalresult[21],
                  SEND_STATE: finalresult[22],
                  SEND_EMAIL: finalresult[23],
                  SEND_PIN: int.parse(finalresult[24]),
                  SEND_FAX: finalresult[25],
                  SEND_MOB: finalresult[26],
                  REC_NAME: finalresult[27],
                  REC_ADDRESS1: finalresult[28],
                  REC_ADDRESS2: finalresult[29],
                  REC_ADDRESS3: finalresult[30],
                  REC_COUNTRY: finalresult[31],
                  REC_STATE: finalresult[32],
                  REC_STREET: finalresult[33],
                  REC_CITY: finalresult[34],
                  REC_PIN: int.parse(finalresult[35]),
                  REC_MOB: finalresult[37],
                  REC_EMAIL: finalresult[38],
                  REC_FAX: finalresult[39])
                  .upsert1();

              print("Insertion completed");
            }
            print("Exited insertion loop");
          } else if (fileName == "957") {
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            print(fields[0][0]
                .split("\n")
                .length);

            for (int i = 0; i < fields.length; i++) {
              print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);

              await BOSLIP_STAMP1(
                  BO_SLIP_NO: finalresult[0],
                  ZMOFACILITYID: finalresult[1],
                  MATNR: finalresult[2],
                  ZINV_PARTICULAR: finalresult[3],
                  MENGE_D: finalresult[4],
                  ZCREATEDT: finalresult[5],
                  ZMOCREATEDBY: finalresult[6])
                  .upsert1();

              print("Insertion completed");
            }
            print("Exited insertion loop");
          } else if (fileName == "959") {
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            //print(fields[0][0].split("\n").length);

            for (int i = 0; i < fields.length; i++) {
              print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);

              await BOSLIP_CASH1(
                  BO_SLIP_NO: finalresult[0],
                  DATE_OF_SENT: finalresult[1],
                  SO_PROFIT_CENTER: finalresult[3],
                  BO_PROFIT_CENTER: finalresult[4],
                  AMOUNT: finalresult[5],
                  WEIGHT_OF_CASH_BAG: finalresult[6],
                  CHEQUE_NO: finalresult[2],
                  CHEQUE_AMOUNT: finalresult[7],
                  CASHORCHEQUE: finalresult[8])
                  .upsert1();

              print("Insertion completed");
            }
            print("Exited insertion loop");
          } else if (fileName == "961") {
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            print(fields[0][0]
                .split("\n")
                .length);

            for (int i = 0; i < fields.length; i++) {
              print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);

              await BOSLIP_DOCUMENT1(
                  BO_SLIP_NO: finalresult[0],
                  DOCUMENT_DETAILS: finalresult[3],
                  TOOFFICE: finalresult[2])
                  .upsert1();
              print("Insertion completed");
            }
            print("Exited insertion loop");
          } else if (fileName == "964") {
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            print(fields[0][0]
                .split("\n")
                .length);

            for (int i = 0; i < fields.length; i++) {
              // print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);
              for (int i = 0; i < finalresult.length; i++) {
                print(finalresult[i]);
              }
              await BSRDETAILS_NEW(
                BOSLIPID: finalresult[0],
                BO_SLIP_DATE: finalresult[1],
                BAGNUMBER: finalresult[3],
                CLOSING_BALANCE: finalresult[4],
                CB_DATE: finalresult[5],
                CASH_STATUS: finalresult[6],
                STAMP_STATUS: finalresult[7],
                DOCUMENT_STATUS: finalresult[8],
              ).upsert1();

              print("Insertion completed");
            }
            print("Exited insertion loop");
          }
          if (fileName == "384") {
            print("fileName: $fileName");
            print("TRue");
            final input = new File(entities[i].path).openRead();
            final fields = await input
                .transform(utf8.decoder)
                .transform(new CsvToListConverter())
                .toList();
            print(fields);
            print(fields[0][0]
                .split("\n")
                .length);

            for (int i = 0; i < fields.length; i++) {
              print("Entered Loop");
              List finalresult = fields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .trim()
                  .split("‡");
              print(finalresult);

              await BAGDETAILS_NEW(
                  FROMOFFICE: finalresult[4],
                  TOOFFICE: finalresult[5],
                  TDATE: finalresult[6],
                  BAGNUMBER: finalresult[3],
                  BOSLIPNO: finalresult[8],
                  NO_OF_ARTICLES: finalresult[9])
                  .upsert1();

              await DESPATCHBAG(
                SCHEDULE: finalresult[0],
                SCHEDULED_TIME: finalresult[1],
                MAILLIST_TO_OFFICE: finalresult[2],
                BAGNUMBER: finalresult[3],
                FROM_OFFICE: finalresult[4],
                TO_OFFICE: finalresult[5],
                REMARKS: finalresult[7],
              ).upsert1();
              print("Insertion completed");
            }
            print("Exited insertion loop");
          }

          ///Switch On Acknowledgement
          // if (entities[i].toString().substring(38, 48) == 'ACK_BOLIVE')
          if (entities[i].toString().contains('ACK_BOLIVE')) {
            subRes.clear();
            final file = File(entities[i].path);
            List<int> firstLine = [];
            List<int> second = [];
            int firstLineLast = 0;
            List<int> s1 = file.readAsBytesSync();
            Uint8List list = Uint8List.fromList(s1);
            try {
              for (int i = 0; i < list.length; i++) {
                if (list[i] != 10) {
                  firstLine.add(list[i]);
                } else {
                  firstLineLast = i;
                  break;
                }
              }
            } catch (e) {
              print("Error is $e");
            }
            try {
              for (int i = firstLineLast + 1; i < list.length; i++) {
                if (list[i] == 135) {
                  list[i] = 1;
                }
                second.add(list[i]);
              }
            } catch (e) {
              print("Error in second is $e");
            }
            List acknowledgeResult = utf8.decode(firstLine).toString().split(
                "‡");
            final ackAcknowledge = SwitchOnAcknowledge()
              ..ParentOfficeNumber = acknowledgeResult[0]
              ..OfficeId = acknowledgeResult[1]
              ..BOSequenceId = acknowledgeResult[2]
              ..OfficeName = acknowledgeResult[3]
              ..LegacyCode = acknowledgeResult[4]
              ..SanctionedLimit = acknowledgeResult[5]
              ..CashBalance = acknowledgeResult[6];
            await ackAcknowledge.upsert1();

            List acknowledgementResult =
            utf8.decode(second).toString().split("");
            List ackResult = acknowledgementResult
                .toString()
                .replaceAll(",", "\n")
                .replaceAll("]", "")
                .split("\n");
            final acknowledgement = SwitchOnAcknowledgement()
              ..LegacyUpdation = ackResult[1]
              ..SanctionedDeletion = ackResult[3]
              ..SanctionedInsertion = ackResult[5]
              ..UpdateWallet = ackResult[7]
              ..InsertionClosingBalance = ackResult[9]
              ..InsertionOpeningBalance = ackResult[11]
              ..InsertionOpeningStock = ackResult[13];
            await acknowledgement.upsert1();
          }

          ///Leave Balance
          // if (entities[i].toString().substring(38, 43) == 'Leave')
          if (entities[i].toString().contains('Leave')) {
            subRes.clear();
            final leaveFile = File(entities[i].path).openRead();
            final leaveFields = await leaveFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < leaveFields.length; i++) {
              List leaveResult = leaveFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < leaveResult.length; i++) {
                subRes.add(leaveResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final updateLeave = LeaveBalanceTable()
                    ..EmployeeNumber = subRes[i][0]
                    ..QuotaType = subRes[i][1]
                    ..LeaveBalance = subRes[i][2];
                  await updateLeave.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Leave Balance', DateTimeDetails().currentDateTime());
          }

          ///VPP MO Commission
          // if (entities[i].toString().substring(38, 41) == 'VPP')
          if (entities[i].toString().contains('VPP')) {
            subRes.clear();
            final vppMOFile = File(entities[i].path).openRead();
            final vppMOFields = await vppMOFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < vppMOFields.length; i++) {
              List vppMOResult = vppMOFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < vppMOResult.length; i++) {
                subRes.add(vppMOResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addVppMO = VppMOCommission()
                    ..Commission = subRes[i][0]
                    ..MinimumAmount = subRes[i][1]
                    ..MaximumAmount = subRes[i][2]
                    ..CommissionAmount = subRes[i][3]
                    ..AdditionalService = subRes[i][4]
                    ..ValueID = subRes[i][5]
                    ..Identifier = subRes[i][6];
                  await addVppMO.upsert1();
                }
              }
            }
            addFileToDB(entities[i].toString(), dir.toString(),
                'MO Commission Master-VPP',
                DateTimeDetails().currentDateTime());
          }

          ///Biller Data

          if (entities[i].toString().contains('BillerData')) {
            subRes.clear();
            print("Inside biller data");
            final billerFile = await File(entities[i].path).openRead();
            final billerFiles = await billerFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < billerFiles.length; i++) {
              List billerResult = billerFiles
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < billerResult.length; i++) {
                subRes.add(billerResult[i].toString().split("‡"));
              }
              print("Biler Data file");

              for (int i = 0; i < subRes.length; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty &&
                    subRes[i][0].toString() != "") {
                  final addBiller = BillerData()
                    ..BillerId = subRes[i][0]
                    ..BillerName = subRes[i][1];
                  await addBiller.upsert1();
                }
              }
              final b = await BillerData().select().toMapList();
            }
            // addFileToDB(entities[i].toString(), dir.toString(), 'Biller Data', DateTimeDetails().currentDateTime());
          }

          ///Ins MO Commission
          // if (entities[i].toString().substring(38, 41) == 'INS')
          if (entities[i].toString().contains('INS')) {
            subRes.clear();
            final insMOFile = File(entities[i].path).openRead();
            final insMOFields = await insMOFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < insMOFields.length; i++) {
              List insMOResult = insMOFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < insMOResult.length; i++) {
                subRes.add(insMOResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addINSMO = InsMOCommission()
                    ..Commission = subRes[i][0]
                    ..MinimumAmount = subRes[i][1]
                    ..MaximumAmount = subRes[i][2]
                    ..CommissionAmount = subRes[i][3]
                    ..AdditionalService = subRes[i][4]
                    ..ValueID = subRes[i][5]
                    ..Identifier = subRes[i][6];
                  await addINSMO.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'MO Commission Master-INS',
                DateTimeDetails().currentDateTime());
          }

          ///EMO MO Commission
          // if (entities[i].toString().substring(38, 41) == 'EMO')
          if (entities[i].toString().contains('EMO')) {
            subRes.clear();
            final emoMOFile = File(entities[i].path).openRead();
            final emoMOFields = await emoMOFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < emoMOFields.length; i++) {
              List emoMOResult = emoMOFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < emoMOResult.length; i++) {
                subRes.add(emoMOResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addEMOMO = EmoMOCommission()
                    ..Commission = subRes[i][0]
                    ..MinimumAmount = subRes[i][1]
                    ..MaximumAmount = subRes[i][2]
                    ..CommissionAmount = subRes[i][3]
                    ..AdditionalService = subRes[i][4]
                    ..ValueID = subRes[i][5]
                    ..Identifier = subRes[i][6];
                  await addEMOMO.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'MO Commission Master-EMO',
                DateTimeDetails().currentDateTime());
          }

          ///Products Master
          // // if (entities[i].toString().substring(38, 45) == 'Product')
          if (entities[i].toString().contains('Product')) {
            subRes.clear();
            final productsFile = await File(entities[i].path).openRead();
            final productFields = await productsFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < productFields.length; i++) {
              List productResult = productFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < productResult.length; i++) {
                subRes.add(productResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addProduct = await ProductsMaster()
                    ..ItemCode = subRes[i][0]
                    ..ShortDescription = subRes[i][1]
                    ..CategoryDescription = subRes[i][2]
                    ..SalePrice = subRes[i][3]
                    ..EffStartDate = subRes[i][4]
                    ..EffEndDate = subRes[i][5]
                    ..POSCurrentStock = subRes[i][6]
                    ..OpeningStock = subRes[i][7]
                    ..Division = subRes[i][8]
                    ..OrderType = subRes[i][9]
                    ..MaterialGroup = subRes[i][10]
                    ..UnitMeasurement = subRes[i][11]
                    ..CreatedBy = subRes[i][12]
                    ..CreatedOn = subRes[i][13]
                    ..ModifiedBy = subRes[i][14]
                    ..ModifiedOn = subRes[i][15]
                    ..Identifier = subRes[i][16];
                  await addProduct.upsert1();
                  print("after products upsert1");
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Product Master', DateTimeDetails().currentDateTime());
          }

          // if (entities[i].toString().contains('Product'))
          // {
          //   print("Inside Product master");
          //   subRes.clear();
          //   final productsFile = await File(entities[i].path).openRead();
          //   final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
          //   for (int i = 1; i < productFields.length; i++) {
          //     subRes.add(productFields[i].toString().split("‡"));
          //   }
          //   for (int i = 0; i < subRes.length; i++) {
          //     if (subRes[i].toString().isNotEmpty) {
          //       final addProduct = await ProductsMaster()
          //           ..ItemCode = subRes[i][0]
          //           ..ShortDescription = subRes[i][1]
          //           ..CategoryDescription = subRes[i][2]
          //           ..SalePrice = subRes[i][3]
          //           ..EffStartDate = subRes[i][4]
          //           ..EffEndDate = subRes[i][5]
          //           ..POSCurrentStock = subRes[i][6]
          //           ..OpeningStock = subRes[i][7]
          //           ..Division = subRes[i][8]
          //           ..OrderType = subRes[i][9]
          //           ..MaterialGroup = subRes[i][10]
          //           ..UnitMeasurement = subRes[i][11]
          //           ..CreatedBy = subRes[i][12]
          //           ..CreatedOn = subRes[i][13]
          //           ..ModifiedBy = subRes[i][14]
          //           ..ModifiedOn = subRes[i][15]
          //           ..Identifier = subRes[i][16];
          //       addProduct.upsert();
          //     }
          //   }
          //   addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
          // }

          ///WeightMaster
          // if (entities[i].toString().substring(38, 44) == 'Weight')

          if (entities[i].toString().contains('Weight')) {
            subRes.clear();
            final weightFile = File(entities[i].path).openRead();
            final weightFields = await weightFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < weightFields.length; i++) {
              List weightResult = weightFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < weightResult.length; i++) {
                subRes.add(weightResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addWeight = WeightMaster()
                    ..WeightId = subRes[i][0]
                    ..MinimumWeight = subRes[i][1]
                    ..MaximumWeight = subRes[i][2]
                    ..ServiceId = subRes[i][3]
                    ..Identifier = subRes[i][4];
                  await addWeight.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Weight Master', DateTimeDetails().currentDateTime());
          }

          ///Distance Master
          // if (entities[i].toString().substring(38, 52) == 'DistanceMaster')
          if (entities[i].toString().contains('DistanceMaster')) {
            subRes.clear();
            final distanceFile = File(entities[i].path).openRead();
            final distanceFields = await distanceFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < distanceFields.length; i++) {
              List distanceResult = distanceFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < distanceResult.length; i++) {
                subRes.add(distanceResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addDistance = DistanceMaster()
                    ..Distance = subRes[i][0]
                    ..MinDistance = subRes[i][1]
                    ..MaxDistance = subRes[i][2]
                    ..Service = subRes[i][3]
                    ..Identifier = subRes[i][4];
                  await addDistance.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Distance Master', DateTimeDetails().currentDateTime());
          }

          ///Local Store
          // if (entities[i].toString().substring(38, 43) == 'Local')
          if (entities[i].toString().contains('Local')) {
            subRes.clear();
            final localStoreFile = File(entities[i].path).openRead();
            final localStoreFields = await localStoreFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < localStoreFields.length; i++) {
              List localStoreResult = localStoreFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < localStoreResult.length; i++) {
                subRes.add(localStoreResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addLocalStore = LocalStoreTable()
                    ..ParentOfficeId = subRes[i][0]
                    ..ParentOfficeName = subRes[i][1]
                    ..OfficeId = subRes[i][2]
                    ..BOSequenceId = subRes[i][3]
                    ..OfficeName = subRes[i][4]
                    ..Address = subRes[i][5]
                    ..Pin = subRes[i][6]
                    ..Latitude = subRes[i][7]
                    ..Longitude = subRes[i][8]
                    ..City = subRes[i][9]
                    ..StateCode = subRes[i][10]
                    ..StateName = subRes[i][11]
                    ..SolutionId = subRes[i][12]
                    ..LegacyCode = subRes[i][13]
                    ..CircleCode = subRes[i][14]
                    ..Circle = subRes[i][15]
                    ..CreatedBy = subRes[i][16]
                    ..CreatedOn = subRes[i][17]
                    ..ModifiedBy = subRes[i][18]
                    ..ModifiedOn = subRes[i][19]
                    ..IsStoreBegin = subRes[i][20]
                    ..WalkInCustomerId = subRes[i][21]
                    ..Identifier = subRes[i][22];
                  await addLocalStore.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Local Store Details', DateTimeDetails().currentDateTime());
          }

          ///Additional Service Mapping
          // if (entities[i].toString().substring(38, 41) == 'Add')
          if (entities[i].toString().contains('Add')) {
            subRes.clear();
            final additionalServiceMappingFile =
            File(entities[i].path).openRead();
            final additionalServiceMappingFields =
            await additionalServiceMappingFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < additionalServiceMappingFields.length; i++) {
              List additionalServiceMappingResult = additionalServiceMappingFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < additionalServiceMappingResult.length; i++) {
                subRes
                    .add(
                    additionalServiceMappingResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addTax = AdditionalServiceMappingTable()
                    ..ServiceId = subRes[i][0]
                    ..AdditionalServiceId = subRes[i][1]
                    ..AdditionalServicePrice = subRes[i][2]
                    ..Identifier = subRes[i][3];
                  await addTax.upsert1();
                }
              }
            }
            await addFileToDB(
                entities[i].toString(),
                dir.toString(),
                'Additional Service Mapping',
                DateTimeDetails().currentDateTime());
          }

          ///Tax master
          // if (entities[i].toString().substring(38, 47) == 'TaxMaster')
          if (entities[i].toString().contains('TaxMaster')) {
            subRes.clear();
            final taxFile = File(entities[i].path).openRead();
            final taxFields = await taxFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < taxFields.length; i++) {
              List taxResult = taxFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < taxResult.length; i++) {
                subRes.add(taxResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addTax = TaxMaster()
                    ..Service = subRes[i][0]
                    ..PercentageValue = subRes[i][1]
                    ..TaxDescription = subRes[i][2]
                    ..Identifier = subRes[i][3];
                  await addTax.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Tax Master', DateTimeDetails().currentDateTime());
          }

          ///Switch On
          // if (entities[i].toString().substring(38, 44) == 'BOLIVE')
          if (entities[i].toString().contains('BOLIVE')) {
            subRes.clear();
            final boLiveFile = File(entities[i].path).openRead();
            final boLiveFields = await boLiveFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < boLiveFields.length; i++) {
              List boLiveResult = boLiveFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < boLiveResult.length; i++) {
                subRes.add(boLiveResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addSwitch = SwitchOnTable()
                    ..ParentOfficeId = subRes[i][0]
                    ..OfficeId = subRes[i][1]
                    ..BOSequenceId = subRes[i][2]
                    ..OfficeName = subRes[i][3]
                    ..LegacyCode = subRes[i][4]
                    ..SanctionedLimit = subRes[i][5]
                    ..CashBalance = subRes[i][6];
                  await addSwitch.upsert1();
                }
              }
            }
            await addFileToDB(
                entities[i].toString(), dir.toString(), 'Switch On',
                DateTimeDetails().currentDateTime());
          }

          ///Service master
          // if (entities[i].toString().substring(38, 45) == 'Service')
          if (entities[i].toString().contains('Service')) {
            subRes.clear();
            final serviceFile = File(entities[i].path).openRead();
            final serviceFields = await serviceFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < serviceFields.length; i++) {
              List serviceResult = serviceFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < serviceResult.length; i++) {
                subRes.add(serviceResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addService = ServiceMaster()
                    ..ServiceId = subRes[i][0]
                    ..ServiceName = subRes[i][1]
                    ..MinimumWeight = subRes[i][2]
                    ..MaximumWeight = subRes[i][3]
                    ..Division = subRes[i][4]
                    ..OrderType = subRes[i][5]
                    ..ProductType = subRes[i][6]
                    ..MaterialGroup = subRes[i][7]
                    ..Identifier = subRes[i][8];
                  await addService.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Service Master', DateTimeDetails().currentDateTime());
          }

          ///Tariff Master
          if (entities[i].toString().substring(38, 50) ==
              'TariffMaster') if (entities[
          i]
              .toString()
              .contains('TariffMaster')) {
            subRes.clear();
            final tariffFile = File(entities[i].path).openRead();
            final tariffFields = await tariffFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < tariffFields.length; i++) {
              List tariffResult = tariffFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 1; i < tariffResult.length; i++) {
                subRes.add(tariffResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addTariff = TariffMaster()
                    ..Service = subRes[i][0]
                    ..WeightId = subRes[i][1]
                    ..Distance = subRes[i][2]
                    ..BasePrice = subRes[i][3]
                    ..Identifier = subRes[i][4];
                  await addTariff.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Tariff Master', DateTimeDetails().currentDateTime());
          }

          ///Cash Indent
          // if (entities[i].toString().substring(56, 58) == 'CI')
          if (entities[i].toString().contains('CI')) {
            subRes.clear();
            final cashIndentFile = File(entities[i].path).openRead();
            final cashIndentFields = await cashIndentFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < cashIndentFields.length; i++) {
              List cashIndentResult = cashIndentFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 0; i < cashIndentResult.length; i++) {
                subRes.add(cashIndentResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addCashIndent = CashIndentTable()
                    ..BOID = subRes[i][0]
                    ..Date = subRes[i][1]
                    ..Time = subRes[i][2]
                    ..BOName = subRes[i][3]
                    ..HOName = subRes[i][4]
                    ..Amount1 = subRes[i][5]
                    ..Amount2 = subRes[i][6]
                    ..Amount3 = subRes[i][7]
                    ..AmountType = subRes[i][8];
                  await addCashIndent.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Cash Indent', DateTimeDetails().currentDateTime());
          }

          ///Special Remittance
          // if (entities[i].toString().substring(56, 58) == 'SR')
          if (entities[i].toString().contains('SR')) {
            subRes.clear();
            final specialRemittanceFile = File(entities[i].path).openRead();
            final specialRemittanceFields = await specialRemittanceFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < specialRemittanceFields.length; i++) {
              List specialRemittanceResult = specialRemittanceFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 0; i < specialRemittanceResult.length; i++) {
                subRes.add(specialRemittanceResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length - 1; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addSpecialRemittance = SpecialRemittanceTable()
                    ..SpecialRemittanceId = subRes[i][0]
                    ..Date = subRes[i][1]
                    ..Time = subRes[i][2]
                    ..BOName = subRes[i][3]
                    ..HOName = subRes[i][4]
                    ..Amount1 = subRes[i][5]
                    ..Amount2 = subRes[i][6]
                    ..Amount3 = subRes[i][7]
                    ..AmountType = subRes[i][8];
                  await addSpecialRemittance.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Special Remittance', DateTimeDetails().currentDateTime());
          }

          ///Excess Cash
          // if (entities[i].toString().substring(56, 58) == 'EC')
          if (entities[i].toString().contains('EC')) {
            subRes.clear();
            final excessCashFile = File(entities[i].path).openRead();
            final excessCashFields = await excessCashFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            for (int i = 0; i < excessCashFields.length; i++) {
              List excessCashResult = excessCashFields
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              for (int i = 0; i < excessCashResult.length; i++) {
                subRes.add(excessCashResult[i].toString().split("‡"));
              }
              for (int i = 0; i < subRes.length; i++) {
                if (subRes[i]
                    .toString()
                    .isNotEmpty) {
                  final addExcessCash = ExcessCashTable()
                    ..BOID = subRes[i][0]
                    ..Date = subRes[i][1]
                    ..Time = subRes[i][2]
                    ..BOName = subRes[i][3]
                    ..HOName = subRes[i][4]
                    ..Amount1 = subRes[i][5]
                    ..Amount2 = subRes[i][6]
                    ..Amount3 = subRes[i][7]
                    ..AmountType = subRes[i][8]
                    ..Amount4 = subRes[i][9];
                  await addExcessCash.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Excess Cash', DateTimeDetails().currentDateTime());
          }

          ///Setup Inventory
          // if (entities[i].toString().substring(38, 43) == 'SetUp')
          print("Setup inventory insert");
          if (entities[i].toString().contains('SetUp')) {
            print("Setup inventory inside");
            subRes.clear();
            final inventoryFile = await File(entities[i].path).openRead();
            final inventoryFields = await inventoryFile
                .transform(utf8.decoder)
                .transform(const CsvToListConverter())
                .toList();
            print(inventoryFields);
            for (int i = 0; i < inventoryFields.length; i++) {
              List inventoryResult = inventoryFields[i]
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")
                  .split("\n");
              print(inventoryResult);
              for (int i = 0; i < inventoryResult.length; i++) {
                subRes.add(inventoryResult[i].toString().split("‡"));
              }
              print(subRes);
              for (int i = 0; i < subRes.length; i++) {
                print(subRes[i].toString());
                print(subRes[i]
                    .toString()
                    .isNotEmpty);
                print(subRes[i]
                    .toString()
                    .length);
                //if(subRes[i].toString().isNotEmpty  ) {
                if (subRes[i]
                    .toString()
                    .length > 2) {
                  final addExcessCash = SetUpInventoryTable()
                    ..BOId = subRes[i][0]
                    ..InventoryName = subRes[i][1]
                    ..Column1 = subRes[i][2]
                    ..Column2 = subRes[i][3];
                  await addExcessCash.upsert1();
                }
              }
            }
            await addFileToDB(entities[i].toString(), dir.toString(),
                'Setup Inventory', DateTimeDetails().currentDateTime());
          }
        }
        String? fname;
        String? type;
        //File received Acknowledgement after file downloaded and inserted successfull- Start
        for (int i = 0; i < 2; i++) {
          if (i == 0) {
            fname = "BOOK";
            type = "DEMOBOOKING";
          }
          else if (i == 1) {
            fname = "DEL";
            type = "DELAPPS";
          }

          if (File('storage/emulated/0/Darpan_Mine/DownloadCSV/$fname-$officeId.zip')
              .existsSync()) {
            print("File Exists");
            var headers = {
              'filename': '$officeId',
              'Authorization': 'Bearer ${acctoken[0].AccessToken}',
            };
            // var request = http.Request('GET', Uri.parse('https://gateway.cept.gov.in/sigtest/ack?filename=$officeId'));
            //var request = http.Request('GET', Uri.parse('https://gateway.cept.gov.in/sigfilecsi/ack?filename=$officeId'));

            var request = http.Request('GET', Uri.parse(
              //'https://gateway.cept.gov.in/signewtest/ack?filename=$officeId&type=$type'));
                'https://gateway.cept.gov.in/signewlive/ack?filename=$officeId&type=$type'));

            request.headers.addAll(headers);

            http.StreamedResponse response = await request.send();

            if (response.statusCode == 200) {
              // print(await response.stream.bytesToString());
              String res = await response.stream.bytesToString();
              await LogCat().writeContent("${DateTimeDetails()
                  .currentDateTime()}: Ack for File: $fname-$officeId: $res ");
              await File(
                  "storage/emulated/0/Darpan_Mine/DownloadCSV/$fname-$officeId.zip")
                  .rename(
                  "storage/emulated/0/Darpan_Mine/Exports/$fname-${DateTimeDetails()
                      .onlyDate()}$officeId.zip");
              await LogCat().writeContent("${DateTimeDetails()
                  .currentDateTime()}: File movement after acknowledgement: $fname-$officeId: $res \n\n");
            }
            else if(response.statusCode == 401){
              showDialog(
                barrierDismissible: false,
                context: navigatorKey.currentContext!,
                builder: (BuildContext dialogContext) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: MyAlertDialog(
                      title: 'Title',
                      content: 'Dialog content',
                    ),
                  );
                },
              );
            }
            else {
              // print(response.reasonPhrase);
              String res = await response.stream.bytesToString();
              await LogCat().writeContent("${DateTimeDetails()
                  .currentDateTime()}: Error in File acknowledgement: $fname-$officeId: $res \n\n");
            }
          }
          // End of acknowledgement
        }
        await Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId')
            .delete(recursive: true);
      }
      catch (e) {
        print("File Download: $e");
        await LogCat().writeContent("File download: $e \n\n");
      }
    }
    }
    else {
      //Need to show the error in Developer logs
      // UtilFs.showToast("Office Master Not Available !", context);
      await LogCat().writeContent("Office Master Not Available \n\n");
    }
  }

  // Future<void> download() async{
  //   List<USERLOGINDETAILS> acctoken=await USERLOGINDETAILS().select().toList();
  //   ByteData secdata;
  //   //String officeId='BO20105103005';
  //   final ofcMaster= await OFCMASTERDATA().select().toList();
  //   print("Inside download Before Try");
  //   //Rakesh Checking whether there is a row in the Master data
  //   if(ofcMaster.length > 0)
  //   {
  //     //var officeId = ofcMaster[0].BOFacilityID.toString();
  //     //var officeId='1234';
  //     var officeId='BO21309110004';//'BO20105103005';//'BO20105103005';//'BO20105103004';//'BO20105103005';
  //     print("Office ID is: "+officeId);
  //     secdata = await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
  //     print("Security Context");
  //     print(SecurityContext.defaultContext.toString());
  //     // if(SecurityContext.defaultContext.toString()!=null) {
  //     try{
  //       SecurityContext.defaultContext.setTrustedCertificatesBytes(
  //           secdata.buffer.asUint8List());
  //     }catch(Error){
  //       SecurityContext.defaultContext.useCertificateChainBytes(
  //           secdata.buffer.asUint8List());
  //     }
  //
  //     // }
  //     print("Entered Download API function");
  //
  //     var dio = Dio();
  //     try {
  //      // Commented Rakesh on 30082022
  //      // Response response = await dio.get(
  //      //   // "https://gateway.cept.gov.in:443/api/downloadFile",
  //      //   //   "https://gateway.cept.gov.in/api/downloadFile",
  //      //      "https://gateway.cept.gov.in/darpan/api/v3/downloadFile",
  //      //    options: Options(
  //      //        responseType: ResponseType.bytes,
  //      //        headers: { 'office-id': '$officeId'},
  //      //        followRedirects: false,
  //      //        validateStatus: (status) {
  //      //          return status! < 500;
  //      //        }),
  //      //  );
  //      // Comment Ended
  //         Response response = await dio.get(
  //       // "https://gateway.cept.gov.in:443/api/downloadFile",
  //       //   "https://gateway.cept.gov.in/api/downloadFile",
  //       "https://gateway.cept.gov.in/sigtest/download?filename=$officeId",
  //           //"https://gateway.cept.gov.in/sigfilecsi/download?filename=$officeId",
  //         options: Options(
  //             responseType: ResponseType.bytes,
  //             headers: {
  //               'filename': '$officeId',
  //               'Authorization': 'Bearer ${acctoken[0]
  //                   .AccessToken}',
  //             },
  //             followRedirects: false,
  //             validateStatus: (status) {
  //               return status! < 500;
  //             }),
  //       );
  //       print(response.statusCode);
  //
  //       if (response.statusCode == 200) {
  //         //commented by rakesh 10082022
  //        File file = await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
  //         var raf = await file.openSync(mode: FileMode.write);
  //         // response.data is List<int> type
  //         raf.writeFromSync(response.data);
  //         await raf.close();
  //         print("Before unZipping");
  //         final zipFile=await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
  //         final destinationDir = await Directory("storage/emulated/0/Darpan_Mine/DownloadCSV");
  //        // final destinationDir = await Directory("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId");
  //         try {
  //           // if(destinationDir.existsSync()){}
  //           // else{
  //           //   destinationDir.create();
  //           // }
  //          await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
  //         } catch (e) {
  //           print(e);
  //         }
  //       // Added by Rakesh 30082022 for ACk
  //         var resheaders = response.headers;
  //         print(resheaders['Sign']);
  //         print(resheaders['Sign'].toString().replaceAll("[", "").replaceAll(
  //             "]", "").trim());
  //         String filesign = resheaders['Sign'].toString()
  //             .replaceAll("[", "")
  //             .replaceAll("]", "")
  //             .trim();
  //         print("FileSign");
  //         print(filesign);
  //         bool? value = await Newenc.verifyfiles(
  //             filesign, "storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
  //
  //         print("Response received back in signature verification: $value");
  //         //Addition ended
  //         //   }
  //         //   else {
  //         //     print(response.data);
  //         //   }
  //         // }on DioError catch(error){
  //         //   print("Error Response");
  //         //   print(error.response!.statusCode);
  //         // }
  //         if (value == true) {
  //         final dir=Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId');
  //         print("Before file processing");
  //         final List<FileSystemEntity> entities = await dir.list().toList();
  //         print(entities.length);
  //         print(entities);
  //         for(int i=0;i<entities.length;i++){
  //           // print("lkajslf"+entities[i].toString());
  //           String fileName=entities[i].toString().substring(entities[i].toString().length-8,entities[i].toString().length-5);
  //           // if(entities[i].toString().endsWith("950"))
  //           // print("fileName: $fileName");
  //
  //           if(fileName=="950"){
  //             print("Inside 950 file name");
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //
  //             // print(fields.length);
  //             // print(fields[0]);
  //             // print(fields[1]);
  //             // print(fields[2]);
  //             // List resm=[];
  //             // // print(fields[0][0]);
  //             // // print(fields[0][1]);
  //             // // print(fields[0][0].split("\n"));
  //             // // print(fields[0][0].split("\n").length);
  //             // for(int i=0;i<fields.length;i++){
  //             // resm.add(fields[i]);
  //             //
  //             // }
  //             // print("Resm length: "+resm.length.toString());
  //             // List res=fields[0][0].split("‡");
  //             // print("Res is: "+res[0]);
  //             // print("Resm is: "+resm[0].toString());
  //             // print("Resm is: "+resm[1].toString());
  //             // print("Resm is: "+resm[2].toString());
  //
  //             try {
  //               for (int i = 0; i < fields.length; i++) {
  //                 print("Entered Loop");
  //                 //text = textList.toString().replace("[", "").replace("]", "");
  //                 List finalresult = fields[i].toString().replaceAll("[", "")
  //                     .replaceAll("]", "").trim()
  //                     .split("‡");
  //                 // List finalresult=fields[0][0].split("‡");
  //                 print(finalresult);
  //                 await Delivery(
  //                     BO_SLIP: finalresult[0],
  //                     SOFFICE_ID: finalresult[1],
  //                     DOFFICE_ID: finalresult[2],
  //                     BOOK_DATE: finalresult[3],
  //                     ART_NUMBER: finalresult[4],
  //                     BOOK_ID: finalresult[5],
  //                     LINE_ITEM: double.parse(finalresult[6]),
  //                     MATNR: finalresult[7],
  //                     BAG_ID: finalresult[8],
  //                     INSURANCE: finalresult[9],
  //                     TOTAL_MONEY: double.parse(finalresult[10]),
  //                     POST_DUE: double.parse(finalresult[11]),
  //                     DEM_CHARGE: double.parse(finalresult[12]),
  //                     COMMISSION: double.parse(finalresult[13]),
  //                     SOURCE_PINCODE: int.parse(finalresult[14]),
  //                     DESTN_PINCODE: int.parse(finalresult[15]),
  //                     BO_ID: finalresult[16],
  //                     REGISTERED: finalresult[17],
  //                     RETURN_SERVICE: finalresult[18],
  //                     COD: finalresult[19],
  //                     VPP: finalresult[20],
  //                     MONEY_TO_BE_COLLECTED: double.parse(finalresult[22]),
  //                     REDIRECTION_FEE: double.parse(finalresult[50]),
  //                     CUST_DUTY: double.parse(finalresult[51]),
  //                     REPORTING_SO_ID: finalresult[52]
  //                 ).upsert1();
  //                 await Addres(
  //                   BO_SLIP: finalresult[0],
  //                   ART_NUMBER: finalresult[4],
  //                   BOOK_ID: finalresult[5],
  //                   BAG_ID: finalresult[8],
  //                   SEND_CUST_N: finalresult[23],
  //                   SEND_ADD1: finalresult[24],
  //                   SEND_ADD2: finalresult[25],
  //                   SEND_ADD3: finalresult[26],
  //                   SEND_STREET: finalresult[27],
  //                   SEND_CITY: finalresult[28],
  //                   SEND_COUNTRY: finalresult[29],
  //                   SEND_STATE: finalresult[30],
  //                   SEND_EMAIL: finalresult[31],
  //                   SEND_PIN: int.parse(finalresult[32]),
  //                   SEND_FAX: finalresult[33],
  //                   SEND_MOB: finalresult[34],
  //                   REC_NAME: finalresult[35],
  //                   REC_ADDRESS1: finalresult[36],
  //                   REC_ADDRESS2: finalresult[37],
  //                   REC_ADDRESS3: finalresult[38],
  //                   REC_COUNTRY: finalresult[39],
  //                   REC_STATE: finalresult[40],
  //                   REC_STREET: finalresult[41],
  //                   REC_CITY: finalresult[42],
  //                   REC_PIN: int.parse(finalresult[43]),
  //                   REC_MOB: finalresult[44],
  //                   REC_EMAIL: finalresult[45],
  //                   REC_FAX: finalresult[46],
  //                 ).upsert1();
  //                 print("Insertion completed");
  //               }
  //             }catch(e){
  //               await DeliveryModel().execSQL('ROLLBACK');
  //             }
  //             print("Exited insertion loop");
  //           }
  //           else if(fileName=="953"){
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //             //print(fields[0][0].split("\n").length);
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //               await Delivery(
  //                   BO_SLIP: finalresult[0],
  //                   SOFFICE_ID: finalresult[1],
  //                   DOFFICE_ID: finalresult[2],
  //                   BOOK_DATE: finalresult[3],
  //                   ART_NUMBER: finalresult[4],
  //                   BOOK_ID: finalresult[5],
  //                   MATNR: finalresult[6],
  //                   LINE_ITEM: double.parse(finalresult[7]),
  //                   COMMISSION: double.parse(finalresult[8]),
  //                   TOTAL_MONEY: double.parse(finalresult[9]),
  //                   SOURCE_PINCODE: int.parse(finalresult[10]),
  //                   DESTN_PINCODE: int.parse(finalresult[11]),
  //                   EMO_MESSAGE: finalresult[12],
  //                   BO_ID: finalresult[13],
  //                   REDIRECTION_SL: double.parse(finalresult[14]),
  //                   MOD_PIN: int.parse(finalresult[36]),
  //                   REPORTING_SO_ID: finalresult[42],
  //                  ART_RECEIVE_DATE:DateTimeDetails().oD() ,
  //                  ART_RECEIVE_TIME:DateTimeDetails().oT() ,
  //               ).upsert1();
  //
  //               await Addres(
  //                   BO_SLIP: finalresult[0],
  //                   ART_NUMBER: finalresult[4],
  //                   BOOK_ID: finalresult[5],
  //                   SEND_CUST_N: finalresult[15],
  //                   SEND_ADD1: finalresult[16],
  //                   SEND_ADD2: finalresult[17],
  //                   SEND_ADD3: finalresult[18],
  //                   SEND_STREET: finalresult[19],
  //                   SEND_CITY: finalresult[20],
  //                   SEND_COUNTRY: finalresult[21],
  //                   SEND_STATE: finalresult[22],
  //                   SEND_EMAIL: finalresult[23],
  //                   SEND_PIN: int.parse(finalresult[24]),
  //                   SEND_FAX: finalresult[25],
  //                   SEND_MOB: finalresult[26],
  //                   REC_NAME: finalresult[27],
  //                   REC_ADDRESS1: finalresult[28],
  //                   REC_ADDRESS2: finalresult[29],
  //                   REC_ADDRESS3: finalresult[30],
  //                   REC_COUNTRY: finalresult[31],
  //                   REC_STATE: finalresult[32],
  //                   REC_STREET: finalresult[33],
  //                   REC_CITY: finalresult[34],
  //                   REC_PIN: int.parse(finalresult[35]),
  //                   REC_MOB: finalresult[37],
  //                   REC_EMAIL: finalresult[38],
  //                   REC_FAX: finalresult[39]
  //               ).upsert1();
  //
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //           else if(fileName=="957"){
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //
  //
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //
  //               await BOSLIP_STAMP1(
  //                   BO_SLIP_NO: finalresult[0],
  //                   ZMOFACILITYID: finalresult[1],
  //                   MATNR: finalresult[2],
  //                   ZINV_PARTICULAR: finalresult[3],
  //                   MENGE_D: finalresult[4],
  //                   ZCREATEDT: finalresult[5],
  //                   ZMOCREATEDBY: finalresult[6]
  //               ).upsert1();
  //
  //
  //
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //           else if(fileName=="959"){
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //             //print(fields[0][0].split("\n").length);
  //
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //
  //               await BOSLIP_CASH1(
  //                   BO_SLIP_NO: finalresult[0],
  //                   DATE_OF_SENT: finalresult[1],
  //                   SO_PROFIT_CENTER: finalresult[3],
  //                   BO_PROFIT_CENTER: finalresult[4],
  //                   AMOUNT: finalresult[5],
  //                   WEIGHT_OF_CASH_BAG: finalresult[6],
  //                   CHEQUE_NO: finalresult[2],
  //                   CHEQUE_AMOUNT: finalresult[7],
  //                   CASHORCHEQUE: finalresult[8]
  //               ).upsert1();
  //
  //
  //
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //           else if(fileName=="961"){
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //             print(fields[0][0].split("\n").length);
  //
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //
  //               await BOSLIP_DOCUMENT1(
  //                   BO_SLIP_NO: finalresult[0],
  //                   DOCUMENT_DETAILS: finalresult[3],
  //                   TOOFFICE: finalresult[2]
  //               ).upsert1();
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //           else if(fileName=="964"){
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //              print(fields[0][0].split("\n").length);
  //
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               // print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //               for(int i=0;i<finalresult.length;i++){
  //                 print(finalresult[i]);
  //               }
  //               await BSRDETAILS_NEW(
  //                 BOSLIPID: finalresult[0],
  //                 BO_SLIP_DATE: finalresult[1],
  //                 BAGNUMBER: finalresult[3],
  //                 CLOSING_BALANCE: finalresult[4],
  //                 CB_DATE: finalresult[5],
  //                 CASH_STATUS: finalresult[6],
  //                 STAMP_STATUS: finalresult[7],
  //                 DOCUMENT_STATUS: finalresult[8],
  //               ).upsert1();
  //
  //
  //
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //           if(fileName=="384"){
  //             print("fileName: $fileName");
  //             print("TRue");
  //             final input = new File(entities[i].path).openRead();
  //             final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //             print(fields);
  //             print(fields[0][0].split("\n").length);
  //
  //             for(int i=0;i<fields.length;i++)
  //             {
  //               print("Entered Loop");
  //               List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
  //               print(finalresult);
  //
  //               await BAGDETAILS_NEW(
  //                   FROMOFFICE: finalresult[4],
  //                   TOOFFICE: finalresult[5],
  //                   TDATE: finalresult[6],
  //                   BAGNUMBER: finalresult[3],
  //                   BOSLIPNO: finalresult[8],
  //                   NO_OF_ARTICLES: finalresult[9]
  //               ).upsert1();
  //
  //               await DESPATCHBAG(
  //                   SCHEDULE: finalresult[0],
  //                   SCHEDULED_TIME: finalresult[1],
  //                   MAILLIST_TO_OFFICE: finalresult[2],
  //                   BAGNUMBER: finalresult[3],
  //                   FROM_OFFICE: finalresult[4],
  //                   TO_OFFICE: finalresult[5],
  //                   REMARKS: finalresult[7],
  //
  //               ).upsert1();
  //               print("Insertion completed");
  //             }
  //             print("Exited insertion loop");
  //           }
  //
  //           ///Switch On Acknowledgement
  //           // if (entities[i].toString().substring(38, 48) == 'ACK_BOLIVE')
  //           if (entities[i].toString().contains('ACK_BOLIVE'))
  //           {
  //             subRes.clear();
  //             final file = File(entities[i].path);
  //             List<int> firstLine = [];
  //             List<int> second = [];
  //             int firstLineLast = 0;
  //             List<int> s1 = file.readAsBytesSync();
  //             Uint8List list = Uint8List.fromList(s1);
  //             try {
  //               for (int i = 0; i < list.length; i++) {
  //                 if (list[i] != 10) {
  //                   firstLine.add(list[i]);
  //                 } else {
  //                   firstLineLast = i;
  //                   break;
  //                 }
  //               }
  //             } catch (e) {
  //               print("Error is $e");
  //             }
  //             try {
  //               for (int i = firstLineLast+1; i < list.length; i++) {
  //                 if (list[i] == 135) {
  //                   list[i] = 1;
  //                 }
  //                 second.add(list[i]);
  //               }
  //             } catch (e) {
  //               print("Error in second is $e");
  //             }
  //             List acknowledgeResult = utf8.decode(firstLine).toString().split("‡");
  //             final ackAcknowledge = SwitchOnAcknowledge()
  //               ..ParentOfficeNumber = acknowledgeResult[0]
  //               ..OfficeId = acknowledgeResult[1]
  //               ..BOSequenceId = acknowledgeResult[2]
  //               ..OfficeName = acknowledgeResult[3]
  //               ..LegacyCode = acknowledgeResult[4]
  //               ..SanctionedLimit = acknowledgeResult[5]
  //               ..CashBalance = acknowledgeResult[6];
  //             await ackAcknowledge.upsert1();
  //
  //
  //
  //             List acknowledgementResult = utf8.decode(second).toString().split("");
  //             List ackResult = acknowledgementResult.toString().replaceAll(",", "\n").replaceAll("]", "").split("\n");
  //             final acknowledgement = SwitchOnAcknowledgement()
  //               ..LegacyUpdation = ackResult[1]
  //               ..SanctionedDeletion = ackResult[3]
  //               ..SanctionedInsertion = ackResult[5]
  //               ..UpdateWallet = ackResult[7]
  //               ..InsertionClosingBalance = ackResult[9]
  //               ..InsertionOpeningBalance = ackResult[11]
  //               ..InsertionOpeningStock = ackResult[13];
  //             await acknowledgement.upsert1();
  //           }
  //
  //           ///Leave Balance
  //           // if (entities[i].toString().substring(38, 43) == 'Leave')
  //           if (entities[i].toString().contains('Leave'))
  //           {
  //             subRes.clear();
  //             final leaveFile = File(entities[i].path).openRead();
  //             final leaveFields = await leaveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < leaveFields.length; i++) {
  //               List leaveResult = leaveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < leaveResult.length; i++) {
  //                 subRes.add(leaveResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final updateLeave = LeaveBalanceTable()
  //                     ..EmployeeNumber = subRes[i][0]
  //                     ..QuotaType = subRes[i][1]
  //                     ..LeaveBalance = subRes[i][2];
  //                   await updateLeave.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Leave Balance', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///VPP MO Commission
  //           // if (entities[i].toString().substring(38, 41) == 'VPP')
  //           if (entities[i].toString().contains( 'VPP'))
  //           {
  //             subRes.clear();
  //             final vppMOFile = File(entities[i].path).openRead();
  //             final vppMOFields = await vppMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < vppMOFields.length; i++) {
  //               List vppMOResult = vppMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < vppMOResult.length; i++) {
  //                 subRes.add(vppMOResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addVppMO = VppMOCommission()
  //                     ..Commission = subRes[i][0]
  //                     ..MinimumAmount = subRes[i][1]
  //                     ..MaximumAmount = subRes[i][2]
  //                     ..CommissionAmount = subRes[i][3]
  //                     ..AdditionalService = subRes[i][4]
  //                     ..ValueID = subRes[i][5]
  //                     ..Identifier = subRes[i][6];
  //                   await  addVppMO.upsert1();
  //                 }
  //               }
  //             }
  //             addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-VPP', DateTimeDetails().currentDateTime());
  //           }
  //           ///Biller Data
  //
  //           if(entities[i].toString().contains('BillerData'))
  //           {
  //             subRes.clear();
  //             print("Inside biller data");
  //             final billerFile = await File(entities[i].path).openRead();
  //             final billerFiles =  await billerFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < billerFiles.length; i++) {
  //               List billerResult = billerFiles.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < billerResult.length; i++) {
  //                 subRes.add(billerResult[i].toString().split("‡"));
  //               }
  //               print("Biler Data file");
  //
  //               for (int i = 0; i < subRes.length; i++) {
  //
  //                 if (subRes[i].toString().isNotEmpty && subRes[i][0].toString()!="") {
  //                   final addBiller = BillerData()
  //                     ..BillerId = subRes[i][0]
  //                     ..BillerName = subRes[i][1];
  //                   await addBiller.upsert1();
  //                 }
  //               }
  //               final b = await BillerData().select().toMapList();
  //             }
  //             // addFileToDB(entities[i].toString(), dir.toString(), 'Biller Data', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Ins MO Commission
  //           // if (entities[i].toString().substring(38, 41) == 'INS')
  //           if (entities[i].toString().contains( 'INS'))
  //           {
  //             subRes.clear();
  //             final insMOFile = File(entities[i].path).openRead();
  //             final insMOFields = await insMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < insMOFields.length; i++) {
  //               List insMOResult = insMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < insMOResult.length; i++) {
  //                 subRes.add(insMOResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addINSMO = InsMOCommission()
  //                     ..Commission = subRes[i][0]
  //                     ..MinimumAmount = subRes[i][1]
  //                     ..MaximumAmount = subRes[i][2]
  //                     ..CommissionAmount = subRes[i][3]
  //                     ..AdditionalService = subRes[i][4]
  //                     ..ValueID = subRes[i][5]
  //                     ..Identifier = subRes[i][6];
  //                   await addINSMO.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-INS', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///EMO MO Commission
  //           // if (entities[i].toString().substring(38, 41) == 'EMO')
  //           if (entities[i].toString().contains('EMO'))
  //           {
  //             subRes.clear();
  //             final emoMOFile = File(entities[i].path).openRead();
  //             final emoMOFields = await emoMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < emoMOFields.length; i++) {
  //               List emoMOResult = emoMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < emoMOResult.length; i++) {
  //                 subRes.add(emoMOResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addEMOMO = EmoMOCommission()
  //                     ..Commission = subRes[i][0]
  //                     ..MinimumAmount = subRes[i][1]
  //                     ..MaximumAmount = subRes[i][2]
  //                     ..CommissionAmount = subRes[i][3]
  //                     ..AdditionalService = subRes[i][4]
  //                     ..ValueID = subRes[i][5]
  //                     ..Identifier = subRes[i][6];
  //                   await addEMOMO.upsert1();
  //                 }
  //               }
  //             }
  //             await   addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-EMO', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Products Master
  //           // // if (entities[i].toString().substring(38, 45) == 'Product')
  //           if (entities[i].toString().contains('Product')) {
  //             subRes.clear();
  //             final productsFile = await File(entities[i].path).openRead();
  //             final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < productFields.length; i++) {
  //               List productResult = productFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < productResult.length; i++) {
  //                 subRes.add(productResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addProduct = await ProductsMaster()
  //                     ..ItemCode = subRes[i][0]
  //                     ..ShortDescription = subRes[i][1]
  //                     ..CategoryDescription = subRes[i][2]
  //                     ..SalePrice = subRes[i][3]
  //                     ..EffStartDate = subRes[i][4]
  //                     ..EffEndDate = subRes[i][5]
  //                     ..POSCurrentStock = subRes[i][6]
  //                     ..OpeningStock = subRes[i][7]
  //                     ..Division = subRes[i][8]
  //                     ..OrderType = subRes[i][9]
  //                     ..MaterialGroup = subRes[i][10]
  //                     ..UnitMeasurement = subRes[i][11]
  //                     ..CreatedBy = subRes[i][12]
  //                     ..CreatedOn = subRes[i][13]
  //                     ..ModifiedBy = subRes[i][14]
  //                     ..ModifiedOn = subRes[i][15]
  //                     ..Identifier = subRes[i][16];
  //                   await  addProduct.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
  //           }
  //           // if (entities[i].toString().contains('Product'))
  //           // {
  //           //   print("Inside Product master");
  //           //   subRes.clear();
  //           //   final productsFile = await File(entities[i].path).openRead();
  //           //   final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //           //   for (int i = 1; i < productFields.length; i++) {
  //           //     subRes.add(productFields[i].toString().split("‡"));
  //           //   }
  //           //   for (int i = 0; i < subRes.length; i++) {
  //           //     if (subRes[i].toString().isNotEmpty) {
  //           //       final addProduct = await ProductsMaster()
  //           //           ..ItemCode = subRes[i][0]
  //           //           ..ShortDescription = subRes[i][1]
  //           //           ..CategoryDescription = subRes[i][2]
  //           //           ..SalePrice = subRes[i][3]
  //           //           ..EffStartDate = subRes[i][4]
  //           //           ..EffEndDate = subRes[i][5]
  //           //           ..POSCurrentStock = subRes[i][6]
  //           //           ..OpeningStock = subRes[i][7]
  //           //           ..Division = subRes[i][8]
  //           //           ..OrderType = subRes[i][9]
  //           //           ..MaterialGroup = subRes[i][10]
  //           //           ..UnitMeasurement = subRes[i][11]
  //           //           ..CreatedBy = subRes[i][12]
  //           //           ..CreatedOn = subRes[i][13]
  //           //           ..ModifiedBy = subRes[i][14]
  //           //           ..ModifiedOn = subRes[i][15]
  //           //           ..Identifier = subRes[i][16];
  //           //       addProduct.upsert();
  //           //     }
  //           //   }
  //           //   addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
  //           // }
  //
  //           ///WeightMaster
  //           // if (entities[i].toString().substring(38, 44) == 'Weight')
  //
  //           if (entities[i].toString().contains('Weight')){
  //             subRes.clear();
  //             final weightFile = File(entities[i].path).openRead();
  //             final weightFields = await weightFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < weightFields.length; i++) {
  //               List weightResult = weightFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < weightResult.length; i++) {
  //                 subRes.add(weightResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addWeight = WeightMaster()
  //                     ..WeightId = subRes[i][0]
  //                     ..MinimumWeight = subRes[i][1]
  //                     ..MaximumWeight = subRes[i][2]
  //                     ..ServiceId = subRes[i][3]
  //                     ..Identifier = subRes[i][4];
  //                   await addWeight.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Weight Master', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Distance Master
  //           // if (entities[i].toString().substring(38, 52) == 'DistanceMaster')
  //           if (entities[i].toString().contains( 'DistanceMaster'))
  //           {
  //             subRes.clear();
  //             final distanceFile = File(entities[i].path).openRead();
  //             final distanceFields = await distanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < distanceFields.length; i++) {
  //               List distanceResult = distanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < distanceResult.length; i++) {
  //                 subRes.add(distanceResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addDistance = DistanceMaster()
  //                     ..Distance = subRes[i][0]
  //                     ..MinDistance = subRes[i][1]
  //                     ..MaxDistance = subRes[i][2]
  //                     ..Service = subRes[i][3]
  //                     ..Identifier = subRes[i][4];
  //                   await   addDistance.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Distance Master', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Local Store
  //           // if (entities[i].toString().substring(38, 43) == 'Local')
  //           if (entities[i].toString().contains('Local'))
  //           {
  //             subRes.clear();
  //             final localStoreFile = File(entities[i].path).openRead();
  //             final localStoreFields = await localStoreFile.transform(utf8.decoder).transform(
  //                 const CsvToListConverter()).toList();
  //             for (int i = 0; i < localStoreFields.length; i++) {
  //               List localStoreResult = localStoreFields.toString().replaceAll("[", "")
  //                   .replaceAll("]", "")
  //                   .split("\n");
  //               for (int i = 1; i < localStoreResult.length; i++) {
  //                 subRes.add(localStoreResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addLocalStore = LocalStoreTable()
  //                     ..ParentOfficeId = subRes[i][0]
  //                     ..ParentOfficeName = subRes[i][1]
  //                     ..OfficeId = subRes[i][2]
  //                     ..BOSequenceId = subRes[i][3]
  //                     ..OfficeName = subRes[i][4]
  //                     ..Address = subRes[i][5]
  //                     ..Pin = subRes[i][6]
  //                     ..Latitude = subRes[i][7]
  //                     ..Longitude = subRes[i][8]
  //                     ..City = subRes[i][9]
  //                     ..StateCode = subRes[i][10]
  //                     ..StateName = subRes[i][11]
  //                     ..SolutionId = subRes[i][12]
  //                     ..LegacyCode = subRes[i][13]
  //                     ..CircleCode = subRes[i][14]
  //                     ..Circle = subRes[i][15]
  //                     ..CreatedBy = subRes[i][16]
  //                     ..CreatedOn = subRes[i][17]
  //                     ..ModifiedBy = subRes[i][18]
  //                     ..ModifiedOn = subRes[i][19]
  //                     ..IsStoreBegin = subRes[i][20]
  //                     ..WalkInCustomerId = subRes[i][21]
  //                     ..Identifier = subRes[i][22];
  //                   await  addLocalStore.upsert1();
  //                 }
  //               }
  //             }
  //             await    addFileToDB(entities[i].toString(), dir.toString(), 'Local Store Details', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Additional Service Mapping
  //           // if (entities[i].toString().substring(38, 41) == 'Add')
  //           if (entities[i].toString().contains('Add'))
  //           {
  //             subRes.clear();
  //             final additionalServiceMappingFile = File(entities[i].path).openRead();
  //             final additionalServiceMappingFields = await additionalServiceMappingFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < additionalServiceMappingFields.length; i++) {
  //               List additionalServiceMappingResult = additionalServiceMappingFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < additionalServiceMappingResult.length; i++) {
  //                 subRes.add(additionalServiceMappingResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addTax = AdditionalServiceMappingTable()
  //                     ..ServiceId = subRes[i][0]
  //                     ..AdditionalServiceId = subRes[i][1]
  //                     ..AdditionalServicePrice = subRes[i][2]
  //                     ..Identifier = subRes[i][3];
  //                   await addTax.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Additional Service Mapping', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Tax master
  //           // if (entities[i].toString().substring(38, 47) == 'TaxMaster')
  //           if (entities[i].toString().contains('TaxMaster'))
  //           {
  //             subRes.clear();
  //             final taxFile = File(entities[i].path).openRead();
  //             final taxFields = await taxFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < taxFields.length; i++) {
  //               List taxResult = taxFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < taxResult.length; i++) {
  //                 subRes.add(taxResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addTax = TaxMaster()
  //                     ..Service = subRes[i][0]
  //                     ..PercentageValue = subRes[i][1]
  //                     ..TaxDescription = subRes[i][2]
  //                     ..Identifier = subRes[i][3];
  //                   await addTax.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Tax Master', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Switch On
  //           // if (entities[i].toString().substring(38, 44) == 'BOLIVE')
  //           if (entities[i].toString().contains( 'BOLIVE'))
  //           {
  //             subRes.clear();
  //             final boLiveFile = File(entities[i].path).openRead();
  //             final boLiveFields = await boLiveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < boLiveFields.length; i++) {
  //               List boLiveResult = boLiveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < boLiveResult.length; i++) {
  //                 subRes.add(boLiveResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addSwitch = SwitchOnTable()
  //                     ..ParentOfficeId = subRes[i][0]
  //                     ..OfficeId = subRes[i][1]
  //                     ..BOSequenceId = subRes[i][2]
  //                     ..OfficeName = subRes[i][3]
  //                     ..LegacyCode = subRes[i][4]
  //                     ..SanctionedLimit = subRes[i][5]
  //                     ..CashBalance = subRes[i][6];
  //                   await addSwitch.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Switch On', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Service master
  //           // if (entities[i].toString().substring(38, 45) == 'Service')
  //           if (entities[i].toString().contains('Service'))
  //           {
  //             subRes.clear();
  //             final serviceFile = File(entities[i].path).openRead();
  //             final serviceFields = await serviceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < serviceFields.length; i++) {
  //               List serviceResult = serviceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 1; i < serviceResult.length; i++) {
  //                 subRes.add(serviceResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if (subRes[i].toString().isNotEmpty) {
  //                   final addService = ServiceMaster()
  //                     ..ServiceId = subRes[i][0]
  //                     ..ServiceName = subRes[i][1]
  //                     ..MinimumWeight = subRes[i][2]
  //                     ..MaximumWeight = subRes[i][3]
  //                     ..Division = subRes[i][4]
  //                     ..OrderType = subRes[i][5]
  //                     ..ProductType = subRes[i][6]
  //                     ..MaterialGroup = subRes[i][7]
  //                     ..Identifier = subRes[i][8];
  //                   await  addService.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Service Master', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Tariff Master
  //           if (entities[i].toString().substring(38, 50) == 'TariffMaster')
  //             if (entities[i].toString().contains( 'TariffMaster'))
  //             {
  //               subRes.clear();
  //               final tariffFile = File(entities[i].path).openRead();
  //               final tariffFields = await tariffFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //               for (int i = 0; i < tariffFields.length; i++) {
  //                 List tariffResult = tariffFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //                 for (int i = 1; i < tariffResult.length; i++) {
  //                   subRes.add(tariffResult[i].toString().split("‡"));
  //                 }
  //                 for (int i = 0; i < subRes.length - 1; i++) {
  //                   if(subRes[i].toString().isNotEmpty) {
  //                     final addTariff = TariffMaster()
  //                       ..Service = subRes[i][0]
  //                       ..WeightId = subRes[i][1]
  //                       ..Distance = subRes[i][2]
  //                       ..BasePrice = subRes[i][3]
  //                       ..Identifier = subRes[i][4];
  //                     await addTariff.upsert1();
  //                   }
  //                 }
  //               }
  //               await  addFileToDB(entities[i].toString(), dir.toString(), 'Tariff Master', DateTimeDetails().currentDateTime());
  //             }
  //
  //           ///Cash Indent
  //           // if (entities[i].toString().substring(56, 58) == 'CI')
  //           if (entities[i].toString().contains( 'CI'))
  //           {
  //             subRes.clear();
  //             final cashIndentFile = File(entities[i].path).openRead();
  //             final cashIndentFields = await cashIndentFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < cashIndentFields.length; i++) {
  //               List cashIndentResult = cashIndentFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 0; i < cashIndentResult.length; i++) {
  //                 subRes.add(cashIndentResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if(subRes[i].toString().isNotEmpty) {
  //                   final addCashIndent = CashIndentTable()
  //                     ..BOID = subRes[i][0]
  //                     ..Date = subRes[i][1]
  //                     ..Time = subRes[i][2]
  //                     ..BOName = subRes[i][3]
  //                     ..HOName = subRes[i][4]
  //                     ..Amount1 = subRes[i][5]
  //                     ..Amount2 = subRes[i][6]
  //                     ..Amount3 = subRes[i][7]
  //                     ..AmountType = subRes[i][8];
  //                   await addCashIndent.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Cash Indent', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Special Remittance
  //           // if (entities[i].toString().substring(56, 58) == 'SR')
  //           if (entities[i].toString().contains( 'SR'))
  //           {
  //             subRes.clear();
  //             final specialRemittanceFile = File(entities[i].path).openRead();
  //             final specialRemittanceFields = await specialRemittanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < specialRemittanceFields.length; i++) {
  //               List specialRemittanceResult = specialRemittanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 0; i < specialRemittanceResult.length; i++) {
  //                 subRes.add(specialRemittanceResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length - 1; i++) {
  //                 if(subRes[i].toString().isNotEmpty) {
  //                   final addSpecialRemittance = SpecialRemittanceTable()
  //                     ..SpecialRemittanceId = subRes[i][0]
  //                     ..Date = subRes[i][1]
  //                     ..Time = subRes[i][2]
  //                     ..BOName = subRes[i][3]
  //                     ..HOName = subRes[i][4]
  //                     ..Amount1 = subRes[i][5]
  //                     ..Amount2 = subRes[i][6]
  //                     ..Amount3 = subRes[i][7]
  //                     ..AmountType = subRes[i][8];
  //                   await  addSpecialRemittance.upsert1();
  //                 }
  //               }
  //             }
  //             await  addFileToDB(entities[i].toString(), dir.toString(), 'Special Remittance', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Excess Cash
  //           // if (entities[i].toString().substring(56, 58) == 'EC')
  //           if (entities[i].toString().contains( 'EC'))
  //           {
  //             subRes.clear();
  //             final excessCashFile = File(entities[i].path).openRead();
  //             final excessCashFields = await excessCashFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             for (int i = 0; i < excessCashFields.length; i++) {
  //               List excessCashResult = excessCashFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               for (int i = 0; i < excessCashResult.length; i++) {
  //                 subRes.add(excessCashResult[i].toString().split("‡"));
  //               }
  //               for (int i = 0; i < subRes.length; i++) {
  //                 if(subRes[i].toString().isNotEmpty) {
  //                   final addExcessCash = ExcessCashTable()
  //                     ..BOID = subRes[i][0]
  //                     ..Date = subRes[i][1]
  //                     ..Time = subRes[i][2]
  //                     ..BOName = subRes[i][3]
  //                     ..HOName = subRes[i][4]
  //                     ..Amount1 = subRes[i][5]
  //                     ..Amount2 = subRes[i][6]
  //                     ..Amount3 = subRes[i][7]
  //                     ..AmountType = subRes[i][8]
  //                     ..Amount4 = subRes[i][9];
  //                   await addExcessCash.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Excess Cash', DateTimeDetails().currentDateTime());
  //           }
  //
  //           ///Setup Inventory
  //           // if (entities[i].toString().substring(38, 43) == 'SetUp')
  //           print("Setup inventory insert");
  //           if (entities[i].toString().contains('SetUp'))
  //           {
  //             print("Setup inventory inside");
  //             subRes.clear();
  //             final inventoryFile = await File(entities[i].path).openRead();
  //             final inventoryFields = await inventoryFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //             print(inventoryFields);
  //             for (int i = 0; i < inventoryFields.length; i++) {
  //               List inventoryResult = inventoryFields[i].toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //               print(inventoryResult);
  //               for (int i = 0; i < inventoryResult.length; i++) {
  //                 subRes.add(inventoryResult[i].toString().split("‡"));
  //               }
  //               print(subRes);
  //               for (int i = 0; i < subRes.length; i++) {
  //                 print(subRes[i].toString());
  //                 print(subRes[i].toString().isNotEmpty);
  //                 print(subRes[i].toString().length);
  //                 //if(subRes[i].toString().isNotEmpty  ) {
  //                   if(subRes[i].toString().length >2  ) {
  //                   final addExcessCash = SetUpInventoryTable()
  //                     ..BOId = subRes[i][0]
  //                     ..InventoryName = subRes[i][1]
  //                     ..Column1 = subRes[i][2]
  //                     ..Column2 = subRes[i][3];
  //                   await  addExcessCash.upsert1();
  //                 }
  //               }
  //             }
  //             await addFileToDB(entities[i].toString(), dir.toString(), 'Setup Inventory', DateTimeDetails().currentDateTime());
  //           }
  //
  //
  //         }
  //         // final input = new File('storage/emulated/0/Darpan_Mine/csvimport.csv').openRead();
  //         // final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         //
  //         //
  //         // for(int i=0;i<fields[0][0].split("\n").length-1;i++){
  //         //   List finalresult=fields[0][0].split("\n")[i].split("‡");
  //         //   print(finalresult);
  //         // }
  //         //   int counter=0;
  //         // print("Files available");
  //         //   print(entities.length);
  //         //   for(int i=0;i<entities.length;i++) {
  //         //     print(counter);
  //         //     counter++;
  //         //     print("BOLive");
  //         //     print(entities[i].toString());
  //         //     String fileName=entities[i].toString().substring(entities[i].toString().length-44,entities[i].toString().length-34);
  //         //     print(fileName);
  //         //     // if(fileName=="ACK_BOLIVE"){
  //         //     //   print("Entered for acknowledge bo live");
  //         //     //   final input = new File(entities[i].path).openRead();
  //         //     //   final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         //     // }
  //         //   }
  //
  //       //File received Acknowledgement after file downloaded and inserted successfull- Start
  //       //   var headers= {
  //       //     'filename': '$officeId',
  //       //     'Authorization': 'Bearer ${acctoken[0].AccessToken}',
  //       //   };
  //       //   var request = http.Request('GET', Uri.parse('https://gateway.cept.gov.in/sigtest/ack?filename=$officeId'));
  //       //   //var request = http.Request('GET', Uri.parse('https://gateway.cept.gov.in/sigfilecsi/ack?filename=$officeId'));
  //       //
  //       //   request.headers.addAll(headers);
  //       //
  //       //   http.StreamedResponse response = await request.send();
  //       //
  //       //   if (response.statusCode == 200) {
  //       //     // print(await response.stream.bytesToString());
  //       //     String res=await response.stream.bytesToString();
  //       //     await LogCat().writeContent("${DateTimeDetails().currentDateTime()}: Ack for File: $officeId: $res ");
  //       //     await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip").rename("storage/emulated/0/Darpan_Mine/Exports/${DateTimeDetails().onlyDate()}$officeId.zip");
  //       //     await LogCat().writeContent("${DateTimeDetails().currentDateTime()}: File movement after acknowledgement: $officeId: $res ");
  //       //
  //       //   }
  //       //   else {
  //       //     // print(response.reasonPhrase);
  //       //     String res=await response.stream.bytesToString();
  //       //     await LogCat().writeContent("${DateTimeDetails().currentDateTime()}: Error in File acknowledgement: $officeId: $res ");
  //       //
  //       //   }
  //          // End of acknowledgement
  //
  //       }
  //       else{
  //         // UtilFs.showToast("Signature Verification Failed! Try Again",context);
  //         await LogCat().writeContent(
  //             '${DateTimeDetails().currentDateTime()} :BackGround operations File Downloading: Signature Verification Failed.\n\n');
  //       }
  //         //Delete the files from the extracted folder
  //         await Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId').delete(recursive: true);
  //         //await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip").delete(recursive: true);
  //       }
  //       else {
  //         // String res=response.data;
  //         await LogCat().writeContent("${DateTimeDetails().currentDateTime()}: Error in File acknowledgement: $officeId: ${response.data} ");
  //
  //       }
  //     }on DioError catch(error){
  //       print("Error Response");
  //       print(error);
  //     }
  //
  //
  //
  //   }
  //   else
  //   {
  //     //Need to show the error in Developer logs
  //     // UtilFs.showToast("Office Master Not Available !", context);
  //   }
  //
  //
  // }

  // Future<void> download() async{
  //   String officeId='BO20105103001';
  //
  //   ByteData secdata = await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
  //
  //   SecurityContext.defaultContext.setTrustedCertificatesBytes(secdata.buffer.asUint8List());
  //
  //   print("Reached Download API");
  //   var headers = {
  //     'office-id': '$officeId'
  //   };
  //   var request = http.Request('GET', Uri.parse('https://gateway.cept.gov.in:443/api/downloadFile'));
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  //
  //
  //   File file = await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
  //
  //   final zipFile=await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip");
  //   final destinationDir = await Directory("storage/emulated/0/Darpan_Mine/DownloadCSV");
  //   try {
  //     await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
  //     final dir=Directory('storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId');
  //     final List<FileSystemEntity> entities = await dir.list().toList();
  //     print(entities.length);
  //     for(int i=0;i<entities.length;i++){
  //
  //       String fileName=entities[i].toString().substring(entities[i].toString().length-8,entities[i].toString().length-5);
  //
  //       if(fileName=="950"){
  //         // print("fileName: ${entities[i]}");
  //         // print("Inside 950 file name");
  //         // print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         // print(fields);
  //         print(fields.length);
  //         // for(int i=0;i<fields.length;i++){
  //         //   print("Inside fields length");
  //         //   print(fields[i]);
  //         // }
  //         // await DeliveryModel().batchStart();
  //         // List finalresult=[];
  //         // for (int j = 0; j < fields.length; j++) {
  //         //   finalresult.add(fields[j].toString().replaceAll("[", "")
  //         //       .replaceAll("]", "").trim()
  //         //       .split("‡"));
  //         //   print(finalresult[j]);
  //         // }
  //         //
  //         // await DeliveryModel().batchStart();
  //         // try{
  //         //   for(int i=0;i<finalresult.length;i++){
  //         //     print("I Value: $i");
  //         //         await Delivery(
  //         //             BO_SLIP: finalresult[i][0],
  //         //             SOFFICE_ID: finalresult[i][1],
  //         //             DOFFICE_ID: finalresult[i][2],
  //         //             BOOK_DATE: finalresult[i][3],
  //         //             ART_NUMBER: finalresult[i][4],
  //         //             BOOK_ID: finalresult[i][5],
  //         //             LINE_ITEM: double.parse(finalresult[i][6]),
  //         //             MATNR: finalresult[i][7],
  //         //             BAG_ID: finalresult[i][8],
  //         //             INSURANCE: finalresult[i][9],
  //         //             TOTAL_MONEY: double.parse(finalresult[i][10]),
  //         //             POST_DUE: double.parse(finalresult[i][11]),
  //         //             DEM_CHARGE: double.parse(finalresult[i][12]),
  //         //             COMMISSION: double.parse(finalresult[i][13]),
  //         //             SOURCE_PINCODE: int.parse(finalresult[i][14]),
  //         //             DESTN_PINCODE: int.parse(finalresult[i][15]),
  //         //             BO_ID: finalresult[i][16],
  //         //             REGISTERED: finalresult[i][17],
  //         //             RETURN_SERVICE: finalresult[i][18],
  //         //             COD: finalresult[i][19],
  //         //             VPP: finalresult[i][20],
  //         //             MONEY_TO_BE_COLLECTED: double.parse(finalresult[i][22]),
  //         //             REDIRECTION_FEE: double.parse(finalresult[i][50]),
  //         //             CUST_DUTY: double.parse(finalresult[i][51]),
  //         //             REPORTING_SO_ID: finalresult[i][52]
  //         //         ).upsert();
  //         //
  //         //         await Addres(
  //         //                 BO_SLIP: finalresult[i][0],
  //         //                 ART_NUMBER: finalresult[i][4],
  //         //                 BOOK_ID: finalresult[i][5],
  //         //                 BAG_ID: finalresult[i][8],
  //         //                 SEND_CUST_N: finalresult[i][23],
  //         //                 SEND_ADD1: finalresult[i][24],
  //         //                 SEND_ADD2: finalresult[i][25],
  //         //                 SEND_ADD3: finalresult[i][26],
  //         //                 SEND_STREET: finalresult[i][27],
  //         //                 SEND_CITY: finalresult[i][28],
  //         //                 SEND_COUNTRY: finalresult[i][29],
  //         //                 SEND_STATE: finalresult[i][30],
  //         //                 SEND_EMAIL: finalresult[i][31],
  //         //                 SEND_PIN: int.parse(finalresult[i][32]),
  //         //                 SEND_FAX: finalresult[i][33],
  //         //                 SEND_MOB: finalresult[i][34],
  //         //                 REC_NAME: finalresult[i][35],
  //         //                 REC_ADDRESS1: finalresult[i][36],
  //         //                 REC_ADDRESS2: finalresult[i][37],
  //         //                 REC_ADDRESS3: finalresult[i][38],
  //         //                 REC_COUNTRY: finalresult[i][39],
  //         //                 REC_STATE: finalresult[i][40],
  //         //                 REC_STREET: finalresult[i][41],
  //         //                 REC_CITY: finalresult[i][42],
  //         //                 REC_PIN: int.parse(finalresult[i][43]),
  //         //                 REC_MOB: finalresult[i][44],
  //         //                 REC_EMAIL: finalresult[i][45],
  //         //                 REC_FAX: finalresult[i][46],
  //         //               ).upsert();
  //         //
  //         //   }
  //         //   final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         // }
  //         // catch(e){
  //         //     print("Error in DB Insertion: "+e.toString());
  //         //     DeliveryModel().batchRollback();
  //         //   }
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             //text = textList.toString().replace("[", "").replace("]", "");
  //             List finalresult = fields[i].toString().replaceAll("[", "")
  //                 .replaceAll("]", "").trim()
  //                 .split("‡");
  //
  //             print(finalresult);
  //             print(finalresult.length);
  //             await Delivery(
  //                 BO_SLIP: finalresult[0],
  //                 SOFFICE_ID: finalresult[1],
  //                 DOFFICE_ID: finalresult[2],
  //                 BOOK_DATE: finalresult[3],
  //                 ART_NUMBER: finalresult[4],
  //                 BOOK_ID: finalresult[5],
  //                 LINE_ITEM: double.parse(finalresult[6]),
  //                 MATNR: finalresult[7],
  //                 BAG_ID: finalresult[8],
  //                 INSURANCE: finalresult[9],
  //                 TOTAL_MONEY: double.parse(finalresult[10]),
  //                 POST_DUE: double.parse(finalresult[11]),
  //                 DEM_CHARGE: double.parse(finalresult[12]),
  //                 COMMISSION: double.parse(finalresult[13]),
  //                 SOURCE_PINCODE: int.parse(finalresult[14]),
  //                 DESTN_PINCODE: int.parse(finalresult[15]),
  //                 BO_ID: finalresult[16],
  //                 REGISTERED: finalresult[17],
  //                 RETURN_SERVICE: finalresult[18],
  //                 COD: finalresult[19],
  //                 VPP: finalresult[20],
  //                 MONEY_TO_BE_COLLECTED: double.parse(finalresult[22]),
  //                 REDIRECTION_FEE: double.parse(finalresult[50]),
  //                 CUST_DUTY: double.parse(finalresult[51]),
  //                 REPORTING_SO_ID: finalresult[52]
  //             ).upsert(ignoreBatch: false);
  //
  //             await Addres(
  //               BO_SLIP: finalresult[0],
  //               ART_NUMBER: finalresult[4],
  //               BOOK_ID: finalresult[5],
  //               BAG_ID: finalresult[8],
  //               SEND_CUST_N: finalresult[23],
  //               SEND_ADD1: finalresult[24],
  //               SEND_ADD2: finalresult[25],
  //               SEND_ADD3: finalresult[26],
  //               SEND_STREET: finalresult[27],
  //               SEND_CITY: finalresult[28],
  //               SEND_COUNTRY: finalresult[29],
  //               SEND_STATE: finalresult[30],
  //               SEND_EMAIL: finalresult[31],
  //               SEND_PIN: int.parse(finalresult[32]),
  //               SEND_FAX: finalresult[33],
  //               SEND_MOB: finalresult[34],
  //               REC_NAME: finalresult[35],
  //               REC_ADDRESS1: finalresult[36],
  //               REC_ADDRESS2: finalresult[37],
  //               REC_ADDRESS3: finalresult[38],
  //               REC_COUNTRY: finalresult[39],
  //               REC_STATE: finalresult[40],
  //               REC_STREET: finalresult[41],
  //               REC_CITY: finalresult[42],
  //               REC_PIN: int.parse(finalresult[43]),
  //               REC_MOB: finalresult[44],
  //               REC_EMAIL: finalresult[45],
  //               REC_FAX: finalresult[46],
  //             ).upsert(ignoreBatch: false);
  //
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //
  //       else if(fileName=="953"){
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //             await Delivery(
  //                 BO_SLIP: finalresult[0],
  //                 SOFFICE_ID: finalresult[1],
  //                 DOFFICE_ID: finalresult[2],
  //                 BOOK_DATE: finalresult[3],
  //                 ART_NUMBER: finalresult[4],
  //                 BOOK_ID: finalresult[5],
  //                 MATNR: finalresult[6],
  //                 LINE_ITEM: finalresult[7],
  //                 COMMISSION: finalresult[8],
  //                 TOTAL_MONEY: finalresult[9],
  //                 SOURCE_PINCODE: finalresult[10],
  //                 DESTN_PINCODE: finalresult[11],
  //                 EMO_MESSAGE: finalresult[12],
  //                 BO_ID: finalresult[13],
  //                 REDIRECTION_SL: finalresult[14],
  //                 MOD_PIN: finalresult[36],
  //                 REPORTING_SO_ID: finalresult[42]
  //             ).upsert();
  //
  //             await Addres(
  //                 BO_SLIP: finalresult[0],
  //                 ART_NUMBER: finalresult[4],
  //                 BOOK_ID: finalresult[5],
  //                 SEND_CUST_N: finalresult[15],
  //                 SEND_ADD1: finalresult[16],
  //                 SEND_ADD2: finalresult[17],
  //                 SEND_ADD3: finalresult[18],
  //                 SEND_STREET: finalresult[19],
  //                 SEND_CITY: finalresult[20],
  //                 SEND_COUNTRY: finalresult[21],
  //                 SEND_STATE: finalresult[22],
  //                 SEND_EMAIL: finalresult[23],
  //                 SEND_PIN: finalresult[24],
  //                 SEND_FAX: finalresult[25],
  //                 SEND_MOB: finalresult[26],
  //                 REC_NAME: finalresult[27],
  //                 REC_ADDRESS1: finalresult[28],
  //                 REC_ADDRESS2: finalresult[29],
  //                 REC_ADDRESS3: finalresult[30],
  //                 REC_COUNTRY: finalresult[31],
  //                 REC_STATE: finalresult[32],
  //                 REC_STREET: finalresult[33],
  //                 REC_CITY: finalresult[34],
  //                 REC_PIN: finalresult[35],
  //                 REC_MOB: finalresult[37],
  //                 REC_EMAIL: finalresult[38],
  //                 REC_FAX: finalresult[39]
  //             ).upsert();
  //
  //             // print("Insertion completed");
  //
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //       else if(fileName=="957"){
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //
  //             await BOSLIP_STAMP1(
  //                 BO_SLIP_NO: finalresult[0],
  //                 ZMOFACILITYID: finalresult[1],
  //                 MATNR: finalresult[2],
  //                 ZINV_PARTICULAR: finalresult[3],
  //                 MENGE_D: finalresult[4],
  //                 ZCREATEDT: finalresult[5],
  //                 ZMOCREATEDBY: finalresult[6]
  //             ).upsert();
  //
  //
  //             print("Insertion completed");
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //       else if(fileName=="959"){
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //
  //             await BOSLIP_CASH1(
  //                 BO_SLIP_NO: finalresult[0],
  //                 DATE_OF_SENT: finalresult[1],
  //                 SO_PROFIT_CENTER: finalresult[3],
  //                 BO_PROFIT_CENTER: finalresult[4],
  //                 AMOUNT: finalresult[5],
  //                 WEIGHT_OF_CASH_BAG: finalresult[6],
  //                 CHEQUE_NO: finalresult[2],
  //                 CHEQUE_AMOUNT: finalresult[7],
  //                 CASHORCHEQUE: finalresult[8]
  //             ).upsert();
  //
  //
  //             print("Insertion completed");
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //       else if(fileName=="961"){
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //
  //             await BOSLIP_DOCUMENT1(
  //                 BO_SLIP_NO: finalresult[0],
  //                 DOCUMENT_DETAILS: finalresult[3],
  //                 TOOFFICE: finalresult[2]
  //             ).upsert();
  //
  //
  //             print("Insertion completed");
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //       else if(fileName=="964"){
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             // print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //             for (int i = 0; i < finalresult.length; i++) {
  //               print(finalresult[i]);
  //             }
  //             await BSRDETAILS_NEW(
  //               BOSLIPID: finalresult[0],
  //               BO_SLIP_DATE: finalresult[1],
  //               BAGNUMBER: finalresult[3],
  //               CLOSING_BALANCE: finalresult[4],
  //               CB_DATE: finalresult[5],
  //               CASH_STATUS: finalresult[6],
  //               STAMP_STATUS: finalresult[7],
  //               DOCUMENT_STATUS: finalresult[8],
  //             ).upsert();
  //
  //
  //             print("Insertion completed");
  //           }  final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //           print("Exited insertion loop");
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //       }
  //       if(fileName=="384"){
  //         print("fileName: $fileName");
  //         print("TRue");
  //         final input = new File(entities[i].path).openRead();
  //         final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //         print(fields);
  //         print(fields[0][0].split("\n").length);
  //         try {
  //           for (int i = 0; i < fields.length; i++) {
  //             print("Entered Loop");
  //             List finalresult = fields[i].toString().replaceAll("[", "").replaceAll(
  //                 "]", "").trim().split("‡");
  //             print(finalresult);
  //
  //             await BAGDETAILS_NEW(
  //                 FROMOFFICE: finalresult[4],
  //                 TOOFFICE: finalresult[5],
  //                 TDATE: finalresult[6],
  //                 BAGNUMBER: finalresult[3],
  //                 BOSLIPNO: finalresult[8],
  //                 NO_OF_ARTICLES: finalresult[9]
  //             ).upsert();
  //
  //             await DESPATCHBAG(
  //                 SCHEDULE: finalresult[0],
  //                 SCHEDULED_TIME: finalresult[1],
  //                 MAILLIST_TO_OFFICE: finalresult[2],
  //                 BAGNUMBER: finalresult[3],
  //                 FROM_OFFICE: finalresult[4],
  //                 TO_OFFICE: finalresult[5],
  //                 REMARKS: finalresult[7]
  //             ).upsert();
  //             print("Insertion completed");
  //           }
  //           final List<dynamic>? result = await DeliveryModel().batchCommit(continueOnError: false);
  //         }catch(e){
  //           print("Error in DB Insertion: "+e.toString());
  //           DeliveryModel().batchRollback();
  //         }
  //         print("Exited insertion loop");
  //       }
  //
  //       ///Switch On Acknowledgement
  //       if (entities[i].toString().substring(38, 48) == 'ACK_BOLIVE') {
  //         subRes.clear();
  //         final file = File(entities[i].path);
  //         List<int> firstLine = [];
  //         List<int> second = [];
  //         int firstLineLast = 0;
  //         List<int> s1 = file.readAsBytesSync();
  //         Uint8List list = Uint8List.fromList(s1);
  //         try {
  //           for (int i = 0; i < list.length; i++) {
  //             if (list[i] != 10) {
  //               firstLine.add(list[i]);
  //             } else {
  //               firstLineLast = i;
  //               break;
  //             }
  //           }
  //         } catch (e) {
  //           print("Error is $e");
  //         }
  //         try {
  //           for (int i = firstLineLast+1; i < list.length; i++) {
  //             if (list[i] == 135) {
  //               list[i] = 1;
  //             }
  //             second.add(list[i]);
  //           }
  //         } catch (e) {
  //           print("Error in second is $e");
  //         }
  //         List acknowledgeResult = utf8.decode(firstLine).toString().split("‡");
  //         final ackAcknowledge = SwitchOnAcknowledge()
  //           ..ParentOfficeNumber = acknowledgeResult[0]
  //           ..OfficeId = acknowledgeResult[1]
  //           ..BOSequenceId = acknowledgeResult[2]
  //           ..OfficeName = acknowledgeResult[3]
  //           ..LegacyCode = acknowledgeResult[4]
  //           ..SanctionedLimit = acknowledgeResult[5]
  //           ..CashBalance = acknowledgeResult[6];
  //         ackAcknowledge.upsert();
  //
  //
  //
  //         List acknowledgementResult = utf8.decode(second).toString().split("");
  //         List ackResult = acknowledgementResult.toString().replaceAll(",", "\n").replaceAll("]", "").split("\n");
  //         final acknowledgement = SwitchOnAcknowledgement()
  //           ..LegacyUpdation = ackResult[1]
  //           ..SanctionedDeletion = ackResult[3]
  //           ..SanctionedInsertion = ackResult[5]
  //           ..UpdateWallet = ackResult[7]
  //           ..InsertionClosingBalance = ackResult[9]
  //           ..InsertionOpeningBalance = ackResult[11]
  //           ..InsertionOpeningStock = ackResult[13];
  //         acknowledgement.upsert();
  //       }
  //
  //       ///Leave Balance
  //       if (entities[i].toString().substring(38, 43) == 'Leave') {
  //         subRes.clear();
  //         final leaveFile = File(entities[i].path).openRead();
  //         final leaveFields = await leaveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < leaveFields.length; i++) {
  //           List leaveResult = leaveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < leaveResult.length; i++) {
  //             subRes.add(leaveResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final updateLeave = LeaveBalanceTable()
  //                 ..EmployeeNumber = subRes[i][0]
  //                 ..QuotaType = subRes[i][1]
  //                 ..LeaveBalance = subRes[i][2];
  //               updateLeave.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Leave Balance', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///VPP MO Commission
  //       if (entities[i].toString().substring(38, 41) == 'VPP') {
  //         subRes.clear();
  //         final vppMOFile = File(entities[i].path).openRead();
  //         final vppMOFields = await vppMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < vppMOFields.length; i++) {
  //           List vppMOResult = vppMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < vppMOResult.length; i++) {
  //             subRes.add(vppMOResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addVppMO = VppMOCommission()
  //                 ..Commission = subRes[i][0]
  //                 ..MinimumAmount = subRes[i][1]
  //                 ..MaximumAmount = subRes[i][2]
  //                 ..CommissionAmount = subRes[i][3]
  //                 ..AdditionalService = subRes[i][4]
  //                 ..ValueID = subRes[i][5]
  //                 ..Identifier = subRes[i][6];
  //               addVppMO.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-VPP', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Ins MO Commission
  //       if (entities[i].toString().substring(38, 41) == 'INS') {
  //         subRes.clear();
  //         final insMOFile = File(entities[i].path).openRead();
  //         final insMOFields = await insMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < insMOFields.length; i++) {
  //           List insMOResult = insMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < insMOResult.length; i++) {
  //             subRes.add(insMOResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addINSMO = InsMOCommission()
  //                 ..Commission = subRes[i][0]
  //                 ..MinimumAmount = subRes[i][1]
  //                 ..MaximumAmount = subRes[i][2]
  //                 ..CommissionAmount = subRes[i][3]
  //                 ..AdditionalService = subRes[i][4]
  //                 ..ValueID = subRes[i][5]
  //                 ..Identifier = subRes[i][6];
  //               addINSMO.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-INS', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///EMO MO Commission
  //       if (entities[i].toString().substring(38, 41) == 'EMO') {
  //         subRes.clear();
  //         final emoMOFile = File(entities[i].path).openRead();
  //         final emoMOFields = await emoMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < emoMOFields.length; i++) {
  //           List emoMOResult = emoMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < emoMOResult.length; i++) {
  //             subRes.add(emoMOResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addEMOMO = EmoMOCommission()
  //                 ..Commission = subRes[i][0]
  //                 ..MinimumAmount = subRes[i][1]
  //                 ..MaximumAmount = subRes[i][2]
  //                 ..CommissionAmount = subRes[i][3]
  //                 ..AdditionalService = subRes[i][4]
  //                 ..ValueID = subRes[i][5]
  //                 ..Identifier = subRes[i][6];
  //               addEMOMO.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-EMO', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Products Master
  //       if (entities[i].toString().substring(38, 45) == 'Product') {
  //         subRes.clear();
  //         final productsFile = File(entities[i].path).openRead();
  //         final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 1; i < productFields.length; i++) {
  //           subRes.add(productFields[i].toString().split("‡"));
  //         }
  //         for (int i = 0; i < subRes.length; i++) {
  //           if (subRes[i].toString().isNotEmpty) {
  //             final addProduct = ProductsMaster()
  //               ..ItemCode = subRes[i][0]
  //               ..ShortDescription = subRes[i][1]
  //               ..CategoryDescription = subRes[i][2]
  //               ..SalePrice = subRes[i][3]
  //               ..EffStartDate = subRes[i][4]
  //               ..EffEndDate = subRes[i][5]
  //               ..POSCurrentStock = subRes[i][6]
  //               ..OpeningStock = subRes[i][7]
  //               ..Division = subRes[i][8]
  //               ..OrderType = subRes[i][9]
  //               ..MaterialGroup = subRes[i][10]
  //               ..UnitMeasurement = subRes[i][11]
  //               ..CreatedBy = subRes[i][12]
  //               ..CreatedOn = subRes[i][13]
  //               ..ModifiedBy = subRes[i][14]
  //               ..ModifiedOn = subRes[i][15]
  //               ..Identifier = subRes[i][16];
  //             addProduct.upsert();
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///WeightMaster
  //       if (entities[i].toString().substring(38, 44) == 'Weight') {
  //         subRes.clear();
  //         final weightFile = File(entities[i].path).openRead();
  //         final weightFields = await weightFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < weightFields.length; i++) {
  //           List weightResult = weightFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < weightResult.length; i++) {
  //             subRes.add(weightResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addWeight = WeightMaster()
  //                 ..WeightId = subRes[i][0]
  //                 ..MinimumWeight = subRes[i][1]
  //                 ..MaximumWeight = subRes[i][2]
  //                 ..ServiceId = subRes[i][3]
  //                 ..Identifier = subRes[i][4];
  //               addWeight.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Weight Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Distance Master
  //       if (entities[i].toString().substring(38, 52) == 'DistanceMaster') {
  //         subRes.clear();
  //         final distanceFile = File(entities[i].path).openRead();
  //         final distanceFields = await distanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < distanceFields.length; i++) {
  //           List distanceResult = distanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < distanceResult.length; i++) {
  //             subRes.add(distanceResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addDistance = DistanceMaster()
  //                 ..Distance = subRes[i][0]
  //                 ..MinDistance = subRes[i][1]
  //                 ..MaxDistance = subRes[i][2]
  //                 ..Service = subRes[i][3]
  //                 ..Identifier = subRes[i][4];
  //               addDistance.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Distance Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Local Store
  //       if (entities[i].toString().substring(38, 43) == 'Local') {
  //         subRes.clear();
  //         final localStoreFile = File(entities[i].path).openRead();
  //         final localStoreFields = await localStoreFile.transform(utf8.decoder).transform(
  //             const CsvToListConverter()).toList();
  //         for (int i = 0; i < localStoreFields.length; i++) {
  //           List localStoreResult = localStoreFields.toString().replaceAll("[", "")
  //               .replaceAll("]", "")
  //               .split("\n");
  //           for (int i = 1; i < localStoreResult.length; i++) {
  //             subRes.add(localStoreResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addLocalStore = LocalStoreTable()
  //                 ..ParentOfficeId = subRes[i][0]
  //                 ..ParentOfficeName = subRes[i][1]
  //                 ..OfficeId = subRes[i][2]
  //                 ..BOSequenceId = subRes[i][3]
  //                 ..OfficeName = subRes[i][4]
  //                 ..Address = subRes[i][5]
  //                 ..Pin = subRes[i][6]
  //                 ..Latitude = subRes[i][7]
  //                 ..Longitude = subRes[i][8]
  //                 ..City = subRes[i][9]
  //                 ..StateCode = subRes[i][10]
  //                 ..StateName = subRes[i][11]
  //                 ..SolutionId = subRes[i][12]
  //                 ..LegacyCode = subRes[i][13]
  //                 ..CircleCode = subRes[i][14]
  //                 ..Circle = subRes[i][15]
  //                 ..CreatedBy = subRes[i][16]
  //                 ..CreatedOn = subRes[i][17]
  //                 ..ModifiedBy = subRes[i][18]
  //                 ..ModifiedOn = subRes[i][19]
  //                 ..IsStoreBegin = subRes[i][20]
  //                 ..WalkInCustomerId = subRes[i][21]
  //                 ..Identifier = subRes[i][22];
  //               addLocalStore.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Local Store Details', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Additional Service Mapping
  //       if (entities[i].toString().substring(38, 41) == 'Add') {
  //         subRes.clear();
  //         final additionalServiceMappingFile = File(entities[i].path).openRead();
  //         final additionalServiceMappingFields = await additionalServiceMappingFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < additionalServiceMappingFields.length; i++) {
  //           List additionalServiceMappingResult = additionalServiceMappingFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < additionalServiceMappingResult.length; i++) {
  //             subRes.add(additionalServiceMappingResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addTax = AdditionalServiceMappingTable()
  //                 ..ServiceId = subRes[i][0]
  //                 ..AdditionalServiceId = subRes[i][1]
  //                 ..AdditionalServicePrice = subRes[i][2]
  //                 ..Identifier = subRes[i][3];
  //               addTax.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Additional Service Mapping', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Tax master
  //       if (entities[i].toString().substring(38, 47) == 'TaxMaster') {
  //         subRes.clear();
  //         final taxFile = File(entities[i].path).openRead();
  //         final taxFields = await taxFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < taxFields.length; i++) {
  //           List taxResult = taxFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < taxResult.length; i++) {
  //             subRes.add(taxResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addTax = TaxMaster()
  //                 ..Service = subRes[i][0]
  //                 ..PercentageValue = subRes[i][1]
  //                 ..TaxDescription = subRes[i][2]
  //                 ..Identifier = subRes[i][3];
  //               addTax.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Tax Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Switch On
  //       if (entities[i].toString().substring(38, 44) == 'BOLIVE') {
  //         subRes.clear();
  //         final boLiveFile = File(entities[i].path).openRead();
  //         final boLiveFields = await boLiveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < boLiveFields.length; i++) {
  //           List boLiveResult = boLiveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < boLiveResult.length; i++) {
  //             subRes.add(boLiveResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addSwitch = SwitchOnTable()
  //                 ..ParentOfficeId = subRes[i][0]
  //                 ..OfficeId = subRes[i][1]
  //                 ..BOSequenceId = subRes[i][2]
  //                 ..OfficeName = subRes[i][3]
  //                 ..LegacyCode = subRes[i][4]
  //                 ..SanctionedLimit = subRes[i][5]
  //                 ..CashBalance = subRes[i][6];
  //               addSwitch.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Switch On', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Service master
  //       if (entities[i].toString().substring(38, 45) == 'Service') {
  //         subRes.clear();
  //         final serviceFile = File(entities[i].path).openRead();
  //         final serviceFields = await serviceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < serviceFields.length; i++) {
  //           List serviceResult = serviceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < serviceResult.length; i++) {
  //             subRes.add(serviceResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if (subRes[i].toString().isNotEmpty) {
  //               final addService = ServiceMaster()
  //                 ..ServiceId = subRes[i][0]
  //                 ..ServiceName = subRes[i][1]
  //                 ..MinimumWeight = subRes[i][2]
  //                 ..MaximumWeight = subRes[i][3]
  //                 ..Division = subRes[i][4]
  //                 ..OrderType = subRes[i][5]
  //                 ..ProductType = subRes[i][6]
  //                 ..MaterialGroup = subRes[i][7]
  //                 ..Identifier = subRes[i][8];
  //               addService.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Service Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Tariff Master
  //       if (entities[i].toString().substring(38, 50) == 'TariffMaster') {
  //         subRes.clear();
  //         final tariffFile = File(entities[i].path).openRead();
  //         final tariffFields = await tariffFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < tariffFields.length; i++) {
  //           List tariffResult = tariffFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 1; i < tariffResult.length; i++) {
  //             subRes.add(tariffResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if(subRes[i].toString().isNotEmpty) {
  //               final addTariff = TariffMaster()
  //                 ..Service = subRes[i][0]
  //                 ..WeightId = subRes[i][1]
  //                 ..Distance = subRes[i][2]
  //                 ..BasePrice = subRes[i][3]
  //                 ..Identifier = subRes[i][4];
  //               addTariff.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Tariff Master', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Cash Indent
  //       if (entities[i].toString().substring(56, 58) == 'CI') {
  //         subRes.clear();
  //         final cashIndentFile = File(entities[i].path).openRead();
  //         final cashIndentFields = await cashIndentFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < cashIndentFields.length; i++) {
  //           List cashIndentResult = cashIndentFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 0; i < cashIndentResult.length; i++) {
  //             subRes.add(cashIndentResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if(subRes[i].toString().isNotEmpty) {
  //               final addCashIndent = CashIndentTable()
  //                 ..BOID = subRes[i][0]
  //                 ..Date = subRes[i][1]
  //                 ..Time = subRes[i][2]
  //                 ..BOName = subRes[i][3]
  //                 ..HOName = subRes[i][4]
  //                 ..Amount1 = subRes[i][5]
  //                 ..Amount2 = subRes[i][6]
  //                 ..Amount3 = subRes[i][7]
  //                 ..AmountType = subRes[i][8];
  //               addCashIndent.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Cash Indent', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Special Remittance
  //       if (entities[i].toString().substring(56, 58) == 'SR') {
  //         subRes.clear();
  //         final specialRemittanceFile = File(entities[i].path).openRead();
  //         final specialRemittanceFields = await specialRemittanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < specialRemittanceFields.length; i++) {
  //           List specialRemittanceResult = specialRemittanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 0; i < specialRemittanceResult.length; i++) {
  //             subRes.add(specialRemittanceResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length - 1; i++) {
  //             if(subRes[i].toString().isNotEmpty) {
  //               final addSpecialRemittance = SpecialRemittanceTable()
  //                 ..SpecialRemittanceId = subRes[i][0]
  //                 ..Date = subRes[i][1]
  //                 ..Time = subRes[i][2]
  //                 ..BOName = subRes[i][3]
  //                 ..HOName = subRes[i][4]
  //                 ..Amount1 = subRes[i][5]
  //                 ..Amount2 = subRes[i][6]
  //                 ..Amount3 = subRes[i][7]
  //                 ..AmountType = subRes[i][8];
  //               addSpecialRemittance.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Special Remittance', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Excess Cash
  //       if (entities[i].toString().substring(56, 58) == 'EC') {
  //         subRes.clear();
  //         final excessCashFile = File(entities[i].path).openRead();
  //         final excessCashFields = await excessCashFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < excessCashFields.length; i++) {
  //           List excessCashResult = excessCashFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 0; i < excessCashResult.length; i++) {
  //             subRes.add(excessCashResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length; i++) {
  //             if(subRes[i].toString().isNotEmpty) {
  //               final addExcessCash = ExcessCashTable()
  //                 ..BOID = subRes[i][0]
  //                 ..Date = subRes[i][1]
  //                 ..Time = subRes[i][2]
  //                 ..BOName = subRes[i][3]
  //                 ..HOName = subRes[i][4]
  //                 ..Amount1 = subRes[i][5]
  //                 ..Amount2 = subRes[i][6]
  //                 ..Amount3 = subRes[i][7]
  //                 ..AmountType = subRes[i][8]
  //                 ..Amount4 = subRes[i][9];
  //               addExcessCash.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Excess Cash', DateTimeDetails().currentDateTime());
  //       }
  //
  //       ///Setup Inventory
  //       if (entities[i].toString().substring(38, 43) == 'SetUp') {
  //         subRes.clear();
  //         final inventoryFile = await File(entities[i].path).openRead();
  //         final inventoryFields = await inventoryFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
  //         for (int i = 0; i < inventoryFields.length; i++) {
  //           List inventoryResult = inventoryFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
  //           for (int i = 0; i < inventoryResult.length; i++) {
  //             subRes.add(inventoryResult[i].toString().split("‡"));
  //           }
  //           for (int i = 0; i < subRes.length; i++) {
  //             if(subRes[i].toString().isNotEmpty) {
  //               final addExcessCash = SetUpInventoryTable()
  //                 ..BOId = subRes[i][0]
  //                 ..InventoryName = subRes[i][1]
  //                 ..Column1 = subRes[i][2]
  //                 ..Column2 = subRes[i][3];
  //               addExcessCash.upsert();
  //             }
  //           }
  //         }
  //         addFileToDB(entities[i].toString(), dir.toString(), 'Setup Inventory', DateTimeDetails().currentDateTime());
  //       }
  //
  //
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   await File("storage/emulated/0/Darpan_Mine/DownloadCSV/$officeId.zip").rename("storage/emulated/0/Darpan_Mine/Exports/${DateTimeDetails().onlyDate()}$officeId.zip");
  //
  //
  // }

  Future<void> upload() async {
    ByteData? secdata;
    secdata =
        await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
    // ByteData secdata = await PlatformAssetBundle().load('assets/certificate/star_cept.crt');
    //
    // SecurityContext.defaultContext.setTrustedCertificatesBytes(secdata.buffer.asUint8List());
    print("Inside Upload Before Try");
    try {
      SecurityContext.defaultContext
          .setTrustedCertificatesBytes(secdata.buffer.asUint8List());
    } catch (Error) {
      SecurityContext.defaultContext
          .useCertificateChainBytes(secdata.buffer.asUint8List());
    }
    //var bodetails="BO20105103003";
    final ofcMaster = await OFCMASTERDATA().select().toList();
    print("Office Master" + ofcMaster.toString());

    try {
      if (ofcMaster.length > 0) {
        var bodetails = ofcMaster[0].BOFacilityID.toString();

        print("Inside Upload");

        var artDelivered = "SELECT A.ART_NUMBER AS A_ART_NUMBER,strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY) AS B_DATE_OF_DELIVERY,DELIVERY_TIME AS C_DELIVERY_TIME,strftime('" +
            frm3 +
            "',DEL_DATE) AS D_DEL_DATE," +
            " BEAT_NO AS E_BEAT_NO,ART_STATUS AS F_ART_STATUS,(MONEY_TO_BE_COLLECTED+COMMISSION+POST_DUE+DEM_CHARGE) AS G_TOTAL_MONEY," +
            " strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY_CONFIRM)  AS H_DATE_OF_DELIVERY_CONFIRM,TIME_OF_DELIVERY_CONFIRM AS I_TIME_OF_DELIVERY_CONFIRM,BO_ID AS J_BO_ID," +
            " POST_DUE AS K_POST_DUE,DEM_CHARGE AS L_DEM_CHARGE,COMMISSION AS M_COMMISSION,MATNR AS N_MATNR,WINDOW_DELIVERY AS O_WINDOW_DELIVERY," +
            " ID_PROOF_DOC AS P_ID_PROOF_DOC,ID_PROOF_NMBR AS Q_ID_PROOF_NMBR,ISSUING_AUTHORITY AS R_ISSUING_AUTHORITY,strftime('" +
            frm3 +
            "',ID_PROOF_VALIDITY_DATE) AS S_ID_PROOF_VALIDITY_DATE," +
            " strftime('" +
            frm3 +
            "',ART_RECEIVE_DATE) AS T_ART_RECEIVE_DATE_AT_BO,ART_RECEIVE_TIME AS U_ART_RECEIVE_TIME_AT_BO,REC_NAME AS V_REC_NAME,REC_ADDRESS1 AS W_REC_ADDRESS1," +
            " REC_ADDRESS2 AS X_REC_ADDRESS2,REC_ADDRESS3 AS Y_REC_ADDRESS3,REC_CITY AS ZA_REC_CITY,REC_PIN AS ZB_REC_PIN,BOOK_DATE AS ZC_BOOK_DATE," +
            " VPP AS ZD_VPP,REGISTERED AS ZE_REGISTERED,RETURN_SERVICE AS ZF_RETURN_SERVICE,COD AS ZG_COD,CASH_ID AS ZH_BELNR,INSURANCE AS ZI_INSURANCE," +
            " '' AS ZJ_ACK,'3' AS ZK_PERNR,REDIRECTION_FEE AS ZL_REDIRECTION_FEE,CUST_DUTY AS ZM_CUSTOM_DUTY,SOFFICE_ID AS ZN_SOFFICE_ID,REPORTING_SO_ID AS ZO_REPORTING_SO_ID, " +
            " DOFFICE_ID AS ZP_DOFFICE_ID,MONEY_TO_BE_COLLECTED AS ZQ_MONEY_TO_BE_COLLECTED,TOTAL_MONEY AS ZR_TOTAL_MONEY FROM DELIVERY A,ADDRESS B WHERE " +
            " A.ART_NUMBER = B.ART_NUMBER AND  "
            // "DATETIME(A.REMARK_DATE,A.DELIVERY_TIME) < DATETIME ('now','-30 minutes','localtime') AND "
            // "IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL AND ART_STATUS = 'D' AND " +
                "IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL AND ART_STATUS in ('D','Delivered') AND " +
            " UPPER(MATNR) NOT IN (SELECT DISTINCT UPPER(ARTICLECODE) FROM ARTICLEMASTER WHERE UPPER(ARTICLETYPE)='EMO') and FILE_NAME IS NULL";

        var emoDelivered = "SELECT A.ART_NUMBER AS A_ART_NUMBER,strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY) AS B_DATE_OF_DELIVERY,DELIVERY_TIME AS C_DELIVERY_TIME,strftime('" +
            frm3 +
            "',DEL_DATE) AS D_DEL_DATE,"
                " BEAT_NO AS E_BEAT_NO,ART_STATUS AS F_ART_STATUS,strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY_CONFIRM) AS G_DATE_OF_DELIVERY_CONFIRM,TIME_OF_DELIVERY_CONFIRM AS H_TIME_OF_DELIVERY_CONFIRM,"
                " BO_ID AS I_BO_ID,MATNR AS J_MATNR,WINDOW_DELIVERY AS K_WINDOW_DELIVERY,ID_PROOF_DOC AS L_ID_PROOF_DOC,ID_PROOF_NMBR AS M_ID_PROOF_NMBR,"
                " ISSUING_AUTHORITY AS N_ISSUING_AUTHORITY,strftime('" +
            frm3 +
            "',ID_PROOF_VALIDITY_DATE) AS O_ID_PROOF_VALIDITY_DATE,REC_NAME AS P_REC_NAME,BOOK_DATE AS Q_BOOK_DATE,"
                " TOTAL_MONEY AS R_MONEY_DELIVERED,DESTN_PINCODE AS S_PAYINGPIN,ART_RECEIVE_DATE  AS T_ART_RECEIVE_DATE,ART_RECEIVE_TIME AS U_ART_RECEIVE_TIME "
            //"strftime('"+frm3+"',ART_RECEIVE_DATE) "

                " ,SOFFICE_ID AS V_SOFFICE_ID,REPORTING_SO_ID AS W_REPORTING_SO_ID,DOFFICE_ID AS X_DOFFICE_ID "
                " FROM DELIVERY A,ADDRESS B WHERE A.ART_NUMBER = B.ART_NUMBER AND IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL " +
            // " FROM DELIVERY A,ADDRESS B WHERE A.ART_NUMBER = B.ART_NUMBER AND  DATETIME(A.REMARK_DATE,A.DELIVERY_TIME) < DATETIME ('now','-30 minutes','localtime') AND IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL "+
            " AND ART_STATUS = 'F' AND UPPER(MATNR) IN (SELECT DISTINCT UPPER(ARTICLECODE) FROM ARTICLEMASTER WHERE UPPER(ARTICLETYPE)='EMO') ";

        var artUndelivered = "SELECT A.ART_NUMBER AS A_ART_NUMBER,strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY) AS B_DATE_OF_DELIVERY,BEAT_NO AS C_BEAT_NO,ART_STATUS AS D_ART_STATUS,BO_ID AS E_BO_ID," +
            " REASON_FOR_NONDELIVERY AS F_REASON_FOR_NONDELIVERY,REASON_TYPE AS G_REASON_TYPE,ACTION AS H_ACTION,strftime('" +
            frm3 +
            "',DATE_OF_1ST_DELIVERY_CONFIRM) AS I_DATE_OF_1ST_DELIVERY_CONFIRM," +
            " RT AS J_RT,strftime('" +
            frm3 +
            "',RT_DATE) AS K_RT_DATE,RT_TIME AS L_RT_TIME,RD AS M_RD,strftime('" +
            frm3 +
            "',RD_DATE) AS N_RD_DATE,RD_TIME AS O_RD_TIME,REC_NAME AS P_RECIPIENT_NAME," +
            " REDIRECT_REC_ADD1 AS Q_REDIRECT_REC_ADD1,REDIRECT_REC_ADD2 AS R_REDIRECT_REC_ADD2,REDIRECT_REC_ADD3 AS S_REDIRECT_REC_ADD3," +
            " A.MOD_PIN AS T_MOD_PIN,MATNR AS U_MATNR, strftime('" +
            frm3 +
            "',ART_RECEIVE_DATE)  AS V_ART_RECEIVE_DATE_AT_BO,ART_RECEIVE_TIME AS W_ART_RECEIVE_TIME_AT_BO," +
            " VPP AS X_VPP,REGISTERED AS Y_REGISTERED,RETURN_SERVICE AS ZA_RETURN_SERVICE,COD AS ZB_COD,INSURANCE AS ZC_INSURANCE,'3' AS ZD_PERNR," +
            " REDIRECTION_FEE AS ZE_REDIRECTION_FEE,'0' AS ZF_CUSTOM_DUTY,SOFFICE_ID AS ZG_SOFFICE_ID,REPORTING_SO_ID AS ZH_REPORTING_SO_ID, " +
            " DOFFICE_ID AS ZI_DOFFICE_ID,MONEY_TO_BE_COLLECTED AS ZJ_MONEY_TO_BE_COLLECTED,TOTAL_MONEY AS ZK_TOTAL_MONEY,POST_DUE AS ZL_POST_DUE, " +
            " DEM_CHARGE AS ZM_DEM_CHARGE,COMMISSION AS ZN_COMMISSION FROM DELIVERY A,ADDRESS B WHERE A.ART_NUMBER = B.ART_NUMBER AND " +
            // " DATETIME(A.REMARK_DATE,A.DELIVERY_TIME) < DATETIME ('now','-30 minutes','localtime') AND "
            "IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL AND ART_STATUS IN ('N','O') " +
            " AND UPPER(MATNR) NOT IN (SELECT DISTINCT UPPER(ARTICLECODE) FROM ARTICLEMASTER WHERE UPPER(ARTICLETYPE)='EMO') ";

        var emoUndelivered = "SELECT A.ART_NUMBER AS A_ART_NUMBER,strftime('" +
            frm3 +
            "',DATE_OF_DELIVERY) AS B_DATE_OF_DELIVERY,BEAT_NO AS C_BEAT_NO,ART_STATUS AS D_ART_STATUS,BO_ID AS E_BO_ID," +
            " REASON_FOR_NONDELIVERY AS F_REASON_FOR_NONDELIVERY,REASON_TYPE AS G_REASON_TYPE,ACTION AS H_ACTION,strftime('" +
            frm3 +
            "',DATE_OF_1ST_DELIVERY_CONFIRM) AS I_DATE_OF_1ST_DELIVERY_CONFIRM," +
            " RT AS J_RT,strftime('" +
            frm3 +
            "',RT_DATE) AS K_RT_DATE,RT_TIME AS L_RT_TIME,RD AS M_RD,strftime('" +
            frm3 +
            "',RD_DATE) AS N_RD_DATE,RD_TIME AS O_RD_TIME,REC_NAME AS P_RECIPIENT_NAME," +
            " REDIRECT_REC_ADD1 AS Q_REDIRECT_REC_ADD1,REDIRECT_REC_ADD2 AS R_REDIRECT_REC_ADD2,REDIRECT_REC_ADD3 AS S_REDIRECT_REC_ADD3,REDIRECT_REC_PIN AS T_REDIRECT_REC_PIN," +
            " A.MOD_PIN AS U_MOD_PIN,MATNR AS V_MATNR, ART_RECEIVE_DATE AS W_ART_RECEIVE_DATE,ART_RECEIVE_TIME AS X_ART_RECEIVE_TIME," +
            " REDIRECTION_SL AS Y_REDIRECTION_SL,SOFFICE_ID AS ZA_SOFFICE_ID,REPORTING_SO_ID AS ZB_REPORTING_SO_ID,DOFFICE_ID AS ZC_DOFFICE_ID " +
            " FROM DELIVERY A,ADDRESS B WHERE A.ART_NUMBER = B.ART_NUMBER AND" + // DATETIME(A.REMARK_DATE,A.DELIVERY_TIME) < DATETIME ('now','-30 minutes','localtime') AND
            " IS_COMMUNICATED IS NULL AND FILE_NAME IS NULL AND ART_STATUS IN ('G','O') " +
            " AND UPPER(MATNR) IN (SELECT DISTINCT UPPER(ARTICLECODE) FROM ARTICLEMASTER WHERE UPPER(ARTICLETYPE)='EMO') ";

        var bagClosed =
            "SELECT A.BAGNUMBER AS  AAA_Bagnumber, B.TOOFFICE As AA_To_Office, A.ART_NUMBER AS A_ART_NUMBER,A.MATNR AS D_Article_Type FROM " +
                " CLOSEARTDETAILS A JOIN BAGDETAILS_NEW B ON A.BAGNUMBER= B.BAGNUMBER WHERE A.IS_COMMUNICATED IS NULL AND  B.IS_COMMUNICATED IS NULL AND  B.FROMOFFICE='" +
                bodetails +
                "'";

        var despatchBag = "SELECT A.SCHEDULE AS A_schedule,strftime('" +
            frm1 +
            "',A.SCHEDULED_TIME) AS B_scheduledtime,A.MAILLIST_TO_OFFICE AS C_mtooffice," +
            " A.BAGNUMBER AS D_bagnumber,A.FROM_OFFICE  AS E_fromoffice,A.TO_OFFICE AS F_tooffice, strftime('" +
            frm2 +
            "',B.TDATE) AS G_closing_date," +
            " A.REMARKS as H_remarks FROM DESPATCHBAG A JOIN BAGDETAILS_NEW B ON A.BAGNUMBER=B.BAGNUMBER  WHERE A.IS_COMMUNICATED IS NULL AND " +
            " B.IS_COMMUNICATED IS NULL AND  A.FROM_OFFICE ='" +
            bodetails +
            "'";

        var bagreceived =
            "SELECT Distinct BAGNUMBER AS A_bagnumber FROM BAGDETAILS_NEW WHERE BAGSTATUS='R' AND IS_COMMUNICATED IS NULL";

        var artreceived =
            "SELECT A.BAGNUMBER AS AA_bagnumber,A.ART_NUMBER AS A_ART_NUMBER,A.STATUS AS B_STATUS,'' AS C_REMARKS FROM RECEIVEDARTDETAILS A JOIN BAGDETAILS_NEW B ON A.BAGNUMBER = B.BAGNUMBER " +
                " WHERE A.IS_COMMUNICATED IS NULL AND B.BAGSTATUS='R' AND B.IS_COMMUNICATED = 'Y'";

        var stampnstationary =
            "SELECT BO_SLIP_NO AS A_BO_SLIP_NO,ZCREATEDT AS B_ZCREATEDT,ZMOFACILITYID AS C_ZMOFACILITYID," +
                " strftime('" +
                frm3 +
                "',RECEIVE_DATE) AS D_RECEIVEDDATE,MATNR AS E_MATNR,MENGE_D AS F_MENGE_D ,ZINV_PARTICULAR AS H_ZINV_PARTICULAR " +
                " FROM BOSLIP_STAMP2 WHERE IS_COMMUNICATED IS NULL";

        var boslipcashchq =
            "SELECT  BO_SLIP_NO AS A_BO_SLIP_NO,DATE_OF_SENT AS B_DATE_OF_SENT,CHEQUE_NO AS C_CHEQUE_NO," +
                " SO_PROFIT_CENTER AS D_SO_PROFIT_CENTER, BO_PROFIT_CENTER AS E_BO_PROFIT_CENTER,AMOUNT AS F_AMOUNT," +
                " WEIGHT_OF_CASH_BAG AS G_WEIGHT_OF_CASH_BAG, CHEQUE_AMOUNT AS H_CHEQUE_AMOUNT, CASHORCHEQUE AS I_CASHORCHEQUE," +
                " LESS_CASH AS J_LESS_CASH, OVER_CASH AS K_OVER_CASH, ACTUAL_CASH AS L_ACTUAL_CASH FROM BOSLIP_CASH2 " +
                " WHERE IS_COMMUNICATED IS NULL";

        var docreceivedack =
            "SELECT A.BO_SLIP_NO AS A_BO_SLIP_NO,B.BO_SLIP_DATE AS B_BO_SLIP_DATE,A.TOOFFICE AS C_TOOFFICE,A.DOCUMENT_DETAILS AS D_DOCUMENT_DETAILS," +
                " 'YES' AS E_DOCUMENT_RECEIVED FROM BOSLIP_DOCUMENT2 A JOIN BSRDETAILS_NEW B ON A.BO_SLIP_NO=B.BOSLIPID  WHERE A.IS_COMMUNICATED IS NULL";

        var billfile = "Select * from billFile where FILE_NAME IS NULL";
        var Splfile =
            "Select * from specialRemittanceFile where FILE_NAME IS NULL";
        var Bagart =
            "Select * from bagArticlesTable where FILE_NAME IS NULL and Status = 'Added'";
        var Bagclose =
            "Select bagnumber ,articlenumber,articletype from bagArticlesTable where FILE_NAME IS NULL and Status = 'Closed'";
        var bagdispatch =
            "Select schedule,SCHEDULED_TIME ,MAILLIST_TO_OFFICE,bagnumber,FROM_OFFICE,TO_OFFICE,CLOSING_DATE,remarks from DESPATCHBAG where IS_COMMUNICATED IS NULL and REMARKS ='Despatched'";
        //  var BilTraCAncel="Select * from CancelBooking where FileTransmitted ='N' and ProductCode = 'E_PAYMENT'";
        // var ArtTraCAncel="Select * from CancelBooking where FileTransmitted ='N' and ProductCode != 'E_PAYMENT'";
        var stampack =
            "Select * from BOSLIP_STAMP1 where IS_COMMUNICATED is null and IS_RCVD='Y'";
        var cashack =
            "Select * from BOSLIP_CASH1 where IS_COMMUNICATED is null and IS_RCVD='Y'";
        var docack =
            "Select * from BOSLIP_DOCUMENT1 where IS_COMMUNICATED is null and IS_RCVD='Y'";

        final artdeliveryexec = await DeliveryModel().execDataTable(
            artDelivered);
        final artundeliveryexec =
        await DeliveryModel().execDataTable(artUndelivered);
        final emodeliveryexec = await DeliveryModel().execDataTable(
            emoDelivered);
        final emoundeliveryexec =
        await DeliveryModel().execDataTable(emoUndelivered);

        print("Executed DataTable");
        print(artdeliveryexec);
        print(artundeliveryexec);
        print(emodeliveryexec);
        print(emoundeliveryexec);

        var zipFile;
        Map deldata = artdeliveryexec.asMap();
        Map undeldata = artundeliveryexec.asMap();
        Map emodeldata = emodeliveryexec.asMap();
        Map emoundeldata = emoundeliveryexec.asMap();

        List folderfiles = [];
        print("Delivery article");
        print(deldata);
        print("un Delivery article");
        print(undeldata);

        List<List<dynamic>> artDeliveredrows = [];
        List<List<dynamic>> artunDeliveredrows = [];
        List<List<dynamic>> emoDeliveredrows = [];
        List<List<dynamic>> emoUnDeliveredrows = [];
        /*
      for (int i = 0; i < deldata.length; i++) {
        List<dynamic> row = [];

        // row.add(data[i].toString());
        row.add(deldata[i]['A_ART_NUMBER']);
        row.add(deldata[i]['B_DATE_OF_DELIVERY']);
        row.add(deldata[i]['C_DELIVERY_TIME']);
        row.add(deldata[i]['D_DEL_DATE']);
        row.add(deldata[i]['E_BEAT_NO']);
        row.add(deldata[i]['F_ART_STATUS']);
        row.add(deldata[i]['G_TOTAL_MONEY']);
        row.add(deldata[i]['H_DATE_OF_DELIVERY_CONFIRM']);
        row.add(deldata[i]['I_TIME_OF_DELIVERY_CONFIRM']);
        row.add(deldata[i]['J_BO_ID']);
        row.add(deldata[i]['K_POST_DUE']);
        row.add(deldata[i]['L_DEM_CHARGE']);
        row.add(deldata[i]['M_COMMISSION']);
        row.add(deldata[i]['N_MATNR']);
        row.add('${deldata[i]['O_WINDOW_DELIVERY'] ?? ''}');
        // row.add(deldata[i]['O_WINDOW_DELIVERY']);
        //row.add(deldata[i]['P_ID_PROOF_DOC']);
        row.add('${deldata[i]['P_ID_PROOF_DOC'] ?? ''}');
        //row.add(deldata[i]['Q_ID_PROOF_NMBR']);
        row.add('${deldata[i]['Q_ID_PROOF_NMBR'] ?? ''}');
        //row.add(deldata[i]['R_ISSUING_AUTHORITY']);
        row.add('${deldata[i]['R_ISSUING_AUTHORITY'] ?? ''}');
        //row.add(deldata[i]['S_ID_PROOF_VALIDITY_DATE']);
        row.add('${deldata[i]['S_ID_PROOF_VALIDITY_DATE'] ?? ''}');
        // row.add(deldata[i]['T_ART_RECEIVE_DATE_AT_BO']);
        row.add('${deldata[i]['T_ART_RECEIVE_DATE_AT_BO'] ?? ''}');
        // row.add(deldata[i]['U_ART_RECEIVE_TIME_AT_BO']);
        row.add('${deldata[i]['U_ART_RECEIVE_TIME_AT_BO'] ?? ''}');
        row.add(deldata[i]['V_REC_NAME']);
        row.add(deldata[i]['W_REC_ADDRESS1']);
        row.add(deldata[i]['X_REC_ADDRESS2']);
        row.add(deldata[i]['Y_REC_ADDRESS3']);
        row.add(deldata[i]['ZA_REC_CITY']);
        row.add(deldata[i]['ZB_REC_PIN']);
        row.add(deldata[i]['ZC_BOOK_DATE']);
        row.add(deldata[i]['ZD_VPP']);
        row.add(deldata[i]['ZE_REGISTERED']);
        row.add(deldata[i]['ZF_RETURN_SERVICE']);
        row.add(deldata[i]['ZG_COD']);
        //row.add(deldata[i]['ZH_BELNR']);
        row.add('${deldata[i]['ZH_BELNR'] ?? ''}');
        row.add(deldata[i]['ZI_INSURANCE']);
        row.add(deldata[i]['ZJ_ACK']);
        row.add(deldata[i]['ZK_PERNR']);
        row.add(deldata[i]['ZL_REDIRECTION_FEE']);
        row.add(deldata[i]['ZM_CUSTOM_DUTY']);
        row.add(deldata[i]['ZN_SOFFICE_ID']);
        row.add(deldata[i]['ZO_REPORTING_SO_ID']);
        row.add(deldata[i]['ZP_DOFFICE_ID']);
        row.add(deldata[i]['ZQ_MONEY_TO_BE_COLLECTED']);
        row.add(deldata[i]['ZR_TOTAL_MONEY']);
        artDeliveredrows.add(row);
        print(row);
      }
      for (int i = 0; i < undeldata.length; i++) {
        List<dynamic> row = [];
        // row.add(data[i].toString());
        row.add(undeldata[i]['A_ART_NUMBER']);
        row.add(undeldata[i]['B_DATE_OF_DELIVERY']);
        row.add(undeldata[i]['C_BEAT_NO']);
        row.add(undeldata[i]['D_ART_STATUS']);
        row.add(undeldata[i]['E_BO_ID']);
        row.add(undeldata[i]['F_REASON_FOR_NONDELIVERY']);
        row.add(undeldata[i]['G_REASON_TYPE']);
        row.add(undeldata[i]['H_ACTION']);
        //row.add(undeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM']);
        row.add('${undeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM'] ?? ''}');
        // row.add(undeldata[i]['J_RT']);
        row.add('${undeldata[i]['J_RT'] ?? ''}');
        //row.add(undeldata[i]['K_RT_DATE']);
        row.add('${undeldata[i]['K_RT_DATE'] ?? ''}');
        //row.add(undeldata[i]['L_RT_TIME']);
        row.add('${undeldata[i]['L_RT_TIME'] ?? ''}');
        // row.add(undeldata[i]['M_RD']);
        row.add('${undeldata[i]['M_RD'] ?? ''}');
        //row.add(undeldata[i]['N_RD_DATE']);
        row.add('${undeldata[i]['N_RD_DATE'] ?? ''}');
        //row.add(undeldata[i]['O_RD_TIME']);
        row.add('${undeldata[i]['O_RD_TIME'] ?? ''}');
        row.add(undeldata[i]['P_RECIPIENT_NAME']);
        //row.add(undeldata[i]['Q_REDIRECT_REC_ADD1']);
        row.add('${undeldata[i]['Q_REDIRECT_REC_ADD1'] ?? ''}');
        // row.add(undeldata[i]['R_REDIRECT_REC_ADD2']);
        row.add('${undeldata[i]['R_REDIRECT_REC_ADD2'] ?? ''}');
        // row.add(undeldata[i]['S_REDIRECT_REC_ADD3']);
        row.add('${undeldata[i]['S_REDIRECT_REC_ADD3'] ?? ''}');
        // row.add(undeldata[i]['T_MOD_PIN']);
        row.add('${undeldata[i]['T_MOD_PIN'] ?? ''}');
        row.add(undeldata[i]['U_MATNR']);
        //row.add(undeldata[i]['V_ART_RECEIVE_DATE_AT_BO']);
        row.add('${undeldata[i]['V_ART_RECEIVE_DATE_AT_BO'] ?? ''}');
        //row.add(undeldata[i]['W_ART_RECEIVE_TIME_AT_BO']);
        row.add('${undeldata[i]['W_ART_RECEIVE_TIME_AT_BO'] ?? ''}');
        row.add(undeldata[i]['X_VPP']);
        row.add(undeldata[i]['Y_REGISTERED']);
        row.add(undeldata[i]['ZA_RETURN_SERVICE']);
        row.add(undeldata[i]['ZB_COD']);
        row.add(undeldata[i]['ZC_INSURANCE']);
        row.add(undeldata[i]['ZD_PERNR']);
        row.add(undeldata[i]['ZE_REDIRECTION_FEE']);
        row.add(undeldata[i]['ZF_CUSTOM_DUTY']);
        row.add(undeldata[i]['ZG_SOFFICE_ID']);
        row.add(undeldata[i]['ZH_REPORTING_SO_ID']);
        row.add(undeldata[i]['ZI_DOFFICE_ID']);
        row.add(undeldata[i]['ZJ_MONEY_TO_BE_COLLECTED']);
        row.add(undeldata[i]['ZK_TOTAL_MONEY']);
        row.add(undeldata[i]['ZL_POST_DUE']);
        row.add(undeldata[i]['ZM_DEM_CHARGE']);
        row.add(undeldata[i]['ZN_COMMISSION']);
        artunDeliveredrows.add(row);
      }
      */

        try {
          for (int i = 0; i < deldata.length; i++) {
            List<dynamic> row = [];
            // row.add(data[i].toString());
            row.add(deldata[i]['A_ART_NUMBER']);
            row.add(deldata[i]['B_DATE_OF_DELIVERY']);
            row.add(deldata[i]['C_DELIVERY_TIME']);
            row.add(deldata[i]['D_DEL_DATE']);
            row.add(deldata[i]['E_BEAT_NO']);
            row.add(deldata[i]['F_ART_STATUS']);
            row.add(deldata[i]['G_TOTAL_MONEY'].floor());
            print("<><><><><><><><><");
            print(deldata[i]['G_TOTAL_MONEY'].floor());

            row.add(deldata[i]['H_DATE_OF_DELIVERY_CONFIRM']);
            row.add(deldata[i]['I_TIME_OF_DELIVERY_CONFIRM']);
            row.add(deldata[i]['J_BO_ID']);
            row.add(deldata[i]['K_POST_DUE'].floor());
            row.add(deldata[i]['L_DEM_CHARGE'].floor());
            row.add(deldata[i]['M_COMMISSION'].floor());
            row.add(deldata[i]['N_MATNR']);
            row.add('${deldata[i]['O_WINDOW_DELIVERY'] ?? ''}');
            // row.add(deldata[i]['O_WINDOW_DELIVERY']);
            //row.add(deldata[i]['P_ID_PROOF_DOC']);
            row.add('${deldata[i]['P_ID_PROOF_DOC'] ?? ''}');
            //row.add(deldata[i]['Q_ID_PROOF_NMBR']);
            row.add('${deldata[i]['Q_ID_PROOF_NMBR'] ?? ''}');
            //row.add(deldata[i]['R_ISSUING_AUTHORITY']);
            row.add('${deldata[i]['R_ISSUING_AUTHORITY'] ?? ''}');
            //row.add(deldata[i]['S_ID_PROOF_VALIDITY_DATE']);
            row.add('${deldata[i]['S_ID_PROOF_VALIDITY_DATE'] ?? ''}');
            // row.add(deldata[i]['T_ART_RECEIVE_DATE_AT_BO']);
            row.add('${deldata[i]['T_ART_RECEIVE_DATE_AT_BO'] ?? ''}');
            // row.add(deldata[i]['U_ART_RECEIVE_TIME_AT_BO']);
            row.add('${deldata[i]['U_ART_RECEIVE_TIME_AT_BO'] ?? ''}');
            row.add(deldata[i]['V_REC_NAME']);
            row.add(deldata[i]['W_REC_ADDRESS1']);
            row.add(deldata[i]['X_REC_ADDRESS2']);
            row.add(deldata[i]['Y_REC_ADDRESS3']);
            row.add(deldata[i]['ZA_REC_CITY']);
            row.add(deldata[i]['ZB_REC_PIN']);
            row.add(deldata[i]['ZC_BOOK_DATE']);
            row.add(deldata[i]['ZD_VPP']);
            row.add(deldata[i]['ZE_REGISTERED']);
            row.add(deldata[i]['ZF_RETURN_SERVICE']);
            row.add(deldata[i]['ZG_COD']);
            //row.add(deldata[i]['ZH_BELNR']);
            row.add('${deldata[i]['ZH_BELNR'] ?? ''}');
            row.add(deldata[i]['ZI_INSURANCE']);
            row.add(deldata[i]['ZJ_ACK']);
            row.add(deldata[i]['ZK_PERNR']);
            //print("ZL_REDIRECTION_FEE is: $deldata[i]['ZL_REDIRECTION_FEE']");
            row.add(deldata[i]['ZL_REDIRECTION_FEE'] == null
                ? '0'
                : deldata[i]['ZL_REDIRECTION_FEE'].floor());
            row.add(deldata[i]['ZM_CUSTOM_DUTY'] == null
                ? '0'
                : deldata[i]['ZM_CUSTOM_DUTY'].floor());
            row.add(deldata[i]['ZN_SOFFICE_ID']);
            row.add(deldata[i]['ZO_REPORTING_SO_ID']);
            row.add(deldata[i]['ZP_DOFFICE_ID']);
            row.add(deldata[i]['ZQ_MONEY_TO_BE_COLLECTED'] == null
                ? '0'
                : deldata[i]['ZQ_MONEY_TO_BE_COLLECTED'].floor());
            row.add(deldata[i]['ZR_TOTAL_MONEY'] == null
                ? '0'
                : deldata[i]['ZR_TOTAL_MONEY'].floor());
            artDeliveredrows.add(row);
            print(row);
          }
        }
        catch (error) {
          print("Error in Del Upload");
          print(error);
          await LogCat().writeContent(
              "Error in Del Upload: $error");
        }
        try {
          for (int i = 0; i < undeldata.length; i++) {
            List<dynamic> row = [];
            // row.add(data[i].toString());
            row.add(undeldata[i]['A_ART_NUMBER']);
            row.add(undeldata[i]['B_DATE_OF_DELIVERY']);
            row.add(undeldata[i]['C_BEAT_NO']);
            row.add(undeldata[i]['D_ART_STATUS']);
            row.add(undeldata[i]['E_BO_ID']);
            row.add(undeldata[i]['F_REASON_FOR_NONDELIVERY']);
            row.add(undeldata[i]['G_REASON_TYPE']);
            row.add(undeldata[i]['H_ACTION']);
            //row.add(undeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM']);
            row.add('${undeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM'] ?? ''}');
            // row.add(undeldata[i]['J_RT']);
            row.add('${undeldata[i]['J_RT'] ?? ''}');
            //row.add(undeldata[i]['K_RT_DATE']);
            row.add('${undeldata[i]['K_RT_DATE'] ?? ''}');
            //row.add(undeldata[i]['L_RT_TIME']);
            row.add('${undeldata[i]['L_RT_TIME'] ?? ''}');
            // row.add(undeldata[i]['M_RD']);
            row.add('${undeldata[i]['M_RD'] ?? ''}');
            //row.add(undeldata[i]['N_RD_DATE']);
            row.add('${undeldata[i]['N_RD_DATE'] ?? ''}');
            //row.add(undeldata[i]['O_RD_TIME']);
            row.add('${undeldata[i]['O_RD_TIME'] ?? ''}');
            row.add(undeldata[i]['P_RECIPIENT_NAME']);
            //row.add(undeldata[i]['Q_REDIRECT_REC_ADD1']);
            row.add('${undeldata[i]['Q_REDIRECT_REC_ADD1'] ?? ''}');
            // row.add(undeldata[i]['R_REDIRECT_REC_ADD2']);
            row.add('${undeldata[i]['R_REDIRECT_REC_ADD2'] ?? ''}');
            // row.add(undeldata[i]['S_REDIRECT_REC_ADD3']);
            row.add('${undeldata[i]['S_REDIRECT_REC_ADD3'] ?? ''}');
            // row.add(undeldata[i]['T_MOD_PIN']);
            row.add('${undeldata[i]['T_MOD_PIN'] ?? ''}');
            row.add(undeldata[i]['U_MATNR']);
            //row.add(undeldata[i]['V_ART_RECEIVE_DATE_AT_BO']);
            row.add('${undeldata[i]['V_ART_RECEIVE_DATE_AT_BO'] ?? ''}');
            //row.add(undeldata[i]['W_ART_RECEIVE_TIME_AT_BO']);
            row.add('${undeldata[i]['W_ART_RECEIVE_TIME_AT_BO'] ?? ''}');
            row.add(undeldata[i]['X_VPP']);
            row.add(undeldata[i]['Y_REGISTERED']);
            row.add(undeldata[i]['ZA_RETURN_SERVICE']);
            row.add(undeldata[i]['ZB_COD']);
            row.add(undeldata[i]['ZC_INSURANCE']);
            row.add(undeldata[i]['ZD_PERNR']);
            row.add(undeldata[i]['ZE_REDIRECTION_FEE'] == null
                ? '0'
                : undeldata[i]['ZE_REDIRECTION_FEE'].floor());
            row.add(undeldata[i]['ZF_CUSTOM_DUTY']);
            row.add(undeldata[i]['ZG_SOFFICE_ID']);
            row.add(undeldata[i]['ZH_REPORTING_SO_ID']);
            row.add(undeldata[i]['ZI_DOFFICE_ID']);
            row.add(undeldata[i]['ZJ_MONEY_TO_BE_COLLECTED'] == null
                ? '0'
                : undeldata[i]['ZJ_MONEY_TO_BE_COLLECTED'].floor());
            row.add(undeldata[i]['ZK_TOTAL_MONEY'] == null
                ? '0'
                : undeldata[i]['ZK_TOTAL_MONEY'].floor());
            row.add(undeldata[i]['ZL_POST_DUE'] == null
                ? '0'
                : undeldata[i]['ZL_POST_DUE'].floor());
            row.add(undeldata[i]['ZM_DEM_CHARGE'] == null
                ? '0'
                : undeldata[i]['ZM_DEM_CHARGE'].floor());
            row.add(undeldata[i]['ZN_COMMISSION'] == null
                ? '0'
                : undeldata[i]['ZN_COMMISSION'].floor());
            artunDeliveredrows.add(row);
          }
        }
        catch (error) {
          print("Error in Undel Upload");
          print(error);
          await LogCat().writeContent(
              "Error in Undel Upload: $error");
        }
        try {
          for (int i = 0; i < emodeldata.length; i++) {
    List<dynamic> row = [];
    // row.add(data[i].toString());
    row.add(emodeldata[i]['A_ART_NUMBER']);
    row.add(emodeldata[i]['B_DATE_OF_DELIVERY']);
    row.add(emodeldata[i]['C_DELIVERY_TIME']);
    row.add(emodeldata[i]['D_DEL_DATE']);
    row.add(emodeldata[i]['E_BEAT_NO']);
    row.add(emodeldata[i]['F_ART_STATUS']);
    row.add(emodeldata[i]['G_DATE_OF_DELIVERY_CONFIRM']);
    row.add(emodeldata[i]['H_TIME_OF_DELIVERY_CONFIRM']);
    row.add(emodeldata[i]['I_BO_ID']);
    row.add(emodeldata[i]['J_MATNR']);
    // row.add(emodeldata[i]['K_WINDOW_DELIVERY']);
    row.add('${emodeldata[i]['K_WINDOW_DELIVERY'] ?? ''}');
    //row.add(emodeldata[i]['L_ID_PROOF_DOC']);
    row.add('${emodeldata[i]['L_ID_PROOF_DOC'] ?? ''}');
    //row.add(emodeldata[i]['M_ID_PROOF_NMBR']);
    row.add('${emodeldata[i]['M_ID_PROOF_NMBR'] ?? ''}');
    //row.add(emodeldata[i]['N_ISSUING_AUTHORITY']);
    row.add('${emodeldata[i]['N_ISSUING_AUTHORITY'] ?? ''}');
    //row.add(emodeldata[i]['O_ID_PROOF_VALIDITY_DATE']);
    row.add('${emodeldata[i]['K_WINDOW_DELIVERY'] ?? ''}');
    row.add(emodeldata[i]['P_REC_NAME']);
    row.add(emodeldata[i]['Q_BOOK_DATE']);
    row.add(emodeldata[i]['R_MONEY_DELIVERED'].floor());
    row.add(emodeldata[i]['S_PAYINGPIN']);
    row.add(emodeldata[i]['T_ART_RECEIVE_DATE']);
    row.add(emodeldata[i]['U_ART_RECEIVE_TIME']);
    row.add(emodeldata[i]['V_SOFFICE_ID']);
    row.add(emodeldata[i]['W_REPORTING_SO_ID']);
    row.add(emodeldata[i]['X_DOFFICE_ID']);
    emoDeliveredrows.add(row);
  }
        }
        catch (error) {
          print("Error in eMO Del Upload");
          print(error);
          await LogCat().writeContent(
              "Error in eMO Del Upload: $error");
        }

        try {
          for (int i = 0; i < emoundeldata.length; i++) {
            List<dynamic> row = [];
            // row.add(data[i].toString());
            row.add(emoundeldata[i]['A_ART_NUMBER']);
            row.add(emoundeldata[i]['B_DATE_OF_DELIVERY']);
            row.add(emoundeldata[i]['C_BEAT_NO']);
            row.add(emoundeldata[i]['D_ART_STATUS']);
            row.add(emoundeldata[i]['E_BO_ID']);
            row.add(emoundeldata[i]['F_REASON_FOR_NONDELIVERY']);
            row.add(emoundeldata[i]['G_REASON_TYPE']);
            row.add(emoundeldata[i]['H_ACTION']);
            //row.add(emoundeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM']);
            row.add(
                '${emoundeldata[i]['I_DATE_OF_1ST_DELIVERY_CONFIRM'] ?? ''}');
            // row.add(emoundeldata[i]['J_RT']);
            row.add('${emoundeldata[i]['J_RT'] ?? ''}');
            //row.add(emoundeldata[i]['K_RT_DATE']);
            row.add('${emoundeldata[i]['K_RT_DATE'] ?? ''}');
            // row.add(emoundeldata[i]['L_RT_TIME']);
            row.add('${emoundeldata[i]['L_RT_TIME'] ?? ''}');
            //row.add(emoundeldata[i]['M_RD']);
            row.add('${emoundeldata[i]['M_RD'] ?? ''}');
            // row.add(emoundeldata[i]['N_RD_DATE']);
            row.add('${emoundeldata[i]['N_RD_DATE'] ?? ''}');
            //row.add(emoundeldata[i]['O_RD_TIME']);
            row.add('${emoundeldata[i]['O_RD_TIME'] ?? ''}');
            row.add(emoundeldata[i]['P_RECIPIENT_NAME']);

            //row.add(emoundeldata[i]['Q_REDIRECT_REC_ADD1']);
            row.add('${emoundeldata[i]['Q_REDIRECT_REC_ADD1'] ?? ''}');
            //row.add(emoundeldata[i]['R_REDIRECT_REC_ADD2']);
            row.add('${emoundeldata[i]['R_REDIRECT_REC_ADD2'] ?? ''}');
            //row.add(emoundeldata[i]['S_REDIRECT_REC_ADD3']);
            row.add('${emoundeldata[i]['S_REDIRECT_REC_ADD3'] ?? ''}');
            //row.add(emoundeldata[i]['T_REDIRECT_REC_PIN']);
            row.add('${emoundeldata[i]['T_REDIRECT_REC_PIN'] ?? ''}');
            row.add(emoundeldata[i]['U_MOD_PIN']);
            row.add(emoundeldata[i]['V_MATNR']);
            row.add(emoundeldata[i]['W_ART_RECEIVE_DATE']);
            row.add(emoundeldata[i]['X_ART_RECEIVE_TIME']);
            row.add(emoundeldata[i]['Y_REDIRECTION_SL']);
            row.add(emoundeldata[i]['ZA_SOFFICE_ID']);
            row.add(emoundeldata[i]['ZB_REPORTING_SO_ID']);
            row.add(emoundeldata[i]['ZC_DOFFICE_ID']);
            emoUnDeliveredrows.add(row);
          }
        }
        catch (error) {
          print("Error in eMO UnDel Upload");
          print(error);
          await LogCat().writeContent(
              "Error in eMO UnDel Upload: $error");
        }
        print("Articles Delivered");
        print(artDeliveredrows.length);


        for (int i = 0; i < artDeliveredrows.length; i++) {
          print(artDeliveredrows[i]);
        }
        if (artDeliveredrows.isNotEmpty) {
          String csv = const ListToCsvConverter(fieldDelimiter: "‡", eol: "\n")
              .convert(artDeliveredrows) + "\n";
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          //final filename = 'BO112PO112${DateTimeDetails().filetimeformat()}951.csv';
          //Rakesh - Getting the BO ID and taking the substring
          //final ofcMaster= await OFCMASTERDATA().select().toList();
          //final filename = 'BO112PO112${DateTimeDetails().filetimeformat()}951.csv';
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}951.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          // final dataDir = Directory("storage/emulated/0/Darpan_Mine/Uploads");
          // zipFile = File("storage/emulated/0/Darpan_Mine/UploadCSV/BO112PO112${DateTimeDetails().filetimeformat()}.zip");
          // // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          // print("ZipFile Created: ${zipFile}");
          // final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";
          //
          // if (await zipFile.exists()) {
          //   print("Already exists");
          //   zipFile.delete();
          //   print("Deleted");
          // }
          // await zipFile.create();
          //
          // await ZipFile.createFromDirectory(
          //     sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          for (int i = 0; i < deldata.length; i++) {
            // data[i]['A_ART_NUMBER']
            await Delivery()
                .select()
                .ART_NUMBER
                .equals(deldata[i]['A_ART_NUMBER'])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
          //
          //
          // String syncdir = (Directory('storage/emulated/0')).path;
          // folderfiles = io.Directory('$zipFileDir').listSync();
          // for (int i = 0; i < folderfiles.length; i++) {
          //   print(folderfiles[i].path.toString());
          // }
        }
        print("article undelivery");
        print(artunDeliveredrows);
        if (artunDeliveredrows.isNotEmpty) {
          String csv = const ListToCsvConverter(
              fieldDelimiter: "‡", eol: "\r\n")
              .convert(artunDeliveredrows) + "\r\n";
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          //final filename = 'BO112PO112${DateTimeDetails().filetimeformat()}952.csv';
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}952.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          print(csv);
          // final dataDir = Directory("storage/emulated/0/Darpan_Mine/Uploads");
          // zipFile = File("storage/emulated/0/Darpan_Mine/UploadCSV/BO112PO112${DateTimeDetails().filetimeformat()}.zip");
          // // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          // print("ZipFile Created: ${zipFile}");
          // final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";
          //
          // if (await zipFile.exists()) {
          //   print("Already exists");
          //   zipFile.delete();
          //   print("Deleted");
          // }
          // await zipFile.create();
          //
          // await ZipFile.createFromDirectory(
          //     sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          for (int i = 0; i < undeldata.length; i++) {
            // data[i]['A_ART_NUMBER']
            await Delivery()
                .select()
                .ART_NUMBER
                .equals(undeldata[i]['A_ART_NUMBER'])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
          //
          //
          // String syncdir = (Directory('storage/emulated/0')).path;
          // folderfiles = io.Directory('$zipFileDir').listSync();
          // for (int i = 0; i < folderfiles.length; i++) {
          //   print(folderfiles[i].path.toString());
          // }
        }
        print("EMO Delievry");
        print(emoDeliveredrows);
        if (emoDeliveredrows.isNotEmpty) {
          String csv = const ListToCsvConverter(
              fieldDelimiter: "‡", eol: "\r\n")
              .convert(emoDeliveredrows) + "\r\n";
          print(csv);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          // final filename = 'BO112PO112${DateTimeDetails().filetimeformat()}954.csv';
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}954.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          // final dataDir = Directory("storage/emulated/0/Darpan_Mine/Uploads");
          // zipFile = File("storage/emulated/0/Darpan_Mine/UploadCSV/BO112PO112${DateTimeDetails().filetimeformat()}.zip");
          // // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          // print("ZipFile Created: ${zipFile}");
          // final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";
          //
          // if (await zipFile.exists()) {
          //   print("Already exists");
          //   zipFile.delete();
          //   print("Deleted");
          // }
          // await zipFile.create();
          //
          // await ZipFile.createFromDirectory(
          //     sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          //Commented by rakesh 10082022
          for (int i = 0; i < emodeldata.length; i++) {
            // data[i]['A_ART_NUMBER']
            await Delivery()
                .select()
                .ART_NUMBER
                .equals(emodeldata[i]['A_ART_NUMBER'])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
          //
          //
          // String syncdir = (Directory('storage/emulated/0')).path;
          // folderfiles = io.Directory('$zipFileDir').listSync();
          // for (int i = 0; i < folderfiles.length; i++) {
          //   print(folderfiles[i].path.toString());
          // }
        }
        print("EMO undelivery");
        print(emoUnDeliveredrows);
        if (emoUnDeliveredrows.isNotEmpty) {
          String csv = const ListToCsvConverter(fieldDelimiter: "‡")
              .convert(emoUnDeliveredrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          //final filename = 'BO112PO112${DateTimeDetails().filetimeformat()}955.csv';
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}955.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          // final dataDir = Directory("storage/emulated/0/Darpan_Mine/Uploads");
          // zipFile = File("storage/emulated/0/Darpan_Mine/UploadCSV/BO112PO112${DateTimeDetails().filetimeformat()}.zip");
          // // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          // print("ZipFile Created: ${zipFile}");
          // final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";
          //
          // if (await zipFile.exists()) {
          //   print("Already exists");
          //   zipFile.delete();
          //   print("Deleted");
          // }
          // await zipFile.create();
          //
          // await ZipFile.createFromDirectory(
          //     sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          for (int i = 0; i < emoundeldata.length; i++) {
            // data[i]['A_ART_NUMBER']
            await Delivery()
                .select()
                .ART_NUMBER
                .equals(emoundeldata[i]['A_ART_NUMBER'])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
          //
          //
          // String syncdir = (Directory('storage/emulated/0')).path;
          // folderfiles = io.Directory('$zipFileDir').listSync();
          // for (int i = 0; i < folderfiles.length; i++) {
          //   print(folderfiles[i].path.toString());
          // }
        }
        //ADDED BY RAKESH 04082022 for Bagreceived
        print("Bag received start");
        final bagreceivedexec = await DeliveryModel().execDataTable(
            bagreceived);
        print(bagreceivedexec);
        Map bagreceiveddata = bagreceivedexec.asMap();
        print(bagreceiveddata);
        List<List<dynamic>> bagreceivedrows = [];
        for (int i = 0; i < bagreceiveddata.length; i++) {
          List<dynamic> row = [];
          row.add(bagreceiveddata[i]['A_bagnumber']);
          bagreceivedrows.add(row);
          print(row);
        }
        if (bagreceivedrows.isNotEmpty) {
          String csv = const ListToCsvConverter(fieldDelimiter: "‡")
              .convert(bagreceivedrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}111305.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < bagreceivedrows.length; i++) {
            await BAGDETAILS_NEW()
                .select()
                .startBlock
                .BAGNUMBER
                .equals(bagreceivedrows[i][0])
                .and
                .BAGSTATUS
                .equals('R')
                .endBlock
                .update({'IS_COMMUNICATED': 0});
          }
        }
        //

        //ADDITION COMPLLETED
        ///Bag Opened File and updating in the DB
        //ADDED BY RAKESH 10082022
        print("Bagopened file");
        final Bagart_File = await BagModel().execDataTable(Bagart);
        print(Bagart_File);
        Map bagartdata = Bagart_File.asMap();
        print(bagartdata);
        List<List<dynamic>> bagartrows = [];
        for (int i = 0; i < bagartdata.length; i++) {
          List<dynamic> row = [];
          row.add(bagartdata[i]['ArticleNumber']);
          row.add(bagartdata[i]['BagNumber']);
          row.add(bagartdata[i]['ArticleType']);
          row.add(bagartdata[i]['Status']);
          bagartrows.add(row);
          print(row);
        }
        if (bagartrows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(bagartrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}111321.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < bagartrows.length; i++) {
            await BagArticlesTable()
                .select()
                .BagNumber
                .equals(bagartrows[i][1])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
        }
        //

        //ADDITION COMPLLETED

        //Bagclose
        print("BagClosed file");
        final BagClosed_File = await BagModel().execDataTable(Bagclose);
        print(BagClosed_File);
        Map bagclosedata = BagClosed_File.asMap();
        print(bagclosedata);
        List<List<dynamic>> bagclosedrows = [];
        for (int i = 0; i < bagclosedata.length; i++) {
          List<dynamic> row = [];
          row.add(bagclosedata[i]['BagNumber']);
          row.add(ofcMaster[0].AOCode.toString());
          row.add(bagclosedata[i]['ArticleNumber']);
          row.add(bagclosedata[i]['ArticleType']);
          bagclosedrows.add(row);
          print(row);
        }
        if (bagclosedrows.isNotEmpty) {
          String csv = const ListToCsvConverter(fieldDelimiter: "‡")
              .convert(bagclosedrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}111354.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < bagclosedrows.length; i++) {
            await BagArticlesTable()
                .select()
                .BagNumber
                .equals(bagclosedrows[i][0])
                .update({'FILE_NAME': '$filename', 'IS_COMMUNICATED': 0});
          }
        }
        //END
        //BAG Dispatch
        print("BagDispatch file");
        final Bagdispatch_File = await DeliveryModel().execDataTable(
            bagdispatch);
        print(Bagdispatch_File);
        Map Bagdispatchdata = Bagdispatch_File.asMap();
        print(Bagdispatchdata);
        List<List<dynamic>> Bagdispatchrows = [];
        for (int i = 0; i < Bagdispatchdata.length; i++) {
          List<dynamic> row = [];
          row.add(Bagdispatchdata[i]['SCHEDULE']);
          row.add(Bagdispatchdata[i]['SCHEDULED_TIME']);
          row.add(Bagdispatchdata[i]['MAILLIST_TO_OFFICE']);
          row.add(Bagdispatchdata[i]['BAGNUMBER']);
          row.add(Bagdispatchdata[i]['FROM_OFFICE']);
          row.add(Bagdispatchdata[i]['TO_OFFICE']);
          row.add(Bagdispatchdata[i]['CLOSING_DATE']);
          row.add(Bagdispatchdata[i]['REMARKS']);
          Bagdispatchrows.add(row);
          print(row);
        }
        if (Bagdispatchrows.isNotEmpty) {
          String csv = const ListToCsvConverter(fieldDelimiter: "‡")
              .convert(Bagdispatchrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}111384.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < Bagdispatchrows.length; i++) {
            await DESPATCHBAG()
                .select()
                .BAGNUMBER
                .equals(Bagdispatchrows[i][3])
                .update({'IS_COMMUNICATED': 0});
          }
        }
        //END

        //STAMPS ACKNOWLEDGED
        print("Stamp Ack file");
        final stampack_File = await DeliveryModel().execDataTable(stampack);
        //print(stampack_File);
        Map stampackdata = stampack_File.asMap();
        //print(stampackdata);
        List<List<dynamic>> stampackrows = [];
        for (int i = 0; i < stampackdata.length; i++) {
          List<dynamic> row = [];
          row.add(stampackdata[i]['BO_SLIP_NO']);
          row.add(stampackdata[i]['ZCREATEDT']);
          row.add(stampackdata[i]['ZMOFACILITYID']);
          row.add(DateTimeDetails().cbsdate());
          row.add(stampackdata[i]['MATNR']);
          row.add(stampackdata[i]['MENGE_D']);
          row.add(stampackdata[i]['ZINV_PARTICULAR']);
          stampackrows.add(row);
          // print(row);
        }
        print(stampackrows);
        if (stampackrows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(stampackrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}958.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          print(csv);
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < stampackrows.length; i++) {
            await BOSLIP_STAMP1()
                .select()
                .startBlock
                .BO_SLIP_NO
                .equals(stampackdata[i]['BO_SLIP_NO'])
                .and
                .IS_RCVD
                .equals('Y')
                .and
                .MATNR
                .equals(stampackdata[i]['MATNR'])
                .endBlock
                .update({'IS_COMMUNICATED': 0});
          }
        }
        //END
        //Cash ACKNOWLEDGED
        print("Cash Ack file");
        final cashack_File = await DeliveryModel().execDataTable(cashack);
        //cashack
        Map cashackdata = cashack_File.asMap();
        //print(stampackdata);
        List<List<dynamic>> cashackrows = [];
        for (int i = 0; i < cashackdata.length; i++) {
          List<dynamic> row = [];
          row.add(cashackdata[i]['BO_SLIP_NO']);
          row.add(cashackdata[i]['DATE_OF_SENT']);
          row.add(cashackdata[i]['CHEQUE_NO']);
          row.add(cashackdata[i]['SO_PROFIT_CENTER']);
          row.add(cashackdata[i]['BO_PROFIT_CENTER']);
          row.add(cashackdata[i]['AMOUNT']);
          row.add(cashackdata[i]['WEIGHT_OF_CASH_BAG']);
          row.add(cashackdata[i]['CHEQUE_AMOUNT']);
          row.add(cashackdata[i]['CASHORCHEQUE']);
          row.add(cashackdata[i]['LESS_CASH']);
          row.add(cashackdata[i]['OVER_CASH']);
          row.add(cashackdata[i]['ACTUAL_CASH']);
          cashackrows.add(row);
          // print(row);
        }
        print(cashackrows);
        if (cashackrows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(cashackrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}960.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          print(csv);
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < cashackrows.length; i++) {
            await BOSLIP_CASH1()
                .select()
                .startBlock
                .BO_SLIP_NO
                .equals(cashackdata[i]['BO_SLIP_NO'])
                .and
                .IS_RCVD
                .equals('Y')
                .and
                .ACTUAL_CASH
                .equals(cashackdata[i]['ACTUAL_CASH'])
                .endBlock
                .update({'IS_COMMUNICATED': 0});
          }
        }
        //END
        //Cash ACKNOWLEDGED
        print("DOC Ack file");
        final docack_File = await DeliveryModel().execDataTable(docack);
        //cashack
        Map docackdata = docack_File.asMap();
        //print(stampackdata);
        List<List<dynamic>> docackrows = [];
        for (int i = 0; i < docackdata.length; i++) {
          List<dynamic> row = [];
          row.add(docackdata[i]['BO_SLIP_NO']);
          row.add(DateTimeDetails().cbsdate());
          row.add(docackdata[i]['TOOFFICE']);
          row.add(docackdata[i]['DOCUMENT_DETAILS']);
          row.add(docackdata[i]['IS_RCVD'] == 'Y' ? 'YES' : 'NO');
          docackrows.add(row);
          // print(row);
        }
        print(docackrows);
        if (docackrows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(docackrows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Delivery";
          final filename =
              '${ofcMaster[0].BOFacilityID}${ofcMaster[0]
              .AOCode}${DateTimeDetails().filetimeformat()}962.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          final path = "$directory/$filename";
          print(csv);
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < docackrows.length; i++) {
            print("During Update doc rows");
            print(docackdata[i]['BO_SLIP_NO'] +
                " ," +
                docackdata[i]['DOCUMENT_DETAILS']);
            await BOSLIP_DOCUMENT1()
                .select()
                .startBlock
                .BO_SLIP_NO
                .equals(docackdata[i]['BO_SLIP_NO'])
                .and
                .IS_RCVD
                .equals('Y')
                .and
                .DOCUMENT_DETAILS
                .equals(docackdata[i]['DOCUMENT_DETAILS'])
                .endBlock
                .update({'IS_COMMUNICATED': 0});
          }
        }
        //END
        print("before ZIP DEL");
        List tempfolderfiles =
        io.Directory('storage/emulated/0/Darpan_Mine/UploadCSV').listSync();
        if (artDeliveredrows.isNotEmpty ||
            artunDeliveredrows.isNotEmpty ||
            emoDeliveredrows.isNotEmpty ||
            emoUnDeliveredrows.isNotEmpty //|| tempfolderfiles.length>0
            ||
            bagreceivedrows.isNotEmpty ||
            bagartrows.isNotEmpty ||
            bagclosedrows.isNotEmpty ||
            Bagdispatchrows.isNotEmpty ||
            stampackrows.isNotEmpty ||
            cashackrows.isNotEmpty ||
            docackrows.isNotEmpty) {
          // print("artdel"+ artDeliveredrows.toString());
          // print("artunDeliveredrows"+ artunDeliveredrows.toString());
          // print("emoDeliveredrows"+ emoDeliveredrows.toString());
          // print("emoUnDeliveredrows"+ emoUnDeliveredrows.toString());
          // print("bagreceivedrows"+ bagreceivedrows.toString());
          // print("bagartrows"+ bagartrows.toString());
          // print("bagclosedrows"+ bagclosedrows.toString());
          // print("Bagdispatchrows"+ Bagdispatchrows.toString());
          // print("stampackrows"+ stampackrows.toString());
          // print("cashackrows"+ cashackrows.toString());
          // print("docackrows"+ docackrows.toString());
          final dataDir = Directory(
              "storage/emulated/0/Darpan_Mine/Uploads/Delivery");
          zipFile = File(
              "storage/emulated/0/Darpan_Mine/UploadCSV/DEL_${ofcMaster[0]
                  .BOFacilityID}${DateTimeDetails().filetimeformat()}.zip");
          var zipFiletemp = await zipFile.path
              .toString()
              .split("storage/emulated/0/Darpan_Mine/UploadCSV/")[1];
          // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          print("ZipFile Created: ${zipFile}");
          final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";

          if (await zipFile.exists()) {
            print("Already exists");
            zipFile.delete();
            print("Deleted");
          }
          await zipFile.create();

          await ZipFile.createFromDirectory(
              sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          var files = io.Directory("storage/emulated/0/Darpan_Mine/Uploads/Delivery")
              .listSync();

          for (int i = 0; i < files.length; i++) {
            await FILE_SYNC_DETAILS()
                .select()
                .FILE_NAME
                .equals(files[i]
                .path
                .toString()
                .split("storage/emulated/0/Darpan_Mine/Uploads/Delivery/")[1])
                .update({
              'ZIP_FILE_NAME': zipFiletemp,
              'STATUS': "0",
              'LAST_UPDATED_DT': DateTimeDetails().currentDateTime()
            });
          }

          print(files.length);
          for (int i = 0; i < files.length; i++) {
            print(files[i]);
            files[i].deleteSync();
          }

          // String syncdir = (Directory('storage/emulated/0')).path;
          //   String syncdir = (Directory('storage/emulated/0/Darpan_Mine/Screenshots')).path;
          //  try {
          //    await File(zipFile).copy(syncdir);
          //    //Updating the IS_COMMUNICATED flag for tables
          //    await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: Directory('storage/emulated/0/Darpan_Mine/Screenshots'));
          //    final dir=await Directory('storage/emulated/0/Darpan_Mine/Screenshots/$zipFile');
          //    final List<FileSystemEntity> entities = await dir.list().toList();
          //    for(int i=0;i<entities.length;i++) {
          //      await Delivery()
          //          .select()
          //          .FILE_NAME
          //          .equals('${entities[i].toString()}.csv')
          //          .update({'IS_COMMUNICATED': '1'});
          //    }
          //    await File(zipFile).delete();
          //  }catch(e){
          //    // UtilFs.showToast("Error in FIle Updating/File Movement",context);
          //    print("Error in FIle Updating/File Movement");
          //    await LogCat().writeContent("'${DateTimeDetails().currentDateTime()} :Error in FIle Updating/File Movement - " + e.toString()+" \n\n");
          //  }

        }

        ///Creating the Letter file and updating the status

        var inputFormat = DateFormat('dd-MM-yyyy');
        var outputFormat = DateFormat('yyyyMMdd');

        final letterBooking =
        await LetterBooking()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("letterBooking test");
        print(letterBooking);
        // if (letterBooking.isNotEmpty) {
        //   for (int i = 0; i < letterBooking.length; i++) {
        //     var date1 =
        //         inputFormat.parse(letterBooking[i]['BookingDate'].toString());
        //     List<List<dynamic>> rows = [];
        //     List bookedLetter = [
        //       letterBooking[i]['FacilityId'],
        //       letterBooking[i]['BookingFacilityZip'],
        //       letterBooking[i]['DistributionChannel'],
        //       letterBooking[i]['UserID'],
        //       letterBooking[i]['CounterNumber'],
        //       letterBooking[i]['InvoiceNumber'],
        //       letterBooking[i]['TotalAmount'],
        //       outputFormat.format(date1).toString(),
        //       letterBooking[i]['BookingTime'],
        //       letterBooking[i]['CurrencyID'],
        //       letterBooking[i]['TenderID'],
        //       letterBooking[i]['TotalCashAmount'],
        //       letterBooking[i]['RoundOffDifference'],
        //       letterBooking[i]['CircleCode'],
        //       letterBooking[i]['LineItemNumber'],
        //       letterBooking[i]['BasePrice'],
        //       letterBooking[i]['LineItemTotalAmount'],
        //       letterBooking[i]['ArticleNumber'],
        //       letterBooking[i]['Division'],
        //       letterBooking[i]['OrderType'],
        //       letterBooking[i]['ProductType'],
        //       letterBooking[i]['ProductCode'],
        //       letterBooking[i]['WeightCode'],
        //       letterBooking[i]['Weight'],
        //       letterBooking[i]['Quantity'],
        //       letterBooking[i]['SenderCustomerNumber'],
        //       letterBooking[i]['SenderName'],
        //       letterBooking[i]['SenderAddress'],
        //       letterBooking[i]['SenderCity'],
        //       letterBooking[i]['SenderState'],
        //       letterBooking[i]['SenderZip'],
        //       letterBooking[i]['SenderCountry'],
        //       letterBooking[i]['RecipientName'],
        //       letterBooking[i]['RecipientAddress'],
        //       letterBooking[i]['RecipientAddress'],
        //       letterBooking[i]['RecipientCity'],
        //       letterBooking[i]['RecipientState'],
        //       letterBooking[i]['RecipientZip'],
        //       letterBooking[i]['RecipientCountryID'],
        //       letterBooking[i]['SenderName'],
        //       letterBooking[i]['SenderAddress'],
        //       letterBooking[i]['SenderCity'],
        //       letterBooking[i]['SenderState'],
        //       letterBooking[i]['SenderZip'],
        //       letterBooking[i]['SenderCountry'],
        //       letterBooking[i]['CommissionAmount'],
        //       letterBooking[i]['TaxAmount'],
        //       letterBooking[i]['RepaymentMode'],
        //       letterBooking[i]['PostageDue'],
        //       letterBooking[i]['PrepaidAmount'],
        //       letterBooking[i]['MaterialGroup'],
        //       letterBooking[i]['DestinationFacility'],
        //       letterBooking[i]['VAS'],
        //       letterBooking[i]['VASValue'],
        //       letterBooking[i]['ElapsedTime'],
        //       letterBooking[i]['IsFullyPrepaid'],
        //       letterBooking[i]['IsOnPostalService']
        //     ];
        //     // List bookedLetter = [letterBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
        //     //   'PS', '54600012', '000', 'SL${letterBooking[i]['BookingDate']}${letterBooking[i]['ArticleNumber']}',
        //     //   letterBooking[i]['TotalAmount'], letterBooking[i]['BookingDate'],
        //     //   letterBooking[i]['BookingTime'], 'INR', 'S', letterBooking[i]['TotalCashAmount'],
        //     //   '0.0', '17', '1', letterBooking[i]['BasePrice'], letterBooking[i]['TotalAmount'],
        //     //   'MO', 'ZAM', 'S', 'LETTER', letterBooking[i]['WeightCode'],
        //     //   letterBooking[i]['Weight'], letterBooking[i]['SenderCustomerNumber'],
        //     //   letterBooking[i]['SenderName'], letterBooking[i]['SenderAddress'],
        //     //   letterBooking[i]['SenderZip'], letterBooking[i]['SenderCity'],
        //     //   letterBooking[i]['SenderState'], letterBooking[i]['SenderCountry'],
        //     //   letterBooking[i]['RecipientName'], letterBooking[i]['RecipientAddress'],
        //     //   letterBooking[i]['RecipientCity'], letterBooking[i]['RecipientState'],
        //     //   letterBooking[i]['RecipientCountryID'], letterBooking[i]['SenderName'],
        //     //   letterBooking[i]['SenderAddress'], letterBooking[i]['SenderZip'],
        //     //   letterBooking[i]['SenderCity'], letterBooking[i]['SenderState'],
        //     //   letterBooking[i]['SenderCountry'], '0', letterBooking[i]['TaxAmount'], 'EMO',
        //     //   letterBooking[i]['PostageDue'], letterBooking[i]['PrepaidAmount'],  'DOM',
        //     //   'PO21310210000', letterBooking[i]['VAS'], letterBooking[i]['VASValue'],
        //     //   letterBooking[i]['ElapsedTime'],  '0', letterBooking[i]['IsOnPostalService'], 'N'];
        //     rows.add(bookedLetter);
        //     String csv = ListToCsvConverter(fieldDelimiter: '‡').convert(rows)+"\n";
        //     //Rakesh - Getting the BO ID and taking the substring
        //     final ofcMaster = await OFCMASTERDATA().select().toList();
        //     //String fileName = 'OUT_RL_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     String fileName =
        //         'OUT_RL_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //
        //     //Rakesh Addition completed
        //     await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
        //     final path = '$dataDirectory/Booking/$fileName';
        //     final File file = File(path);
        //     //await file.writeAsString(csv,encoding: const Windows1252Codec());
        //     await file.writeAsString(csv, encoding: const Windows1252Codec());
        //     await LetterBooking()
        //         .select()
        //         .ArticleNumber
        //         .equals(letterBooking[i]['ArticleNumber'])
        //         .update({
        //       'FileCreated': 'Y',
        //       'FileName': fileName,
        //       'FileCreatedDateTime': DateTimeDetails().currentDateTime()
        //     });
        //     addFileToDB(file.toString(), path.toString(),
        //         'Register Letter Booking', DateTimeDetails().currentDateTime());
        //   }
        // }
        if (letterBooking.isNotEmpty) {
          List<List<dynamic>> rows = [];
          for (int i = 0; i < letterBooking.length; i++) {
            var date1 =
            inputFormat.parse(letterBooking[i]['BookingDate'].toString());

            List bookedLetter = [
              letterBooking[i]['FacilityId'],
              letterBooking[i]['BookingFacilityZip'],
              letterBooking[i]['DistributionChannel'],
              letterBooking[i]['UserID'],
              letterBooking[i]['CounterNumber'],
              letterBooking[i]['InvoiceNumber'],
              letterBooking[i]['TotalAmount'],
              outputFormat.format(date1).toString(),
              letterBooking[i]['BookingTime'],
              letterBooking[i]['CurrencyID'],
              letterBooking[i]['TenderID'],
              letterBooking[i]['TotalCashAmount'],
              letterBooking[i]['RoundOffDifference'],
              letterBooking[i]['CircleCode'],
              letterBooking[i]['LineItemNumber'],
              letterBooking[i]['BasePrice'],
              letterBooking[i]['LineItemTotalAmount'],
              letterBooking[i]['ArticleNumber'],
              letterBooking[i]['Division'],
              letterBooking[i]['OrderType'],
              letterBooking[i]['ProductType'],
              letterBooking[i]['ProductCode'],
              letterBooking[i]['WeightCode'],
              letterBooking[i]['Weight'],
              letterBooking[i]['Quantity'],
              letterBooking[i]['SenderCustomerNumber'],
              letterBooking[i]['SenderName'],
              letterBooking[i]['SenderAddress'],
              letterBooking[i]['SenderCity'],
              letterBooking[i]['SenderState'],
              letterBooking[i]['SenderZip'],
              letterBooking[i]['SenderCountry'],
              letterBooking[i]['RecipientName'],
              letterBooking[i]['RecipientAddress'],
              letterBooking[i]['RecipientAddress'],
              letterBooking[i]['RecipientCity'],
              letterBooking[i]['RecipientState'],
              letterBooking[i]['RecipientZip'],
              letterBooking[i]['RecipientCountryID'],
              letterBooking[i]['SenderName'],
              letterBooking[i]['SenderAddress'],
              letterBooking[i]['SenderCity'],
              letterBooking[i]['SenderState'],
              letterBooking[i]['SenderZip'],
              letterBooking[i]['SenderCountry'],
              letterBooking[i]['CommissionAmount'],
              letterBooking[i]['TaxAmount'],
              letterBooking[i]['RepaymentMode'],
              letterBooking[i]['PostageDue'],
              letterBooking[i]['PrepaidAmount'],
              letterBooking[i]['MaterialGroup'],
              letterBooking[i]['DestinationFacility'],
              letterBooking[i]['VAS'],
              letterBooking[i]['VASValue'],
              letterBooking[i]['ElapsedTime'],
              letterBooking[i]['IsFullyPrepaid'],
              letterBooking[i]['IsOnPostalService']
            ];
            // List bookedLetter = [letterBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
            //   'PS', '54600012', '000', 'SL${letterBooking[i]['BookingDate']}${letterBooking[i]['ArticleNumber']}',
            //   letterBooking[i]['TotalAmount'], letterBooking[i]['BookingDate'],
            //   letterBooking[i]['BookingTime'], 'INR', 'S', letterBooking[i]['TotalCashAmount'],
            //   '0.0', '17', '1', letterBooking[i]['BasePrice'], letterBooking[i]['TotalAmount'],
            //   'MO', 'ZAM', 'S', 'LETTER', letterBooking[i]['WeightCode'],
            //   letterBooking[i]['Weight'], letterBooking[i]['SenderCustomerNumber'],
            //   letterBooking[i]['SenderName'], letterBooking[i]['SenderAddress'],
            //   letterBooking[i]['SenderZip'], letterBooking[i]['SenderCity'],
            //   letterBooking[i]['SenderState'], letterBooking[i]['SenderCountry'],
            //   letterBooking[i]['RecipientName'], letterBooking[i]['RecipientAddress'],
            //   letterBooking[i]['RecipientCity'], letterBooking[i]['RecipientState'],
            //   letterBooking[i]['RecipientCountryID'], letterBooking[i]['SenderName'],
            //   letterBooking[i]['SenderAddress'], letterBooking[i]['SenderZip'],
            //   letterBooking[i]['SenderCity'], letterBooking[i]['SenderState'],
            //   letterBooking[i]['SenderCountry'], '0', letterBooking[i]['TaxAmount'], 'EMO',
            //   letterBooking[i]['PostageDue'], letterBooking[i]['PrepaidAmount'],  'DOM',
            //   'PO21310210000', letterBooking[i]['VAS'], letterBooking[i]['VASValue'],
            //   letterBooking[i]['ElapsedTime'],  '0', letterBooking[i]['IsOnPostalService'], 'N'];
            rows.add(bookedLetter);
          }
          String csv = ListToCsvConverter(fieldDelimiter: '‡', eol: "\n")
              .convert(rows) + "\n";
          //Rakesh - Getting the BO ID and taking the substring
          final ofcMaster = await OFCMASTERDATA().select().toList();
          //String fileName = 'OUT_RL_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          String fileName =
              'OUT_RL_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          //Rakesh Addition completed
          await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
          final path = '$dataDirectory/Booking/$fileName';
          final File file = File(path);
          //await file.writeAsString(csv,encoding: const Windows1252Codec());
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < letterBooking.length; i++) {
            await LetterBooking()
                .select()
                .ArticleNumber
                .equals(letterBooking[i]['ArticleNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
          }
          addFileToDB(file.toString(), path.toString(),
              'Register Letter Booking', DateTimeDetails().currentDateTime());
        }

        ///Creating the Parcel file and updating the status
        final parcelBooking =
        await ParcelBooking()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("Parcel Data in DB:");
        print(parcelBooking);

        // if (parcelBooking.isNotEmpty) {
        //   for (int i = 0; i < parcelBooking.length; i++) {
        //     List<List<dynamic>> rows = [];
        //     var date1 =
        //         inputFormat.parse(parcelBooking[i]['BookingDate'].toString());
        //
        //     List bookedParcel = [
        //       parcelBooking[i]['FacilityId'],
        //       parcelBooking[i]['BookingFacilityZip'],
        //       parcelBooking[i]['DistributionChannel'],
        //       parcelBooking[i]['UserID'],
        //       parcelBooking[i]['CounterNumber'],
        //       parcelBooking[i]['InvoiceNumber'],
        //       parcelBooking[i]['TotalAmount'],
        //       // parcelBooking[i]['BookingDate'],
        //       // parcelBooking[i]['BookingDate'].toString().substring(6,9)+parcelBooking[i]['BookingDate'].toString().substring(3,4)+parcelBooking[i]['BookingDate'].toString().substring(0,1),
        //       outputFormat.format(date1).toString(),
        //       parcelBooking[i]['BookingTime'],
        //       parcelBooking[i]['CurrencyID'],
        //       parcelBooking[i]['TenderID'],
        //       parcelBooking[i]['TotalCashAmount'],
        //       parcelBooking[i]['RoundOffDifference'],
        //       parcelBooking[i]['CircleCode'],
        //       parcelBooking[i]['LineItemNumber'],
        //       parcelBooking[i]['BasePrice'],
        //       parcelBooking[i]['LineItemTotalAmount'],
        //       parcelBooking[i]['ArticleNumber'],
        //       parcelBooking[i]['Division'],
        //       parcelBooking[i]['OrderType'],
        //       parcelBooking[i]['ProductType'],
        //       parcelBooking[i]['ProductCode'],
        //       parcelBooking[i]['WeightCode'],
        //       parcelBooking[i]['Weight'],
        //       parcelBooking[i]['Quantity'],
        //       parcelBooking[i]['SenderCustomerNumber'],
        //       parcelBooking[i]['SenderName'],
        //       parcelBooking[i]['SenderAddress'],
        //       parcelBooking[i]['SenderCity'],
        //       parcelBooking[i]['SenderState'],
        //       parcelBooking[i]['SenderZip'],
        //       parcelBooking[i]['SenderCountry'],
        //       parcelBooking[i]['RecipientName'],
        //       parcelBooking[i]['RecipientAddress'],
        //       parcelBooking[i]['RecipientAddress'],
        //       parcelBooking[i]['RecipientCity'],
        //       parcelBooking[i]['RecipientState'],
        //       parcelBooking[i]['RecipientZip'],
        //       parcelBooking[i]['RecipientCountryID'],
        //       parcelBooking[i]['SenderName'],
        //       parcelBooking[i]['SenderAddress'],
        //       parcelBooking[i]['SenderCity'],
        //       parcelBooking[i]['SenderState'],
        //       parcelBooking[i]['SenderZip'],
        //       parcelBooking[i]['SenderCountry'],
        //       parcelBooking[i]['CommissionAmount'],
        //       parcelBooking[i]['TaxAmount'],
        //       parcelBooking[i]['RepaymentMode'],
        //       parcelBooking[i]['PostageDue'],
        //       parcelBooking[i]['PrepaidAmount'],
        //       parcelBooking[i]['MaterialGroup'],
        //       parcelBooking[i]['DestinationFacility'],
        //       parcelBooking[i]['VAS'],
        //       parcelBooking[i]['VASValue'],
        //       parcelBooking[i]['IsAMS'],
        //       parcelBooking[i]['ElapsedTime'],
        //       parcelBooking[i]['IsFullPrepaid'],
        //       parcelBooking[i]['IsOnPostalService']
        //     ];
        //     // List bookedParcel = [parcelBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
        //     //   'PS', '54600012', '000', 'SL${parcelBooking[i]['BookingDate']}${parcelBooking[i]['ArticleNumber']}',
        //     //   parcelBooking[i]['TotalAmount'], parcelBooking[i]['BookingDate'],
        //     //   parcelBooking[i]['BookingTime'], 'INR', 'S', parcelBooking[i]['TotalCashAmount'],
        //     //   '0.0', '50015379', '17', '1', parcelBooking[i]['BasePrice'],
        //     //   parcelBooking[i]['TotalAmount'], 'MO', 'ZAM', 'S', 'PARCEL',
        //     //   parcelBooking[i]['WeightCode'], parcelBooking[i]['Weight'], '1',
        //     //   parcelBooking[i]['SenderCustomerNumber'], parcelBooking[i]['SenderName'],
        //     //   parcelBooking[i]['SenderAddress'], parcelBooking[i]['SenderCity'],
        //     //   parcelBooking[i]['SenderZip'], parcelBooking[i]['SenderState'],
        //     //   parcelBooking[i]['SenderCountry'], parcelBooking[i]['RecipientName'],
        //     //   parcelBooking[i]['RecipientAddress'], parcelBooking[i]['RecipientCity'],
        //     //   parcelBooking[i]['RecipientZip'], parcelBooking[i]['RecipientState'],
        //     //   parcelBooking[i]['RecipientCountryID'], parcelBooking[i]['SenderName'],
        //     //   parcelBooking[i]['SenderAddress'], parcelBooking[i]['SenderCity'],
        //     //   parcelBooking[i]['SenderZip'], parcelBooking[i]['SenderState'],
        //     //   parcelBooking[i]['SenderCountry'], '0', 'DOM', 'PO21310210000',
        //     //   parcelBooking[i]['TaxAmount'], 'EMO', parcelBooking[i]['PostageDue'],
        //     //   parcelBooking[i]['PrepaidAmount'], 'REG', '', parcelBooking[i]['IsAMS'],
        //     //   parcelBooking[i]['ElapsedTime'],  parcelBooking[i]['IsFullPrepaid'],
        //     //   parcelBooking[i]['IsOnPostalService']];
        //     rows.add(bookedParcel);
        //     print(bookedParcel);
        //     String csv =
        //         const ListToCsvConverter(fieldDelimiter: "‡").convert(rows)+"\n";
        //     //String fileName = 'OUT_PL_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     String fileName =
        //         'OUT_PL_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
        //     final path = '$dataDirectory/Booking/$fileName';
        //     final File file = File(path);
        //     await file.writeAsString(csv, encoding: const Windows1252Codec());
        //     await ParcelBooking()
        //         .select()
        //         .ArticleNumber
        //         .equals(parcelBooking[i]['ArticleNumber'])
        //         .update({
        //       'FileCreated': 'Y',
        //       'FileName': fileName,
        //       'FileCreatedDateTime': DateTimeDetails().currentDateTime()
        //     });
        //     addFileToDB(file.toString(), path.toString(), 'Parcel Booking',
        //         DateTimeDetails().currentDateTime());
        //   }
        // }
        // if (parcelBooking.isNotEmpty) {
        //   List<List<dynamic>> rows = [];
        //   for (int i = 0; i < parcelBooking.length; i++) {
        //
        //     var date1 =
        //     inputFormat.parse(parcelBooking[i]['BookingDate'].toString());
        //
        //     List bookedParcel = [
        //       parcelBooking[i]['FacilityId'],
        //       parcelBooking[i]['BookingFacilityZip'],
        //       parcelBooking[i]['DistributionChannel'],
        //       parcelBooking[i]['UserID'],
        //       parcelBooking[i]['CounterNumber'],
        //       parcelBooking[i]['InvoiceNumber'],
        //       parcelBooking[i]['TotalAmount'],
        //       // parcelBooking[i]['BookingDate'],
        //       // parcelBooking[i]['BookingDate'].toString().substring(6,9)+parcelBooking[i]['BookingDate'].toString().substring(3,4)+parcelBooking[i]['BookingDate'].toString().substring(0,1),
        //       outputFormat.format(date1).toString(),
        //       parcelBooking[i]['BookingTime'],
        //       parcelBooking[i]['CurrencyID'],
        //       parcelBooking[i]['TenderID'],
        //       parcelBooking[i]['TotalCashAmount'],
        //       parcelBooking[i]['RoundOffDifference'],
        //       parcelBooking[i]['CircleCode'],
        //       parcelBooking[i]['LineItemNumber'],
        //       parcelBooking[i]['BasePrice'],
        //       parcelBooking[i]['LineItemTotalAmount'],
        //       parcelBooking[i]['ArticleNumber'],
        //       parcelBooking[i]['Division'],
        //       parcelBooking[i]['OrderType'],
        //       parcelBooking[i]['ProductType'],
        //       parcelBooking[i]['ProductCode'],
        //       parcelBooking[i]['WeightCode'],
        //       parcelBooking[i]['Weight'],
        //       parcelBooking[i]['Quantity'],
        //       parcelBooking[i]['SenderCustomerNumber'],
        //       parcelBooking[i]['SenderName'],
        //       parcelBooking[i]['SenderAddress'],
        //       parcelBooking[i]['SenderCity'],
        //       parcelBooking[i]['SenderState'],
        //       parcelBooking[i]['SenderZip'],
        //       parcelBooking[i]['SenderCountry'],
        //       parcelBooking[i]['RecipientName'],
        //       parcelBooking[i]['RecipientAddress'],
        //       parcelBooking[i]['RecipientAddress'],
        //       parcelBooking[i]['RecipientCity'],
        //       parcelBooking[i]['RecipientState'],
        //       parcelBooking[i]['RecipientZip'],
        //       parcelBooking[i]['RecipientCountryID'],
        //       parcelBooking[i]['SenderName'],
        //       parcelBooking[i]['SenderAddress'],
        //       parcelBooking[i]['SenderCity'],
        //       parcelBooking[i]['SenderState'],
        //       parcelBooking[i]['SenderZip'],
        //       parcelBooking[i]['SenderCountry'],
        //       parcelBooking[i]['CommissionAmount'],
        //       parcelBooking[i]['TaxAmount'],
        //       parcelBooking[i]['RepaymentMode'],
        //       parcelBooking[i]['PostageDue'],
        //       parcelBooking[i]['PrepaidAmount'],
        //       parcelBooking[i]['MaterialGroup'],
        //       parcelBooking[i]['DestinationFacility'],
        //       parcelBooking[i]['VAS'],
        //       parcelBooking[i]['VASValue'],
        //       parcelBooking[i]['IsAMS'],
        //       parcelBooking[i]['ElapsedTime'],
        //       parcelBooking[i]['IsFullPrepaid'],
        //       parcelBooking[i]['IsOnPostalService']
        //     ];
        //     // List bookedParcel = [parcelBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
        //     //   'PS', '54600012', '000', 'SL${parcelBooking[i]['BookingDate']}${parcelBooking[i]['ArticleNumber']}',
        //     //   parcelBooking[i]['TotalAmount'], parcelBooking[i]['BookingDate'],
        //     //   parcelBooking[i]['BookingTime'], 'INR', 'S', parcelBooking[i]['TotalCashAmount'],
        //     //   '0.0', '50015379', '17', '1', parcelBooking[i]['BasePrice'],
        //     //   parcelBooking[i]['TotalAmount'], 'MO', 'ZAM', 'S', 'PARCEL',
        //     //   parcelBooking[i]['WeightCode'], parcelBooking[i]['Weight'], '1',
        //     //   parcelBooking[i]['SenderCustomerNumber'], parcelBooking[i]['SenderName'],
        //     //   parcelBooking[i]['SenderAddress'], parcelBooking[i]['SenderCity'],
        //     //   parcelBooking[i]['SenderZip'], parcelBooking[i]['SenderState'],
        //     //   parcelBooking[i]['SenderCountry'], parcelBooking[i]['RecipientName'],
        //     //   parcelBooking[i]['RecipientAddress'], parcelBooking[i]['RecipientCity'],
        //     //   parcelBooking[i]['RecipientZip'], parcelBooking[i]['RecipientState'],
        //     //   parcelBooking[i]['RecipientCountryID'], parcelBooking[i]['SenderName'],
        //     //   parcelBooking[i]['SenderAddress'], parcelBooking[i]['SenderCity'],
        //     //   parcelBooking[i]['SenderZip'], parcelBooking[i]['SenderState'],
        //     //   parcelBooking[i]['SenderCountry'], '0', 'DOM', 'PO21310210000',
        //     //   parcelBooking[i]['TaxAmount'], 'EMO', parcelBooking[i]['PostageDue'],
        //     //   parcelBooking[i]['PrepaidAmount'], 'REG', '', parcelBooking[i]['IsAMS'],
        //     //   parcelBooking[i]['ElapsedTime'],  parcelBooking[i]['IsFullPrepaid'],
        //     //   parcelBooking[i]['IsOnPostalService']];
        //     rows.add(bookedParcel);
        //     print(bookedParcel);
        //   }
        //
        //   String csv =
        //       const ListToCsvConverter(fieldDelimiter: "‡",eol: "\n").convert(rows)+"\n";
        //   //String fileName = 'OUT_PL_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //   String fileName =
        //       'OUT_PL_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
        //       .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //   await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
        //   final path = '$dataDirectory/Booking/$fileName';
        //   final File file = File(path);
        //   await file.writeAsString(csv, encoding: const Windows1252Codec());
        //   for (int i = 0; i < parcelBooking.length; i++) {
        //     await ParcelBooking()
        //         .select()
        //         .ArticleNumber
        //         .equals(parcelBooking[i]['ArticleNumber'])
        //         .update({
        //       'FileCreated': 'Y',
        //       'FileName': fileName,
        //       'FileCreatedDateTime': DateTimeDetails().currentDateTime()
        //     });
        //   }
        //   addFileToDB(file.toString(), path.toString(), 'Parcel Booking',
        //       DateTimeDetails().currentDateTime());
        //
        // }
        ///Creating the Speed booking file and updating the status
        final speedBooking =
        await SpeedBooking()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print(speedBooking);
        // if (speedBooking.isNotEmpty) {
        //   for (int i = 0; i < speedBooking.length; i++) {
        //     var date1 =
        //         inputFormat.parse(speedBooking[i]['BookingDate'].toString());
        //     List<List<dynamic>> rows = [];
        //     List bookedSpeed = [
        //       speedBooking[i]['FacilityId'],
        //       speedBooking[i]['BookingFacilityZip'],
        //       speedBooking[i]['DistributionChannel'],
        //       speedBooking[i]['UserID'],
        //       speedBooking[i]['CounterNumber'],
        //       speedBooking[i]['InvoiceNumber'],
        //       speedBooking[i]['TotalAmount'],
        //       // speedBooking[i]['BookingDate'].toString().substring(6,9)+speedBooking[i]['BookingDate'].toString().substring(3,4)+speedBooking[i]['BookingDate'].toString().substring(0,1)
        //       //speedBooking[i]['BookingDate'].toString(),
        //       outputFormat.format(date1).toString(),
        //       speedBooking[i]['BookingTime'],
        //       speedBooking[i]['CurrencyID'],
        //       speedBooking[i]['TenderID'],
        //       speedBooking[i]['TotalCashAmount'],
        //       speedBooking[i]['RoundOffDifference'],
        //       speedBooking[i]['CircleCode'],
        //       speedBooking[i]['LineItemNumber'],
        //       speedBooking[i]['BasePrice'],
        //       speedBooking[i]['LineItemTotalAmount'],
        //       speedBooking[i]['ArticleNumber'],
        //       speedBooking[i]['Division'],
        //       speedBooking[i]['OrderType'],
        //       speedBooking[i]['ProductType'],
        //       speedBooking[i]['ProductCode'],
        //       speedBooking[i]['WeightCode'],
        //       speedBooking[i]['Weight'],
        //       speedBooking[i]['DistanceCode'],
        //       speedBooking[i]['Distance'],
        //       speedBooking[i]['Quantity'],
        //       speedBooking[i]['SenderCustomerNumber'],
        //       speedBooking[i]['SenderName'],
        //       speedBooking[i]['SenderAddress'],
        //       speedBooking[i]['SenderAddress'],
        //       speedBooking[i]['SenderAddress'],
        //       speedBooking[i]['SenderCity'],
        //       speedBooking[i]['SenderState'],
        //       speedBooking[i]['SenderZip'],
        //       speedBooking[i]['SenderCountry'],
        //       speedBooking[i]['SenderMobile'],
        //       speedBooking[i]['RecipientName'],
        //       speedBooking[i]['RecipientAddress'],
        //       speedBooking[i]['RecipientAddress'],
        //       speedBooking[i]['RecipientCity'],
        //       speedBooking[i]['RecipientState'],
        //       speedBooking[i]['RecipientZip'],
        //       speedBooking[i]['RecipientCountryID'],
        //       speedBooking[i]['SenderName'],
        //       speedBooking[i]['SenderAddress'],
        //       speedBooking[i]['SenderState'],
        //       speedBooking[i]['SenderZip'],
        //       speedBooking[i]['SenderCountry'],
        //       speedBooking[i]['TaxAmount'],
        //       speedBooking[i]['PostageDue'],
        //       speedBooking[i]['PrepaidAmount'],
        //       speedBooking[i]['MaterialGroup'],
        //       speedBooking[i]['DestinationFacility'],
        //       speedBooking[i]['ElapsedTime'],
        //       '${speedBooking[i]['IsFullyPrepaid'] ?? ''}',
        //       speedBooking[i]['VAS'],
        //       speedBooking[i]['VASValue']
        //     ];
        //     // List bookedSpeed = [speedBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
        //     //   'PS', '54600012', '000', 'SL${speedBooking[i]['BookingDate']}${speedBooking[i]['ArticleNumber']}',
        //     //   speedBooking[i]['TotalAmount'], speedBooking[i]['BookingDate'],
        //     //   speedBooking[i]['BookingTime'], 'INR', 'S', speedBooking[i]['TotalCashAmount'],
        //     //   '0.0', '11', '1', speedBooking[i]['BasePrice'],
        //     //   speedBooking[i]['TotalAmount'], 'MO', 'ZAM', 'S', 'SP_INLAND',
        //     //   speedBooking[i]['WeightCode'], speedBooking[i]['Weight'], 'NL2',
        //     //   speedBooking[i]['Distance'],'1', speedBooking[i]['SenderCustomerNumber'],
        //     //   speedBooking[i]['SenderName'], speedBooking[i]['SenderAddress'],
        //     //   speedBooking[i]['SenderCity'], speedBooking[i]['SenderState'],
        //     //   speedBooking[i]['SenderZip'], speedBooking[i]['SenderCountry'],
        //     //   speedBooking[i]['SenderMobile'], speedBooking[i]['RecipientName'],
        //     //   speedBooking[i]['RecipientAddress'], speedBooking[i]['RecipientCity'],
        //     //   speedBooking[i]['RecipientState'], speedBooking[i]['RecipientZip'],
        //     //   speedBooking[i]['RecipientCountryID'], speedBooking[i]['SenderName'],
        //     //   speedBooking[i]['SenderAddress'], speedBooking[i]['SenderCity'],
        //     //   speedBooking[i]['SenderState'], speedBooking[i]['SenderZip'],
        //     //   speedBooking[i]['SenderCountry'], speedBooking[i]['TaxAmount'],
        //     //   speedBooking[i]['PostageDue'], speedBooking[i]['PrepaidAmount'], 'DOM',
        //     //   'PO22201301000', speedBooking[i]['ElapsedTime'],  speedBooking[i]['IsFullPrepaid'],
        //     //   '', '', 'N'];
        //     rows.add(bookedSpeed);
        //     String csv =
        //         const ListToCsvConverter(fieldDelimiter: "‡").convert(rows)+"\n";
        //     //String fileName = 'OUT_SP_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     String fileName =
        //         'OUT_SP_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
        //     final path = '$dataDirectory/Booking/$fileName';
        //     final File file = File(path);
        //     await file.writeAsString(csv, encoding: const Windows1252Codec());
        //     print("Booking Date");
        //     print(csv);
        //     await SpeedBooking()
        //         .select()
        //         .ArticleNumber
        //         .equals(speedBooking[i]['ArticleNumber'])
        //         .update({
        //       'FileCreated': 'Y',
        //       'FileName': fileName,
        //       'FileCreatedDateTime': DateTimeDetails().currentDateTime(),
        //     });
        //     addFileToDB(file.toString(), path.toString(), 'Speed Post Booking',
        //         DateTimeDetails().currentDateTime());
        //   }
        // }
        if (speedBooking.isNotEmpty) {
          List<List<dynamic>> rows = [];
          for (int i = 0; i < speedBooking.length; i++) {
            var date1 =
            inputFormat.parse(speedBooking[i]['BookingDate'].toString());

            List bookedSpeed = [
              speedBooking[i]['FacilityId'],
              speedBooking[i]['BookingFacilityZip'],
              speedBooking[i]['DistributionChannel'],
              speedBooking[i]['UserID'],
              speedBooking[i]['CounterNumber'],
              speedBooking[i]['InvoiceNumber'],
              speedBooking[i]['TotalAmount'],
              // speedBooking[i]['BookingDate'].toString().substring(6,9)+speedBooking[i]['BookingDate'].toString().substring(3,4)+speedBooking[i]['BookingDate'].toString().substring(0,1)
              //speedBooking[i]['BookingDate'].toString(),
              outputFormat.format(date1).toString(),
              speedBooking[i]['BookingTime'],
              speedBooking[i]['CurrencyID'],
              speedBooking[i]['TenderID'],
              speedBooking[i]['TotalCashAmount'],
              speedBooking[i]['RoundOffDifference'],
              speedBooking[i]['CircleCode'],
              speedBooking[i]['LineItemNumber'],
              speedBooking[i]['BasePrice'],
              speedBooking[i]['LineItemTotalAmount'],
              speedBooking[i]['ArticleNumber'],
              speedBooking[i]['Division'],
              speedBooking[i]['OrderType'],
              speedBooking[i]['ProductType'],
              speedBooking[i]['ProductCode'],
              speedBooking[i]['WeightCode'],
              speedBooking[i]['Weight'],
              speedBooking[i]['DistanceCode'],
              speedBooking[i]['Distance'],
              speedBooking[i]['Quantity'],
              speedBooking[i]['SenderCustomerNumber'],
              speedBooking[i]['SenderName'],
              speedBooking[i]['SenderAddress'],
              speedBooking[i]['SenderAddress'],
              speedBooking[i]['SenderAddress'],
              speedBooking[i]['SenderCity'],
              speedBooking[i]['SenderState'],
              speedBooking[i]['SenderZip'],
              speedBooking[i]['SenderCountry'],
              speedBooking[i]['SenderMobile'],
              speedBooking[i]['RecipientName'],
              speedBooking[i]['RecipientAddress'],
              speedBooking[i]['RecipientAddress'],
              speedBooking[i]['RecipientCity'],
              speedBooking[i]['RecipientState'],
              speedBooking[i]['RecipientZip'],
              speedBooking[i]['RecipientCountryID'],
              speedBooking[i]['SenderName'],
              speedBooking[i]['SenderAddress'],
              speedBooking[i]['SenderState'],
              speedBooking[i]['SenderZip'],
              speedBooking[i]['SenderCountry'],
              speedBooking[i]['TaxAmount'],
              speedBooking[i]['PostageDue'],
              speedBooking[i]['PrepaidAmount'],
              speedBooking[i]['MaterialGroup'],
              speedBooking[i]['DestinationFacility'],
              speedBooking[i]['ElapsedTime'],
              '${speedBooking[i]['IsFullyPrepaid'] ?? ''}',
              speedBooking[i]['VAS'],
              speedBooking[i]['VASValue']
            ];
            // List bookedSpeed = [speedBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
            //   'PS', '54600012', '000', 'SL${speedBooking[i]['BookingDate']}${speedBooking[i]['ArticleNumber']}',
            //   speedBooking[i]['TotalAmount'], speedBooking[i]['BookingDate'],
            //   speedBooking[i]['BookingTime'], 'INR', 'S', speedBooking[i]['TotalCashAmount'],
            //   '0.0', '11', '1', speedBooking[i]['BasePrice'],
            //   speedBooking[i]['TotalAmount'], 'MO', 'ZAM', 'S', 'SP_INLAND',
            //   speedBooking[i]['WeightCode'], speedBooking[i]['Weight'], 'NL2',
            //   speedBooking[i]['Distance'],'1', speedBooking[i]['SenderCustomerNumber'],
            //   speedBooking[i]['SenderName'], speedBooking[i]['SenderAddress'],
            //   speedBooking[i]['SenderCity'], speedBooking[i]['SenderState'],
            //   speedBooking[i]['SenderZip'], speedBooking[i]['SenderCountry'],
            //   speedBooking[i]['SenderMobile'], speedBooking[i]['RecipientName'],
            //   speedBooking[i]['RecipientAddress'], speedBooking[i]['RecipientCity'],
            //   speedBooking[i]['RecipientState'], speedBooking[i]['RecipientZip'],
            //   speedBooking[i]['RecipientCountryID'], speedBooking[i]['SenderName'],
            //   speedBooking[i]['SenderAddress'], speedBooking[i]['SenderCity'],
            //   speedBooking[i]['SenderState'], speedBooking[i]['SenderZip'],
            //   speedBooking[i]['SenderCountry'], speedBooking[i]['TaxAmount'],
            //   speedBooking[i]['PostageDue'], speedBooking[i]['PrepaidAmount'], 'DOM',
            //   'PO22201301000', speedBooking[i]['ElapsedTime'],  speedBooking[i]['IsFullPrepaid'],
            //   '', '', 'N'];
            rows.add(bookedSpeed);
          }
          String csv =
              const ListToCsvConverter(fieldDelimiter: "‡", eol: "\n").convert(
                  rows) + "\n";
          //String fileName = 'OUT_SP_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          String fileName =
              'OUT_SP_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
          final path = '$dataDirectory/Booking/$fileName';
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          print("Booking Date");
          print(csv);
          for (int i = 0; i < speedBooking.length; i++) {
            await SpeedBooking()
                .select()
                .ArticleNumber
                .equals(speedBooking[i]['ArticleNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime(),
            });
          }
          addFileToDB(file.toString(), path.toString(), 'Speed Post Booking',
              DateTimeDetails().currentDateTime());
        }

        ///Creating the EMO file and updating the status
        final emoBooking =
        await EmoBooking()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("emoBooking test");
        print(emoBooking);
        if (emoBooking.isNotEmpty) {
          List<List<dynamic>> rows = [];
          for (int i = 0; i < emoBooking.length; i++) {
            var date1 =
            inputFormat.parse(emoBooking[i]['BookingDate'].toString());

            //List<List<dynamic>> rows = [];
            List bookedEMO = [
              emoBooking[i]['FacilityId'],
              emoBooking[i]['BookingFacilityZip'],
              emoBooking[i]['DistributionChannel'],
              emoBooking[i]['UserID'],
              emoBooking[i]['CounterNumber'],
              emoBooking[i]['InvoiceNumber'],
              emoBooking[i]['TotalAmount'],
              outputFormat.format(date1).toString(),
              emoBooking[i]['BookingTime'],
              emoBooking[i]['CurrencyID'],
              emoBooking[i]['TenderID'],
              emoBooking[i]['TotalCashAmount'],
              emoBooking[i]['RoundOffDifference'],
              emoBooking[i]['CheckerUserID'],
              emoBooking[i]['CircleCode'],
              emoBooking[i]['LineItemNumber'],
              emoBooking[i]['BasePrice'],
              emoBooking[i]['LineItemTotalAmount'],
              emoBooking[i]['Division'],
              emoBooking[i]['OrderType'],
              emoBooking[i]['ProductType'],
              emoBooking[i]['ProductCode'],
              emoBooking[i]['ValueCode'],
              emoBooking[i]['Value'],
              emoBooking[i]['Quantity'],
              emoBooking[i]['SenderCustomerNumber'],
              emoBooking[i]['SenderName'],
              emoBooking[i]['SenderAddress'],
              emoBooking[i]['SenderCity'],
              emoBooking[i]['SenderState'],
              emoBooking[i]['SenderZip'],
              emoBooking[i]['SenderCountry'],
              emoBooking[i]['RecipientName'],
              emoBooking[i]['RecipientAddress'],
              emoBooking[i]['RecipientCity'],
              emoBooking[i]['RecipientState'],
              emoBooking[i]['RecipientZip'],
              emoBooking[i]['RecipientCountryID'],
              emoBooking[i]['RecipientMobile'],
              emoBooking[i]['RecipientEmail'],
              emoBooking[i]['SenderName'],
              emoBooking[i]['SenderAddress'],
              emoBooking[i]['SenderCity'],
              emoBooking[i]['SenderState'],
              emoBooking[i]['SenderZip'],
              emoBooking[i]['SenderCountry'],
              emoBooking[i]['CommissionAmount'],
              emoBooking[i]['MaterialGroup'],
              emoBooking[i]['DestinationFacility'],
              emoBooking[i]['SenderMoneyTransferValue'],
              emoBooking[i]['MOTrackingID'],
              emoBooking[i]['MOMessage'],
              emoBooking[i]['ElapsedTime'],
              emoBooking[i]['BulkAddressType'],
              emoBooking[i]['VPMOIdentifier']
            ];
            // List bookedEMO = [emoBooking[i]['ArticleNumber'], 'BO11304216001', '570010',
            //   'PS', '54600012', '000', 'SL${emoBooking[i]['BookingDate']}${emoBooking[i]['ArticleNumber']}',
            //   emoBooking[i]['TotalAmount'], emoBooking[i]['BookingDate'],
            //   emoBooking[i]['BookingTime'], 'INR', 'S', emoBooking[i]['TotalCashAmount'],
            //   '0.0', '50015379', '11', '1', emoBooking[i]['BasePrice'],
            //   emoBooking[i]['TotalAmount'], 'MO', emoBooking[i]['OrderType'],
            //   emoBooking[i]['ProductType'], 'EMO', emoBooking[i]['ValueCode'],
            //   emoBooking[i]['Value'], '1',  emoBooking[i]['SenderCustomerNumber'],
            //   emoBooking[i]['SenderName'], emoBooking[i]['SenderAddress'],
            //   emoBooking[i]['SenderCity'], emoBooking[i]['SenderState'],
            //   emoBooking[i]['SenderZip'], emoBooking[i]['SenderCountry'],
            //   emoBooking[i]['RecipientName'], emoBooking[i]['RecipientAddress'],
            //   emoBooking[i]['RecipientCity'], emoBooking[i]['RecipientState'],
            //   emoBooking[i]['RecipientZip'], emoBooking[i]['RecipientCountryID'],
            //   emoBooking[i]['RecipientMobile'], emoBooking[i]['RecipientEmail'],
            //   emoBooking[i]['SenderName'], emoBooking[i]['SenderAddress'],
            //   emoBooking[i]['SenderCity'], emoBooking[i]['SenderState'],
            //   emoBooking[i]['SenderZip'], emoBooking[i]['SenderCountry'],
            //   emoBooking[i]['CommissionAmount'], 'DMR', 'PO21310210000',
            //   emoBooking[i]['SenderMoneyTransferValue'], emoBooking[i]['MOTrackingID'],
            //   emoBooking[i]['MOMessage'], '', '0', ''];
            rows.add(bookedEMO);
          }
          String csv =
              const ListToCsvConverter(fieldDelimiter: "‡").convert(rows) +
                  "\n";
          //String fileName = 'OUT_MO_B_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          String fileName =
              'OUT_MO_B_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
          final path = '$dataDirectory/Booking/$fileName';
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < emoBooking.length; i++) {
            await EmoBooking()
                .select()
                .ArticleNumber
                .equals(emoBooking[i]['ArticleNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
          }
          addFileToDB(file.toString(), path.toString(), 'MO Booking',
              DateTimeDetails().currentDateTime());
        }

        ///Creating the Cancelled Letter file and updating in the DB
        // final cancelledLetter = await CancelBooking().select()
        //     .startBlock.FileCreated.equals('N').and.ProductCode.not.equals('E_PAYMENT').endBlock
        //     .toMapList();
        final cancelledLetter =
        await CancelBooking()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("Cancelled Article");
        print(cancelledLetter);
        if (cancelledLetter.isNotEmpty) {
          for (int i = 0; i < cancelledLetter.length; i++) {
            var date1 =
            inputFormat.parse(cancelledLetter[i]['BookingDate'].toString());

            List<List<dynamic>> rows = [];
            List cancel = [
              cancelledLetter[i]['FacilityId'],
              cancelledLetter[i]['BookingFacilityZip'],
              cancelledLetter[i]['DistributionChannel'],
              cancelledLetter[i]['UserId'],
              cancelledLetter[i]['CounterNumber'],
              cancelledLetter[i]['InvoiceNumber'],
              cancelledLetter[i]['TotalAmount'],
              outputFormat.format(date1).toString(),
              cancelledLetter[i]['BookingTime'],
              cancelledLetter[i]['CurrencyId'],
              cancelledLetter[i]['TenderId'],
              cancelledLetter[i]['TotalCashAmount'],
              cancelledLetter[i]['RoundOffDifferenceAmount'],
              cancelledLetter[i]['ParentInvoiceNumber'],
              cancelledLetter[i]['CircleCode'],
              cancelledLetter[i]['LineItemNumber'],
              cancelledLetter[i]['BasePrice'],
              cancelledLetter[i]['LineItemTotalAmount'],
              cancelledLetter[i]['ArticleNumber'],
              cancelledLetter[i]['Division'],
              cancelledLetter[i]['OrderType'],
              cancelledLetter[i]['ProductType'],
              cancelledLetter[i]['ProductCode'],
              cancelledLetter[i]['WeightCode'],
              cancelledLetter[i]['Weight'],
              cancelledLetter[i]['Quantity'],
              cancelledLetter[i]['ValueCode'] ?? '',
              cancelledLetter[i]['Value'] ?? '',
              cancelledLetter[i]['DistanceCode'],
              cancelledLetter[i]['Distance'],
              cancelledLetter[i]['SenderCustomerId'],
              cancelledLetter[i]['RecipientCountryId'],
              cancelledLetter[i]['IsReversed'] ?? '',
              cancelledLetter[i]['TaxAmount'],
              cancelledLetter[i]['PostageDue'],
              cancelledLetter[i]['PrepaidAmount'],
              cancelledLetter[i]['MaterialGroup'],
              cancelledLetter[i]['SerialNumber'] ?? '',
              cancelledLetter[i]['IsFullPrepaid'] ?? '',
              cancelledLetter[i]['VAS'],
              cancelledLetter[i]['VASValue']
            ];
            rows.add(cancel);
            print(cancelledLetter);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_CN_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            String fileName =
                'OUT_CN_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await CancelBooking()
                .select()
                .ArticleNumber
                .equals(cancelledLetter[i]['ArticleNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
            addFileToDB(file.toString(), path.toString(), 'Cancel Booking',
                DateTimeDetails().currentDateTime());
          }
        }

        ///Creating the Cancelled Biller Tran file and updating in the DB
        final cancelledBiller =
        await CancelBiller()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("Cancelled Biller Tran");
        print(cancelledBiller);
        // var inputFormatcbill = DateFormat('ddMMyyyy');
        // var outputFormatcbill = DateFormat('yyyyMMdd');
        if (cancelledBiller.isNotEmpty) {
          for (int i = 0; i < cancelledBiller.length; i++) {
            // var date1 = inputFormatcbill.parse(cancelledBiller[i]['BookingDate'].toString());
            List<List<dynamic>> rows = [];
            List cancel = [
              cancelledBiller[i]['FacilityId'],
              cancelledBiller[i]['BookingFacilityZip'],
              cancelledBiller[i]['DistributionChannel'],
              cancelledBiller[i]['UserId'],
              cancelledBiller[i]['CounterNumber'],
              cancelledBiller[i]['InvoiceNumber'],
              cancelledBiller[i]['TotalAmount'],
              //outputFormatcbill.format(date1).toString()
              cancelledBiller[i]['BookingDate'].toString().substring(4) +
                  cancelledBiller[i]['BookingDate'].toString().substring(2, 4) +
                  cancelledBiller[i]['BookingDate'].toString().substring(0, 2),
              cancelledBiller[i]['BookingTime'],
              cancelledBiller[i]['CurrencyId'],
              cancelledBiller[i]['TenderId'],
              cancelledBiller[i]['TotalCashAmount'],
              cancelledBiller[i]['RoundOffDifferenceAmount'],
              cancelledBiller[i]['ParentInvoiceNumber'],
              cancelledBiller[i]['CircleCode'],
              cancelledBiller[i]['LineItemNumber'],
              cancelledBiller[i]['LineItemTotalAmount'],
              cancelledBiller[i]['ArticleNumber'],
              cancelledBiller[i]['Division'],
              cancelledBiller[i]['OrderType'],
              cancelledBiller[i]['ProductType'],
              cancelledBiller[i]['ProductCode'],
              cancelledBiller[i]['ValueCode'],
              cancelledBiller[i]['Value'],
              cancelledBiller[i]['Quantity'],
              cancelledBiller[i]['SenderCustomerId'],
              cancelledBiller[i]['IsReversed'],
              cancelledBiller[i]['MaterialGroup'],
              cancelledBiller[i]['SerialNumber'],
              cancelledBiller[i]['AddlBillInfo'],
              cancelledBiller[i]['AddlBillAmountInfo'],
              cancelledBiller[i]['BillerID']
            ];
            rows.add(cancel);
            print("Cancelled BIller");
            print(cancelledBiller);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_CN_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            String fileName =
                'OUT_CN_TPB_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await CancelBiller()
                .select()
                .ArticleNumber
                .equals(cancelledBiller[i]['ArticleNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
            addFileToDB(file.toString(), path.toString(), 'Cancel Biller',
                DateTimeDetails().currentDateTime());
          }
        }

        ///Creating the Product file and updating in the DB
        final products =
        await ProductSaleTable()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        print("Product sale ");
        print(products);
        //var inputFormatps = DateFormat('ddMMyyyy');
        // if (products.isNotEmpty) {
        //   for (int i = 0; i < products.length; i++) {
        //     //var date1 = inputFormatps.parse(products[i]['BookingDate'].toString());
        //     List<List<dynamic>> rows = [];
        //     List soldProduct = [
        //       products[i]['FacilityId'],
        //       products[i]['BookingFacilityZip'],
        //       products[i]['DistributionChannel'],
        //       products[i]['UserId'],
        //       products[i]['CounterNumber'],
        //       products[i]['InvoiceNumber'],
        //       products[i]['TotalAmount'],
        //       products[i]['BookingDate'].toString().substring(4) +
        //           products[i]['BookingDate'].toString().substring(2, 4) +
        //           products[i]['BookingDate'].toString().substring(0, 2),
        //       //outputFormat.format(date1).toString(),
        //       products[i]['BookingTime'],
        //       products[i]['CurrencyId'],
        //       products[i]['TenderId'],
        //       products[i]['TotalCashAmount'],
        //       products[i]['RoundOffDifference'],
        //       products[i]['CircleCode'],
        //       products[i]['LineItemNumber'],
        //       products[i]['BasePrice'],
        //       products[i]['LineItemTotalAmount'],
        //       products[i]['Division'],
        //       products[i]['OrderType'],
        //       products[i]['ProductType'],
        //       products[i]['ProductCode'],
        //       products[i]['Quantity'],
        //       products[i]['SenderCustomerId'],
        //       products[i]['MaterialGroup'],
        //       products[i]['DestinationFacilityId'],
        //       products[i]['UoM'],
        //       products[i]['ElapsedTime']
        //     ];
        //     // List soldProduct = ['BO22202101002', '690573', 'PS', '50171362', '000',
        //     //   products[i]['InvoiceNumber'], products[i]['TotalAmount'], products[i]['BookingDate'],
        //     //   products[i]['BookingTime'], 'INR', 'S', products[i]['TotalAmount'], '0', '22',
        //     //   '1', products[i]['BasePrice'], products[i]['TotalAmount'], 'PH', 'ZRP', 'NS',
        //     //   products[i]['ProductCode'], products[i]['Quantity'], '7000000013', 'DEFS',
        //     //   'BO22202101002', 'EA', '000037'];
        //     rows.add(soldProduct);
        //     print("Product sale row");
        //     print(soldProduct);
        //     String csv =
        //         const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
        //     //String fileName = 'OUT_PS_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     String fileName =
        //         'OUT_PS_${ofcMaster[0].BOFacilityID}_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
        //     await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
        //     final path = '$dataDirectory/Booking/$fileName';
        //     final File file = File(path);
        //     await file.writeAsString(csv, encoding: const Windows1252Codec());
        //     await ProductSaleTable()
        //         .select()
        //         .id
        //         .equals(products[i]['id'])
        //         .update({
        //       'FileCreated': 'Y',
        //       'FileName': fileName,
        //       'FileCreatedDate': DateTimeDetails().currentDateTime()
        //     });
        //     addFileToDB(file.toString(), path.toString(), 'Product Sale',
        //         DateTimeDetails().currentDateTime());
        //   }
        // }
        if (products.isNotEmpty) {
          List<List<dynamic>> rows = [];
          for (int i = 0; i < products.length; i++) {
            //var date1 = inputFormatps.parse(products[i]['BookingDate'].toString());

            List soldProduct = [
              products[i]['FacilityId'],
              products[i]['BookingFacilityZip'],
              products[i]['DistributionChannel'],
              products[i]['UserId'],
              products[i]['CounterNumber'],
              products[i]['InvoiceNumber'],
              products[i]['TotalAmount'],
              products[i]['BookingDate'].toString().substring(4) +
                  products[i]['BookingDate'].toString().substring(2, 4) +
                  products[i]['BookingDate'].toString().substring(0, 2),
              //outputFormat.format(date1).toString(),
              products[i]['BookingTime'],
              products[i]['CurrencyId'],
              products[i]['TenderId'],
              products[i]['TotalCashAmount'],
              products[i]['RoundOffDifference'],
              products[i]['CircleCode'],
              products[i]['LineItemNumber'],
              products[i]['BasePrice'],
              products[i]['LineItemTotalAmount'],
              products[i]['Division'],
              products[i]['OrderType'],
              products[i]['ProductType'],
              products[i]['ProductCode'],
              products[i]['Quantity'],
              products[i]['SenderCustomerId'],
              products[i]['MaterialGroup'],
              products[i]['DestinationFacilityId'],
              products[i]['UoM'],
              products[i]['ElapsedTime']
            ];
            // List soldProduct = ['BO22202101002', '690573', 'PS', '50171362', '000',
            //   products[i]['InvoiceNumber'], products[i]['TotalAmount'], products[i]['BookingDate'],
            //   products[i]['BookingTime'], 'INR', 'S', products[i]['TotalAmount'], '0', '22',
            //   '1', products[i]['BasePrice'], products[i]['TotalAmount'], 'PH', 'ZRP', 'NS',
            //   products[i]['ProductCode'], products[i]['Quantity'], '7000000013', 'DEFS',
            //   'BO22202101002', 'EA', '000037'];
            rows.add(soldProduct);
          }
          print("Product sale row");
          //print(soldProduct);
          String csv =
              const ListToCsvConverter(fieldDelimiter: "‡", eol: "\n").convert(
                  rows) + "\n";
          //String fileName = 'OUT_PS_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          String fileName =
              'OUT_PS_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
          final path = '$dataDirectory/Booking/$fileName';
          final File file = File(path);
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < products.length; i++) {
            await ProductSaleTable()
                .select()
                .id
                .equals(products[i]['id'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDate': DateTimeDetails().currentDateTime()
            });
          }
          addFileToDB(file.toString(), path.toString(), 'Product Sale',
              DateTimeDetails().currentDateTime());
        }

        ///Creating the Day Model file and updating in the DB
        var inputFormatDB = DateFormat('dd-MM-yyyy HH:mm:ss');
        var outputFormatDB = DateFormat('yyyy-MM-dd HH:mm:ss');
        final dayDetail =
        await DayBegin()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        if (dayDetail.isNotEmpty) {
          for (int i = 0; i < dayDetail.length; i++) {
            var date1 = inputFormatDB
                .parse(dayDetail[i]['DayBeginTimeStamp1'].toString());
            var date2 = inputFormatDB
                .parse(dayDetail[i]['DayBeginTimeStamp1'].toString());
            List<List<dynamic>> rows = [];
            List detailDay = [
              dayDetail[i]['BPMId'],
              outputFormatDB.format(date1).toString(),
              outputFormatDB.format(date2).toString()
            ];
            rows.add(detailDay);
            print("Day Begin");
            print(detailDay);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_DB_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            String fileName =
                'OUT_DB_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await DayBegin()
                .select()
                .id
                .equals(dayDetail[i]['id'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
            addFileToDB(file.toString(), path.toString(), 'Day Begin Upload',
                DateTimeDetails().currentDateTime());
          }
        }

        ///Creating Cash Indent file and updating in the DB
        final cashIndent =
        await CashIndent()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        if (cashIndent.isNotEmpty) {
          for (int i = 0; i < cashIndent.length; i++) {
            List<List<dynamic>> rows = [];
            List indentCash = [
              cashIndent[i]['SOSlipNumber'],
              cashIndent[i]['SOGenerationDate'].toString().substring(4) +
                  cashIndent[i]['SOGenerationDate'].toString().substring(2, 4) +
                  cashIndent[i]['SOGenerationDate'].toString().substring(0, 2),
              cashIndent[i]['ChequeNumber'],
              cashIndent[i]['BOName'],
              cashIndent[i]['SOName'],
              cashIndent[i]['CashAmount'],
              cashIndent[i]['Weight'],
              cashIndent[i]['ChequeAmount'],
              cashIndent[i]['AmountType']
            ];
            rows.add(indentCash);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_CI_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}_968.csv';
            String fileName =
                'OUT_CI_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}_968.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await CashIndent()
                .select()
                .SOSlipNumber
                .equals(cashIndent[i]['SOSlipNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
            addFileToDB(file.toString(), path.toString(), 'Cash Indent Upload',
                DateTimeDetails().currentDateTime());
          }
        }

        ///Creating Excess cash from Bag file & Updating in the DB
        final excessCash = await ExcessBagCashTable()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        if (excessCash.isNotEmpty) {
          for (int i = 0; i < excessCash.length; i++) {
            List<List<dynamic>> rows = [];
            List excess = [
              excessCash[i]['SOSlipNumber'],
              //excessCash[i]['GenerationDate'],
              excessCash[i]['GenerationDate'].toString().substring(6) +
                  excessCash[i]['GenerationDate'].toString().substring(3, 5) +
                  excessCash[i]['GenerationDate'].toString().substring(0, 2),
              excessCash[i]['ChequeNumber'],
              excessCash[i]['BOName'],
              excessCash[i]['SOName'],
              excessCash[i]['CashAmount'],
              excessCash[i]['Weight'],
              excessCash[i]['ChequeAmount'],
              excessCash[i]['TypeOfPayment'],
              excessCash[i]['Miscellaneous']
            ];
            rows.add(excess);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_EC_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}_965.csv';
            String fileName =
                'OUT_EC_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}_965.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await ExcessBagCashTable()
                .select()
                .SOSlipNumber
                .equals(excessCash[i]['SOSlipNumber'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
          }
        }

        ///Creating Documents File and updating in the DB
        final documents =
        await DocumentTable()
            .select()
            .FileCreated
            .equals('N')
            .toMapList();
        if (documents.isNotEmpty) {
          for (int i = 0; i < documents.length; i++) {
            List<List<dynamic>> rows = [];
            List document = [
              documents[i]['BOAccountNumber'],
              documents[i]['CreatedOn'].toString().substring(6) +
                  documents[i]['CreatedOn'].toString().substring(3, 5) +
                  documents[i]['CreatedOn'].toString().substring(0, 2),
              documents[i]['FromOffice'],
              documents[i]['DocumentDetails']
            ];
            rows.add(document);
            String csv =
            const ListToCsvConverter(fieldDelimiter: "‡").convert(rows);
            //String fileName = 'OUT_DOC_BO11304216001_${DateTimeDetails().dateCharacter()}_${DateTimeDetails().timeCharacter()}_963.csv';
            String fileName =
                'OUT_DOC_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
                .dateCharacter()}_${DateTimeDetails().timeCharacter()}_963.csv';
            await FILE_SYNC_DETAILS(FILE_NAME: fileName).upsert1();
            final path = '$dataDirectory/Booking/$fileName';
            final File file = File(path);
            await file.writeAsString(csv, encoding: const Windows1252Codec());
            await DocumentTable()
                .select()
                .DocumentId
                .equals(documents[i]['DocumentId'])
                .update({
              'FileCreated': 'Y',
              'FileName': fileName,
              'FileCreatedDateTime': DateTimeDetails().currentDateTime()
            });
          }
        }

        ///Biller transaction File and updating in the DB
        //ADDED BY RAKESH 10082022
        print("Bill File start");
        final Bil_File = await BookingModel().execDataTable(billfile);
        print(Bil_File);
        Map billfiledata = Bil_File.asMap();
        print(billfiledata);
        List<List<dynamic>> billfilerows = [];
        for (int i = 0; i < billfiledata.length; i++) {
          List<dynamic> row = [];
          row.add(billfiledata[i]['FacilityId']);
          row.add(billfiledata[i]['Zip']);
          row.add(billfiledata[i]['Channel']);
          row.add(billfiledata[i]['UserId']);
          row.add(billfiledata[i]['CounterNumber']);
          row.add(billfiledata[i]['InvoiceNumber']);
          row.add(billfiledata[i]['TotalAmount']);
          row.add(billfiledata[i]['BookingDate'].toString().substring(4) +
              billfiledata[i]['BookingDate'].toString().substring(2, 4) +
              billfiledata[i]['BookingDate'].toString().substring(0, 2));
          row.add(billfiledata[i]['BookingTime']);
          row.add(billfiledata[i]['CurrencyId']);
          row.add(billfiledata[i]['TenderId']);
          row.add(billfiledata[i]['TotalCashAmount']);
          row.add(billfiledata[i]['RoundOffDifference']);
          row.add(billfiledata[i]['CircleCode']);
          row.add(billfiledata[i]['LineItemNumber']);
          row.add(billfiledata[i]['LineItemTotalAmount']);
          row.add(billfiledata[i]['ArticleNumber']);
          row.add(billfiledata[i]['Division']);
          row.add(billfiledata[i]['OrderType']);
          row.add(billfiledata[i]['ProductType']);
          row.add(billfiledata[i]['ProductCode']);
          row.add(billfiledata[i]['ValueCode']);
          row.add(billfiledata[i]['Value']);
          row.add(billfiledata[i]['Quantity']);
          row.add(billfiledata[i]['CustomerId']);
          row.add(billfiledata[i]['MaterialGroup']);
          row.add(billfiledata[i]['DestinationFacilityId']);
          row.add(billfiledata[i]['ElapsedTime']);
          row.add(billfiledata[i]['AdditionalBillInfo']);
          row.add(billfiledata[i]['AdditionalBillAmountInfo']);
          row.add(billfiledata[i]['BillerId']);

          billfilerows.add(row);
          print(row);
        }
        //Biller Transactions
        if (billfilerows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(billfilerows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Booking";
          final filename =
              'OUT_TPB_BSNL_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          //Rakesh Addition completed
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < billfilerows.length; i++) {
            await BillFile()
                .select()
                .InvoiceNumber
                .equals(billfilerows[i][5])
                .update({
              'IS_COMMUNICATED': 0,
              'File_Name': filename,
            });
          }
        }
        //

        //ADDITION COMPLLETED

        ///Special Remittance File and updating in the DB
        //ADDED BY RAKESH 10082022
        print("Special Remittance start");
        final Spl_File = await BookingModel().execDataTable(Splfile);
        print(Spl_File);
        Map splfiledata = Spl_File.asMap();
        print(splfiledata);
        List<List<dynamic>> splfilerows = [];
        for (int i = 0; i < splfiledata.length; i++) {
          List<dynamic> row = [];
          row.add(splfiledata[i]['SlipNumber']);
          //row.add(splfiledata[i]['Date']);
          row.add(splfiledata[i]['Date'].toString().substring(4) +
              splfiledata[i]['Date'].toString().substring(2, 4) +
              splfiledata[i]['Date'].toString().substring(0, 2));
          row.add(splfiledata[i]['ChequeNumber']);
          row.add(splfiledata[i]['BOProfitName']);
          row.add(splfiledata[i]['SOProfitName']);
          row.add(splfiledata[i]['CashAmount']);
          row.add(splfiledata[i]['Weight']);
          row.add(splfiledata[i]['ChequeAmount']);
          row.add(splfiledata[i]['ChequeCash']);
          splfilerows.add(row);
          print(row);
        }
        if (splfilerows.isNotEmpty) {
          String csv =
          const ListToCsvConverter(fieldDelimiter: "‡").convert(splfilerows);
          final String directory = "storage/emulated/0/Darpan_Mine/Uploads/Booking";
          final filename =
              'OUT_SR_${ofcMaster[0].BOFacilityID}_${DateTimeDetails()
              .dateCharacter()}_${DateTimeDetails().timeCharacter()}_970.csv';
          await FILE_SYNC_DETAILS(FILE_NAME: filename).upsert1();
          //Rakesh Addition completed
          final path = "$directory/$filename";
          final File file = await File(path).create();
          await file.writeAsString(csv, encoding: const Windows1252Codec());
          for (int i = 0; i < splfilerows.length; i++) {
            await SpecialRemittanceFile()
                .select()
                .SlipNumber
                .equals(splfilerows[i][0])
                .update({
              'IS_COMMUNICATED': 0,
              'File_Name': filename,
            });
          }
        }
        //

        //ADDITION COMPLLETED
        if (letterBooking.isNotEmpty ||
            parcelBooking.isNotEmpty ||
            speedBooking.isNotEmpty ||
            emoBooking.isNotEmpty ||
            cancelledLetter.isNotEmpty ||
            products.isNotEmpty ||
            dayDetail.isNotEmpty ||
            cashIndent.isNotEmpty ||
            excessCash.isNotEmpty ||
            documents.isNotEmpty ||
            billfilerows.isNotEmpty ||
            splfilerows.isNotEmpty ||
            cancelledBiller.isNotEmpty) {
          final dataDir = Directory(
              "storage/emulated/0/Darpan_Mine/Uploads/Booking");
          //zipFile = File("storage/emulated/0/Darpan_Mine/UploadCSV/Book_BO112PO112${DateTimeDetails().filetimeformat()}.zip");
          zipFile = File(
              "storage/emulated/0/Darpan_Mine/UploadCSV/Book_${ofcMaster[0]
                  .BOFacilityID}${DateTimeDetails().filetimeformat()}.zip");
          // final zipFile=File("storage/emulated/0/Darpan_Mine/UploadCSV/${(filename.substring(filename.length,filename.length-5))}.zip");
          print("ZipFile Created: ${zipFile}");
          final zipFileDir = "storage/emulated/0/Darpan_Mine/UploadCSV";
          var zipFiletemp = await zipFile.path
              .toString()
              .split("storage/emulated/0/Darpan_Mine/UploadCSV/")[1];
          if (await zipFile.exists()) {
            print("Already exists");
            zipFile.delete();
            print("Deleted");
          }
          await zipFile.create();
          await ZipFile.createFromDirectory(
              sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
          //File Deletion after Zipping
          var files = io.Directory("storage/emulated/0/Darpan_Mine/Uploads/Booking")
              .listSync();
          print(files.length);

          for (int i = 0; i < files.length; i++) {
            await FILE_SYNC_DETAILS()
                .select()
                .FILE_NAME
                .equals(files[i]
                .path
                .toString()
                .split("storage/emulated/0/Darpan_Mine/Uploads/Booking/")[1])
                .update({
              'ZIP_FILE_NAME': zipFiletemp,
              'STATUS': "0",
              'LAST_UPDATED_DT': DateTimeDetails().currentDateTime()
            });
          }

          for (int i = 0; i < files.length; i++) {
            print(files[i]);
            files[i].deleteSync();
          }
        }

        var folderfilestemp = await FILE_SYNC_DETAILS()
            .distinct(columnsToSelect: ["ZIP_FILE_NAME"])
            .STATUS
            .equals("0")
            .toList();
        print(folderfilestemp);

        for (int i = 0; i < folderfilestemp.length; i++) {
          folderfiles.add(folderfilestemp[i].ZIP_FILE_NAME);
        }
        // folderfiles = io.Directory('storage/emulated/0/Darpan_Mine/UploadCSV').listSync();
        print("Files count upload" + folderfiles.length.toString());
        // for (int i = 0; i < folderfiles.length; i++) {
        //   print(folderfiles[i].path.toString());
        //
        //   // var request = http.MultipartRequest('POST', Uri.parse('https://gateway.cept.gov.in:443/api/uploadFile'));
        //   var request = http.MultipartRequest('POST', Uri.parse('https://gateway.cept.gov.in/darpan/api/v3/uploadFile'));
        //   request.files.add(await http.MultipartFile.fromPath('file', '${folderfiles[i].path.toString()}'));
        //   http.StreamedResponse response = await request.send();
        //   if (response.statusCode == 200) {
        //     // print(await response.stream.bytesToString());
        //     String res=await response.stream.bytesToString();
        //     print(res);
        //     var temp=json.decode(res);
        //     print(temp);
        //     print(temp.length);
        //
        //     print(temp['fileName']);
        //
        //     String syncdir = (Directory('storage/emulated/0/Darpan_Mine/Screenshots')).path;
        //     try {
        //       print("Try Start");
        //       String fname=temp['fileName'].toString();
        //       await File("storage/emulated/0/Darpan_Mine/UploadCSV/$fname").rename("storage/emulated/0/Darpan_Mine/Screenshots/$fname");
        //       //Updating the IS_COMMUNICATED flag for tables
        //       final zipFile=await File("storage/emulated/0/Darpan_Mine/Screenshots/$fname");
        //       await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: Directory('storage/emulated/0/Darpan_Mine/Screenshots'));
        //       final dir=await Directory('storage/emulated/0/Darpan_Mine/Screenshots');
        //       final List<FileSystemEntity> entities = await dir.list().toList();
        //       for(int i=0;i<entities.length;i++) {
        //         print("File Names:");
        //         print(entities[i].toString());
        //         await Delivery()
        //             .select()
        //             .FILE_NAME
        //             .equals('${entities[i].toString()}.csv')
        //             .update({'IS_COMMUNICATED': '1'});
        //       }
        //       //await File(zipFile.path).delete();
        //     }catch(e){
        //       // UtilFs.showToast("Error in FIle Updating/File Movement",context);
        //       print("Error in FIle Updating/File Movement");
        //       print(e.toString());
        //       await LogCat().writeContent("'${DateTimeDetails().currentDateTime()} :Error in FIle Updating/File Movement - " + e.toString()+" \n\n");
        //     }
        //
        //   }
        //   else {
        //     print(response.reasonPhrase);
        //   }
        // }
        try {
          for (int i = 0; i < folderfilestemp.length; i++) {
            print(folderfiles[i].toString());

            print("Inside upload file encryption");

            List<USERLOGINDETAILS> acctoken =
            await USERLOGINDETAILS().select().toList();

            print("Folder files");
            // print(folderfiles[i].path.toString());
            // var file=  folderfiles[i].path.toString().replaceAll("storage/emulated/0/Darpan_Mine/UploadCSV/","");
            var file = folderfiles[i];
            print("File Name: $file");
            print("File loc: storage/emulated/0/Darpan_Mine/UploadCSV/$file");

            if (File('storage/emulated/0/Darpan_Mine/UploadCSV/$file')
                .existsSync()) {
              print("True Available");
              // Commneted Sign and upload
              // String? sign= await Newenc.signfiles(folderfiles[i].path.toString());
              String? sign = await Newenc.signfiles(
                  'storage/emulated/0/Darpan_Mine/UploadCSV/$file');
              print("Sign received");
              print(sign);
              //sign="";

              var headers = {
                'Authorization': 'Bearer ${acctoken[0].AccessToken}',
              };

              // var request = http.MultipartRequest('POST',
              //     Uri.parse('https://gateway.cept.gov.in/signewtest/upload'));
              var request = http.MultipartRequest('POST',
                  Uri.parse('https://gateway.cept.gov.in/signewlive/upload'));


              request.fields.addAll({'$file': '$sign'});
              //commented by rakesh on 07102022...
              //request.files.add(await http.MultipartFile.fromPath('file', folderfiles[i].path.toString()));
              request.files.add(await http.MultipartFile.fromPath(
                  'file', 'storage/emulated/0/Darpan_Mine/UploadCSV/$file'));
              request.headers.addAll(headers);

              http.StreamedResponse response = await request.send();

              if (response.statusCode == 200) {
                // print(await response.stream.bytesToString());
                String res = await response.stream.bytesToString();

                await LogCat().writeContent(
                    "${DateTimeDetails()
                        .currentDateTime()}: File: $file: $res ");
                await File("storage/emulated/0/Darpan_Mine/UploadCSV/$file")
                    .rename("storage/emulated/0/Darpan_Mine/Screenshots/$file");
                await LogCat().writeContent(
                    "${DateTimeDetails()
                        .currentDateTime()}: File movement to archive: $file: $res ");
              } else {
                String res = await response.stream.bytesToString();
                await LogCat().writeContent(
                    "${DateTimeDetails()
                        .currentDateTime()}: Error in File acknowledgement: $file: $res ");
              }
              //COmmented Upload
            } else {
              print("Not Available");
            }
          }
        }
        catch (error1) {
          print("Error Response in Upload call");
          print(error1);
          await LogCat().writeContent(
              "Upload Exception upload call: $error1");
        }

      } else {
        //Need to show the error in Developer logs
        // UtilFs.showToast("Office Master Not Available !", context);
      }
    }
    catch (error1) {
      print("Error Response in Upload function");
      print(error1);
      await LogCat().writeContent(
          "Error Response in Upload function: $error1");
    }

  }
}

DataSync dataSync = DataSync();
