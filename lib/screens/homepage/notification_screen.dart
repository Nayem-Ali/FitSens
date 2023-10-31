import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> dummyNotifications = [
    {
      "title": "Don't miss your lower body workout",
      "subtitle": "About 30 minutes ago"
    },
    {
      "title": "Congratulation. You have finished your today's activity.",
      "subtitle": "28 May"
    },
    {
      "title": "Oops. You missed your upper body workout.",
      "subtitle": "3 April"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notifications"),
      ),
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                //style: ListTileStyle.list,
                title: Text(
                  dummyNotifications[index]["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  dummyNotifications[index]["subtitle"]!,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: IconButton(
                  onPressed: () {
                    dummyNotifications.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.dangerous,
                    color: Colors.red,
                  ),
                ),
              ),
              const Divider(thickness: 2),
            ],
          );
        },
      ),
    );
  }
}
