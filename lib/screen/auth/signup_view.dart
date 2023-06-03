import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils.dart';
import '../../widget/button_loader.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../controller/auth_view_controller.dart';
import 'signin_view.dart';

class SignUpView extends ConsumerWidget {
  const SignUpView({super.key});

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
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 25),
                  CustomTextfield(
                    controller: n.name,
                    hintText: 'Enter full name',
                  ),
                  const SizedBox(height: 10),
                  CustomTextfield(
                    controller: n.email1,
                    hintText: 'Enter email',
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextfield(
                    controller: n.password1,
                    hintText: 'Enter password',
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 50),
                  CustomButton(
                    color: Colors.white,
                    child: ButtonLoader(
                      text: 'Create account',
                      isLoading: ref.watch(authViewController),
                    ),
                    onPressed: () => n.signUpWithEmailAndPassword(),
                  ),
                  const SizedBox(height: 18),
                  CustomButton(
                    height: 40,
                    width: 200,
                    textColor: Colors.white,
                    text: 'Old Member? Login',
                    onPressed: () => push(const SignInView()),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
