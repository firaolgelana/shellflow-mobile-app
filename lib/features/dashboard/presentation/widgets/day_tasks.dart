import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/stat_item.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/stat_card.dart';

Widget dayTaskSummaryGrid() {
  final items = [
    StatItem(
      title: 'Total Tasks',
      subtitle: 'Tasks scheduled for today',
      count: 0,
      icon: Icons.list_alt,
      iconColor: Colors.grey,
    ),
    StatItem(
      title: 'Completed',
      subtitle: 'Tasks completed today',
      count: 0,
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ),
    StatItem(
      title: 'Pending',
      subtitle: 'Tasks remaining',
      count: 0,
      icon: Icons.access_time,
      iconColor: Colors.amber,
    ),
    StatItem(
      title: 'Overdue',
      subtitle: 'Tasks past deadline',
      count: 2,
      icon: Icons.error,
      iconColor: Colors.red,
    ),
  ];

  return GridView.builder(
    shrinkWrap: true, // ⭐ important
    
    physics: const NeverScrollableScrollPhysics(), // ⭐ important
    padding: const EdgeInsets.all(16),
    itemCount: items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // 2 × 2 grid
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4, // adjust card height
    ),
    itemBuilder: (context, index) {
      return StatCard(item: items[index]);
    },
  );
}
