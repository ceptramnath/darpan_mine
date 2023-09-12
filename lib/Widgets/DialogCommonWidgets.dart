import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DottedLine.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0.toDouble()),
          child: Row(
            children: [
              Expanded(
                  flex: 2, child: Image.asset('assets/images/ic_logo.png')),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INDIA POST',
                      style: TextStyle(
                          fontSize: 25,
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
        DottedLine(),
        SizedBox(
          height: 20.toDouble(),
        )
      ],
    );
  }
}
