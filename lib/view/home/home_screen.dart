import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? uid;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = firebaseAuth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  firebaseAuth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: const Center(
          child: Text("uid", style: TextStyle(fontSize: 30)),
        ));
  }
}
