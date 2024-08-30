import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../settings/logic/bools.dart';
import 'speed_utils.dart';

class SpeedometerWidget extends ConsumerWidget {
  final double speed;
  final double totalDistance;
  final Duration totalTime;
  final double maxSpeed;

  const SpeedometerWidget(
      {super.key,
      required this.speed,
      required this.totalDistance,
      required this.totalTime,
      required this.maxSpeed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isKMPH = ref.watch(isKMPHProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Speedometer(
                speed: convertSpeed(speed, isKMPH).toDouble(),
                maxSpeed: 240,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isKMPH ? "km/h" : "mph",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      AnimatedNumber(
                        duration: const Duration(milliseconds: 500),
                        value: convertSpeed(speed, isKMPH),
                        style: const TextStyle(
                            fontSize: 52, fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   "${convertSpeed(speed, isKMPH)}",
                      //   style: const TextStyle(
                      //       fontSize: 52,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ],
                  ),
                  (totalDistance.round() > 0)
                      ? Text(
                          "${convertDistance(totalDistance, getDistanceType(isKMPH, totalDistance))} ${getDistanceType(isKMPH, totalDistance).name}")
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  "Average Speed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${convertSpeed(totalTime.inSeconds > 0 ? totalDistance / totalTime.inSeconds : 0, isKMPH)} ${isKMPH ? "km/h" : "mph"}",
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Max Speed",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${convertSpeed(maxSpeed, isKMPH)} ${isKMPH ? "km/h" : "mph"}",
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

class AnimatedNumber extends ImplicitlyAnimatedWidget {
  final int value;
  final TextStyle? style;
  const AnimatedNumber({
    super.key,
    required super.duration,
    required this.value,
    this.style,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedNumber> createState() =>
      _AnimatedNumberState();
}

class _AnimatedNumberState extends AnimatedWidgetBaseState<AnimatedNumber> {
  late IntTween _counter;

  @override
  void initState() {
    _counter = IntTween(begin: widget.value, end: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('${_counter.evaluate(animation)}', style: widget.style);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _counter = visitor(
      _counter,
      widget.value,
      (dynamic value) => IntTween(begin: value),
    ) as IntTween;
  }
}

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
        context: context,
      ),
    );
  }
}

class SpeedometerPainter extends CustomPainter {
  final double speedFraction;
  final double maxSpeed;
  final BuildContext context;

  SpeedometerPainter(
      {required this.speedFraction,
      required this.maxSpeed,
      required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);
    double startAngle = 3 * pi / 4;
    double sweepAngle = 3 * pi / 2;
    double currentAngle = startAngle + (sweepAngle * speedFraction);

    // Draw the background arc
    Paint arcPaint = Paint()
      ..color = Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.2)
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
      ..color = Theme.of(context).primaryColor
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
