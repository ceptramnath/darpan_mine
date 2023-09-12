import 'package:darpan_mine/Delivery/Screens/Styles/NeuromorphicBox.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EMOCard extends StatelessWidget {
  String? articleNumber;
  String? articleType;
  int sourcepin;
  String? destpin;
  double amounttocollect;

  EMOCard(this.articleNumber, this.articleType, this.sourcepin, this.destpin,
      this.amounttocollect);

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
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: Icon(
                //         Icons.person_outline,
                //         color: Colors.blueGrey,
                //         size: 25.h,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 20.w,
                //     ),
                //     Expanded(
                //       flex: 10,
                //       child: Text(
                //         addresseeName,
                //         style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 17.sp),
                //       ),
                //     ),
                //   ],
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "From: ${sourcepin.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(child: Icon(Icons.flight_takeoff)),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                          "To: ${destpin.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     FlatButton.icon(
                //         onPressed: cardNavigation,
                //         icon: Icon(
                //           Icons.remove_red_eye,
                //           color: Colors.blueGrey,
                //         ),
                //         label: Text(
                //           'View',
                //           style: TextStyle(color: Colors.blueGrey),
                //         )),
                //     FlatButton(
                //       onPressed: isListArticle ? null : () {
                //         Toast.show('This is a List Article', context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                //       },
                //       child: Icon(
                //         isListArticleIcon,
                //         color: Colors.blueGrey,
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text("Amount to Deliver"),
                            Text(amounttocollect.toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
