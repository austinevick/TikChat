import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/utils.dart';
import '../controller/auth_view_controller.dart';
import '../controller/post_controller.dart';
import '../widget/custom_textfield.dart';
import 'profile/current_user_profile.dart';
import 'profile/other_user_profile.dart';

final usersProvider = StreamProvider(
    (ref) => ref.read(authViewController.notifier).getUsersAsStream());

final searchProvider = StreamProvider.family((ref, String query) =>
    ref.read(authViewController.notifier).searchUsers(query));

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final user = ref.watch(postController).currentUserId;
      return Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(60, 60),
              child: SafeArea(
                child: Container(
                  color: const Color(0xff666b7a),
                  height: 60,
                  child: Row(
                    children: [
                      const BackButton(),
                      Expanded(
                        child: CustomTextfield(
                          controller: searchCtrl,
                          onChanged: (value) => setState(() {}),
                          hintText: 'Search',
                          autoFocus: true,
                          hasBorderside: false,
                          suffixIcon: searchCtrl.text.isEmpty
                              ? const SizedBox.shrink()
                              : IconButton(
                                  onPressed: () => searchCtrl.clear(),
                                  icon: const Icon(Icons.clear)),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          body: searchCtrl.text.isNotEmpty
              ? ref.watch(searchProvider(searchCtrl.text)).when(
                  data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, i) => ListTile(
                            onTap: () {
                              if (data[i].userId == user) {
                                push(const CurrentUserProfile());
                                return;
                              }
                              push(OtherUserProfile(id: data[i].userId));
                            },
                            leading: const CircleAvatar(),
                            title: Text(data[i].name),
                          )),
                  error: (e, t) => const Center(),
                  loading: () => const Center())
              : ref.watch(usersProvider).when(
                  data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, i) => ListTile(
                            onTap: () {
                              if (data[i].userId == user) {
                                push(const CurrentUserProfile());
                                return;
                              }
                              push(OtherUserProfile(id: data[i].userId));
                            },
                            leading: const CircleAvatar(),
                            title: Text(data[i].name),
                          )),
                  error: (e, t) => const Center(),
                  loading: () => const Center()));
    });
  }
}
