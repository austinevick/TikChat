import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils.dart';
import '../../controller/auth_view_controller.dart';
import '../../controller/post_controller.dart';
import '../../widget/custom_button.dart';
import '../auth/signin_view.dart';

final userPostsStreamProvider =
    StreamProvider((ref) => ref.read(postController).getCurrentUserPosts());

final userDetailsProvider = FutureProvider(
    (ref) => ref.read(authViewController.notifier).getCurrentUserById());

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final authNotifier = ref.watch(userDetailsProvider);

      return Scaffold(
          body: SafeArea(
        child: authNotifier.asData == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 48,
                    child: Icon(Icons.person, size: 38),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please sign in or create an account to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    color: Colors.white,
                    text: 'Sign In',
                    height: 45,
                    width: 180,
                    onPressed: () => push(const SignInView()),
                  )
                ],
              )
            : NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [],
                body: Column(
                  children: [
                    const SizedBox(height: 30),
                    authNotifier.when(
                        data: (data) => Column(
                              children: [
                                Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 48,
                                      child: Icon(Icons.person, size: 38),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {},
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 18,
                                          child:
                                              Icon(Icons.camera_alt, size: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Center(
                                    child: Text(
                                  data!.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )),
                                Center(child: Text(data.email!)),
                                const SizedBox(height: 20),
                              ],
                            ),
                        error: (e, t) => const Center(),
                        loading: () => const Center()),
                    const Text(
                      'Posts',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Divider(thickness: 2),
                    ref.watch(userPostsStreamProvider).when(
                        data: (data) => Expanded(
                              child: GridView.builder(
                                  itemCount: data.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  itemBuilder: (ctx, i) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(),
                                      )),
                            ),
                        error: (e, t) => Center(
                              child: Text(e.toString()),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ))
                  ],
                ),
              ),
      ));
    });
  }
}
