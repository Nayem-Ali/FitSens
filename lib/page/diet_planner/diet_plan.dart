import 'package:finessapp/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';

class DietPlanner extends StatefulWidget {
  const DietPlanner({Key? key}) : super(key: key);

  @override
  State<DietPlanner> createState() => _DietPlannerState();
}

class _DietPlannerState extends State<DietPlanner> {
  DBService dbService = DBService();
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> userDetails = {};
  late double calorieNeeds;
  late double carbsNeeds;
  late double proteinNeeds;
  late double fatNeeds;
  late int age;

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Diet Planner",
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
    getUserData();
  }

  getUserData() async {
    userDetails = await dbService.getUserInfo();
    DateTime date = DateTime.parse(userDetails['dob']);
    age = DateTime.now().difference(date).inDays ~/ 365;
    dietPlan();
    setState(() {});
  }

  dietPlan() {
    double height = double.parse(userDetails['height']);
    double weight = double.parse(userDetails['weight']);
    double bmr;
    if (userDetails['gender'].toUpperCase() == "MALE") {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    //  Assuming moderate activity level
    calorieNeeds = bmr * 1.55;
    proteinNeeds = (calorieNeeds * 0.25) / 4;
    carbsNeeds = (calorieNeeds * 0.45) / 4;
    fatNeeds = (calorieNeeds * 0.30) / 9;
  }

  // Carbohydrate: 45% x 1,500 calories / 4 calories = 168.75 grams per day
  // Protein: 25% x 1,500 calories / 4 calories =  93.75 grams per day
  // Fat: 30% x 1,500 calories / 9 calories = 50 grams per day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: userDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Based in your height, weight and age"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: Get.height * .1,
                        width: Get.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                            child: Text(
                          "Calorie\n${(calorieNeeds).toStringAsFixed(0)}\ngrams per day",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Get.textScaleFactor * 16,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: Get.height * .1,
                        width: Get.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                            child: Text(
                          "Carbohydrates\n${(carbsNeeds).toStringAsFixed(0)}\ngrams per day",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: Get.textScaleFactor * 16,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: Get.height * .1,
                        width: Get.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                            child: Text(
                              "Protein\n${(proteinNeeds).toStringAsFixed(0)}\ngrams per day",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Get.textScaleFactor * 16,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        height: Get.height * .1,
                        width: Get.width * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                            child: Text(
                              "Fat\n${(fatNeeds).toStringAsFixed(0)}\ngrams per day",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: Get.textScaleFactor * 16,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
