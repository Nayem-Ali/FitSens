import 'package:finessapp/services/auth_service.dart';
import 'package:finessapp/screens/auth/register_screen.dart';
import 'package:finessapp/screens/homepage/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/color_utility.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
       // resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SafeArea(
                    child: Text(
                      "Hey, There",
                      style: TextStyle(
                          color: ColorCode.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 22),
                    ),
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(
                        color: ColorCode.primaryColor1,
                        fontWeight: FontWeight.w900,
                        fontSize: 36),
                  ),
                  const SizedBox(height: 20),
                  //const Expanded(child: SizedBox(height: 20)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter email";
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
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter email";
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
                                  icon: Icon(isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                hintText: "Enter your password",
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black12),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: resetPassword,
                    style: TextButton.styleFrom(foregroundColor: ColorCode.gray),
                    child: const Text("Forget Password",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(colors: [
                        ColorCode.primaryColor2,
                        ColorCode.primaryColor1
                      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        AuthService auth = AuthService();
                        String flag = await auth.loginUser(
                            email.text.trim(), password.text.trim());
                        if (flag == "true") {
                          Get.offAll(const HomeScreen());
                        } else {
                          Get.snackbar("Something went wrong", flag,
                              duration: const Duration(seconds: 5));
                        }
                      },
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
                      icon: Icon(
                        Icons.login,
                        size: screenSize.width * 0.08,
                      ),
                      label: const Text("Login"),
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: Colors.black12, thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Did not registered yet?",
                        style:
                            TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const RegisterScreen());
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: ColorCode.primaryColor1),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void resetPassword() {
    var screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0,horizontal: 9),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter your email & tap sent button to get a email with password reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorCode.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: email,
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
                    fillColor: Colors.black12),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                        colors: ColorCode.primaryG,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    AuthService auth = AuthService();
                    String flag = await auth.resetPassword(email.text.trim());
                    if (flag == "true") {
                      Get.snackbar("Dear user",
                          "An password reset link is sent to ${email.text}",
                          duration: const Duration(seconds: 5));
                    } else {
                      Get.snackbar("Something went wrong!", flag,
                          duration: const Duration(seconds: 5));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: Size(
                          screenSize.width * .8, screenSize.height * .08)),
                  icon: const Icon(Icons.send),
                  label: const Text("Sent"),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      },
    );
  }
}
