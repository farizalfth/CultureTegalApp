import 'facility_model.dart';
import 'review_model.dart';

class CultureModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String description;
  final String image;
  final List<String> gallery;
  final String builtYear;
  final String subLocation;
  final String duration;
  final String distance;
  final String funFact;
  final double latitude;
  final double longitude;
  final bool isSlider;
  final List<FacilityModel> facilities;
  final List<ReviewModel> reviews;

  CultureModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.description,
    required this.image,
    required this.gallery,
    required this.builtYear,
    required this.subLocation,
    required this.duration,
    required this.distance,
    required this.funFact,
    required this.latitude,
    required this.longitude,
    required this.facilities,
    required this.reviews,
    this.isSlider = false,
  });

  factory CultureModel.fromJson(Map<String, dynamic> json) {
    return CultureModel(
      id: json['id']?.toString() ?? '',
      title: json['nama_tempat']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      category: json['kategori']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? '',
      image: json['image_url']?.toString() ?? '',
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      builtYear: json['tahun_dibangun']?.toString() ?? '',
      subLocation: json['lokasi_singkat']?.toString() ?? '',
      duration: json['durasi_kunjungan']?.toString() ?? '',
      distance: json['jarak_estimasi']?.toString() ?? '',
      funFact: json['fun_fact']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isSlider: json['is_slider'] as bool? ?? false,
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((item) => FacilityModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }
}