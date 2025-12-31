import 'package:flutter/material.dart';
Widget quickActions() {
  final Map<IconData, String> actions = {
    Icons.add: 'Add new task',
    Icons.calendar_today: 'Create weekly plan',
    Icons.schedule: 'Auto schedule',
    Icons.event: 'View calendar',
  };

  final entries = actions.entries.toList();

  return GridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    childAspectRatio: 1.7,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(10),
    children: List.generate(entries.length, (index) {
      final icon = entries[index].key;
      final label = entries[index].value;

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.black12, width: 1.5),
          padding: const EdgeInsets.all(12),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }),
  );
}
