import 'package:finessapp/page/workout/widgets/workout_container.dart';
import 'package:finessapp/page/workout/workout_schedule.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/widgets/barchart.dart';
import 'package:finessapp/widgets/linechart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';

import '../widgets/daily_container.dart';
import '../widgets/progress.dart';
import 'ab.dart';

import 'fullbody.dart';
import 'lower_body.dart';

class Workout extends StatefulWidget {
  const Workout({Key? key}) : super(key: key);

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  DBService dbService = DBService();
  List<Map<String, dynamic>> workoutData = [];

  getData() async {
    workoutData = await dbService.getWorkoutData();
    workoutData.sort((a, b) => a['date'].compareTo(b['date']));
    if (workoutData.length > 7) {
      workoutData =
          workoutData.sublist(workoutData.length - 7, workoutData.length);
    }
    setState(() {});
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(

        children: [

          const SizedBox(height: 20,),
          Flexible(child: MyBarChart(weeklyData: workoutData)),
          const SizedBox(height: 20,),

          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40 * fem),
                  color: Colors.white,
                ),
                //margin: EdgeInsets.only(top: 220 * fem),
                height: 650 * fem,
                width: 375 * fem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5 * fem,
                        width: 50 * fem,
                        margin: EdgeInsets.fromLTRB(
                            133 * fem, 5 * fem, 134 * fem, 2 * fem),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50 * fem),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    DailyContainer(
                      title: "Daily Workout Schedule",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WorkoutSchedule()),
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          25 * fem, 0 * fem, 30 * fem, 30 * fem),
                      child: Text(
                        "What Do You Want to Train",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 17 * ffem,
                          fontWeight: FontWeight.bold,
                          height: 1.5 * ffem / fem,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    WorkoutContainer(
                      title: 'Fullbody Workout',
                      subTitle: '11 Exercises | 32 mins',
                      image: Image.asset('assets/page-1/images/fullbody.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Fullbody()),
                        );
                      },
                    ),
                    WorkoutContainer(
                      title: 'Lowerbody Workout',
                      subTitle: '12 Exercises | 40 mins',
                      image: Image.asset('assets/page-1/images/lowerbody.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LowerBody()),
                        );
                      },
                    ),
                    WorkoutContainer(
                      title: 'AB Workout',
                      subTitle: '14 Exercises | 25 mins',
                      image: Image.asset('assets/page-1/images/AB.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AB()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Workout Tracker",
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
}
