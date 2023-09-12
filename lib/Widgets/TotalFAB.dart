import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class TotalFAB extends StatelessWidget {
  final Function() function;
  final String title;

  const TotalFAB({Key? key, required this.function, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: ColorConstants.kPrimaryColor.withOpacity(.9),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          function();
        },
        label: Text(title, style: TextStyle(fontSize: 20)));
  }
}
