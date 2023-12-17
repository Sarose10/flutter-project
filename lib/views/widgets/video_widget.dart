
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';
import 'package:sk/models/video.dart';

class PlayVideoFromNetwork extends StatefulWidget {
  final Video video;
  const PlayVideoFromNetwork({Key? key, required this.video}) : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromNetworkState();
}

class _PlayVideoFromNetworkState extends State<PlayVideoFromNetwork> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.video.key}'),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(controller: controller);
  }
}