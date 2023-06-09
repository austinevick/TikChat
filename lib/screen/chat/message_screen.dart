import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import '../../common/utils.dart';
import '../../controller/message_controller.dart';
import '../../model/user_model.dart';
import '../profile/other_user_profile.dart';
import 'message_bubble.dart';
import 'message_textfield.dart';
import 'video_call_screen.dart';

final messageStreamProvider = StreamProvider.family(
    (ref, String id) => ref.read(messageController).getAllOneToOneMessage(id));

class MessageScreen extends StatefulWidget {
  final UserModel user;
  const MessageScreen({super.key, required this.user});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with SingleTickerProviderStateMixin {
  final itemScrollController = GroupedItemScrollController();
  late final AnimationController animationController;
  late final Animation<Offset> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(0.0, -5.0))
        .animate(animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(messageController);
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(60, 60),
              child: SafeArea(
                child: Container(
                    width: double.infinity,
                    height: 60,
                    color: const Color(0xff11162a),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const BackButton(),
                          Stack(
                            children: [
                              CircleAvatar(radius: 15),
                              CircleAvatar(
                                child: Text(widget.user.name.substring(0, 1)),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                              onTap: () => push(
                                  OtherUserProfile(id: widget.user.userId)),
                              child: Text(
                                widget.user.name,
                                style: const TextStyle(fontSize: 17),
                              )),
                          const Spacer(),
                          IconButton(
                              onPressed: () => push(const VideoCallScreen()),
                              icon: const FaIcon(FontAwesomeIcons.video))
                        ],
                      ),
                    )),
              )),
          body: Column(
            children: [
              Expanded(
                child: ref
                    .watch(messageStreamProvider(widget.user.userId))
                    .when(
                        data: (data) =>
                            NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                setState(() {
                                  if (scrollNotification
                                      is ScrollStartNotification) {
                                    animationController.forward();
                                  } else if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    animationController.forward();
                                  } else if (scrollNotification
                                      is ScrollEndNotification) {
                                    animationController.reverse();
                                  }
                                });
                                return true;
                              },
                              child: StickyGroupedListView(
                                stickyHeaderBackgroundColor:
                                    const Color(0xff292d36),
                                elements: data,
                                groupBy: (message) =>
                                    DateFormat.yMMMd().format(message.timeSent),
                                groupSeparatorBuilder: (element) => SizedBox(
                                  height: 50,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 100,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          DateFormat.yMMMd()
                                              .format(element.timeSent),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9.5,
                                              fontWeight: FontWeight.w700),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                itemScrollController: itemScrollController,
                                order: StickyGroupedListOrder.ASC,
                                indexedItemBuilder: (context, chat, index) =>
                                    MessageBubble(
                                        isMe: chat.senderId ==
                                            notifier.currentUserId,
                                        type: chat.type,
                                        timeSent: chat.timeSent,
                                        avatar:
                                            widget.user.name.substring(0, 1),
                                        message: chat.textMessage),
                              ),
                            ),
                        error: (e, t) => Center(
                              child: Text(e.toString()),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            )),
              ),
              MessageTextField(receiverId: widget.user.userId)
            ],
          ),
        ),
      );
    });
  }
}
