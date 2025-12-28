import 'package:flutter/material.dart';
class StatItem {
  final String title;
  final String subtitle;
  final int count;
  final IconData icon;
  final Color iconColor;

  StatItem({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.iconColor,
  });
}
