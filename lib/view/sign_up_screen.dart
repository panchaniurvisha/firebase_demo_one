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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();

  List<String> data = [
    "Sign up",
    "Hey there! create your profile to start your journey",
    "Your email"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign_up_page\n"
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
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () {},
                          child: const Text("Forgot Password")),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          createUser();
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
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 18),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an Account?'),
                        TextButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutesName.secondScreen, (route) => false);
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

  createUser() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        debugPrint("Value==>${value.user}");
        user = value.user;
        user!.sendEmailVerification();
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint("Error===>$e");
    }
  }
}
