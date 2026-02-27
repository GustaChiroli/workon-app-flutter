class PostCount {
  final int likes;
  final int comments;

  PostCount({required this.likes, required this.comments});

  factory PostCount.fromJson(Map<String, dynamic> json) {
    return PostCount(
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'likes': likes, 'comments': comments};
  }
}
