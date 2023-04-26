import 'package:flutter/material.dart';

import '../common/utils.dart';
import '../screen/auth/signin_view.dart';
import 'custom_button.dart';

class SignInInfoDialog extends StatelessWidget {
  const SignInInfoDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.info, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    "Please sign in or create an account to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 75),
                  CustomButton(
                    color: Colors.white,
                    text: 'Sign In',
                    height: 45,
                    onPressed: () {
                      Navigator.of(context).pop();
                      push(const SignInView());
                    },
                  )
                ],
              ),
            )));
  }
}
