import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/common/enum.dart';
import 'package:media_app/common/utils.dart';
import 'package:media_app/controller/message_controller.dart';

import 'custom_button.dart';

class CustomAudioWidget extends StatefulWidget {
  final String receiverId;
  const CustomAudioWidget({super.key, required this.receiverId});

  @override
  State<CustomAudioWidget> createState() => _CustomAudioWidgetState();
}

class _CustomAudioWidgetState extends State<CustomAudioWidget> {
  late final RecorderController recorderController;
  late final PlayerController playerController;
  bool isRecording = false;
  double radius = 50;
  String path = '';
  int min = 0;
  int sec = 0;
  void initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  bool isPlaying = false;

  void onCurrentDuration() {
    recorderController.onCurrentDuration.listen((event) {
      setState(() {
        min = event.inMinutes;
        sec = event.inSeconds.remainder(60);
      });
    });
  }

  void onPlayerStateChanged() {
    playerController = PlayerController();
    playerController.onPlayerStateChanged.listen((state) {
      setState(() {
        state = playerController.playerState;
      });
    });
  }

  @override
  void initState() {
    initialiseController();
    onPlayerStateChanged();
    onCurrentDuration();

    super.initState();
  }

  IconData buildPlayerIcon() {
    switch (playerController.playerState) {
      case PlayerState.playing:
        return Icons.pause;
      case PlayerState.paused:
        return Icons.play_arrow;
      default:
        return Icons.play_arrow;
    }
  }

  void startRecording() async {
    await recorderController.record();
  }

  Future<String?> stopRecording() async {
    return await recorderController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 2.7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(isRecording
                  ? 'Recording...'
                  : 'Tap on the mic to record, tap again to cancel.'),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: Material(
                  color: const Color(0xff666b7a),
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              playerController.startPlayer();
                            },
                            icon: Icon(buildPlayerIcon())),
                        Expanded(
                          child: isRecording || path.isEmpty
                              ? AudioWaveforms(
                                  enableGesture: true,
                                  shouldCalculateScrolledPosition: true,
                                  size: const Size(double.infinity, 50.0),
                                  recorderController: recorderController,
                                  waveStyle: const WaveStyle(
                                    waveColor: Colors.white,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                )
                              : AudioFileWaveforms(
                                  size: const Size(double.infinity, 50),
                                  playerController: playerController,
                                  playerWaveStyle: const PlayerWaveStyle(
                                      seekLineThickness: 3,
                                      waveThickness: 3,
                                      showSeekLine: false),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                            "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}")
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              path.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        playerController.stopAllPlayers();
                      },
                      icon: const Icon(Icons.delete))
                  : AvatarGlow(
                      endRadius: isRecording ? 50 : 40,
                      animate: isRecording ? true : false,
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          setState(() => isRecording = !isRecording);
                          if (isRecording) {
                            await recorderController.record();
                          } else {
                            final path = await recorderController.stop();

                            setState(() => this.path = path!);
                            await playerController.preparePlayer(
                                path: this.path);
                          }
                        },
                        child: AnimatedContainer(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(60)),
                            width: isRecording ? 50 : 45,
                            height: isRecording ? 50 : 45,
                            duration: const Duration(milliseconds: 1200),
                            child: const Icon(Icons.mic)),
                      ),
                    ),
              const Spacer(),
              CustomButton(
                height: 50,
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  if (path.isEmpty) {
                    showToast('No audio was found');
                    return;
                  }
                  ref.read(messageController).sendFileMessage(
                      path, widget.receiverId, MessageType.audio);
                },
                text: 'Send',
              )
            ],
          ),
        ),
      );
    });
  }
}
