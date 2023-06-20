import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/res/commen/app_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/user_model.dart';
import '../../utils/utils.dart';
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
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Utils utils = Utils();
  UserModel? userModel;

  final ImagePicker picker = ImagePicker();
  XFile? image, galleryImage;
  File? imageFile, captureImage;

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

  pickImage() async {
    image = await picker.pickImage(source: ImageSource.camera);
    imageFile = File(image!.path);
    storeImage();
    setState(() {});
  }

  storeImage() async {
    try {
      final UploadTask uploadTask = firebaseStorage
          .ref()
          .child("images")
          .child("profile.png")
          .putFile(imageFile!);
// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            debugPrint("Upload was error");
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            debugPrint("Upload was success");
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
    } on FirebaseException catch (e) {
      utils.showSnackBar(context, message: e.message);
    }
  }

  pickImageFromGallery() async {
    galleryImage = await picker.pickImage(source: ImageSource.gallery);
    captureImage = File(galleryImage!.path);
    storeGalleryImage();
    setState(() {});
  }

  storeGalleryImage() async {
    try {
      final UploadTask uploadTask = firebaseStorage
          .ref()
          .child("images")
          .child("profile_one.png")
          .putFile(captureImage!);
// Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            debugPrint("Upload is $progress% complete.");
            break;
          case TaskState.paused:
            debugPrint("Upload is paused.");
            break;
          case TaskState.canceled:
            debugPrint("Upload was canceled");
            break;
          case TaskState.error:
            debugPrint("Upload was error");
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            debugPrint("Upload was success");
            // Handle successful uploads on complete
            // ...
            break;
        }
      });
    } on FirebaseException catch (e) {
      utils.showSnackBar(context, message: e.message);
    }
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
        child: userModel == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipOval(
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : captureImage != null
                                ? Image.file(
                                    captureImage!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/profile.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                          onPressed: () => showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            // barrierColor: Colors.transparent,
                            builder: (context) => Container(
                              height: 150,
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Profile photo",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white12),
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            onPressed: () => pickImage(),
                                            icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.white12),
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            onPressed: () =>
                                                pickImageFromGallery(),
                                            icon: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Image.asset(
                                                "assets/images/gallery_icon.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const AppText(
                    text: "Data Get From Model",
                    fontSize: 20,
                    color: Colors.indigoAccent,
                  ),
                  AppText(
                    text: "first_name: ${userModel!.firstName}",
                  ),
                  AppText(
                    text: "last_name: ${userModel!.lastName}",
                  ),
                  AppText(
                    text: "Email: ${userModel!.email}",
                  ),
                  AppText(
                    text: "Phone number: ${userModel!.number}",
                  ),
                  AppText(
                    text: "Id: ${userModel!.id}",
                  ),
                ],
              ),
      ),
    );
  }
}
