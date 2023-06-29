import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/comment_controller.dart';
import '../../model/comment.dart';
import '../../widget/custom_textfield.dart';

class ReplyCommentsScreen extends StatefulWidget {
  final String postId;
  final String commentId;
  final String replyingTo;
  final String comment;
  final DateTime timeSent;
  final String name;
  final List<dynamic> likes;
  const ReplyCommentsScreen(
      {super.key,
      required this.postId,
      required this.commentId,
      required this.replyingTo,
      required this.comment,
      required this.timeSent,
      required this.name,
      required this.likes});

  @override
  State<ReplyCommentsScreen> createState() => _ReplyCommentsScreenState();
}

class _ReplyCommentsScreenState extends State<ReplyCommentsScreen> {
  final replyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      const BackButton(),
                      const Text(
                        'Replies',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.clear))
                    ],
                  ),
                  StreamBuilder<List<Replies>>(
                      stream: ref
                          .watch(commentController)
                          .getReplies(widget.postId, widget.commentId),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Column(
                          children: [
                            Material(
                              color: const Color(0xff1d212b),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(radius: 15),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${widget.name} • 4hr ago ',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Text(widget.comment),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () {},
                                              child: const Icon(
                                                  Icons.thumb_up_outlined,
                                                  size: 15)),
                                          const SizedBox(width: 4),
                                          Text(
                                            widget.likes.length.toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.comment,
                                                  size: 15))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                                children: List.generate(
                              snapshot.data!.length,
                              (i) => snapshot.data!.isEmpty
                                  ? const Center()
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const CircleAvatar(radius: 15),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${snapshot.data![i].username} • 4hr ago ',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child:
                                                Text(snapshot.data![i].comment),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 40),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                    onTap: () {},
                                                    child: const Icon(
                                                        Icons.thumb_up_outlined,
                                                        size: 15)),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  '2',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.comment,
                                                        size: 15))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ))
                          ],
                        );
                      })
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomTextfield(
                controller: replyCtrl,
                hintText: 'Add a reply',
                hasBorderside: false,
                prefixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.insert_emoticon)),
                suffixIcon: IconButton(
                    onPressed: () async {
                      ref.read(commentController).replyComments(widget.postId,
                          widget.commentId, widget.replyingTo, replyCtrl.text);
                      setState(() => replyCtrl.clear());
                    },
                    icon: const Icon(Icons.send_outlined)),
              ),
            )
          ],
        ),
      );
    });
  }
}
