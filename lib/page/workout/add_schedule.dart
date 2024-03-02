import 'package:finessapp/page/workout/workout_schedule.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/local_notifications.dart';
import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({Key? key}) : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  CollectionReference workout =
  FirebaseFirestore.instance.collection('workout');
  CollectionReference userCollection =
  FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;

  DateTime _selectedDate = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  DateTime dateForDif = DateTime.now();


  late TimeOfDay pickedTime;
  late DateTime? pickerDate;
  late double durationForNotify;


  List<int> remindList = [
    10,
    15,
    20,
    30,
  ];

  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  String _chooseWorkout = "Fullbody workout";
  List<String> chooseWorkoutList = [
    "Fullbody workout",
    "Lowerbody workout",
    "AB workout",
  ];


  addNotification() async {
    Map<String, dynamic> notificationsData = {
      'title': "Workout Reminder",
      'body': "Now you have to do $_chooseWorkout",
      'time': _time,
      'isCheck': false,
      'date': DateTime(_selectedDate.year,_selectedDate.month,_selectedDate.day,pickedTime.hour,pickedTime.minute,0),

    };
    await DBService().addNotifications(notificationsData);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              MyInputField(
                title: "Choose workout",
                hint: _chooseWorkout,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _chooseWorkout = newValue!;
                    });
                  },
                  items: chooseWorkoutList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                height: fem * 300,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MyButton(
                  width: 330,
                  height: 55,
                  label: "Add Schedule",
                  onTap: () async {

                    dif();
                    LocalNotifications.showScheduleNotification(
                        title: "Workout Reminder",
                        body: "Now you have to do $_chooseWorkout",
                        payload: "This is schedule data", duration: durationForNotify.toInt());

                    await workout.doc(user!.uid).collection('schedule').add({
                      'date': formattedDate,
                      'time': _time,
                      'choose': _chooseWorkout,
                    });

                    Get.snackbar("Workout Reminder", "Successfully Added");

                    addNotification();

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);


                  }, fontSize: 16,),
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
            "Add Schedule",
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
            Get.off(const WorkoutSchedule());
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        actions: const [
          SizedBox(
            width: 35,
          ),
        ]);
  }

  _getDateFromUser() async {
    pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2040),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate!;
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

  dif() {


    DateTime dateForDif = DateTime.now();

    int h = int.parse(dateForDif.hour.toString().padLeft(2, '0'));
    int hTemp= h;
    if(h>12) {
      h=h-12;
    }

    String hourAndMinute;
    if(hTemp>12){
      hourAndMinute = '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"PM"}';
    }else{
      hourAndMinute = '${h.toString()}:${dateForDif.minute.toString().padLeft(2, '0')} ${"AM"}';
    }


    List<String>l=_time.split(" ");
    List<String>l1=hourAndMinute.split(" ");

    double m1 = double.parse(_time.split(":")[1].split(" ")[0])/60;
    double m2 = double.parse(hourAndMinute.split(":")[1].split(" ")[0])/60;

    double h1 = double.parse(_time.split(":")[0])+m1;
    double h2 = double.parse(hourAndMinute.split(":")[0]);
    if(h2.toInt()==0){
      h2=12+m2;
    }else{
      h2 = double.parse(hourAndMinute.split(":")[0])+m2;
    }
    //print(m2);
    //print(hourAndMinute);
    //print('$h1 $h2');
    //print('$l $l1');

    if(l[1]==l1[1]){
      durationForNotify = ((h1-h2).abs()) * 3600;
      //print(durationForNotify);
    }else{
      durationForNotify = (24-(h1+12-h2).abs()) * 3600;
      //print(durationForNotify);
    }
    //print(dtn);
    //print(hourAndMinute);
    //durationForNotify = dt.difference(dtn).inSeconds.abs();
    //print(durationForNotify);

  }

}
