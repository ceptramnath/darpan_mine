import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:darpan_mine/Delivery/Screens/CustomAppBar.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Utils/shareFiles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share/share.dart';

import '../LogCat.dart';

class DevelopersLogScreen extends StatefulWidget {
  @override
  _DevelopersLogScreenState createState() => _DevelopersLogScreenState();
}

class _DevelopersLogScreenState extends State<DevelopersLogScreen> {
  String _currentDateTime = "";
  String _onlyDate = "";
  File? logFile;
  String? data;
  bool start = true;
  bool stop = false;
  TextEditingController share = new TextEditingController();
  Connectivity connectivity = Connectivity();
  var server, host;

  void _getTime() {
    final String formattedDateTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now()).toString();
    final String onlyDate =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    setState(() {
      _currentDateTime = formattedDateTime;
      _onlyDate = onlyDate;
      print(_onlyDate);
    });
  }

  Future<String> get _localPath async {
    Directory directory = Directory('storage/emulated/0/Darpan_Mine/Logs');
    print("Path is -" + directory.path.toString());
    return directory.path;
  }

  Future<File> get _localFile async {
    _getTime();
    final path = await _localPath;
    logFile = File('$path/$_onlyDate.txt');
    return File('$path/$_onlyDate.txt');
  }

  Future<String?> readContent() async {
    //String contents1="";
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      String contents1;
      contents1 = contents.split(_onlyDate).reversed.join(_onlyDate);
      return contents1;
    } catch (e) {
      await LogCat().writeContent(
          '${DateTimeDetails().currentDateTime()} : $runtimeType : $e.\n\n');
    }
  }

  @override
  void initState() {
    super.initState();
    readContent().then((String? value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appbarTitle: 'Developer\'s Log',
        ),
        body: data == null || data!.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/ic_happy.png',
                          fit: BoxFit.contain,
                          color: Colors.grey,
                          width: 100,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Cheers! No Errors!',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 15,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, left: 10, right: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data!,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFCC0000),
                          border: Border.all(color: Color(0xFFCC000)),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            topLeft: Radius.circular(40.0),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Share.shareFiles(['${logFile!.path}']);
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.attachment,
                                  color: Colors.white,
                                ),
                                Text(
                                  'SEND',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ShareFilesScreen()));
                            },
                            child: Column(
                              children: [
                                Icon(
                                  MdiIcons.fileSwap,
                                  color: Colors.white,
                                ),
                                Text(
                                  'File Share',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: _showDeleteDialog,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                Text(
                                  'CLEAR',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  _showDeleteDialog() async {
    await Future.delayed(Duration(milliseconds: 1));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return CustomDeveloperLogDeleteDialog(
          //   delete: () {
          //     LogCat().deleteFile();
          //     setState(() {
          //       data = '';
          //     });
          //     Navigator.of(context).pop();
          //   },
          // );

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context),
          );
        });
  }

  contentBox(context) {
    return Stack(
      children: [
        Container(
          padding:
              EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Confirm',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Log File will be Deleted. Do you want to clear log?',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blueGrey)),
                    textColor: Color(0xFFCD853F),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "Cancel",
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // CustomButton(
                  //   buttonFunction: delete,
                  //   buttonText: 'OKAY',
                  // ),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.blueGrey)),
                    textColor: Color(0xFFCD853F),
                    color: Colors.white,
                    onPressed: () {
                      LogCat().deleteFile();
                      setState(() {
                        data = '';
                      });
                      Navigator.of(context).pop();
                    },
                    child: new Text('OKAY'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 40,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  "assets/images/ic_arrows.png",
                )),
          ),
        ),
      ],
    );
  }
}
