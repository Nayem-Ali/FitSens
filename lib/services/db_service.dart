import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

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

  addDietPlan(Map<String, dynamic> data, String mealType) async {
    String uid = auth.currentUser!.uid;
    await fireStore.collection('user').doc(uid).collection('dietPlan').doc(mealType).set(data);
  }

  getDietPlan() async {
    List<dynamic> allData = [];
    String uid = auth.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot =
          await fireStore.collection('user').doc(uid).collection('dietPlan').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  addWorkoutData(Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection('user')
        .doc(uid)
        .collection('Workout')
        .doc(data['id'])
        .set(data);
  }

  addSleepData(Map<String, dynamic> data) async {
    String uid = auth.currentUser!.uid;
    await fireStore
        .collection('user')
        .doc(uid)
        .collection('Sleep')
        .doc(data['id'])
        .set(data);
  }

  getWorkoutData() async {
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot =
      await fireStore.collection('user').doc(uid).collection('Workout').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  getSleepDataForChart()async{
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot =
          await fireStore.collection('user').doc(uid).collection('Sleep').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  getSleepData()async{
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];
    try {
      final querySnapshot =
      await fireStore.collection('sleep').doc(uid).collection('schedule').get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;
    } catch (e) {
      return [];
    }
  }

  addDrinkSchedule(Map<String, dynamic> drinksData) async {
    String uid = auth.currentUser!.uid;
    fireStore
        .collection('user')
        .doc(uid)
        .collection('DrinkSchedule')
        .doc(now.toString())
        .set(drinksData);
  }

  getDrinkSchedule() async {
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];

    try {
      final querySnapshot = await fireStore
          .collection('user')
          .doc(uid)
          .collection('DrinkSchedule')
          .get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;

    } catch (e) {
      return [];
    }
  }

  addNotifications(Map<String, dynamic> notificationsData)async{
    String uid = auth.currentUser!.uid;
    fireStore
        .collection('user')
        .doc(uid)
        .collection('notifications')
        .doc(now.toString())
        .set(notificationsData);
  }

  getNotifications()async{
    String uid = auth.currentUser!.uid;
    List<Map<String, dynamic>>? allData = [];

    try {
      final querySnapshot = await fireStore
          .collection('user')
          .doc(uid)
          .collection('notifications')
          .get();
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      return allData;

    } catch (e) {
      return [];
    }
  }

  updateDrinkSchedule(int index, bool status)async{
    String uid = auth.currentUser!.uid;
    List<String>? allData = [];

    try {
      final querySnapshot = await fireStore
          .collection('user')
          .doc(uid)
          .collection('DrinkSchedule')
          .get();
      allData = querySnapshot.docs.map((doc) => doc.id).toList();
      await fireStore
          .collection('user')
          .doc(uid)
          .collection('DrinkSchedule')
      .doc(allData[index]).update({'isOn':status});
      print(allData[index]);
    } catch (e) {

    }
  }

  deleteDrinkSchedule(int index)async{
    String uid = auth.currentUser!.uid;
    List<String>? allData = [];

    try {
      final querySnapshot = await fireStore
          .collection('user')
          .doc(uid)
          .collection('DrinkSchedule')
          .get();
      allData = querySnapshot.docs.map((doc) => doc.id).toList();
      await fireStore
          .collection('user')
          .doc(uid)
          .collection('DrinkSchedule')
          .doc(allData[index]).delete();
      print(allData[index]);
    } catch (e) {

    }
  }

  deleteNotifications(int index)async{
    String uid = auth.currentUser!.uid;
    List<String>? allData = [];

    try {
      final querySnapshot = await fireStore
          .collection('user')
          .doc(uid)
          .collection('notifications')
          .get();
      allData = querySnapshot.docs.map((doc) => doc.id).toList();
      await fireStore
          .collection('user')
          .doc(uid)
          .collection('notifications')
          .doc(allData[index]).delete();
      print(allData[index]);
    } catch (e) {

    }
  }



}
