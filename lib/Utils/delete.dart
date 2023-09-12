import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'dart:io' as io;

import 'package:intl/intl.dart';
import '../LogCat.dart';

//old rows in the database can be deleted after 90 days
// old files created can be deleted after 40 days.

class DBdelete {
  int db_days= -90;
  int file_days= -40;
  Future<void> delete() async {
    var testing = DateTime.now().add(Duration(days: db_days));
    print("Date before 90 days");
    print(testing);
    var file_cutoffDate = DateTime.now().add(Duration(days: file_days));

    var cbstran = await TBCBS_TRAN_DETAILS().select().toMapList();

    int cbs=0;
    for (int i = 0; i < cbstran.length; i++) {
      String temp3 = cbstran[i]['TRAN_DATE']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (DateTime.parse(temp3).isBefore(testing)) {
        await TBCBS_TRAN_DETAILS()
            .select()
            .TRAN_DATE
            .startsWith(cbstran[i]['TRAN_DATE'])
            .delete();
        cbs= cbs+1;
      }
    }
    print("CBS TRAN DELETION: $cbs rows");

    var instran = await DAY_TRANSACTION_REPORT().select().toMapList();
    //print(instran.length);
    int ins=0;
    for (int i = 0; i < instran.length; i++) {
      //print(instran[i]['TRAN_DATE']);
      String temp3 = instran[i]['TRAN_DATE']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (DateTime.parse(temp3).isBefore(testing)) {
        await DAY_TRANSACTION_REPORT()
            .select()
            .TRAN_DATE
            .startsWith(instran[i]['TRAN_DATE'])
            .delete();
        ins= ins+1;
      }
    }
    print("INS TRAN DELETION: $ins rows");

    // Get the ZIp files generated and synched to server.
    var files_sc = io.Directory("storage/emulated/0/Darpan_Mine/Screenshots")
        .listSync();
    print(files_sc.length);
    for (int i = 0; i < files_sc.length; i++) {
      // print(files[i].path);
      // print(files[i]
      //     .path
      //     .toString()
      //     .split("storage/emulated/0/Darpan_Mine/Screenshots/")[1]);
      // print(files[i].statSync().modified);

      // Updating the file sync details before proceeding further
      var res =await FILE_SYNC_DETAILS()
          .select()
          .ZIP_FILE_NAME
          .equals(files_sc[i]
          .path
          .toString()
          .split("storage/emulated/0/Darpan_Mine/Screenshots/")[1])
          .update({
        'STATUS': "1",
        'LAST_UPDATED_DT': files_sc[i].statSync().modified.toString()
      });
      print("Result of upadtion is :$res");
    }

    //deleting old files from Screenshots
    print("File deletion cutoff date is:$file_cutoffDate");
    await LogCat().writeContent(
        "File deletion cutoff date is:$file_cutoffDate");
    print("files before cutoff from screenshots: ${files_sc.length} " );
    await LogCat().writeContent(
        "files before cutoff from screenshots: ${files_sc.length} ");
    int count_sc_del=0;
    for (int i = 0; i < files_sc.length; i++) {
      if (DateTime.parse(files_sc[i].statSync().modified.toString()).isBefore(file_cutoffDate)) {
        print("${files_sc[i].path} ${files_sc[i].statSync().modified.toString()}");
        files_sc[i].delete();
        await LogCat().writeContent(files_sc[i].path);
        count_sc_del= count_sc_del+1;
      }
    }
    print("files deleted from screenshots: $count_sc_del " );
    await LogCat().writeContent(
        "files deleted from screenshots: $count_sc_del " );
// from the exports folder

    // Get the ZIp files generated and synched to server.
    var files_exp = io.Directory("storage/emulated/0/Darpan_Mine/Exports")
        .listSync();
        //deleting old files from exports
    print(" files before cutoff from exports: ${files_exp.length} ");
    await LogCat().writeContent(
        " files before cutoff from exports: ${files_exp.length} " );
    int count_exp_del=0;
    for (int i = 0; i < files_exp.length; i++) {
      if (DateTime.parse(files_exp[i].statSync().modified.toString()).isBefore(file_cutoffDate)) {
        print("${files_exp[i].path} ${files_exp[i].statSync().modified.toString()}");
        files_exp[i].delete();
        await LogCat().writeContent(files_exp[i].path);
        count_exp_del= count_exp_del+1;
      }
    }
    print("files deleted from Exports: $count_exp_del " );
    await LogCat().writeContent(
        " files deleted from Exports: $count_exp_del " );
    // from the Logs folder

    // Get the ZIp files generated and synched to server.
    var files_log = io.Directory("storage/emulated/0/Darpan_Mine/Logs")
        .listSync();

    //deleting old files from logs
    print(" files before cutoff from Logs: ${files_log.length} ");
    await LogCat().writeContent(
        " files before cutoff from Logs: ${files_log.length} " );
    int count_log_del=0;
    for (int i = 0; i < files_log.length; i++) {
      if (DateTime.parse(files_log[i].statSync().modified.toString()).isBefore(file_cutoffDate)) {
        print("${files_log[i].path} ${files_log[i].statSync().modified.toString()}");
        files_log[i].delete();
        await LogCat().writeContent(files_log[i].path);
        count_log_del= count_log_del+1;
      }
    }
    print("files deleted from logs: $count_log_del " );
    await LogCat().writeContent(
        " files deleted from logs: $count_log_del " );
    // old file deletion ended

 // get the list of files synched
    var file_list= await FILE_SYNC_DETAILS()
        .select()
        .STATUS
        .equals("1")
        .toMapList();
    print("List of files synched:$file_list ");
    //Checking the matching files from delivery table
    var match_del = [];
    for(int k=0; k<file_list.length;k++)
      {
        var del_data = await Delivery().select()
            .FILE_NAME
            .equals(file_list[k]['FILE_NAME']).toMapList();
        if(del_data.length>0)
          match_del.add(file_list[k]['FILE_NAME']);
      }
    print("List of Matching names for deletion from Delivery details : $match_del");

//delete data from delivery Table
    int del=0;
    for (int i = 0; i < match_del.length; i++) {
      var del_del = await  await Delivery()
          .select().FILE_NAME
          .equals(match_del[i]).toMapList();
       print(del_del[i]['DEL_DATE']);
      print(del_del[i]['FILE_NAME']);
      String art = del_del[i]['ART_NUMBER'];
      String temp3 = del_del[i]['DEL_DATE'];
      if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
        print(art);
        await Delivery()
            .select()
            .FILE_NAME
            .equals(match_del[i])
            .delete();
       await Addres()
            .select()
            .ART_NUMBER
            .equals(art)
            .delete();
        del=del+1;
      }
    }
    print("Delivery TRAN DELETION: $del rows");

