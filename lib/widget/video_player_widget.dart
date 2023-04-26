import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'custom_button.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final double? iconSize;
  const VideoPlayerWidget({super.key, required this.url, this.iconSize});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController videoController;
  late final AnimationController animationController;
  bool isPlaying = true;
  bool isVisible = false;
  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.url)..initialize();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    videoController.addListener(() {
      if (!videoController.value.isPlaying) {
        setState(() => isVisible = true);
      }
    });
    super.initState();
  }

  void fadeOutController() {
    Future.delayed(const Duration(milliseconds: 2000),
        () => setState(() => isVisible = !isVisible));
  }

  void playerHandler() => setState(() {
        fadeOutController();
        isPlaying = !isPlaying;
        if (isPlaying) {
          animationController.reverse();
          videoController.pause();
        } else {
          videoController.play();
          animationController.forward();
        }
      });

  @override
  void dispose() {
    videoController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => playerHandler(),
      child: Stack(
        children: [
          VideoPlayer(videoController),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(videoController,
                  allowScrubbing: true)),
          Center(
              child: Visibility(
                  visible: isVisible,
                  child: AnimatedIcon(
                      size: widget.iconSize ?? 80,
                      color: Colors.red,
                      icon: AnimatedIcons.play_pause,
                      progress: animationController))),
        ],
      ),
    );
  }
}
