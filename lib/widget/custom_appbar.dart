import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/post_controller.dart';
import 'create_post_bottom_sheet.dart';
import 'signin_info_dialog.dart';

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Container(
        padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
        color: const Color(0xff11162a).withOpacity(0.2),
        height: 100,
        child: Row(
          children: [
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
