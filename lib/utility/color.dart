import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryClr = Color(0xff6db0b5);

const primaryGradient = LinearGradient(
  begin: Alignment(0, -1),
  end: Alignment(0, 1),
  colors: <Color>[Color(0xffacdbd1), Color(0xff6db0b5)],
);

const secondaryGradient = LinearGradient(
  begin: Alignment(0, -1),
  end: Alignment(1, -3.567),
  colors: <Color>[
    Color(0x7fffffff),
    Color(0x7fedf7f8)
  ],
);


const thirdGradient = LinearGradient(
  begin: Alignment(0, -1),
  end: Alignment(0, 1),
  colors: <Color>[Color(0x33acdbd1), Color(0x336db0b5)],
);

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.w700, color: Colors.grey));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey[600]));
}
