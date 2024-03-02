import 'package:finessapp/page/workout/widgets/v_widghet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../services/db_service.dart';
import '../../../utility/color.dart';
import '../../../utility/utils.dart';
import '../../widgets/button.dart';

class VideoPlayer extends StatefulWidget {
  final String assetPath;
  final String title;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  final String text6;
  final String text7;
  final String text8;
  final String text9;
  final String text10;
  final String text11;

  const VideoPlayer(
      {Key? key,
      required this.assetPath,
      required this.title,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.text4,
      required this.text5,
      required this.text6,
      required this.text7,
      required this.text8,
      required this.text9,
      required this.text10,
      required this.text11})
      : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  DBService dbService = DBService();
  late VideoPlayerController controller;
  late Future<void> _initializeVideoPlayerFuture;

  Map<String, double> fExercise = {
    'Warm Up': 50,
    'Jumping Jack': 120,
    'Skipping': 70,
    'Squats': 100,
    'Arm Raises': 80,
    'Rest and Drinks': 90,
    'Incline Push-Ups': 100,
    'Push-Ups': 90,
    'Cobra Stretch': 100,
  };

  setData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("targetBurn")) {
      sp.setDouble('targetBurn', 800);
      sp.setDouble('completedBurn', 0);
    }
    double target = sp.getDouble('targetBurn') ?? 800;
    double completed = sp.getDouble('completedBurn') ?? 0;
    completed += fExercise[widget.title]!;
    sp.setDouble("completedBurn", completed);
    DateTime date = DateTime.now();
    String id = DateFormat.yMMMd().format(date);
    Map<String, dynamic> workoutData = {
      'id': id,
      'date': date,
      'percentage':
          completed / target >= 1 ? 100 : ((completed / target) * 100).toInt(),
      "target": target,
      "complete": completed,
    };
    await dbService.addWorkoutData(workoutData);
    // print(controller.value.duration.inSeconds - controller.value.position.inSeconds < 15);
  }

  @override
  void initState() {
    super.initState();
    try{
      controller = VideoPlayerController.asset(widget.assetPath)
        ..addListener(() {
          setState(() {});
        })
        ..setLooping(false)
        ..initialize().then(
              (value) => controller.play(),
        );
    }catch(e){
      print(e);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;

    return SafeArea(
        child: Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 200,
                width: 350,
                child: VWidget(controller: controller)),
            const SizedBox(
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    widget.title,
                    style: SafeGoogleFont(
                      'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    MyButton(
                        label: "Done",
                        onTap: () async {
                          if ((controller.value.duration.inSeconds -
                                  controller.value.position.inSeconds) <
                              50) {
                            await setData();
                            Get.back();
                          } else {
                            Get.snackbar(
                              "Oops",
                              "You have not finished yet",
                            );
                          }
                        },
                        width: 80,
                        height: 42,
                        fontSize: 16),
                    if (controller.value.isInitialized)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryClr,
                          child: IconButton(
                              onPressed: () {
                                controller.setVolume(isMuted ? 1 : 0);
                              },
                              icon: Icon(
                                isMuted ? Icons.volume_mute : Icons.volume_up,
                                color: Colors.white,
                              )),
                        ),
                      ),
                  ],
                )
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            //const FullExerciseList(),
            Container(
              height: Get.height*0.6,
              width: Get.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(60)),
                gradient: primaryGradient,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      widget.text1,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.text2,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text3,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text4,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text5,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text6,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text7,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text8,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text9,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text10,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.text11,
                      style: SafeGoogleFont(
                        'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: primaryClr,
        title: Center(
          child: Text(
            "Tutorial",
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 20,
            color: Colors.white,
          ),
        ),
        actions: const [
          SizedBox(
            width: 60,
          ),
        ]);
  }
}
