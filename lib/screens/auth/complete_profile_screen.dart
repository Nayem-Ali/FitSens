import 'package:finessapp/services/auth_service.dart';
import 'package:finessapp/screens/auth/login_screen.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var selectedGender = "Male";
  List<String> options = ["Male", "Female", "Others"];
  TextEditingController selectedDate = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final weightRegex = RegExp(r'^(\d{1,3}\.?\d{1,2}?)$');
  dynamic userInfo = Get.arguments;

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    setState(() {
      userInfo["img"] = "";
      userInfo["dob"] = DateFormat("yyyy-MM-dd").format(pickedDate!);
      String str = DateFormat("yyyy/MM/dd").format(pickedDate);
      selectedDate.text = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/onBoarding/profile.png",
                height: screenSize.height * .35,
                width: screenSize.width,
              ),
              const Text(
                "Let's complete your profile",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              const SizedBox(height: 12),
              const Text(
                "It will help us to known more about you.",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Choose gender',
                          prefixIcon: const Icon(Icons.perm_identity),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                          suffixIcon: DropdownButtonFormField(
                            padding: const EdgeInsets.fromLTRB(50, 0, 20, 0),
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            value: selectedGender,
                            onChanged: (newValue) {
                              setState(() {
                                selectedGender = newValue!;
                              });
                            },
                            items: options
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: selectedDate,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: pickDate,
                            icon: const Icon(Icons.calendar_month),
                          ),
                          hintText: "Your birthdate",
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.black12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: weight,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter weight";
                                } else if (!weightRegex.hasMatch(value)) {
                                  return "Invalid Format";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.monitor_weight),
                                hintText: "Your weight",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: screenSize.width * .13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(colors: [
                                  ColorCode.primaryColor2,
                                  ColorCode.primaryColor1
                                ]),
                              ),
                              child: const Center(
                                child: Text(
                                  "KG",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: height,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter height";
                                } else if (!weightRegex.hasMatch(value)) {
                                  return "Invalid Format";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.height),
                                hintText: "Your height",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: screenSize.width * .13,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                      colors: ColorCode.primaryG),
                                ),
                                child: const Center(
                                  child: Text(
                                    "CM",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final db = AuthService();
                  if (formKey.currentState!.validate()) {
                    userInfo["gender"] = selectedGender;
                    userInfo["height"] = height.text.trim();
                    userInfo["weight"] = weight.text.trim();
                    await db.storeUserInfo(userInfo);
                    Get.offAll(const LoginScreen());
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34),
                    ),
                    backgroundColor: ColorCode.primaryColor1,
                    elevation: 5,
                    minimumSize: Size(
                      screenSize.width * 0.8,
                      screenSize.height * 0.08,
                    ),
                    textStyle: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                icon: Icon(
                  Icons.navigate_next,
                  size: screenSize.width * 0.08,
                ),
                label: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
