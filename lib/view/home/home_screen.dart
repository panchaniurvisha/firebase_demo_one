import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../login_page/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  UserModel? userModel;
  getUser() {
    CollectionReference users = firebaseFireStore.collection('user');
    users.doc(firebaseAuth.currentUser!.uid).get().then((value) {
      debugPrint("User Added---->${jsonEncode(value.data())}");
      userModel = userModelFromJson(jsonEncode(value.data()));
      setState(() {});
    }).catchError((error) {
      debugPrint("Failed to get user: $error");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
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
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: userModel != null
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Data Get From Model",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.orangeAccent, height: 2),
              ),
              Text("first_name: ${userModel!.firstName}", style: const TextStyle(height: 2, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("last_name: ${userModel!.lastName}", style: const TextStyle(height: 2, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Email: ${userModel!.email}", style: const TextStyle(height: 2, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Phone number: ${userModel!.number}", style: const TextStyle(height: 2, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Id: ${userModel!.id}", style: const TextStyle(height: 2, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          )
              : const CircularProgressIndicator()),
    );
  }
}