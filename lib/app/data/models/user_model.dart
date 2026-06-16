class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String points;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.points = "0",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['nama'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profile_picture'],
      points: json['points']?.toString() ?? "0",
    );
  }
}
