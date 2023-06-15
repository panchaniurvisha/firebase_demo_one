import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  const AppText({super.key, required this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(
          height: 3,
          color: Color(0xff000000),
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? 14,
          fontFamily: "Circular Std",
          fontStyle: FontStyle.normal,
        ));
  }
}
