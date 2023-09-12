//
// for(int i=0;i<entities.length;i++){
//   // print("lkajslf"+entities[i].toString());
//   String fileName=entities[i].toString().substring(entities[i].toString().length-8,entities[i].toString().length-5);
//   // if(entities[i].toString().endsWith("950"))
//   // print("fileName: $fileName");
//
//   if(fileName=="950"){
//     print("Inside 950 file name");
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//
//     // print(fields.length);
//     // print(fields[0]);
//     // print(fields[1]);
//     // print(fields[2]);
//     // List resm=[];
//     // // print(fields[0][0]);
//     // // print(fields[0][1]);
//     // // print(fields[0][0].split("\n"));
//     // // print(fields[0][0].split("\n").length);
//     // for(int i=0;i<fields.length;i++){
//     // resm.add(fields[i]);
//     //
//     // }
//     // print("Resm length: "+resm.length.toString());
//     // List res=fields[0][0].split("‡");
//     // print("Res is: "+res[0]);
//     // print("Resm is: "+resm[0].toString());
//     // print("Resm is: "+resm[1].toString());
//     // print("Resm is: "+resm[2].toString());
//
//     try {
//       for (int i = 0; i < fields.length; i++) {
//         print("Entered Loop");
//         //text = textList.toString().replace("[", "").replace("]", "");
//         List finalresult = fields[i].toString().replaceAll("[", "")
//             .replaceAll("]", "").trim()
//             .split("‡");
//         // List finalresult=fields[0][0].split("‡");
//         print(finalresult);
//         await Delivery(
//             BO_SLIP: finalresult[0],
//             SOFFICE_ID: finalresult[1],
//             DOFFICE_ID: finalresult[2],
//             BOOK_DATE: finalresult[3],
//             ART_NUMBER: finalresult[4],
//             BOOK_ID: finalresult[5],
//             LINE_ITEM: double.parse(finalresult[6]),
//             MATNR: finalresult[7],
//             BAG_ID: finalresult[8],
//             INSURANCE: finalresult[9],
//             TOTAL_MONEY: double.parse(finalresult[10]),
//             POST_DUE: double.parse(finalresult[11]),
//             DEM_CHARGE: double.parse(finalresult[12]),
//             COMMISSION: double.parse(finalresult[13]),
//             SOURCE_PINCODE: int.parse(finalresult[14]),
//             DESTN_PINCODE: int.parse(finalresult[15]),
//             BO_ID: finalresult[16],
//             REGISTERED: finalresult[17],
//             RETURN_SERVICE: finalresult[18],
//             COD: finalresult[19],
//             VPP: finalresult[20],
//             MONEY_TO_BE_COLLECTED: double.parse(finalresult[22]),
//             REDIRECTION_FEE: double.parse(finalresult[50]),
//             CUST_DUTY: double.parse(finalresult[51]),
//             REPORTING_SO_ID: finalresult[52]
//         ).upsert1();
//         await Addres(
//           BO_SLIP: finalresult[0],
//           ART_NUMBER: finalresult[4],
//           BOOK_ID: finalresult[5],
//           BAG_ID: finalresult[8],
//           SEND_CUST_N: finalresult[23],
//           SEND_ADD1: finalresult[24],
//           SEND_ADD2: finalresult[25],
//           SEND_ADD3: finalresult[26],
//           SEND_STREET: finalresult[27],
//           SEND_CITY: finalresult[28],
//           SEND_COUNTRY: finalresult[29],
//           SEND_STATE: finalresult[30],
//           SEND_EMAIL: finalresult[31],
//           SEND_PIN: int.parse(finalresult[32]),
//           SEND_FAX: finalresult[33],
//           SEND_MOB: finalresult[34],
//           REC_NAME: finalresult[35],
//           REC_ADDRESS1: finalresult[36],
//           REC_ADDRESS2: finalresult[37],
//           REC_ADDRESS3: finalresult[38],
//           REC_COUNTRY: finalresult[39],
//           REC_STATE: finalresult[40],
//           REC_STREET: finalresult[41],
//           REC_CITY: finalresult[42],
//           REC_PIN: int.parse(finalresult[43]),
//           REC_MOB: finalresult[44],
//           REC_EMAIL: finalresult[45],
//           REC_FAX: finalresult[46],
//         ).upsert1();
//         print("Insertion completed");
//       }
//     }catch(e){
//       await DeliveryModel().execSQL('ROLLBACK');
//     }
//     print("Exited insertion loop");
//   }
//   else if(fileName=="953"){
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//     //print(fields[0][0].split("\n").length);
//     for(int i=0;i<fields.length;i++)
//     {
//       print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//       await Delivery(
//         BO_SLIP: finalresult[0],
//         SOFFICE_ID: finalresult[1],
//         DOFFICE_ID: finalresult[2],
//         BOOK_DATE: finalresult[3],
//         ART_NUMBER: finalresult[4],
//         BOOK_ID: finalresult[5],
//         MATNR: finalresult[6],
//         LINE_ITEM: double.parse(finalresult[7]),
//         COMMISSION: double.parse(finalresult[8]),
//         TOTAL_MONEY: double.parse(finalresult[9]),
//         SOURCE_PINCODE: int.parse(finalresult[10]),
//         DESTN_PINCODE: int.parse(finalresult[11]),
//         EMO_MESSAGE: finalresult[12],
//         BO_ID: finalresult[13],
//         REDIRECTION_SL: double.parse(finalresult[14]),
//         MOD_PIN: int.parse(finalresult[36]),
//         REPORTING_SO_ID: finalresult[42],
//         ART_RECEIVE_DATE:DateTimeDetails().oD() ,
//         ART_RECEIVE_TIME:DateTimeDetails().oT() ,
//       ).upsert1();
//
//       await Addres(
//           BO_SLIP: finalresult[0],
//           ART_NUMBER: finalresult[4],
//           BOOK_ID: finalresult[5],
//           SEND_CUST_N: finalresult[15],
//           SEND_ADD1: finalresult[16],
//           SEND_ADD2: finalresult[17],
//           SEND_ADD3: finalresult[18],
//           SEND_STREET: finalresult[19],
//           SEND_CITY: finalresult[20],
//           SEND_COUNTRY: finalresult[21],
//           SEND_STATE: finalresult[22],
//           SEND_EMAIL: finalresult[23],
//           SEND_PIN: int.parse(finalresult[24]),
//           SEND_FAX: finalresult[25],
//           SEND_MOB: finalresult[26],
//           REC_NAME: finalresult[27],
//           REC_ADDRESS1: finalresult[28],
//           REC_ADDRESS2: finalresult[29],
//           REC_ADDRESS3: finalresult[30],
//           REC_COUNTRY: finalresult[31],
//           REC_STATE: finalresult[32],
//           REC_STREET: finalresult[33],
//           REC_CITY: finalresult[34],
//           REC_PIN: int.parse(finalresult[35]),
//           REC_MOB: finalresult[37],
//           REC_EMAIL: finalresult[38],
//           REC_FAX: finalresult[39]
//       ).upsert1();
//
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//   else if(fileName=="957"){
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//     print(fields[0][0].split("\n").length);
//
//     for(int i=0;i<fields.length;i++)
//     {
//       print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//
//       await BOSLIP_STAMP1(
//           BO_SLIP_NO: finalresult[0],
//           ZMOFACILITYID: finalresult[1],
//           MATNR: finalresult[2],
//           ZINV_PARTICULAR: finalresult[3],
//           MENGE_D: finalresult[4],
//           ZCREATEDT: finalresult[5],
//           ZMOCREATEDBY: finalresult[6]
//       ).upsert1();
//
//
//
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//   else if(fileName=="959"){
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//    // print(fields[0][0].split("\n").length);
//
//     for(int i=0;i<fields.length;i++)
//     {
//       print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//
//       await BOSLIP_CASH1(
//           BO_SLIP_NO: finalresult[0],
//           DATE_OF_SENT: finalresult[1],
//           SO_PROFIT_CENTER: finalresult[3],
//           BO_PROFIT_CENTER: finalresult[4],
//           AMOUNT: finalresult[5],
//           WEIGHT_OF_CASH_BAG: finalresult[6],
//           CHEQUE_NO: finalresult[2],
//           CHEQUE_AMOUNT: finalresult[7],
//           CASHORCHEQUE: finalresult[8]
//       ).upsert1();
//
//
//
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//   else if(fileName=="961"){
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//     print(fields[0][0].split("\n").length);
//
//     for(int i=0;i<fields.length;i++)
//     {
//       print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//
//       await BOSLIP_DOCUMENT1(
//           BO_SLIP_NO: finalresult[0],
//           DOCUMENT_DETAILS: finalresult[3],
//           TOOFFICE: finalresult[2]
//       ).upsert1();
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//   else if(fileName=="964"){
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//     print(fields[0][0].split("\n").length);
//
//     for(int i=0;i<fields.length;i++)
//     {
//       // print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//       for(int i=0;i<finalresult.length;i++){
//         print(finalresult[i]);
//       }
//       await BSRDETAILS_NEW(
//         BOSLIPID: finalresult[0],
//         BO_SLIP_DATE: finalresult[1],
//         BAGNUMBER: finalresult[3],
//         CLOSING_BALANCE: finalresult[4],
//         CB_DATE: finalresult[5],
//         CASH_STATUS: finalresult[6],
//         STAMP_STATUS: finalresult[7],
//         DOCUMENT_STATUS: finalresult[8],
//       ).upsert1();
//
//
//
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//   if(fileName=="384"){
//     print("fileName: $fileName");
//     print("TRue");
//     final input = new File(entities[i].path).openRead();
//     final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
//     print(fields);
//     print(fields[0][0].split("\n").length);
//
//     for(int i=0;i<fields.length;i++)
//     {
//       print("Entered Loop");
//       List finalresult=fields[i].toString().replaceAll("[", "").replaceAll("]", "").trim().split("‡");
//       print(finalresult);
//
//       await BAGDETAILS_NEW(
//           FROMOFFICE: finalresult[4],
//           TOOFFICE: finalresult[5],
//           TDATE: finalresult[6],
//           BAGNUMBER: finalresult[3],
//           BOSLIPNO: finalresult[8],
//           NO_OF_ARTICLES: finalresult[9]
//       ).upsert1();
//
//       await DESPATCHBAG(
//         SCHEDULE: finalresult[0],
//         SCHEDULED_TIME: finalresult[1],
//         MAILLIST_TO_OFFICE: finalresult[2],
//         BAGNUMBER: finalresult[3],
//         FROM_OFFICE: finalresult[4],
//         TO_OFFICE: finalresult[5],
//         REMARKS: finalresult[7],
//
//       ).upsert1();
//       print("Insertion completed");
//     }
//     print("Exited insertion loop");
//   }
//
//   ///Switch On Acknowledgement
//   // if (entities[i].toString().substring(38, 48) == 'ACK_BOLIVE')
//   if (entities[i].toString().contains('ACK_BOLIVE'))
//   {
//     subRes.clear();
//     final file = File(entities[i].path);
//     List<int> firstLine = [];
//     List<int> second = [];
//     int firstLineLast = 0;
//     List<int> s1 = file.readAsBytesSync();
//     Uint8List list = Uint8List.fromList(s1);
//     try {
//       for (int i = 0; i < list.length; i++) {
//         if (list[i] != 10) {
//           firstLine.add(list[i]);
//         } else {
//           firstLineLast = i;
//           break;
//         }
//       }
//     } catch (e) {
//       print("Error is $e");
//     }
//     try {
//       for (int i = firstLineLast+1; i < list.length; i++) {
//         if (list[i] == 135) {
//           list[i] = 1;
//         }
//         second.add(list[i]);
//       }
//     } catch (e) {
//       print("Error in second is $e");
//     }
//     List acknowledgeResult = utf8.decode(firstLine).toString().split("‡");
//     final ackAcknowledge = SwitchOnAcknowledge()
//       ..ParentOfficeNumber = acknowledgeResult[0]
//       ..OfficeId = acknowledgeResult[1]
//       ..BOSequenceId = acknowledgeResult[2]
//       ..OfficeName = acknowledgeResult[3]
//       ..LegacyCode = acknowledgeResult[4]
//       ..SanctionedLimit = acknowledgeResult[5]
//       ..CashBalance = acknowledgeResult[6];
//     await ackAcknowledge.upsert1();
//
//
//
//     List acknowledgementResult = utf8.decode(second).toString().split("");
//     List ackResult = acknowledgementResult.toString().replaceAll(",", "\n").replaceAll("]", "").split("\n");
//     final acknowledgement = SwitchOnAcknowledgement()
//       ..LegacyUpdation = ackResult[1]
//       ..SanctionedDeletion = ackResult[3]
//       ..SanctionedInsertion = ackResult[5]
//       ..UpdateWallet = ackResult[7]
//       ..InsertionClosingBalance = ackResult[9]
//       ..InsertionOpeningBalance = ackResult[11]
//       ..InsertionOpeningStock = ackResult[13];
//     await acknowledgement.upsert1();
//   }
//
//   ///Leave Balance
//   // if (entities[i].toString().substring(38, 43) == 'Leave')
//   if (entities[i].toString().contains('Leave'))
//   {
//     subRes.clear();
//     final leaveFile = File(entities[i].path).openRead();
//     final leaveFields = await leaveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < leaveFields.length; i++) {
//       List leaveResult = leaveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < leaveResult.length; i++) {
//         subRes.add(leaveResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final updateLeave = LeaveBalanceTable()
//             ..EmployeeNumber = subRes[i][0]
//             ..QuotaType = subRes[i][1]
//             ..LeaveBalance = subRes[i][2];
//           await updateLeave.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Leave Balance', DateTimeDetails().currentDateTime());
//   }
//
//   ///VPP MO Commission
//   // if (entities[i].toString().substring(38, 41) == 'VPP')
//   if (entities[i].toString().contains( 'VPP'))
//   {
//     subRes.clear();
//     final vppMOFile = File(entities[i].path).openRead();
//     final vppMOFields = await vppMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < vppMOFields.length; i++) {
//       List vppMOResult = vppMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < vppMOResult.length; i++) {
//         subRes.add(vppMOResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addVppMO = VppMOCommission()
//             ..Commission = subRes[i][0]
//             ..MinimumAmount = subRes[i][1]
//             ..MaximumAmount = subRes[i][2]
//             ..CommissionAmount = subRes[i][3]
//             ..AdditionalService = subRes[i][4]
//             ..ValueID = subRes[i][5]
//             ..Identifier = subRes[i][6];
//           await  addVppMO.upsert1();
//         }
//       }
//     }
//     addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-VPP', DateTimeDetails().currentDateTime());
//   }
//   ///Biller Data
//
//   if(entities[i].toString().contains('BillerData'))
//   {
//     subRes.clear();
//     print("Inside biller data");
//     final billerFile = await File(entities[i].path).openRead();
//     final billerFiles =  await billerFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < billerFiles.length; i++) {
//       List billerResult = billerFiles.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < billerResult.length; i++) {
//         subRes.add(billerResult[i].toString().split("‡"));
//       }
//       print("Biler Data file");
//
//       for (int i = 0; i < subRes.length; i++) {
//
//         if (subRes[i].toString().isNotEmpty && subRes[i][0].toString()!="") {
//           final addBiller = BillerData()
//             ..BillerId = subRes[i][0]
//             ..BillerName = subRes[i][1];
//           await addBiller.upsert1();
//         }
//       }
//       final b = await BillerData().select().toMapList();
//     }
//     // addFileToDB(entities[i].toString(), dir.toString(), 'Biller Data', DateTimeDetails().currentDateTime());
//   }
//
//   ///Ins MO Commission
//   // if (entities[i].toString().substring(38, 41) == 'INS')
//   if (entities[i].toString().contains( 'INS'))
//   {
//     subRes.clear();
//     final insMOFile = File(entities[i].path).openRead();
//     final insMOFields = await insMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < insMOFields.length; i++) {
//       List insMOResult = insMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < insMOResult.length; i++) {
//         subRes.add(insMOResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addINSMO = InsMOCommission()
//             ..Commission = subRes[i][0]
//             ..MinimumAmount = subRes[i][1]
//             ..MaximumAmount = subRes[i][2]
//             ..CommissionAmount = subRes[i][3]
//             ..AdditionalService = subRes[i][4]
//             ..ValueID = subRes[i][5]
//             ..Identifier = subRes[i][6];
//           await addINSMO.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-INS', DateTimeDetails().currentDateTime());
//   }
//
//   ///EMO MO Commission
//   // if (entities[i].toString().substring(38, 41) == 'EMO')
//   if (entities[i].toString().contains('EMO'))
//   {
//     subRes.clear();
//     final emoMOFile = File(entities[i].path).openRead();
//     final emoMOFields = await emoMOFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < emoMOFields.length; i++) {
//       List emoMOResult = emoMOFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < emoMOResult.length; i++) {
//         subRes.add(emoMOResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addEMOMO = EmoMOCommission()
//             ..Commission = subRes[i][0]
//             ..MinimumAmount = subRes[i][1]
//             ..MaximumAmount = subRes[i][2]
//             ..CommissionAmount = subRes[i][3]
//             ..AdditionalService = subRes[i][4]
//             ..ValueID = subRes[i][5]
//             ..Identifier = subRes[i][6];
//           await addEMOMO.upsert1();
//         }
//       }
//     }
//     await   addFileToDB(entities[i].toString(), dir.toString(), 'MO Commission Master-EMO', DateTimeDetails().currentDateTime());
//   }
//
//   ///Products Master
//   // // if (entities[i].toString().substring(38, 45) == 'Product')
//   if (entities[i].toString().contains('Product')) {
//     subRes.clear();
//     final productsFile = await File(entities[i].path).openRead();
//     final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < productFields.length; i++) {
//       List productResult = productFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < productResult.length; i++) {
//         subRes.add(productResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addProduct = await ProductsMaster()
//             ..ItemCode = subRes[i][0]
//             ..ShortDescription = subRes[i][1]
//             ..CategoryDescription = subRes[i][2]
//             ..SalePrice = subRes[i][3]
//             ..EffStartDate = subRes[i][4]
//             ..EffEndDate = subRes[i][5]
//             ..POSCurrentStock = subRes[i][6]
//             ..OpeningStock = subRes[i][7]
//             ..Division = subRes[i][8]
//             ..OrderType = subRes[i][9]
//             ..MaterialGroup = subRes[i][10]
//             ..UnitMeasurement = subRes[i][11]
//             ..CreatedBy = subRes[i][12]
//             ..CreatedOn = subRes[i][13]
//             ..ModifiedBy = subRes[i][14]
//             ..ModifiedOn = subRes[i][15]
//             ..Identifier = subRes[i][16];
//           await  addProduct.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
//   }
//   // if (entities[i].toString().contains('Product'))
//   // {
//   //   print("Inside Product master");
//   //   subRes.clear();
//   //   final productsFile = await File(entities[i].path).openRead();
//   //   final productFields = await productsFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//   //   for (int i = 1; i < productFields.length; i++) {
//   //     subRes.add(productFields[i].toString().split("‡"));
//   //   }
//   //   for (int i = 0; i < subRes.length; i++) {
//   //     if (subRes[i].toString().isNotEmpty) {
//   //       final addProduct = await ProductsMaster()
//   //           ..ItemCode = subRes[i][0]
//   //           ..ShortDescription = subRes[i][1]
//   //           ..CategoryDescription = subRes[i][2]
//   //           ..SalePrice = subRes[i][3]
//   //           ..EffStartDate = subRes[i][4]
//   //           ..EffEndDate = subRes[i][5]
//   //           ..POSCurrentStock = subRes[i][6]
//   //           ..OpeningStock = subRes[i][7]
//   //           ..Division = subRes[i][8]
//   //           ..OrderType = subRes[i][9]
//   //           ..MaterialGroup = subRes[i][10]
//   //           ..UnitMeasurement = subRes[i][11]
//   //           ..CreatedBy = subRes[i][12]
//   //           ..CreatedOn = subRes[i][13]
//   //           ..ModifiedBy = subRes[i][14]
//   //           ..ModifiedOn = subRes[i][15]
//   //           ..Identifier = subRes[i][16];
//   //       addProduct.upsert();
//   //     }
//   //   }
//   //   addFileToDB(entities[i].toString(), dir.toString(), 'Product Master', DateTimeDetails().currentDateTime());
//   // }
//
//   ///WeightMaster
//   // if (entities[i].toString().substring(38, 44) == 'Weight')
//
//   if (entities[i].toString().contains('Weight')){
//     subRes.clear();
//     final weightFile = File(entities[i].path).openRead();
//     final weightFields = await weightFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < weightFields.length; i++) {
//       List weightResult = weightFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < weightResult.length; i++) {
//         subRes.add(weightResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addWeight = WeightMaster()
//             ..WeightId = subRes[i][0]
//             ..MinimumWeight = subRes[i][1]
//             ..MaximumWeight = subRes[i][2]
//             ..ServiceId = subRes[i][3]
//             ..Identifier = subRes[i][4];
//           await addWeight.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Weight Master', DateTimeDetails().currentDateTime());
//   }
//
//   ///Distance Master
//   // if (entities[i].toString().substring(38, 52) == 'DistanceMaster')
//   if (entities[i].toString().contains( 'DistanceMaster'))
//   {
//     subRes.clear();
//     final distanceFile = File(entities[i].path).openRead();
//     final distanceFields = await distanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < distanceFields.length; i++) {
//       List distanceResult = distanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < distanceResult.length; i++) {
//         subRes.add(distanceResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addDistance = DistanceMaster()
//             ..Distance = subRes[i][0]
//             ..MinDistance = subRes[i][1]
//             ..MaxDistance = subRes[i][2]
//             ..Service = subRes[i][3]
//             ..Identifier = subRes[i][4];
//           await   addDistance.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Distance Master', DateTimeDetails().currentDateTime());
//   }
//
//   ///Local Store
//   // if (entities[i].toString().substring(38, 43) == 'Local')
//   if (entities[i].toString().contains('Local'))
//   {
//     subRes.clear();
//     final localStoreFile = File(entities[i].path).openRead();
//     final localStoreFields = await localStoreFile.transform(utf8.decoder).transform(
//         const CsvToListConverter()).toList();
//     for (int i = 0; i < localStoreFields.length; i++) {
//       List localStoreResult = localStoreFields.toString().replaceAll("[", "")
//           .replaceAll("]", "")
//           .split("\n");
//       for (int i = 1; i < localStoreResult.length; i++) {
//         subRes.add(localStoreResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addLocalStore = LocalStoreTable()
//             ..ParentOfficeId = subRes[i][0]
//             ..ParentOfficeName = subRes[i][1]
//             ..OfficeId = subRes[i][2]
//             ..BOSequenceId = subRes[i][3]
//             ..OfficeName = subRes[i][4]
//             ..Address = subRes[i][5]
//             ..Pin = subRes[i][6]
//             ..Latitude = subRes[i][7]
//             ..Longitude = subRes[i][8]
//             ..City = subRes[i][9]
//             ..StateCode = subRes[i][10]
//             ..StateName = subRes[i][11]
//             ..SolutionId = subRes[i][12]
//             ..LegacyCode = subRes[i][13]
//             ..CircleCode = subRes[i][14]
//             ..Circle = subRes[i][15]
//             ..CreatedBy = subRes[i][16]
//             ..CreatedOn = subRes[i][17]
//             ..ModifiedBy = subRes[i][18]
//             ..ModifiedOn = subRes[i][19]
//             ..IsStoreBegin = subRes[i][20]
//             ..WalkInCustomerId = subRes[i][21]
//             ..Identifier = subRes[i][22];
//           await  addLocalStore.upsert1();
//         }
//       }
//     }
//     await    addFileToDB(entities[i].toString(), dir.toString(), 'Local Store Details', DateTimeDetails().currentDateTime());
//   }
//
//   ///Additional Service Mapping
//   // if (entities[i].toString().substring(38, 41) == 'Add')
//   if (entities[i].toString().contains('Add'))
//   {
//     subRes.clear();
//     final additionalServiceMappingFile = File(entities[i].path).openRead();
//     final additionalServiceMappingFields = await additionalServiceMappingFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < additionalServiceMappingFields.length; i++) {
//       List additionalServiceMappingResult = additionalServiceMappingFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < additionalServiceMappingResult.length; i++) {
//         subRes.add(additionalServiceMappingResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addTax = AdditionalServiceMappingTable()
//             ..ServiceId = subRes[i][0]
//             ..AdditionalServiceId = subRes[i][1]
//             ..AdditionalServicePrice = subRes[i][2]
//             ..Identifier = subRes[i][3];
//           await addTax.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Additional Service Mapping', DateTimeDetails().currentDateTime());
//   }
//
//   ///Tax master
//   // if (entities[i].toString().substring(38, 47) == 'TaxMaster')
//   if (entities[i].toString().contains('TaxMaster'))
//   {
//     subRes.clear();
//     final taxFile = File(entities[i].path).openRead();
//     final taxFields = await taxFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < taxFields.length; i++) {
//       List taxResult = taxFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < taxResult.length; i++) {
//         subRes.add(taxResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addTax = TaxMaster()
//             ..Service = subRes[i][0]
//             ..PercentageValue = subRes[i][1]
//             ..TaxDescription = subRes[i][2]
//             ..Identifier = subRes[i][3];
//           await addTax.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Tax Master', DateTimeDetails().currentDateTime());
//   }
//
//   ///Switch On
//   // if (entities[i].toString().substring(38, 44) == 'BOLIVE')
//   if (entities[i].toString().contains( 'BOLIVE'))
//   {
//     subRes.clear();
//     final boLiveFile = File(entities[i].path).openRead();
//     final boLiveFields = await boLiveFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < boLiveFields.length; i++) {
//       List boLiveResult = boLiveFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < boLiveResult.length; i++) {
//         subRes.add(boLiveResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addSwitch = SwitchOnTable()
//             ..ParentOfficeId = subRes[i][0]
//             ..OfficeId = subRes[i][1]
//             ..BOSequenceId = subRes[i][2]
//             ..OfficeName = subRes[i][3]
//             ..LegacyCode = subRes[i][4]
//             ..SanctionedLimit = subRes[i][5]
//             ..CashBalance = subRes[i][6];
//           await addSwitch.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Switch On', DateTimeDetails().currentDateTime());
//   }
//
//   ///Service master
//   // if (entities[i].toString().substring(38, 45) == 'Service')
//   if (entities[i].toString().contains('Service'))
//   {
//     subRes.clear();
//     final serviceFile = File(entities[i].path).openRead();
//     final serviceFields = await serviceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < serviceFields.length; i++) {
//       List serviceResult = serviceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 1; i < serviceResult.length; i++) {
//         subRes.add(serviceResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if (subRes[i].toString().isNotEmpty) {
//           final addService = ServiceMaster()
//             ..ServiceId = subRes[i][0]
//             ..ServiceName = subRes[i][1]
//             ..MinimumWeight = subRes[i][2]
//             ..MaximumWeight = subRes[i][3]
//             ..Division = subRes[i][4]
//             ..OrderType = subRes[i][5]
//             ..ProductType = subRes[i][6]
//             ..MaterialGroup = subRes[i][7]
//             ..Identifier = subRes[i][8];
//           await  addService.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Service Master', DateTimeDetails().currentDateTime());
//   }
//
//   ///Tariff Master
//   if (entities[i].toString().substring(38, 50) == 'TariffMaster')
//     if (entities[i].toString().contains( 'TariffMaster'))
//     {
//       subRes.clear();
//       final tariffFile = File(entities[i].path).openRead();
//       final tariffFields = await tariffFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//       for (int i = 0; i < tariffFields.length; i++) {
//         List tariffResult = tariffFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//         for (int i = 1; i < tariffResult.length; i++) {
//           subRes.add(tariffResult[i].toString().split("‡"));
//         }
//         for (int i = 0; i < subRes.length - 1; i++) {
//           if(subRes[i].toString().isNotEmpty) {
//             final addTariff = TariffMaster()
//               ..Service = subRes[i][0]
//               ..WeightId = subRes[i][1]
//               ..Distance = subRes[i][2]
//               ..BasePrice = subRes[i][3]
//               ..Identifier = subRes[i][4];
//             await addTariff.upsert1();
//           }
//         }
//       }
//       await  addFileToDB(entities[i].toString(), dir.toString(), 'Tariff Master', DateTimeDetails().currentDateTime());
//     }
//
//   ///Cash Indent
//   // if (entities[i].toString().substring(56, 58) == 'CI')
//   if (entities[i].toString().contains( 'CI'))
//   {
//     subRes.clear();
//     final cashIndentFile = File(entities[i].path).openRead();
//     final cashIndentFields = await cashIndentFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < cashIndentFields.length; i++) {
//       List cashIndentResult = cashIndentFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 0; i < cashIndentResult.length; i++) {
//         subRes.add(cashIndentResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if(subRes[i].toString().isNotEmpty) {
//           final addCashIndent = CashIndentTable()
//             ..BOID = subRes[i][0]
//             ..Date = subRes[i][1]
//             ..Time = subRes[i][2]
//             ..BOName = subRes[i][3]
//             ..HOName = subRes[i][4]
//             ..Amount1 = subRes[i][5]
//             ..Amount2 = subRes[i][6]
//             ..Amount3 = subRes[i][7]
//             ..AmountType = subRes[i][8];
//           await addCashIndent.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Cash Indent', DateTimeDetails().currentDateTime());
//   }
//
//   ///Special Remittance
//   // if (entities[i].toString().substring(56, 58) == 'SR')
//   if (entities[i].toString().contains( 'SR'))
//   {
//     subRes.clear();
//     final specialRemittanceFile = File(entities[i].path).openRead();
//     final specialRemittanceFields = await specialRemittanceFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < specialRemittanceFields.length; i++) {
//       List specialRemittanceResult = specialRemittanceFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 0; i < specialRemittanceResult.length; i++) {
//         subRes.add(specialRemittanceResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length - 1; i++) {
//         if(subRes[i].toString().isNotEmpty) {
//           final addSpecialRemittance = SpecialRemittanceTable()
//             ..SpecialRemittanceId = subRes[i][0]
//             ..Date = subRes[i][1]
//             ..Time = subRes[i][2]
//             ..BOName = subRes[i][3]
//             ..HOName = subRes[i][4]
//             ..Amount1 = subRes[i][5]
//             ..Amount2 = subRes[i][6]
//             ..Amount3 = subRes[i][7]
//             ..AmountType = subRes[i][8];
//           await  addSpecialRemittance.upsert1();
//         }
//       }
//     }
//     await  addFileToDB(entities[i].toString(), dir.toString(), 'Special Remittance', DateTimeDetails().currentDateTime());
//   }
//
//   ///Excess Cash
//   // if (entities[i].toString().substring(56, 58) == 'EC')
//   if (entities[i].toString().contains( 'EC'))
//   {
//     subRes.clear();
//     final excessCashFile = File(entities[i].path).openRead();
//     final excessCashFields = await excessCashFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     for (int i = 0; i < excessCashFields.length; i++) {
//       List excessCashResult = excessCashFields.toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       for (int i = 0; i < excessCashResult.length; i++) {
//         subRes.add(excessCashResult[i].toString().split("‡"));
//       }
//       for (int i = 0; i < subRes.length; i++) {
//         if(subRes[i].toString().isNotEmpty) {
//           final addExcessCash = ExcessCashTable()
//             ..BOID = subRes[i][0]
//             ..Date = subRes[i][1]
//             ..Time = subRes[i][2]
//             ..BOName = subRes[i][3]
//             ..HOName = subRes[i][4]
//             ..Amount1 = subRes[i][5]
//             ..Amount2 = subRes[i][6]
//             ..Amount3 = subRes[i][7]
//             ..AmountType = subRes[i][8]
//             ..Amount4 = subRes[i][9];
//           await addExcessCash.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Excess Cash', DateTimeDetails().currentDateTime());
//   }
//
//   ///Setup Inventory
//   // if (entities[i].toString().substring(38, 43) == 'SetUp')
//   print("Setup inventory insert");
//   if (entities[i].toString().contains('SetUp'))
//   {
//     print("Setup inventory inside");
//     subRes.clear();
//     final inventoryFile = await File(entities[i].path).openRead();
//     final inventoryFields = await inventoryFile.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
//     print(inventoryFields);
//     for (int i = 0; i < inventoryFields.length; i++) {
//       List inventoryResult = inventoryFields[i].toString().replaceAll("[", "").replaceAll("]", "").split("\n");
//       print(inventoryResult);
//       for (int i = 0; i < inventoryResult.length; i++) {
//         subRes.add(inventoryResult[i].toString().split("‡"));
//       }
//       print(subRes);
//       for (int i = 0; i < subRes.length; i++) {
//         print(subRes[i].toString());
//         print(subRes[i].toString().isNotEmpty);
//         print(subRes[i].toString().length);
//         //if(subRes[i].toString().isNotEmpty  ) {
//         if(subRes[i].toString().length >2  ) {
//           final addExcessCash = SetUpInventoryTable()
//             ..BOId = subRes[i][0]
//             ..InventoryName = subRes[i][1]
//             ..Column1 = subRes[i][2]
//             ..Column2 = subRes[i][3];
//           await  addExcessCash.upsert1();
//         }
//       }
//     }
//     await addFileToDB(entities[i].toString(), dir.toString(), 'Setup Inventory', DateTimeDetails().currentDateTime());
//   }
//
//
// }
