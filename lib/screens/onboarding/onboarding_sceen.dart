import 'package:finessapp/screens/auth/login_screen.dart';
import 'package:finessapp/screens/onboarding/get_started_screen.dart';
import 'package:finessapp/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utility/color_utility.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List pageDetails = [
    {
      "title": "Track Your Goal",
      "subtitle":
          "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
      "image": "assets/images/onBoarding/onBoarding1.png"
    },
    {
      "title": "Get Burn",
      "subtitle":
          "Let’s keep burning, to achieve yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
      "image": "assets/images/onBoarding/onBoarding2.png"
    },
    {
      "title": "Eat Well",
      "subtitle":
          "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
      "image": "assets/images/onBoarding/onBoarding3.png"
    },
    {
      "title": "Improve Sleep Quality",
      "subtitle":
          "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
      "image": "assets/images/onBoarding/onBoarding4.png"
    },
  ];

  PageController controller = PageController();
  int selectedPage = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorCode.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            itemCount: 4,
            itemBuilder: (context, index) {
              return OnBoardingPage(
                pageDetail: pageDetails[index] ?? {},
              );
            },
          ),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    color: ColorCode.primaryColor1,
                    value: (selectedPage + 1) / pageDetails.length,
                    strokeWidth: 2,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(30),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        ColorCode.primaryColor1,
                        ColorCode.primaryColor2,
                      ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.navigate_next),
                    color: ColorCode.white,
                    onPressed: () {
                      if (selectedPage <3 ) {
                        selectedPage++;
                        controller.jumpToPage(selectedPage);

                        setState(() {});
                      } else {
                        Get.offAll(const LoginScreen());
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
