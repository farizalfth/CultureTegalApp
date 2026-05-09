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
}