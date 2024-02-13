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

  updateUserInfo(Map<String, dynamic> userDetails) async {
    String uid = auth.currentUser!.uid;
    await fireStore.collection("user").doc(uid).update(userDetails);
  }

  addSteps(Map<String, dynamic> stepsData) async {
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection('user')
        .doc(uid)
        .collection('steps')
        .doc(stepsData['id'])
        .set(stepsData);
  }

  getSteps() async {
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot = await fireStore.collection('user').doc(uid).collection('steps').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  addBPMData(Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    await fireStore.collection('user').doc(uid).collection('BPM').doc(data['id']).set(data);
  }

  getBPMData() async {
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot = await fireStore.collection('user').doc(uid).collection('BPM').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  addWaterIntakeData(Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection('user')
        .doc(uid)
        .collection('WaterIntake')
        .doc(data['id'])
        .set(data);
  }

  getWaterIntakeData() async {
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot =
          await fireStore.collection('user').doc(uid).collection('WaterIntake').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }
}
