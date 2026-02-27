import 'package:workon_app/model/post/count_model.dart';

class PostModel {
  final String id;
  final String userId;
  final String caption;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PostCount count;
  final UserNameModel user;

  PostModel({
    required this.id,
    required this.userId,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.count,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      caption: json['caption'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      count: PostCount.fromJson(json['_count']),
      user: UserNameModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'caption': caption,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '_count': count.toJson(),
    };
  }
}

class UserNameModel {
  final String fullName;

  UserNameModel({required this.fullName});

  factory UserNameModel.fromJson(Map<String, dynamic> json) {
    return UserNameModel(fullName: json['fullName']);
  }
}
