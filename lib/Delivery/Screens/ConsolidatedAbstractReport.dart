import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/DottedLine.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DeliveryScreen.dart';
import 'ReportDetailsScreen.dart';
import 'db/DarpanDBModel.dart';

class ConsolidatedAbstractScreen extends StatefulWidget {
  @override
  _ConsolidatedAbstractScreenState createState() => _ConsolidatedAbstractScreenState();
}

class _ConsolidatedAbstractScreenState extends State<ConsolidatedAbstractScreen> {
  List<Delivery> _articlesToDisplay = [];
  List<Delivery> _previousarticlesToDisplay = [];
  Future? getDetails;
  bool visible = false;
  int _selectedIndex = 0;
  List<Addres> _address = [];
  List<Addres> _addressToDisplay = [];
  var prevDayCount = 0;
  var recdTodayCount = 0;
  var issueToPostmanCount = 0;
  var notissueToPostmanCount = 0;
  var deliveredCount = 0;
  var redirectCount = 0;
  var rtsCount = 0;
  var depositCount = 0;
  var pendingCount = 0;

  List totalArticlesList = [];
  List speedArticlesList = [];
  List rlArticlesList = [];
  List parcelArticlesList = [];
  List emoArticlesList = [];



  List totalDelArticlesList = [];
  List speedDelArticlesList = [];
  List rlDelArticlesList = [];
  List parcelDelArticlesList = [];
  List emoDelArticlesList = [];



  List totalUnDelArticlesList = [];
  List speedUnDelArticlesList = [];
  List rlUnDelArticlesList = [];
  List parcelUnDelArticlesList = [];
  List emoUnDelArticlesList = [];

  List totalPendingArticlesList = [];
  List speedPendingArticlesList = [];
  List rlPendingArticlesList = [];
  List parcelPendingArticlesList = [];
  List emoPendingArticlesList = [];

  List prevDayList = [];
  List recdTodayList = [];
  List issueToPostmanList = [];
  List notissueToPostmanList = [];
  List deliveredList = [];
  List redirectedList = [];
  List rtsList = [];
  List depositList = [];
  List pendingList = [];
  List deliveryLetter =[];

  int totalarticles=0;
  int rlArticles=0;
  int speedArticles=0;
  int parcelArticles=0;
  int emoArticles=0;


  int totalDelarticles=0;
  int rlDelArticles=0;
  int speedDelArticles=0;
  int parcelDelArticles=0;
  int emoDelArticles=0;

  int totalUnDelarticles=0;
  int rlUnDelArticles=0;
  int speedUnDelArticles=0;
  int parcelUnDelArticles=0;
  int emoUnDelArticles=0;

  int totalDepositarticles=0;
  int rlDepositArticles=0;
  int speedDepositArticles=0;
  int parcelDepositArticles=0;
  int emoDepositArticles=0;

  int totalPendingarticles=0;
  int rlPendingArticles=0;
  int speedPendingArticles=0;
  int parcelPendingArticles=0;
  int emoPendingArticles=0;



  @override
  void initState() {
    getDetails = db();
    super.initState();
  }

