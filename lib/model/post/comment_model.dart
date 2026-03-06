class CommentModel {
  final String id;
  final String userId;
  final String postId;
  final String content;
  final DateTime createdAt;
  final UserNameModel user;

  CommentModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      userId: json['userId'],
      postId: json['postId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      user: UserNameModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'postId': postId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserNameModel {
  final String fullName;
  final String? imageUrl;

  UserNameModel({required this.fullName, this.imageUrl});

  factory UserNameModel.fromJson(Map<String, dynamic> json) {
    return UserNameModel(
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
    );
  }
}
