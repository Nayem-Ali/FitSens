import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<Map<String, dynamic>> getUserInfo() async {
    String uid = auth.currentUser!.uid;
    Map<String, dynamic> userDetails;
    DocumentSnapshot ds = await fireStore.collection("user").doc(uid).get();
    userDetails = ds.data() as Map<String, dynamic>;
    return userDetails;
    // = ds.data() as Map<String, dynamic>?;
  }

  updateUserInfo(Map<String,dynamic> userDetails) async {
    String uid = auth.currentUser!.uid;
    await fireStore.collection("user").doc(uid).update(
      userDetails
    );

  }


}
