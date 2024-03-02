import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewReceipe extends StatefulWidget {
  const ViewReceipe({Key? key}) : super(key: key);

  @override
  State<ViewReceipe> createState() => _ViewReceipeState();
}

class _ViewReceipeState extends State<ViewReceipe> {
  Map<String, dynamic> recipe = Get.arguments[0];
  String image = Get.arguments[1];



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.05),
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 100,
            ),
            const Divider(),
            Text(
              "Dish: ${recipe['label']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Cuisine: ${recipe['cuisineType']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            // Text("Health Label: ${hits[index].recipe.healthLabels.join(", ")}"),
            Text(
              "Time: ${recipe['time']} minutes",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Calorie: ${recipe['calorie'].toStringAsFixed(2)} kCal",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Carbohydrate: ${recipe['carbs'].toStringAsFixed(2)} "
                  "g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Protein: ${recipe['protein'].toStringAsFixed(2)} g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              "Fat: ${recipe['fat'].toStringAsFixed(2)} g",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),
            Text(
              "Health Labels: ${recipe['healthLabel']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),

            Text(
              "Diet Labels: ${recipe['dietLabel']}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const Divider(),

            const Text(
              "Ingredients",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: recipe['ingredient'].length,
                itemBuilder: (context, index) {
                  return Text(
                    "${index + 1}. ${recipe['ingredient'][index]}",
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
