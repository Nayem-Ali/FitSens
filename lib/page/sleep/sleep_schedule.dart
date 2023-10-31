import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:finessapp/page/sleep/ideal_sleep.dart';
import 'package:finessapp/page/widgets/button.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../screens/homepage/profile_screen.dart';
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

  ProfileScreen p = ProfileScreen();

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
          margin: const EdgeInsets.only(left: 20, right: 25, top: 20),
          height: 110 * fem,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 20),
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
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: StreamBuilder(
                        stream: user1.snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length > 1
                                    ? 1
                                    : snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DateTime date1 = DateTime.parse(
                                      snapshot.data!.docs[index]["dob"]);
                                  late int age = DateTime.now().year - date1.year;

                                  if (age >= 1 && age <= 2) {
                                    return ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        child: Text(
                                          "11–14 hours per 24 hours",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (age >= 3 && age <= 5) {
                                    return ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        child: Text(
                                          "10–13 hours per 24 hours",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (age >= 6 && age <= 12) {
                                    return ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        child: Text(
                                          "9–12 hours per 24 hours",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (age >= 13 && age <= 18) {
                                    return ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        child: Text(
                                          "8–10 hours per 24 hours",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (age >= 18) {
                                    return ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        child: Text(
                                          "7 or more hours per night",
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                });
                          } else {
                            return Container();
                          }
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    child: MyButton(
                        label: 'View more',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const IdealSleep()),
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
          margin: EdgeInsets.fromLTRB(25 * fem, 23 * fem, 35 * fem, 34 * fem),
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
        const SizedBox(height: 20),
        SingleChildScrollView(
          child: SizedBox(
            height: 220,
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

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Successfully Deleted"),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    setState(() {});
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "For delete you have swipe Left to Right"),
                                      backgroundColor: Colors.green,
                                    ));
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
                                            subTitle1: snapshot
                                                .data!.docs[index]['bed_time'],
                                            subTitle: 'in 6h 22m',
                                            image:
                                                Image.asset("assets/bed.png")),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

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

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Successfully Deleted"),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    setState(() {});
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "For delete you have swipe Left to Right"),
                                      backgroundColor: Colors.green,
                                    ));
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
                                            subTitle1: snapshot.data!
                                                .docs[index]['alarm_time'],
                                            subTitle: 'in ${snapshot.data!
                                                .docs[index]['alarm_time']}h 30m',
                                            image: Image.asset(
                                                "assets/alarm.png")),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                height: 90,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16 * fem),
                                  gradient: thirdGradient,
                                ),
                                margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 35 * fem, 34 * fem),
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "You will get 8 hours 10 mins for tonight",
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
                                      Image.asset("assets/ProgressBar.png")
                                    ],
                                  ),
                                ),
                              ),
                              //const SizedBox(height: 15,)
                            ],
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
        ),
        /*Container(
          height: 90,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16 * fem),
            gradient: thirdGradient,
          ),
          margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 35 * fem, 34 * fem),
          child: Container(
            margin: EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You will get 8 hours 10 mins for tonight",
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
                Image.asset("assets/ProgressBar.png")
              ],
            ),
          ),
        ),*/
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
            Navigator.pop(context);
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
        height: 100,
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
}
