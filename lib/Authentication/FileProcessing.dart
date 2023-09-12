import 'dart:io' as io;
import 'dart:convert';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';

class FileProcessing{


  FileProc() async {
    final dir = Directory(
        'storage/emulated/0/Darpan_Mine/DownloadCSV/BO20105103004');
    print('File Process Started');
    print(dir.toString());
    print("Before file processing");
    final List<FileSystemEntity> entities = await dir.list().toList();
    print(entities.length);
    print(entities);
    List subRes = [];

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
      }

      try {
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
          // await addFileToDB(entities[i].toString(), dir.toString(),
          //     'Product Master', DateTimeDetails().currentDateTime());
        }
      }
      catch(e)
    {
      print("Product Master File Error");
      print(e);
      if(e.toString().contains("FormatException: Unexpected extension byte")){
        print("Error Captured..!"+ entities[i].toString().replaceAll("File: '", ""));
        String s1= entities[i].toString().replaceAll("File: '", "");
        String s2 = s1.replaceAll("'", "");
        await File(s2).delete();

      }
    }

    }
  }

  }
FileProcessing fileProcessing = FileProcessing();