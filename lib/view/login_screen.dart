import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:flutter/material.dart';

import '../res/commen/app_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login_page"),
      ),
      body: ListView(
        children: [
          Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text("Your email",
                          style: TextStyle(
                            height: 3,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: "Circular Std",
                            fontStyle: FontStyle.normal,
                          )),
                    ),
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text("Your password",
                          style: TextStyle(
                            height: 3,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: "Circular Std",
                            fontStyle: FontStyle.normal,
                          )),
                    ),
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
                      height: 50,
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
                          fixedSize: const Size(120, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
