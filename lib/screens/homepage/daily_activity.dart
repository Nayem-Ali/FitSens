import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:finessapp/page/step/step_counter_backend.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyActivity extends StatefulWidget {
  const DailyActivity({Key? key}) : super(key: key);

  @override
  State<DailyActivity> createState() => _DailyActivityState();
}

class _DailyActivityState extends State<DailyActivity> {
  StepCounterBackend stepCounterBackend = StepCounterBackend();
  TextEditingController water = TextEditingController();
  TextEditingController steps = TextEditingController();
  int goalSteps = 0;
  int goalWaterIntake = 0;
  int totalSteps = Get.arguments;
  double averageSpeed = 0;
  int totalIntake = 0;
  DateTime dateTime = DateTime.now();
  static List<AlarmSettings> alarm = [];

  final formKey = GlobalKey<FormState>();

  addAlarm() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ) as TimeOfDay;
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime: DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute),
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'FitSens',
      notificationBody: 'Time for drink water',
      enableNotificationOnKill: true,
    );
    alarm.clear();
    alarm.add(alarmSettings);
    await Alarm.set(alarmSettings: alarmSettings);
    print(alarmSettings.id);
    setState(() {});
  }

  showDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: water,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return "Cant left empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(label: Text("Glass of Water")),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: steps,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return "Cant left empty";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(label: Text("Number of Steps")),
                    )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [ColorCode.primaryColor2, ColorCode.primaryColor1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setInt("goalSteps", int.parse(steps.text.trim()));
                    sp.setInt("goalWater", int.parse(water.text.trim()));
                    getGoal();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 5,
                      // minimumSize: Size(
                      //   screenSize.width * 0.8,
                      //   screenSize.height * 0.08,
                      // ),
                      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGoal();
  }

  getGoal() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("waterIntake") == false) {
      sp.setInt("waterIntake", 0);
    }
    // DateTime now = DateTime.now();
    // String formatDate = DateFormat.yMMMMEEEEd().format(now);
    // print(formatDate);
    if (sp.containsKey("goalSteps")) {
      goalSteps = sp.getInt("goalSteps") ?? 0;
      steps.text = goalSteps.toString();
    }
    if (sp.containsKey("goalWater")) {
      goalWaterIntake = sp.getInt("goalWater") ?? 0;
      water.text = goalWaterIntake.toString();
    }
    List<String> avgSpeed = sp.getStringList('averageSpeed') ?? [];
    // print("Avg Speed: ${avgSpeed}");
    totalIntake = sp.getInt('waterIntake') ?? 0;
    if (avgSpeed.isNotEmpty) {
      for (String speed in avgSpeed) {
        averageSpeed += double.parse(speed);
      }
      averageSpeed /= avgSpeed.length;
    }

    setState(() {});
    print(stepCounterBackend.steps);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text(
          "Daily Activity",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height,
          child: Column(
            children: [
              Container(
                height: screenSize.height * 0.2,
                margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.05,
                  vertical: Get.height * 0.01,
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [ColorCode.primaryColor2, ColorCode.primaryColor1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today Target",
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          IconButton(
                            onPressed: showDialog,
                            icon: const Icon(
                              Icons.add,
                              size: 35,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: screenSize.height * 0.08,
                            width: screenSize.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/onBoarding/glass.png"),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Water Intake"),
                                      Text("$goalWaterIntake Glasses")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: screenSize.height * 0.08,
                            width: screenSize.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/onBoarding/boots.png"),
                                  const SizedBox(width: 12),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Steps"),
                                      Text("$goalSteps"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Text(
                "Steps Activity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              // SizedBox(height: Get.height * 0.01),
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
                          value: totalSteps / (int.tryParse(steps.text) ?? 1),
                          color: ColorCode.primaryColor1,
                          backgroundColor: ColorCode.secondaryColor1,
                          strokeWidth: 10,
                        ),
                      ),
                      Text(
                        "$totalSteps\nSteps",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Distant Walked: ${((totalSteps * 0.762) / 1000).toStringAsFixed(2)} kM",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      Text(
                        "Average Speed: ${(averageSpeed*3.6).toStringAsFixed(2)} km/h",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      Text(
                        "Calorie Burned: ${(totalSteps * 0.04).toStringAsFixed(2)} kCal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                      Text(
                        "Step Progress: ${(totalSteps / (int.tryParse(steps.text) ?? 1) * 100).toStringAsFixed(2)}% ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          // color: ColorCode.primaryColor1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // SizedBox(height: Get.height * 0.01),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   child: BarChar(),
              // ),
              const Divider(),
              const Text(
                "Water Intake Activity",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
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
                          value: totalIntake / (int.tryParse(water.text) ?? 1),
                          color: ColorCode.primaryColor1,
                          backgroundColor: ColorCode.secondaryColor1,
                          strokeWidth: 10,
                        ),
                      ),
                      Text(
                        "$totalIntake\n Glasses",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          totalIntake = sp.getInt('waterIntake') ?? 0;
                          totalIntake += 1;
                          sp.setInt('waterIntake', totalIntake);
                          setState(() {});
                        },
                        style: OutlinedButton.styleFrom(minimumSize: Size(Get.width * 0.45, 40)),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Water'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          SharedPreferences sp = await SharedPreferences.getInstance();
                          totalIntake = sp.getInt('waterIntake') ?? 0;
                          if (totalIntake > 0) {
                            totalIntake -= 1;
                          }
                          sp.setInt('waterIntake', totalIntake);
                          setState(() {});
                        },
                        style: OutlinedButton.styleFrom(minimumSize: Size(Get.width * 0.45, 40)),
                        icon: const Icon(Icons.remove),
                        label: const Text('Reduce Water'),
                      )
                    ],
                  )
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  addAlarm();
                },
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(Get.width * 0.8, 40),
                    backgroundColor: ColorCode.primaryColor1),
                icon: const Icon(Icons.alarm),
                label: const Text("Add Drink Alarm"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: alarm.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${alarm[index].dateTime}'),
                      subtitle: Text('${alarm[index].id}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
