import 'package:firebase_demo_one/res/commen/app_text.dart';
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
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: AppString.forgotPasswordTitle),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          const AppText(
            text: AppString.text,
          ),
          const AppText(text: AppString.email),
          AppTextFormField(
            labelText: AppString.email,
            hintText: AppString.hintEmailName,
            controller: emailController,
            validator: (value) => utils.isValidEmail(emailController.text) ? null : AppString.errorEmailTitle,
            keyboardType: TextInputType.emailAddress,
          ),
          ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  debugPrint("Next Login Screen====>");
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text(
                AppString.resetPassword,
                style: TextStyle(fontSize: 18),
              )),
        ],
      )),
    );
  }

  verifyEmail() {}
}
