import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHintPosition extends StatelessWidget {
  String? hintText;

  CustomHintPosition({this.hintText});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 10,
      bottom: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            color: Colors.white,
            child: Text(
              ' $hintText ',
              style: TextStyle(color: Color(0xFFd4af37)),
            )),
      ),
    );
  }
}
