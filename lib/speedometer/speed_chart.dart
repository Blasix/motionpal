import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SpeedChartWidget extends StatelessWidget {
  final List<FlSpot> speedData;

  const SpeedChartWidget({super.key, required this.speedData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: speedData.isNotEmpty ? speedData.last.x : 1,
        minY: 0,
        maxY: speedData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: speedData,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
