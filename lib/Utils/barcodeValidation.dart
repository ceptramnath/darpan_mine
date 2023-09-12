import 'package:darpan_mine/CBS/db/cbsdb.dart';
import 'package:darpan_mine/DatabaseModel/INSTransactions.dart';
import 'package:darpan_mine/DatabaseModel/ReportsModel.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'dart:io' as io;

import 'package:intl/intl.dart';

import '../LogCat.dart';

// Used for validating the bag and article barcodes

class artnoValidate {

  String validate(String text)  {
    const allowedalpha = r"""ABCDEFGHIJKLMNOPQRSTUVWXYZ""";
    var value;
    if(text.length >= 11)
    value = int.tryParse(text.substring(2,11));
    if( text.length >=2 && (!allowedalpha.contains(text.substring(0,1).toUpperCase()) || !allowedalpha.contains(text.substring(1,2).toUpperCase())) )
    return "Only alphabets allowed in first two characters";
    else
      if(text.length >= 11 && value == null ) {

        return "Invalid barcode!";
      }
      else
      if( text.length >=13 && (!allowedalpha.contains(text.substring(11,12).toUpperCase()) || !allowedalpha.contains(text.substring(12).toUpperCase())) )
        return "Only alphabets allowed in last two characters";
      else
    if(text.length !=13)
      return "Length must be 13";
   else
    return "Valid";
  }
}

artnoValidate artval = artnoValidate();

class bagnoValidate {

  String validate(String text)  {
    const allowedalpha = r"""ABCDEFGHIJKLMNOPQRSTUVWXYZ""";
    var value;
    if(text.length >= 13)
      value = int.tryParse(text.substring(3));
    if( text.length >=3 && (!allowedalpha.contains(text.substring(0,1).toUpperCase()) || !allowedalpha.contains(text.substring(1,2).toUpperCase())|| !allowedalpha.contains(text.substring(2,3).toUpperCase())) )
      return "Only alphabets allowed in first 3 characters";
    else
    if(text.length >= 13 && value == null ) {
      return "Invalid barcode!";
    }
    else
    if(text.length !=13)
      return "Length must be 13";
    else
      return "Valid";
  }
}

bagnoValidate bgval = bagnoValidate();

class emonoValidate {

  String validate(String text)  {
    var value;
    if(text.length >= 18)
      value = int.tryParse(text);

    if(text.length !=18)
      return "Length must be 18";
    else
    if(text.length == 18 && value == null ) {
      return "Invalid barcode!";
    }
    else
      return "Valid";
  }
}

emonoValidate emoval = emonoValidate();
