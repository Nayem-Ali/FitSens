import 'package:finessapp/page/diet_planner/diet_plan.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/utils.dart';
import 'controller.dart';
import 'data_model.dart';

class MakeDietPlan extends StatefulWidget {
  const MakeDietPlan({Key? key}) : super(key: key);

  @override
  State<MakeDietPlan> createState() => _MakeDietPlanState();
}

class _MakeDietPlanState extends State<MakeDietPlan> {
  DBService dbService = DBService();
  FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> dietData = [];
  List<Hit> hits = [];
  FoodController postController = FoodController();
  double calorieNeeds = Get.arguments[0];
  double carbsNeeds = Get.arguments[1];
  double proteinNeeds = Get.arguments[2];
  double fatNeeds = Get.arguments[3];
  double cal = Get.arguments[0] * 0.15;
  double totalCalorie = 0;
  double totalCarbs = 0;
  double totalFat = 0;
  double totalProtein = 0;
  bool isLoading = true;
  String mealType = "breakfast";
  String selectedMealLabel = "";
  Map<String, dynamic> data = {};
  Map<String, dynamic> breakfast = {};
  Map<String, dynamic> lunch = {};
  Map<String, dynamic> snack = {};
  Map<String, dynamic> dinner = {};

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Make Diet Plan",
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

  getData(String q) async {
    setState(() {
      isLoading = true;
    });
    FoodModel foodModel = (await postController.getFoods(q: q, from: 0, to: 100))!;
    hits = foodModel.hits;
    setState(() {
      isLoading = false;
    });
  }

  addMeal(Recipe recipe) {
    data['image'] = recipe.image;
    data['label'] = recipe.label;
    data['ingredient'] = recipe.ingredientLines;
    data['mealType'] = recipe.mealType.join(", ");
    data['healthLabel'] = recipe.healthLabels;
    data['cuisineType'] = recipe.cuisineType.join(", ");
    data['time'] = recipe.totalTime;
    data['dietLabel'] = recipe.dietLabels.join(", ");
    data['calorie'] = recipe.calories;
    data['protein'] = recipe.totalNutrients['PROCNT']!.quantity;
    data['carbs'] = recipe.totalNutrients['CHOCDF']!.quantity;
    data['fat'] = recipe.totalNutrients['FAT']!.quantity;

    if (mealType == 'breakfast') {
      data.forEach((key, value) {
        breakfast[key] = value;
      });
      // breakfast = data;
    } else if (mealType == 'lunch') {
      data.forEach((key, value) {
        lunch[key] = value;
      });
    } else if (mealType == 'snack') {
      data.forEach((key, value) {
        snack[key] = value;
      });
    } else {
      data.forEach((key, value) {
        dinner[key] = value;
      });
    }
    calculateTotals();
  }

