import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:media_app/common/enum.dart';

import '../../common/utils.dart';
import 'custom_audio_player.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final DateTime timeSent;
  final String message;
  final String avatar;
  final MessageType type;
  const MessageBubble(
      {super.key,
      required this.isMe,
      required this.timeSent,
      required this.message,
      required this.avatar,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isMe
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(child: Text(avatar)),
                    ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xff16a464)
                          : const Color(0xff35356e),
                      borderRadius: BorderRadius.circular(10)),
                  child: buildMessageWidget(type)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTextMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(message),
          Text(dateFormatter(timeSent),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white60)),
        ],
      );

  Widget buildMessageWidget(MessageType type) {
    switch (type) {
      case MessageType.text:
        return buildTextMessage();
      case MessageType.audio:
        return CustomAudioPlayer(path: message);
      default:
        return Text(message);
    }
  }
}
