import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logic/bools.dart';
import '../logic/themes.dart';
import '../widgets/buttons.dart';
import 'statistics_screen.dart';

List<bool> _getThemeModeBools(ThemeMode selectedThemeMode) {
  return List.generate(ThemeMode.values.length, (index) {
    return index == selectedThemeMode.index;
  });
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // Color _locationLedColor = Colors.grey;
  // String _locationLedText = 'Loading...';

  // @override
  // void initState() {
  //   _updateLocationLedColor();
  //   super.initState();
  // }

  // Future<void> _updateLocationLedColor() async {
  //   try {
  //     Location location = Location();

  //     bool serviceEnabled;
  //     PermissionStatus permissionGranted;

  //     serviceEnabled = await location.serviceEnabled();
  //     if (!serviceEnabled) {
  //       setState(() {
  //         _locationLedColor = const Color.fromARGB(255, 255, 17, 0);
  //         _locationLedText = 'Location service is disabled';
  //       });
  //       return;
  //     }

  //     permissionGranted = await location.hasPermission();
  //     if (permissionGranted != PermissionStatus.granted &&
  //         permissionGranted != PermissionStatus.grantedLimited) {
  //       setState(() {
  //         _locationLedColor = Colors.orange;
  //         _locationLedText = 'Location permission is denied';
  //       });
  //       return;
  //     }

  //     setState(() {
  //       _locationLedColor = const Color.fromARGB(255, 0, 255, 8);
  //       _locationLedText = 'Location service is enabled';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _locationLedColor = const Color.fromARGB(255, 255, 17, 0);
  //       _locationLedText = 'Error: $e';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode themeMode = ref.watch(themeModeProvider);
    bool isKMPH = ref.watch(isKMPHProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            SettingsButton(
              icon: const Icon(
                SimpleIcons.github,
                size: 30,
              ),
              text: 'Github Repo',
              onPressed: (context) async {
                await launchUrl(
                    Uri.parse('https://github.com/Blasix/speedometer'));
              },
            ),
            SettingsButton(
              icon: const Icon(
                Icons.bar_chart,
                size: 30,
              ),
              text: 'Statistics',
              onPressed: (context) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const StatisticsScreen();
                  },
                ));
              },
            ),
            // SettingsButton(
            //   icon: Container(
            //     margin: const EdgeInsets.all(3),
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: _locationLedColor,
            //       boxShadow: [
            //         if (!(_locationLedColor == Colors.grey))
            //           BoxShadow(
            //             color: _locationLedColor.withOpacity(0.8),
            //             spreadRadius: 3,
            //             blurRadius: 3,
            //           ),
            //       ],
            //     ),
            //     width: 26,
            //     height: 26,
            //   ),
            //   text: 'Location Service',
            //   onPressed: (context) {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: Text(_locationLedText),
            //           actions: [
            //             TextButton(
            //               child: const Text('OK'),
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
            //settings switch button for changing distance between km and mph
            SettingsToggleButtons(
              icon: Icons.speed,
              text: 'Speed',
              onPressed: (i) {
                if (i == 0) {
                  ref.read(isKMPHProvider.notifier).updateIsKMPH(true);
                } else {
                  ref.read(isKMPHProvider.notifier).updateIsKMPH(false);
                }
              },
              isSelected: [isKMPH, !isKMPH],
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("km/h"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("mph"),
                )
              ],
            ),

            SettingsToggleButtons(
                icon: Theme.of(context).brightness == Brightness.light
                    ? Icons.wb_sunny_outlined
                    : Icons.dark_mode,
                text: "Theme",
                isSelected: _getThemeModeBools(themeMode),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('System'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Light'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Dark'),
                  ),
                ],
                onPressed: (index) {
                  ref
                      .read(themeModeProvider.notifier)
                      .updateThemeMode(ThemeMode.values[index]);
                })
          ],
        ),
      ),
    );
  }
}
