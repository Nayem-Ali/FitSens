import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/page/sleep/sleep_schedule.dart';
import 'package:finessapp/page/sleep/widgets/sleep_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../widgets/daily_container.dart';
import '../widgets/progress.dart';

class SleepHome extends StatefulWidget {
  const SleepHome({Key? key}) : super(key: key);

  @override
  State<SleepHome> createState() => _SleepHomeState();
}

class _SleepHomeState extends State<SleepHome> {
  CollectionReference sleep = FirebaseFirestore.instance.collection('sleep');
  User? user = FirebaseAuth.instance.currentUser;

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProgressBar(
            t_color: primaryClr,
            color: Colors.white,
            t1_color: primaryClr,
            gradient1: primaryGradient,
            height: 200 * fem,
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, right: 30),
            height: 120 * fem,
            width: 375 * fem,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: primaryGradient,
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Night Sleep",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "8h 20m",
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset("assets/Vector1.png"),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: DailyContainer(
              title: "Daily Sleep Schedule",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SleepSchedule()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25 * fem, 0 * fem, 30 * fem, 30 * fem),
            child: Text(
              "Today Schedule",
              style: SafeGoogleFont(
                'Poppins',
                fontSize: 17 * ffem,
                fontWeight: FontWeight.bold,
                height: 1.5 * ffem / fem,
                color: Colors.black,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: 220,
              width: 400,
              child: StreamBuilder(
                stream: sleep
                    .doc(user!.uid)
                    .collection('schedule')
                    .where('date', isEqualTo: formattedDate)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length > 1 ? 1 : snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final document = snapshot.data!.docs[index];
                        final documentId = document.id;

                        return Column(
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16 * fem),
                                      gradient: thirdGradient,
                                    ),
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    child: SleepContainer(
                                        title: 'Bed Time',
                                        subTitle1: snapshot.data!.docs[index]['bed_time'],
                                        subTitle: 'in 6h 12m',
                                        image: Image.asset("assets/bed.png")),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //const SizedBox(height: 10),
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16 * fem),
                                      gradient: thirdGradient,
                                    ),
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    child: SleepContainer(
                                        title: 'Alarm',
                                        subTitle1: snapshot.data!.docs[index]['alarm_time'],
                                        subTitle: 'in 14h 30m',
                                        image: Image.asset("assets/alarm.png")),
                                  ),
                                ],
                              ),
                            ),
                            //const SizedBox(height: 15,)
                          ],
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Sleep Tracker",
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
}
