import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'speed_utils.dart';
import 'speedometer.dart';

class LocationServiceWidget extends StatefulWidget {
  const LocationServiceWidget({super.key});

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  // bools later for other files
  bool isKMPH = false;
  bool isDarkMode = false;

  // Tracker variables
  double speed = 0; // M/s
  double totalDistance = 0; // Meters
  Duration totalTime = Duration.zero; // Seconds
  double maxSpeed = 0; // M/s
  double averageSpeed = 0; // M/s

  Location location = Location();

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

      location.changeSettings(accuracy: LocationAccuracy.high);

      // Listen to location updates
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          speed = currentLocation.speed ?? 0;
          totalDistance += speed;
          maxSpeed = max(maxSpeed, speed);
          if (speed > 0) {
            totalTime += const Duration(seconds: 1);
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Speedometer(
                      speed: convertSpeed(speed, isKMPH) * 1.0,
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
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${convertSpeed(speed, isKMPH)}",
                            style: const TextStyle(
                                fontSize: 52, fontWeight: FontWeight.bold),
                          ),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${convertSpeed(maxSpeed, isKMPH)} ${isKMPH ? "km/h" : "mph"}",
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
