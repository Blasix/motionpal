import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speedometer App'),
        ),
        body: const LocationServiceWidget(),
      ),
    );
  }
}

class LocationServiceWidget extends StatefulWidget {
  const LocationServiceWidget({super.key});

  @override
  State<LocationServiceWidget> createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  // bools later for other files
  bool isKMPH = false;
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
    return Center(
      child: _locationData == null
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Location: ${_locationData!.latitude}, ${_locationData!.longitude}'),
                Text("Speed: ${_convertSpeed(_locationData!.speed!)} km/h"),
              ],
            ),
    );
  }
}
