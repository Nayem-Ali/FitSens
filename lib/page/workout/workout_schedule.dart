// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import '../../utility/color.dart';
// import '../../utility/utils.dart';
// import 'add_schedule.dart';
//
//
// class WorkoutSchedule extends StatefulWidget {
//   const WorkoutSchedule({Key? key}) : super(key: key);
//
//   @override
//   State<WorkoutSchedule> createState() => _WorkoutScheduleState();
// }
//
// class _WorkoutScheduleState extends State<WorkoutSchedule> {
//
//   CollectionReference workout = FirebaseFirestore.instance.collection('workout');
//
//
//   DateTime _selectedDate = DateTime.now();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _appBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             _addTaskBar(),
//             _addDateBar(),
//
//             const SizedBox(height: 9),
//             SizedBox(
//               height: 500,
//               width: 400,
//               child: StreamBuilder(
//                   stream: workout
//                       .doc('jj')
//                       .collection('workout2')
//                       .where('date',
//                       isEqualTo:
//                       DateFormat('yyyy-MM-dd').format(_selectedDate))
//                       .snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//
//                             return Card(
//                               color: primaryClr,
//                               margin: const EdgeInsets.only(
//                                   left: 20, right: 20, top: 10, bottom: 10),
//                               child: ListTile(
//                                 title: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 10),
//                                     Text(
//                                       snapshot.data!.docs[index]['date'],
//                                       style: SafeGoogleFont(
//                                         'Poppins',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.data!.docs[index]['time'],
//                                       style: SafeGoogleFont(
//                                         'Poppins',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     Text(
//                                       snapshot.data!.docs[index]['choose'],
//                                       style: SafeGoogleFont(
//                                         'Poppins',
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 10),
//                                   ],
//                                 ),
//                               ),
//                             );
//
//                           });
//                     } else {
//                       return Container();
//                     }
//                   }),
//             ),
//
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: primaryClr,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const AddSchedule()),
//           );
//         },
//         child: const Icon(Icons.add_circle),
//       ),
//     );
//   }
//
//   _addDateBar() {
//     return Container(
//       margin: const EdgeInsets.only(top: 15, left: 20),
//       child: DatePicker(
//         DateTime.now(),
//         height: 100,
//         width: 80,
//         initialSelectedDate: DateTime.now(),
//         selectionColor: primaryClr,
//         selectedTextColor: Colors.white,
//         dateTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey,
//           ),
//         ),
//         dayTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey,
//           ),
//         ),
//         monthTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey,
//           ),
//         ),
//         onDateChange: (date) {
//           setState(() {
//             _selectedDate = date;
//           });
//
//           //print(_selectedDate);
//         },
//       ),
//     );
//   }
//
//   _addTaskBar() {
//     return Container(
//       margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Today",
//             style: headingStyle,
//           ),
//           Text(
//             DateFormat.yMMMd().format(DateTime.now()),
//             style: subHeadingStyle,
//           ),
//         ],
//       ),
//     );
//   }
//
//   _appBar() {
//     return AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Center(
//           child: Text(
//             "Workout Schedule",
//             style: GoogleFonts.lato(
//               textStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//           ),
//         ),
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             Icons.arrow_back_ios_new_outlined,
//             size: 20,
//             color: Colors.black,
//           ),
//         ),
//         actions: const [
//
//           SizedBox(
//             width: 30,
//           ),
//         ]);
//   }
//
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:finessapp/page/workout/workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../utility/color.dart';
import '../../utility/color_utility.dart';
import '../../utility/utils.dart';
import 'add_schedule.dart';

class WorkoutSchedule extends StatefulWidget {
  const WorkoutSchedule({Key? key}) : super(key: key);

  @override
  State<WorkoutSchedule> createState() => _WorkoutScheduleState();
}

class _WorkoutScheduleState extends State<WorkoutSchedule> {
  DateTime _selectedDate = DateTime.now();
  String formattedDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  CollectionReference workout =
      FirebaseFirestore.instance.collection('workout');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 15),
            SizedBox(
              height: 500,
              width: 400,
              child: StreamBuilder(
                  stream: workout
                      .doc(user!.uid)
                      .collection('schedule')
                      .where('date',
                          isEqualTo:
                              DateFormat('yyyy-MM-dd').format(_selectedDate))
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final document = snapshot.data!.docs[index];
                            final documentId = document.id;
                            return Column(
                              children: [
                                Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  onDismissed: (direction) async {
                                    if (direction == DismissDirection.startToEnd) {
                                      await workout
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
                                  child: Card(
                                    color: index%2 == 1 ? primaryClr : ColorCode.secondaryColor1,
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),

                                          // Text(
                                          //   snapshot.data!.docs[index]['date'],
                                          //   style: SafeGoogleFont(
                                          //     'Poppins',
                                          //     fontSize: 15,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          //
                                          // Text(
                                          //   snapshot.data!.docs[index]['time'],
                                          //   style: SafeGoogleFont(
                                          //     'Poppins',
                                          //     fontSize: 15,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),
                                          //
                                          // Text(
                                          //   snapshot.data!.docs[index]['choose'],
                                          //   style: SafeGoogleFont(
                                          //     'Poppins',
                                          //     fontSize: 15,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: Colors.black,
                                          //   ),
                                          // ),


                                          Text(
                                            snapshot.data!.docs[index]['date'],
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]['time'],
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]['choose'],
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),


                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15,)
                              ],
                            );

                          });
                    } else {
                      return Container();
                    }
                  }),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryClr,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSchedule()),
          );
        },
        child: const Icon(Icons.add_circle),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
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
            //formattedDate1 = DateFormat('yyyy-MM-dd').format(_selectedDate);
            //print(formattedDate1);
          });

          //print(_selectedDate);
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            DateFormat.yMMMd().format(DateTime.now()),
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Workout Schedule",
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
            Get.off(const Workout());
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: const [
          SizedBox(
            width: 30,
          ),
        ]);
  }
}
