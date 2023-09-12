import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Wallet/Cash/CashDetailsScreen.dart';
import 'package:darpan_mine/Mails/Wallet/Transaction/TransactionsScreen.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'Cash/CashService.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletAmount=0;
  var currentDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  /// Fetching the wallet amount from the DB
  Future getBalance() async {
    walletAmount = await CashService().cashBalance();
    return walletAmount.toStringAsFixed(2);
  }

  String ofcID = " ";
  String ofcName = " ";
  String empID = " ";
  String empName = " ";
  // String appName = packageInfo.appName;
  // String packageName = packageInfo.packageName;
  String version ="1.0.0";
  // String buildNumber = packageInfo.buildNumber;

  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  getData() async {
    final userDetails = await OFCMASTERDATA().select().toList();
    ofcID = userDetails[0].BOFacilityID.toString();
    ofcName = userDetails[0].BOName.toString();
    empID = userDetails[0].EMPID.toString();
    empName = userDetails[0].EmployeeName.toString();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      version = packageInfo.version;
    });
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;


  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = formatter.format(currentDate);
    return Scaffold(
        backgroundColor: ColorConstants.kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                    flex: 2, child: Image.asset('assets/images/ic_logo.png')),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(
                        'D A R P A N',
                        style: TextStyle(
                            letterSpacing: 2, fontWeight: FontWeight.w500),
                      ),
                      Text('Version : $version',
                          style: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.w500))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder(
          future: getBalance(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            else {
              return Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: ColorConstants.kPrimaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          walletText('Branch Office ', '$ofcName\n($ofcID)'),
                          walletText('User Name ', '$empName ($empID)'),
                          walletText('Business Date ', formattedDate),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: ColorConstants.kWhite,
                              border: Border.all(
                                  color: ColorConstants.kPrimaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45))),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            // padding: EdgeInsets.only(left:5.0,top:15.0,bottom: 15.0,right:15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width:MediaQuery.of(context).size.width*.36,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.kPrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomLeft: Radius.circular(25))),
                                    child: Padding(
                                      padding: EdgeInsets.all(18.0),
                                      child: Text(
                                        'Wallet \nAmount',
                                        style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: MediaQuery.of(context).size.width*.038,
                                            fontWeight: FontWeight.w500,
                                            color: ColorConstants.kWhite),
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    '\u{20B9} ${walletAmount.toStringAsFixed(2)}',

                                    style: TextStyle(
                                        letterSpacing: 2,
                                        fontSize:  MediaQuery.of(context).size.width*.038,
                                        fontWeight: FontWeight.w500,
                                        color: ColorConstants.kPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const DoubleSpace(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CashDetailsScreen())),
                          child: const ListTile(
                            leading: CircleAvatar(
                              child:
                                  Icon(Icons.account_balance_wallet_outlined),
                            ),
                            title: Text(
                              'Cash Details',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                        ),
                        const Divider(),
                        const Space(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      const TransactionDetailsScreen())),
                          child: const ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.receipt),
                            ),
                            title: Text(
                              'All Transactions',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }

  walletText(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              )),
          SizedBox(
            width: 20,
            child: Text(
              ":",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
              flex: 2,
              child: Text(
                description,
                style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ),
    );
  }
}
