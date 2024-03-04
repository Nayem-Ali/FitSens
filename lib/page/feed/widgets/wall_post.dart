import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/db_service.dart';
import 'comment.dart';
import 'formate_date.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final commentTextController = TextEditingController();
  late Map<String, dynamic> userDetails = {};
  DBService dbService = DBService();
  getData() async {
    userDetails = await dbService.getUserInfo();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('feed').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("feed")
        .doc(widget.postId)
        .collection("comments")
        .add({
      "CommentText": commentText,
      "CommentBy": userDetails["name"],
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              addComment(commentTextController.text);
              commentTextController.clear();
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you wanna delete this post?"),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () async {
                final commentDocs = await FirebaseFirestore.instance
                    .collection('feed')
                    .doc(widget.postId)
                    .collection("comments")
                    .get();

                for (var doc in commentDocs.docs) {
                  await FirebaseFirestore.instance
                      .collection("feed")
                      .doc(widget.postId)
                      .collection("comments")
                      .doc(doc.id)
                      .delete();
                }
                FirebaseFirestore.instance
                    .collection("feed")
                    .doc(widget.postId)
                    .delete();
                Get.snackbar("Delete Post", "Delete Successfully");
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.message,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                " . ",
                style: TextStyle(color: Colors.grey[400]),
              ),
              Text(
                widget.time,
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                      onPressed: toggleLike,
                      icon: Icon(
                        size: 30,
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      )),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        showCommentDialog();
                      },
                      icon: const Icon(
                        Icons.comment,
                        size: 30,
                        color: Colors.grey,
                      )),

                  const Text(
                    ' ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Column(
                children: [
                  if (userDetails["name"] == widget.user)
                    IconButton(
                        onPressed: () {
                          deletePost();
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 30,
                          color: Colors.redAccent,
                        )),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    ' ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("feed")
                .doc(widget.postId)
                .collection("comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>?;

                  if (commentData == null) {
                    return const SizedBox
                        .shrink(); // or return an empty widget if needed
                  }
                  return Comment(
                    text: commentData["CommentText"] as String? ?? "",
                    user: commentData["CommentBy"] as String? ?? "",
                    time: formatDate(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
