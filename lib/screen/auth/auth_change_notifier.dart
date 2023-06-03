import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/screen/auth/signup_view.dart';
import 'package:media_app/screen/bottom_navigation_bar.dart';

import '../../controller/auth_view_controller.dart';

final authChangeNotifier = StreamProvider.autoDispose(
    (ref) => ref.watch(authViewController.notifier).auth.authStateChanges());

class AuthChangeNotifier extends ConsumerWidget {
  const AuthChangeNotifier({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authChangeNotifier).when(
        data: (data) => data == null
            ? const SignUpView()
            : const BottomNavigationBarScreen(),
        error: (e, t) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}
