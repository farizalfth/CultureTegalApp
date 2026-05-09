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
}