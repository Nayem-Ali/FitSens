import 'package:finessapp/page/diet_planner/make_plan.dart';
import 'package:finessapp/utility/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/db_service.dart';
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
  List<dynamic> dietData = [];
  late int age;
  double calorieNeeds = 1;
  double carbsNeeds = 1;
  double proteinNeeds = 1;
  double fatNeeds = 1;
  double calorieTakes = 0;
  double carbsTakes = 0;
  double proteinTakes = 0;
  double fatTakes = 0;

  getUserData() async {
    userDetails = await dbService.getUserInfo();
    DateTime date = DateTime.parse(userDetails['dob']);
    age = DateTime.now().difference(date).inDays ~/ 365;
    dietData = await dbService.getDietPlan();
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
    if (dietData.isNotEmpty) {
      calorieTakes = (dietData[0]['calorie'] ?? 0) +
          (dietData[1]['calorie'] ?? 0) +
          (dietData[2]['calorie'] ?? 0) +
          (dietData[3]['calorie'] ?? 0);

      carbsTakes = (dietData[0]['calorie'] ?? 0) +
          (dietData[1]['carbs'] ?? 0) +
          (dietData[2]['carbs'] ?? 0) +
          (dietData[3]['carbs'] ?? 0);

      proteinTakes = (dietData[0]['protein'] ?? 0) +
          (dietData[1]['protein'] ?? 0) +
          (dietData[2]['protein'] ?? 0) +
          (dietData[3]['protein'] ?? 0);

      fatTakes = (dietData[0]['fat'] ?? 0) +
          (dietData[1]['fat'] ?? 0) +
          (dietData[2]['fat'] ?? 0) +
          (dietData[3]['fat'] ?? 0);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          const Text(
            "Based on your height, weight, gender and age estimating macronutrients per day:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DataTable(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
                gradient: primaryGradient),
            // border: TableBorder.all(),
            columnSpacing: Get.width * 0.15,
            dataTextStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            headingTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            dividerThickness: 2,

            columns: const [
              DataColumn(label: Text("Nutrition (unit)")),
              DataColumn(label: Text("Need")),
              DataColumn(label: Text("Take")),
            ],
            rows: [
              DataRow(
                cells: [
                  const DataCell(Text("Calorie (kCal)")),
                  DataCell(Text(calorieNeeds.toStringAsFixed(2))),
                  DataCell(Text(calorieTakes.toStringAsFixed(2))),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text("Carbohydrate (g)")),
                  DataCell(Text(carbsNeeds.toStringAsFixed(2))),
                  DataCell(Text(carbsTakes.toStringAsFixed(2))),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text("Protein (g)")),
                  DataCell(Text(proteinNeeds.toStringAsFixed(2))),
                  DataCell(Text(proteinTakes.toStringAsFixed(2))),
                ],
              ),
              DataRow(
                cells: [
                  const DataCell(Text("Fat (g)")),
                  DataCell(Text(fatNeeds.toStringAsFixed(2))),
                  DataCell(Text(fatTakes.toStringAsFixed(2))),
                ],
              )
            ],
            // children: [
            //   const TableRow(children: [
            //     TableCell(
            //       child: Text(
            //         "Need",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     TableCell(
            //       child: Text(
            //         "Take",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //   ]),
            //   TableRow(children: [
            //     TableCell(
            //       child: Text(
            //         "Calorie: ${calorieNeeds.toStringAsFixed(2)} kCal",
            //         textAlign: TextAlign.center,
            //       ),
            //     ),
            //     TableCell(
            //       child: Text(
            //         "Carbohydrates: ${carbsNeeds.toStringAsFixed(2)} g",
            //         textAlign: TextAlign.center,
            //       ),
            //     )
            //   ])
            // ],
          ),
          const SizedBox(height: 10),
          dietData.isEmpty
              ? ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const MakeDietPlan(),
                      arguments: [calorieNeeds, carbsNeeds, proteinNeeds, fatNeeds],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    backgroundColor: primaryClr,
                    // shadowColor: Colors.transparent,
                    elevation: 5,
                    minimumSize: Size(
                      Get.width * 0.8,
                      Get.height * 0.06,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text("Make Your Diet Plan"),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Column(
                            children: [
                              const Text("Breakfast"),
                              CircleAvatar(
                                backgroundImage: NetworkImage(dietData[0]['image']),
                                radius: 60,
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              const Text("Lunch"),
                              CircleAvatar(
                                backgroundImage: NetworkImage(dietData[2]['image']),
                                radius: 60,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Card(
                          child: Column(
                            children: [
                              const Text("Snack"),
                              CircleAvatar(
                                backgroundImage: NetworkImage(dietData[3]['image']),
                                radius: 60,
                              ),
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              const Text("Dinner"),
                              CircleAvatar(
                                backgroundImage: NetworkImage(dietData[1]['image']),
                                radius: 60,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
