import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewPicker extends StatelessWidget {
  final ValueChanged<CalendarView> onSelect;

  const CalendarViewPicker({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1F23),
      child: Wrap(
        children: [
          _option(context, Icons.calendar_view_day, "Daily", CalendarView.day),
          _option(context, Icons.view_week, "Weekly", CalendarView.week),
          _option(context, Icons.grid_view, "Monthly", CalendarView.month),
        ],
      ),
    );
  }

  Widget _option(
    BuildContext context,
    IconData icon,
    String title,
    CalendarView view,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        onSelect(view);
        Navigator.pop(context);
      },
    );
  }
}
