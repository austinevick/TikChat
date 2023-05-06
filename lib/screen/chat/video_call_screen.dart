import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:media_app/widget/custom_button.dart';

import '../../controller/video_call_controller.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "114cf81bc1fe403996c9cf0b1e4ba6f7",
          channelName: "channelName"));

  void initAgoraClient() async {
    await client.initialize();
  }

  @override
  void initState() {
    initAgoraClient();
    client.sessionController.addListener(() {
      videoVisibilityIcon();
      micVisibilityIcon();
    });
    super.initState();
  }

  IconData videoIcon = Icons.videocam;
  void videoVisibilityIcon() {
    setState(() {
      if (client.sessionController.value.isLocalVideoDisabled) {
        videoIcon = Icons.videocam;
      } else {
        videoIcon = Icons.videocam_off;
      }
    });
  }

  IconData micIcon = Icons.mic;
  void micVisibilityIcon() {
    setState(() {
      if (client.sessionController.value.isLocalUserMuted) {
        videoIcon = Icons.mic_off;
      } else {
        videoIcon = Icons.mic;
      }
    });
  }

  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future.value(false),
      child: GestureDetector(
        onTap: () => setState(() => isVisible = !isVisible),
        child: Scaffold(
          body: Stack(
            children: [
              AgoraVideoViewer(client: client),
              Positioned(
                top: 40,
                right: 16,
                child: isVisible
                    ? GestureDetector(
                        onTap: () => VideoCallController.switchCamera(
                            sessionController: client.sessionController),
                        child: const Icon(Icons.cameraswitch))
                    : const SizedBox.shrink(),
              ),
              Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: isVisible
                      ? Container(
                          height: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black38.withOpacity(0.2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () => VideoCallController.toggleMute(
                                      sessionController:
                                          client.sessionController),
                                  child: CircleAvatar(
                                      radius: 22, child: Icon(micIcon))),
                              CustomButton(
                                height: 60,
                                width: 60,
                                color: Colors.red,
                                radius: 500,
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await VideoCallController.endCall(
                                      sessionController:
                                          client.sessionController);
                                  await client.release();
                                },
                                child: const Icon(Icons.call),
                              ),
                              GestureDetector(
                                  onTap: () async =>
                                      VideoCallController.toggleCamera(
                                          sessionController:
                                              client.sessionController),
                                  child: CircleAvatar(
                                      radius: 22, child: Icon(videoIcon))),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
