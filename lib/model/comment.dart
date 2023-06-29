class Comment {
  final String userId;
  final String documentId;
  final String postId;
  final String username;
  final String avatar;
  final String comment;
  final List<dynamic> likes;
  final List<dynamic> replies;
  final DateTime timeSent;
  Comment({
    required this.userId,
    required this.documentId,
    required this.postId,
    required this.username,
    required this.avatar,
    required this.comment,
    required this.likes,
    required this.replies,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'documentId': documentId,
      'postId': postId,
      'username': username,
      'avatar': avatar,
      'comment': comment,
      'likes': likes,
      'replies': replies,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      userId: map['userId'] as String,
      documentId: map['documentId'] as String,
      postId: map['postId'] as String,
      username: map['username'] as String,
      avatar: map['avatar'] as String,
      comment: map['comment'] as String,
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
      replies: List<dynamic>.from((map['replies'] as List<dynamic>)),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}

class Replies {
  final String userId;
  final String documentId;
  final String parentId;
  final String replyingTo;
  final String username;
  final String avatar;
  final String comment;
  final List<dynamic> likes;
  final DateTime timeSent;
  Replies({
    required this.userId,
    required this.documentId,
    required this.parentId,
    required this.username,
    required this.avatar,
    required this.replyingTo,
    required this.comment,
    required this.likes,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'documentId': documentId,
      'parentId': parentId,
      'username': username,
      'avatar': avatar,
      'comment': comment,
      'likes': likes,
      'replyingTo': replyingTo,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory Replies.fromMap(Map<String, dynamic> map) {
    return Replies(
      userId: map['userId'] as String,
      documentId: map['documentId'] as String,
      parentId: map['parentId'] as String,
      username: map['username'] as String,
      avatar: map['avatar'] as String,
      replyingTo: map['replyingTo'] as String,
      comment: map['comment'] as String,
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
    );
  }
}
