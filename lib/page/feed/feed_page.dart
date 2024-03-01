import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/page/feed/my_post.dart';
import 'package:finessapp/page/feed/widgets/text_field.dart';
import 'package:finessapp/page/feed/widgets/wall_post.dart';
import 'package:finessapp/utility/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../services/db_service.dart';
import '../../utility/utils.dart';
import 'helper/helper_methods.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Map<String, dynamic> userDetails = {};
  DBService dbService = DBService();

  // void signOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  void postMessage() async {
    String uid = currentUser.uid;
    if (textController.text.isNotEmpty) {
      await fireStore.collection("feed").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'name': userDetails['name'],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  getData() async {
    userDetails = await dbService.getUserInfo();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _appBar(),
      body: userDetails.isNotEmpty
          ? Center(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("feed")
                            .orderBy("TimeStamp", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final post = snapshot.data!.docs[index];
                                  return WallPost(
                                    message: post['Message'],
                                    user: post['name'],
                                    postId: post.id,
                                    likes:
                                        List<String>.from(post['Likes'] ?? []),
                                    time: formatDate(post["TimeStamp"]),
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error:${snapshot.error}'));
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                        icon: const Icon(
                          Icons.send,
                          color: primaryClr,
                          size: 30,
                        ),
                      ),
                    ]),
                  ),
                  Text(
                    "Log in as: ${userDetails["name"]}",
                    //"${currentUser.email}",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          : Text(""),
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
        actions: [
          IconButton(
              onPressed: () {
                Get.to(const MyPost());
              },
              icon: const Icon(Icons.confirmation_num_sharp)),
        ]);
  }
}
