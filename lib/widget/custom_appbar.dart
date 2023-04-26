import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_view_controller.dart';
import '../controller/post_controller.dart';
import 'create_post_bottom_sheet.dart';
import 'message_badge.dart';
import 'signin_info_dialog.dart';

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final postNotifier = ref.watch(postController);

      return Container(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        color: const Color(0xff11162a).withOpacity(0.2),
        height: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                if (postNotifier.auth.currentUser == null) {
                  showDialog(
                      context: context,
                      builder: (ctx) => const SignInInfoDialog());
                  return;
                }
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    context: context,
                    builder: (ctx) => const CreatePostBottomSheet());
              },
              icon: const Icon(Icons.camera_alt_outlined,
                  size: 30, color: Colors.white),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => postNotifier.setVisibility(),
              icon: Icon(
                  postNotifier.isVisible
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 25,
                  color: Colors.white),
            ),
          ],
        ),
      );
    });
  }
}
