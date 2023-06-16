import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/constant/app_string.dart';
import 'package:firebase_demo_one/utils/utils.dart';
import 'package:flutter/material.dart';

import '../res/commen/app_text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  Utils utils = Utils();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(AppString.resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppString.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            AppTextFormField(
              labelText: AppString.email,
              hintText: AppString.hintEmailName,
              controller: emailController,
              validator: (value) => utils.isValidEmail(emailController.text)
                  ? null
                  : AppString.errorEmailTitle,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  verifyEmail();
                  debugPrint("Next Login Screen====>");
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              icon: const Icon(Icons.email_outlined),
              label: const Text(
                AppString.resetPassword,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  verifyEmail() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      firebaseAuth.sendPasswordResetEmail(email: emailController.text.trim());
      utils.showSnackBar(context,
          message: "Password reset link sent! Check your email");
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      debugPrint("e----->$e");
      utils.showSnackBar(context, message: e.message);
      Navigator.pop(context);
    }
  }
}
