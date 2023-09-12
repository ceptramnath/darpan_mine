import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'dart:async';
import 'dart:convert';

class aadharOTP{
    String txnid="";
  getOTP(String uid) async{
    var request = http.Request('POST', Uri.parse('http://dopauth.in:8084/EcafRestService/GenerateEkycData_OTP/$uid'));


                            http.StreamedResponse response = await request.send();

                            if (response.statusCode == 200) {
                              // print(await response.stream.bytesToString());
                              String res = await response.stream.bytesToString();
                              print(res);

                              Xml2Json xml2json = new Xml2Json();
                              xml2json.parse(res);

                              String a = xml2json.toBadgerfish();
                              Map t = json.decode(a);
                              print(t);

                              String AUAResponse =
                              t['BsnlAuaResponse']['UidaiResponse']['OtpRes']['@ret'];
                              print("AUA Response is: $AUAResponse");
                              // if(AUAResponse=="y"){
                                txnid =
                                t['BsnlAuaResponse']['UidaiResponse']['OtpRes']['@txn'];
                                List resp=[];
                                resp.add(AUAResponse);
                                resp.add(txnid);
                                if(AUAResponse=="n"){
                                  resp.add(t['BsnlAuaResponse']['UidaiResponse']['OtpRes']['@err']);
                                }
                                return resp;
                              // }
                            }
                            else {
                              print(response.reasonPhrase);
                            }

  }
  verifyOTP(String otp,String id,String aadhar) async{
    var request = http.Request('POST', Uri.parse('http://dopauth.in:8084/EcafRestService/FetchEkycData_OTP/DOP/$aadhar/Auth/$otp/$id'));

                                http.StreamedResponse response = await request.send();

                                if (response.statusCode == 200) {
                                  String res = await response.stream.bytesToString();
                                  print(res);

                                  Xml2Json xml2json = new Xml2Json();
                                  xml2json.parse(res);

                                  String a = xml2json.toBadgerfish();
                                  Map t = json.decode(a);
                                  print(t);
                                  String AUAResponse =
                                  t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@ret'];
                                  // if(AUAResponse=="y"){
                                  //  return "y";
                                  // }
                                  txnid =
                                  t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@txn'];
                                  List resp=[];
                                  resp.add(AUAResponse);
                                  resp.add(txnid);
                                  if(AUAResponse=="n"){
                                    resp.add(t['BsnlAuaResponse']['UidaiResponse']['AuthRes']['@err']);
                                  }
                                  return resp;

                                }
                                else {
                                  print(response.reasonPhrase);
                                }
  }
}