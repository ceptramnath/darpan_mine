import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Delivery/Screens/CustomAppBar.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_server/http_server.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:open_settings/open_settings.dart';
import 'package:sqflite/sqflite.dart';

// import 'dart:html' as temp;

import '../LogCat.dart';

class ShareFilesScreen extends StatefulWidget {
  @override
  _ShareFilesScreenState createState() => _ShareFilesScreenState();
}

class _ShareFilesScreenState extends State<ShareFilesScreen> {
  bool start = true;
  bool stop = false;
  late HttpRequest request;
  late HttpServer server;
  TextEditingController share = new TextEditingController();
  Connectivity connectivity = Connectivity();
  final info = NetworkInfo();
  String? host = "";
  List<OFCMASTERDATA> bpmdata = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appbarTitle: 'File Share',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blueGrey)),
                textColor: Color(0xFFCD853F),
                color: Colors.white,
                child: new Text(
                  "Connect to WIFI network",
                ),
                onPressed: () async {
                  OpenSettings.openWIFISetting();
                },
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "First Connect Mobile to any Mobile/Laptop/USB-Wifi HotSpot"),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(color: Colors.blueGrey),
              controller: share,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Color(0xFFCFB53B)),
                  ),
                  prefixIcon: Icon(
                    MdiIcons.monitorShare,
                    color: Colors.blueGrey,
                  ),
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  labelText: 'Browser URL',
                  contentPadding: EdgeInsets.all(15.0),
                  isDense: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCFB53B))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCFB53B)))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: start,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blueGrey)),
              textColor: Color(0xFFCD853F),
              color: Colors.white,
              child: new Text(
                "Start sharing",
              ),
              onPressed: () async {
                var con = await Connectivity().checkConnectivity();
                if (con == ConnectivityResult.wifi) {
                  host = await info.getWifiIP();
                  if (host!.startsWith("192")) {
                    setState(() {
                      start = false;
                      stop = true;
                    });
                    dbshare();
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Connect to a WiFi Network to enable File Sharing",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
            ),
          ),
          Visibility(
            visible: stop,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blueGrey)),
              textColor: Color(0xFFCD853F),
              color: Colors.white,
              child: new Text(
                "Stop sharing",
              ),
              onPressed: () async {
                share.text = "";
                server.close();
                setState(() {
                  stop = false;
                  start = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  dbshare() async {
    bpmdata = await OFCMASTERDATA().select().toList();

    String databasesPath = await getDatabasesPath();
    print("Database path");
    print(databasesPath);
    //String db1=databasesPath+'/articleremarks.db';
    // final dataDir=Directory(db1);
    final dataDir = Directory(databasesPath);
    print(dataDir);
    final String onlyDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    final dataDir1 = Directory("storage/emulated/0/Darpan_Mine/Logs");
    try {
      var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final fileName = 'DBShare-$date.zip';
      final fileName1 = 'DeveloperLog-$date.zip';

      final zipFile = File("storage/emulated/0/Darpan_Mine/Exports/$fileName");
      final zipFile1 = File("storage/emulated/0/Darpan_Mine/Exports/$fileName1");
      if (await zipFile.exists()) {
        print("Already exists");
        zipFile.delete();
        print("Deleted");
      }
      if (await zipFile1.exists()) {
        print("Already exists");
        zipFile1.delete();
        print("Deleted");
      }

      print("Creating");
      await zipFile.create();
      await zipFile1.create();
      print("File created");
      await ZipFile.createFromDirectory(
          sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
      await ZipFile.createFromDirectory(
          sourceDir: dataDir1, zipFile: zipFile1, recurseSubDirs: true);
      print("Zip Created");
      final zipFilePath = "storage/emulated/0/Darpan_Mine/Exports/$fileName";
      final zipFilePath1 = "storage/emulated/0/Darpan_Mine/Exports/$fileName1";
      print("File path");
      print(zipFilePath);
    } catch (Exception) {
      await LogCat().writeContent(
          '${DateTimeDetails().currentDateTime()} : $Exception.\n\n');
    }
    serverInit();
  }

  serverInit() async {
    String requestUriPath;
    String requestUriQuery;

    String rootDirPathStr = 'storage/emulated/0/Darpan_Mine/';

    print("rootDirPathStr: " + rootDirPathStr);

    var file = await File('storage/emulated/0/Darpan_Mine/assets/index.html');
    file.writeAsStringSync('');
    //getting the dir

    String text = '''<!DOCTYPE html>
<html>

<head>
    <style>
        /*table, th, tr {*/

        /*  border: 1px solid black;*/

        /*  border-collapse: collapse;*/

        /*}*/

        td {
            font-family: Verdana;
            font-size: 15pt;
            text-align: center;
        }

        p {
            font-size: 15pt;
        }
    </style>
    <title>Darpan Web Browser</title>

</head>

<body>
<div style="width: 100%;margin-top: 30px">
    <div style="float:left;width: 50%;">
        <img style=""src="data:image/jpeg;base64,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">


    </div>
    <div style="margin-top: 30px;margin-bottom: 100px ;float:right;width: 50%">

        <table>
            <tr>
                <td style="text-align:left; padding-right: 10px">Branch Office Name</td>
                <td>:</td>
                <td style="text-align:left; padding-left: 10px">
                    <b>
                        <span >${bpmdata[0].BOName}</span>
                    </b>
                </td>
            </tr>
            <tr>
                <td style="text-align:left; padding-right: 10px">Branch Office ID</td>
                <td>:</td>
                <td style="text-align:left; padding-left: 10px">
                    <b>
                        <span >${bpmdata[0].BOFacilityID}</span>
                    </b>
                </td>
            </tr>
            <tr>
                <td style="text-align:left; padding-right: 10px">BPM Name</td>
                <td>:</td>
                <td style="text-align:left; padding-left: 10px">
                    <b>
                        <span >${bpmdata[0].EmployeeName}</span>
                    </b>
                </td>
            </tr>
            <tr>
                <td style="text-align:left;padding-right: 10px">Employee ID</td>
                <td>:</td>
                <td style="text-align:left; padding-left: 10px">
                    <b>
                        <span >${bpmdata[0].EMPID}</span>
                    </b>
                </td>
            </tr>

        </table>
    </div>


</div>

<div style="margin-bottom: 250px; padding-top: 17%">
    <p>
        <a href="Screenshots/"> Screenshots</a></p>
    <p>
        <a href="Logs/"> Logs</a></p>
    <p>
        <a href="Reports/"> Reports</a></p>
    <p>
        <a href="Exports/" >Exports</a></p>
    <p>
</div>


<footer class="mdl-mega-footer">
    <div class="mdl-mega-footer__middle-section">

        <div class="" style="text-align:center;">
            <b>Department of Posts</b>
            <br>
            <b>Ministry of Communications</b>
            <br> Designed & Developed by Centre For Excellence in Postal Technology ( C.E.P.T )
            <br> Mysuru 570010
            <br>
            <br> Department of Posts<sup>&#169;</sup> 2016-2022.
            <br> All rights reserved.
        </div>

    </div>

    <div class="mdl-mega-footer__bottom-section" hidden>
        <ul class="mdl-mega-footer__link-list">
            <li><a href="https://www.indiapost.gov.in/VAS/Pages/Content/disclaimer.aspx">Disclaimer</a></li>
            <li><a href="https://www.indiapost.gov.in/VAS/Pages/Content/PrivacyPolicy.aspx">Privacy Policy</a></li>
            <li><a href="https://www.indiapost.gov.in/VAS/Pages/Content/Copyright.aspx">Copyright Information</a></li>
            <li><a href="https://www.indiapost.gov.in/VAS/Pages/Content/TermsConditions.aspx">Terms &amp; Conditions</a></li>
        </ul>
    </div>

</footer>

</body>

</html>''';

    await file.writeAsString(text.trim(), mode: FileMode.append);

    server = await HttpServer.bind(host, 8000, shared: true);
    print("Server running on IP : " +
        host! +
        " On Port : " +
        server.port.toString());
    setState(() {
      share.text = host! + ":" + server.port.toString();
    });

    VirtualDirectory rootVirDir = VirtualDirectory(rootDirPathStr)
      ..allowDirectoryListing = true;

    // final dir = Directory(rootDirPathStr+"Logs");
    // final List<FileSystemEntity> entities = await dir.list().toList();
    // print("Entities: $entities");

    // await userFilesVirDir.serve(server);
    await for (request in server) {
      requestUriPath = request.uri.path;
      requestUriQuery = request.uri.query;
      print(
          'requestUriPath: $requestUriPath and requestUriQuery: $requestUriQuery');
      // try {
      //    var req=await rootVirDir.serveRequest(request);
      //    print(req);
      //   //  await rootVirDir.serveFile(File('storage/emulated/0/Postman/indexold.html'),request);
      // }catch(Exception){
      //   print(Exception);
      // }
      if (requestUriPath == '/' && requestUriQuery == '') {
        rootVirDir.serveFile(
            File('storage/emulated/0/Darpan_Mine/assets/index.html'), request);
      } else if (requestUriPath.startsWith('/Logs/')) {
        print('file requested');

        VirtualDirectory userFilesVirDir =
            VirtualDirectory('/storage/emulated/0/Darpan_Mine/')
              ..allowDirectoryListing = true;
        try {
          await userFilesVirDir.serveRequest(request);
        } catch (e) {
          print("error On file requested: $e");
        }
      } else if (requestUriPath.startsWith('/Reports/')) {
        print('file requested db');
        VirtualDirectory userFilesVirDir =
            VirtualDirectory('/storage/emulated/0/Darpan_Mine/')
              ..allowDirectoryListing = true;
        try {
          await userFilesVirDir.serveRequest(request);
        } catch (e) {
          print("error On file requested: $e");
        }
      } else if (requestUriPath.startsWith('/Screenshots/')) {
        print('file requested db');
        VirtualDirectory userFilesVirDir =
            VirtualDirectory('/storage/emulated/0/Darpan_Mine/')
              ..allowDirectoryListing = true;
        try {
          await userFilesVirDir.serveRequest(request);
        } catch (e) {
          print("error On file requested: $e");
        }
      } else if (requestUriPath.startsWith('/Exports/')) {
        final dir = Directory(rootDirPathStr + "Exports");
        final List<FileSystemEntity> entities = await dir.list().toList();
        print(entities);

        print('file requested db');
        VirtualDirectory userFilesVirDir =
            VirtualDirectory('/storage/emulated/0/Darpan_Mine/')
              ..allowDirectoryListing = true;

        try {
          await userFilesVirDir.serveRequest(request);
        } catch (e) {
          print("error On file requested: $e");
        }
      }
    }
  }
}
