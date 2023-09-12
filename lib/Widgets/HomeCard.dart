import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final String image;

  const HomeCard(
      {Key? key,
      required this.title,
      required this.backgroundColor,
      required this.textColor,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.toDouble()),
      child: Container(
        width: 100.toDouble(),
        height: 120.toDouble(),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.0.toDouble(),
                height: 60.0.toDouble(),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white,
                      width: 2.0.toDouble(),
                      style: BorderStyle.solid),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(image),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10.0.toDouble(), horizontal: 5.toDouble()),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.toDouble(),
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
