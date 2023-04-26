class UserModel {
  final String userId;
  final String documentId;
  final String name;
  final String? email;
  final String? password;
  final bool? isOnline;
  final int? lastSeen;
  final String? avatar;
  final String? bio;

  UserModel({
    required this.userId,
    required this.documentId,
    required this.name,
    this.email,
    this.password,
    this.lastSeen,
    this.isOnline,
    this.avatar,
    this.bio,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'documentId': documentId,
      'isOnline': isOnline,
      'avatar': avatar,
      'lastSeen': lastSeen,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        userId: map['userId'] as String,
        name: map['name'] as String,
        documentId: map['documentId'] as String,
        email: map['email'] as String,
        lastSeen: map['lastSeen'],
        password: map['password'] != null ? map['password'] as String : null,
        isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
        avatar: map['avatar'] != null ? map['avatar'] as String : null,
        bio: map['bio'] != null ? map['bio'] as String : null);
  }
}
