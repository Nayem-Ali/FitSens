import 'package:finessapp/page/workout/widgets/v_widghet.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../utility/color.dart';
import '../../../utility/utils.dart';
import '../../widgets/button.dart';


class VedioPlayer extends StatefulWidget {
  final String assetPath;
  final String title;
  const VedioPlayer({Key? key, required this.assetPath, required this.title}) : super(key: key);

  @override
  State<VedioPlayer> createState() => _VedioPlayerState();
}

class _VedioPlayerState extends State<VedioPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(widget.assetPath)
      ..addListener(() {
        setState(() {
        });
      })
      ..setLooping(true)
      ..initialize().then((value) => controller.play());


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
      body: SingleChildScrollView(

        child: Column(
          children: [
            VWidget(controller: controller),
            const SizedBox(
              height: 20,
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

                if (controller != null && controller.value.isInitialized)
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
            ),

            const SizedBox(
              height: 25,
            ),

            MyButton(label: "Done", onTap: (){
              Navigator.pop(context);
            }, width: 100, height: 50,fontSize: 15)


          ],
        ),
      ),
    ));
  }
}