    //Checking the matching files from Letter Booking table
    var match_lbkg = [];
    for(int k=0; k<file_list.length;k++)
    {
      var lbkg_data = await LetterBooking().select()
          .FileName
          .equals(file_list[k]['FILE_NAME']).toMapList();
      if(lbkg_data.length>0)
        match_lbkg.add(file_list[k]['FILE_NAME']);
    }
    print("List of Matching names for deletion from Letter Booking details : $match_lbkg");

//delete data from Book letter Table
    int lbkg=0;
    for (int i = 0; i < match_lbkg.length; i++) {
      var lbkg_del =  await LetterBooking()
          .select().FileName
          .equals(match_lbkg[i]).toMapList();
      print(lbkg_del[i]['BookingDate']);
      print(lbkg_del[i]['FileName']);
      String art = lbkg_del[i]['ART_NUMBER'];
      String temp3 = lbkg_del[i]['BookingDate']
            .substring(0, 10)
            .split("-")
            .reversed
            .join("-");
      if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
        print(art);
        await LetterBooking()
            .select()
            .FileName
            .equals(match_lbkg[i])
            .delete();
        lbkg=lbkg+1;
      }
    }
    print("Letter booking DELETION: $lbkg rows");

    // var bookletter = await LetterBooking().select().toMapList();
    // int let=0;
    // for (int i = 0; i < bookletter.length; i++) {
    //   String temp3 = bookletter[i]['BookingDate']
    //       .substring(0, 10)
    //       .split("-")
    //       .reversed
    //       .join("-");
    //   if (DateTime.parse(temp3).isBefore(testing)) {
    //     await LetterBooking()
    //         .select()
    //         .BookingDate
    //         .startsWith(bookletter[i]['BookingDate'])
    //         .delete();
    //     let= let+1;
    //   }
    // }
    // print("letter TRAN DELETION: $let rows");
//Checking the matching files from Speed Booking table
    var match_sbkg = [];
    for(int k=0; k<file_list.length;k++)
    {
      var sbkg_data = await SpeedBooking().select()
          .FileName
          .equals(file_list[k]['FILE_NAME']).toMapList();
      if(sbkg_data.length>0)
        match_sbkg.add(file_list[k]['FILE_NAME']);
    }
    print("List of Matching names for deletion from Speed Booking details : $match_sbkg");

