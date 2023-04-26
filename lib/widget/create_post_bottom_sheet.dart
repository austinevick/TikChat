import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common/utils.dart';
import '../screen/home/upload_view.dart';
import 'custom_button.dart';

class CreatePostBottomSheet extends StatelessWidget {
  const CreatePostBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    const border = Border(
        bottom: BorderSide(color: Colors.grey),
        top: BorderSide(color: Colors.grey));
    return Column(
      children: [
        const SizedBox(height: 25),
        const Text(
          'CREATE POST FROM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 25),
        CustomButton(
            border: border,
            textColor: Colors.white,
            radius: 0,
            text: 'Camera',
            onPressed: () => ImagePicker()
                    .pickVideo(source: ImageSource.camera)
                    .then((file) {
                  if (file != null) {
                    push(UploadView(path: File(file.path)));
                  }
                })),
        const SizedBox(height: 16),
        CustomButton(
            border: border,
            textColor: Colors.white,
            radius: 0,
            text: 'Gallery',
            onPressed: () => ImagePicker()
                    .pickVideo(source: ImageSource.gallery)
                    .then((file) {
                  if (file != null) {
                    push(UploadView(path: File(file.path)));
                  }
                })),
        const Spacer(),
        CustomButton(
          border: const Border(
              top: BorderSide(
            color: Colors.grey,
          )),
          textColor: Colors.white,
          radius: 0,
          text: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
