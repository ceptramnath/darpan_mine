import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/CustomToast.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TotalToast extends StatelessWidget {
  final String totalAmount;

  const TotalToast({Key? key, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToastDecorator(
        backgroundColor: ColorConstants.kGrassGreen,
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2)),
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MdiIcons.currencyInr,
                      size: 30,
                      color: ColorConstants.kWhite,
                    ),
                    Text(
                      totalAmount,
                      style: TextStyle(
                          color: Colors.white, fontSize: 20.toDouble()),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                title: Text('Amount to be collected',
                    style: TextStyle(
                        color: ColorConstants.kWhite, letterSpacing: 2)),
              ),
            ),
          ],
        ));
  }
}
