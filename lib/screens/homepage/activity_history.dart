import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finessapp/services/db_service.dart';
import 'package:finessapp/utility/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key}) : super(key: key);

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  DBService dbService = DBService();
  List<Map<String, dynamic>> stepActivity = [];

  getData() async {
    stepActivity = await dbService.getSteps();
    stepActivity.sort((a, b) => a['date'].compareTo(b['date']));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: stepActivity.length,
        itemBuilder: (context, index) {
          // var date = DateTime.fromMillisecondsSinceEpoch(stepActivity[index]['date'] * 1000);
          DateTime date = (stepActivity[index]['date'] as Timestamp).toDate();
          String formattedDate = DateFormat.yMMMMEEEEd().format(date);
          return Card(
            child: ListTile(
              title: Text(formattedDate),
              subtitle: Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: (stepActivity[index]['steps'] / stepActivity[index]['target']),
                    color: ColorCode.primaryColor1,
                    backgroundColor: ColorCode.secondaryColor2,
                    minHeight: 15,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  Text((stepActivity[index]['steps'] / stepActivity[index]['target'] * 100)
                            .toStringAsPrecision(2) +'%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              // leading: stepActivity[index]['goal'] == 'complete'
              //     ? const Icon(
              //         Icons.done_outline_outlined,
              //         color: Colors.green,
              //       )
              //     : const Icon(
              //         Icons.cancel,
              //         color: Colors.red,
              //       ),
            ),
          );
        },
      ),
    );
  }
}
