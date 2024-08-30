import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../settings/logic/bools.dart';
import '../settings/screens/main.dart';
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
          _speedData.add(FlSpot(_speedData.length.toDouble(), speed));
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
            ),
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
