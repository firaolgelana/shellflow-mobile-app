import 'package:flutter/material.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String monthName;
  final VoidCallback onMonthTap;
  final VoidCallback onTodayTap;

  const CalendarAppBar({
    super.key,
    required this.monthName,
    required this.onMonthTap,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F1316),
      elevation: 0,
      leading: const Icon(Icons.menu, color: Colors.white),
      title: InkWell(
        onTap: onMonthTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(monthName, style: const TextStyle(color: Colors.white)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
          onPressed: onTodayTap,
        ),
        IconButton(
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
