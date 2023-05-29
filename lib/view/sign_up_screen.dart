import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:flutter/material.dart';

import '../res/commen/app_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();

  List<String> data = [
    "Sign in",
    "Hey there! Sign up with your email to continue.",
    "Your email"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign_up_page\n"
            "Firebase_Auth_Demo"),
      ),
      body: ListView(
        children: [
          Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int index = 0; index < 3; index++)
                      Text(data[index],
                          style: TextStyle(
                            height: index == 0
                                ? 3
                                : index == 2
                                    ? 5
                                    : 0,
                            color: index == 1
                                ? const Color(0xff8C8A87)
                                : const Color(0xff000000),
                            fontWeight:
                                index == 0 ? FontWeight.w700 : FontWeight.w500,
                            fontSize: index == 0 ? 22 : 14,
                            fontFamily: "Circular Std",
                            fontStyle: FontStyle.normal,
                          )),
                    AppTextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty ||
                            /* !RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
                                .hasMatch(value)) {*/
                            !RegExp(r'\S+@\S+\.+.[com]').hasMatch(value)) {
                          return "Enter Correct Email Address";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const Text("Your password",
                        style: TextStyle(
                          height: 3,
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: "Circular Std",
                          fontStyle: FontStyle.normal,
                        )),
                    AppTextFormField(
                      suffixIcon: IconButton(
                        icon: Icon(isSecurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        iconSize: 20,
                        color: const Color(0xff200E32),
                        onPressed: () {
                          setState(() {
                            isSecurePassword = !isSecurePassword;
                          });
                        },
                      ),
                      labelText: "password",
                      maxLength: 8,
                      controller: passwordController,
                      obscureText: isSecurePassword,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)")
                                .hasMatch(value)) {
                          return "please  valid password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {}, child: Text("Forgot Password")),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.validate();
                            debugPrint("Second Screen====>");
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutesName.secondScreen, (route) => false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        )),
                    Row(
                      children: [
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign in',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            //signup screen
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
