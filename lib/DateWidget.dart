import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/src/size_extension.dart';

class DateWidget extends StatelessWidget {
  String selectedDate;
  String currentDate;
  Widget Function() selectDate;

  DateWidget(
      {required this.selectedDate,
      required this.currentDate,
      required this.selectDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 8),
            child: InkWell(
              onTap: selectDate,
              child: Container(
                child: GestureDetector(
                  onTap: () => selectDate,
                  child: IgnorePointer(
                    child: TextFormField(
                      key: Key(selectedDate),
                      initialValue:
                          selectedDate == '' ? currentDate : selectedDate,
                      readOnly: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                                width: 1, color: Color(0xFFCFB53B)),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                          ),
                          labelStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          labelText: 'Select Date',
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFFCFB53B))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFFCFB53B)))),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }
}
