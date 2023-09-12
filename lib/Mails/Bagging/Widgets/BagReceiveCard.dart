import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagReceiveCard extends StatelessWidget {
  final String bagNumber;
  final String bagWeight;
  final Function() deleteFunction;
  final Function() receiveFunction;

  const BagReceiveCard(
      {Key? key,
      required this.bagNumber,
      required this.bagWeight,
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
            return AlertDialog(
              title: Text('Conformation'),
              content: Text('Do you want to Receive Bag/Bags?'),
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
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: ListTile(
                trailing: IconButton(
                    onPressed: () {
                      deleteFunction();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blueGrey,
                    )),
                title: Text(
                  'Bag# $bagNumber',
                  style: TextStyle(letterSpacing: 2),
                ),
                subtitle: Text(
                  "Weight $bagWeight gms",
                  style: TextStyle(letterSpacing: 2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
