import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/utility/color.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBarChart extends StatefulWidget {
  List<Map<String, dynamic>> weeklyData;

  MyBarChart({Key? key, required this.weeklyData}) : super(key: key);

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: 140,
            width: Get.width,
            child: BarChart(
              BarChartData(
                maxY: 100,
                minY: 0,
                gridData: const FlGridData(
                  // show: false,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getBottomTitles,
                    ),
                  ),
                ),
                barGroups: widget.weeklyData
                    .map(
                      (weekDay) => BarChartGroupData(
                        x: (weekDay['date'] as Timestamp).toDate().weekday,
                        barRods: [
                          BarChartRodData(
                            toY: weekDay['percentage'] * 1.0,
                            width: 20,
                            borderRadius: BorderRadius.circular(10),
                            gradient: primaryGradient,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                                color: ColorCode.secondaryColor2
                            )
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  Widget text;
  switch (value.toInt()) {
    case 1:
      text = const Text("Mon");
      break;
    case 2:
      text = const Text("Tue");
      break;
    case 3:
      text = const Text("Wed");
      break;
    case 4:
      text = const Text("Thu");
      break;
    case 5:
      text = const Text("Fri");
      break;
    case 6:
      text = const Text("Sat");
      break;
    default:
      text = const Text("Sun");
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
