import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../common/utils.dart';
import '../../controller/message_controller.dart';
import '../../model/user_model.dart';
import '../../widget/custom_button.dart';
import '../auth/signin_view.dart';
import '../search_users_screen.dart';
import 'message_screen.dart';

final lastMessageProvider =
    StreamProvider((ref) => ref.read(messageController).getAllLastMessages());

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) => Consumer(builder: (context, ref, _) {
        final notifier = ref.watch(messageController);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Messages'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search))
            ],
          ),
          body: notifier.auth.currentUser == null
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
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
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
              : ref.watch(lastMessageProvider).when(
                  data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (ctx, i) {
                        final chat = data[i];
                        return ListTile(
                            onTap: () => push(MessageScreen(
                                  user: UserModel(
                                      userId: chat.contactId,
                                      documentId: chat.documentId,
                                      name: chat.username,
                                      isOnline: chat.isOnline),
                                )),
                            subtitle: Text(chat.lastMessage),
                            trailing: Text(
                                DateFormat('kk:mm').format(data[i].timeSent)),
                            leading: const CircleAvatar(),
                            title: Text(chat.username));
                      }),
                  error: (e, t) => Center(
                        child: Text(e.toString()),
                      ),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
          floatingActionButton: FloatingActionButton(
            onPressed: () => push(const SearchUsersScreen()),
            child: const Icon(Icons.chat),
          ),
        );
      });
}
