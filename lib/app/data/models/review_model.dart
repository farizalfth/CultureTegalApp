class ReviewModel {
  final String id;
  final String userName;
  final String userAvatar;
  final String date;
  final double rating;
  final String comment;
  final String? reviewImage;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.rating,
    required this.comment,
    this.reviewImage,
  });
}