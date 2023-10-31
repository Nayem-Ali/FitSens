import 'package:finessapp/utility/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utility/color_utility.dart';

class LineChar extends StatelessWidget {
  const LineChar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(

      height: screenSize.height * .3,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 10,right: 20,),
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: 7,
          minY: 60,
          maxY: 100,
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 14),
                  Text("Sat"),
                  Text("Sun"),
                  Text("Mon"),
                  Text("Tue"),
                  Text("Wed"),
                  Text("Thu"),
                  Text("Fri"),
                  //SizedBox(width: 0),
                ],
              ),
            ),
          ),
          gridData: const FlGridData(
              drawHorizontalLine: true, drawVerticalLine: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(1, 85),
                FlSpot(2, 92),
                FlSpot(3, 75),
                FlSpot(4, 79.5),
                FlSpot(5, 84),
                FlSpot(6, 79),
                FlSpot(7, 84),
              ],
              //isCurved: true,

              // dotData: const FlDotData(show: false),
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
