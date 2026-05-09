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
    this.content = "Berita selengkapnya belum tersedia untuk saat ini, namun ini adalah representasi paragraf berita yang panjang agar UI terlihat penuh dan profesional. Kota Tegal terus berinovasi dalam memajukan budaya dan pariwisata daerah. Berbagai event menarik diselenggarakan untuk menarik minat wisatawan lokal maupun mancanegara.",
  });
}