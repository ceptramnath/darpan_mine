import 'dart:math' as math show sin, pi;

import 'package:darpan_mine/Constants/Color.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AnimatedButton extends StatefulWidget {
  Function function;

  AnimatedButton({Key? key, required this.function}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller!,
              curve: const CurveWave(),
            ),
          ),
          child: FloatingActionButton(
            elevation: 5,
            onPressed: () {
              widget.function();
            },
            child: Container(
              child: Icon(MdiIcons.barcodeScan),
            ),
            backgroundColor: ColorConstants.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class CurveWave extends Curve {
  const CurveWave();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
