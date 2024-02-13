// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finessapp/utility/color.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class MyBarChart extends StatefulWidget {
//   const MyBarChart({Key? key}) : super(key: key);
//
//   @override
//   State<MyBarChart> createState() => _MyBarChartState();
// }
//
// class _MyBarChartState extends State<MyBarChart> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: SizedBox(
//             height: 150,
//             width: Get.width,
//             child: BarChart(
//               BarChartData(
//                   maxY: 100,
//                   minY: 0,
//                   gridData: const FlGridData(
//                     show: false,
//                   ),
//                   borderData: FlBorderData(show: false),
//                   titlesData: const FlTitlesData(
//                     show: true,
//                     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: getBottomTitles,
//                       ),
//                     ),
//                   ),
//                   barGroups: weeklyStepData
//                       .map(
//                         (e) => BarChartGroupData(
//                           x: (e['date'] as Timestamp).toDate().weekday,
//                           barRods: [
//                             BarChartRodData(
//                               toY: e['steps'] / e['target'] > 1
//                                   ? 100
//                                   : e['steps'] / e['target'] * 100,
//                               width: 12,
//                               borderRadius: BorderRadius.circular(5),
//                               gradient: primaryGradient,
//
//                             ),
//                           ],
//
//                         ),
//                       )
//                       .toList()),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget getBottomTitles(double value, TitleMeta meta) {
//   Widget text;
//   switch (value.toInt()) {
//     case 1:
//       text = const Text("Mon");
//       break;
//     case 2:
//       text = const Text("Tue");
//       break;
//     case 3:
//       text = const Text("Wed");
//       break;
//     case 4:
//       text = const Text("Thu");
//       break;
//     case 5:
//       text = const Text("Fri");
//       break;
//     case 6:
//       text = const Text("Sat");
//       break;
//     default:
//       text = const Text("Sun");
//       break;
//   }
//   return SideTitleWidget(axisSide: meta.axisSide, child: text);
// }