  db() async {
    prevDayCount = 0;
    recdTodayCount = 0;
    issueToPostmanCount = 0;
    notissueToPostmanCount = 0;
    deliveredCount = 0;
    redirectCount = 0;
    rtsCount = 0;
    depositCount = 0;
    pendingCount = 0;

    String type ="";


    print("Fetching Delivery Report..!");


    final fetch = await Delivery()
        .select()
        .invoiceDate
        .equals(DateTimeDetails().currentDate()).toList();
    print(fetch.length);

    if(fetch.length>0)
      {


        for(int i =0; i<fetch.length;i++){
           type = fetch[i].MATNR.toString();
           totalarticles=totalarticles+1;
           //1. Letter
           if (type =="LETTER"||type == "VPL" ||type =="INTL_APP_EPACKET"
               ||type == "AEROGRAMME_INTL"||type =="BL"||type =="BMS"
               ||type =="BP"||type =="FGN_BL"||type =="FGN_BULKBAG"||type =="FGN_LETTER"
               ||type =="FGN_PRINTEDPAPERS"||type =="FGN_SMALLPACKETS"||type =="LETTER_CARD_S"
               ||type =="MP_AEROGRAMME"||type =="MP_ENVELOPE"||type =="MP_ILC"||type =="MP_MEGHDOOT_PC"
               ||type =="MP_PASSBOOK"||type =="MP_PC"||type =="NBMS"||type =="PB"||type =="PERIODICAL"
               ||type =="P_SP"||type =="R_NP")
             {
               rlArticles=rlArticles+1;
               rlArticlesList.add(fetch[i].ART_NUMBER);
                if(fetch[i].ART_STATUS=="D"||fetch[i].ART_STATUS=="DELIVERY"||fetch[i].ART_STATUS=="Delivery")
                  {
                    totalDelarticles=totalDelarticles+1;
                    rlDelArticles=rlDelArticles+1;
                    rlDelArticlesList.add(fetch[i].ART_NUMBER);
                  }
                else if (fetch[i].ART_STATUS=="N"||fetch[i].ART_STATUS=="O")
                  {
                    totalUnDelarticles=totalUnDelarticles+1;
                    rlUnDelArticles=rlUnDelArticles+1;
                    rlUnDelArticlesList.add(fetch[i].ART_NUMBER);
                  }
                else if (fetch[i].ART_STATUS=="NULL"||fetch[i].ART_STATUS==null)
                  {
                    totalPendingarticles=totalPendingarticles+1;
                    rlPendingArticles=rlPendingArticles+1;
                    rlPendingArticlesList.add(fetch[i].ART_NUMBER);
                  }

             }
           //2. Parcel
           else if (type =="PARCEL"|| type =="VPP"|| type =="COD"|| type == "BP"
               || type =="BUSINESS_PARCEL"|| type =="EXPRESS_ONP"|| type =="FGN_AIR_PARCEL"
               || type =="FGN_SAL_PARCEL"|| type =="EXPRESS_PARCEL")
           {
             parcelArticles=parcelArticles+1;
             parcelArticlesList.add(fetch[i].ART_NUMBER);
             if(fetch[i].ART_STATUS=="D"||fetch[i].ART_STATUS=="DELIVERY"||fetch[i].ART_STATUS=="Delivery")
             {
               totalDelarticles=totalDelarticles+1;
               parcelDelArticles=parcelDelArticles+1;
               parcelDelArticlesList.add(fetch[i].ART_NUMBER);
             }
             else if (fetch[i].ART_STATUS=="N"||fetch[i].ART_STATUS=="O")
             {
               totalUnDelarticles=totalUnDelarticles+1;
               parcelUnDelArticles=parcelUnDelArticles+1;
               parcelUnDelArticlesList.add(fetch[i].ART_NUMBER);
             }
             else if (fetch[i].ART_STATUS=="NULL"||fetch[i].ART_STATUS==null)
             {
               totalPendingarticles=totalPendingarticles+1;
               parcelPendingArticles=parcelPendingArticles+1;
               parcelPendingArticlesList.add(fetch[i].ART_NUMBER);
             }

           }
           //3. Speed
           else if (type=="SPEED"|| type=="BRSP"|| type=="FGN_SP_DOCUMENT"|| type=="FGN_SP_MERCHANDISE"
               || type=="SP_INLAND"|| type=="SP_INLAND_PARCEL"|| type=="SPEEDPOST"|| type=="SPEED"|| type=="SP")
             {
               speedArticles=speedArticles+1;
               speedArticlesList.add(fetch[i].ART_NUMBER);
               if(fetch[i].ART_STATUS=="D"||fetch[i].ART_STATUS=="DELIVERY"||fetch[i].ART_STATUS=="Delivery")
               {
                 totalDelarticles=totalDelarticles+1;
                 speedDelArticles=speedDelArticles+1;
                 speedDelArticlesList.add(fetch[i].ART_NUMBER);
               }
               else if (fetch[i].ART_STATUS=="N"||fetch[i].ART_STATUS=="O")
               {
                 totalUnDelarticles=totalUnDelarticles+1;
                 speedUnDelArticles=speedUnDelArticles+1;
                 speedUnDelArticlesList.add(fetch[i].ART_NUMBER);
               }
               else if (fetch[i].ART_STATUS=="NULL"||fetch[i].ART_STATUS==null)
               {
                 totalPendingarticles=totalPendingarticles+1;
                 speedPendingArticles=speedPendingArticles+1;
                 speedPendingArticlesList.add(fetch[i].ART_NUMBER);
               }
             }
           else if(type=="EMO"||type =="MO"){
             emoArticles=emoArticles+1;
             emoArticlesList.add(fetch[i].ART_NUMBER);
             if(fetch[i].ART_STATUS=="F"||fetch[i].ART_STATUS=="DELIVERY"||fetch[i].ART_STATUS=="Delivery")
             {
               totalDelarticles=totalDelarticles+1;
               emoDelArticles=emoDelArticles+1;
               emoDelArticlesList.add(fetch[i].ART_NUMBER);
             }
             else if (fetch[i].ART_STATUS=="G"||fetch[i].ART_STATUS=="O")
             {
               totalUnDelarticles=totalUnDelarticles+1;
               emoUnDelArticles=emoUnDelArticles+1;
               emoUnDelArticlesList.add(fetch[i].ART_NUMBER);
             }
             else if (fetch[i].ART_STATUS=="NULL"||fetch[i].ART_STATUS==null)
             {
               totalPendingarticles=totalPendingarticles+1;
               emoPendingArticles=emoPendingArticles+1;
               emoPendingArticlesList.add(fetch[i].ART_NUMBER);
             }


           }

        }
        setState(() {
          visible=true;
        });

      }
    return fetch;
  }

