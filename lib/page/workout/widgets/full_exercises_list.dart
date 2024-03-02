import 'package:finessapp/page/workout/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utility/utils.dart';
import 'customContainer.dart';

class FullExerciseList extends StatelessWidget {
  const FullExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                          assetPath: 'assets/video/fullbody/warmup.mp4',
                          title: 'Warm Up',
                          text1: 'Some Benefits of Warm Up Exercise',
                          text2: '⭐ Increased Blood Flow',
                          text3: '⭐ Improved Muscle Flexibility',
                          text4: '⭐ Enhanced Joint Range of Motion',
                          text5: '⭐ Activation of Nervous System',
                          text6: '⭐ Mental Preparation',
                          text7: '⭐ Prevention of Injury',
                          text8: '⭐ Improved Performance',
                          text9: '⭐ Temperature Regulation',
                          text10: '⭐ Gradual Elevation of Heart Rate',
                          text11: '⭐ Reduced Muscle Stiffness and Soreness',
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
                          assetPath: 'assets/video/fullbody/jumping.mp4',
                          title: 'Jumping Jack',
                          text1: 'Some Benefits of Jumping Exercise',
                          text2: '⭐ Muscular Endurance',
                          text3: '⭐ Easy to modify for different fitness levels',
                          text4: '⭐ Metabolic Rate Increase',
                          text5: '⭐ Low-Impact Option',
                          text6: '⭐ Dynamic Warm-Up',
                          text7: '⭐ Improves quick, coordinated movements',
                          text8: '⭐ Requires no special equipment',
                          text9: '⭐ Social Engagement',
                          text10: '⭐ Posture Improvement',
                          text11: '⭐ Adaptable for All Ages',
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
                          assetPath: 'assets/video/fullbody/skipping.mp4',
                          title: 'Skipping',
                          text1: 'Some Benefits of skipping Exercise',
                          text2: '⭐ Muscle Tone',
                          text3: '⭐ Increased Agility',
                          text4: '⭐ Lymphatic System Stimulation',
                          text5: '⭐ Joint Health',
                          text6: '⭐ Time-Efficient',
                          text7: '⭐ Variety of Techniques',
                          text8: '⭐ Improved Respiratory Function',
                          text9: '⭐ Social Engagement',
                          text10: '⭐ Boosted Metabolism',
                          text11: '⭐ Enhanced Focus & Mind Muscle Connection',
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayer(
                      assetPath: 'assets/video/fullbody/squats.mp4',
                      title: 'Squats',
                      text1: 'Some Benefits of Squats Exercise',
                      text2: '⭐ Muscle Engagement',
                      text3: '⭐ Strength Building',
                      text4: '⭐ Increased Power',
                      text5: '⭐ Joint Flexibility',
                      text6: '⭐ Improved Posture',
                      text7: '⭐ Calorie Burning',
                      text8: '⭐ Full Body Workout',
                      text9: '⭐ Hormonal Benefits',
                      text10: '⭐ Bone Density',
                      text11: '⭐ Increased Metabolism',
                    )),
              );
            },
            image: Image.asset("assets/page-2/squats.png"),
            title: "Squats",
            subTitle: "20x"),
        const SizedBox(
          height: 13,
        ),
        MyContainer(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayer(
                      assetPath: 'assets/video/fullbody/arm.mp4',
                      title: 'Arms Raises',
                      text1: 'Some Benefits of Arms Exercise',
                      text2: '⭐ Shoulder Activation',
                      text3: '⭐ Upper Body Toning',
                      text4: '⭐ Improved Posture',
                      text5: '⭐ Core Engagement',
                      text6: '⭐ Enhanced Shoulder Flexibility',
                      text7: '⭐ Joint Health',
                      text8: '⭐ Increased Blood Circulation',
                      text9: '⭐ Minimal Equipment Required',
                      text10: '⭐ Neck and Upper Back Relief',
                      text11: '⭐ Improved Balance',
                    )),
              );
            },
            image: Image.asset("assets/page-2/arm.png"),
            title: "Arm Raises",
            subTitle: "1.00"),
        const SizedBox(
          height: 13,
        ),
        MyContainer(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayer(
                      assetPath: 'assets/video/fullbody/rest.mp4',
                      title: 'Rest and Drinks',
                      text1: 'Some Benefits of breaks in Exercise',
                      text2: '⭐ Muscle Recovery',
                      text3: '⭐ Injury Prevention',
                      text4: '⭐ Performance Improvement',
                      text5: '⭐ Immune System Support',
                      text6: '⭐ Mental Well-being',
                      text7: '⭐ Temperature Regulation',
                      text8: '⭐ Joint Lubrication',
                      text9: '⭐ Electrolyte Balance',
                      text10: '⭐ Recovery Enhancement',
                      text11: '⭐ Cognitive Function',
                    )),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VideoPlayer(
                      assetPath: 'assets/video/fullbody/incline_push_up.mp4',
                      title: 'Incline Push Up',
                      text1: 'Some Benefits of IPU Exercise',
                      text2: '⭐ Chest Development',
                      text3: '⭐ Shoulder Engagement:',
                      text4: '⭐ Triceps Activation',
                      text5: '⭐ Scapular Stabilization',
                      text6: '⭐ Engages core muscles for stability',
                      text7: '⭐ Gentler on wrists and shoulders',
                      text8: '⭐ Easily modifiable for different levels',
                      text9: '⭐ Increased Range of Motion',
                      text10: '⭐ Improves functional fitness',
                      text11: '⭐ Can be done using household items',
                    )),
              );
            },
            image: Image.asset("assets/page-2/incline.png"),
            title: "Incline Push-Ups",
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
                      assetPath: 'assets/video/fullbody/push_up.mp4',
                      title: 'Push Ups',
                      text1: 'Some Benefits of Push Ups Exercise',
                      text2: '⭐ Chest Development',
                      text3: '⭐ Shoulder Engagement:',
                      text4: '⭐ Triceps Activation',
                      text5: '⭐ Scapular Stabilization',
                      text6: '⭐ Engages core muscles for stability',
                      text7: '⭐ Gentler on wrists and shoulders',
                      text8: '⭐ Easily modifiable for different levels',
                      text9: '⭐ Increased Range of Motion',
                      text10: '⭐ Improves functional fitness',
                      text11: '⭐ Can be done using household items',
                    )),
              );
            },
            image: Image.asset("assets/page-2/pushups.png"),
            title: "Push-Ups",
            subTitle: "15x"),
        const SizedBox(
          height: 13,
        ),

        MyContainer(
            onTap: () {
              Get.to(const VideoPlayer(
                assetPath: 'assets/video/fullbody/cobra_stretch.mp4',
                title: 'Cobra Stretch',
                text1: 'Some Benefits of CS Exercise',
                text2: '⭐ Chest Development',
                text3: '⭐ Shoulder Engagement:',
                text4: '⭐ Triceps Activation',
                text5: '⭐ Scapular Stabilization',
                text6: '⭐ Engages core muscles for stability',
                text7: '⭐ Gentler on wrists and shoulders',
                text8: '⭐ Easily modifiable for different levels',
                text9: '⭐ Increased Range of Motion',
                text10: '⭐ Improves functional fitness',
                text11: '⭐ Can be done using household items',

              ));
            },
            image: Image.asset("assets/page-2/cobra.png"),
            title: "Cobra Stretch",
            subTitle: "15x"),

      ],
    );
  }
}
