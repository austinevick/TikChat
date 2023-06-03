import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/common/utils.dart';
import 'package:media_app/screen/bottom_navigation_bar.dart';
import '../model/post.dart';
import '../notification_config.dart';
import '../widget/loading_dialog.dart';
import 'auth_view_controller.dart';
import 'dart:isolate';

final postController =
    ChangeNotifierProvider.autoDispose((ref) => PostController());

class PostController extends ChangeNotifier {
  final collectionReference = FirebaseFirestore.instance.collection("users");

  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  String get currentUserId => auth.currentUser!.uid;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoadingValue(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setNotifier() => notifyListeners();

  Future<String> _uploadVideoToStorage(String videoPath) async {
    Reference ref =
        storage.ref().child('videos').child(DateTime.now().toIso8601String());
    UploadTask uploadTask = ref.putFile(File(videoPath));
    TaskSnapshot snap = await uploadTask;

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void uploadVideo(String caption, File file) async {
    try {
      String docId = collectionReference.doc().id;

      final owner = await AuthViewController().getCurrentUserById();
      final url = await _uploadVideoToStorage(file.path);
      final post = Post(
          ownerId: currentUserId,
          documentId: docId,
          likes: [],
          comment: [],
          owner: owner!.name,
          isFavorite: false,
          caption: caption,
          dateCreated: DateTime.now(),
          videoUrl: url);

      final data = await collectionReference
          .doc(currentUserId)
          .collection('posts')
          .doc(docId)
          .set(post.toMap(), SetOptions(merge: true))
          .whenComplete(() {
        showNotification('Post uploaded', 'Your post was successful');
        showBottomFlash(content: 'Your post was successful');
      });
      await Isolate.run(() => data);
    } catch (e) {
      showBottomFlash(content: e.toString());
      rethrow;
    }
  }

  void likePost(List likes, String documentId) async {
    if (likes.contains(currentUserId)) {
      await collectionReference
          .doc(currentUserId)
          .collection('posts')
          .doc(documentId)
          .update({
        "isFavorite": false,
        "likes": FieldValue.arrayRemove([currentUserId])
      });
      return;
    }
    await collectionReference
        .doc(currentUserId)
        .collection('posts')
        .doc(documentId)
        .update({
      "isFavorite": true,
      "likes": FieldValue.arrayUnion([currentUserId])
    });
  }

  bool isFavorite(List likes) {
    if (auth.currentUser == null) return false;
    return likes.contains(currentUserId) ? true : false;
  }

  Stream<List<Post>> getCurrentUserPosts() {
    return collectionReference.snapshots().map((event) => event.docs
        .where((element) => element.data()['id'] == currentUserId)
        .map((e) => Post.fromMap(e.data()))
        .toList());
  }

  Stream<List<Post>> getPosts() {
    return collectionReference
        .doc(currentUserId)
        .collection('posts')
        .snapshots()
        .map((event) => event.docs.map((e) => Post.fromMap(e.data())).toList());
  }
}
