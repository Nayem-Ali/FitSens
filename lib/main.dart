import 'package:finessapp/screens/auth/login_screen.dart';
import 'package:finessapp/screens/homepage/home_screen.dart';
import 'package:finessapp/screens/onboarding/get_started_screen.dart';
import 'package:finessapp/screens/onboarding/onboarding_sceen.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// To interact with flutter engine
  await Firebase.initializeApp(
    name: "Fitness App",
    options: const FirebaseOptions(
      apiKey: "AIzaSyB1eme39Dmz_4q1k0EaPidyZZ0tr7nlyh8",
      appId: "1:780499690558:android:1ccbad2a23fff57f8b9d6f",
      messagingSenderId: "780499690558",
      projectId: "fitness-app-f0ef1",
      storageBucket: "gs://fitness-app-f0ef1.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    bool isNew() {
      FirebaseAuth auth = FirebaseAuth.instance;
      bool res = auth.currentUser?.uid != null;
      print(auth.currentUser?.uid);
      print(res);
      return res;
    }

    return GetMaterialApp(
      title: 'Fitsens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorCode.primaryColor1),
        primaryColor: ColorCode.primaryColor1,
        //fontFamily: "Poppins",
        textTheme: GoogleFonts.latoTextTheme(),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.emailVerified) {
            return const HomeScreen();
          } else if (isNew()) {
            print("I have email");
            return const LoginScreen();
          } else {
            return const GetStartedScreen();
          }
        },
      ),
    );
  }
}
