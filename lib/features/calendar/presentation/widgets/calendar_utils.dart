import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/adabters/meeting_data_source.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/models/meeting_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarUtils {
  
  static Future<void> pickDateAndJump({
    required BuildContext context,
    required CalendarController controller,
    bool isInputMode = false,
    Color dialogColor = const Color(0xFF1A1F23),
    Color accentColor = const Color(0xFF004D56),
    Color textColor = Colors.white,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.displayDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialEntryMode: isInputMode 
          ? DatePickerEntryMode.input 
          : DatePickerEntryMode.calendar,
      
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentColor,
              onPrimary: textColor,
              surface: dialogColor,
              onSurface: textColor,
            ),
            
            // 1. FIX THE TEXT TYPING COLOR
            // This forces the text you type (e.g., "01/03/2026") to be White
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: textColor), 
              bodyMedium: TextStyle(color: textColor),
            ),

            // 2. FIX THE LABEL AND HINT COLORS
            inputDecorationTheme: InputDecorationTheme(
              // Color of the label "Enter Date"
              labelStyle: TextStyle(color: textColor.withOpacity(0.8)), 
              // Color of the placeholder "mm/dd/yyyy"
              hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
              // Color of the "Enter Date" label when it moves to the top
              floatingLabelStyle: TextStyle(color: accentColor),
              
              // Optional: Customize the underline border color
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.3)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: accentColor),
              ),
            ),

            // Style the OK/Cancel buttons
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: accentColor,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            
            // Style the Header
            datePickerTheme: DatePickerThemeData(
              headerBackgroundColor: const Color(0xFF12171A),
              headerForegroundColor: textColor,
              surfaceTintColor: Colors.transparent,
            ),
            
            dialogBackgroundColor: dialogColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.displayDate = picked;
    }
  }

  // 2. Add Event Dialog logic
  static void showAddEventDialog({
    required BuildContext context,
    required DateTime selectedDate,
    required MeetingDataSource dataSource,
  }) {
    final TextEditingController titleController = TextEditingController();
    final DateTime startTime = selectedDate;
    final DateTime endTime = selectedDate.add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F23),
        title: const Text("New Event", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${DateFormat('EEE, MMM d').format(startTime)}  •  ${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}",
              style: const TextStyle(color: Colors.tealAccent, fontSize: 14),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: titleController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Add Title",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.tealAccent)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF004D56)),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final Meeting newMeeting = Meeting(
                  id: DateTime.now().millisecondsSinceEpoch,
                  eventName: titleController.text,
                  from: startTime,
                  to: endTime,
                  background: const Color(0xFF0F8644),
                  isAllDay: false,
                );
                dataSource.addMeeting(newMeeting);
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 3. View Picker (Daily/Weekly/Monthly) Bottom Sheet
  static void showViewPicker({
    required BuildContext context,
    required Function(CalendarView) onViewSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F23),
      builder: (context) => Wrap(
        children: [
          _buildViewOption(context, Icons.calendar_view_day, "Daily", CalendarView.day, onViewSelected),
          _buildViewOption(context, Icons.view_week, "Weekly", CalendarView.week, onViewSelected),
          _buildViewOption(context, Icons.grid_view, "Monthly", CalendarView.month, onViewSelected),
        ],
      ),
    );
  }

  static Widget _buildViewOption(BuildContext context, IconData icon, String title, CalendarView view, Function(CalendarView) onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        onTap(view);
        Navigator.pop(context);
      },
    );
  }
}