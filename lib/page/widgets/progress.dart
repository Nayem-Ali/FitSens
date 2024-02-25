
import 'package:flutter/material.dart';

import '../../services/db_service.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../../widgets/barchart.dart';

class ProgressBar extends StatefulWidget {

  final Gradient? gradient;
  final Gradient? gradient1;
  final Color? color;
  final Color? t_color;
  final Color? t1_color;
  final double? height;
  const ProgressBar({Key? key,this.gradient, this.color, this.t_color, this.t1_color, this.gradient1,  this.height}) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {

  DBService dbService = DBService();
  List<Map<String, dynamic>> sleepData = [];


  getData() async {
    try{
      sleepData = await dbService.getSleepDataForChart();
      sleepData.sort((a, b) => a['date'].compareTo(b['date']));
      if (sleepData.length > 7) {
        sleepData = sleepData.sublist(sleepData.length - 7, sleepData.length);
      }

    }catch(e){
      print(e);
    }
    setState(() {});
    print(sleepData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      padding:
      EdgeInsets.fromLTRB(30 * fem, 5 * fem, 28 * fem, 20 * fem),
      width: 375 * fem,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        color: widget.color,
      ),
      child: MyBarChart(weeklyData: sleepData),
    );
  }
}
