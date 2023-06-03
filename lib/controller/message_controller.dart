import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../common/enum.dart';
import '../model/last_conversation.dart';
import '../model/message.dart';
import '../model/user_model.dart';
import 'auth_view_controller.dart';

final messageController = Provider((ref) => MessageController());

class MessageController {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final auth = FirebaseAuth.instance;

  String get currentUserId =>
      auth.currentUser == null ? "" : auth.currentUser!.uid;

  Stream<List<Message>> getAllOneToOneMessage(String receiverId) {
    return firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromMap(e.data())).toList());
  }

  Stream<List<LastConversation>> getAllLastMessages() {
    return firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<LastConversation> contacts = [];
      for (var document in event.docs) {
        final lastMessage = LastConversation.fromMap(document.data());
        final userData = await firestore
            .collection('users')
            .doc(lastMessage.contactId)
            .get();
        final user = UserModel.fromMap(userData.data()!);

        contacts.add(LastConversation(
            documentId: lastMessage.documentId,
            username: user.name,
            isOnline: user.isOnline!,
            profileImageUrl: user.avatar!,
            contactId: lastMessage.contactId,
            timeSent: lastMessage.timeSent,
            lastMessage: lastMessage.lastMessage));
      }
      return contacts;
    });
  }

  Future<String> _storeFileInStorage(String file) async {
    Reference ref =
        storage.ref().child('videos').child(DateTime.now().toIso8601String());
    UploadTask uploadTask = ref.putFile(File(file));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  void sendFileMessage(
      String file, String receiverId, MessageType messageType) async {
    final messageId = const Uuid().v4();
    final timeSent = DateTime.now();
    try {
      final url = await _storeFileInStorage(file);
      final receiverDoc =
          await firestore.collection('users').doc(receiverId).get();
      final receiverData = UserModel.fromMap(receiverDoc.data()!);
      final senderData = await AuthViewController().getCurrentUserById();
      String lastMessage;
      switch (messageType) {
        case MessageType.image:
          lastMessage = '📸 Photo message';
          break;
        case MessageType.audio:
          lastMessage = '📸 Voice message';
          break;
        case MessageType.video:
          lastMessage = '📸 Video message';
          break;
        case MessageType.gif:
          lastMessage = '📸 GIF message';
          break;
        default:
          lastMessage = '📦 GIF message';
          break;
      }

      saveToMessageCollection(
          receiverId: receiverId,
          textMessage: url,
          timeSent: timeSent,
          messageId: messageId,
          senderUsername: senderData!.name,
          receiverUsername: receiverData.name,
          messageType: messageType);

      saveAsLastMessage(
          senderUserData: senderData,
          receiverUserData: receiverData,
          lastMessage: lastMessage,
          timeSent: timeSent,
          receiverId: receiverId);
    } catch (e) {
      rethrow;
    }
  }

  void sentTextMessage(
      {required String textMessage, required String receiverId}) async {
    try {
      final messageId = const Uuid().v4();
      final timeSent = DateTime.now();
      final receiverDoc =
          await firestore.collection('users').doc(receiverId).get();
      final receiver = UserModel.fromMap(receiverDoc.data()!);
      final senderData = await AuthViewController().getCurrentUserById();
      saveToMessageCollection(
          receiverId: receiverId,
          textMessage: textMessage,
          timeSent: timeSent,
          messageId: messageId,
          senderUsername: senderData!.name,
          receiverUsername: receiver.name,
          messageType: MessageType.text);
      saveAsLastMessage(
          senderUserData: senderData,
          receiverUserData: receiver,
          lastMessage: textMessage,
          timeSent: timeSent,
          receiverId: receiverId);
    } catch (e) {
      rethrow;
    }
  }

  void saveToMessageCollection({
    required String receiverId,
    required String textMessage,
    required DateTime timeSent,
    required String messageId,
    required String senderUsername,
    required String receiverUsername,
    required MessageType messageType,
  }) async {
    final message = Message(
        senderId: currentUserId,
        receiverId: receiverId,
        textMessage: textMessage,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

//Sender
    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

//Receiver
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(currentUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void saveAsLastMessage({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String lastMessage,
    required DateTime timeSent,
    required String receiverId,
  }) async {
    final receiverLastMessage = LastConversation(
        documentId: const Uuid().v1(),
        profileImageUrl: senderUserData.avatar!,
        username: senderUserData.name,
        isOnline: senderUserData.isOnline!,
        contactId: senderUserData.userId,
        timeSent: timeSent,
        lastMessage: lastMessage);
    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(currentUserId)
        .set(receiverLastMessage.toMap());

    final senderLastMessage = LastConversation(
        documentId: const Uuid().v1(),
        profileImageUrl: receiverUserData.avatar!,
        username: receiverUserData.name,
        isOnline: receiverUserData.isOnline!,
        contactId: receiverUserData.userId,
        timeSent: timeSent,
        lastMessage: lastMessage);

    await firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(receiverId)
        .set(senderLastMessage.toMap());
  }

  void updateMessageNotification(bool seen, String documentId) async {
    // if (seen) {
    //   await messageReference.doc(documentId).update({"seen": false});
    //   return;
    // }
    // await messageReference.doc(documentId).update({"seen": true});
  }
}
