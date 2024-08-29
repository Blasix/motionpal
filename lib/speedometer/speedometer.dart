import 'package:flutter/material.dart';
import 'dart:math';

class Speedometer extends StatefulWidget {
  final double speed;
  final double maxSpeed;

  const Speedometer({
    super.key,
    required this.speed,
    required this.maxSpeed,
  });

  @override
  SpeedometerState createState() => SpeedometerState();
}

class SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initialize the Tween and set up the Animation
    _animation = Tween<double>(
      begin: widget.speed / widget.maxSpeed,
      end: widget.speed / widget.maxSpeed,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {}); // Update the UI during animation
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant Speedometer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.speed != widget.speed) {
      // Remember the current animation value
      double currentSpeedFraction = _animation.value;
      // Reset the controller and update the Tween with the new speed
      _controller.reset();
      _animation = Tween<double>(
        begin: currentSpeedFraction, // Start from the current animation value
        end: widget.speed / widget.maxSpeed, // End at the new speed value
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
        ..addListener(() {
          setState(() {});
        });

      // Start the animation again
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // Adjust size according to your design
      painter: SpeedometerPainter(
        speedFraction: _animation.value,
        maxSpeed: widget.maxSpeed,
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speedFraction;
  final double maxSpeed;

  SpeedometerPainter({required this.speedFraction, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    double startAngle = 3 * pi / 4;
    double sweepAngle = 3 * pi / 2;
    double currentAngle = startAngle + (sweepAngle * speedFraction);

    // Draw the background arc
    Paint arcPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

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
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

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
