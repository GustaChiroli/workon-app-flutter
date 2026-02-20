class UserModel {
  final String id;
  final String email;
  final String? name;
  final String role;
  final String? fitnessGoal;
  final String createdAt;
  final double? height;
  final double? weight;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.fitnessGoal,
    required this.createdAt,
    this.height,
    this.weight,
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
