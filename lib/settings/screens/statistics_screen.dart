import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/statistics.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  void comformationPopUp(
      BuildContext context, WidgetRef ref, String title, String content) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetStatistics(ref);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void resetStatistics(WidgetRef ref) {
    // Reset lifetime distance and top speed
    ref.read(lifetimeDistanceProvider.notifier).resetValue();
    ref.read(lifetimeTopSpeedProvider.notifier).resetValue();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double lifetimeDistance = ref.watch(lifetimeDistanceProvider);
    double lifetimeTopSpeed = ref.watch(lifetimeTopSpeedProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lifetime Distance: $lifetimeDistance'),
            Text('Lifetime Top Speed: $lifetimeTopSpeed'),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                comformationPopUp(context, ref, 'Reset Statistics',
                    'Are you sure you want to reset your statistics? This action cannot be undone.');
              },
              child: const Text(
                'Reset Statistics',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
