import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'login_page/login_with_phone_number.dart';

class OtpPage extends StatefulWidget {
  final String? phone;
  const OtpPage({Key? key, this.phone}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var code = "";
  String? verificationCode;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
        width: 56,
        height: 56,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color.fromRGBO(30, 60, 87, 1),
        ),
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(234, 239, 243, 1),
            ),
            borderRadius: BorderRadius.circular(20)));

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
        borderRadius: BorderRadius.circular(8));
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration
          ?.copyWith(color: const Color.fromRGBO(234, 239, 243, 1)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("otp verification"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "We need to register your phone before getting started !",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    verifyOtp();
                    debugPrint("Home Screen-------->");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Verify phone number"),
                ),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoginWithPhoneNumber(),
                            ),
                            (route) => false);
                      },
                      child: const Text(
                        "Edit Phone number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  verifyOtp() {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: LoginWithPhoneNumber.verify, smsCode: code);
      firebaseAuth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    } catch (e) {
      debugPrint("Wrong Otp");
    }
  }
}
