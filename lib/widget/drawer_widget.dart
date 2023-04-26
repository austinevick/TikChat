import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/utils.dart';
import '../controller/auth_view_controller.dart';
import '../screen/auth/signin_view.dart';
import 'create_post_bottom_sheet.dart';
import 'signin_info_dialog.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final authNotifier = ref.watch(authViewController.notifier);

      return Drawer(
        child: SafeArea(
            child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              trailing: const Icon(Icons.video_call, color: Colors.white),
              title: const Text(
                'CREATE',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              onTap: () {
                if (authNotifier.auth.currentUser == null) {
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
            ),
            const Divider(thickness: 1.8),
            const Spacer(),
            ListTile(
                trailing: const Icon(Icons.login),
                title: Text(authNotifier.auth.currentUser != null
                    ? 'LOG OUT'
                    : "SIGN IN"),
                onTap: () => authNotifier.auth.signOut().whenComplete(
                    () => pushAndRemoveUntil(const SignInView()))),
          ],
        )),
      );
    });
  }
}
