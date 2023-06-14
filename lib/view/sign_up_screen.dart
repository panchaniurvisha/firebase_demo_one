import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/commen/app_text.dart';
import 'package:firebase_demo_one/utils/utils.dart';
import 'package:firebase_demo_one/view/login_screen.dart';
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
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  User? user;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();
  Utils utils = Utils();

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
                    const AppText(text: "First Name"),
                    AppTextFormField(
                      controller: firstNameController,
                      validator: (value) =>
                          utils.isValidName(firstNameController.text)
                              ? null
                              : "Please Enter Correct Name,",
                      labelText: "First Name",
                      hintText: "Enter First name",
                    ),
                    const AppText(text: "Last Name"),
                    AppTextFormField(
                      controller: lastNameController,
                      validator: (value) =>
                          utils.isValidName(lastNameController.text)
                              ? null
                              : "Please Enter Correct Name,",
                      labelText: "Last Name",
                      hintText: "Enter Last name",
                    ),
                    const AppText(text: "Email"),
                    AppTextFormField(
                      labelText: "Email",
                      hintText: "Enter Email",
                      controller: emailController,
                      validator: (value) =>
                          utils.isValidEmail(emailController.text)
                              ? null
                              : "Please Enter Correct Email,",
                    ),
                    const AppText(text: "Password"),
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
                      hintText: "Enter Password",
                      controller: passwordController,
                      obscureText: isSecurePassword,
                      validator: (value) =>
                          utils.isValidPassword(passwordController.text)
                              ? null
                              : "Please valid Password ,",
                    ),
                    const AppText(text: "Phone no"),
                    AppTextFormField(
                      controller: numberController,
                      labelText: "Number",
                      hintText: "Enter Number",
                      validator: (value) =>
                          utils.isValidMobile(numberController.text)
                              ? null
                              : "Please Enter Correct Number,",
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
                          if (formKey.currentState!.validate()) {
                            createUser();
                            debugPrint("First Screen====>");
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
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
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
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        debugPrint("Value==>${value.user}");
        user = value.user;
        user!.sendEmailVerification();
        createUserData();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.---->');
        utils.showSnackBar(context,
            message: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        utils.showSnackBar(context,
            message: "The account already exists for that email.");
      }
    } catch (e) {
      debugPrint("Error===>$e");
    }
  }

  createUserData() {
    CollectionReference users = firebaseFireStore.collection('user');
    users.doc(user!.uid).set({
      'id': user!.uid, // John Doe
      'first_name': firstNameController.text, // Stokes and Sons
      'last_name': lastNameController.text,
      "number": numberController.text,
      "email ": user!.email, // 42
    }).then((value) {
      utils.showToastMessage(
          message: " SignUp is complete,Please verify your email");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
    }).catchError((error) {
      debugPrint("Failed to add user: $error");
    });
  }
}
