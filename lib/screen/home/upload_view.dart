import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/widget/button_loader.dart';
import 'package:media_app/widget/custom_button.dart';
import 'package:media_app/widget/custom_textfield.dart';
import 'dart:isolate';
import '../../common/utils.dart';
import '../../controller/post_controller.dart';
import '../../widget/video_player_widget.dart';
import '../bottom_navigation_bar.dart';

class UploadView extends StatefulWidget {
  final File path;
  const UploadView({super.key, required this.path});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  var caption = TextEditingController();
  @override
  void dispose() {
    caption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = MediaQuery.of(context).size;
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Consumer(builder: (context, ref, _) {
        final n = ref.watch(postController);
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                VideoPlayerWidget(
                  url: widget.path.path,
                ),
                Positioned(
                  bottom: isKeyboardVisible ? m.height / 2.5 : 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    color: Colors.black45.withOpacity(0.2),
                    child: CustomTextfield(
                      controller: caption,
                      hasBorderside: false,
                      onChanged: (value) => n.setNotifier(),
                      hintText: 'Add caption',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: caption.text.isEmpty
                            ? const SizedBox.shrink()
                            : CustomButton(
                                isLoading: n.isLoading,
                                color: Colors.white,
                                width: 100,
                                onPressed: () async {
                                  n.uploadVideo(
                                      caption.text, File(widget.path.path));

                                  pushAndRemoveUntil(
                                      const BottomNavigationBarScreen());
                                },
                                child: ButtonLoader(
                                    isLoading: n.isLoading, text: 'Post'),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      });
    });
  }
}
