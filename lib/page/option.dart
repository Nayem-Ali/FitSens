import 'package:finessapp/page/diet_planner/diet_plan.dart';
import 'package:finessapp/page/feed/home_page.dart';
import 'package:finessapp/page/heart_bpm.dart';
import 'package:finessapp/page/sleep/sleep_home.dart';
import 'package:finessapp/page/widgets/button.dart';
import 'package:finessapp/page/workout/workout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Option extends StatelessWidget {
  const Option({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              label: 'Workout Tracker',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Workout()),
                );
              },
              width: 350,
              height: 60,
              fontSize: 16,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
                label: "Sleep Tracker",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SleepHome()),
                  );
                },
                width: 350,
                height: 60,
                fontSize: 16),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              label: "Heart BPM",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HeartBPM()),
                );
              },
              width: 350,
              height: 60,
              fontSize: 16,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              label: "Diet Planner",
              onTap: () {
                Get.to(() => const DietPlanner());
              },
              width: 350,
              height: 60,
              fontSize: 16,
            ),
            const SizedBox(
              height: 20,
            ),
            MyButton(
              label: "Feed",
              onTap: () {
                Get.to(() => const HomePage());
              },
              width: 350,
              height: 60,
              fontSize: 16,
            )
          ],
        ),
      ),
    );
  }
}
