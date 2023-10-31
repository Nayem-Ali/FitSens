
import 'package:flutter/material.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';

class ProgressBar extends StatelessWidget {

  final Gradient? gradient;
  final Gradient? gradient1;
  final Color? color;
  final Color? t_color;
  final Color? t1_color;
  final double height;
  const ProgressBar({Key? key,this.gradient, this.color, this.t_color, this.t1_color, this.gradient1, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Container(
      padding:
      EdgeInsets.fromLTRB(30 * fem, 5 * fem, 28 * fem, 20 * fem),
      width: 375 * fem,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Opacity(
                    opacity: 0.3,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          0 * fem, 5 * fem, 0 * fem, 15 * fem),
                      width: 283 * fem,
                      height: 160 * fem,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            //line
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 22 * fem),

                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 22 * fem),
                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 22 * fem),
                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 22 * fem),
                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 22 * fem),
                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0 * fem, 0 * fem, 0 * fem, 20 * fem),
                            height: 1.2 * fem,
                            decoration: BoxDecoration(
                              color: t1_color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 4 * fem,
                      top: 146 * fem,
                    ),
                    width: 275 * fem,
                    height: 18 * fem,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 20 * fem, 0 * fem),
                          child: Text(
                            'Sun',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 20 * fem, 0 * fem),
                          child: Text(
                            'Mon',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 20 * fem, 0 * fem),
                          child: Text(
                            'Tue',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 20 * fem, 0 * fem),
                          child: Text(
                            'Wed',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 19 * fem, 0 * fem),
                          child: Text(
                            'Thu',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 19 * fem, 0 * fem),
                          child: Text(
                            'Fri',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w700,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0 * fem, 0 * fem, 10 * fem, 0 * fem),
                          child: Text(
                            'Sat',
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 10 * ffem,
                              fontWeight: FontWeight.w400,
                              height: 1.5 * ffem / fem,
                              color: t1_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(
                      left: 190 * fem,
                      top: 5 * fem,
                    ),
                    width: 18 * fem,
                    height: 125 * fem,
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: gradient1
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 12 * fem),
                    child: Text(
                      '100%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 10 * fem),
                    child: Text(
                      '80%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 10 * fem),
                    child: Text(
                      '60%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 10 * fem),
                    child: Text(
                      '40%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 0 * fem, 10 * fem),
                    child: Text(
                      '20%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        0 * fem, 0 * fem, 8 * fem, 0 * fem),
                    child: Text(
                      '0%',
                      textAlign: TextAlign.right,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 10.625 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.5 * ffem / fem,
                        color: t1_color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
