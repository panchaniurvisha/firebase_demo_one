import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  final String? phone;
  const OtpPage({Key? key, this.phone}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? verificationCode;
  final FocusNode pinPutFocusNode = FocusNode();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController pinPutController = TextEditingController();

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(20)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("otp verification"),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  "verify +1-${widget.phone}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            ),
            Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                controller: pinPutController,
                pinAnimationType: PinAnimationType.fade,
                onSubmitted: (pin) async {
                  try {
                    await firebaseAuth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: verificationCode!, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false);
                      }
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                })
          ],
        ));
  }

  verifyPhone() async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+1${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        firebaseAuth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {});
      },
    );
  }
}
