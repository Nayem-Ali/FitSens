import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:finessapp/page/sleep/ideal_sleep.dart';
import 'package:finessapp/page/sleep/sleep_home.dart';
import 'package:finessapp/page/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../services/db_service.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';
import 'widgets/sleep_container.dart';
import 'add_sleep_schedule.dart';

class SleepSchedule extends StatefulWidget {
  const SleepSchedule({Key? key}) : super(key: key);

  @override
  State<SleepSchedule> createState() => _SleepScheduleState();
}

class _SleepScheduleState extends State<SleepSchedule> {
  CollectionReference user1 = FirebaseFirestore.instance.collection('user');


  CollectionReference sleep = FirebaseFirestore.instance.collection('sleep');
  User? user = FirebaseAuth.instance.currentUser;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DateTime _selectedDate = DateTime.now();
  DBService dbService = DBService();
  List<Map<String, dynamic>> sleepData = [];
  late Map<String, dynamic> userDetails = {};
  late double durationSleepNotify;
  // ignore: prefer_typing_uninitialized_variables
  var hour, min;
  int age=0;

  @override
  void initState() {
    super.initState();
    // TODO: imple
    difSleep();
    getData();
  }
  getData() async {
    sleepData = await dbService.getSleepData();
    sleepData.sort((a, b) {
      if (a['id'] != null &&
          a['id'] is Timestamp &&
          b['id'] != null &&
          b['id'] is Timestamp) {
        Timestamp aTimestamp = a['id'];
        Timestamp bTimestamp = b['id'];
        return aTimestamp.compareTo(bTimestamp);
      } else {
        // Handle the case where 'id' is null or not a Timestamp
        // For example, if 'id' is a String or another type, you can handle it here
        // This example assumes a default behavior of sorting by 'bed_time' if 'id' is not a Timestamp
        String aBedTime = a['bed_time'] ?? '';
        String bBedTime = b['bed_time'] ?? '';
        return aBedTime.compareTo(bBedTime);
      }
    });
    userDetails = await dbService.getUserInfo();
    difSleep();
    age = (DateTime.now().year - DateTime.parse(userDetails['dob']).year);
    print(age);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 25, top: 10),
          height: 120 * fem,
          width: 375 * fem,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: primaryGradient,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 18),
                    child: Text(
                      "Ideal Hours for Sleep",
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if(age>=1 && age<=2)
                    Container(
                      margin: const EdgeInsets.only(left: 16,top: 5, bottom: 6),
                      child: Text(
                        "11–14 hours",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if(age>=3 && age<=5)
                    Container(
                      margin: const EdgeInsets.only(left: 16,top: 5, bottom: 6),
                      child: Text(
                        "10–13 hours",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if(age>=6 && age<=12)
                    Container(
                      margin: const EdgeInsets.only(left: 16,top: 5, bottom: 6),
                      child: Text(
                        "9–12 hours",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if(age>=13 && age<=18)
                    Container(
                      margin: const EdgeInsets.only(left: 16,top: 5, bottom: 6),
                      child: Text(
                        "8-10 hours",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if(age>=18)
                    Container(
                      margin: const EdgeInsets.only(left: 16,top: 5, bottom: 6),
                      child: Text(
                        "7 or more hours",
                        style: SafeGoogleFont(
                          'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.only(left: 25),
                    child: MyButton(
                        label: 'View more',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const IdealSleep()),
                          );
                        },
                        width: 90,
                        height: 35,
                        fontSize: 12),
                  )
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 5),
                  child: Image.asset("assets/Layer.png")),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(25 * fem, 18 * fem, 35 * fem, 15 * fem),
          child: Text(
            "Your Schedule",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 17 * ffem,
              fontWeight: FontWeight.bold,
              height: 1.5 * ffem / fem,
              color: Colors.black,
            ),
          ),
        ),
        _addDateBar(),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: SizedBox(
            height: 300,
            width: 400,
            child: StreamBuilder(
                stream: sleep
                    .doc(user!.uid)
                    .collection('schedule')
                    .where('date',
                        isEqualTo:
                            DateFormat('yyyy-MM-dd').format(_selectedDate))
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length > 1
                            ? 1
                            : snapshot.data!.docs.length,
                        itemBuilder: (context, index) {

                            difSleep();
                            final document = snapshot.data!.docs[index];
                            final documentId = document.id;
                            return Column(
                              children: [
                                Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  onDismissed: (direction) async {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      await sleep
                                          .doc(user!.uid)
                                          .collection('schedule')
                                          .doc(documentId)
                                          .delete();

                                      Get.snackbar("Drinks Schedule",
                                          "Successfully Deleted",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white);
                                    } else {
                                      setState(() {});
                                      Get.snackbar("Drinks Schedule",
                                          "For delete you have swipe Left to Right");
                                    }
                                  },
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 20,
                                  ),
                                  secondaryBackground: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 20,
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16 * fem),
                                            gradient: thirdGradient,
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: SleepContainer(
                                              title: 'Bed Time',
                                              subTitle:
                                                  'Your bed time at ${snapshot.data!.docs[index]['bed_time']}',
                                              image: Image.asset(
                                                  "assets/bed.png")),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  onDismissed: (direction) async {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      await sleep
                                          .doc(user!.uid)
                                          .collection('schedule')
                                          .doc(documentId)
                                          .delete();

                                      Get.snackbar("Sleep Reminder", "Successfully Removed");
                                    } else {
                                      setState(() {});

                                      Get.snackbar("Sleep Reminder", "For delete you have swipe Left to Right");
                                    }
                                  },
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 20,
                                  ),
                                  secondaryBackground: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 20,
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //const SizedBox(height: 10),
                                        Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16 * fem),
                                            gradient: thirdGradient,
                                          ),
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: SleepContainer(
                                              title: 'Alarm',
                                              subTitle:
                                                  'Your alarm time at  ${snapshot.data!.docs[index]['alarm_time']}',
                                              image: Image.asset(
                                                  "assets/alarm.png")),
                                        ),
                                        const SizedBox(height: 13),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 90,
                                  width: 350,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16 * fem),
                                    gradient: thirdGradient,
                                  ),
                                  margin: EdgeInsets.fromLTRB(
                                      25 * fem, 0 * fem, 35 * fem, 34 * fem),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "You will get $hour hours $min mins for tonight",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 14 * ffem,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5 * ffem / fem,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //const SizedBox(height: 15,)
                              ],
                            );
                          //}
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryClr,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSleepSchedule()),
          );
        },
        child: const Icon(Icons.add_circle),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Sleep Schedule",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.off(const SleepHome());
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: const [
          SizedBox(
            width: 45,
          ),
        ]);
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 90,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });

          //print(_selectedDate);
        },
      ),
    );
  }

  difSleep() {
    DateTime tempDate =
    DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    late String bed = "00:00 am", alarm = "00:00 am";
    for (int i = 0; i < sleepData.length; i++) {
      if (sleepData[i]['id'] != null &&
          sleepData[i]['id'] is Timestamp &&
          (sleepData[i]['id'] as Timestamp).toDate() == tempDate) {
        bed = sleepData[i]['bed_time'];
        alarm = sleepData[i]['alarm_time'];
      }
    }
    //print(bed);
    //print(sleepData.length);
    //print(tempDate);

    List<String> l = bed.split(" ");
    List<String> l1 = alarm.split(" ");

    double m1 = double.parse(bed.split(":")[1].split(" ")[0]) / 60;
    double m2 = double.parse(alarm.split(":")[1].split(" ")[0]) / 60;

    double h1 = double.parse(bed.split(":")[0]) + m1;
    double h2 = double.parse(alarm.split(":")[0]) + m2;

    if (l[1] == l1[1]) {
      hour = ((h1 - h2).abs()).toInt();
      durationSleepNotify = ((h1 - h2).abs()) * 3600;
      min = durationSleepNotify % 3600 ~/ 60;
      //print(hour);
      //print(min);
    } else {
      hour = (24 - (h1 + 12 - h2).abs()).toInt();
      durationSleepNotify = (24 - (h1 + 12 - h2).abs()) * 3600;
      min = durationSleepNotify % 3600 ~/ 60;
    }

  }


