import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:firebase_demo_one/view/home/home_screen.dart';
import 'package:firebase_demo_one/view/login_screen.dart';
import 'package:firebase_demo_one/view/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> appRoutes = {
  RoutesName.firstScreen: (context) => const LoginScreen(),
  RoutesName.secondScreen: (context) => const SignUpScreen(),
  RoutesName.homeScreen: (context) => const HomeScreen(),
};
