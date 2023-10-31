import 'package:finessapp/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/color_utility.dart';
import '../../widgets/barchart.dart';
import '../../widgets/bmi_widget.dart';
import '../../widgets/linechart.dart';
import 'daily_activity.dart';
import 'db_service.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Map<String, dynamic> userDetails = {};
  late double bmiValue;
  late String status;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getBMIStatus(double bmi) {
    if (bmi <= 18.5) {
      status = "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      status = "Normal";
    } else if (bmi >= 25 && bmi < 30) {
      status = "Overweight";
    } else if (bmi >= 30 && bmi < 35) {
      status = "Obese Class - I";
    } else if (bmi >= 35 && bmi < 40) {
      status = "Obese Class - II";
    } else {
      status = "Obese Class - III";
    }
  }

  getData() async {
    DBService db = DBService();
    userDetails = await db.getUserInfo();
    double height = double.parse(userDetails["height"]);
    double weight = double.parse(userDetails["weight"]);
    height /= 100;
    bmiValue = weight / (height * height);
    getBMIStatus(bmiValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: userDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SizedBox(
                height: screenSize.height * 1.3,
                width: screenSize.width,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Welcome Back,",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                              Text(
                                userDetails["name"],
                                style: const TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(const NotificationScreen());
                            },
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 45,
                            ),
                          )
                        ],
                      ),
                    ),
                    BMI(status: status, bmiValue: bmiValue),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                        gradient: thirdGradient,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today Target",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              gradient: primaryGradient,
                            ),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(const DailyActivity());
                                },
                                style: ElevatedButton.styleFrom(
                                  //maximumSize: const Size(20,20),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: const Text(
                                  "Check",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(

                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      child: const Text(
                        "Activity Status",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const LineChar(),
                    const Padding(

                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Heart BPM",
                        style:
                            TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          height: screenSize.height * .15,
                          width: screenSize.width * 0.45,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(20),
                            gradient: thirdGradient,
                          ),
                          child: const Center(
                              child: Text(
                            "456 kCal\nBurned",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                            textAlign: TextAlign.center,
                          )),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          height: screenSize.height * .15,
                          width: screenSize.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: thirdGradient,
                          ),
                          child: const Center(
                            child: Text(
                              "7005/10000\nSteps",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),

                    const BarChar(),
                  ],
                ),
              ),
            ),
    );
  }
}
