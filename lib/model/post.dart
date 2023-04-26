import 'package:media_app/model/comment.dart';

class Post {
  final String ownerId;
  final String documentId;
  final String owner;
  final String caption;
  final String videoUrl;
  final bool isFavorite;
  final DateTime dateCreated;
  final List<dynamic> likes;
  final List<dynamic> comment;
  Post({
    required this.ownerId,
    required this.documentId,
    required this.owner,
    required this.caption,
    required this.videoUrl,
    required this.isFavorite,
    required this.dateCreated,
    required this.likes,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'documentId': documentId,
      'owner': owner,
      'caption': caption,
      'videoUrl': videoUrl,
      'isFavorite': isFavorite,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'likes': likes,
      'comments': comment.map((x) => x.toMap()).toList(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      ownerId: map['ownerId'] as String,
      documentId: map['documentId'] as String,
      owner: map['owner'] as String,
      caption: map['caption'] as String,
      videoUrl: map['videoUrl'] as String,
      isFavorite: map['isFavorite'] as bool,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      likes: List<dynamic>.from(map['likes'] as List<dynamic>),
      comment: List<dynamic>.from(map['comments']),
    );
  }
}
