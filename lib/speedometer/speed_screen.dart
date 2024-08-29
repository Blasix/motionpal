import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../settings/logic/bools.dart';
import '../settings/screens/main.dart';
import 'speed_utils.dart';
import 'speedometer.dart';

class LocationServiceWidget extends StatefulWidget {
  const LocationServiceWidget({super.key});

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  // bools later for other files
  bool isDarkMode = false;

  // Tracker variables
  double speed = 0; // M/s
  double totalDistance = 0; // Meters
  // DateTime? startTime;
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
            // startTime ??= DateTime.now();
            totalTime += const Duration(seconds: 1);
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _resetData() {
    setState(() {
      speed = 0;
      totalDistance = 0;
      totalTime = Duration.zero;
      maxSpeed = 0;
      averageSpeed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetData,
        ),
        title: const Text("Speedometer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
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
                    speed: convertSpeed(speed, SettingsLogic.isKMPH).toDouble(),
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
                            SettingsLogic.isKMPH ? "km/h" : "mph",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${convertSpeed(speed, SettingsLogic.isKMPH)}",
                            style: const TextStyle(
                                fontSize: 52, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      (totalDistance.round() > 0)
                          ? Text(
                              "${convertDistance(totalDistance, getDistanceType(SettingsLogic.isKMPH, totalDistance))} ${getDistanceType(SettingsLogic.isKMPH, totalDistance).name}")
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
                      "${convertSpeed(totalTime.inSeconds > 0 ? totalDistance / totalTime.inSeconds : 0, SettingsLogic.isKMPH)} ${SettingsLogic.isKMPH ? "km/h" : "mph"}",
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
                      "${convertSpeed(maxSpeed, SettingsLogic.isKMPH)} ${SettingsLogic.isKMPH ? "km/h" : "mph"}",
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
