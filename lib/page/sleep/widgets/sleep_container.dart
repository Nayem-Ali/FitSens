
import 'package:flutter/material.dart';

import '../../../utility/utils.dart';
class SleepContainer extends StatelessWidget {
  final Widget? image;
  final String title;
  final String? subTitle;
  final String? subTitle1;
  const SleepContainer({Key? key, this.image, required this.title, this.subTitle, this.subTitle1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: image,
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 15 * ffem,
                    fontWeight: FontWeight.w500,
                    height: 1.5 * ffem / fem,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10,),

              ],
            ),

            Text(
              subTitle!,
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 13 * ffem,
                fontWeight: FontWeight.w400,
                height: 1.5 * ffem / fem,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
