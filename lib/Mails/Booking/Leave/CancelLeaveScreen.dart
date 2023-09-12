import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:darpan_mine/Widgets/LetterForm.dart';
import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelLeaveScreen extends StatefulWidget {
  const CancelLeaveScreen({Key? key}) : super(key: key);

  @override
  _CancelLeaveScreenState createState() => _CancelLeaveScreenState();
}

class _CancelLeaveScreenState extends State<CancelLeaveScreen> {
  final leaveFocus = FocusNode();
  final leaveController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    child: Container(
                        child: DataTable(columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Request \nID',
                        ),
                      ),
                      DataColumn(
                        label: Text('From \nDate'),
                      ),
                      DataColumn(
                        label: Text('To \nDate', textAlign: TextAlign.center),
                      ),
                      DataColumn(
                        label: Text('Leave\nType', textAlign: TextAlign.center),
                      ),
                      DataColumn(
                        label: Text('Status', textAlign: TextAlign.center),
                      ),
                      DataColumn(
                        label: Text('', textAlign: TextAlign.center),
                      ),
                    ], rows: <DataRow>[
                      DataRow(cells: [
                        DataCell(Text('LEV123243653453453')),
                        DataCell(Text('01.01.2022')),
                        DataCell(Text('03.01.2022')),
                        DataCell(Center(child: Text('GDS Maternity Leave'))),
                        DataCell(Center(child: Text('GRANTED'))),
                        DataCell(Center(child: Text(''))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('LEV123243653453453')),
                        DataCell(Text('05.01.2022')),
                        DataCell(Text('08.01.2022')),
                        DataCell(Center(child: Text('GDS Maternity Leave'))),
                        DataCell(Center(child: Text('APPLIED'))),
                        DataCell(Center(
                            child: ElevatedButton(
                          child: Text('CANCEL'),
                          onPressed: () => cancelLeaveDialog(),
                        ))),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('LEV123243653453453')),
                        DataCell(Text('11.01.2022')),
                        DataCell(Text('14.01.2022')),
                        DataCell(Center(child: Text('GDS Maternity Leave'))),
                        DataCell(Center(child: Text('APPLIED'))),
                        DataCell(Center(
                            child: ElevatedButton(
                          child: Text('CANCEL'),
                          onPressed: () => cancelLeaveDialog(),
                        ))),
                      ]),
                    ])),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter reason for cancellation'),
            content: CInputForm(
                readOnly: false,
                iconData: Icons.cancel_presentation,
                labelText: 'Cancellation Reason',
                controller: leaveController,
                textType: TextInputType.text,
                typeValue: 'Leave',
                focusNode: leaveFocus),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('CONFIRM'),
                ),
              ),
            ],
          );
        });
  }

  void cancelLeaveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conformation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Do you want to Cancel the Leave?'),
              DoubleSpace(),
              DialogText(
                  title: 'Request Id : ', subtitle: 'LEV123243653453453'),
              DialogText(title: 'From Date : ', subtitle: '05.01.2022'),
              DialogText(title: 'To Date : ', subtitle: '08.01.2022'),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmDialog();
                },
                child: Text('YES'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO'),
              ),
            ),
          ],
        );
      },
    );
  }
}
