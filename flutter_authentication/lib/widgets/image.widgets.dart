import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopRightSvg extends StatelessWidget {
  const TopRightSvg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Positioned(
      right: 0,
      child: SvgPicture.asset(
        "assets/top1.svg", // Hardcoded asset path
        height: height * 0.2, // Hardcoded height multiplier
      ),
    );
  }
}


class BottomLeftSvg extends StatelessWidget {
  const BottomLeftSvg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: 0,
      left: -width * 0.05, // Hardcoded offset logic
      child: SvgPicture.asset(
        "assets/bottom.svg", // Hardcoded asset path
        height: height * 0.175, // Hardcoded height multiplier
      ),
    );
  }
}


class CustomImage extends StatelessWidget {
  final double size;

  CustomImage({required this.size});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Image.asset(
      "assets/geminiplus.png",
      width: width * size,
    );
  }
}
