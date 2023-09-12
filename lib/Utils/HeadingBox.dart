import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

class HeadingBox extends StatelessWidget {
  String headingTitle;

  HeadingBox({required this.headingTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, right: 20, left: 20),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8),
              child: Text(
                headingTitle,
                style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 1.0,
                  width: 170.0,
                  color: Colors.black12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
