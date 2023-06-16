import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/commen/app_text.dart';
import 'package:firebase_demo_one/res/constant/app_string.dart';
import 'package:firebase_demo_one/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../res/commen/app_text_form_field.dart';
import '../login_page/login_screen.dart';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.signupTitle),
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
                    const AppText(text: AppString.firstName),
                    AppTextFormField(
                      controller: firstNameController,
                      validator: (value) =>
                          utils.isValidName(firstNameController.text)
                              ? null
                              : AppString.errorTitle,
                      labelText: AppString.firstName,
                      hintText: AppString.hintTextName,
                      keyboardType: TextInputType.name,
                    ),
                    const AppText(text: AppString.lastname),
                    AppTextFormField(
                      controller: lastNameController,
                      validator: (value) =>
                          utils.isValidName(lastNameController.text)
                              ? null
                              : AppString.errorTitle,
                      labelText: AppString.lastname,
                      hintText: AppString.hintTextLastName,
                      keyboardType: TextInputType.name,
                    ),
                    const AppText(text: AppString.email),
                    AppTextFormField(
                      labelText: AppString.email,
                      hintText: AppString.hintEmailName,
                      controller: emailController,
                      validator: (value) =>
                          utils.isValidEmail(emailController.text)
                              ? null
                              : AppString.errorEmailTitle,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const AppText(text: AppString.password),
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
                        labelText: AppString.password,
                        hintText: AppString.hintTextPassword,
                        controller: passwordController,
                        obscureText: isSecurePassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) =>
                            utils.isValidPassword(passwordController.text)
                                ? null
                                : AppString.errorPasswordTitle,
                        keyboardType: TextInputType.visiblePassword),
                    const AppText(text: AppString.mobileNo),
                    AppTextFormField(
                        controller: phoneNumberController,
                        labelText: AppString.number,
                        hintText: AppString.hintTextNumber,
                        validator: (value) =>
                            utils.isValidMobile(phoneNumberController.text)
                                ? null
                                : AppString.errorNumberTitle,
                        keyboardType: TextInputType.phone),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            createUser();
                            debugPrint("Next Login Screen====>");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(400, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text(
                          AppString.signup,
                          style: TextStyle(fontSize: 18),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppString.createAccount),
                        TextButton(
                          child: const Text(
                            AppString.login,
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

  ///----EMAIL SHOW IN AUTH
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

  ///------DATA SHOW IN  FIRESTORE DATABASE
  createUserData() {
    CollectionReference users = firebaseFireStore.collection('user');
    users.doc(user!.uid).set({
      'id': user!.uid, // John Doe
      'first_name': firstNameController.text, // Stokes and Sons
      'last_name': lastNameController.text,
      "number": phoneNumberController.text,
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
