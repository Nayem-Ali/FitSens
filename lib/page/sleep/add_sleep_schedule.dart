import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utility/color.dart';
import '../../utility/utils.dart';
import '../widgets/button.dart';
import '../widgets/input_field.dart';

class AddSleepSchedule extends StatefulWidget {
  const AddSleepSchedule({Key? key}) : super(key: key);

  @override
  State<AddSleepSchedule> createState() => _AddSleepScheduleState();
}

class _AddSleepScheduleState extends State<AddSleepSchedule> {

  CollectionReference sleep =
  FirebaseFirestore.instance.collection('sleep');
  User? user = FirebaseAuth.instance.currentUser;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime _selectedDate = DateTime.now();
  String _time = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _alarmTime='06:00 AM';

  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

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
                title: "Bed Time",
                hint: _time,
                widget: IconButton(
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    print(_time);
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
                    print("Pressed");
                    _getAlarmTimeFromUser(isStartTime: true);
                  },
                ),
              ),

              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
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
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
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
                      await sleep.doc(user!.uid).collection('schedule').add({
                        'date': formattedDate,
                        'bed_time': _time,
                        'alarm_time': _alarmTime,
                        'repeat': _selectedRepeat,
                      }).then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Successfully Added"),
                          backgroundColor: Colors.green,
                        ));
                      });
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
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2040),
    );

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    } else {
      print("Wrong");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("Time cancel");
    } else if (isStartTime == true) {
      setState(() {
        _time = _formatedTime;
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
    String formatedATime = pickedATime.format(context);
    if (pickedATime == null) {
      print("Time cancel");
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
}
