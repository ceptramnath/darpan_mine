import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Mails/Booking/BookingDBModel/BookingDBModel.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({Key? key}) : super(key: key);

  @override
  _RequestStatusScreenState createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  List specialRemittanceRequests = [];

  requests() async {
    specialRemittanceRequests =
        await SpecialRemittanceFile().select().toMapList();
    return specialRemittanceRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: FutureBuilder(
        future: requests(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Card(
                          child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'ID',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text('Amount \nRequested',
                                      textAlign: TextAlign.center),
                                ),
                                DataColumn(
                                  label: Text('Acknowledgement\nReceived On',
                                      textAlign: TextAlign.center),
                                ),
                                DataColumn(
                                  label: Expanded(
                                      child: Text(
                                    'Status',
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ],
                              rows: specialRemittanceRequests
                                  .map((e) => DataRow(cells: <DataCell>[
                                        DataCell(Text(
                                            '${e['SlipNumber']}${e['id']}')),
                                        DataCell(Center(
                                            child: Text('${e['CashAmount']}'))),
                                        DataCell(Center(
                                            child: Text('${e['Date']}'))),
                                        const DataCell(
                                            Text('Acknowledgement Pending')),
                                      ]))
                                  .toList()),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
