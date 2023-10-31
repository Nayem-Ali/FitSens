import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/utility/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../utility/color_utility.dart';
import '../../utility/utils.dart';

class IdealSleep extends StatefulWidget {
  const IdealSleep({Key? key}) : super(key: key);

  @override
  State<IdealSleep> createState() => _IdealSleepState();
}

class _IdealSleepState extends State<IdealSleep> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: screenSize.height * .26,
              width: screenSize.width,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      left: BorderSide(width: 1),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  //barTouchData: BarTouchData(enabled: false),
                  minY: 0,
                  maxY: 24,
                  groupsSpace: 4,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(width: 45),
                          Text("0-3M"),
                          Text("4-12M"),
                          Text("1-2Y"),
                          Text("3-5Y"),
                          Text("6-12Y"),
                          Text("13-18Y"),
                          Text("18Y+"),
                          SizedBox(width: 0),
                        ],
                      ),
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 17,
                          width: 25,
                          color: ColorCode.primaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 16,
                          width: 25,
                          color: ColorCode.secondaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: 14,
                          width: 25,
                          color: ColorCode.primaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: 13,
                          width: 25,
                          color: ColorCode.secondaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(
                          toY: 12,
                          width: 25,
                          color: ColorCode.primaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 6,
                      barRods: [
                        BarChartRodData(
                          toY: 10,
                          width: 25,
                          color: ColorCode.secondaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 7,
                      barRods: [
                        BarChartRodData(
                          toY: 7,
                          width: 25,
                          color: ColorCode.primaryColor2,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'fig: Ideal hours of sleep',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 15,),
            Text(
              'Recommended Sleep Times By Age Group',
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Container(
              //width: MediaQuery.of(context).size.width, // Adjust the width as needed
              margin: const EdgeInsets.only(left: 15, right: 10, top: 16),
              child: Card(
                elevation: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Center(
                    child: DataTable(
                      columnSpacing: 10,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => ColorCode.primaryColor2,
                        // Set the background color for the title row
                      ),
                      border: TableBorder.all(),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Age',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Group',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Age',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Range',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  ' Recommended',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'hours of sleep',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      rows: const <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Newborns')),
                            DataCell(Text('0-3 months')),
                            DataCell(Text('14-17 hours (including naps)')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Infant')),
                            DataCell(Text('4-12 months')),
                            DataCell(Text('12-16 hours (including naps)')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Toddler')),
                            DataCell(Text('1-2 years')),
                            DataCell(Text('11-14 hours (including naps)')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Preschool')),
                            DataCell(Text('3-5 years')),
                            DataCell(Text('10-13 hours (including naps)')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('School-age')),
                            DataCell(Text('6-12 years')),
                            DataCell(Text('9-12 hours')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Teen')),
                            DataCell(Text('13-18 years')),
                            DataCell(Text('8-10 hours')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(Text('Adult')),
                            DataCell(Text('18 years and older')),
                            DataCell(Text('7 hours or more')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

_appBar(BuildContext context) {
  return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "Ideal Hours for Sleep",
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 20,
          color: Colors.black,
        ),
      ),
      actions: const [
        SizedBox(
          width: 45,
        ),
      ]);
}
