import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/commen/app_text.dart';
import 'package:firebase_demo_one/res/constant/app_string.dart';
import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:firebase_demo_one/utils/utils.dart';
import 'package:firebase_demo_one/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/user_model.dart';
import '../../res/commen/app_text_form_field.dart';
import 'login_with_phone_number.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  User? userData;
  UserCredential? userCredential;

  Utils utils = Utils();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool value = false;
  bool isSecurePassword = true;
  final formKey = GlobalKey<FormState>();
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState

    //user=FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.loginTitle),
      ),
      body: ListView(
        children: [
          Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft,
                        child: AppText(text: AppString.email)),
                    AppTextFormField(
                        labelText: AppString.email,
                        hintText: AppString.hintEmailName,
                        controller: emailController,
                        validator: (value) =>
                            utils.isValidEmail(emailController.text)
                                ? null
                                : AppString.errorEmailTitle,
                        keyboardType: TextInputType.emailAddress),
                    const Align(
                        alignment: Alignment.topLeft,
                        child: AppText(text: AppString.password)),
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
                        textInputAction: TextInputAction.done,
                        labelText: AppString.password,
                        hintText: AppString.hintTextPassword,
                        controller: passwordController,
                        obscureText: isSecurePassword,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) =>
                            utils.isValidPassword(passwordController.text)
                                ? null
                                : AppString.errorPasswordTitle),
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
                          AppString.login,
                          style: TextStyle(fontSize: 18),
                        )),
                    const AppText(text: AppString.or),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginWithPhoneNumber(),
                              ));
                        },
                        child: const Text(AppString.loginWithMobile)),
                    const AppText(
                      text: AppString.loginWithSocialMedia,
                      fontSize: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          icon: Image.asset(
                            "assets/images/google_logo.png",
                            height: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            userCredential = await signInWithGitHub();
                            userData = userCredential!.user;
                            debugPrint("userdata =$userData");
                          },
                          icon: Image.asset("assets/images/github_logo.png",
                              height: 30),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
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

  ///---------------->>>
  loginUser() async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        debugPrint("Value==>${value.user}");
        if (value.user!.emailVerified) {
          debugPrint("User is Login....");
          userData = value.user;
          getUser();
        } else {
          debugPrint("Please verify the email");
          utils.showSnackBar(
            context,
            message: "Please verify the email",
            label: "Resent",
            onPressed: () => value.user!.sendEmailVerification(),
          );
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

  ///------Get Data FireBaseFireStore--------->>>
  getUser() {
    CollectionReference users = firebaseFireStore.collection('user');
    users.doc(userData!.uid).get().then((value) {
      debugPrint("User Added---->${jsonEncode(value.data())}");
      userModel = userModelFromJson(jsonEncode(value.data()));
      utils.showToastMessage(message: "Login is successfully");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }).catchError((error) {
      debugPrint("Failed to add user: $error");
    });
  }

  ///------SignInWithGoogle--------->>>
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint("googleUser----->$googleUser");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    userCredential = await firebaseAuth.signInWithCredential(credential);
    userData = userCredential!.user;
    debugPrint("userdata-->$userData");
    utils.showToastMessage(message: "Login is Successfully");
  }

  ///------SignInWithGithub--------->>>
  Future<UserCredential> signInWithGitHub() async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: 'c9f2890ed2deb37c7a78',
      clientSecret: '1c716ac8795a1aa4812b930d3b2eb6737f29f928',
      redirectUrl: 'https://fir-demo-app-8423e.firebaseapp.com/__/auth/handler',
    );

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential =
        GithubAuthProvider.credential("${result.token}");

    // Once signed in, return the UserCredential
    return await firebaseAuth.signInWithCredential(githubAuthCredential);
  }
}
