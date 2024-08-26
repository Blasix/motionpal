import 'package:flutter/material.dart';
import 'package:location/location.dart';

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
                            speed: _locationData!.speed!,
                            maxSpeed: 240,
                            isKMPH: isKMPH),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              isKMPH ? "km/h" : "mph",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${_convertSpeed(_locationData!.speed!)}",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
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

  const Speedometer(
      {super.key,
      required this.speed,
      required this.maxSpeed,
      required this.isKMPH});
  @override
  Widget build(BuildContext context) {
    double x = 240;
    double y = 12;
    double percent;
    if (speed != 0) {
      percent = (speed / (maxSpeed + speed)) * x;
    } else {
      percent = 0;
    }
    return Stack(
      children: [
        Container(
          width: x,
          height: y,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: percent,
          height: y,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: speed == 0
                ? BorderRadius.circular(35)
                : const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    bottomLeft: Radius.circular(35),
                  ),
          ),
        ),
      ],
    );
  }
}
