import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DottedLine.dart';
import 'UITools.dart';

class DialogHeader1 extends StatelessWidget {
  const DialogHeader1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //DottedLine(),
        SmallSpace(),
        Padding(
          padding: EdgeInsets.all(0.0.toDouble()),
          child: Row(
            children: [
              Expanded(
                  flex: 2, child: Image.asset('assets/images/ic_logo.png')),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INDIA POST',
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w500),
                    ),
                    Text('Ministry Of Communication')
                  ],
                ),
              )
            ],
          ),
        ),
        SmallSpace(),
        //DottedLine(),
        // SizedBox(
        //   height: 20.toDouble(),
        //)
      ],
    );
  }
}
