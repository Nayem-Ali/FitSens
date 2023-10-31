
import 'package:flutter/material.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../workout/workout_schedule.dart';

class DailyContainer extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const DailyContainer({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(

      margin: EdgeInsets.fromLTRB(
          25 * fem, 23 * fem, 30 * fem, 25 * fem),
      padding: EdgeInsets.fromLTRB(
          20 * fem, 15 * fem, 20 * fem, 14 * fem),

      height: 57 * fem,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16 * fem),
        gradient: thirdGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 14 * ffem,
              fontWeight: FontWeight.w500,
              height: 1.5 * ffem / fem,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 45,),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 50 * fem,

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50 * fem),
                  gradient: primaryGradient
              ),
              child: Center(
                child: Text(
                  'Check',
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 9 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.5 * ffem / fem,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
