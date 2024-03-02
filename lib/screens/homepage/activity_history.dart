import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:finessapp/widgets/barchart.dart';
import 'package:finessapp/widgets/linechart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utility/utils.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key}) : super(key: key);

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  DBService dbService = DBService();
  List<Map<String, dynamic>> stepActivity = [];
  List<Map<String, dynamic>> heartBPM = [];
  List<Map<String, dynamic>> waterIntakeActivity = [];
  List<Map<String, dynamic>> weeklyStepActivity = [];
  List<Map<String, dynamic>> weeklyHeartBPM = [];
  List<Map<String, dynamic>> weeklyWaterIntakeActivity = [];
  bool weekly = true;
  DateTime myDate = DateTime.now();
  String id = DateFormat.yMMMd().format(DateTime.now());
  String id2 = DateTime.now().toString().substring(0, 10);

  getData() async {
    stepActivity = await dbService.getSteps();
    heartBPM = await dbService.getBPMData();
    waterIntakeActivity = await dbService.getWaterIntakeData();
    stepActivity.sort((a, b) => a['date'].compareTo(b['date']));
    heartBPM.sort((a, b) => a['date'].compareTo(b['date']));
    waterIntakeActivity.sort((a, b) => a['date'].compareTo(b['date']));
    if (stepActivity.length > 7) {
      weeklyStepActivity = stepActivity.sublist(stepActivity.length - 7, stepActivity.length);
    }
    if (heartBPM.length > 7) {
      weeklyHeartBPM = heartBPM.sublist(heartBPM.length - 7, heartBPM.length);
    }
    if (waterIntakeActivity.length > 7) {
      weeklyWaterIntakeActivity =
          waterIntakeActivity.sublist(waterIntakeActivity.length - 7, waterIntakeActivity.length);
    }

    setState(() {});
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Activity History",
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
            Get.back();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    weekly = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: weekly ? ColorCode.primaryColor2 : Colors.transparent),
                child: const Text("Weekly"),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    weekly = false;
                  });
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: !weekly ? ColorCode.primaryColor2 : Colors.transparent),
                child: const Text("Monthly"),
              ),
            ],
          ),
          weekly
              ? Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: LineChar(
                          weeklyData: heartBPM.length > 7 ? weeklyHeartBPM : heartBPM,
                        ),
                      ),
                      const Text(
                        "Heart BPM",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const Divider(thickness: 2),
                      Expanded(
                        child: MyBarChart(
                          weeklyData: stepActivity.length > 7 ? weeklyStepActivity : stepActivity,
                        ),
                      ),
                      const Text(
                        "Step Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const Divider(thickness: 2),
                      const SizedBox(height: 5),
                      Expanded(
                        child: MyBarChart(
                          weeklyData: waterIntakeActivity.length > 7
                              ? weeklyWaterIntakeActivity
                              : waterIntakeActivity,
                        ),
                      ),
                      const Text(
                        "Water Intake Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                    ],
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatePicker(
                        DateTime(
                            DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
                        initialSelectedDate: DateTime.now(),
                        daysCount: 30,
                        selectionColor: ColorCode.primaryColor2,
                        selectedTextColor: Colors.white,
                        onDateChange: (date) {
                          setState(() {
                            myDate = date;
                            id = DateFormat.yMMMd().format(date);
                            id2 = DateTime(myDate.year, myDate.month, myDate.day, 0, 0)
                                .toString().substring(0, 10);
                          });
                        },
                      ),
                      const Divider(thickness: 2),
                      const Text(
                        "Heart BPM",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const Divider(thickness: 2),
                      for (var bpm in heartBPM)
                        if (bpm['id'] == id)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image(
                                    image: const AssetImage('assets/heart.png'),
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.1,
                                  ),
                                  Text(
                                    '${bpm['BPM']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              const Text(
                                "Beats Per Minute",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              Text(
                                "Measured at ${DateFormat.jm().format((bpm['date'] as Timestamp).toDate())}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                            ],
                          ),
                      const Divider(thickness: 2),
                      const Text(
                        "Step Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const Divider(thickness: 2),
                      for (var step in stepActivity)
                        if (step['id'] == id2)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.09,
                                    width: Get.height * 0.09,
                                    child: CircularProgressIndicator(
                                      value: step['percentage'] / 100,
                                      color: ColorCode.primaryColor1,
                                      strokeWidth: 10,
                                      backgroundColor: ColorCode.secondaryColor1,
                                    ),
                                  ),
                                  Text(
                                    '${step['percentage']}% ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      // color: ColorCode.primaryColor1,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Walked: ${((step['steps'] * 0.762) / 1000).toStringAsFixed(2)} "
                                "kM",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Burned: ${(step['steps'] * 0.04).toStringAsFixed(2)} kCal",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Steps: ${step['steps']} / ${step['target']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                      const Divider(thickness: 2),
                      const Text(
                        "Water Intake",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const Divider(thickness: 2),
                      for (var waterIntake in waterIntakeActivity)
                        if (waterIntake['id'] == id)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.09,
                                    width: Get.height * 0.09,
                                    child: CircularProgressIndicator(
                                      value: waterIntake['percentage'] / 100,
                                      color: ColorCode.primaryColor1,
                                      strokeWidth: 10,
                                      backgroundColor: ColorCode.secondaryColor1,
                                    ),
                                  ),
                                  Text(
                                    '${waterIntake['percentage']}% ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      // color: ColorCode.primaryColor1,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              Text(
                                "Drinks ${waterIntake['todayIntake']} Glasses",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Target ${waterIntake['target']} Glasses",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  // color: ColorCode.primaryColor1,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
