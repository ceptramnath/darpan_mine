import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loader extends StatelessWidget {
  Loader(
      {Key? key,
      this.opacity: 0.5,
      this.isCustom: false,
      this.dismissibles: false,
      this.color: Colors.black,
      this.loadingTxt: 'Loading...'})
      : super(key: key);

  final bool isCustom;
  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: opacity,
            child: const ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
              child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: isCustom
                    ? Container(
                        width: 1000,
                        height: 500,
                        alignment: Alignment.center,
                        // padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/spinew.gif"),
                          ),
                        ),
                        // child: Text(loadingTxt, style: TextStyle(color: Colors.white70, fontSize: 18)),
                      )
                    : Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10),
                        child: CircularProgressIndicator(),
                      ),
              ),

              // Container(
              //   alignment: Alignment.center,
              //   margin: const EdgeInsets.only(top: 5),
              //   child: Text(loadingTxt, style: TextStyle(color: Colors.white70, fontSize: 18)),
              // ),
            ],
          )),
          Container(
            alignment: Alignment.center,
            // margin: const EdgeInsets.only(top: 5),
            child: Text(loadingTxt,
                style: TextStyle(color: Colors.amberAccent, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
