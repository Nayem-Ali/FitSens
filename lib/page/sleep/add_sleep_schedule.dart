import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/page/sleep/sleep_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/db_service.dart';
import '../../services/local_notifications.dart';
import '../../utility/utils.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddSleepSchedule extends StatefulWidget {
  const AddSleepSchedule({Key? key}) : super(key: key);

  @override
  State<AddSleepSchedule> createState() => _AddSleepScheduleState();
}

class _AddSleepScheduleState extends State<AddSleepSchedule> {

  CollectionReference sleep = FirebaseFirestore.instance.collection('sleep');
  User? user = FirebaseAuth.instance.currentUser;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _alarmTime = '06:00 AM';
  late double durationSleepNotify;
  CollectionReference user1 = FirebaseFirestore.instance.collection('user');
  double idealHour=0;
  late Map<String, dynamic> userDetails = {};
  int age = 0;

  DateTime? _pickerDate;

  TimeOfDay pickedTime = TimeOfDay.now();

  final String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  DBService dbService = DBService();

  addNotification() async {
    Map<String, dynamic> notificationsData = {
      'title': "Sleep Reminder",
      'body': "Now you have to do $_alarmTime",
      'time': _alarmTime,
      'date': DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day,pickedTime.hour,pickedTime.minute,0)
    };
    await DBService().addNotifications(notificationsData);
    setState(() {});
  }

  calculateIdealHour(){
    if(age>=1 && age<=2){
      idealHour = 14;
    }
    else if(age>=3 && age<=5){
      idealHour = 12;
    }
    if(age>=6 && age<=12){
      idealHour = 10;
    }
    if(age>=13 && age<=18){
      idealHour = 9;
    }
    if(age>=18){
      idealHour = 7;
    }

  }

  setData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("targetSleepHour")) {
      sp.setDouble('targetSleepHour', idealHour);
      sp.setInt('completedHour', 0);
    }
    double target = sp.getDouble('targetSleepHour') ?? idealHour;
    int completed = sp.getInt('completedHour') ?? 0;
    completed = (durationSleepNotify ~/ 3600);
    sp.setInt("completedHour", completed);
    String id = DateFormat.yMMMd().format(_selectedDate);
    Map<String, dynamic> sleepData = {
      'id': id,
      'date': _selectedDate,
      'percentage':
          completed / target >= 1 ? 100 : ((completed / target) * 100).toInt(),
      'difference': durationSleepNotify,
      "target": target.toInt(),
      "complete": completed,
    };
    await dbService.addSleepData(sleepData);
    // print(controller.value.duration.inSeconds - controller.value.position.inSeconds < 15);
  }

  getData()async{
    userDetails = await dbService.getUserInfo();
    age = (DateTime.now().year - DateTime.parse(userDetails['dob']).year);
    setState(() {

    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(formattedDate);
    double baseWidth = 375;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyInputField(
                title: "Date",
                hint: formattedDate,
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              MyInputField(
                title: "Bed Time",
                hint: _time,
                widget: IconButton(
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    //print(_time);
                    _getTimeFromUser(isStartTime: true);
                  },
                ),
              ),
              MyInputField(
                title: "Alarm Time",
                hint: _alarmTime,
                widget: IconButton(
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    //print("Pressed");
                    _getAlarmTimeFromUser(isStartTime: true);
                  },
                ),
              ),

              SizedBox(
                height: 30,
                width: 200,
                child: StreamBuilder(
                    stream: user1.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                idealHour = 14;
                              } else if (age >= 3 && age <= 5) {
                                idealHour = 13;
                              } else if (age >= 6 && age <= 12) {
                                idealHour = 12;
                              } else if (age >= 13 && age <= 18) {
                                idealHour = 10;
                              } else if (age >= 18) {
                                idealHour = 8;
                              }
                              return null;
                            });
                      } else {
                        return Container();
                      }
                    }),
              ),
              SizedBox(
                height: fem * 250,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                    width: 330,
                    height: 55,
                    fontSize: 16,
                    label: "Add Sleep Schedule",
                    onTap: () async {
                      //temp();
                      difSleep();
                      LocalNotifications.showScheduleNotification(
                          title: "Sleep Reminder",
                          body: "Your alarm time is $_alarmTime",
                          payload: "This is schedule data",
                          duration: durationSleepNotify.toInt());

                      await setData();
                      await sleep
                          .doc(user!.uid)
                          .collection('schedule')
                          .doc(formattedDate)
                          .set({
                        'date': formattedDate,
                        'bed_time': _time,
                        'alarm_time': _alarmTime,
                        'repeat': _selectedRepeat,
                        'id': dateTime,
                        'difference': durationSleepNotify,
                        'ideal_hour': idealHour,
                      });

                      Get.snackbar("Sleep Reminder", "Successfully Added");

                      addNotification();

                      Get.off(const SleepSchedule());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Add Sleep Schedule",
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
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: const [
          SizedBox(
            width: 40,
          ),
        ]);
  }

  _getDateFromUser() async {
    _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2040),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate!;
        formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    } else {
      //print("Wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    pickedTime = await _showTimePicker();
    // ignore: use_build_context_synchronously
    String formatedTime = pickedTime.format(context);
    if (isStartTime == true) {
    setState(() {
      _time = formatedTime;
      //print(_time);
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

  _getAlarmTimeFromUser({required bool isStartTime}) async {
    var pickedATime = await _showAlarmTimePicker();
    // ignore: use_build_context_synchronously
    String formatedATime = pickedATime.format(context);
    if (pickedATime == null) {
      //print("Time cancel");
    } else if (isStartTime == true) {
      setState(() {
        _alarmTime = formatedATime;
      });
    }
  }

  _showAlarmTimePicker() async {
    return await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_alarmTime.split(":")[0]),
        minute: int.parse(_alarmTime.split(":")[1].split(" ")[0]),
      ),
    );
  }

  difSleep() {


    List<String> l = _time.split(" ");
    List<String> l1 = _alarmTime.split(" ");

    double m1 = double.parse(_time.split(":")[1].split(" ")[0]) / 60;
    double m2 = double.parse(_alarmTime.split(":")[1].split(" ")[0]) / 60;

    double h1 = double.parse(_time.split(":")[0]) + m1;
    double h2 = double.parse(_alarmTime.split(":")[0]) + m2;

    if (l[1] == l1[1]) {
      durationSleepNotify = ((h1 - h2).abs()) * 3600;
      //print(durationSleepNotify);
    } else {
      durationSleepNotify = (24 - (h1 + 12 - h2).abs()) * 3600;
      //print(durationSleepNotify);
    }
  }

}
