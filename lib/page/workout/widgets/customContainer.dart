import 'package:flutter/material.dart';

import '../../../utility/utils.dart';


class MyContainer extends StatelessWidget {
  final Widget? image;
  final String title;
  final String subTitle;
  final Function()? onTap;
  const MyContainer(
      {Key? key, this.image, required this.title, required this.subTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        width: 350,
        height: 60,
        color: Colors.white,
        child: Row(
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

                Text(
                  subTitle,
                  style: SafeGoogleFont(
                    'Poppins',
                    fontSize: 12 * ffem,
                    fontWeight: FontWeight.w400,
                    height: 1.5 * ffem / fem,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
