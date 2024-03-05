import 'package:finessapp/services/db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:intl/intl.dart';

import '../utility/color_utility.dart';
import '../utility/utils.dart';

class HeartBPM extends StatefulWidget {
  const HeartBPM({super.key});

  @override
  State<HeartBPM> createState() => _HeartBPMState();
}

class _HeartBPMState extends State<HeartBPM> {
  DBService dbService = DBService();
  List<SensorValue> data = [];
  List<SensorValue> bpmData = [];
  int bpmValue = 0;
  bool switchKey = false;
  late DateTime start;
  bool isInitialized = false;
  int sec = 0;
  int count = 0;

  void saveData() async {
    String date = DateFormat.yMMMd().format(start);
    Map<String, dynamic> data = {"BPM": bpmValue, "date": start, "id": date};
    await dbService.addBPMData(data);
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Heart BPM",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 21,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cover both the camera and flash with your finger",
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  switchKey
                      ? HeartBPMDialog(
                          context: context,
                          onRawData: (value) {
                            // print(data.length);
                            if (isInitialized == false) {
                              isInitialized = true;
                              start = value.time;
                            }
                            data.add(value);
                            sec = value.time.difference(start).inSeconds.abs();
                            setState(() {
                              if ((value.time.difference(start).inMinutes).abs() == 1) {
                                saveData();
                                switchKey = !switchKey;
                                isInitialized = false;
                              } else if (data.length >= 100) {
                                data.removeAt(0);
                              }
                            });
                          },
                          onBPM: (value) => setState(() {
                            if (bpmData.length >= 100) bpmData.removeAt(0);
                            bpmData.add(SensorValue(
                                value: value.toDouble(), time: DateTime.now()));
                            if (bpmData.last.value > 120 ||
                                bpmData.last.value < 70) {
                              // double avg = 0;
                              // bpmData.map((e) => avg += e.value);
                              // print(avg/bpmData.length);
                              // bpmValue = avg.toInt();
                            } else {
                              bpmValue = bpmData.last.value.toInt();
                            }
                          }),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            setState(() {
                              data.clear();
                              switchKey = !switchKey;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              backgroundColor: ColorCode.primaryColor1,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(120, 40)),
                          child: Text(
                            "Measure",
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  // BPMChart(data)
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: ColorCode.primaryColor1,
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 30,
                      value: sec / 60,
                    ),
                    Text(
                      "${(sec / 60 * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text("Time: ${sec}s"),
              Text(
                "Heart Beat Rate: ${bpmValue.toStringAsFixed(0).toString()}",
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (switchKey)
                ElevatedButton(
                  onPressed: () {
                    saveData();
                    setState(() {
                      switchKey = !switchKey;
                      isInitialized = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    backgroundColor: ColorCode.primaryColor1,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text("Turn off"),
                ),
              if (data.length > 5)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  child: BPMChart(data),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
