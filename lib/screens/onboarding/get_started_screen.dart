import 'package:finessapp/screens/onboarding/onboarding_sceen.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/login_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorCode.primaryColor2,ColorCode.primaryColor1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Text(
              "FitSens",
              style: TextStyle(
                color: ColorCode.black,
                fontSize: 36,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Live, Track and Flourish",
              style: TextStyle(
                color: ColorCode.black,
                fontSize: 21,
                fontWeight: FontWeight.w400,
              ),
            ),

            const Spacer(),
            InkWell(
              onTap: () {
                Get.off(const OnBoardingScreen());
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05,
                    vertical: screenSize.width * 0.03),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenSize.width * 0.2),
                  gradient: LinearGradient(
                    colors: [
                      ColorCode.secondaryColor1,
                      ColorCode.secondaryColor2
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "Get Started",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorCode.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
