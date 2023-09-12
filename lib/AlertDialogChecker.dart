import 'dart:async';
import 'dart:convert';

import 'package:darpan_mine/Authentication/APIEndPoints.dart';
import 'package:darpan_mine/Authentication/LoginScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'Authentication/LoginScreen_old.dart';
import 'Authentication/db/registrationdb.dart';
import 'INSURANCE/Utils/utils.dart';
import 'INSURANCE/Widget/Loader.dart';
import 'package:darpan_mine/Authentication/LoginScreen.dart';

class MyAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();
  bool _isNewLoading = false;
  APIEndPoints apiEndPoints = new APIEndPoints();
  //late final loginuri = apiEndPoints.login;
  List<USERLOGINDETAILS> loginDetails = [];
  String access_token = "";
  String refresh_token = "";
  String validity = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialog(
              title: Text("Token Exipred"),
              actions: [
                TextButton(
                  onPressed: () async {
                    every3seconds?.cancel();
                    setState(() {
                      _isNewLoading = true;
                    });
                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Enter UserID/Password."),
                      ));
                    else if (!validatePassword(passwordController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Invalid Password"),
                      ));
                    }

                    final loginDetails = await USERLOGINDETAILS()
                        .select()
                        .EMPID
                        .contains(usernameController.text)
                        .toList();

                    if (loginDetails.length > 0 &&
                        loginDetails[0].AccessToken.toString() != null) {
                      if (loginDetails[0].Password != passwordController.text) {
                        UtilFs.showToast("User Credentials is wrong", context);
                      } else {
                        print(
                            'User details with Access token is available in local db.');

                        bool value = false;
                        bool netresult =
                            await InternetConnectionChecker().hasConnection;
                        if (netresult) {
                          // value = await ls.LoginAPI(loginuri,
                          //     usernameController.text, passwordController.text);
                          //getting the token using refresh token 26072023.
                          var ret= ls.Token_RefreshToken();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Internet connection is not available..!"),
                          ));
                        }
                      }
                    }

                    setState(() {
                      _isNewLoading = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Fetch Token"),
                )
              ],
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      child: TextFormField(
                        controller: usernameController,
                        style: TextStyle(color: Colors.amberAccent),
                        keyboardType: TextInputType.number,
                        // maxLength: 10,
                        // maxLengthEnforced: true,
                        // readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Employee ID / Username",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 3)),
                          contentPadding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 20, right: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * .75,
                      child: TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: passwordController,
                        style: TextStyle(color: Colors.amberAccent),
                        keyboardType: TextInputType.visiblePassword,
                        // maxLength: 10,
                        // maxLengthEnforced: true,
                        // readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 2, 40, 86),
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blueGrey, width: 3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 3)),
                          contentPadding: EdgeInsets.only(
                              top: 20, bottom: 20, left: 20, right: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _isNewLoading == true
            ? Loader(isCustom: true, loadingTxt: 'Please Wait...Loading...')
            : Container()
      ],
    );
  }

  /*
  Future<bool> LoginAPI(
      String loginuri, String username, String password) async {
    bool rtValue = false;
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(loginuri));
    request.body =
        json.encode({"username": "$username", "password": "$password"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseContent = await response.stream.bytesToString();
      print(responseContent);
      access_token = jsonDecode(responseContent)["access_token"];
      refresh_token = jsonDecode(responseContent)["refresh_token"];

      //Storing Access token in local DB.
      if (access_token.isNotEmpty || access_token != null) {
        await USERLOGINDETAILS().select().delete();
        var validityTimer = jsonDecode(responseContent)['expires_in'];
        final logindetails = USERLOGINDETAILS()
          ..EMPID = username
          ..AccessToken = access_token
          ..Validity =
              DateTime.now().add(Duration(seconds: validityTimer)).toString()
          ..Password = password;
        logindetails.save();

        loginDetails = await USERLOGINDETAILS().select().toList();

        int validtimer = DateTime.parse(loginDetails[0].Validity!)
            .difference(DateTime.now())
            .inSeconds;
        print("Timer validity: $validtimer");

        every3seconds =
            Stream<int>.periodic(Duration(seconds: validtimer), (t) => t)
                .listen((t) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext dialogContext) {
              return WillPopScope(
                onWillPop: () async => false,
                child: MyAlertDialog(
                  title: 'Title $t',
                  content: 'Dialog content',
                ),
              );
            },
          );
        });
      }
      /*
      String validityTime = jsonDecode(responseContent)["expires_in"].toString();
      DateTime now = DateTime.now();
      validity = DateFormat('yyyy-MM-dd – kk:mm').format(now) + validity;

       */
      String error = " ";
      try {
        error = jsonDecode(responseContent)["error"];
      } catch (e) {
        print("Error DKSjf");
        print(e);
      }

      print("Response is - " + responseContent);
      print(access_token);
      print(error);

      if (error == "invalid_grant")
        rtValue = false;
      else if (access_token.isNotEmpty) rtValue = true;
    } else {
      print(response.reasonPhrase);
      rtValue = false;
    }

    return rtValue;
  }


   */
  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
