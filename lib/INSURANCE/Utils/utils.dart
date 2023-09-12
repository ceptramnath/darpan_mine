import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class UtilFs {
//   static showToast(String message, BuildContext context) {
//    Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
//   }
// }

class UtilFs {
  static showToast(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
                // onPressed: () async{
                //   Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => Navigation),
                //           (route) => false);
                // },
              )
            ],
            content: Text(message),
          );
        });
  }
}

class UtilFsNav {
  static showToast(String message, BuildContext context, Widget Navigation) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                // onPressed: () => Navigator.of(context).pop(),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Navigation),
                  );
                },
              )
            ],
            content: Text(message),
          );
        });
  }
}

class UtilFs1 {
  static showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM);
  }
}
