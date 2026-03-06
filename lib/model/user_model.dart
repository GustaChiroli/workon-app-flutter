class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? fitnessGoal;
  final String? createdAt;
  final double? height;
  final double? weight;
  final String? imageUrl;
  final List<FollowModel>? followers;
  final List<FollowModel>? followings;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.fitnessGoal,
    required this.createdAt,
    this.height,
    this.weight,
    required this.imageUrl,
    this.followers,
    this.followings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['fullName'],
      role: json['role'],
      fitnessGoal: json['fitnessGoal'] ?? "BUILD_MUSCLE",
      createdAt: json['createdAt'],
      height: _parseToDouble(json['height']),
      weight: _parseToDouble(json['weight']),
      imageUrl: json['imageUrl'],
      followers: (json['followers'] as List? ?? [])
          .map((e) => FollowModel.fromJson(e))
          .toList(),
      followings: (json['following'] as List? ?? [])
          .map((e) => FollowModel.fromJson(e))
          .toList(),
    );
  }

  static double? _parseToDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }
}

class FollowModel {
  final String id;
  final UserModel follower;

  FollowModel({required this.id, required this.follower});

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      id: json['id'],
      follower: UserModel.fromJson(json['follower']),
    );
  }
}

class FollowerModel {
  final String id;
  final String fullName;
  final String email;
  final List<FollowModel> followers;

  FollowerModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.followers,
  });

  factory FollowerModel.fromJson(Map<String, dynamic> json) {
    return FollowerModel(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      followers: (json['followers'] as List)
          .map((e) => FollowModel.fromJson(e))
          .toList(),
    );
  }
}
