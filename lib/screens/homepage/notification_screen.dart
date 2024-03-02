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

  DateTime now = DateTime.now();

  List<Map<String, dynamic>> allNotifications = [];
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;

  double h1 = 0.0, h2 = 0.0;

  double difForNotify=0.0;
  double difference=0.0;

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

    DateTime dateTime = DateTime.now();
    String id = DateFormat.yMMMd().format(dateTime);
    for(var diff in allNotifications){
      print(id);
      if(diff['id'] == id){
        difference = diff['difference'] * 1.0;
      }
      print(difference);
    }

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
          final ago = (DateTime.now()
              .difference(allNotifications[index]['date'].toDate()));


          return Column(
            children: [
              Dismissible(
                key: Key(UniqueKey().toString()),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await DBService().deleteNotifications(index);
                    //getData();
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
                                  'about ${ago.inHours} h ${ago.inMinutes~/60} min ago',
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

  // dif() {
  //
  //     DateTime dateForDif = DateTime.now();
  //
  //     int h = int.parse(dateForDif.hour.toString().padLeft(2, '0'));
  //     int hTemp= h;
  //     if(h>12) {
  //       h=h-12;
  //     }
  //
  //     String hourAndMinute;
  //     if(hTemp>12){
  //       hourAndMinute = '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"PM"}';
  //     }else{
  //       hourAndMinute = '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"AM"}';
  //     }
  //
  //
  //     List<String>l=difference.toString().split(" ");
  //     List<String>l1=hourAndMinute.split(" ");
  //
  //     double m1 = double.parse(difference.toString().split(":")[1].split(" ")[0])/60;
  //     double m2 = double.parse(hourAndMinute.split(":")[1].split(" ")[0])/60;
  //
  //     double h1 = double.parse(difference.toString().split(":")[0])+m1;
  //     double h2 = double.parse(hourAndMinute.split(":")[0]);
  //     if(h2.toInt()==0){
  //       h2=12+m2;
  //     }else{
  //       h2 = double.parse(hourAndMinute.split(":")[0])+m2;
  //     }
  //     print(m2);
  //     print(hourAndMinute);
  //     print('$h1 $h2');
  //     print('$l $l1');
  //
  //     if(l[1]==l1[1]){
  //       difForNotify = ((h1-h2).abs()) * 3600;
  //     }else{
  //       difForNotify = (24-(h1+12-h2).abs()) * 3600;
  //     }
  //     print(difForNotify);
  //
  //
  //
  //   setState(() {
  //
  //   });
  //
  // }
}
