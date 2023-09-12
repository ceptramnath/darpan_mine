import 'package:darpan_mine/Widgets/UITools.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class BagDispatchCard extends StatelessWidget {
  final String articleNumber;
  final String articleCount;
  final String cashCount;
  final Function() deleteFunction;
  final Function() receiveFunction;

  const BagDispatchCard(
      {Key? key,
      required this.articleNumber,
      required this.articleCount,
      required this.cashCount,
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
                title: const Text('Confirmation'),
                content: const Text('Do you want to Dispatch Bag/Bags?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () {
                      receiveFunction();
                      Navigator.of(context).pop();
                    },
                    child: const Text('ACCEPT'),
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
                        style: const TextStyle(
                            letterSpacing: 2, fontWeight: FontWeight.w500),
                      ),
                      const Space(),
                      Text(
                        'Total Articles $articleCount',
                        style: const TextStyle(letterSpacing: 2),
                      ),
                      const Space(),
                      cashCount.isNotEmpty
                          ? Text(
                              'Cash count \u{20B9}$cashCount',
                              style: const TextStyle(letterSpacing: 2),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      deleteFunction();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.blueGrey,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