// difSleep() {
  //   DateTime tempDate =
  //       DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
  //   late String bed = "00:00 am", alarm = "00:00 am";
  //   for (int i = 0; i < sleepData.length; i++) {
  //     if ((sleepData[i]['id'] as Timestamp).toDate() == tempDate) {
  //       bed = sleepData[i]['bed_time'];
  //       alarm = sleepData[i]['alarm_time'];
  //     }
  //   }
  //   print(bed);
  //   print(sleepData.length);
  //   print(tempDate);
  //
  //   List<String> l = bed.split(" ");
  //   List<String> l1 = alarm.split(" ");
  //
  //   double m1 = double.parse(bed.split(":")[1].split(" ")[0]) / 60;
  //   double m2 = double.parse(alarm.split(":")[1].split(" ")[0]) / 60;
  //
  //   double h1 = double.parse(bed.split(":")[0]) + m1;
  //   double h2 = double.parse(alarm.split(":")[0]) + m2;
  //
  //   if (l[1] == l1[1]) {
  //     hour = ((h1 - h2).abs()).toInt();
  //     durationSleepNotify = ((h1 - h2).abs()) * 3600;
  //     min = durationSleepNotify % 3600 ~/ 60;
  //     print(hour);
  //     print(min);
  //   } else {
  //     hour = (24 - (h1 + 12 - h2).abs()).toInt();
  //     durationSleepNotify = (24 - (h1 + 12 - h2).abs()) * 3600;
  //     min = durationSleepNotify % 3600 ~/ 60;
  //   }
  // }
}
