import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String? text;
  final double? height;
  final double? fontSize;
  final Color? color;
  const AppText(
      {super.key, required this.text, this.fontSize, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(
          height: height ?? 3,
          color: color ?? Color(0xff000000),
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? 14,
          fontFamily: "Circular Std",
          fontStyle: FontStyle.normal,
        ));
  }
}
