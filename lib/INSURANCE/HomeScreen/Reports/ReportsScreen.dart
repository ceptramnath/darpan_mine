import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:darpan_mine/INSURANCE/Utils/DateTimeDetails.dart';
import 'package:intl/intl.dart';

import '../../../HomeScreen.dart';
import '../HomeScreen.dart';
import 'ReportGeneratedScreen.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  TextEditingController date = TextEditingController(
      text: DateTimeDetails()
          .onlyDate()
          .toString()
          .split('-')
          .reversed
          .join('-'));

  // List<String> _options = [
  //   'Day End Collection Report',
  //   'Daily Indexing Report',
  //   'Daily Summary Report',
  // ];
  List<String> _optionsdec = [
    'Transactions',
  ];
  List<String> _optionsdir = [
    'Transactions',
    'PLI',
    'RPLI',
  ];
  List<String> _optionsdsr = [
    'PLI',
    'RPLI',
  ];

  String _selectedService = 'Day End Collection Report';
  String _selecteddecService = 'Transactions';
  String _selecteddirservice = 'Transactions';
  String _selecteddsr = 'PLI';
  List<String> services = [
    'Day End Collection Report',
    'Daily Indexing Report',
    'Daily Summary Report',
  ];

  // List<Widget> _buildChips() {
  //   List<Widget> chips = [];
  //   for (int i = 0; i < _options.length; i++) {
  //     Widget item = Padding(
  //       padding: const EdgeInsets.only(left: 5, right: 5),
  //       child: ChoiceChip(
  //         label: Text(_options[i]),
  //         labelStyle: TextStyle(color: Colors.white),
  //         // avatar: Icon(_icons[i]),
  //         elevation: 10,
  //         pressElevation: 5,
  //         shadowColor: Colors.teal,
  //         backgroundColor: Colors.blue,
  //         selectedColor: Color(0xFFCC0000),
  //         selected: _selectedIndex == i,
  //         onSelected: (bool value) {
  //           setState(() {
  //             _selectedIndex = i;
  //           });
  //         },
  //       ),
  //     );
  //     chips.add(item);
  //   }
  //   return chips;
  // }
  //
  // List<Widget> _buildOptionChips(int startvalue,int endvalue) {
  //   List<Widget> chips1 = [];
  //   for (int i = startvalue; i < endvalue; i++) {
  //     Widget item = Padding(
  //       padding: const EdgeInsets.only(left: 5, right: 5),
  //       child: ChoiceChip(
  //         label: Text(_options1[i]),
  //         labelStyle: TextStyle(color: Colors.white),
  //         // avatar: Icon(_icons1[i]),
  //         elevation: 10,
  //         pressElevation: 5,
  //         shadowColor: Colors.teal,
  //         backgroundColor: Colors.blue,
  //         selectedColor: Color(0xFFCC0000),
  //         selected: _selectedIndex1 == i,
  //         onSelected: (bool value) {
  //           setState(() {
  //             _selectedIndex1 = i;
  //           });
  //         },
  //       ),
  //     );
  //     chips1.add(item);
  //   }
  //   return chips1;
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await _onBackPressed();
        result ??= false;
        return result;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("REPORTS"),
          backgroundColor: ColorConstants.kPrimaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Reports Type",
              //       style:
              //           TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              //     ),
              //   ),
              // ),
              // Container(
              //   // height: 100,
              //   alignment: Alignment.centerLeft,
              //   child: Wrap(
              //     spacing: 6,
              //     direction: Axis.horizontal,
              //     children: _buildChips(),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reports Type",
                      style: TextStyle(
                          color: Colors.blueGrey[300], fontSize: 18),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * .95,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(90.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 35.0),
                    child: DropdownButtonFormField<String>(
                      alignment: Alignment.center,
                      value: _selectedService,
                      icon: const Icon(Icons.arrow_drop_down),
                      elevation: 16,
                      style:
                          TextStyle(color: Colors.deepPurple, fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                        border: InputBorder.none,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedService = newValue!;
                        });
                      },
                      items: services
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       "Transaction Type",
              //       style:
              //           TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
              //   child: Row(
              //     children: [
              //       if (_options[_selectedIndex] == "Day End Collection Report")
              //         Row(
              //           children: [
              //             Container(
              //               // height: 100,
              //               child: Wrap(
              //                 spacing: 6,
              //                 direction: Axis.horizontal,
              //                 children: _buildOptionChips(0,1),
              //               ),
              //             ),
              //           ],
              //         )
              //       else if (_options[_selectedIndex] ==
              //           'Daily Indexing Report')
              //         Row(
              //           children: [
              //             Container(
              //               // height: 100,
              //               child: Wrap(
              //                 spacing: 6,
              //                 direction: Axis.horizontal,
              //                 children: _buildOptionChips(0,3),
              //               ),
              //             ),
              //           ],
              //         )
              //       else if (_options[_selectedIndex] == 'Daily Summary Report')
              //         Row(
              //           children: [
              //             Container(
              //               // height: 100,
              //               child: Wrap(
              //                 spacing: 6,
              //                 direction: Axis.horizontal,
              //                 children: _buildOptionChips(1,3),
              //               ),
              //             ),
              //           ],
              //         )
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transaction Type",
                      style: TextStyle(
                          color: Colors.blueGrey[300], fontSize: 18),
                    )),
              ),
              Card(
                child: Column(
                  children: [
                    if (_selectedService == "Day End Collection Report")
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .95,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 35.0),
                            child: DropdownButtonFormField<String>(
                              alignment: Alignment.center,
                              value: _selecteddecService,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 18),
                              decoration: InputDecoration(
                                labelText: "Product Name",
                                labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                border: InputBorder.none,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selecteddecService = newValue!;
                                });
                              },
                              items: _optionsdec.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    else if (_selectedService == "Daily Indexing Report")
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .95,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 35.0),
                            child: DropdownButtonFormField<String>(
                              alignment: Alignment.center,
                              value: _selecteddirservice,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 18),
                              decoration: InputDecoration(
                                labelText: "Product Name",
                                labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                border: InputBorder.none,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selecteddirservice = newValue!;
                                });
                              },
                              items: _optionsdir.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      )
                    else if (_selectedService == "Daily Summary Report")
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .95,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(90.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 35.0),
                            child: DropdownButtonFormField<String>(
                              alignment: Alignment.center,
                              value: _selecteddsr,
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 18),
                              decoration: InputDecoration(
                                labelText: "Product Name",
                                labelStyle: TextStyle(color: Color(0xFFCFB53B)),
                                border: InputBorder.none,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selecteddsr = newValue!;
                                });
                              },
                              items: _optionsdsr.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    Divider(
                      thickness: 0.8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.5, left: 15.0),
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            child: GestureDetector(
                                onTap: () => _selectDate,
                                child: IgnorePointer(
                                  child: TextFormField(
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500),
                                    controller: date,
                                    decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 2, 40, 86),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: InputBorder.none,
                                      labelText: "Date",
                                      labelStyle:
                                          TextStyle(color: Color(0xFFCFB53B)),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // TextFormField(
              //   style:const TextStyle(fontSize: 17,
              //       color://Colors.white,
              //       Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500   ) ,
              //   controller: date,
              //   decoration: InputDecoration(
              //       hintStyle: TextStyle(fontSize: 15,
              //         color: Color.fromARGB(255, 2, 40, 86), fontWeight: FontWeight.w500 ,  ),
              //       border: InputBorder.none,
              //
              //       enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color:Colors.blueGrey,width: 3)
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color:Colors.green,width: 3)
              //       ),
              //
              //       contentPadding: EdgeInsets.only(top:20,bottom: 20,left: 20,right: 20),
              //       prefixIcon: IconButton(icon: Icon(Icons.calendar_today),
              //       onPressed: () async{
              //         _selectDate(context);
              //       },),
              //       labelText: "Report Date"),
              // ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: Text(
                    'GENERATE REPORT',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      // elevation:MaterialStateProperty.all(),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.red)))),
                  onPressed: () async {
                    if (_selectedService == "Day End Collection Report")
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReportGeneratedScreen(
                                  _selectedService,
                                  _selecteddecService,
                                  date.text)));
                    else if (_selectedService == "Daily Indexing Report")
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReportGeneratedScreen(
                                  _selectedService,
                                  _selecteddirservice,
                                  date.text)));
                    else if (_selectedService == "Daily Summary Report")
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ReportGeneratedScreen(
                                  _selectedService, _selecteddsr, date.text)));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        var formatter = new DateFormat('dd-MM-yyyy');
        // date.text = formatter.format(d).toString().split('-').reversed.join('-');
        date.text = formatter.format(d);
      });
    }
  }

  Future<bool>? _onBackPressed() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => MainHomeScreen(UserPage(false), 3)),
        (route) => false);
  }
}
