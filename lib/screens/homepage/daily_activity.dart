import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:finessapp/page/step/step_counter_backend.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../page/widgets/button.dart';
import '../../page/widgets/input_field.dart';
import '../../services/local_notifications.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';

class DailyActivity extends StatefulWidget {
  const DailyActivity({Key? key}) : super(key: key);

  @override
  State<DailyActivity> createState() => _DailyActivityState();
}

class _DailyActivityState extends State<DailyActivity> {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;

  DBService dbService = DBService();
  StepCounterBackend stepCounterBackend = StepCounterBackend();
  TextEditingController water = TextEditingController();
  TextEditingController steps = TextEditingController();
  int goalSteps = 0;
  int goalWaterIntake = 0;
  int totalSteps = Get.arguments;
  double averageSpeed = 0;
  int totalIntake = 0;
  DateTime dateTime = DateTime.now();
  bool isHistory = false;
  bool isSchedule = true;
  bool isSwitched = false;
  final formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> allSchedule = [];
  List<Map<String, dynamic>> allHistory = [];
  List<bool> alarmStatus = [];

  showDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: water,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return "Cant left empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Glass of Water"),
                  prefixIcon: Icon(
                    Icons.water,
                    color: Colors.blue,
                  ),
                  helperText: "1 Glass = 250 ML",
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  helperStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              TextFormField(
                controller: steps,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return "Cant left empty";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Number of Steps"),
                  prefixIcon: Icon(
                    Icons.fireplace,
                    color: Colors.red,
                  ),
                  helperText: "Each Step Burn 0.04 kCal",
                  labelStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  helperStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: [
                          ColorCode.primaryColor2,
                          ColorCode.primaryColor1
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setInt("goalSteps", int.parse(steps.text.trim()));
                    sp.setInt("goalWater", int.parse(water.text.trim()));
                    getGoal();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 5,
                      // minimumSize: Size(
                      //   screenSize.width * 0.8,
                      //   screenSize.height * 0.08,
                      // ),
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  child: const Text("Add"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDrinkScheduleDoc();
    getData();
    getHistory();
    getGoal();

  }

  getData() async {
    //allSchedule.clear();
    allSchedule = await dbService.getDrinkSchedule();
    for (var schedule in allSchedule) {
      alarmStatus.add(schedule['isOn']);
    }
    print(allSchedule);
  }

  getHistory() async {
    allHistory = await dbService.getWaterIntakeData();
  }

  getGoal() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("waterIntake") == false) {
      sp.setInt("waterIntake", 8);
    }

    if (sp.containsKey("goalSteps")) {
      goalSteps = sp.getInt("goalSteps") ?? 10000;
      steps.text = goalSteps.toString();
    }
    if (sp.containsKey("goalWater")) {
      goalWaterIntake = sp.getInt("goalWater") ?? 8;
      water.text = goalWaterIntake.toString();
    }
    List<String> avgSpeed = sp.getStringList('averageSpeed') ?? [];
    // print("Avg Speed: ${avgSpeed}");
    totalIntake = sp.getInt('waterIntake') ?? 0;
    if (avgSpeed.isNotEmpty) {
      for (String speed in avgSpeed) {
        averageSpeed += double.parse(speed);
      }
      averageSpeed /= avgSpeed.length;
    }

    setState(() {});
  }

  addWater() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    totalIntake = sp.getInt('waterIntake') ?? 0;
    totalIntake += 1;
    sp.setInt('waterIntake', totalIntake);
    DateTime date = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(date);
    Map<String, dynamic> data = {
      "date": date,
      "id": formattedDate,
      "todayIntake": totalIntake,
      "target": goalWaterIntake,
      "percentage": totalIntake / goalWaterIntake >= 1
          ? 100
          : ((totalIntake / goalWaterIntake) * 100).toInt()
    };
    await dbService.addWaterIntakeData(data);
    setState(() {});
  }

  reduceWater() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    totalIntake = sp.getInt('waterIntake') ?? 0;
    if (totalIntake > 0) {
      totalIntake -= 1;
    }
    sp.setInt('waterIntake', totalIntake);
    DateTime date = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(date);
    Map<String, dynamic> data = {
      "date": date,
      "id": formattedDate,
      "todayIntake": totalIntake,
      "target": goalWaterIntake,
      "percentage": totalIntake / goalWaterIntake >= 1
          ? 100
          : ((totalIntake / goalWaterIntake) * 100).toInt()
    };
    await dbService.addWaterIntakeData(data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: const Text(
            "Daily Activity",
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Column(
              children: [
                Container(
                  height: Get.height * 0.2,
                  margin: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.05,
                    vertical: Get.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorCode.primaryColor2,
                            ColorCode.primaryColor1
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today Target",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: showDialog,
                              icon: const Icon(
                                Icons.add,
                                size: 35,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: Get.height * 0.08,
                              width: Get.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/onBoarding/glass.png"),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Water Intake"),
                                        Text("$goalWaterIntake Glasses")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: Get.height * 0.08,
                              width: Get.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        "assets/images/onBoarding/boots.png"),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("Steps"),
                                        Text("$goalSteps"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Text(
                  "Steps Activity",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                // SizedBox(height: Get.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.1,
                          width: Get.height * 0.1,
                          child: CircularProgressIndicator(
                            value: totalSteps / (int.tryParse(steps.text) ?? 1),
                            color: ColorCode.primaryColor1,
                            backgroundColor: ColorCode.secondaryColor1,
                            strokeWidth: 10,
                          ),
                        ),
                        Text(
                          "$totalSteps\nSteps",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Distant Walked: ${((totalSteps * 0.762) / 1000).toStringAsFixed(2)} kM",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // color: ColorCode.primaryColor1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Average Speed: ${(averageSpeed * 3.6).toStringAsFixed(2)} km/h",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // color: ColorCode.primaryColor1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Calorie Burned: ${(totalSteps * 0.04).toStringAsFixed(2)} kCal",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // color: ColorCode.primaryColor1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Step Progress: ${(totalSteps / (int.tryParse(steps.text) ?? 1) * 100).toStringAsFixed(2)}% ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            // color: ColorCode.primaryColor1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    )
                  ],
                ),
                // SizedBox(height: Get.height * 0.01),
                // const Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: BarChar(),
                // ),
                const Divider(),
                const Text(
                  "Water Intake Activity",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.1,
                          width: Get.height * 0.1,
                          child: CircularProgressIndicator(
                            value:
                                totalIntake / (int.tryParse(water.text) ?? 1),
                            color: ColorCode.primaryColor1,
                            backgroundColor: ColorCode.secondaryColor1,
                            strokeWidth: 10,
                          ),
                        ),
                        Text(
                          "$totalIntake\n Glasses",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        OutlinedButton.icon(
                          onPressed: addWater,
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(Get.width * 0.45, 40)),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Water'),
                        ),
                        OutlinedButton.icon(
                          onPressed: reduceWater,
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(Get.width * 0.45, 40)),
                          icon: const Icon(Icons.remove),
                          label: const Text('Reduce Water'),
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          getHistory();
                          print(getHistory());
                          setState(() {
                            isHistory = true;
                            isSchedule = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(Get.height * 0.19, 50),
                        ),
                        icon: const Icon(Icons.history_edu),
                        label: const Text("History"),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          getData();

                          print(allSchedule);
                          setState(() {
                            isHistory = false;
                            isSchedule = true;
                          });
                          //addAlarm();
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(Get.height * 0.19, 50),
                          // backgroundColor: ColorCode.primaryColor1,
                        ),
                        icon: const Icon(Icons.alarm),
                        label: const Text("Schedule"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),

                if (isSchedule)
                  Expanded(
                    child: FutureBuilder<List<String>>(
                      future: getDrinkScheduleDoc(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(); // or a loading indicator
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          // Data fetched successfully
                          allData = snapshot.data ?? [];
                          return ListView.builder(
                            itemCount: allData!.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(allData![index]), // Use the document ID as the key
                                onDismissed: (direction) async {
                                  if (direction == DismissDirection.startToEnd) {
                                    try {
                                      await userCollection
                                          .doc(user!.uid)
                                          .collection('DrinkSchedule')
                                          .doc(allData![index])
                                          .delete();
                                      setState(() {
                                        allData!.removeAt(index);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Successfully Deleted"),
                                        backgroundColor: Colors.red,
                                      ));
                                    } catch (e) {
                                      print("Error deleting document: $e");
                                    }
                                  } else {
                                    // Handle other directions if needed
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
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20, right: 20),
                                  child: Card(
                                    color: index % 2 == 1 ? Colors.black26 : Colors.blueGrey,
                                    child: ListTile(
                                      title: Text(
                                        '${allSchedule[index]['time']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      trailing: Switch(
                                        onChanged: (value) async {
                                          dif(allSchedule[index]['time']);
                                          if (value) {
                                            LocalNotifications.showScheduleNotification(
                                              title: "It's Drink Reminder",
                                              body: "Now you have to drink Water",
                                              payload: "This is schedule data",
                                              duration: durationForNotify.toInt(),
                                            );
                                          }

                                          setState(() {
                                            alarmStatus[index] = value;
                                            print(alarmStatus[index]);
                                          });
                                          DBService().updateDrinkSchedule(index, value);
                                        },
                                        value: alarmStatus[index],
                                        activeColor: index % 2 == 1 ? Colors.black54 : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    // child: ListView.builder(
                    //   itemCount: allSchedule.length,
                    //   itemBuilder: (context, index) {
                    //     //final document = snapshot.data!.docs[index];
                    //     //final documentId = document.id;
                    //
                    //     return Column(
                    //       children: [
                    //         Dismissible(
                    //           key: Key(allData![index]),
                    //           onDismissed: (direction) async {
                    //
                    //             if (direction == DismissDirection.startToEnd) {
                    //               await userCollection
                    //                   .doc(user!.uid)
                    //                   .collection('DrinkSchedule')
                    //                   .doc(allData?[index])
                    //                   .delete();
                    //               setState(() {
                    //                 // Remove the item from the list when deleted
                    //                 allData?.removeAt(index);
                    //               });
                    //
                    //               ScaffoldMessenger.of(context)
                    //                   .showSnackBar(const SnackBar(
                    //                 content: Text("Successfully Deleted"),
                    //                 backgroundColor: Colors.red,
                    //               ));
                    //             } else {
                    //               setState(() {});
                    //               ScaffoldMessenger.of(context)
                    //                   .showSnackBar(const SnackBar(
                    //                 content: Text(
                    //                     "For delete you have swipe Left to Right"),
                    //                 backgroundColor: Colors.green,
                    //               ));
                    //             }
                    //           },
                    //           background: Container(
                    //             decoration: BoxDecoration(
                    //               color: Colors.red,
                    //               borderRadius: BorderRadius.circular(20),
                    //             ),
                    //             height: 20,
                    //           ),
                    //           secondaryBackground: Container(
                    //             decoration: BoxDecoration(
                    //               color: Colors.green,
                    //               borderRadius: BorderRadius.circular(20),
                    //             ),
                    //             height: 20,
                    //           ),
                    //           child: (formattedDate ==
                    //                   allSchedule[index]['date'])
                    //               ? Container(
                    //                   margin: const EdgeInsets.only(
                    //                       left: 20, right: 20),
                    //                   child: Card(
                    //                     color: index % 2 == 1
                    //                         ? Colors.black26
                    //                         : Colors.blueGrey,
                    //                     child: ListTile(
                    //                       title: Text(
                    //                         '${allSchedule[index]['time']}',
                    //                         style: const TextStyle(
                    //                             color: Colors.white,
                    //                             fontWeight: FontWeight.bold,
                    //                             fontSize: 17),
                    //                       ),
                    //                       trailing: Switch(
                    //                         onChanged: (value) async {
                    //                           dif(allSchedule[index]['time']);
                    //                           if (value) {
                    //                             LocalNotifications
                    //                                 .showScheduleNotification(
                    //                                     title:
                    //                                         "It's Drink Reminder",
                    //                                     body:
                    //                                         "Now you have to drinks Water",
                    //                                     payload:
                    //                                         "This is schedule data",
                    //                                     duration:
                    //                                         durationForNotify
                    //                                             .toInt());
                    //                           }
                    //
                    //                           setState(() {
                    //                             alarmStatus[index] = value;
                    //                             print(alarmStatus[index]);
                    //                           });
                    //                           DBService().updateDrinkSchedule(
                    //                               index, value);
                    //                         },
                    //                         value: alarmStatus[index],
                    //                         activeColor: index % 2 == 1
                    //                             ? Colors.black54
                    //                             : Colors.white,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 )
                    //               : Container(),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // ),
                  ),

                //schedule(),
                if (isHistory)
                  Expanded(
                    child: ListView.builder(
                      itemCount: allHistory.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Card(
                            child: ListTile(
                                title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${allHistory[index]['id']}'),
                                Text(
                                    'Percentage: ${allHistory[index]['percentage']}'),
                                Text('Target: ${allHistory[index]['target']}'),
                                Text(
                                    'Today Intake: ${allHistory[index]['todayIntake']}'),
                              ],
                            )),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              SizedBox(
                width: Get.width * 0.48,
              ),
              FloatingActionButton(
                backgroundColor: primaryClr,
                onPressed: () {
                  showDrinksDialog();
                },
                child: const Icon(Icons.add_circle),
              ),
            ],
          ),
        ));
  }

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  DateTime dateForDif = DateTime.now();

  late TimeOfDay pickedTime;
  late DateTime? pickerDate;
  late double durationForNotify;
  List<String>? allData = [];

  Future<List<String>> getDrinkScheduleDoc() async {
    List<String> data = [];
    try {
      final querySnapshot = await userCollection
          .doc(user!.uid)
          .collection('DrinkSchedule')
          .get();
      // Store document IDs in data list
      data = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching documents: $e");
    }
    return data;
  }

  addSchedule() async {
    Map<String, dynamic> drinksData = {
      'date': formattedDate,
      'time': _time,
      'isOn': false,
    };
    await DBService().addDrinkSchedule(drinksData);
    setState(() {});
  }

  showDrinksDialog() {
    showModalBottomSheet(
      useSafeArea: true,
      // isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Add Drink Schedule",
                style: SafeGoogleFont(
                  'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              MyInputField(
                title: "Time",
                hint: _time,
                widget: IconButton(
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getTimeFromUser(isStartTime: true);
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.05),
              Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                  width: 330,
                  height: 55,
                  label: "Add Drink Schedule",
                  onTap: () async {
                    addSchedule();
                    addNotification();
                    Get.off(const DailyActivity());
                  },
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    pickedTime = await _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time cancel");
    } else if (isStartTime == true) {
      setState(() {
        _time = formatedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_time.split(":")[0]),
        minute: int.parse(_time.split(":")[1].split(" ")[0]),
      ),
    );
  }

  addNotification() async {
    DateTime now = DateTime.now();
    Map<String, dynamic> notificationsData = {
      'title': "It's Drink Time",
      'body': "Now you have to drinks Water",
      'time': _time,
      'date': DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute, 0),
    };
    await DBService().addNotifications(notificationsData);
    setState(() {});
  }

  dif(String check) {
    DateTime dateForDif = DateTime.now();
    int h = int.parse(dateForDif.hour.toString().padLeft(2, '0'));
    int hTemp = h;
    if (h > 12) {
      h = h - 12;
    }

    String hourAndMinute;
    if (hTemp > 12) {
      hourAndMinute =
          '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"PM"}';
    } else {
      hourAndMinute =
          '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"AM"}';
    }

    List<String> l = check.split(" ");
    List<String> l1 = hourAndMinute.split(" ");

    double m1 = double.parse(check.split(":")[1].split(" ")[0]) / 60;
    double m2 = double.parse(hourAndMinute.split(":")[1].split(" ")[0]) / 60;

    double h1 = double.parse(check.split(":")[0]) + m1;
    double h2 = double.parse(hourAndMinute.split(":")[0]);
    if (h2.toInt() == 0) {
      h2 = 12 + m2;
    } else {
      h2 = double.parse(hourAndMinute.split(":")[0]) + m2;
    }
    print('$h1 $h2');
    print('$l $l1');

    if (l[1] == l1[1]) {
      durationForNotify = ((h1 - h2).abs()) * 3600;
      print(durationForNotify);
    } else {
      durationForNotify = (24 - (h1 + 12 - h2).abs()) * 3600;
      print(durationForNotify);
    }
    //print(dtn);
    print(hourAndMinute);
    //durationForNotify = dt.difference(dtn).inSeconds.abs();
    //print(durationForNotify);
  }
}

// import 'package:alarm/alarm.dart';
// import 'package:finessapp/page/step/step_counter_backend.dart';
// import 'package:finessapp/services/db_service.dart';
// import 'package:finessapp/utility/color_utility.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class DailyActivity extends StatefulWidget {
//   const DailyActivity({Key? key}) : super(key: key);
//
//   @override
//   State<DailyActivity> createState() => _DailyActivityState();
// }
//
// class _DailyActivityState extends State<DailyActivity> {
//   DBService dbService = DBService();
//   StepCounterBackend stepCounterBackend = StepCounterBackend();
//   TextEditingController water = TextEditingController();
//   TextEditingController steps = TextEditingController();
//   int goalSteps = 0;
//   int goalWaterIntake = 0;
//   int totalSteps = Get.arguments;
//   double averageSpeed = 0;
//   int totalIntake = 0;
//   DateTime dateTime = DateTime.now();
//   static List<AlarmSettings> alarm = [];
//
//   final formKey = GlobalKey<FormState>();
//
//   addAlarm() async {
//     TimeOfDay time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     ) as TimeOfDay;
//     final alarmSettings = AlarmSettings(
//       id: 1,
//       dateTime: DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute),
//       assetAudioPath: 'assets/alarm.mp3',
//       loopAudio: true,
//       vibrate: false,
//       volume: 0.8,
//       fadeDuration: 3.0,
//       notificationTitle: 'FitSens',
//       notificationBody: 'Time for drink water',
//       enableNotificationOnKill: true,
//     );
//     alarm.clear();
//     alarm.add(alarmSettings);
//     await Alarm.set(alarmSettings: alarmSettings);
//     // Alarm.ringStream.stream.listen((_) => yourOnRingCallback());
//     print(alarmSettings.id);
//     setState(() {});
//   }
//
//   showDialog() {
//     showModalBottomSheet(
//       useSafeArea: true,
//       // isScrollControlled: true,
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: water,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isNotEmpty) {
//                     return "Cant left empty";
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   label: Text("Glass of Water"),
//                   prefixIcon: Icon(
//                     Icons.water,
//                     color: Colors.blue,
//                   ),
//                   helperText: "1 Glass = 250 ML",
//                   labelStyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   helperStyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: Get.height * 0.02),
//               TextFormField(
//                 controller: steps,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value!.isNotEmpty) {
//                     return "Cant left empty";
//                   }
//                   return null;
//                 },
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   label: Text("Number of Steps"),
//                   prefixIcon: Icon(
//                     Icons.fireplace,
//                     color: Colors.red,
//                   ),
//                   helperText: "Each Step Burn 0.04 kCal",
//                   labelStyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   helperStyle: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(30),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     gradient: LinearGradient(
//                         colors: [ColorCode.primaryColor2, ColorCode.primaryColor1],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter)),
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     SharedPreferences sp = await SharedPreferences.getInstance();
//                     sp.setInt("goalSteps", int.parse(steps.text.trim()));
//                     sp.setInt("goalWater", int.parse(water.text.trim()));
//                     getGoal();
//                   },
//                   style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(34),
//                       ),
//                       backgroundColor: Colors.transparent,
//                       shadowColor: Colors.transparent,
//                       elevation: 5,
//                       // minimumSize: Size(
//                       //   screenSize.width * 0.8,
//                       //   screenSize.height * 0.08,
//                       // ),
//                       textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
//                   child: const Text("Add"),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getGoal();
//   }
//
//   getGoal() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     if (sp.containsKey("waterIntake") == false) {
//       sp.setInt("waterIntake", 8);
//     }
//     // DateTime now = DateTime.now();
//     // String formatDate = DateFormat.yMMMMEEEEd().format(now);
//     // print(formatDate);
//     if (sp.containsKey("goalSteps")) {
//       goalSteps = sp.getInt("goalSteps") ?? 10000;
//       steps.text = goalSteps.toString();
//     }
//     if (sp.containsKey("goalWater")) {
//       goalWaterIntake = sp.getInt("goalWater") ?? 8;
//       water.text = goalWaterIntake.toString();
//     }
//     List<String> avgSpeed = sp.getStringList('averageSpeed') ?? [];
//     // print("Avg Speed: ${avgSpeed}");
//     totalIntake = sp.getInt('waterIntake') ?? 0;
//     if (avgSpeed.isNotEmpty) {
//       for (String speed in avgSpeed) {
//         averageSpeed += double.parse(speed);
//       }
//       averageSpeed /= avgSpeed.length;
//     }
//
//     setState(() {});
//   }
//
//   addWater() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     totalIntake = sp.getInt('waterIntake') ?? 0;
//     totalIntake += 1;
//     sp.setInt('waterIntake', totalIntake);
//     DateTime date = DateTime.now();
//     String formattedDate = DateFormat.yMMMd().format(date);
//     Map<String, dynamic> data = {
//       "date": date,
//       "id": formattedDate,
//       "todayIntake": totalIntake,
//       "target": goalWaterIntake,
//       "percentage": totalIntake / goalWaterIntake >= 1
//           ? 100
//           : ((totalIntake / goalWaterIntake) * 100).toInt()
//     };
//     await dbService.addWaterIntakeData(data);
//     setState(() {});
//   }
//
//   reduceWater() async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     totalIntake = sp.getInt('waterIntake') ?? 0;
//     if (totalIntake > 0) {
//       totalIntake -= 1;
//     }
//     sp.setInt('waterIntake', totalIntake);
//     DateTime date = DateTime.now();
//     String formattedDate = DateFormat.yMMMd().format(date);
//     Map<String, dynamic> data = {
//       "date": date,
//       "id": formattedDate,
//       "todayIntake": totalIntake,
//       "target": goalWaterIntake,
//       "percentage": totalIntake / goalWaterIntake >= 1
//           ? 100
//           : ((totalIntake / goalWaterIntake) * 100).toInt()
//     };
//     await dbService.addWaterIntakeData(data);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.black,
//         backgroundColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//         title: const Text(
//           "Daily Activity",
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: Get.height,
//           child: Column(
//             children: [
//               Container(
//                 height: Get.height * 0.2,
//                 margin: EdgeInsets.symmetric(
//                   horizontal: Get.width * 0.05,
//                   vertical: Get.height * 0.01,
//                 ),
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                         colors: [ColorCode.primaryColor2, ColorCode.primaryColor1],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(9.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             "Today Target",
//                             style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
//                           ),
//                           IconButton(
//                             onPressed: showDialog,
//                             icon: const Icon(
//                               Icons.add,
//                               size: 35,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: Get.height * 0.08,
//                             width: Get.width * 0.4,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset("assets/images/onBoarding/glass.png"),
//                                   const SizedBox(width: 12),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Text("Water Intake"),
//                                       Text("$goalWaterIntake Glasses")
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: Get.height * 0.08,
//                             width: Get.width * 0.4,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Center(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Image.asset("assets/images/onBoarding/boots.png"),
//                                   const SizedBox(width: 12),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const Text("Steps"),
//                                       Text("$goalSteps"),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(),
//               const Text(
//                 "Steps Activity",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Divider(),
//               // SizedBox(height: Get.height * 0.01),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.1,
//                         width: Get.height * 0.1,
//                         child: CircularProgressIndicator(
//                           value: totalSteps / (int.tryParse(steps.text) ?? 1),
//                           color: ColorCode.primaryColor1,
//                           backgroundColor: ColorCode.secondaryColor1,
//                           strokeWidth: 10,
//                         ),
//                       ),
//                       Text(
//                         "$totalSteps\nSteps",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Distant Walked: ${((totalSteps * 0.762) / 1000).toStringAsFixed(2)} kM",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           // color: ColorCode.primaryColor1,
//                         ),
//                       ),
//                       Text(
//                         "Average Speed: ${(averageSpeed * 3.6).toStringAsFixed(2)} km/h",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           // color: ColorCode.primaryColor1,
//                         ),
//                       ),
//                       Text(
//                         "Calorie Burned: ${(totalSteps * 0.04).toStringAsFixed(2)} kCal",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           // color: ColorCode.primaryColor1,
//                         ),
//                       ),
//                       Text(
//                         "Step Progress: ${(totalSteps / (int.tryParse(steps.text) ?? 1) * 100).toStringAsFixed(2)}% ",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           // color: ColorCode.primaryColor1,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               // SizedBox(height: Get.height * 0.01),
//               // const Padding(
//               //   padding: EdgeInsets.symmetric(horizontal: 10),
//               //   child: BarChar(),
//               // ),
//               const Divider(),
//               const Text(
//                 "Water Intake Activity",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       SizedBox(
//                         height: Get.height * 0.1,
//                         width: Get.height * 0.1,
//                         child: CircularProgressIndicator(
//                           value: totalIntake / (int.tryParse(water.text) ?? 1),
//                           color: ColorCode.primaryColor1,
//                           backgroundColor: ColorCode.secondaryColor1,
//                           strokeWidth: 10,
//                         ),
//                       ),
//                       Text(
//                         "$totalIntake\n Glasses",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       OutlinedButton.icon(
//                         onPressed: addWater,
//                         style: OutlinedButton.styleFrom(minimumSize: Size(Get.width * 0.45, 40)),
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add Water'),
//                       ),
//                       OutlinedButton.icon(
//                         onPressed: reduceWater,
//                         style: OutlinedButton.styleFrom(minimumSize: Size(Get.width * 0.45, 40)),
//                         icon: const Icon(Icons.remove),
//                         label: const Text('Reduce Water'),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   addAlarm();
//                 },
//                 style: OutlinedButton.styleFrom(
//                     minimumSize: Size(Get.width * 0.8, 40),
//                     backgroundColor: ColorCode.primaryColor1),
//                 icon: const Icon(Icons.alarm),
//                 label: const Text("Add Drink Alarm"),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: alarm.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text('${alarm[index].dateTime}'),
//                       subtitle: Text('${alarm[index].id}'),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
