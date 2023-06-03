import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_app/common/utils.dart';
import 'package:media_app/model/user_model.dart';
import 'package:media_app/screen/auth/signin_view.dart';

import '../screen/bottom_navigation_bar.dart';

final authViewController =
    StateNotifierProvider.autoDispose<AuthViewController, bool>(
        (ref) => AuthViewController(ref));

class AuthViewController extends StateNotifier<bool> {
  final Ref? ref;
  AuthViewController([this.ref]) : super(false);
  final collectionRef = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  final name = TextEditingController();
  final email1 = TextEditingController();
  final password1 = TextEditingController();
  final email2 = TextEditingController();
  final password2 = TextEditingController();

  void isAuthenticated() {
    if (auth.currentUser != null) {
      push(const SignInView());
    }
  }

  String get documentId => collectionRef.doc().id;

  Future<void> signUpWithEmailAndPassword() async {
    try {
      state = true;
      final response = await auth.createUserWithEmailAndPassword(
          email: email1.text, password: password1.text);
      final user = UserModel(
          userId: response.user!.uid,
          name: name.text,
          email: email1.text,
          isOnline: true,
          documentId: documentId,
          avatar: "",
          bio: '');
      await collectionRef.doc(response.user!.uid).set(user.toMap());
      state = false;
      if (response.user!.uid.isNotEmpty) {
        pushAndRemoveUntil(const BottomNavigationBarScreen());
      }
    } on FirebaseAuthException catch (e) {
      showBottomFlash(content: e.message);
      state = false;
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      state = true;
      final response = await auth.signInWithEmailAndPassword(
          email: email2.text, password: password2.text);
      state = false;
      if (response.user!.uid.isNotEmpty) {
        pushAndRemoveUntil(const BottomNavigationBarScreen());
      }
    } on FirebaseAuthException catch (e) {
      showBottomFlash(content: e.message);
      state = false;
      rethrow;
    }
  }

  void updateUserPresence(bool isOnline) async => await collectionRef
      .doc(auth.currentUser!.uid)
      .update({"isOnline": isOnline});

  Future<UserModel?> getUsersAsFuture() async {
    UserModel? user;
    final querySnapshot = await collectionRef.get();
    for (var users in querySnapshot.docs) {
      user = UserModel.fromMap(users.data());
    }
    return user;
  }

  Future<UserModel?> getCurrentUserById([String? id]) async {
    UserModel? user;
    final snapshot = await collectionRef
        .where('userId', isEqualTo: id ?? auth.currentUser!.uid)
        .get();
    for (var i = 0; i < snapshot.docs.length; i++) {
      user = UserModel.fromMap(snapshot.docs[i].data());
    }
    return user;
  }

  Stream<List<UserModel>> getUsersAsStream() {
    return collectionRef.snapshots().map(
        (event) => event.docs.map((e) => UserModel.fromMap(e.data())).toList());
  }

  Stream<List<UserModel>> searchUsers(String query) {
    return collectionRef.snapshots().map((event) => event.docs
        .where((element) => element
            .data()['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((e) => UserModel.fromMap(e.data()))
        .toList());
  }
}