  final key = new GlobalKey<ScaffoldState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text("Delivery Abstract Report"),
          backgroundColor: ColorConstants.kPrimaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DeliveryScreen()),
                    (route) => false),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            bool? result = await _onBackPressed();
            result ??= false;
            return result;
          },
          child: FutureBuilder(
                      future: getDetails,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.mark_email_unread_outlined,
                                  size: 50.toDouble(),
                                  color: ColorConstants.kTextColor,
                                ),
                                Text(
                                    'No Records found for \nthe Date : ${DateTimeDetails().currentDate()}',

                                  style: TextStyle(
                                      letterSpacing: 2,
                                      color: ColorConstants.kTextColor),
                                ),
                              ],
                            ),
                          );
                        }
                        else {
                          return SafeArea(
                            child: visible == true
                                ? SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5.0),
                                      child: DialogText(
                                          title: 'Date of Transaction : ',
                                          subtitle: DateTimeDetails().currentDate()),
                                    ),
                                    const DottedLine(),
                                    const Space(),
                                    totalarticles == 0 ? Container(): ExpansionTile(
                                title:  expansionTitleValue(
                                    'Total Articles Invoiced', totalarticles),
                                children: [
                                  rlArticlesList.isNotEmpty
                                ? deliveryExpansionTile(
                                'Register Letter',
                                      rlArticles,
                                      rlArticlesList)
                                  : Container(),

                                  speedArticlesList.isNotEmpty
                                      ? deliveryExpansionTile(
                                      'Speed Letter',
                                      speedArticles,
                                      speedArticlesList)
                                      : Container(),

                                  parcelArticlesList.isNotEmpty
                                      ? deliveryExpansionTile(
                                      'Parcel',
                                      parcelArticles,
                                      parcelArticlesList)
                                      : Container(),

                                  emoArticlesList.isNotEmpty
                                      ? deliveryExpansionTile(
                                      'eMO',
                                      emoArticles,
                                      emoArticlesList)
                                      : Container(),

                                ],
                              ),
                                    const DottedLine(),
                                    const Space(),
                                    totalDelarticles == 0? Container(): ExpansionTile(
                                      title:  expansionTitleValue(
                                          'Total Articles Delivered', totalDelarticles),
                                      children: [
                                        rlDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Register Letter',
                                            rlDelArticles,
                                            rlDelArticlesList)
                                            : Container(),

                                        speedDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Speed Letter',
                                            speedDelArticles,
                                            speedDelArticlesList)
                                            : Container(),

                                        parcelDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Parcel',
                                            parcelDelArticles,
                                            parcelDelArticlesList)
                                            : Container(),

                                        emoDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'eMO',
                                            emoDelArticles,
                                            emoDelArticlesList)
                                            : Container(),


                                      ],
                                    ),
                                    const DottedLine(),
                                    const Space(),
                                    totalUnDelarticles == 0? Container(): ExpansionTile(
                                      title:  expansionTitleValue(
                                          'Total Articles Un-Delivered', totalUnDelarticles),
                                      children: [
                                        rlUnDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Register Letter',
                                            rlUnDelArticles,
                                            rlUnDelArticlesList)
                                            : Container(),

                                        speedUnDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Speed Letter',
                                            speedUnDelArticles,
                                            speedUnDelArticlesList)
                                            : Container(),

                                        parcelUnDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Parcel',
                                            parcelUnDelArticles,
                                            parcelUnDelArticlesList)
                                            : Container(),

                                        emoUnDelArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'eMO',
                                            emoUnDelArticles,
                                            emoUnDelArticlesList)
                                            : Container(),
                                      ],
                                    ),
                                    const DottedLine(),
                                    const Space(),
                                    totalPendingarticles ==0? Container(): ExpansionTile(
                                      title:  expansionTitleValue(
                                          'Total Articles Pending', totalPendingarticles),
                                      children: [
                                        rlPendingArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Register Letter',
                                            rlPendingArticles,
                                            rlPendingArticlesList)
                                            : Container(),

                                        speedPendingArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Speed Letter',
                                            speedPendingArticles,
                                            speedPendingArticlesList)
                                            : Container(),

                                        parcelPendingArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'Parcel',
                                            parcelPendingArticles,
                                            parcelPendingArticlesList)
                                            : Container(),

                                        emoPendingArticlesList.isNotEmpty
                                            ? deliveryExpansionTile(
                                            'eMO',
                                            emoPendingArticles,
                                            emoPendingArticlesList)
                                            : Container(),

                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            )
                                : Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .mark_email_unread_outlined,
                                    size: 50.toDouble(),
                                    color: ColorConstants
                                        .kTextColor,
                                  ),
                                   Text(
                                       'No Records found for \nthe Date : ${DateTimeDetails().currentDate()}',
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: ColorConstants
                                            .kTextColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),

        )
    );
  }


  Widget nextSpace(String title) {
    return Column(
      children: [
        const Space(),
        const DottedLine(),
        const DoubleSpace(),
        const DottedLine(),
        const Space(),
        Text(
          title,
          style: headingStyle(),
        ),
        SizedBox(width: 150, child: const Divider()),
      ],
    );
  }
  Widget slipTitleDescription(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(
                title,
                style: titleStyle(),
              )),
          const Text(' : '),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Text(
                value,
                style: subTitleStyle(),
              )),
        ],
      ),
    );
  }

  Widget expansionTitleValue(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: Text(
              title,
              style: titleStyle(),
            )),
        const Text(' : '),
        SizedBox(
          width: 10,
        ),
        Expanded(
            flex: 2,
            child: Text(
               value.toString(),
              style: subTitleStyle(),
            ))
      ],
    );
  }
  textStyle() {
    return TextStyle(
        letterSpacing: 1, fontSize: 13, color: ColorConstants.kTextColor);
  }

  titleStyle() {
    return TextStyle(
        letterSpacing: 1, fontSize: 13, color: ColorConstants.kTextDark);
  }

  subTitleStyle() {
    return TextStyle(
        fontSize: 13,
        letterSpacing: 1,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kTextDark);
  }

  headingStyle() {
    return TextStyle(
        letterSpacing: 1,
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: ColorConstants.kSecondaryColor);
  }


  Widget deliveryExpansionTile(
      String title, int totalCount, List deliveryLetter) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: ExpansionTile(
        title: expansionTitleValue(title, totalCount),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: deliveryLetter
                        .map((e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        e,
                        style: textStyle(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ))
                        .toList(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: deliveryLetter
                      .map((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      ':',
                      style: textStyle(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0),
                  child: SizedBox(
                    width: 10,
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DeliveryScreen()),
            (route) => false);
  }

  customSnackBar() {
    return key.currentState!.showSnackBar(new SnackBar(
      content: new Text("No Articles has been added"),
    ));
  }



  navigation(String title, List articles) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReportDetailsScreen(title, articles)));
  }
}
