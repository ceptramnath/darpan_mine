import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button1 extends StatelessWidget {
  final String buttonText;
  final Function() buttonFunction;

  Button1({required this.buttonText, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0.toDouble()),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorConstants.kWhite),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.toDouble()),
                    side: BorderSide(color: ColorConstants.kSecondaryColor)))),
        onPressed: buttonFunction,
        child: Padding(
          padding: EdgeInsets.all(2.0.toDouble()),
          child: new Text(
            buttonText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: ColorConstants.kAmberAccentColor),
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final String buttonText;
  final Function() buttonFunction;

  ConfirmButton({required this.buttonText, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.toDouble()),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(ColorConstants.kWhite),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.toDouble()),
                    side: BorderSide(color: ColorConstants.kSecondaryColor)))),
        onPressed: buttonFunction,
        child: Padding(
          padding: EdgeInsets.all(8.0.toDouble()),
          child: new Text(
            buttonText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: ColorConstants.kAmberAccentColor, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
