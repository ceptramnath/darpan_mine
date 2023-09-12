import 'package:flutter/material.dart';

class CustomDrawerListTile extends StatelessWidget {
  IconData? listTileIcon;
  String? listTileTitle;
  Widget Function() listTileNavFunction;

  CustomDrawerListTile(
      {this.listTileIcon,
      this.listTileTitle,
      required this.listTileNavFunction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        listTileIcon,
        color: Colors.black54,
      ),
      title: Text(listTileTitle!),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return listTileNavFunction();
        }));
      },
    );
  }
}
