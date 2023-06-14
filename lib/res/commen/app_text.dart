import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String? text;
  const AppText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: const TextStyle(
          height: 3,
          color: Color(0xff000000),
          fontWeight: FontWeight.w500,
          fontSize: 14,
          fontFamily: "Circular Std",
          fontStyle: FontStyle.normal,
        ));
  }
}
