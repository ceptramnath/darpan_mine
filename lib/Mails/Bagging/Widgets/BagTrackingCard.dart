import 'package:darpan_mine/Widgets/DialogText.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagTrackingCard extends StatelessWidget {
  final String bagNumber;
  final Function() function;

  const BagTrackingCard(
      {Key? key, required this.bagNumber, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (_) => BagTrackScreen()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bagNumber,
                          style: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.w500),
                        ),
                        DialogText(title: 'Total Count ', subtitle: '0')
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => BagTrackScreen()));
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.blueGrey,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
