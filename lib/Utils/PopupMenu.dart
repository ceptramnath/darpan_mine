import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

class CustomPopUpMenu extends StatelessWidget {
  String? popUpTitle;
  String? popUpImage;
  Color? popUpImageColor;

  CustomPopUpMenu({this.popUpTitle, this.popUpImage, this.popUpImageColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
          title: Text(popUpTitle!),
          leading: Image.asset(
            popUpImage!,
            fit: BoxFit.contain,
            height: 30,
            color: popUpImageColor,
          ),
        ));
  }
}
