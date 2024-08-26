import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationServiceWidget extends StatefulWidget {
  const LocationServiceWidget({super.key});

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  // bools later for other files
  bool isKMPH = true;
  bool isDarkMode = false;

  Location location = Location();
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    _initializeLocationService();
  }

  Future<void> _initializeLocationService() async {
    try {
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      location.changeSettings(accuracy: LocationAccuracy.high, interval: 10);

      // Listen to location updates
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _locationData = currentLocation;
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  int _convertSpeed(double speedInMetersPerSecond) {
    if (isKMPH) {
      return (speedInMetersPerSecond * 3.6)
          .round(); // Convert to kilometers per hour
    } else {
      return (speedInMetersPerSecond * 2.23694)
          .round(); // Convert to miles per hour
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: _locationData == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Speedometer(
                            speed: _convertSpeed(_locationData!.speed!) * 1.0,
                            maxSpeed: 240,
                            isKMPH: isKMPH),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${_convertSpeed(_locationData!.speed!)}",
                                  style: const TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Text("Distance")
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${_convertSpeed(_locationData!.speed!)} ${isKMPH ? "km/h" : "mph"}",
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Max Speed",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${_convertSpeed(_locationData!.speed!)} ${isKMPH ? "km/h" : "mph"}",
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

class Speedometer extends StatelessWidget {
  final double speed;
  final double maxSpeed;
  final bool isKMPH;

  const Speedometer({
    super.key,
    required this.speed,
    required this.maxSpeed,
    required this.isKMPH,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // Adjust size according to your design
      painter: SpeedometerPainter(speed: speed, maxSpeed: maxSpeed),
    );
  }
}

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
