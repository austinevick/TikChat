import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/post_controller.dart';
import '../screen/chat/message_screen.dart';

class MessageBadge extends StatelessWidget {
  const MessageBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final user = ref.watch(postController).currentUserId;
      final n = ref.watch(messageStreamProvider(user));

      return Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(color: Colors.white, Icons.chat),
          Positioned(
              right: -7,
              top: -6,
              child: n.when(
                  data: (data) => data.isEmpty
                      ? const SizedBox.shrink()
                      : CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 8.5,
                          child: Text(
                            data.length.toString(),
                            style: const TextStyle(fontSize: 10),
                          )),
                  error: (e, t) => const Center(),
                  loading: () => const Center())),
        ],
      );
    });
  }
}
