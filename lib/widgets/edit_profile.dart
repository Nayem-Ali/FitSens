import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/db_service.dart';
import '../screens/homepage/profile_screen.dart';
import '../utility/utils.dart';


class EditProfile extends StatefulWidget {

  const EditProfile({Key? key, required this.userDetails}) : super(key: key);

  final Map<String, dynamic> userDetails;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController gender = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final weightRegex = RegExp(r'^(\d{1,3}\.?\d{1,2}?)$');
  final nameRegex =
      RegExp(r'^[a-zA-Z. ]+( [a-zA-Z]+)?( [a-zA-Z]+)?( [a-zA-Z]+)?$');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.userDetails["name"];
    dob.text = widget.userDetails["dob"];
    height.text = widget.userDetails["height"];
    weight.text = widget.userDetails["weight"];
    gender.text = widget.userDetails["gender"];
  }

  updateInfo() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    widget.userDetails["name"] = name.text.trim();
    widget.userDetails["dob"] = dob.text.trim();
    widget.userDetails["gender"] = gender.text.trim();
    widget.userDetails["height"] = height.text.trim();
    widget.userDetails["weight"] = weight.text.trim();
    DBService db = DBService();
    await db.updateUserInfo(widget.userDetails);
    Get.off(const ProfileScreen());
  }

  datePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    String temp = DateFormat("yyyy-MM-dd").format(pickedDate!);
    dob.text = temp;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: SafeArea(

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  validator: (value) {
                    if (!nameRegex.hasMatch(value!)) {
                      return "Invalid Format. Only alphabet, whitespace and dot(.) allowed";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Date of birth",
                          labelStyle: TextStyle(fontSize: 20),
                          counterText: "YYYY-MM-DD"),
                      controller: dob,
                      onTap: datePicker,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Gender",
                        labelStyle: TextStyle(fontSize: 20),
                        counterText: "  ",
                      ),
                      onChanged: (value) {
                        setState(() {
                          gender.text = value!;
                        });
                      },
                      value: gender.text,
                      items: ["Male", "Female", "Others"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ]),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: weight,
                        validator: (value) {
                          if (!weightRegex.hasMatch(value!)) {
                            return "0-9 & dot allowed e.g. 123.12";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Weight",
                          labelStyle: TextStyle(fontSize: 20),
                          counterText: "KG",
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextFormField(
                      controller: height,
                      validator: (value) {
                        if (!weightRegex.hasMatch(value!)) {
                          return "0-9 & dot allowed e.g. 123.12";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Height",
                        labelStyle: TextStyle(fontSize: 20),
                        counterText: "CM",
                      ),
                    ))
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: ColorCode.primaryG,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ElevatedButton.icon(
                      onPressed: updateInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        "Update",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )),
                )
              ],
            ),
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
            "Edit Personal Data",
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
            Get.back();
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
