import 'package:finessapp/services/auth_service.dart';
import 'package:finessapp/screens/auth/complete_profile_screen.dart';
import 'package:finessapp/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/color_utility.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final nameRegex = RegExp(r'^[a-zA-Z.]+( [a-zA-Z]+)?( [a-zA-Z]+)?$');
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$');
  final passRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$');

  bool isVisible = true;

  void createNewUser() async {
    if (_formKey.currentState!.validate()) {
      AuthService auth = AuthService();
      final flag = await auth.createUser(
          userEmail.text.trim(), userPassword.text.trim());
      if (flag.contains("true")) {
        //"true ${userCredential.user!.uid}";
        Get.snackbar(
          "Hi ${firstName.text}",
          "A verification message sent to your email ${userEmail.text}",
          duration: const Duration(seconds: 10),
        );
        Get.to(const CompleteProfileScreen(), arguments: {
          "uid": flag.substring(
            5,
          ),
          "name": '${firstName.text} ${lastName.text}'
        });
      } else {
        Get.snackbar(
          "An error occurs",
          flag,
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  "Hey there,",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  "Create an Account",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: ColorCode.primaryColor1),
                ),
                //const Expanded(child: SizedBox(height: 12)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: firstName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter first name";
                            } else if (!nameRegex.hasMatch(value)) {
                              return "Invalid name format. Only contains alphabet & whitespace";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "Enter First Name",
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: lastName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Invalid name format. Only contains alphabet & whitespace";
                            } else if (!nameRegex.hasMatch(value)) {
                              return "Invalid name format. Only contains alphabet & whitespace";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "Enter Last Name",
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: userEmail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your email please";
                            } else if (!emailRegex.hasMatch(value)) {
                              return "Invalid email. Please try to provide a valid email";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: "Enter your email",
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
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: userPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your password please";
                            } else if (!passRegex.hasMatch(value)) {
                              return "Password must contains at lease one uppercase, one lowercase,\n one digit, one special character with length 6 or more";
                            }
                            return null;
                          },
                          obscureText: isVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_open),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off) ,
                            ),
                            hintText: "Enter your password",
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
                        TextFormField(
                          controller: confirmPassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your password please";
                            } else if (confirmPassword.text.trim() !=
                                userPassword.text.trim()) {
                              return "Password not matched";
                            }
                            return null;
                          },
                          obscureText: isVisible,
                          decoration: const InputDecoration(
                            prefixIcon:  Icon(Icons.lock_open),

                            hintText: "Re - enter your password",
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
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
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
                    onPressed: createNewUser,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 5,
                        minimumSize: Size(
                          screenSize.width * 0.8,
                          screenSize.height * 0.08,
                        ),
                        textStyle: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                    child: const Text("Register"),
                  ),
                ),
                const Spacer(),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(const LoginScreen());
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: ColorCode.primaryColor1),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
