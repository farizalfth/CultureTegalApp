class UmkmModel {
  final String id;
  final String name;
  final String price;
  final String storeName;
  final String image;
  final String category;
  final double rating;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? storeAddress;
  final String? whatsappNumber;
  final String? externalLink;
  final String? adminId;

  UmkmModel({
    required this.id,
    required this.name,
    required this.price,
    required this.storeName,
    required this.image,
    required this.category,
    required this.rating,
    this.description,
    this.latitude,
    this.longitude,
    this.storeAddress,
    this.whatsappNumber,
    this.externalLink,
    this.adminId,
  });

  factory UmkmModel.fromJson(Map<String, dynamic> json) {
    return UmkmModel(
      id: json['id']?.toString() ?? '',
      name: json['nama_produk']?.toString() ?? '',
      price: json['harga']?.toString() ?? '',
      storeName: json['nama_toko']?.toString() ?? '',
      image: json['image_url']?.toString() ?? '',
      category: json['kategori']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['deskripsi']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      storeAddress: json['alamat_toko']?.toString(),
      whatsappNumber: json['no_whatsapp']?.toString(),
      externalLink: json['link_eksternal']?.toString(),
      adminId: json['admin_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_produk': name,
      'harga': price,
      'nama_toko': storeName,
      'image_url': image,
      'kategori': category,
      'rating': rating,
      'deskripsi': description,
      'latitude': latitude,
      'longitude': longitude,
      'alamat_toko': storeAddress,
      'no_whatsapp': whatsappNumber,
      'link_eksternal': externalLink,
      'admin_id': adminId,
    };
  }
}
