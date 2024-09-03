import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../settings/logic/bools.dart';
import '../settings/screens/settings.dart';
import 'speed_chart.dart';
import 'speedometer.dart';

class LocationServiceWidget extends StatefulWidget {
  const LocationServiceWidget({super.key});

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  // Tracker variables
  double speed = 0; // M/s
  double totalDistance = 0; // Meters
  // DateTime? startTime;
  Duration totalTime = Duration.zero; // Seconds
  double maxSpeed = 0; // M/s
  double averageSpeed = 0; // M/s

  final List<FlSpot> _speedData = [];

  // Location location = Location();

  @override
  void initState() {
    super.initState();
    _initializeLocationService();
  }

  Future<void> _initializeLocationService() async {
    try {
      // Ensure location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Location Service Disabled'),
                content: const Text(
                    'Please enable location services to use this app.'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openLocationSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            });
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next step to handle this
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Location Permission Denied'),
                content: const Text(
                    'Please enable location permissions to use this app.'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Open Settings'),
                  ),
                ],
              );
            });
        return;
      }

      Geolocator.getPositionStream(locationSettings: const LocationSettings())
          .listen((Position? position) {
        if (position == null) {
          speed = 0;
          return;
        }
        speed = position.speed;
        totalDistance += speed;
        maxSpeed = max(maxSpeed, speed);
        _speedData.add(FlSpot(_speedData.length.toDouble(), speed));
        if (speed > 0) {
          // startTime ??= DateTime.now();
          totalTime += const Duration(seconds: 1);
        }
      });

      // location.changeSettings(accuracy: LocationAccuracy.high);

      // // Listen to location updates
      // location.onLocationChanged.listen((LocationData currentLocation) {
      //   setState(() {
      //     speed = currentLocation.speed ?? 0;
      //     totalDistance += speed;
      //     maxSpeed = max(maxSpeed, speed);
      //     _speedData.add(FlSpot(_speedData.length.toDouble(), speed));
      //     if (speed > 0) {
      //       // startTime ??= DateTime.now();
      //       totalTime += const Duration(seconds: 1);
      //     }
      //   });
      // });
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
      _speedData.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
                child: SingleChildScrollView(
              child: SettingsLogic.isChart
                  ? SpeedChartWidget(
                      speedData: _speedData,
                    )
                  : SpeedometerWidget(
                      speed: speed,
                      totalDistance: totalDistance,
                      totalTime: totalTime,
                      maxSpeed: maxSpeed,
                    ),
            )),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.refresh),
                    onPressed: _resetData,
                  ),
                  IconButton(
                    iconSize: 32,
                    icon: SettingsLogic.isChart
                        ? const Icon(Icons.speed)
                        : const Icon(Icons.show_chart_rounded),
                    onPressed: () {
                      setState(() {
                        SettingsLogic.isChart = !SettingsLogic.isChart;
                      });
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
