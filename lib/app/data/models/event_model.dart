import 'package:flutter/material.dart';

class EventHighlight {
  final String name;
  final IconData icon;

  EventHighlight({required this.name, required this.icon});

  factory EventHighlight.fromJson(Map<String, dynamic> json) {
    return EventHighlight(
      name: json['name']?.toString() ?? '',
      icon: _getEventIcon(json['icon']?.toString() ?? ''),
    );
  }

  static IconData _getEventIcon(String key) {
    switch (key.toLowerCase().trim()) {
      case 'theater_comedy_rounded':
      case 'theater':
        return Icons.theater_comedy_rounded;
      case 'soup_kitchen_rounded':
      case 'soup':
        return Icons.soup_kitchen_rounded;
      case 'storefront_rounded':
      case 'store':
        return Icons.storefront_rounded;
      case 'emoji_events_rounded':
      case 'games':
        return Icons.emoji_events_rounded;
      case 'shopping_bag_rounded':
        return Icons.shopping_bag_rounded;
      case 'mic_rounded':
        return Icons.mic_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}

class EventModel {
  final String id;
  final String name;
  final String location;
  final String detailedAddress;
  final String? imageUrl;
  final String schedule;
  final String fullDate;
  final String time;
  final String status;
  final String category;
  final String description;
  final String audience;
  final String ticketPrice;
  final bool isRecurring;
  final List<EventHighlight> highlights;
  final double latitude;
  final double longitude;
  final String badgeTop;
  final String badgeBottom;

  EventModel({
    required this.id,
    required this.name,
    required this.location,
    required this.detailedAddress,
    this.imageUrl,
    required this.schedule,
    required this.fullDate,
    required this.time,
    required this.status,
    required this.category,
    required this.description,
    required this.audience,
    required this.ticketPrice,
    this.isRecurring = false,
    this.highlights = const [],
    required this.latitude,
    required this.longitude,
    required this.badgeTop,
    required this.badgeBottom,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      detailedAddress: json['detailed_address']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
      schedule: json['schedule']?.toString() ?? '',
      fullDate: json['full_date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      audience: json['audience']?.toString() ?? '',
      ticketPrice: json['ticket_price']?.toString() ?? '',
      isRecurring: json['is_recurring'] as bool? ?? false,
      highlights:
          (json['highlights'] as List<dynamic>?)
              ?.map(
                (item) => EventHighlight.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      badgeTop: json['badge_top']?.toString() ?? '',
      badgeBottom: json['badge_bottom']?.toString() ?? '',
    );
  }
}
