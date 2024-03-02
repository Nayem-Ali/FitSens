
import 'package:flutter/material.dart';
import '../../../utility/color.dart';
import '../../../utility/utils.dart';

class WorkoutContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget image;
  final Function()? onTap;
  const WorkoutContainer({Key? key, required this.title, required this.subTitle, required this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120*fem,
        width: 375*fem,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16 * fem),
          gradient: thirdGradient,
        ),
        margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 30 * fem, 30 * fem),
        child: Container(

          margin: EdgeInsets.only(left: 20*fem, right: 8*fem),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15,),
                  Text(
                      title,
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 15 * ffem,
                      fontWeight: FontWeight.w600,
                      height: 1.5 * ffem / fem,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    subTitle,
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 13 * ffem,
                      fontWeight: FontWeight.w500,
                      height: 1.5 * ffem / fem,
                      color: Colors.grey,
                    ),
                  ),


                ],
              ),
              image,
            ],
          ),
        ),
      ),
    );
  }
}
