import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogText extends StatelessWidget {
  final String title;
  final String subtitle;

  DialogText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: title,
          style: TextStyle(
              color: ColorConstants.kTextColor,
              letterSpacing: 1,
              fontSize: 14),
          children: [
            TextSpan(
                text: subtitle,
                style: TextStyle(
                    color: ColorConstants.kTextDark,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.toDouble(),
                    fontSize: 14))
          ]),
    );
  }
}

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(color: ColorConstants.kTextColor));
  }
}

class HeadingText extends StatelessWidget {
  final String title;

  const HeadingText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            color: ColorConstants.kTextDark,
            letterSpacing: 1.toDouble()));
  }
}

class TitleAndHeading extends StatelessWidget {
  final String title;
  final String heading;

  const TitleAndHeading({Key? key, required this.title, required this.heading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [TitleText(title: title), HeadingText(title: heading)],
    );
  }
}

class DialogListTile extends StatelessWidget {
  final String title;
  final String description;

  const DialogListTile(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: title,
        style:
            const TextStyle(color: ColorConstants.kTextColor, letterSpacing: 1),
        children: <TextSpan>[
          TextSpan(
              text: description,
              style: const TextStyle(
                  color: ColorConstants.kTextDark, letterSpacing: 1)),
        ],
      ),
    );
  }
}
