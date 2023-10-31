import 'package:finessapp/page/workout/widgets/workout_container.dart';
import 'package:finessapp/page/workout/workout_schedule.dart';
import 'package:flutter/material.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../sleep/sleep_schedule.dart';
import '../sleep/widgets/sleep_container.dart';
import '../widgets/daily_container.dart';
import '../widgets/progress.dart';
import 'ab.dart';
import 'add_schedule.dart';
import 'fullbody.dart';
import 'lower_body.dart';

class Workout extends StatelessWidget {
  const Workout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Stack(children: [
         ProgressBar(
          t_color: Colors.white,
          color: primaryClr,
          t1_color: Colors.white,
          gradient1: secondaryGradient, height: 385*fem,
        ),
        SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40 * fem),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 220 * fem),
            height: 700 * fem,
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
      ]),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: primaryClr,
        title: Center(
          child: Text(
            "Workout Tracker",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
            color: Colors.white,
          ),
        ),
        actions: const [
          SizedBox(
            width: 45,
          ),
        ]);
  }
}
