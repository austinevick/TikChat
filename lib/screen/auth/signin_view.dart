import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/screen/auth/signup_view.dart';

import '../../common/utils.dart';
import '../../widget/button_loader.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../controller/auth_view_controller.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(authViewController.notifier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 25),
                  const CircleAvatar(
                    radius: 35,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    controller: n.email2,
                    hintText: 'Enter email',
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextfield(
                    controller: n.password2,
                    hintText: 'Enter password',
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    color: Colors.white,
                    child: ButtonLoader(
                      text: 'Sign In',
                      isLoading: ref.watch(authViewController),
                    ),
                    onPressed: () => n.signInWithEmailAndPassword(),
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    height: 40,
                    textColor: Colors.white,
                    width: 200,
                    text: 'Create an account',
                    onPressed: () => push(const SignUpView()),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
