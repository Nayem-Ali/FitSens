import 'package:flutter/material.dart';

class ColorCode {

  static Color get primaryColor1 => const Color(0xff6DB0B5); ///getter function
  static Color get primaryColor2 => const Color(0xffACDBD1);

  static Color get secondaryColor1 => const Color(0xff939780);
  static Color get secondaryColor2 => const Color(0xffA6AA85);


  static List<Color> get primaryG => [ primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);

}

