import 'dart:async';

import 'package:finessapp/services/db_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepCounterBackend {
  int steps = 0;
  late DateTime lastDay;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  DBService dbService = DBService();
  double speed = 0;
  List<String> averageSpeed = [];

  requestPermission() async {
    var status = await Permission.activityRecognition.request();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    if (status.isGranted) {
      // Permission granted, start listening to step count
      initPlatformState();
    } else {
      status = await Permission.activityRecognition.request();
    }
  }

  initialStepsSetter(StepCount event) async {
    /// for the first time when user install app
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (sp.containsKey("initial") == false) {
      // print("initial step setter");
      sp.setInt("initial", event.steps);
      DateTime toDay = DateTime.now();
      lastDay = DateTime(toDay.year, toDay.month, toDay.day, 0, 0);
      sp.setString("lastDay", lastDay.toString());
    }
  }

  void onStepCount(StepCount event) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await initialStepsSetter(event);
    int initialSteps = sp.getInt("initial") ?? 0;

    ///Update initial steps if system is reboot
    if (event.steps < initialSteps) {
      sp.setInt("initial", event.steps);
      initialSteps = sp.getInt("initial") ?? 0;
      // print("Update");
    }

    ///Update initial steps after 24 hours
    String getLastDate = sp.getString("lastDay") ?? "";
    DateTime lastInitializedData = DateTime.tryParse(getLastDate) ?? DateTime.now();

    steps = event.steps - initialSteps;
    int target = sp.getInt("goalSteps") ?? 0;
    String lastDate = sp.getString('lastDay') ?? "";
    // print(lastDate.substring(0, lastDate.indexOf(" ")));

    Map<String, dynamic> stepData = {
      "id": lastDate.substring(0, lastDate.indexOf(" ")),
      "steps": event.steps - initialSteps,
      "date": DateTime.parse(lastDate),
      "goal": (event.steps - initialSteps) >= target ? "Complete" : "Incomplete",
      "target": target,
      "percentage": ((event.steps - initialSteps) / target) > 1
          ? 100
          : (((event.steps - initialSteps) / target) * 100).toInt(),
    };
    await dbService.addSteps(stepData);

    if (event.timeStamp.difference(lastInitializedData).inHours >= 24) {
      sp.setInt("initial", event.steps);
      sp.setInt("waterIntake", 0);
      DateTime toDay = DateTime.now();
      lastDay = DateTime(toDay.year, toDay.month, toDay.day, 0, 0);
      sp.setString("lastDay", lastDay.toString());
      averageSpeed.clear();
      sp.setStringList("averageSpeed", averageSpeed);
    }

    Geolocator.getPositionStream().listen((position) {
      speed = position.speed;
      averageSpeed = sp.getStringList("averageSpeed") ?? [];
      if (speed > 0.001) {
        averageSpeed.add(speed.toString());
      }
      sp.setStringList("averageSpeed", averageSpeed);
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {}

  void onPedestrianStatusError(error) {}

  void onStepCountError(error) {}

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }
}
