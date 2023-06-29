import 'package:flutter/material.dart';
import 'package:media_app/controller/post_controller.dart';
import 'package:media_app/model/post.dart';
import '../../common/utils.dart';
import '../../model/user_model.dart';
import '../chat/message_screen.dart';
import '../../widget/signin_info_dialog.dart';
import '../comments/comment_screen.dart';

class PostItems extends StatelessWidget {
  final Post post;
  final PostController postNotifier;
  const PostItems({super.key, required this.post, required this.postNotifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        postNotifier.currentUserId == post.ownerId
            ? const SizedBox.shrink()
            : IconButton(
                color: Colors.white,
                iconSize: 32,
                onPressed: () {
                  if (postNotifier.auth.currentUser == null) {
                    showDialog(
                        context: context,
                        builder: (ctx) => const SignInInfoDialog());
                    return;
                  }
                  push(MessageScreen(
                    user: UserModel(
                        userId: post.ownerId,
                        documentId: post.documentId,
                        name: post.owner),
                  ));
                },
                icon: const Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                )),
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: post.likes.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  post.likes.length.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
        ),
        IconButton(
            color:
                postNotifier.isFavorite(post.likes) ? Colors.red : Colors.white,
            iconSize: 35,
            onPressed: () {
              if (postNotifier.auth.currentUser == null) {
                showDialog(
                    context: context,
                    builder: (ctx) => const SignInInfoDialog());
                return;
              }
              postNotifier.likePost(post.likes, post.documentId);
            },
            icon: Icon(postNotifier.isFavorite(post.likes)
                ? Icons.favorite
                : Icons.favorite_border)),
        const SizedBox(width: 20),
        IconButton(
            iconSize: 35,
            onPressed: () => push(CommentScreen(postId: post.documentId)),
            icon: const Icon(Icons.comment)),
        Row(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                post.owner,
                style: const TextStyle(color: Colors.white),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  post.caption,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: CircleAvatar(),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
