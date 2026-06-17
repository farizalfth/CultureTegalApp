class FacilityModel {
  final String id;
  final String name;
  final String icon;

  FacilityModel({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) {
    return FacilityModel(
      id: json['id']?.toString() ?? '',
      name: json['nama_fasilitas']?.toString() ?? '',
      icon: json['icon_key']?.toString() ?? '',
    );
  }
}