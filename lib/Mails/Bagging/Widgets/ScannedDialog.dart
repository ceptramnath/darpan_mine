import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScannedDialog extends StatelessWidget {
  const ScannedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.toDouble()))),
      elevation: 0,
      backgroundColor: ColorConstants.kWhite,
      child: _data(context),
    );
  }

  _data(BuildContext context) => SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.toDouble()),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Image.asset('assets/images/ic_logo.png')),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INDIA POST',
                            style: TextStyle(
                                fontSize: 25.toDouble(),
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.toDouble()),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.toDouble()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DialogText(
                              title: 'Register Letter : ', subtitle: '10'),
                          Space(),
                          DialogText(
                              title: 'Registered Parcel : ', subtitle: '2'),
                          Space(),
                          DialogText(title: 'Speed Post : ', subtitle: '5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Space(),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0.toDouble()),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ColorConstants.kPrimaryAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0.toDouble()),
                              bottomLeft: Radius.circular(10.0.toDouble()))),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 15.0.toDouble()),
                          child: Text(
                            "OKAY",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0.toDouble(),
                                color: ColorConstants.kWhite),
                          ),
                        ),
                        SizedBox(width: 20.0.toDouble()),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      );
}
