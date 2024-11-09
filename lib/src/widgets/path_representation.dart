import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GraphicalRepresentation extends StatefulWidget {
  final double forwardDistance;
  final double turnWidth;
  final int numberOfRows;
  final String firstTurn;

  const GraphicalRepresentation({
    Key? key,
    required this.forwardDistance,
    required this.turnWidth,
    required this.numberOfRows,
    required this.firstTurn,
  }) : super(key: key);

  @override
  _GraphicalRepresentationState createState() => _GraphicalRepresentationState();
}

class _GraphicalRepresentationState extends State<GraphicalRepresentation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Path _path;
  late List<Offset> _points;
  int _currentPointIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..addListener(() {
        setState(() {
          _currentPointIndex = (_currentPointIndex + 1) % _points.length;
        });
      });
    _initializePath();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializePath() {
    _path = Path();
    _points = [];

    double xOffset = 0;
    double yOffset = 0;
    bool turnLeft = widget.firstTurn == 'left';

    for (int i = 0; i < widget.numberOfRows; i++) {
      // Forward movement
      _path.moveTo(xOffset, yOffset);
      _points.add(Offset(xOffset, yOffset));

      xOffset += widget.forwardDistance;
      _path.lineTo(xOffset, yOffset);
      _points.add(Offset(xOffset, yOffset));

      // Turn (left or right based on the row)
      if (turnLeft) {
        xOffset -= widget.turnWidth;
      } else {
        xOffset += widget.turnWidth;
      }
      yOffset += 50; // Move down for the next row

      _path.lineTo(xOffset, yOffset);
      _points.add(Offset(xOffset, yOffset));

      // Alternate turns for the next row
      turnLeft = !turnLeft;
    }

    _controller.repeat();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 300,
      width: double.infinity,
      child: Stack(  // Wrap CustomPaint with Stack
        children: [
          CustomPaint(
            painter: FieldPainter(_path),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_points.isNotEmpty) {
                Offset currentPosition = _points[_currentPointIndex];
                return Positioned(
                  left: currentPosition.dx,
                  top: currentPosition.dy,
                  child: Transform.rotate(
                    angle: _points.length > _currentPointIndex + 1
                        ? _getRotationAngle(currentPosition, _points[_currentPointIndex + 1])
                        : 0,
                    child: Image.asset('assets/images/gardro_device.png', width: 30, height: 30),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }


  double _getRotationAngle(Offset current, Offset next) {
    // Calculate angle between two points to rotate the image
    return atan2(next.dy - current.dy, next.dx - current.dx);
  }
}

class FieldPainter extends CustomPainter {
  final Path path;

  FieldPainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
