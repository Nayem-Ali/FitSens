import 'package:flutter/cupertino.dart';
import '../utility/color_utility.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key, required this.pageDetail}) : super(key: key);

  final Map<String,String> pageDetail;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: [
          Image.asset(
            pageDetail["image"]!, // "assets/images/onBoarding/onBoarding1.png"
            width: screenSize.width,
            height: screenSize.height * 0.60,
            fit: BoxFit.fill,
          ),
          SizedBox(height: screenSize.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pageDetail["title"]!, //, Track Your Gaol
              style:
              TextStyle(fontSize: 26, fontWeight: FontWeight.w700,color: ColorCode.black),
            ),
          ),
          SizedBox(height: screenSize.height * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              pageDetail["subtitle"]!,
              style:
              TextStyle(fontSize: 16, color: ColorCode.gray),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
