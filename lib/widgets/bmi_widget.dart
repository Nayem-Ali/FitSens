import 'package:finessapp/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/color_utility.dart';

class BMI extends StatefulWidget {
  const BMI({Key? key, required this.status, required this.bmiValue})
      : super(key: key);
  final String status;
  final double bmiValue;

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  String causeUnderweight =
      "Family history. Some people have a naturally low BMI due to physical characteristics that run in their family.\n"
      "A high metabolism. If a person has a high metabolism, they may not gain much weight even when eating high-energy foods.\n"
      "Frequent physical activity. Athletes or people who engage in high levels of physical activity, such as runners, may burn significant amounts of calories that result in low body weight.\n"
      "Mental illness. Poor mental health can affect a person’s ability to eat.\n";

  String treatment =
      "Adding snacks. High-protein and whole-grain carbohydrate snacks can help a person gain weight. Examples include peanut butter crackers, protein bars, trail mix, pita chips and hummus, or a handful of almonds\n"
      ""
      ""
      "";
  Map<String, List<String>> level = {};

  @override
  initState() {
    level = {
      "Underweight": [causeUnderweight, treatment],
      "Normal": [causeUnderweight, treatment],
      "Overweight": [causeUnderweight, treatment],
      "Obese": [causeUnderweight, treatment],
      //"Overweight": [causeUnderweight, treatment],
    };
    super.initState();
  }

  showInfo() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Text(level[widget.status]?.first ?? "");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // padding: const EdgeInsets.all(10),
      height: 120,
      width: Get.size.width*.95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [ColorCode.primaryColor1, primaryClr],
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BMI(Body Mass Index)",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: ColorCode.white),
              ),
              Text(
                "Status: ${widget.status}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: ColorCode.white),
              ),
              // Container(
              //   height: 40,
              //   width: 100,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(45),
              //     gradient: LinearGradient(colors: ColorCode.secondaryG),
              //   ),
              //   child: Center(
              //     child: ElevatedButton(
              //       onPressed: showInfo,
              //       style: ElevatedButton.styleFrom(
              //         //maximumSize: const Size(20,20),
              //         backgroundColor: Colors.transparent,
              //         shadowColor: Colors.transparent,
              //       ),
              //       child: const Text(
              //         "View more",
              //         style: TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                    colors: [Colors.white, Colors.white70])),
            child: Center(
              child: Text(widget.bmiValue.toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
            ),
          )
        ],
      ),
    );
  }
}
