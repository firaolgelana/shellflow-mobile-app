import 'package:flutter/material.dart';

class Meeting {
  Meeting({
    required this.id,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });

  Object id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  /// Helper to generate dummy data
  static List<Meeting> getInitialData() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    
    meetings.add(
      Meeting(
        id: 1,
        eventName: 'Conference',
        from: startTime,
        to: endTime,
        background: const Color(0xFF0F8644),
        isAllDay: false,
      ),
    );
    return meetings;
  }
}