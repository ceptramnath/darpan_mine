import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ml_scanner_plugin/qr_camera.dart';


void main() {
  debugPaintSizeEnabled = false;
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String qr;
  bool camState = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ML Scanner'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex:9,
                // child: camState?
              child:     Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: QrCamera(
                      onError: (context, error) => Text(
                        error.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                      qrCodeCallback: (code) {
                        setState(() {
                          qr = code;
                        });
                      },
                      // child: Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.transparent,
                      //     border: Border.all(
                      //         color: Colors.orange,
                      //         width: 10.0,
                      //         style: BorderStyle.solid),
                      //   ),
                      // ),
                    ),
                  ),
                )
                    // : Center(child: Text("Camera inactive"))
    ),
            Expanded(flex:2,child: Text("QRCODE: $qr")),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Text(
      //       "press me",
      //       textAlign: TextAlign.center,
      //     ),
      //     onPressed: () {
      //       setState(() {
      //         camState = !camState;
      //       });
      //     }),
    );
  }
}
