import 'package:latlong2/latlong.dart';

enum MapItemType { culture, event, umkm }

class MapItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final LatLng coordinate;
  final MapItemType type;
  final String infoTag;
  final double rating;
  final dynamic originalModel;

  MapItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.coordinate,
    required this.type,
    required this.infoTag,
    this.rating = 0.0,
    required this.originalModel,
  });
}
