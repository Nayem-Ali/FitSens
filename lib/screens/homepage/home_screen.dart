import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finessapp/page/option.dart';
import 'package:finessapp/screens/homepage/dashboard_screen.dart';
import 'package:finessapp/screens/homepage/profile_screen.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pages = const [DashboardScreen(), Option(), ProfileScreen()];
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Colors.white,
        backgroundColor: ColorCode.primaryColor2,
        //height: 50,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: const [
          Icon(Icons.dashboard),
          Icon(Icons.list),
          Icon(Icons.perm_identity)
        ],
      ),
      body: pages[_page],
    );
  }
}
