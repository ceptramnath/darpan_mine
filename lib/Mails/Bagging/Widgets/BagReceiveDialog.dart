import 'package:flutter/material.dart';

class BagReceiveDialog extends StatelessWidget {
  final Function() function;

  const BagReceiveDialog({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conformation'),
      content: Text('Do you want to Receive Bag/Bags?'),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            function();
          },
          child: Text('ACCEPT'),
        ),
      ],
    );
  }
}
