import 'package:android_intent/android_intent.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Wallet/WalletScreen.dart';
import 'package:darpan_mine/Utils/DeveloperLogsScreen.dart';
import 'package:darpan_mine/Utils/PopupMenu.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(55);

  final String title;

  const AppAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(
        title,
        // textAlign: TextAlign.center,
        style: TextStyle(letterSpacing: 2, fontSize: 18),
      ),
      backgroundColor: ColorConstants.kPrimaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(right: .5),
              child: IconButton(
                icon: const Icon(Icons.account_balance_wallet),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => WalletScreen())),
              ),
            ),
            ListTileTheme(
              iconColor: Colors.white,
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                      value: 'Get Link',
                      child: GestureDetector(
                        onTap: () async {
                          final AndroidIntent intent = AndroidIntent(
                            action: 'action_application_details_settings',
                            data:
                                'package:dop.indiapost.darpan', // replace com.example.app with your applicationId
                          );
                          await intent.launch();
                        },
                        child: CustomPopUpMenu(
                          popUpImageColor: Colors.green,
                          popUpTitle: 'App Info',
                          popUpImage: 'assets/images/ic_appinfo.png',
                        ),
                      )),
                  // PopupMenuItem<String>(
                  //     value: 'Get Link',
                  //     child: CustomPopUpMenu(
                  //       popUpImageColor: Colors.blueGrey,
                  //       popUpTitle: 'File Share',
                  //       popUpImage: 'assets/images/ic_web_sharing.png',
                  //     )
                  // ),
                  PopupMenuItem<String>(
                      value: 'Get Link',
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DevelopersLogScreen()));
                        },
                        child: CustomPopUpMenu(
                          popUpImageColor: Colors.greenAccent,
                          popUpTitle: 'Developer\'s Log',
                          popUpImage:
                              'assets/images/ic_android_debug_bridge.png',
                        ),
                      )),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
