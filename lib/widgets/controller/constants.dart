import 'package:flutter/material.dart';


class Constants {
  static const regularHeading =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black);

  static const boldHeading =
      TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black);

  static const regularDarkText = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black);
}

class AppColors {
  static const whiteColor = Colors.white;
  static const secondaryColor = Color(0xFF3E2933);
  static const lightGrayColor = Color(0xffc0c1c3);
  static const lighterGrayColor = Color(0xffe0e0e0);
  static const blackColor = Colors.black;
  static const activeColor = Color(0xfff9535c);
  static const fontColor = Color(0xfff5d9db);
}

class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;
  final TextDecoration textDecoration;
  final int maxLine;
  final TextAlign textAlign;
  final Color bColor;
  final TextDirection textDirection ;

   const PrimaryText({Key? key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.secondaryColor,
    this.size = 20,
    this.height = 1.3,
    this.textDecoration = TextDecoration.none,
    this.maxLine = 1,
    this.bColor = Colors.transparent,
    this.textAlign =TextAlign.start,
    this.textDirection = TextDirection.rtl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      textAlign:textAlign ,
      textDirection:textDirection ,
      style: TextStyle(
        decoration: textDecoration,
        color: color,
        height: height,
        fontFamily: 'eyad',
        fontSize: size,
        fontWeight: fontWeight,
        backgroundColor: bColor,
      ),
    );
  }
}

class PrimaryTextNR extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;
  final TextDecoration textDecoration;
  final int maxLine;
  final int arLanguage;
  final Color bColor;
  final TextAlign textAlign;
   const PrimaryTextNR(
      {Key? key, required this.text,
      this.fontWeight = FontWeight.w400,
      this.color = AppColors.secondaryColor,
      this.size = 20,
      this.height = 1.3,
      this.textDecoration = TextDecoration.none,
      this.maxLine = 1,
      this.arLanguage = 0,
      this.bColor = Colors.transparent,
      this.textAlign = TextAlign.justify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection:  TextDirection.ltr,
      maxLines: maxLine,
      style: TextStyle(
        decoration: textDecoration,
        color: color,
        height: height,
        fontFamily: 'eyad',
        fontSize: size,
        fontWeight: fontWeight,
        backgroundColor: bColor,
      ),
    );
  }
}