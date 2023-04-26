import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String path;
  const CustomAudioPlayer({super.key, required this.path});

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  PlayerController controller = PlayerController();
  List<double> data = [];

  int sec = 0;
  Future<void> extractAudio() async {
    final waveFormData =
        await controller.extractWaveformData(path: widget.path);
    setState(() => data = waveFormData);
  }

  void onCurrentDuration() {
    controller.onCurrentDurationChanged.listen((event) {
      setState(() {
        sec = event;
      });
    });
  }

  void onPlayerStateChanged() {
    controller.onPlayerStateChanged.listen((state) {
      setState(() {
        state = controller.playerState;
      });
    });
  }

  @override
  void initState() {
    controller.preparePlayer(path: widget.path);

    onPlayerStateChanged();
    onCurrentDuration();
    super.initState();
  }

  IconData buildPlayerIcon() {
    switch (controller.playerState) {
      case PlayerState.playing:
        return Icons.pause;
      case PlayerState.paused:
        return Icons.play_arrow;
      default:
        return Icons.play_arrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (controller.playerState.isPlaying) {
                  controller.pausePlayer();
                } else {
                  print(widget.path);
                  controller.startPlayer();
                }
              },
              icon: Icon(buildPlayerIcon())),
          Expanded(
            child: AudioFileWaveforms(
                size: const Size(double.infinity, 35.0),
                playerController: controller,
                enableSeekGesture: true,
                waveformData: data,
                playerWaveStyle: const PlayerWaveStyle(
                  showSeekLine: false,
                )),
          ),
          CircleAvatar()
        ],
      ),
    );
  }
}
