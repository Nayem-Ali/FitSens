import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utility/color_utility.dart';

List<String> weekDays = [];

class LineChar extends StatefulWidget {
  List<Map<String, dynamic>> weeklyData;

  LineChar({Key? key, required this.weeklyData}) : super(key: key);

  @override
  State<LineChar> createState() => _LineCharState();
}

class _LineCharState extends State<LineChar> {
  @override
  Widget build(BuildContext context) {
    List<FlSpot> flSpot = [];
    weekDays = widget.weeklyData
        .map((data) => DateFormat.E().format((data['date'] as Timestamp).toDate()))
        .toList();
    for (int i = 0; i < widget.weeklyData.length; i++) {
      flSpot.add(FlSpot(i + 1.0, widget.weeklyData[i]['BPM'] * 1.0));
    }
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: LineChart(
        LineChartData(
          minY: 60,
          maxY: 140,
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: getBottomTitles,
                showTitles: true,
              ),
            ),
          ),
          gridData: const FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: flSpot,
              isCurved: true,
              belowBarData: BarAreaData(
                show: true,
                color: ColorCode.primaryColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  String temp = (value - value.toInt()).toStringAsFixed(1);
  double k = double.parse(temp);
  if (value == 0 || k > 0) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: const Text(""),
    );
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: Text(weekDays[value.toInt() - 1]),
  );
}
