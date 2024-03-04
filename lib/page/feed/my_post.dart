import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/page/feed/widgets/formate_date.dart';
import 'package:finessapp/page/feed/widgets/text_field.dart';
import 'package:finessapp/page/feed/widgets/wall_post.dart';
import 'package:finessapp/utility/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/db_service.dart';
import '../../utility/utils.dart';

class MyPost extends StatefulWidget {
  const MyPost({
    Key? key,
  }) : super(key: key);

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late Map<String, dynamic> userDetails = {};
  DBService dbService = DBService();
  late List<DocumentSnapshot> _posts;

  void postMessage() async {
    if (textController.text.isNotEmpty) {
      await fireStore.collection("feed").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'name':userDetails['name'],
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
                            .where("UserEmail",
                                isEqualTo:
                                    currentUser.email) // Filter by user email
                            //.orderBy("TimeStamp", descending: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {

                            _posts = snapshot.data!.docs;
                            _posts.sort((a, b) {
                              Timestamp aTime = a['TimeStamp'];
                              Timestamp bTime = b['TimeStamp'];
                              return bTime.compareTo(aTime);
                            });

                            return ListView.builder(
                                itemCount: _posts.length,
                                itemBuilder: (context, index) {
                                  final post = _posts[index];
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
                          )),
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
          : const Text(""),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: primaryClr,
        title: Center(
          child: Text(
            "My Post",
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
              onPressed: () {}, icon: const Icon(Icons.confirmation_num_sharp)),
        ]);
  }
}
