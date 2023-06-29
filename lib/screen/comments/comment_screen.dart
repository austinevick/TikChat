import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../common/utils.dart';
import '../../controller/comment_controller.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../profile/current_user_profile.dart';
import '../profile/other_user_profile.dart';
import 'reply_comments_screen.dart';

final commentsProvider = StreamProviderFamily(
    (ref, String id) => ref.read(commentController).getComments(id));

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final commentCtrl = TextEditingController();
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final notifier = ref.watch(commentController);

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: const Color(0xff666b7a),
                    borderRadius: BorderRadius.circular(25),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextfield(
                        controller: commentCtrl,
                        focusNode: focus,
                        hasBorderside: false,
                        autoFocus: true,
                        onChanged: (value) => setState(() {}),
                        hintText: 'Comment',
                        suffixIcon: IconButton(
                            onPressed: () {
                              notifier.commentOnPost(
                                  widget.postId, commentCtrl.text);
                              commentCtrl.clear();
                            },
                            icon: commentCtrl.text.isEmpty
                                ? const SizedBox.shrink()
                                : const Icon(Icons.send)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: ref.watch(commentsProvider(widget.postId)).when(
                        data: (data) => ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (ctx, i) {
                              final comment = data[i];
                              bool isLiked =
                                  comment.likes.contains(comment.userId);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          child: Text(
                                              data[i].username.substring(0, 1)),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.blueGrey
                                                  .withOpacity(0.4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      if (comment.userId ==
                                                          notifier
                                                              .currentUserId) {
                                                        push(
                                                            const CurrentUserProfile());
                                                      } else {
                                                        push(OtherUserProfile(
                                                            id: comment
                                                                .userId));
                                                      }
                                                    },
                                                    child: Text(
                                                      comment.username,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Text(comment.comment),
                                                Row(
                                                  children: [
                                                    Text(timeago.format(
                                                        comment.timeSent)),
                                                    IconButton(
                                                        iconSize: 16,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        color: isLiked
                                                            ? Colors.red
                                                            : Colors.white,
                                                        onPressed: () =>
                                                            notifier.likeComment(
                                                                comment.likes,
                                                                widget.postId,
                                                                comment
                                                                    .documentId),
                                                        icon: Icon(isLiked
                                                            ? Icons.thumb_up
                                                            : Icons
                                                                .thumb_up_outlined)),
                                                    Text(
                                                        '${text(comment.likes)}'),
                                                    const SizedBox(width: 8),
                                                    CustomButton(
                                                        width: 85,
                                                        radius: 8,
                                                        height: 35,
                                                        onPressed: () => push(
                                                                ReplyCommentsScreen(
                                                              postId:
                                                                  widget.postId,
                                                              commentId: comment
                                                                  .documentId,
                                                              replyingTo:
                                                                  comment
                                                                      .userId,
                                                              comment: comment
                                                                  .comment,
                                                              likes:
                                                                  comment.likes,
                                                              name: comment
                                                                  .username,
                                                              timeSent: comment
                                                                  .timeSent,
                                                            )),
                                                        child: Text(
                                                            'Reply ${text(comment.replies)}'))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        error: (e, t) => Center(
                              child: Text(e.toString()),
                            ),
                        loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ))),
              ],
            ),
          ),
        ),
      );
    });
  }

  Object text(List<dynamic> val) => val.isEmpty ? '' : val.length;
}
