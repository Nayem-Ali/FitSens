import 'package:finessapp/page/workout/widgets/customContainer.dart';
import 'package:finessapp/page/workout/widgets/video_player.dart';
import 'package:flutter/material.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';

class AB extends StatelessWidget {
  const AB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: fem * 1300,
          width: fem * 400,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                //color: primaryClr,
                decoration: const BoxDecoration(
                  gradient: primaryGradient,
                ),
                height: fem * 400,
                width: fem * 400,
                child: Image.asset(
                  'assets/page-2/vector.png',
                  fit: BoxFit.contain,
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 300),
                  height: fem * 1000,
                  width: fem * 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40 * fem),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 5 * fem,
                          width: 50 * fem,
                          margin: EdgeInsets.fromLTRB(
                              133 * fem, 5 * fem, 134 * fem, 2 * fem),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50 * fem),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "AB Workout",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 17 * ffem,
                            fontWeight: FontWeight.bold,
                            height: 1.5 * ffem / fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "14 Exercise | 30 mins | 280 calories burn",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w500,
                            height: 1.5 * ffem / fem,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "Exercises",
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 17 * ffem,
                                fontWeight: FontWeight.bold,
                                height: 1.5 * ffem / fem,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              "2 Sets",
                              style: SafeGoogleFont(
                                'Poppins',
                                fontSize: 14 * ffem,
                                fontWeight: FontWeight.w400,
                                height: 1.5 * ffem / fem,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Set 1",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      MyContainer(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VideoPlayer(
                                    assetPath: 'assets/video/video.mp4',
                                    title: 'Warm Up',
                                    text1:
                                    'Some Benefits of Warm Up Exercise',
                                    text2: '⭐ Increased Blood Flow',
                                    text3: '⭐ Improved Muscle Flexibility',
                                    text4:
                                    '⭐ Enhanced Joint Range of Motion',
                                    text5: '⭐ Activation of Nervous System',
                                    text6: '⭐ Mental Preparation',
                                    text7: '⭐ Prevention of Injury',
                                    text8: '⭐ Improved Performance',
                                    text9: '⭐ Temperature Regulation',
                                    text10:
                                    '⭐ Gradual Elevation of Heart Rate',
                                    text11:
                                    '⭐ Reduced Muscle Stiffness and Soreness',
                                  )),
                            );
                          },
                          image: Image.asset("assets/page-2/warmup.png"),
                          title: "Warm Up",
                          subTitle: "5.00"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VideoPlayer(
                                    assetPath:
                                    'assets/video/fullbody/jumping.mp4',
                                    title: 'Jumping Jack',
                                    text1:
                                    'Some Benefits of Warm Up Exercise',
                                    text2: '⭐ Increased Blood Flow',
                                    text3: '⭐ Improved Muscle Flexibility',
                                    text4:
                                    '⭐ Enhanced Joint Range of Motion',
                                    text5: '⭐ Activation of Nervous System',
                                    text6: '⭐ Mental Preparation',
                                    text7: '⭐ Prevention of Injury',
                                    text8: '⭐ Improved Performance',
                                    text9: '⭐ Temperature Regulation',
                                    text10:
                                    '⭐ Gradual Elevation of Heart Rate',
                                    text11:
                                    '⭐ Reduced Muscle Stiffness and Soreness',
                                  )),
                            );
                          },
                          image: Image.asset("assets/page-2/jumping.png"),
                          title: "Jumping Jack",
                          subTitle: "12x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VideoPlayer(
                                    assetPath:
                                    'assets/video/fullbody/skipping.mp4',
                                    title: 'Skipping',
                                    text1:
                                    'Some Benefits of Warm Up Exercise',
                                    text2: '⭐ Increased Blood Flow',
                                    text3: '⭐ Improved Muscle Flexibility',
                                    text4:
                                    '⭐ Enhanced Joint Range of Motion',
                                    text5: '⭐ Activation of Nervous System',
                                    text6: '⭐ Mental Preparation',
                                    text7: '⭐ Prevention of Injury',
                                    text8: '⭐ Improved Performance',
                                    text9: '⭐ Temperature Regulation',
                                    text10:
                                    '⭐ Gradual Elevation of Heart Rate',
                                    text11:
                                    '⭐ Reduced Muscle Stiffness and Soreness',
                                  )),
                            );
                          },
                          image: Image.asset("assets/page-2/skipping.png"),
                          title: "Skipping",
                          subTitle: "15x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/squats.png"),
                          title: "Squats",
                          subTitle: "20x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/arm.png"),
                          title: "Arm Raises",
                          subTitle: "1.00"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/rest.png"),
                          title: "Rest and Drinks",
                          subTitle: "3.00"),
                      const SizedBox(
                        height: 13,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Set 2",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 14 * ffem,
                            fontWeight: FontWeight.w400,
                            height: 1.5 * ffem / fem,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/incline.png"),
                          title: "Incline Push-Ups",
                          subTitle: "12x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/pushups.png"),
                          title: "Push-Ups",
                          subTitle: "15x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/skipping.png"),
                          title: "Skipping",
                          subTitle: "15x"),
                      const SizedBox(
                        height: 13,
                      ),
                      MyContainer(
                          onTap: () {},
                          image: Image.asset("assets/page-2/cobra.png"),
                          title: "Cobra Stretch",
                          subTitle: "15x"),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
