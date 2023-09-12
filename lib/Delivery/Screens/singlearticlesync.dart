import 'dart:convert';

import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:http/http.dart' as http;

import 'db/ArticleModel.dart';

class SingleArticleSync {
  String? deviceIP;
  String token =
      "eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3NlcmlhbG51bWJlciI6Ijc4ODk1MzU3NTBiOWVmMTIiLCJleHAiOjE2NzQ0NzM4MDUsImlzcyI6ImFwcHMuaW5kaWFwb3N0Lmdvdi5pbiIsImF1ZCI6ImFwcHMucG9zdG1hbi5pbmRpYXBvc3QuZ292LmluIn0.IIv54RiioNXSx-K4VirKQxsljoP2aghET4P0XLlxhV0";

  Future<bool> sadsync(String articlenumber) async {
    print("Reached delivery part");
    print(articlenumber.length);
    for (int i = 0; i < 1; i++) {
      List<ScannedArticle> adelivered = await ScannedArticle()
          .select()
          .articleNumber
          .equals(articlenumber)
          .and
          .startBlock
          .isCommunicated
          .equals(0)
          .and
          .articleStatus
          .equals("Delivered")
          .endBlock
          .toList();

      try {
        deviceIP = await Ipify.ipv4();
      } catch (e) {
        if (deviceIP == null) {
          deviceIP = "0.0.0.0";
        }
      }
      print(adelivered[i].articleNumber);

      String? articleNumber = adelivered[i].articleNumber;
      String? articleType = adelivered[i].articleType;
      var dt = adelivered[i].remarkDate;
      String? inDate = adelivered[i].invoiceDate;
      String? lat = adelivered[i].latitude;
      String? long = adelivered[i].longitude;
      String? dname = adelivered[i].deliveredTo;
      String? dadd = adelivered[i].addresseeType;
      var artstatus = 'D';
      if (articleType == "Registered Letter") {
        articleType = "REGISTERED";
      }
      if (articleType == "EMO") {
        articleType = "EMO";
        artstatus = 'F';
      }
      if (articleType == "Speed Post") {
        articleType = "SPEED";
      }
      if (articleType == "Parcel") {
        articleType = "PARCEL";
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://apps.indiapost.gov.in/testing/api/postman/updatedeliverytest'));
      // var request = http.Request('POST', Uri.parse('http://apps.indiapost.gov.in/pmaapi/api/postman/updatedelivery'));
      request.body =
          '''{"DeliveredDate":"$dt",\r\n"InvoicedDate":"$inDate",\r\n"ArticleNumber":"$articleNumber",\r\n"PinCode":"570010",\r\n"OfficeCode":"${adelivered[i].facilityID}",\r\n"ArticleType":"$articleType",\r\n"DeviceId":"7889535750b9ef12",\r\n"BeatNo":"${adelivered[i].beat}",\r\n"BatchNo":"${adelivered[i].batch}",\r\n"IpAddress":"$deviceIP",\r\n"PostmanName":"${adelivered[i].postman}",\r\n"Ratings":"1",\r\n"DeliveredTo":"$dname",\r\n"AddresseeType":"$dadd",\r\n"FacilityId":"${adelivered[i].facilityID}",\r\n"Latitude":"$lat",\r\n"Longitude":"$long",\r\n"articlestatus":"$artstatus"}''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());

        String reply =
            jsonDecode(await response.stream.bytesToString())["status"];
        print("reply is $reply");
        if (reply == "1") {
          print("$articleNumber with $articleType synchronized");
          await ScannedArticle()
              .select()
              .articleNumber
              .equals(articleNumber)
              .update({
            "isCommunicated": "1",
            "sync_time": DateTimeDetails().currentDateTime()
          });
          // await LogCat().writeContent("${DateTimeDetails().currentDateTime()} : $articleType article: $articleNumber synchronized\n\n");
        } else {
          // await  LogCat().writeContent("${DateTimeDetails().currentDateTime()} : $reply\n\n");
        }
      } else {
        print("error sync in delivery");
        print(response.statusCode);
        print(response.reasonPhrase);
        String error1 = await response.stream.bytesToString();
        // await LogCat().writeContent("${DateTimeDetails().currentDateTime()} : $error1\n\n");
      }
    }
    return true;
  }

  Future<bool> saudsync(String articlenumber) async {
    print("Reached undelivery part");
    print(articlenumber.length);

    for (int i = 0; i < 1; i++) {
      print("Article number in loop: ${articlenumber[i]}");
      List<ScannedArticle> aremarks = await ScannedArticle()
          .select()
          .articleNumber
          .equals(articlenumber)
          .and
          .startBlock
          .isCommunicated
          .equals(0)
          .and
          .articleStatus
          .not
          .equals("Delivered")
          .endBlock
          .toList();

      List<Logintable> pm =
          await Logintable().select().is_Active.equals(1).toList();

      try {
        deviceIP = await Ipify.ipv4();
      } catch (e) {
        if (deviceIP == null) {
          deviceIP = "0.0.0.0";
        }
      }
      print('Step :' + i.toString());
      String? articleNumber = aremarks[0].articleNumber;
      String? articleType = aremarks[0].articleType;
      String? remarks = aremarks[0].reasonCode;
      var dt = aremarks[0].remarkDate;
      String? inDate = aremarks[0].invoiceDate;
      String? lat = aremarks[0].latitude;
      String? long = aremarks[0].longitude;
      var artstatus = 'N';
      if (articleType == "Registered Letter") {
        articleType = "REGISTERED";
      }
      if (articleType == "EMO") {
        articleType = "EMO";
        artstatus = 'G';
      }
      if (articleType == "Speed Post") {
        articleType = "SPEED";
      }
      if (articleType == "Parcel") {
        articleType = "PARCEL";
      }
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'http://apps.indiapost.gov.in/testing/api/postman/updateundeliverytest'));
      // var request = http.Request('POST', Uri.parse('http://apps.indiapost.gov.in/pmaapi/api/postman/updateundelivery'));
      print(request);
      request.body =
          '''{"InvoicedDate":"$inDate",\r\n"UndeliveryRemarkDate":"$dt",\r\n"ArticleNumber":"$articleNumber",
            \r\n"PinCode":"570010",\r\n"OfficeCode":"${aremarks[i].facilityID}",\r\n"ArticleType":"$articleType",
            \r\n"DeviceId":"7889535750b9ef12",\r\n"BeatNo":"${aremarks[i].beat}",\r\n"BatchNo":"${aremarks[i].batch}",
            \r\n"IpAddress":"$deviceIP",\r\n"PostmanName":"${aremarks[i].postman}",\r\n"Ratings":"1",\r\n"RemarkCode":"0",\r\n"ActionCode":"0",\r\n"Reason_For_Ndeli":"$remarks",
            \r\n"FacilityId":"${aremarks[i].facilityID}",\r\n"Latitude":"$lat",\r\n"Longitude":"$long",\r\n"articlestatus":"$artstatus"}''';
      request.headers.addAll(headers);
      print("Request body " + request.body.toString());
      print("Request header " + request.headers.toString());
      http.StreamedResponse response = await request.send();
      print("Response " + response.toString());
      print('API Response: ' + response.statusCode.toString());
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        String reply =
            jsonDecode(await response.stream.bytesToString())["status"];
        print("reply is $reply");
        if (reply == "1") {
          print("$articleNumber with $articleType and $remarks synchronized");
          await ScannedArticle()
              .select()
              .articleNumber
              .equals(articleNumber)
              .update({
            "isCommunicated": "1",
            "sync_time": DateTimeDetails().currentDateTime()
          });
          // await LogCat().writeContent("${DateTimeDetails().currentDateTime()} :$articleType article: $articleNumber synchronized\n\n");
        } else {
          // await LogCat().writeContent("${DateTimeDetails().currentDateTime()} : $reply\n\n");
        }
      } else {
        print(response.reasonPhrase);
        String error1 = await response.stream.bytesToString();
        // await LogCat().writeContent("${DateTimeDetails().currentDateTime()} : $error1\n\n");
      }
    }

    return true;
  }
}

SingleArticleSync sas = new SingleArticleSync();
