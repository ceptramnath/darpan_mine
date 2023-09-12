import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  Function() buttonFunction;

  CustomButton({required this.buttonText, required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.blueGrey)),
      textColor: Color(0xFFCD853F),
      color: Colors.white,
      onPressed: buttonFunction,
      child: new Text(
        buttonText,
      ),
    );
  }
}
