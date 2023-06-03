import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login_page"),
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
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Your email",
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
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Your password",
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
                      controller: passwordController,
                      obscureText: isSecurePassword,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"(?=.\d)(?=.[a-z])(?=.[A-Z])(?=.\W)")
                                .hasMatch(value)) {
                          return "please  valid password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            loginUser();
                            debugPrint("Second Screen!!!!!!!!!!!---->");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(300, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Do not have an Account?'),
                        TextButton(
                          child: const Text(
                            'Signup',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.secondScreen,
                            );
                            //signup screen
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  loginUser() async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        debugPrint("Value==>${value.user}");
        user = value.user;
        if (user!.emailVerified) {
          debugPrint("User is Login....");
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.homeScreen, (route) => false);
        } else {
          debugPrint("Please verify the email");
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
  }
}
