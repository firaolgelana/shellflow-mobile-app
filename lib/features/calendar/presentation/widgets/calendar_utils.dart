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
//event add dialog
static void showAddEventDialog({
    required BuildContext context,
    required DateTime selectedDate,
    required MeetingDataSource dataSource,
  }) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController(); // Description Controller
    
    // Mutable variables for time logic
    DateTime startTime = selectedDate;
    DateTime endTime = selectedDate.add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder allows us to call setState INSIDE the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            
            // Helper function to pick time
            Future<void> pickTime({required bool isStartTime}) async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(isStartTime ? startTime : endTime),
                builder: (context, child) {
                  // Apply your Dark Theme to the TimePicker
                  return Theme(
                    data: Theme.of(context).copyWith(
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: const Color(0xFF1A1F23),
                        hourMinuteTextColor: Colors.white,
                        dayPeriodTextColor: Colors.tealAccent,
                        dialHandColor: const Color(0xFF004D56),
                        dialBackgroundColor: Colors.white10,
                        helpTextStyle: const TextStyle(color: Colors.white),
                        entryModeIconColor: Colors.tealAccent,
                        cancelButtonStyle: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white70)),
                        confirmButtonStyle: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.tealAccent)),
                      ),
                      colorScheme: const ColorScheme.dark(
                        surface: Color(0xFF1A1F23),
                        onSurface: Colors.white,
                        primary: Color(0xFF004D56),
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedTime != null) {
                setState(() {
                  final DateTime baseDate = isStartTime ? startTime : endTime;
                  final DateTime newDateTime = DateTime(
                    baseDate.year,
                    baseDate.month,
                    baseDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  if (isStartTime) {
                    startTime = newDateTime;
                    // Auto-adjust end time if it becomes before start time
                    if (endTime.isBefore(startTime)) {
                      endTime = startTime.add(const Duration(hours: 1));
                    }
                  } else {
                    endTime = newDateTime;
                  }
                });
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF1A1F23),
              title: const Text("New Event", style: TextStyle(color: Colors.white)),
              content: SingleChildScrollView( // Added scroll for small screens
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- DATE DISPLAY ---
                    Text(
                      DateFormat('EEEE, MMMM d, y').format(startTime),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 15),

                    // --- ADJUSTABLE TIME ROW ---
                    Row(
                      children: [
                        // Start Time Button
                        Expanded(
                          child: InkWell(
                            onTap: () => pickTime(isStartTime: true),
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Start", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(
                                    DateFormat('h:mm a').format(startTime),
                                    style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
                        const SizedBox(width: 10),
                        // End Time Button
                        Expanded(
                          child: InkWell(
                            onTap: () => pickTime(isStartTime: false),
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("End", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(
                                    DateFormat('h:mm a').format(endTime),
                                    style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- TITLE INPUT ---
                    TextField(
                      controller: titleController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.white54),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // --- DESCRIPTION INPUT (OPTIONAL) ---
                    TextField(
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3, // Make it taller
                      minLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Description (Optional)",
                        labelStyle: TextStyle(color: Colors.white54),
                        alignLabelWithHint: true, // Aligns label to top
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.tealAccent)),
                      ),
                    ),
                  ],
                ),
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
                        description: descController.text, // Save Description
                        from: startTime, // Use updated start time
                        to: endTime, // Use updated end time
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
            );
          },
        );
      },
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