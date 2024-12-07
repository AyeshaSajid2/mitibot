import 'package:flutter/material.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Map<String, dynamic>>? boundingBoxes;

  BoundingBoxPainter(this.boundingBoxes);

  @override
  void paint(Canvas canvas, Size size) {
    if (boundingBoxes == null || boundingBoxes!.isEmpty) {
      return; // Nothing to paint
    }

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var box in boundingBoxes!) {
      if (box != null && box.containsKey('x') && box.containsKey('y') && box.containsKey('width') && box.containsKey('height')) {
        final double x = box['x'];
        final double y = box['y'];
        final double width = box['width'];
        final double height = box['height'];
        canvas.drawRect(Rect.fromLTWH(x, y, width, height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
