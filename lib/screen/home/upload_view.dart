import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/widget/button_loader.dart';
import 'package:media_app/widget/custom_button.dart';
import 'package:media_app/widget/custom_textfield.dart';

import '../../controller/post_controller.dart';
import '../../widget/video_player_widget.dart';

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
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(postController);
      return Scaffold(
          body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          VideoPlayerWidget(
            url: widget.path.path,
          ),
          Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.black,
            child: CustomTextfield(
                controller: caption,
                readOnly: true,
                onChanged: (value) => n.setNotifier(),
                hintText: 'Add caption',
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: caption.text.isEmpty
                      ? const SizedBox.shrink()
                      : CustomButton(
                          isLoading: n.isLoading,
                          height: 25,
                          color: Colors.white,
                          width: 100,
                          onPressed: () =>
                              n.uploadVideo(File(widget.path.path)),
                          child: ButtonLoader(
                              isLoading: n.isLoading, text: 'Post'),
                        ),
                ),
                onTap: () async {
                  String? result = await showModalBottomSheet<String>(
                      context: context,
                      builder: (ctx) => const AddCaptionBottomSheet());

                  print(result);
                  setState(() => caption.text = result!);
                }),
          )
        ],
      ));
    });
  }
}

class AddCaptionBottomSheet extends StatelessWidget {
  const AddCaptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final n = ref.watch(postController);
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.black,
        child: SingleChildScrollView(
          child: CustomTextfield(
            controller: n.caption,
            autoFocus: true,
            hintText: 'Add caption',
            onChanged: (value) => n.setNotifier(),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: n.caption.text.isEmpty
                  ? const SizedBox.shrink()
                  : CustomButton(
                      height: 25,
                      color: Colors.white,
                      width: 100,
                      text: 'Done',
                      onPressed: () =>
                          Navigator.of(context).pop(n.caption.text),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
