import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyFireBaseApp extends StatefulWidget {
  const MyFireBaseApp({Key? key}) : super(key: key);

  @override
  State<MyFireBaseApp> createState() => _MyFireBaseAppState();
}

class _MyFireBaseAppState extends State<MyFireBaseApp> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserCredential? userCredential;
  User? userData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Firebase App", style: TextStyle(fontSize: 25)),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                userCredential = await signInWithGoogle();
                userData = userCredential!.user;
                debugPrint("userdata =$userData");
              },
              icon: Image.asset(
                "assets/images/google_logo.png",
                height: 20,
              ),
              label: const Text("Sign in with Google",
                  style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                userCredential = await signInWithGitHub();
                userData = userCredential!.user;
                debugPrint("userdata =$userData");
              },
              icon: Image.asset("assets/images/github_logo.png", height: 20),
              label: const Text("Sign in with github",
                  style: TextStyle(color: Colors.black)),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "OR",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}