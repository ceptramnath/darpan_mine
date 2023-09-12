import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ConcaveDecoration extends Decoration {
  ShapeBorder? shape;
  double? depth;
  List<Color>? colors;
  double? opacity;

  ConcaveDecoration({
    required this.shape,
    required this.depth,
    this.colors = const [Colors.black87, Colors.white],
    this.opacity = 1.0,
  })  : assert(shape != null),
        assert(colors == null || colors.length == 2);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _ConcaveDecorationPainter(shape!, depth!, colors!, opacity!);

  @override
  EdgeInsetsGeometry get padding => shape!.dimensions;

  @override
  Decoration? lerpFrom(Decoration? a, double? t) {
    if (a is ConcaveDecoration) {
      t = Curves.easeInOut.transform(t!);
      return ConcaveDecoration(
        shape: ShapeBorder.lerp(a.shape, shape, t),
        depth: ui.lerpDouble(a.depth, depth, t),
        // colors: [
        //   Color.lerp(a.colors[0], colors[0], t),
        //   Color.lerp(a.colors[1], colors[1], t),
        // ],
        opacity: ui.lerpDouble(a.opacity, opacity, t),
      );
    }
  }
}

// class CornerSide {
//   CornerSide.all(double x, [double y]) : this._all(Size(x, y ?? x));
//
//   CornerSide.vertical({
//     Size top = Size.zero,
//     Size bottom = Size.zero,
//   }) : this.only(
//     topLeft: top,
//     topRight: top,
//     bottomLeft: bottom,
//     bottomRight: bottom,
//   );
//
//   CornerSide.horizontal({
//     Size left = Size.zero,
//     Size right = Size.zero,
//   }) : this.only(
//     topLeft: left,
//     topRight: right,
//     bottomLeft: left,
//     bottomRight: right,
//   );
//
//   const CornerSide.only({
//     this.topLeft = Size.zero,
//     this.topRight = Size.zero,
//     this.bottomLeft = Size.zero,
//     this.bottomRight = Size.zero,
//   });
//
//   const CornerSide._all(Size size) : this.only(
//     topLeft: size,
//     topRight: size,
//     bottomLeft: size,
//     bottomRight: size,
//   );
//
//   final Size topLeft;
//   final Size topRight;
//   final Size bottomLeft;
//   final Size bottomRight;
//
//   static CornerSide lerp(CornerSide a, CornerSide b, double t) {
//     return CornerSide.only(
//       topLeft: Size.lerp(a.topLeft, b.topLeft, t),
//       topRight: Size.lerp(a.topRight, b.topRight, t),
//       bottomRight: Size.lerp(a.bottomRight, b.bottomRight, t),
//       bottomLeft: Size.lerp(a.bottomLeft, b.bottomLeft, t),
//     );
//   }
// }
//
// class _CornerBoxPainter extends BoxPainter {
//   final double fillLeft;
//   final double fillTop;
//   final double fillRight;
//   final double fillBottom;
//   final double strokeWidth;
//   final EdgeInsets insets;
//   final double position;
//   final CornerSide cornerSide;
//   Paint _p;
//
//   _CornerBoxPainter(this.fillLeft, this.fillTop, this.fillRight, this.fillBottom, this.strokeWidth, strokeColor, this.insets, this.position, this.cornerSide) {
//     _p = Paint()
//       ..color = strokeColor
//       ..style = PaintingStyle.stroke
//     // ..strokeCap = StrokeCap.square
//       ..strokeWidth = strokeWidth;
//   }
//
//   @override
//   void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
//     var _rect = offset & configuration.size;
//
//     var a = _rect.deflate(strokeWidth / 2);
//     var b = insets.deflateRect(_rect).inflate(strokeWidth / 2);
//     var rect = Rect.lerp(a, b, position);
//
//     Path _path = Path();
//
//     var topLeftCornerRect = Alignment.topLeft.inscribe(cornerSide.topLeft, rect);
//     var topRightCornerRect = Alignment.topRight.inscribe(cornerSide.topRight, rect);
//     var bottomRightCornerRect = Alignment.bottomRight.inscribe(cornerSide.bottomRight, rect);
//     var bottomLeftCornerRect = Alignment.bottomLeft.inscribe(cornerSide.bottomLeft, rect);
//     var i = [
//       Offset.lerp(topLeftCornerRect.bottomLeft, rect.centerLeft, fillLeft),
//       rect.topLeft,
//       Offset.lerp(topLeftCornerRect.topRight, rect.topCenter, fillTop),
//       Offset.lerp(topRightCornerRect.topLeft, rect.topCenter, fillTop),
//       rect.topRight,
//       Offset.lerp(topRightCornerRect.bottomRight, rect.centerRight, fillRight),
//       Offset.lerp(bottomRightCornerRect.topRight, rect.centerRight, fillRight),
//       rect.bottomRight,
//       Offset.lerp(bottomRightCornerRect.bottomLeft, rect.bottomCenter, fillBottom),
//       Offset.lerp(bottomLeftCornerRect.bottomRight, rect.bottomCenter, fillBottom),
//       rect.bottomLeft,
//       Offset.lerp(bottomLeftCornerRect.topLeft, rect.centerLeft, fillLeft),
//     ].iterator;
//
//     while (i.moveNext()) {
//       _path.moveTo(i.current.dx, i.current.dy); i.moveNext();
//       _path.lineTo(i.current.dx, i.current.dy); i.moveNext();
//       _path.lineTo(i.current.dx, i.current.dy);
//     }
//     canvas.drawPath(_path, _p);
//   }
// }
//
// class ConcaveDecoration extends Decoration {
//   final ShapeBorder shape;
//   final double depth;
//   final List<Color> colors;
//   final double opacity;
//
//   ConcaveDecoration({
//     @required this.shape,
//     @required this.depth,
//     this.colors = const [Colors.black87, Colors.white],
//     this.opacity = 1.0,
//   }) : assert(shape != null), assert(colors == null || colors.length == 2);
//
//   @override
//   BoxPainter createBoxPainter([onChanged]) => _ConcaveDecorationPainter(shape, depth, colors, opacity);
//
//   @override
//   EdgeInsetsGeometry get padding => shape.dimensions;
//
//   @override
//   Decoration lerpFrom(Decoration a, double t) {
//     if (a is ConcaveDecoration) {
//       t = Curves.easeInOut.transform(t);
//       return ConcaveDecoration(
//         shape: ShapeBorder.lerp(a.shape, shape, t),
//         depth: ui.lerpDouble(a.depth, depth, t),
//         colors: [
//           Color.lerp(a.colors[0], colors[0], t),
//           Color.lerp(a.colors[1], colors[1], t),
//         ],
//         opacity: ui.lerpDouble(a.opacity, opacity, t),
//       );
//     }
//     return null;
//   }
// }

class _ConcaveDecorationPainter extends BoxPainter {
  ShapeBorder shape;
  double depth;
  List<Color> colors;
  double opacity;

  _ConcaveDecorationPainter(this.shape, this.depth, this.colors, this.opacity) {
    if (depth > 0) {
      colors = [
        colors[1],
        colors[0],
      ];
    } else {
      depth = -depth;
    }
    colors = [
      colors[0].withOpacity(opacity),
      colors[1].withOpacity(opacity),
    ];
  }

  @override
  void paint(
      ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final shapePath = shape.getOuterPath(offset & configuration.size!);
    final rect = shapePath.getBounds();

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depth * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, depth);
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width, rect.height / 2)
        : Size(rect.width / 2, rect.height);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect =
      alignment.inscribe(Size.square(rect.longestSide), rect);
      paint
        ..shader = ui.Gradient.linear(
            shaderRect.topLeft, shaderRect.bottomRight, colors, stops);

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}
