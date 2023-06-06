import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/commen/app_text_form_field.dart';
import 'package:firebase_demo_one/utils/routes_name.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  final formKey = GlobalKey<FormState>();
  TextEditingController  phoneController = TextEditingController();
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
        child: Column(
          children: [
            const CountryCodePicker(
              onChanged: print,
              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
              initialSelection: 'IT',
              favorite: ['+39','FR'],
              // optional. Shows only country name and flag
              showCountryOnly: false,
              // optional. Shows only country name and flag when popup is closed.
              showOnlyCountryWhenClosed: false,
              // optional. aligns the flag and the Text left
              alignLeft: false,
            ),
            const Text("Your Mobile Number",
                style: TextStyle(
                  height: 3,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: "Circular Std",
                  fontStyle: FontStyle.normal,
                )),
            AppTextFormField(
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
            ),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    registerUser();
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
    );
  }

  registerUser() {

     firebaseAuth = PhoneAuthOptions.newBuilder(auth)
        .setPhoneNumber(phoneController.text) // Phone number to verify
        .setTimeout(60L, TimeUnit.SECONDS) // Timeout and unit
        .setActivity(this) // Activity (for callback binding)
        .setCallbacks(callbacks) // OnVerificationStateChangedCallbacks
        .build()
    PhoneAuthProvider.verifyPhoneNumber(options)
  }
}


