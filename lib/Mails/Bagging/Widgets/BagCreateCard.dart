import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagCreateCard extends StatelessWidget {
  final String articleNumber;
  final String weight;
  final Function() deleteFunction;
  final Function() receiveFunction;

  const BagCreateCard(
      {Key? key,
      required this.articleNumber,
      required this.weight,
      required this.deleteFunction,
      required this.receiveFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: AlertDialog(
                title: Text('Conformation'),
                content: Text('Do you want to Create Bag/Bags?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      receiveFunction();
                      Navigator.of(context).pop();
                    },
                    child: Text('ACCEPT'),
                  ),
                ],
              ),
            );
          },
        );
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
                          articleNumber,
                          style: TextStyle(
                              letterSpacing: 2, fontWeight: FontWeight.w500),
                        ),
                        Space(),
                        Text(
                          weight,
                          style: TextStyle(letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        deleteFunction();
                      },
                      icon: Icon(
                        Icons.delete,
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
