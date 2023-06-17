import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/view/login_page/login_screen.dart';
import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 5), //arguments duration and action
      () {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterLogo(
              size: height / 3,
              style: FlutterLogoStyle.horizontal,
              curve: Curves.easeInCubic),
        ],
      ),
    )));
  }
}
