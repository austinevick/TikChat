class LastConversation {
  final String documentId;
  final String username;
  final String profileImageUrl;
  final bool isOnline;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;
  LastConversation({
    required this.isOnline,
    required this.documentId,
    required this.username,
    required this.profileImageUrl,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentId': documentId,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'contactId': contactId,
      'isOnline': isOnline,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory LastConversation.fromMap(Map<String, dynamic> map) {
    return LastConversation(
      documentId: map['documentId'] as String,
      isOnline: map['isOnline'] as bool,
      username: map['username'] as String,
      profileImageUrl: map['profileImageUrl'] as String,
      contactId: map['contactId'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
