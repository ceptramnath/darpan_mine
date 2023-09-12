import 'package:darpan_mine/Delivery/Screens/Styles/NeuromorphicBox.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BulkDeliveryCard extends StatelessWidget {
  String? articleNumber;
  String? articleType;

  BulkDeliveryCard(this.articleNumber, this.articleType);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Container(
        decoration: nCDBox,
        child: Container(
          decoration: nCIBox,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 15, bottom: 10, top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Icon(
                            MdiIcons.barcodeScan,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                              child: Container(
                                  child: Text(
                            articleNumber!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black54),
                          ))),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Article Type',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        Text(
                          articleType!,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
