import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/message_controller.dart';
import '../../widget/custom_audio_widget.dart';
import '../../widget/custom_textfield.dart';

class MessageTextField extends StatefulWidget {
  final String receiverId;
  const MessageTextField({super.key, required this.receiverId});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final messageCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(messageController);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const CircleAvatar(child: Icon(Icons.camera_alt))),
            Expanded(
              child: Material(
                color: const Color(0xff666b7a),
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: CustomTextfield(
                    hintText: 'Write something here',
                    hasBorderside: false,
                    maxLines: null,
                    textStyle: const TextStyle(),
                    onChanged: (value) => setState(() {}),
                    textCapitalization: TextCapitalization.sentences,
                    controller: messageCtrl,
                  ),
                ),
              ),
            ),
            messageCtrl.text.isEmpty
                ? IconButton(
                    color: Colors.white,
                    onPressed: () => showModalBottomSheet(
                        shape: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (ctx) =>
                            CustomAudioWidget(receiverId: widget.receiverId)),
                    icon: const CircleAvatar(child: Icon(Icons.mic)))
                : IconButton(
                    color: Colors.white,
                    onPressed: () {
                      notifier.sentTextMessage(
                          textMessage: messageCtrl.text,
                          receiverId: widget.receiverId);
                      messageCtrl.clear();
                    },
                    icon: const CircleAvatar(child: Icon(Icons.send))),
          ],
        ),
      );
    });
  }
}
