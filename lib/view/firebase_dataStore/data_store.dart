import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataStore extends StatefulWidget {
  const DataStore({Key? key}) : super(key: key);

  @override
  State<DataStore> createState() => _DataStoreState();
}

class _DataStoreState extends State<DataStore> {
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FireBase Cloud FireStore"),
      ),
      body: ElevatedButton(
        onPressed: () async {
          createUserData();
        },
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(350, 50)),
            backgroundColor: MaterialStateProperty.all(Colors.white)),
        child: const Text("create User Data",
            style: TextStyle(color: Colors.black)),
      ),
    );
  }

  createUserData() {
    CollectionReference users = firebaseFireStore.collection('users');

    users
        .add({
          'full_name': "Urvisha Panchani", // John Doe
          'company': "Skill qode", // Stokes and Sons
          'age': 24 // 42
        })
        .then((value) => debugPrint("User Added---->${value.get()}"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }
}
