class UserSearchModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String createdAt;
  final String? imageUrl;
  final List<FollowSearchModel> followers;
  final List<FollowSearchModel> following;

  UserSearchModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
    this.imageUrl,
    required this.followers,
    required this.following,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) {
    return UserSearchModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      following: (json['following'] as List? ?? [])
          .map((e) => FollowSearchModel.fromJson(e))
          .toList(),
      followers: (json['followers'] as List? ?? [])
          .map((e) => FollowSearchModel.fromJson(e))
          .toList(),
    );
  }
}

class FollowSearchModel {
  final String id;
  final SimpleUserModel user;

  FollowSearchModel({required this.id, required this.user});

  factory FollowSearchModel.fromJson(Map<String, dynamic> json) {
    return FollowSearchModel(
      id: json['id'],
      user: SimpleUserModel.fromJson(json['follower'] ?? json['following']),
    );
  }
}

class SimpleUserModel {
  final String id;
  final String email;
  final String fullName;

  SimpleUserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
    );
  }
}
