class NewsModel {
  final String id;
  final String title;
  final String category;
  final String date;
  final String image;
  final String content;

  NewsModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.image,
    required this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
    );
  }
}
