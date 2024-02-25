import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_methods.dart';
import 'comment.dart';
import 'comment_button.dart';
import 'like_button.dart';


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
      required this.likes, required this.time});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  final commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('feed').doc(currentUser.uid).collection("message").doc(widget.postId);

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
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentBy": currentUser.email,
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
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.grey[400],
          //   ),
          //   padding: EdgeInsets.all(10),
          //   child: Icon(
          //     Icons.person,
          //     color: Colors.white,
          //   ),
          // ),

          Text(
            widget.message,
          ),

          const SizedBox(
            height: 5,
          ),

          Row(
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[400]),),
              Text(" . ", style: TextStyle(color: Colors.grey[400]),),
              Text(widget.time, style: TextStyle(color: Colors.grey[400]),),
            ],
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       widget.user,
          //       style: TextStyle(color: Colors.grey[500]),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '0',
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
                .collection("User Posts")
                .doc(widget.postId)
                .collection("Comments")
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
                    return SizedBox.shrink(); // or return an empty widget if needed
                  }

                  //final String commentText = commentData["CommentText"] as String? ?? "";
                  //final String commentedBy = commentData["CommentedBy"] as String? ?? "";

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
