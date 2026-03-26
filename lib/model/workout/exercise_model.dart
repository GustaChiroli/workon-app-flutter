class Exercise {
  final String id;
  final String name;
  final String? description;
  final String muscleGroup;
  final bool isCardio;

  Exercise({
    required this.id,
    required this.name,
    this.description,
    required this.muscleGroup,
    required this.isCardio,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      muscleGroup: json['muscleGroup'],
      isCardio: json['isCardio'],
    );
  }
}
