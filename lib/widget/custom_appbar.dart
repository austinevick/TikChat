import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/post_controller.dart';
import 'create_post_bottom_sheet.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(postController);
      return Container(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        color: const Color(0xff11162a).withOpacity(0.2),
        height: 100,
        child: Row(
          children: [
            notifier.percentage != '100%'
                ? notifier.progress == 0
                    ? const SizedBox.shrink()
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: notifier.progress,
                            color: Colors.red,
                            backgroundColor: Colors.grey,
                          ),
                          Center(
                              child: Text(
                            notifier.percentage,
                            style: const TextStyle(fontSize: 10),
                          )),
                        ],
                      )
                : const SizedBox.shrink(),
            const Spacer(),
            IconButton(
              onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (ctx) => const CreatePostBottomSheet()),
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 30, color: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}
