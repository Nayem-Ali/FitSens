import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> dummyNotifications = [
    {
      "title": "Don't miss your lower body workout",
      "subtitle": "About 30 minutes ago"
    },
    {
      "title": "Congratulation. You have finished your today's activity.",
      "subtitle": "28 May"
    },
    {
      "title": "Oops. You missed your upper body workout.",
      "subtitle": "3 April"
    },
  ];

  DateTime now = DateTime.now();

  List<Map<String, dynamic>> allNotifications = [];
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;

  double h1 = 0.0, h2 = 0.0;

  getData() async {
    //allSchedule.clear();
    allNotifications = await DBService().getNotifications();
    for (var notification in allNotifications) {
      if (notification['title'] == "It’s Drink Time") {
        DateTime now = DateTime.now();
        DateTime date = (notification['date'] as Timestamp).toDate();
        DateTime date2 =
            DateTime(now.year, now.month, now.day, date.hour, date.minute);
        notification['date'] = date2 as Timestamp;
      }
    }
    allNotifications.sort((a, b) => b['date'].compareTo(a['date']));
    //print(allNotifications);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView.builder(
        itemCount: allNotifications.length,
        itemBuilder: (context, index) {
          final isFuture = (DateTime.now()
                  .difference(allNotifications[index]['date'].toDate()))
              .isNegative;
          return Column(
            children: [
              Dismissible(
                key: Key(UniqueKey().toString()),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    DBService().deleteNotifications(index);
                    getData();
                    Get.snackbar("Notifications", "Successfully Deleted",
                        backgroundColor: Colors.red, colorText: Colors.white);
                  } else {
                    setState(() {});
                    Get.snackbar("Notifications",
                        "For delete you have swipe Left to Right");
                  }
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isFuture
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          color: index % 2 == 1
                              ? ColorCode.primaryColor1
                              : ColorCode.secondaryColor1,
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${allNotifications[index]['title']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  '${allNotifications[index]['body']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  '${allNotifications[index]['date'].toDate()}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  '${allNotifications[index]['time']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryClr,
      title: Center(
        child: Text(
          "Notifications",
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
      ],
    );
  }
}
