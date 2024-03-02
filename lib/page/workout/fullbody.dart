
import 'package:finessapp/page/workout/widgets/full_exercises_list.dart';
import 'package:finessapp/page/workout/workout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';

class Fullbody extends StatelessWidget {
  const Fullbody({Key? key}) : super(key: key);

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
                  height: fem * 870,
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
                          "Full-body Workout",
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
                          "09 Exercise | 32 mins | 800 calories burn",
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
                      const FullExerciseList(),
                    ],
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 10,left: 10),
                child: IconButton(onPressed: (){
                  Get.off(const Workout());
                }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

