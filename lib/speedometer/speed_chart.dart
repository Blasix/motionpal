import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:motionpal/settings/logic/bools.dart';

import 'speed_utils.dart';

class SpeedChartWidget extends StatelessWidget {
  final List<FlSpot> speedData;

  const SpeedChartWidget({super.key, required this.speedData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> modifiedSpeedData = SettingsLogic.isKMPH
        ? speedData
            .map(
              (spot) => FlSpot(spot.x, (spot.y * 3.6)
                  // .roundToDouble(),
                  ),
            )
            .toList()
        : speedData
            .map(
              (spot) => FlSpot(spot.x, (spot.y * 2.23694)
                  // .roundToDouble(),
                  ),
            )
            .toList();

    // if (modifiedSpeedData.length > 60) {
    //   final List<FlSpot> combinedSpeedData = [];
    //   for (int i = 0; i < modifiedSpeedData.length - 5; i += 5) {
    //     final sublist = modifiedSpeedData.sublist(i, i + 5);
    //     final combinedSpot = FlSpot(
    //       sublist.first.x,
    //       sublist.map((spot) => spot.y).reduce((a, b) => a + b) /
    //           sublist.length,
    //     );
    //     combinedSpeedData.add(combinedSpot);
    //   }
    //   modifiedSpeedData = combinedSpeedData;
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
            aspectRatio: 1, child: SpeedChart(speedData: modifiedSpeedData)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  "Min",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '${modifiedSpeedData.isNotEmpty ? modifiedSpeedData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) : 0} ${SettingsLogic.isKMPH ? 'km/h' : 'mph'}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Avg',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '${modifiedSpeedData.isNotEmpty ? (modifiedSpeedData.map((spot) => spot.y).reduce((a, b) => a + b) / modifiedSpeedData.length).toStringAsFixed(2) : 0} ${SettingsLogic.isKMPH ? 'km/h' : 'mph'}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Max',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  '${modifiedSpeedData.isNotEmpty ? modifiedSpeedData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b).toStringAsFixed(2) : 0} ${SettingsLogic.isKMPH ? 'km/h' : 'mph'}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SpeedChart extends StatelessWidget {
  final List<FlSpot> speedData;

  const SpeedChart({super.key, required this.speedData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(
                  strokeWidth: 4,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Colors.transparent,
                    ],
                  ),
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 8,
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 0,
                      strokeColor: Theme.of(context).primaryColor,
                    );
                  },
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots
                  .map(
                    (touchedSpot) => LineTooltipItem(
                      '${touchedSpot.y.toStringAsFixed(2)} ${SettingsLogic.isKMPH ? 'km/h' : 'mph'}',
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  .toList();
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: speedData.isNotEmpty ? speedData.last.x : 1,
        minY: speedData.isNotEmpty
            ? (speedData
                    .map((spot) => spot.y)
                    .reduce((a, b) => a < b ? a : b)) *
                0.9
            : 0,
        maxY: speedData.isNotEmpty
            ? (speedData
                    .map((spot) => spot.y)
                    .reduce((a, b) => a > b ? a : b)) *
                1.1
            : 1,
        lineBarsData: [
          LineChartBarData(
            shadow: Shadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 4,
            ),
            belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0),
                    Theme.of(context).primaryColor.withOpacity(0),
                  ],
                )),
            dotData: const FlDotData(show: false),
            spots: speedData,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 4,
          ),
        ],
      ),
    );
  }
}
