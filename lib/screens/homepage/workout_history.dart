import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utility/color_utility.dart';
import '../../utility/utils.dart';
import '../../widgets/barchart.dart';

class WorkoutHistory extends StatefulWidget {
  const WorkoutHistory({Key? key}) : super(key: key);

  @override
  State<WorkoutHistory> createState() => _WorkoutHistoryState();
}

class _WorkoutHistoryState extends State<WorkoutHistory> {
  DBService dbService = DBService();
  List<Map<String, dynamic>> workoutHistory = [];
  List<Map<String, dynamic>> weeklyWorkoutHistory = [];
  DateTime myDate = DateTime.now();
  String id = DateFormat.yMMMd().format(DateTime.now());

  getData() async {
    workoutHistory = await dbService.getWorkoutData();
    workoutHistory.sort((a, b) => a['date'].compareTo(b['date']));
    if (workoutHistory.length > 7) {
      weeklyWorkoutHistory =
          workoutHistory.sublist(workoutHistory.length - 7, workoutHistory.length);
    }

    setState(() {});
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Workout History",
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
          const Divider(
            thickness: 2,
            color: primaryClr,
          ),
          const Text(
            "Monthly History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              // color: ColorCode.primaryColor1,
            ),
          ),
          const Divider(
            thickness: 2,
            color: primaryClr,
          ),
          SizedBox(height: Get.height * 0.03),
          DatePicker(
            DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day),
            initialSelectedDate: DateTime.now(),
            daysCount: 32,
            selectionColor: ColorCode.primaryColor2,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                myDate = date;
                id = DateFormat.yMMMd().format(date);
              });
            },
          ),
          const SizedBox(height: 30),
          for (var workout in workoutHistory)
            if (workout['id'] == id)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.1,
                        width: Get.height * 0.1,
                        child: CircularProgressIndicator(
                          value: workout['percentage'] / 100,
                          color: ColorCode.primaryColor1,
                          strokeWidth: 10,
                          backgroundColor: ColorCode.secondaryColor1,
                        ),
                      ),
                      Text(
                        '${workout['percentage']}% ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: ColorCode.primaryColor1,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: Get.width * 0.01,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Burned ${workout['complete']} kCal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Target ${workout['target']} kCal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
          const SizedBox(height: 30),
          const Divider(
            thickness: 2,
            color: primaryClr,
          ),
          const Text(
            "Weekly History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              // color: ColorCode.primaryColor1,
            ),
          ),
          const Divider(
            thickness: 2,
            color: primaryClr,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: MyBarChart(
              weeklyData: workoutHistory.length > 7 ? weeklyWorkoutHistory : workoutHistory,
            ),
          ),
        ],
      ),
    );
  }
}
