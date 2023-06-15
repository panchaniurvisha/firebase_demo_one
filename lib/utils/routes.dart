import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:flutter/cupertino.dart';

import '../view/login_page/login_screen.dart';
import '../view/login_page/login_with_phone_number.dart';
import '../view/sign_up_page/sign_up_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  RoutesName.firstScreen: (context) => const LoginScreen(),
  RoutesName.secondScreen: (context) => const SignUpScreen(),
  RoutesName.homeScreen: (context) => const LoginWithPhoneNumber(),
};
