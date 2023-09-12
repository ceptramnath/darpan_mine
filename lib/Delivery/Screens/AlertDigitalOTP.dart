import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertDigitalOTP extends StatefulWidget {
  @override
  AlertDigitalOTPState createState() => AlertDigitalOTPState();
}

class AlertDigitalOTPState extends State<AlertDigitalOTP> {
  TextEditingController digitalToken = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showDialogBox(BuildContext context, String digitalOTP) {
    // flutter defined function
    print("Reached showDialog");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
          elevation: 0,
          backgroundColor: ColorConstants.kWhite,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: digitalToken..text = digitalOTP,
                    style: TextStyle(color: Colors.blueGrey),
                    decoration: InputDecoration(
                      labelText: "Digital OTP",
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
                TextButton(
                    child: Text("Enable Access"),
                    onPressed: () async {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFFCC0000),
                      primary: Colors.white,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

AlertDigitalOTPState ado = AlertDigitalOTPState();
