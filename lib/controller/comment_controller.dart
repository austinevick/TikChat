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
