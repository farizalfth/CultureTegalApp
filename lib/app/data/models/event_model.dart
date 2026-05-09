import 'package:flutter/material.dart';

class EventHighlight {
  final String name;
  final IconData icon;

  EventHighlight({required this.name, required this.icon});
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
}
