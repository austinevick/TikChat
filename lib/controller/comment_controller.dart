import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../model/comment.dart';
import 'auth_view_controller.dart';

final commentController = Provider((ref) => CommentController());

class CommentController {
  final collectionReference = FirebaseFirestore.instance;

  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser!.uid;

  void commentOnPost(String postId, String comment) async {
    try {
      final user = await AuthViewController().getUsersAsFuture();
      final documentId = const Uuid().v4();
      final commentData = Comment(
          userId: user!.userId,
          documentId: documentId,
          postId: postId,
          username: user.name,
          avatar: '',
          comment: comment,
          likes: [],
          replies: [],
          timeSent: DateTime.now());
      await collectionReference
          .collection("users")
          .doc(currentUserId)
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(documentId)
          .set(commentData.toMap());
    } catch (e) {
      print(e);
    }
  }

  void replyComments(
      String postId, String parentId, String replyingTo, String comment) async {
    final user = await AuthViewController().getUsersAsFuture();
    final documentId = const Uuid().v4();
    final replies = Replies(
        userId: user!.userId,
        documentId: documentId,
        parentId: parentId,
        username: user.name,
        avatar: '',
        replyingTo: replyingTo,
        comment: comment,
        likes: [],
        timeSent: DateTime.now());
    await collectionReference
        .collection("users")
        .doc(currentUserId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(parentId)
        .collection('replies')
        .doc(documentId)
        .set(replies.toMap());

    await collectionReference
        .collection("users")
        .doc(currentUserId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(parentId)
        .update({
      'replies': FieldValue.arrayUnion([documentId])
    });
  }

  Stream<List<Replies>> getReplies(String postId, String parentId) {
    return collectionReference
        .collection("users")
        .doc(currentUserId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(parentId)
        .collection('replies')
        .snapshots()
        .map((event) => event.docs
            .where((element) => element.data()['parentId'] == parentId)
            .map((e) => Replies.fromMap(e.data()))
            .toList());
  }

  Stream<List<Comment>> getComments(String postId) {
    return collectionReference
        .collection("users")
        .doc(currentUserId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timeSent')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Comment.fromMap(e.data())).toList());
  }

  void likeComment(List likes, String postId, String commentId) async {
    if (likes.contains(currentUserId)) {
      await collectionReference
          .collection('users')
          .doc(currentUserId)
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({
        "likes": FieldValue.arrayRemove([currentUserId])
      });
      return;
    }
    await collectionReference
        .collection('users')
        .doc(currentUserId)
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      "likes": FieldValue.arrayUnion([currentUserId])
    });
  }
}
