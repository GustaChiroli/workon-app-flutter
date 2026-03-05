import 'package:workon_app/model/post/count_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String caption;
  final String? imageUrl;
  final String? imagePublicId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PostCount count;
  final bool likedByMe;
  final String? likeId;
  final UserNameModel user;

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.imagePublicId,
    required this.createdAt,
    required this.updatedAt,
    required this.count,
    required this.likedByMe,
    required this.likeId,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      caption: json['caption'],
      imageUrl: json['imageUrl'],
      imagePublicId: json['imagePublicId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      count: PostCount.fromJson(json['_count']),
      likedByMe: json['likedByMe'] ?? false,
      likeId: json['likeId'],
      user: UserNameModel.fromJson(json['user']),
    );
  }
}

class UserNameModel {
  final String fullName;

  UserNameModel({required this.fullName});

  factory UserNameModel.fromJson(Map<String, dynamic> json) {
    return UserNameModel(fullName: json['fullName']);
  }
}
