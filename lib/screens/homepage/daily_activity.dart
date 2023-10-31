import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';

import '../../widgets/barchart.dart';

class DailyActivity extends StatefulWidget {
  const DailyActivity({Key? key}) : super(key: key);

  @override
  State<DailyActivity> createState() => _DailyActivityState();
}

class _DailyActivityState extends State<DailyActivity> {
  TextEditingController water = TextEditingController();
  TextEditingController steps = TextEditingController();

  showDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: TextFormField()),
                  const SizedBox(width: 40,),
                  Expanded(child: TextFormField()),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [
                          ColorCode.primaryColor2,
                          ColorCode.primaryColor1
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: ElevatedButton(
                  onPressed: (){},
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
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)),
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
                height: screenSize.height * 0.20,
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
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
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Water Intake"),
                                      Text("12 Glasses")
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
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Steps"), Text("10000")],
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
              const Text(
                "Steps Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: BarChar(),
              ),
              const Text(
                "Water Intake Progress",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: BarChar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
