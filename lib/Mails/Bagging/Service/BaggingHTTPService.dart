import 'package:darpan_mine/Constants/URL.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaggingHTTPService {
  bagReceive(BuildContext context, String date, String time, String bagNumber,
      String numberOfArticles) async {
    var response = await http.post(Uri.parse(URL.bagReceiveURL), body: {
      "fromoffice": "PO9999999999",
      "tooffice": "PO2183020201",
      "tdate": "$date $time",
      "time": time,
      "userid": "USER1",
      "bagnumber": bagNumber,
      "bagstatus": "BAG RECEIVE",
      "botdate": "$date $time",
      "is_rcvd": "Y",
      "is_communicated": "",
      "boslipno": "",
      "no_of_articles": numberOfArticles,
      "file_name": "",
      "business_date": ""
    });
    if (response.statusCode == 201) {
      Toast.showToast(response.body, context);
    } else {
      Toast.showToast(response.statusCode.toString(), context);
    }
  }
}
