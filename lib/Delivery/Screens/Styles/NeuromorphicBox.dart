import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'NeuromorphicDecoration.dart';

Color mC = Colors.grey.shade100;
Color mCL = Colors.white;
Color mCD = Colors.black.withOpacity(0.075);
Color mCC = Colors.green.withOpacity(0.65);
Color fCD = Colors.blueGrey;
Color fCL = Colors.grey;

BoxDecoration nMbox = BoxDecoration(
    borderRadius: BorderRadius.circular(15.w),
    color: mC,
    boxShadow: [
      BoxShadow(
        color: mCD,
        offset: Offset(10.w, 10.w),
        blurRadius: 10.w,
      ),
      BoxShadow(
        color: mCL,
        offset: Offset(-10.w, -10.w),
        blurRadius: 10.w,
      ),
    ]);

BoxDecoration nMboxInvert = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: mCD,
    boxShadow: [
      BoxShadow(
          color: mCL,
          offset: Offset(3.w, 3.w),
          blurRadius: 3.w,
          spreadRadius: -3.w),
    ]);

BoxDecoration nMboxInvertActive = nMboxInvert.copyWith(color: mCC);

BoxDecoration nMbtn = BoxDecoration(
    borderRadius: BorderRadius.circular(10.w),
    color: mC,
    boxShadow: [
      BoxShadow(
        color: mCD,
        offset: Offset(2.w, 2.w),
        blurRadius: 2.w,
      )
    ]);

BoxDecoration nCOBox = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20.w)),
  color: Colors.grey[100],
  boxShadow: [
    BoxShadow(
        color: Colors.grey[600]!,
        offset: Offset(4.w, 4.w),
        blurRadius: 15.w,
        spreadRadius: 1.w),
    BoxShadow(
        color: Colors.white,
        offset: Offset(-4.w, -4.w),
        blurRadius: 15.w,
        spreadRadius: 1.w),
  ],
);

BoxDecoration nCDBox = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20.w)),
  color: Colors.grey[100],
  boxShadow: [
    BoxShadow(
        color: Colors.grey[600]!,
        offset: Offset(4.w, 4.w),
        blurRadius: 5.w,
        spreadRadius: 1.w),
    BoxShadow(
        color: Colors.white,
        offset: Offset(-4.w, -4.w),
        blurRadius: 5.w,
        spreadRadius: 1.w),
  ],
);

ConcaveDecoration nCIBox = ConcaveDecoration(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.w)),
  ),
  colors: [
    Colors.white,
    Colors.grey[400]!,
  ],
  depth: 10,
);

RoundedRectangleBorder appBarStyle = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(
    bottom: Radius.circular(20.w),
  ),
);