//delete data from speed boooking Table
    int sbkg=0;
    for (int i = 0; i < match_sbkg.length; i++) {
      var sbkg_del =  await SpeedBooking()
          .select().FileName
          .equals(match_sbkg[i]).toMapList();
      print(sbkg_del[i]['BookingDate']);
      print(sbkg_del[i]['FileName']);
      String art = sbkg_del[i]['ART_NUMBER'];
      String temp3 = sbkg_del[i]['BookingDate']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
        print(art);
        await SpeedBooking()
            .select()
            .FileName
            .equals(match_sbkg[i])
            .delete();
        sbkg=sbkg+1;
      }
    }
    print("Speed booking DELETION: $sbkg rows");

    // var bookspeed = await SpeedBooking().select().toMapList();
    // int sp=0;
    // for (int i = 0; i < bookspeed.length; i++) {
    //   String temp3 = bookspeed[i]['BookingDate']
    //       .substring(0, 10)
    //       .split("-")
    //       .reversed
    //       .join("-");
    //   if (DateTime.parse(temp3).isBefore(testing)) {
    //     await SpeedBooking()
    //         .select()
    //         .BookingDate
    //         .startsWith(bookspeed[i]['BookingDate'])
    //         .delete();
    //     sp=sp+1;
    //   }
    // }
    // print("Speed TRAN DELETION: $sp rows");
//Checking the matching files from Parcel Booking table
    var match_pbkg = [];
    for(int k=0; k<file_list.length;k++)
    {
      var pbkg_data = await ParcelBooking().select()
          .FileName
          .equals(file_list[k]['FILE_NAME']).toMapList();
      if(pbkg_data.length>0)
        match_pbkg.add(file_list[k]['FILE_NAME']);
    }
    print("List of Matching names for deletion from parcel Booking details : $match_pbkg");

//delete data from parcel boooking Table
    int pbkg=0;
    for (int i = 0; i < match_sbkg.length; i++) {
      var pbkg_del =  await ParcelBooking()
          .select().FileName
          .equals(match_pbkg[i]).toMapList();
      print(pbkg_del[i]['BookingDate']);
      print(pbkg_del[i]['FileName']);
      String art = pbkg_del[i]['ART_NUMBER'];
      String temp3 = pbkg_del[i]['BookingDate']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
        print(art);
        await ParcelBooking()
            .select()
            .FileName
            .equals(match_pbkg[i])
            .delete();
        pbkg=pbkg+1;
      }
    }
    print("Parcel booking DELETION: $pbkg rows");

    // var bookparcel = await ParcelBooking().select().toMapList();
    // int pl =0 ;
    // for (int i = 0; i < bookparcel.length; i++) {
    //   String temp3 = bookparcel[i]['BookingDate']
    //       .substring(0, 10)
    //       .split("-")
    //       .reversed
    //       .join("-");
    //   if (DateTime.parse(temp3).isBefore(testing)) {
    //     await ParcelBooking()
    //         .select()
    //         .BookingDate
    //         .startsWith(bookparcel[i]['BookingDate'])
    //         .delete();
    //     pl=pl+1;
    //   }
    // }
    // print("parcel TRAN DELETION: $pl rows");
//Checking the matching files from EMO Booking table
    var match_ebkg = [];
    for(int k=0; k<file_list.length;k++)
    {
      var ebkg_data = await EmoBooking().select()
          .FileName
          .equals(file_list[k]['FILE_NAME']).toMapList();
      if(ebkg_data.length>0)
        match_ebkg.add(file_list[k]['FILE_NAME']);
    }
    print("List of Matching names for deletion from EMO Booking details : $match_ebkg");

