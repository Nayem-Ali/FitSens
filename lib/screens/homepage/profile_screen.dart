import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/screens/homepage/activity_history.dart';
import 'package:finessapp/screens/homepage/home_screen.dart';
import 'package:finessapp/screens/homepage/workout_progress.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:finessapp/widgets/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as p;
import '../../utility/color.dart';
import '../auth/login_screen.dart';
import '../../services/db_service.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({Key? key,}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  late Map<String, dynamic> userDetails = {};
  late int age;
  bool darkMode = false;
  final ImagePicker _picker = ImagePicker();
  late File image;
  String url = "";

  Future selectPhoto(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile == null) {
      return;
    }

    var file = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
    if (file == null) {
      return;
    } else {
      image = File(file.path);
    }
    await uploadFile();
  }

  Future uploadFile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;


    try {
      final destination = 'files/${auth.currentUser!.uid}';
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(image);
      String tempUrl = await ref.getDownloadURL();

      await firestore
          .collection("user")
          .doc(auth.currentUser!.uid)
          .update({"img": tempUrl});
      Get.snackbar("Dear ${userDetails["name"]}",
          "Your profile picture is uploaded successfully.",
          backgroundColor: Colors.grey);
      url = tempUrl;
      setState(() {});
    } catch (e) {
      print('error occurred');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    //darkMode = Brightness.dark == MediaQuery.of(context).platformBrightness;
  }

  getData() async {
    DBService db = DBService();
    userDetails = await db.getUserInfo();
    DateTime date1 = DateTime.parse(userDetails["dob"]);
    age = DateTime.now().year - date1.year;
    url = userDetails["img"];
    setState(() {});
  }

  profilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        var screenSize = MediaQuery.of(context).size;
        return SizedBox(
          width: screenSize.width,
          height: screenSize.height * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectPhoto(ImageSource.gallery);
                },
                label: const Text("Gallery"),
                icon: const Icon(Icons.image),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  selectPhoto(ImageSource.camera);
                },
                label: const Text("Camera"),
                icon: const Icon(Icons.camera_alt),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.off(const HomeScreen());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: userDetails.isEmpty
          ? const SizedBox(
              child: Center(
                child: Text("Loading...."),
              ),
            )
          : SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: url != ""
                              ? NetworkImage(url)
                              : const AssetImage('assets/profile.png') as ImageProvider,
                        ),
                        Expanded(
                          child: Text(
                            userDetails["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            gradient: LinearGradient(colors: [
                              ColorCode.primaryColor1,
                              ColorCode.primaryColor1
                            ]),
                          ),
                          child: ElevatedButton(
                            onPressed: profilePicture,
                            style: ElevatedButton.styleFrom(
                              //maximumSize: const Size(20,20),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                          child: Text(
                            userDetails["height"] + " cm\n Height",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                // color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                          child: Text(
                            userDetails["weight"] + " kg\n Weight",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                // color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: thirdGradient,
                        ),
                        child: Center(
                          child: Text(
                            "$age yo \nAge",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                // color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Account",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.to(EditProfile(userDetails: userDetails));
                          },
                          style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text("Edit Personal Data"),
                          icon: const Icon(Icons.edit),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.to(()=>const ActivityHistory());
                          },
                          style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text("Activity History"),
                          icon: const Icon(Icons.stacked_line_chart),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {

                          },
                          style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text("Workout Progress"),
                          icon: const Icon(Icons.bar_chart),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Others",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Enable Dark-Mode",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            Switch(
                              value: darkMode,
                              onChanged: (value) {
                                setState(() {
                                  darkMode = value;
                                  if (darkMode) {
                                    Get.changeTheme(ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.fromSeed(
                                            seedColor:
                                                ColorCode.gray)));
                                  } else {
                                    Get.changeTheme(
                                      ThemeData.from(
                                        colorScheme: ColorScheme.fromSeed(
                                          seedColor: ColorCode.primaryColor1,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Are you sure to logout"),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await auth.signOut().whenComplete(() {
                                          Get.offAll(const LoginScreen());
                                        });
                                      },
                                      child: const Text("Yes"),
                                    ),
                                    TextButton(
                                      onPressed: ()  {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("No"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              textStyle: const TextStyle(fontSize: 15)),
                          label: const Text("Logout"),
                          icon: const Icon(Icons.exit_to_app),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
