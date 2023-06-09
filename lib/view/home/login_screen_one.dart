import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/view/otp_page.dart';
import 'package:flutter/material.dart';

class LoginScreenOne extends StatefulWidget {
  const LoginScreenOne({
    Key? key,
  }) : super(key: key);
  static String verify = "";

  @override
  State<LoginScreenOne> createState() => _LoginScreenOneState();
}

class _LoginScreenOneState extends State<LoginScreenOne> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var phone = "";
  User? user;
  TextEditingController countryCode = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryCode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Phone Verification",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We need to register your phone before getting started !",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 30,
                          child: TextField(
                            controller: countryCode,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                          )),
                      const Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            phone = value;
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: "Phone"),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      verifyPhoneNumber();
                      debugPrint("Otp Screen!!!!!!!!!!!---->");
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Send the code"),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  verifyPhoneNumber() async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: countryCode.text + phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        LoginScreenOne.verify = verificationId;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpPage(),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