  showItem(Recipe recipe) {
    Get.bottomSheet(
      ignoreSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            CircleAvatar(
              backgroundImage: NetworkImage(recipe.image),
              radius: 100,
            ),
            const Divider(),
            Text(
              "Dish: ${recipe.label}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Cuisine: ${recipe.cuisineType.join(", ")}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            // Text("Health Label: ${hits[index].recipe.healthLabels.join(", ")}"),
            Text(
              "Time: ${recipe.totalTime} minutes",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Calorie: ${recipe.calories.toStringAsFixed(2)} kCal",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Carbohydrate: ${recipe.totalNutrients['CHOCDF']!.quantity.toStringAsFixed(2)} "
              "g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Protein: ${recipe.totalNutrients['PROCNT']!.quantity.toStringAsFixed(2)} g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Fat: ${recipe.totalNutrients['FAT']!.quantity.toStringAsFixed(2)} g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),
            Text(
              "Health Labels: ${recipe.healthLabels.join(", ")}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),

            Text(
              "Diet Labels: ${recipe.dietLabels.join(", ")}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),

            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: recipe.ingredientLines.length,
                itemBuilder: (context, index) {
                  return Text(
                    "${index + 1}. ${recipe.ingredientLines[index]}",
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addMeal(recipe);
                Get.back();
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
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: const Text("Add to Meal"),
            )
          ],
        ),
      ),
    );
  }

  calculateTotals() {
    totalCalorie = (breakfast['calorie'] ?? 0) +
        (lunch['calorie'] ?? 0) +
        (dinner['calorie'] ?? 0) +
        (snack['calorie'] ?? 0);

    totalCarbs = (breakfast['carbs'] ?? 0) +
        (lunch['carbs'] ?? 0) +
        (dinner['carbs'] ?? 0) +
        (snack['carbs'] ?? 0);

    totalFat =
        (breakfast['fat'] ?? 0) + (lunch['fat'] ?? 0) + (dinner['fat'] ?? 0) + (snack['fat'] ?? 0);

    totalProtein = (breakfast['protein'] ?? 0) +
        (lunch['protein'] ?? 0) +
        (dinner['protein'] ?? 0) +
        (snack['protein'] ?? 0);
    setState(() {});
  }

  getDietData() async {
    dietData = await dbService.getDietPlan();
    if (dietData.isNotEmpty) {
      breakfast = dietData[0];
      lunch = dietData[2];
      snack = dietData[3];
      dinner = dietData[1];
      selectedMealLabel = breakfast['label'];
      calculateTotals();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDietData();
    getData("breakfast");
  }

  // Carbohydrate: 45% x 1,500 calories / 4 calories = 168.75 grams per day
  // Protein: 25% x 1,500 calories / 4 calories =  93.75 grams per day
  // Fat: 30% x 1,500 calories / 9 calories = 50 grams per day

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: totalCalorie / calorieNeeds,
                    color: ColorCode.primaryColor1,
                    backgroundColor: ColorCode.secondaryColor2,
                    minHeight: Get.height * 0.03,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Text(
                    "Calorie: ${totalCalorie.toStringAsFixed(2)} / ${calorieNeeds.toStringAsFixed(2)} gm per day",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: totalCarbs / carbsNeeds,
                    color: ColorCode.primaryColor1,
                    backgroundColor: ColorCode.secondaryColor2,
                    minHeight: Get.height * 0.03,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Text(
                    "Carbohydrate: ${totalCarbs.toStringAsFixed(2)} / ${carbsNeeds.toStringAsFixed(2)} gm per day",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: totalProtein / proteinNeeds,
                    color: ColorCode.primaryColor1,
                    backgroundColor: ColorCode.secondaryColor2,
                    minHeight: Get.height * 0.03,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Text(
                    "Protein: ${totalProtein.toStringAsFixed(2)} / ${proteinNeeds.toStringAsFixed(2)} gm per day",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: totalFat / fatNeeds,
                    color: ColorCode.primaryColor1,
                    backgroundColor: ColorCode.secondaryColor2,
                    minHeight: Get.height * 0.03,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  Text(
                    "Fat: ${totalFat.toStringAsFixed(2)} / ${fatNeeds.toStringAsFixed(2)} gm per day",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      cal = calorieNeeds * 0.15;
                      mealType = "breakfast";
                      if (breakfast.isNotEmpty) {
                        selectedMealLabel = breakfast['label'];
                      }
                      await getData('breakfast');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: mealType == 'breakfast'
                          ? Colors.orangeAccent.shade100
                          : Colors.transparent,
                    ),
                    child: const Text("Break Fast"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      cal = calorieNeeds * 0.35;
                      mealType = "lunch";
                      if (lunch.isNotEmpty) {
                        selectedMealLabel = lunch['label'];
                      }
                      await getData('lunch');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          mealType == 'lunch' ? Colors.orangeAccent.shade100 : Colors.transparent,
                    ),
                    child: const Text("Lunch"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      cal = calorieNeeds * 0.15;
                      mealType = 'snack';
                      if (snack.isNotEmpty) {
                        selectedMealLabel = snack['label'];
                      }
                      await getData('snack');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          mealType == 'snack' ? Colors.orangeAccent.shade100 : Colors.transparent,
                    ),
                    child: const Text("Snack"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      cal = calorieNeeds * 0.35;
                      mealType = "dinner";
                      if (dinner.isNotEmpty) {
                        selectedMealLabel = dinner['label'];
                      }
                      await getData('dinner');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          mealType == 'dinner' ? Colors.orangeAccent.shade100 : Colors.transparent,
                    ),
                    child: const Text("Dinner"),
                  ),
                ],
              ),
              isLoading
                  ? const Expanded(
                      child: Column(children: [
                        Spacer(),
                        CircularProgressIndicator(),
                        Spacer(),
                      ]),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: hits.length,
                        itemBuilder: (context, index) {
                          double? calorie = hits[index].recipe.calories;
                          bool condition = (calorie < cal);
                          return condition
                              ? Card(
                                  color: selectedMealLabel == hits[index].recipe.label
                                      ? ColorCode.primaryColor2
                                      : Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(hits[index].recipe.image),
                                    ),
                                    title: Text(hits[index].recipe.label),
                                    onTap: () {
                                      showItem(hits[index].recipe);
                                    },
                                  ),
                                )
                              : const SizedBox();
                        },
                      ),
                    ),
              ElevatedButton.icon(
                onPressed: () async {
                  await dbService.addDietPlan(breakfast, 'breakfast');
                  await dbService.addDietPlan(lunch, 'lunch');
                  await dbService.addDietPlan(snack, 'snack');
                  await dbService.addDietPlan(dinner, 'dinner');
                  Get.snackbar(
                    "FitSens",
                    "Diet Plan Added Successfully",
                  );
                  Get.off(() => const DietPlanner());
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
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