//delete data from parcel boooking Table
    int ebkg=0;
    for (int i = 0; i < match_ebkg.length; i++) {
      var ebkg_del =  await EmoBooking()
          .select().FileName
          .equals(match_pbkg[i]).toMapList();
      print(ebkg_del[i]['BookingDate']);
      print(ebkg_del[i]['FileName']);
      String art = ebkg_del[i]['ART_NUMBER'];
      String temp3 = ebkg_del[i]['BookingDate']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
        print(art);
        await ParcelBooking()
            .select()
            .FileName
            .equals(match_ebkg[i])
            .delete();
        ebkg=ebkg+1;
      }
    }
    print("EMO booking DELETION: $ebkg rows");

    // var bookEMO = await EmoBooking().select().toMapList();
    // int emo=0;
    // for (int i = 0; i < bookEMO.length; i++) {
    //   String temp3 = bookEMO[i]['BookingDate']
    //       .substring(0, 10)
    //       .split("-")
    //       .reversed
    //       .join("-");
    //   if (DateTime.parse(temp3).isBefore(testing)) {
    //     await EmoBooking()
    //         .select()
    //         .BookingDate
    //         .startsWith(bookEMO[i]['BookingDate'])
    //         .delete();
    //     emo=emo+1;
    //   }
    // }
    // print("EMO TRAN DELETION: $emo rows");
// Cash/tran table data will move to backup daily. SO we need to delete the data from the backup tables.
    // Deleting old data from the FILE_SYNC_DETAILS Table is not written

    var cashtable = await CashTableBackup().select().toMapList();
    int cash=0;
    for (int i = 0; i < cashtable.length; i++) {
     // print(cashtable[i]['Cash_Date']);
      String temp3 = cashtable[i]['Cash_Date']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      //print(temp3);
      if (DateTime.parse(temp3).isBefore(testing)) {
        await CashTableBackup()
            .select()
            .Cash_Date
            .startsWith(cashtable[i]['Cash_Date'])
            .delete();
        cash= cash+1;
      }
    }
    print("Cash TRAN DELETION: $cash rows");

    var transtable = await TransactionTableBackup().select().toMapList();
    int tran=0;
    for (int i = 0; i < transtable.length; i++) {
      String temp3 = transtable[i]['tranDate']
          .substring(0, 10)
          .split("-")
          .reversed
          .join("-");
      if (DateTime.parse(temp3).isBefore(testing)) {
        await TransactionTableBackup()
            .select()
            .tranDate
            .startsWith(transtable[i]['tranDate'])
            .delete();
        tran=tran+1;
      }
    }
    print("trans TRAN DELETION: $tran rows");

    // var deltable = await Delivery().select().toMapList();
    // int del=0;
    // for (int i = 0; i < deltable.length; i++) {
    //   print(deltable[i]['DEL_DATE']);
    //   String art = deltable[i]['ART_NUMBER'];
    //   String temp3 = deltable[i]['DEL_DATE'];
    //   // String temp3 = deltable[i]['DEL_DATE']
    //   //     .substring(0, 10)
    //   //     .split("-")
    //   //     .reversed
    //   //     .join("-");
    //   print(temp3);
    //   if (temp3 != null && DateTime.parse(temp3).isBefore(testing)) {
    //     await Delivery()
    //         .select()
    //         .ART_NUMBER
    //         .equals(deltable[i]['ART_NUMBER'])
    //         .delete();
    //     await Addres()
    //         .select()
    //         .ART_NUMBER
    //         .equals(deltable[i]['ART_NUMBER'])
    //         .delete();
    //     del=del+1;
    //   }
    // }
    // print("Delivery TRAN DELETION: $del rows");

    /*

     */

    var deletebillercancel = await CancelBiller().select().toMapList();
/*

 */
    for (int i = 0; i < deletebillercancel.length; i++) {
      String dt = deletebillercancel[i]['BookingDate'];
      var temp1 = dt.substring(0, 2) +
          "-" +
          dt.substring(2, 4) +
          "-" +
          dt.substring(4, 8);
      String temp3 = temp1.substring(0, 10).split("-").reversed.join("-");
      if (DateTime.parse(temp3).isBefore(testing)) {
        await CancelBiller()
            .select()
            .BookingDate
            .startsWith(deletebillercancel[i]['BookingDate'])
            .delete();
      }
    }

    var deletebookingcancel = await CancelBooking().select().toMapList();

    for (int i = 0; i < deletebookingcancel.length; i++) {
      String dt = deletebookingcancel[i]['BookingDate'];
      var temp1 = dt.substring(0, 2) +
          "-" +
          dt.substring(2, 4) +
          "-" +
          dt.substring(4, 8);
      String temp3 = temp1.substring(0, 10).split("-").reversed.join("-");
      if (DateTime.parse(temp3).isBefore(testing)) {
        await CancelBooking()
            .select()
            .BookingDate
            .startsWith(deletebookingcancel[i]['BookingDate'])
            .delete();
      }
    }
  }
}

DBdelete dBdelete = DBdelete();
