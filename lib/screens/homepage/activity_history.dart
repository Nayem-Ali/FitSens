import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/widgets/barchart.dart';
import 'package:finessapp/widgets/linechart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: _appBar(context),
      body: Column(
        children: [

          Expanded(
            child: Column(
              children: [
                const Text("Step Activity"),
                Expanded(
                  child: MyBarChart(
                    weeklyData: stepActivity.length > 7 ? weeklyStepActivity : stepActivity,
                  ),
                ),
                const Text("Water Intake Activity"),
                Expanded(
                  child: MyBarChart(
                    weeklyData: waterIntakeActivity.length > 7
                        ? weeklyWaterIntakeActivity
                        : waterIntakeActivity,
                  ),
                ),
                const Text("Heart BPM"),
                Expanded(
                  child: LineChar(
                    weeklyData: heartBPM.length > 7 ? weeklyHeartBPM : heartBPM,
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
