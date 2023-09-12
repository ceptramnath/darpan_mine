import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:darpan_mine/Authentication/CommonMainScreen.dart';
import 'package:darpan_mine/Authentication/LoginScreen_old.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Mails/Bagging/Screens/BagOpen/BagOpenScreen.dart';
import 'package:darpan_mine/Mails/Bagging/Service/BaggingDBService.dart';
import 'package:darpan_mine/Utils/shareFiles.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:root/root.dart';
// import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:darpan_mine/Authentication/LoginScreen_new_aadhar_bio_otp.dart';
import 'package:darpan_mine/Constants/Texts.dart';
import 'package:darpan_mine/DatabaseModel/PostOfficeModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/INSURANCE/Utils/utils.dart';
import 'package:darpan_mine/Mails/MailsMainScreen.dart';
import 'package:darpan_mine/Mails/backgroundoperations.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart' show ByteData, PlatformAssetBundle, rootBundle;
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../HomeScreen.dart';

import 'package:root/root.dart';

import '../../LogCat.dart';
import 'package:http/http.dart' as http;

import 'package:darpan_mine/Delivery/Screens/db/ArticleModel.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  String _currentDateTime="";
  String _onlyDate="";
  String? version;
  String? buildNumber;
  APIEndPoints apiEndPoints = new APIEndPoints();

  void _getTime() async{
    final String formattedDateTime =
    DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString();
    final String onlyDate = DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    _currentDateTime = formattedDateTime;
    _onlyDate = onlyDate;
    print(_onlyDate);

  }

  int? scannerValue;
  bool? _status=false;

  @override
  void initState() {

    createFolder();
    getPrefs();
    insertMasterData();
    super.initState();

  }


  insertMasterData() async
  {
    //Inserting Article Type Master Data
    final fetchArticleMaster = await ARTICLETYPEMASTER().select().toCount();

    if (fetchArticleMaster == 0) {
      print('Inserting Article Master Data..!');
      final fileMaster = await FILEMASTERDATA()
        ..FILETYPE = "BOOKING"
        ..DIVISION = "MO"
        ..ORDERTYPE_SP = "ZPP"
        ..ORDERTYPE_LETTERPARCEL = "ZAM"
        ..ORDERTYPE_EMO = "ZFS"
        ..PRODUCT_TYPE = 'S'
        ..MATERIALGROUP_SP = "DPM"
        ..MATERIALGROUP_LETTER = "DOM"
        ..MATERIALGROUP_EMO = "DMR";

      fileMaster.save();
    }

    // articleTypeMaster
  }

  static Future<String> get getFilePath async{
    // final directory = await getApplicationDocumentsDirectory();
    final directory='storage/emulated/0/Darpan_Mine/assets';

    return directory;
  }
  static Future<File> getFile(String fileName) async{
    final path = await getFilePath;
    ByteData data = await rootBundle.load("assets/images/download.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var newDbFile=await File("storage/emulated/0/Darpan_Mine/assets/download.png").writeAsBytes(bytes, flush: true);
    return File('$path/$fileName');

  }
  static Future<File> saveToFile(var data, String filePath, String fileName) async{
    print("filePath+fileName: " + filePath+fileName);
    final file = await getFile(filePath+fileName);
    return file.writeAsString(data);
  }
  static Future<void> createDir(String filePath) async{
    final path = await getFilePath;
    Directory('$path/$filePath').create(recursive: true);
  }
  static Future<String> readFromFile(String filePath, String fileName) async{
    try{
      final file = await getFile('$filePath$fileName');
      String fileContents = await file.readAsString();
      return fileContents;
    }catch(e){
      final assetFile = await rootBundle.loadString('assets/web/$filePath$fileName');
      if(filePath == ''){
        await saveToFile(assetFile, '$filePath', '$fileName');
      }else{
        await createDir(filePath);
        await saveToFile(assetFile, '$filePath', '$fileName');
      }
      print('copying the file from assets');

      return '';
    }

  }

  Future<void> checkRoot() async {
    bool? result = await Root.isRooted();
    print("Device Rooted: $result");
    setState(() {
      _status = result;
    });
  }


  assetFolder() async{
    final v = await getFilePath;
    Directory('$v').create(recursive: true);
    readFromFile('','index.html');
  }

  fetchStampBalanceDetails(String token, String uri, String boid) async {
    print('inside Stamp Balance API');
    String requestURI = uri + boid;
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse(requestURI));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      print(res);

      List<dynamic> expansionInventoryName = json.decode(res);

      final stampTable = await BagStampsTable().select().toList();
      final productTable = await ProductsTable().select().toList();

      //when there is no data available then only inventory will be added
      //code by Rohit on 03-08-2022
      if (productTable.length == 0) {
        if (expansionInventoryName.isNotEmpty) {
          for (int i = 0; i < expansionInventoryName.length; i++) {

            await BaggingDBService().addProductsMain(
                expansionInventoryName[i]['stamp_name'],
                double.parse(expansionInventoryName[i]['denomination'].toString()),
                expansionInventoryName[i]['quantity']);
          }
        }
      }
      if (stampTable.length == 0) {
        if (expansionInventoryName.isNotEmpty) {
          for (int i = 0; i < expansionInventoryName.length; i++) {
            await BaggingDBService().addInventoryFromBagToDB(
                expansionInventoryName[i]['stamp_name'],
                expansionInventoryName[i]['denomination'].toString(),
                expansionInventoryName[i]['quantity'].toString(),
                expansionInventoryName[i]['total_amount'].toString(),
                expansionInventoryName[i]['boid'],
                'Received');
          }
        }
      }


    } else {
      print(response.reasonPhrase);
    }
  }


  Future<void> createFolder() async {

    // print('Inserting Inventory Details when Table is Empty');
    // final productTableCount = await ProductsTable().select().toCount();
    // final ofcMaster = await OFCMASTERDATA().select().toList();
    // final userDetails = await USERLOGINDETAILS().select().Active.equals(true).toList();
    //
    // if (productTableCount==0)
    // {
    //   await fetchStampBalanceDetails(userDetails[0].AccessToken.toString(), apiEndPoints.fetchStampBalanceAPI,
    //       ofcMaster[0].BOFacilityID.toString());
    // }
    //



    print("Before check root");
  await checkRoot();
  print("After check root");
  if(_status==true){
    UtilFs.showToast("Device is Rooted. Cannot Proceed",context);
  }
  else {
    _getTime();
    final mainFolder = 'Darpan_Mine';
    final logsFolder = 'Logs';
    final reportsFolder = 'Reports';
    final screenshotFolder = 'Screenshots';
    final exportFolder = 'Exports';
    final dbFolder = 'Databases';
    // bool permGranted = true;

    final mainPath = Directory('storage/emulated/0/$mainFolder');
    final logsPath = Directory('storage/emulated/0/$mainFolder/$logsFolder');
    final reportsPath = Directory(
        'storage/emulated/0/$mainFolder/$reportsFolder');
    final screenshotPath = Directory(
        'storage/emulated/0/$mainFolder/$screenshotFolder');
    final exportPath = Directory(
        'storage/emulated/0/$mainFolder/$exportFolder');
    final dbPath = Directory('storage/emulated/0/$mainFolder/$dbFolder');
    // final dbPath=await getDatabasesPath();
    final logpath = File(
        'storage/emulated/0/$mainFolder/$logsFolder/$_onlyDate.txt');
    // var RICTPLI = Directory('storage/emulated/0/$mainFolder/.RICTPLI');
    // var RICTCBS = Directory('storage/emulated/0/$mainFolder/.RICTCBS');
    var dcsvpath = Directory('storage/emulated/0/$mainFolder/DownloadCSV');
    var ucsvpath = Directory('storage/emulated/0/$mainFolder/UploadCSV');
    var uploads = Directory('storage/emulated/0/$mainFolder/Uploads');
    final dataPath = Directory(dataDirectory);
    final downloadedFilesPath = Directory(dataDirectory + '/Delivery');
    final uploadedFilesPath = Directory(dataDirectory + '/Booking');

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // permGranted = false;
      await Permission.phone.request();
      await Permission.storage.request();
      await Permission.location.request();
      await Permission.camera.request();
      await Permission.bluetooth.request();
      await Permission.bluetoothScan.request();
      await Permission.bluetoothAdvertise.request();
      await Permission.bluetoothConnect.request();

      print(Permission.storage.request());


      // Timer(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainHomeScreen(MailsMainScreen(),1))));
      final checkRolloutStatus = await USERLOGINDETAILS().select().toList();
      print("checkRolloutStatus");
      print(checkRolloutStatus.length);
      // print(checkRolloutStatus[0].Password);

      //When Login Table is Empty or having data with default password navigate to Password Login Screen
      if(checkRolloutStatus.length==0 || checkRolloutStatus[0].Password==apiEndPoints.defaultPassword)
      {
        Timer(Duration(seconds: 2), () =>
            Navigator.pushReplacement(
                //context, MaterialPageRoute(builder: (_) => LoginScreen())));
                context, MaterialPageRoute(builder: (_) => CommonLoginScreen())));
      }

      //else Navigate to Aadhar Login Screen
      else{
        // Timer(Duration(seconds: 2), () =>
        //     Navigator.pushReplacement(
        //         context, MaterialPageRoute(builder: (_) => AadharLoginScreen())));
        Timer(Duration(seconds: 2), () =>
            Navigator.pushReplacement(
                //context, MaterialPageRoute(builder: (_) => LoginScreen())));
                context, MaterialPageRoute(builder: (_) => CommonLoginScreen())));
      }
      // Timer(Duration(seconds: 2), () =>
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (_) => ShareFilesScreen())));

      // Timer(Duration(seconds: 2), () =>
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (_) => BagOpenScreen())));
    }

    if (await mainPath.exists()) {
      if (await logsPath.exists()) {} else {
        logsPath.create();
      }
      if (await reportsPath.exists()) {} else {
        reportsPath.create();
      }
      if (await screenshotPath.exists()) {} else {
        screenshotPath.create();
      }
      if (await dbPath.exists()) {} else {
        dbPath.create();
      }
      if (await exportPath.exists()) {} else {
        exportPath.create();
      }
      // if (await RICTPLI.exists()) {} else {
      //   RICTPLI.create();
      // }
      // if (await RICTCBS.exists()) {} else {
      //   RICTCBS.create();
      // }
      if (await dcsvpath.exists()) {} else {
        dcsvpath.create();
      }
      if (await ucsvpath.exists()) {} else {
        ucsvpath.create();
      }
      if (await uploads.exists()) {} else {
        uploads.create();
      }
      if (await dataPath.exists()) {} else {
        dataPath.create();
      }
      if (await downloadedFilesPath.exists()) {} else {
        downloadedFilesPath.create();
      }
      if (await uploadedFilesPath.exists()) {} else {
        uploadedFilesPath.create();
      }
      if (await logpath.exists()) {}

      else {
        logpath.create();
      }
      // await _checkFirstRun();
      await assetFolder();

      await LogCat().writeContent("$_currentDateTime:  App initialised\n" "\n");
    }
    else {
      await mainPath.create();
      await logsPath.create();
      await reportsPath.create();
      await screenshotPath.create();
      await exportPath.create();
      await logpath.create();
      await dbPath.create();
      // await RICTPLI.create();
      // await RICTCBS.create();
      await dcsvpath.create();
      await ucsvpath.create();
      await uploads.create();
      // await _checkFirstRun();
      await assetFolder();
      await dataPath.create();
      await downloadedFilesPath.create();
      await uploadedFilesPath.create();

      _getTime();
      await LogCat().writeContent("$_currentDateTime:  App initialised\n" "\n");
      // await LogCat().writeContent(" App Folders Created: $_currentDateTime\n\n");

    }
    if (status.isGranted) {
      // await _checkFirstRun();
      // await ds.db;
      // Timer(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(false,scannerValue!,false))));
      // Timer(Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainHomeScreen(MailsMainScreen(),1))));

      final checkRolloutStatus = await USERLOGINDETAILS().select().toList();
      print(checkRolloutStatus.length);
      // print(checkRolloutStatus[0].Password);

      //When Login Table is Empty or having data with default password navigate to Password Login Screen
      if(checkRolloutStatus.length==0 || checkRolloutStatus[0].Password==apiEndPoints.defaultPassword)
        {
          Timer(Duration(seconds: 2), () =>
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => CommonLoginScreen())));
        }

      //else Navigate to Aadhar Login Screen
      else{
        // Timer(Duration(seconds: 2), () =>
        //     Navigator.pushReplacement(
        //         context, MaterialPageRoute(builder: (_) => AadharLoginScreen())));
        //Changed as per orders of AD, CEPT on 30062023
        Timer(Duration(seconds: 2), () =>
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => CommonLoginScreen())));
      }




      // Timer(Duration(seconds: 2), () =>
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (_) => ShareFilesScreen())));

      // Timer(Duration(seconds: 2), () =>
      //     Navigator.pushReplacement(
      //         context, MaterialPageRoute(builder: (_) => BagOpenScreen())));
    }
    List assets = [
      'New_Business_Quote.txt',
      'calculatePremium.txt',
      'fetchreceiptList.txt',
      'getOfficeDetails.txt',
      'getProposalDetails.txt',
      'getProposalNumber.txt',
      'getQuote.txt',
      'initialPremiumPayment.txt',
      'payProposalPremium.txt',
      'policySearch.txt',
      'proposalIndexing.txt',
      'quoteSearch.txt',
      'RenewalPremiumPayment.txt',
      'searchPolicyForIndexing.txt'
    ];
    // final path = '$cachepath';
    // for (int i = 0; i < assets.length; i++) {
    //   ByteData data = await rootBundle.load("assets/pli/${assets[i]}");
    //   List<int> bytes = data.buffer.asUint8List(
    //       data.offsetInBytes, data.lengthInBytes);
    //   File file = File("$cachepath/${assets[i]}");
    //   if (file.existsSync()) {}
    //   else
    //     await File("$cachepath/${assets[i]}")
    //         .writeAsBytes(bytes, flush: true);
    // }
    List cbsassets = [
      'ConfigDetails.txt',
      'withdrawalFinalSubmit.txt',
      'signatureAuthentication.txt',
      'openAccount.txt',
      'miniStatement.txt',
      'hvwInitiateRequest.txt',
      'hvwEnquiry.txt',
      'highValuewithdrawal.txt',
      'fetchSOL.txt',
      'fetchOAP.txt',
      'fetchAccountDetails.txt',
      'depositAmount.txt',
      'cifEnquiry.txt'
    ];
    // final cbspath = '$cachepath';
    // Directory d=await getTemporaryDirectory();
    // final cbspath=await d.path.toString()
    // for (int i = 0; i < cbsassets.length; i++) {
    //   ByteData data = await rootBundle.load("assets/cbs/${cbsassets[i]}");
    //   List<int> bytes = data.buffer.asUint8List(
    //       data.offsetInBytes, data.lengthInBytes);
    //   // File file = File("$cachepath/${cbsassets[i]}");
    //   File file=await DefaultCacheManager().putFile(cbspath, cbsassets[i]);
    //   if (file.existsSync()) {}
    //   else
    //     // await File("$cachepath/${cbsassets[i]}")
    //     //     .writeAsBytes(bytes, flush: true);
    // await File("$cbspath/${cbsassets[i]}").writeAsBytes(bytes,flush:true);
    // }
    //
    // print("CBS Details");

    print(DateTimeDetails().cbsdate());
    print(DateTimeDetails().cbsdatetime());
  }
  }


  getPrefs() async {
    // final emptyLatLng = await OfficeMasterPinCode().select().Delivery.not.equals("Non-Delivery").and.OfficeType.equals('PO').and.Latitude.isNull().toMapList();
    // if (emptyLatLng.isNotEmpty) {
    //   for (int i = 0; i < emptyLatLng.length; i++) {
    //     print("Empty co-ordinate offices are ${emptyLatLng[i]['OfficeName']}");
    //   }
    // }
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      scannerValue = _prefs.getInt('scanner_value') ?? 4;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_bottom_multiply.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          children: [
                            Text('Department of Posts', style: TextStyle(color: Colors.white, fontSize: 20),),
                            SizedBox(height: 5,),
                            Text('Ministry of Communications', style: TextStyle(color: Colors.white),),
                            Text('Government of India', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset('assets/images/ic_arrows.png', width: 150,),)
                  ],
                ),),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text('DARPAN', style: TextStyle(color: Colors.white, fontSize: 50),),
                    // Container(
                    //     margin: EdgeInsets.only(left: 100.w),
                    //     child: Text('with new technology', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 10), textAlign: TextAlign.right,)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


_SplashScreenState ss=_SplashScreenState();