import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:firebase_demo_one/view/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreenOne extends StatefulWidget {
  const LoginScreenOne({Key? key}) : super(key: key);

  @override
  State<LoginScreenOne> createState() => _LoginScreenOneState();
}

class _LoginScreenOneState extends State<LoginScreenOne> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? verificationCode = "";
  User? user;
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const Text("Your Mobile Number",
                  style: TextStyle(
                    height: 3,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    fontFamily: "Circular Std",
                    fontStyle: FontStyle.normal,
                  )),
              IntlPhoneField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: Colors.black26, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  debugPrint(phone.completeNumber);
                },
              ),
              /*AppTextFormField(
                controller: phoneController,,
                labelText: "Mobile Number",
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s./0-9]*$')
                          .hasMatch(value)) {
                    return "Enter Valid Phone Number";
                  } else {
                    return null;
                  }
                },
              ),*/
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      registerUser();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpPage(),
                          ),
                          (route) => false);
                      debugPrint("Home Screen====>");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Text(
                    "Register",
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
        ),
      ),
    );
  }

  registerUser() async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+44 7123 123 456',
      verificationCompleted: (PhoneAuthCredential credential) {
        firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
