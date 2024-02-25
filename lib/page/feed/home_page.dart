import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/page/feed/widgets/drawer.dart';
import 'package:finessapp/page/feed/widgets/text_field.dart';
import 'package:finessapp/page/feed/widgets/wall_post.dart';
import 'package:finessapp/utility/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utility/utils.dart';
import 'helper/helper_methods.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;



  // void signOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  void postMessage() async {
    String uid = currentUser.uid;
    if (textController.text.isNotEmpty) {
      await fireStore.collection("feed").doc(uid).collection("message").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage(){
    Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _appBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("feed").doc(currentUser.uid).collection("message")
                      .orderBy("TimeStamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return WallPost(
                              message: post['Message'],
                              user: post['UserEmail'],
                              postId: post.id,
                              likes: List<String>.from(post['Likes']??[]),
                              time: formatDate(post["TimeStamp"]),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error:${snapshot.error}'));
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(children: [
                Expanded(
                  child: MyTextField(
                    controller: textController,
                    hintText: "Write something on the wall..",
                    obscureText: false,
                  ),
                ),
                IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.send, color: primaryClr,size: 30,)),
              ]),
            ),
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: primaryClr,
        title: Center(
          child: Text(
            "Feed",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.white,
          ),
        ),
        actions: const [
          SizedBox(
            width: 50,
          ),
        ]);
  }
}
