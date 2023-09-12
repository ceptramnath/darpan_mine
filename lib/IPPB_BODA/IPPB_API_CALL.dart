import 'dart:convert';

import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';
import 'package:darpan_mine/DatabaseModel/transtable.dart';

import '../LogCat.dart';

class ippb_BODA{
 // Future<String>
  void getData(String frmDate,String ToDate) async {
    try {
      final ofcMaster = await OFCMASTERDATA().select().toList();
      var officeId = ofcMaster[0].BOFacilityID.toString();
      String Req_id = "Req_$officeId${DateTimeDetails().cbsdatetime()}";
      officeId = "BO29204114007"; // hardcoded need to change
      String MsgDateTime = DateTimeDetails().tranUpdateTime();
      //String MsgDateTime="2023-07-05T17:12:48.159";
      print(Req_id);
      print(MsgDateTime);

      String fromDate = "08-Feb-23 00:00:00"; //frmDate
      String toDate = "08-Feb-23 23:59:00"; //ToDate
      String err = "",
          status = "";
      String res = "",
          tag_data = "";
      //String res_FacId="",tranDate="",frmDtTime="",toDtTime="",TotalDep="",TotalWdl="",Status="",Remarks="";
      var headers = {
        'Content-Type': 'application/xml'
      };
      var request = http.Request(
          'POST', Uri.parse('https://rictapi.cept.gov.in/ippb'));
      //request.body = '''<soapenv:Envelope xmlns:soapenv=\'http://schemas.xmlsoap.org/soap/envelope/\'\r\nxmlns:web=\'http://webservice.fiusb.ci.infosys.com/\'>\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<web:executeService>\r\n<arg0><![CDATA[<?xml version=\'1.0\' encoding=\'UTF-8\'?>\r\n<FIXML xsi:schemaLocation=\'http://www.finacle.com/fixml RetCustAdd.xsd\' xmlns=\'http://www.finacle.com/fixml\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\'>\r\n <Header>\r\n <RequestHeader>\r\n <MessageKey>\t\t\t\r\n <RequestUUID>Req_1576649895553</RequestUUID>\r\n <ServiceRequestId>executeFinacleScript</ServiceRequestId>\r\n <ServiceRequestVersion>10.2</ServiceRequestVersion>\r\n <ChannelId>COR</ChannelId>\r\n <LanguageId></LanguageId>\t\t\t\t\t\r\n </MessageKey>\r\n<RequestMessageInfo>\r\n<BankId>IPPB</BankId>\r\n <TimeZone></TimeZone>\r\n<EntityId></EntityId>\r\n<EntityType></EntityType>\r\n<ArmCorrelationId></ArmCorrelationId>\r\n <MessageDateTime>2023-06-14T11:48:15.553</MessageDateTime>\r\n </RequestMessageInfo>\r\n <Security>\r\n <Token>\t   \r\n <PasswordToken>\r\n <UserId></UserId>\r\n <Password></Password>\r\n </PasswordToken>\t\t\r\n </Token>\r\n <FICertToken></FICertToken>\r\n <RealUserLoginSessionId></RealUserLoginSessionId>\r\n<RealUser></RealUser>\r\n<RealUserPwd></RealUserPwd>\r\n <SSOTransferToken></SSOTransferToken>\r\n</Security>\r\n </RequestHeader>\r\n</Header>\r\n <Body>\r\n<executeFinacleScriptRequest>\r\n <ExecuteFinacleScriptInputVO>\r\n <requestId>Boda_API_for_TranDetails.scr</requestId>\r\n </ExecuteFinacleScriptInputVO>\r\n <executeFinacleScript_CustomData>\r\n <EodFlag>S</EodFlag>\r\n <FacilityId>BO29204114007</FacilityId>\r\n <FromDate>08-Feb-23 00:00:00</FromDate>\r\n<ToDate>08-Feb-23 22:00:00</ToDate>\t\t\t\t\t\t\t\t\t\r\n</executeFinacleScript_CustomData>\r\n</executeFinacleScriptRequest>\r\n</Body>\r\n</FIXML>\r\n]]></arg0>\r\n</web:executeService>\r\n</soapenv:Body>\r\n</soapenv:Envelope>''';
      request.body =
      "<soapenv:Envelope xmlns:soapenv=\'http://schemas.xmlsoap.org/soap/envelope/\'\r\nxmlns:web=\'http://webservice.fiusb.ci.infosys.com/\'>\r\n<soapenv:Header/>\r\n<soapenv:Body>\r\n<web:executeService>\r\n<arg0><![CDATA[<?xml version=\'1.0\' encoding=\'UTF-8\'?>\r\n<FIXML xsi:schemaLocation=\'http://www.finacle.com/fixml RetCustAdd.xsd\' xmlns=\'http://www.finacle.com/fixml\' xmlns:xsi=\'http://www.w3.org/2001/XMLSchema-instance\'>\r\n <Header>\r\n <RequestHeader>\r\n <MessageKey>\t\t\t\r\n <RequestUUID>$Req_id</RequestUUID>\r\n <ServiceRequestId>executeFinacleScript</ServiceRequestId>\r\n <ServiceRequestVersion>10.2</ServiceRequestVersion>\r\n <ChannelId>COR</ChannelId>\r\n <LanguageId></LanguageId>\t\t\t\t\t\r\n </MessageKey>\r\n<RequestMessageInfo>\r\n<BankId>IPPB</BankId>\r\n <TimeZone></TimeZone>\r\n<EntityId></EntityId>\r\n<EntityType></EntityType>\r\n<ArmCorrelationId></ArmCorrelationId>\r\n <MessageDateTime>$MsgDateTime</MessageDateTime>\r\n </RequestMessageInfo>\r\n <Security>\r\n <Token>\t   \r\n <PasswordToken>\r\n <UserId></UserId>\r\n <Password></Password>\r\n </PasswordToken>\t\t\r\n </Token>\r\n <FICertToken></FICertToken>\r\n <RealUserLoginSessionId></RealUserLoginSessionId>\r\n<RealUser></RealUser>\r\n<RealUserPwd></RealUserPwd>\r\n <SSOTransferToken></SSOTransferToken>\r\n</Security>\r\n </RequestHeader>\r\n</Header>\r\n <Body>\r\n<executeFinacleScriptRequest>\r\n <ExecuteFinacleScriptInputVO>\r\n <requestId>Boda_API_for_TranDetails.scr</requestId>\r\n </ExecuteFinacleScriptInputVO>\r\n <executeFinacleScript_CustomData>\r\n <EodFlag>S</EodFlag>\r\n <FacilityId>$officeId</FacilityId>\r\n <FromDate>$fromDate</FromDate>\r\n<ToDate>$toDate</ToDate>\t\t\t\t\t\t\t\t\t\r\n</executeFinacleScript_CustomData>\r\n</executeFinacleScriptRequest>\r\n</Body>\r\n</FIXML>\r\n]]></arg0>\r\n</web:executeService>\r\n</soapenv:Body>\r\n</soapenv:Envelope>";
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();


      if (response.statusCode == 200) {
        res = await response.stream.bytesToString();
        // print(res);
        //replacing &lt; with < symbol
        final resxml = res.toString().replaceAll("&lt;", "<");
        print(resxml);
        final document = XmlDocument.parse(resxml);
        //error case Runtime error
//       final document = XmlDocument.parse('''<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:executeServiceResponse xmlns:ns1="http://webservice.fiusb.ci.infosys.com/"><return><FIXML xsi:schemaLocation="http://www.finacle.com/fixml executeFinacleScript.xsd" xmlns="http://www.finacle.com/fixml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
// <Header>
// <ResponseHeader>
// <RequestMessageKey>
// <RequestUUID>Req_1576649895553</RequestUUID>
// <ServiceRequestId>executeFinacleScript</ServiceRequestId>
// <ServiceRequestVersion>10.2</ServiceRequestVersion>
// <ChannelId>COR</ChannelId>
// </RequestMessageKey>
// <ResponseMessageInfo>
// <BankId>IPPB</BankId>
// <TimeZone></TimeZone>
// <MessageDateTime>2023-06-13T04:52:43.293</MessageDateTime>
// </ResponseMessageInfo>
// <UBUSTransaction>
// <Id>null</Id>
// <Status>FAILED</Status>
// </UBUSTransaction>
// <HostTransaction>
// <Id>0000</Id>
// <Status>FAILURE</Status>
// </HostTransaction>
// <HostParentTransaction>
// <Id>null</Id>
// <Status>null</Status>
// </HostParentTransaction>
// <CustomInfo/>
// </ResponseHeader>
// </Header>
// <Body>
// <Error>
// <FIBusinessException>
// <ErrorDetail><ErrorCode>SYS</ErrorCode><ErrorDesc>Runtime error has occurred</ErrorDesc><ErrorSource></ErrorSource><ErrorType>BE</ErrorType></ErrorDetail>
// </FIBusinessException>
// </Error></Body>
// </FIXML>
// </return></ns1:executeServiceResponse></soap:Body></soap:Envelope>''');
        //FAILED case... no data
//       final document = XmlDocument.parse('''<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ns1:executeServiceResponse xmlns:ns1="http://webservice.fiusb.ci.infosys.com/"><return><FIXML xmlns="http://www.finacle.com/fixml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.finacle.com/fixml executeFinacleScript.xsd">
// <Header>
// <ResponseHeader>
// <RequestMessageKey>
// 	<RequestUUID>0b927fa3-19b1-4d4f-a745-8c37e60ec44f</RequestUUID>
// 	<ServiceRequestId>executeFinacleScript</ServiceRequestId>
// 	<ServiceRequestVersion>10.2</ServiceRequestVersion>
// 	<ChannelId>COR</ChannelId>
// </RequestMessageKey>
// <ResponseMessageInfo>
// 	<BankId>IPPB</BankId>
// 	<TimeZone>GMT+05:30</TimeZone>
// 	<MessageDateTime>2020-04-10T11:11:40.959</MessageDateTime>
// </ResponseMessageInfo>
// <UBUSTransaction>
// 	<Id/>
// 	<Status/>
// </UBUSTransaction>
// <HostTransaction>
// 	<Id/>
// 	<Status>SUCCESS</Status>
// </HostTransaction>
// <HostParentTransaction>
// 	<Id/>
// 	<Status/>
// </HostParentTransaction>
// <CustomInfo/>
// </ResponseHeader>
// </Header>
// <Body>
//         <executeFinacleScriptResponse>
//             <ExecuteFinacleScriptOutputVO/>
//             <executeFinacleScript_CustomData>
//                 <Response>No Data found for the given inputs. Please try with different inputs.</Response>
//                 <Status>FAILED</Status>
//             </executeFinacleScript_CustomData>
//         </executeFinacleScriptResponse>
// </Body>
//
// </FIXML>
// </return></ns1:executeServiceResponse></soap:Body></soap:Envelope>''');
        final Body_Tag = document.findAllElements('Body');
        final err_tag = Body_Tag.first.findAllElements('ErrorDesc');
        print(Body_Tag);
        print(err_tag);
        final body_Status_tag = Body_Tag.first.findAllElements('Status');
        print(body_Status_tag);
        // If error
        if (err_tag.length > 0) {
          err = err_tag
              .map((element) => element.innerText)
              .first;
          print(err);
          final apiDetails = IppbApi()
            ..ReqDATE = DateTimeDetails().currentDate()
            ..ReqTime = DateTimeDetails().oT()
            ..FacId = officeId
            ..Status = "FAILED"
            ..Remarks = err;
          await apiDetails.save();
        }
        else if (body_Status_tag.length > 0) {
          status = body_Status_tag
              .map((element) => element.innerText)
              .first;
          print(status);
          final res_tag = Body_Tag.first.findAllElements('Response');
          tag_data = res_tag
              .map((element) => element.innerText)
              .first;
          if (status == "FAILED") {
            final apiDetails = IppbApi()
              ..ReqDATE = DateTimeDetails().currentDate()
              ..ReqTime = DateTimeDetails().oT()
              ..FacId = officeId
              ..Status = "FAILED"
              ..Remarks = tag_data;
            await apiDetails.save();
          }
          else if (status == "SUCCESS") {
            //var DateTime_formatter = new DateFormat('dd-MM-yyyy HH:mm:ss');
            // var Date_formatter = new DateFormat('dd-MM-yyyy');
            var data = tag_data.split("~");
            print(data);
            print(DateFormat('dd-MMM-yyyy').parseLoose(data[1]).toString());
            print(DateFormat('dd-MMM-yyyy').parseLoose(data[1]).toString());
            print(DateFormat('dd-MMM-yyyy').parseLoose(data[1]).toString());

            final ippbapi_check = await IppbApi()
                .select()
                .TranDate
                .equals(DateFormat('dd-MMM-yyyy').parseLoose(data[1]))
                .and
                .FromDateTime
                .equals(DateFormat('dd-MMM-yyyy HH:mm:ss')
                .parseLoose(data[2])
                .toString())
                .and
                .ToDateTime
                .equals(DateFormat('dd-MMM-yyyy HH:mm:ss')
                .parseLoose(data[3])
                .toString())
                .toList();
            print("ippbapi_check :${ippbapi_check.length}");
            if (ippbapi_check.isEmpty) {
              final apiDetails = IppbApi()
                ..ReqDATE = DateTimeDetails().currentDate()
                ..ReqTime = DateTimeDetails().oT()
                ..FacId = data[0]
                ..TranDate = DateFormat('dd-MM-yyyy').parse(data[1]).toString()
                ..FromDateTime = DateFormat('dd-MM-yyyy')
                    .parse(data[2])
                    .toString()
                ..ToDateTime = DateFormat('dd-MM-yyyy')
                    .parse(data[3])
                    .toString()
                ..TotalDeposit = data[4]
                ..TotalWithdrawl = data[5]
                    .split("!")
                    .first
                ..Status = "SUCCESS";
              await apiDetails.save();
            }
            await IppbApi().select().delete();
          }
        }
        print("IppbBoda are:");
        print(await IppbApi().select().toMapList());
        //return res;
      }
      else {
        final apiDetails = IppbApi()
          ..ReqDATE = DateTimeDetails().currentDate()
          ..ReqTime = DateTimeDetails().oT()
          ..FacId = officeId
          ..Status = response.reasonPhrase.toString()
          ..Remarks = err;
        await apiDetails.save();
        print(response.reasonPhrase);
        // return response.reasonPhrase.toString();
      }
    }
    catch (e) {
      final ofcMaster = await OFCMASTERDATA().select().toList();
      var officeId = ofcMaster[0].BOFacilityID.toString();
      print("Exception in IPPB API CALL: $e");
      await LogCat().writeContent("File download: $e \n\n");
      final apiDetails = IppbApi()
        ..ReqDATE = DateTimeDetails().currentDate()
        ..ReqTime = DateTimeDetails().oT()
        ..FacId = officeId
        ..Status = e.toString()
        ..Remarks = e.toString();
      await apiDetails.save();
    }

  }
}

