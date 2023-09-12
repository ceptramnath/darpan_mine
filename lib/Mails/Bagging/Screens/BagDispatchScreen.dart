import 'package:darpan_mine/Authentication/db/registrationdb.dart';
import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Delivery/Screens/db/DarpanDBModel.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';
import 'package:darpan_mine/Utils/Printing.dart';
import 'package:darpan_mine/Widgets/Button.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagDispatchScreen extends StatefulWidget {
  const BagDispatchScreen({Key? key}) : super(key: key);

  @override
  _BagDispatchScreenState createState() => _BagDispatchScreenState();
}

class _BagDispatchScreenState extends State<BagDispatchScreen> {
  List closedBags = [];
  String? _chosenValue;
  bool ctfy = false;
  String? despatchSchedule;
  bool maillist = false;
  List<String> basicInformation = <String>[];
  List<String> secondReceipt = <String>[];
  Future? fetchInfo;

  @override
  void initState() {
    fetchInfo = getSchedule();
    // getBagDetails();
    super.initState();
  }

  getSchedule() async {
    print('Getting Schedule..!');
    final schedule = await OFCMASTERDATA().select().toList();
    despatchSchedule = schedule[0].MAILSCHEDULE.toString();
    print('Fetched Schedule is - ' + despatchSchedule.toString());
    closedBags =
        await BagCloseTable().select().Status.equals('Closed').toMapList();
    print(closedBags.length);
    print(closedBags);
    setState(() {
      maillist=true;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstants.kPrimaryColor,
        title: const Text(
          'Bag Despatch',
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: FutureBuilder(
          future: fetchInfo,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: DropdownButton<String>(
                            underline: const SizedBox(),
                            focusColor: Colors.white,
                            value: _chosenValue,
                            style: const TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items:
                                // despatchSchedule.map((String value) {
                                //   print('inside DropDown');
                                //   print(value);
                                <String>[
                              despatchSchedule!
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                            hint: const Text(
                              "Select Schedule Time",
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                ctfy = true;
                                _chosenValue = value;
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  Visibility(
                      visible: ctfy,

                      child: Row(
                        children: [
                          SizedBox(width: 20,),
                          Text(
                            'Bag Number',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 12),
                          ),
                          SizedBox(width: 35,),
                          Text('# Articles',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 12),),
                          SizedBox(width: 45,),
                          Text('Cash',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.blueGrey, fontSize: 12),)
                        ],
                      ),),
                  Visibility(
                      visible: ctfy,
                      child: closedBags.isEmpty
                          ? Column(
                        children: [
                          Icon(Icons.mark_email_unread_outlined,
                              size: 50.toDouble(),
                              color: ColorConstants.kTextColor),
                          const Text(
                            'No Records found',
                            style: TextStyle(
                                letterSpacing: 2,
                                color: ColorConstants.kTextColor),
                          ),
                        ],
                      )
                          : Flexible(
                          child: ListView.builder(
                              physics:
                              const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: closedBags.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Text(
                                            closedBags[index]
                                            ["BagNumber"],
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                color:
                                                Colors.blue[300],
                                                fontWeight:
                                                FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            closedBags[index][
                                            'TotalArticlesCount'],
                                            style: TextStyle(
                                                letterSpacing: 1,
                                                color:
                                                Colors.blue[300],
                                                fontWeight:
                                                FontWeight.w500),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                              closedBags[index]
                                              ['CashCount'].toString().isEmpty||closedBags[index]
                                              ['CashCount'].toString()==""?"--":closedBags[index]
                                              ['CashCount'].toString(),
                                              style: TextStyle(
                                                  letterSpacing: 1,
                                                  color: Colors
                                                      .blue[300],
                                                  fontWeight:
                                                  FontWeight
                                                      .w500))),
                                      Expanded(
                                          flex: 1,
                                          child: Checkbox(
                                            shape:
                                            RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(15),
                                            ),
                                            onChanged:
                                                (bool? value) {},
                                            value: true,
                                          ))
                                    ],
                                  ),
                                );
                              }


                          ))),


                  const Divider(),
                  const SmallSpace(),
                  Visibility(
                    visible: ctfy,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          buttonText: "Dispatch",
                          buttonFunction: ()async {
                            for (int i = 0; i < closedBags.length; i++) {
                              await BagCloseTable()
                                  .select()
                                  .BagNumber
                                  .equals(closedBags[i]['BagNumber'])
                                  .update({
                                "Status": "Dispatched",
                                "DispatchDate": DateTimeDetails().currentDate(),
                                "DispatchTime": DateTimeDetails().onlyTime()
                              });

                              //added below code by Rohit to store information in Despatch Table for Msg creation.

                              final ofcMaster = await OFCMASTERDATA().select().toList();
                              final bagclose = await BagCloseTable()
                                  .select()
                                  .BagNumber
                                  .equals(closedBags[i]['BagNumber'])
                                  .toList();

                              final despatchtable = await DESPATCHBAG()
                                ..SCHEDULE = 'MMS' //hardcoded
                                ..SCHEDULED_TIME = DateTimeDetails().previousDate() +
                                    ' ' +
                                    ofcMaster[0].MAILSCHEDULE.toString()
                                ..MAILLIST_TO_OFFICE = ofcMaster[0].AOCode
                                ..BAGNUMBER = closedBags[i]['BagNumber']
                                ..FROM_OFFICE = ofcMaster[0].BOFacilityID
                                ..TO_OFFICE = ofcMaster[0].AOCode
                                ..CLOSING_DATE = bagclose[0].ClosedDate
                                ..REMARKS = 'Despatched';

                              despatchtable.save();
                            }
                            Toast.showFloatingToast(
                                "${closedBags.length} has been dispatched", context);
                            setState(() {
                              maillist = true;

                              closedBags = List.from(closedBags)
                                ..removeRange(0, closedBags.length);
                            });
                          },
                        ),
                        SizedBox(width: 20,),
                        Button(
                          buttonText: "Print Mail List",
                          buttonFunction: () async {
                            // List<BagCloseTable> bagvisible = await BagCloseTable()
                            //     .select()
                            //     .ClosedDate
                            //     .equals("18-11-2022")
                            //     .toList();
                            List<BagCloseTable> bagvisible=await BagCloseTable().select().ClosedDate.equals(DateTimeDetails().currentDate()).toList();
                            print("Bag number is:");
                            print(bagvisible[0].BagNumber);
                            List<BagArticlesTable> artvisible =
                            await BagArticlesTable()
                                .select()
                                .BagNumber
                                .equals(bagvisible[0].BagNumber)
                                .and.Status.equals('Closed')
                                .toList();
                            print("Articles list are:");
    for (int i = 0; i < artvisible.length; i++) {

      print(artvisible[i].ArticleNumber);

    }

                            final userDetails =
                            await OFCMASTERDATA().select().toList();

                            basicInformation.clear();

                            basicInformation.add("Office Name");
                            basicInformation.add(userDetails[0].BOName.toString());
                            basicInformation.add("Office ID");
                            basicInformation
                                .add(userDetails[0].BOFacilityID.toString());

                            basicInformation.add("Report Date");
                            basicInformation.add(DateTimeDetails().currentDate());
                            basicInformation.add("Report Time");
                            basicInformation.add(DateTimeDetails().oT());

                            basicInformation.add("Bag Number");
                            basicInformation.add(bagvisible[0].BagNumber!);
                            basicInformation
                                .add("................................");
                            basicInformation.add("");
                            basicInformation
                                .add("................................");
                            basicInformation.add("");

                            for (int i = 0; i < artvisible.length; i++) {
                              print(artvisible[i].ArticleNumber);
                              basicInformation
                                  .add("${i + 1}  ${artvisible[i].ArticleNumber!}");
                              basicInformation.add(artvisible[i].ArticleType!);
                            }

                            secondReceipt
                                .clear(); //sending empty list so that it won't print
                            PrintingTelPO printer = new PrintingTelPO();
                            await printer.printThroughUsbPrinter("BOOKING",
                                "Bag Manifest", basicInformation, secondReceipt, 1);
                          },
                        ),

                      ],
                    ),
                  ),

                ],
              );
            }
          }),
    );
  }

  void removeBag(int index) {
    setState(() {
      closedBags = List.from(closedBags)..removeAt(index);
    });
  }
}
