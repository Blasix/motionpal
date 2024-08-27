import 'dart:math';

import 'package:flutter/material.dart';

class SpeedometerPainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  SpeedometerPainter({required this.speed, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the size of the speedometer
    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    double startAngle = 3 * pi / 4;
    double sweepAngle = 3 * pi / 2;
    double currentAngle = startAngle + (sweepAngle * (speed / maxSpeed));

    // Draw the background arc
    Paint arcPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw the filled arc (representing speed)
    Paint progressPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      currentAngle - startAngle,
      false,
      progressPaint,
    );

    // // Draw the speed indicator (needle)
    // Paint needlePaint = Paint()
    //   ..color = Colors.red
    //   ..strokeWidth = 2;

    // double needleLength = radius - 15;
    // Offset needleEnd = Offset(
    //   center.dx + needleLength * cos(currentAngle),
    //   center.dy + needleLength * sin(currentAngle),
    // );

    // canvas.drawLine(center, needleEnd, needlePaint);

    // // Draw the center circle
    // Paint centerCirclePaint = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.fill;

    // canvas.drawCircle(center, 5, centerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
