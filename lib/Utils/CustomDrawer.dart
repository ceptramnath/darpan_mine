import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashService.dart';
import 'package:darpan_mine/Utils/SettingsScreen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

import 'CustomDrawerListTile.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String greetingMessage = '';
  String? ofcID, ofcName, empID, empName, max, min,schedule,pincode;

  @override
  void initState() {
    greetings();
    super.initState();
  }

  greetings() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    ofcID = userDetails[0].BOFacilityID.toString();
    ofcName = userDetails[0].BOName.toString();
    empID = userDetails[0].EMPID.toString();
    empName = userDetails[0].EmployeeName.toString();
    max = userDetails[0].MAXBAL.toString();
    min = userDetails[0].MINBAL.toString();
    schedule = userDetails[0].MAILSCHEDULE.toString();
    pincode =  userDetails[0].MAILSCHEDULE.toString();
    var hour = DateTime.now().hour;
    print(hour.toString());
    if (hour < 12) {
      setState(() {
        greetingMessage = 'Good Morning';
      });
    } else if ((hour >= 12) && (hour <= 16)) {
      greetingMessage = 'Good Afternoon';
    } else {
      greetingMessage = 'Good Evening';
    }
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: FutureBuilder(
        future: greetings(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          else {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    // height: 300.h,
                    height: 310,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xFFCC0000)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/images/ic_arrows.png',
                                fit: BoxFit.contain,
                                width: 50,
                                // height: 70,
                              ),
                              Column(
                                children: [

                                  Text(
                                    "Department of Posts",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Ministry of Communications",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Government of India",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                 ],
                              ),
                              Image.asset(
                                'assets/images/ic_emblem.png',
                                color: Colors.white,
                                fit: BoxFit.contain,
                                width: 30,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greetingMessage,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "$empName - ($empID)",
                                    style: TextStyle(color: Colors.white),
                                  ),

                                  Text(
                                    "$ofcName - ($ofcID)",
                                    style: TextStyle(color: Colors.white),
                                  ),

                                  SizedBox(height: 5,),
                                  Text(
                                    "Max Balance - \u{20B9} $max",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Min Balance - \u{20B9} $min",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    "Mail Schedule - $schedule Hrs.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text("General"),
                  ),
                  // CustomDrawerListTile(listTileIcon: Icons.home, listTileTitle: 'Home', listTileNavFunction: () =>Navigator.pop(context)),
                  CustomDrawerListTile(
                      listTileIcon: Icons.approval,
                      listTileTitle: 'Settings',
                      listTileNavFunction: () => SettingsScreen()),
                ],
              ),
            );
          }
        },
      ),
    );






  }
}
