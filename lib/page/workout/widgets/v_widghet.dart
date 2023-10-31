import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'basic_overlay.dart';


class VWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const VWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller != null && controller.value.isInitialized
        ? Container(
            alignment: Alignment.topCenter,
            child: buildVideo(),
          )
        : const Center(
          child: CircularProgressIndicator(),
        );
  }

  Widget buildVideo() => Stack(
    children: [
      buildVideoPlayer(),
      Positioned.fill(child: BasicOverlayWidget(controller: controller,)),
    ],

  );

  Widget buildVideoPlayer() => AspectRatio(
    aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
  );
}
