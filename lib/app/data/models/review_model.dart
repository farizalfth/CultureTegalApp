class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String date;
  final double rating;
  final String comment;
  final List<String> reviewImages;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.date,
    required this.rating,
    required this.comment,
    required this.reviewImages,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Anonim',
      userAvatar: json['user_avatar']?.toString() ?? 'https://i.pravatar.cc/150',
      date: _formatDate(json['created_at']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['komentar']?.toString() ?? '',
      reviewImages: (json['review_images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  static String _formatDate(dynamic dateString) {
    if (dateString == null) return "Baru saja";
    try {
      final DateTime parsed = DateTime.parse(dateString.toString());
      final Duration difference = DateTime.now().difference(parsed);

      if (difference.inDays > 30) {
        return "${parsed.day}-${parsed.month}-${parsed.year}";
      } else if (difference.inDays > 0) {
        return "${difference.inDays} hari lalu";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} jam lalu";
      } else {
        return "Baru saja";
      }
    } catch (_) {
      return "Baru saja";
    }
  }
}