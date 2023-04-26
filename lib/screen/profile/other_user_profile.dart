import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/utils.dart';
import '../../controller/auth_view_controller.dart';
import '../../controller/post_controller.dart';
import '../chat/message_screen.dart';

final userPostsStreamProvider =
    StreamProvider((ref) => ref.read(postController).getCurrentUserPosts());

final userDetailsProvider = FutureProvider.family((ref, String id) =>
    ref.read(authViewController.notifier).getCurrentUserById(id));

class OtherUserProfile extends StatelessWidget {
  final String id;
  const OtherUserProfile({super.key, this.id = ''});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final authNotifier = ref.watch(userDetailsProvider(id));

      return Scaffold(
          body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [],
          body: Column(
            children: [
              const SizedBox(height: 30),
              authNotifier.when(
                  data: (data) => Column(
                        children: [
                          const CircleAvatar(
                            radius: 48,
                            child: Icon(Icons.person, size: 38),
                          ),
                          const SizedBox(height: 20),
                          Center(
                              child: Text(
                            data!.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )),
                          Center(child: Text(data.email!)),
                          const SizedBox(height: 12),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    iconSize: 35,
                                    onPressed: () =>
                                        push(MessageScreen(user: data)),
                                    icon: const Icon(Icons.message)),
                                IconButton(
                                    iconSize: 35,
                                    onPressed: () {},
                                    icon: const Icon(Icons.block))
                              ]),
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
