import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// 1. Import Domain Entity
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
// 2. Import Bloc & Events
import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart';
// 3. Import UI Model
import 'package:shell_flow_mobile_app/features/calendar/presentation/models/meeting_model.dart';

class CalendarEventHandler {
  
  static void showEventDialog({
    required BuildContext context,
    required CalendarBloc bloc, // We only need Bloc, not DataSource
    DateTime? selectedDate,
    Meeting? existingMeeting,
  }) {
    final bool isEditing = existingMeeting != null;
    
    // Initialize Controllers
    final TextEditingController titleController = TextEditingController(
      text: isEditing ? existingMeeting.eventName : ''
    );
    final TextEditingController descController = TextEditingController(
      text: isEditing ? existingMeeting.description : ''
    );
    
    // Time Logic
    DateTime baseDate = selectedDate ?? DateTime.now();
    DateTime startTime = isEditing ? existingMeeting.from : baseDate;
    DateTime endTime = isEditing ? existingMeeting.to : baseDate.add(const Duration(hours: 1));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            
            // Reusable Time Picker Logic
            Future<void> pickTime({required bool isStartTime}) async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(isStartTime ? startTime : endTime),
                builder: (context, child) {
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
                  final DateTime base = isStartTime ? startTime : endTime;
                  final DateTime newDate = DateTime(base.year, base.month, base.day, pickedTime.hour, pickedTime.minute);
                  
                  if (isStartTime) {
                    startTime = newDate;
                    // Auto-adjust end time if it becomes before start time
                    if (endTime.isBefore(startTime)) {
                      endTime = startTime.add(const Duration(hours: 1));
                    }
                  } else {
                    endTime = newDate;
                  }
                });
              }
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF1A1F23),
              
              // --- HEADER ROW (Title + Delete) ---
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? "Edit Event" : "New Event", 
                    style: const TextStyle(color: Colors.white)
                  ),
                  if (isEditing) 
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                         // 1. DELETE LOGIC via BLoC
                         // Ensure ID is cast to String safely
                         final String taskId = existingMeeting.id as String;
                         bloc.add(DeleteTaskEvent(taskId));
                         
                         Navigator.pop(context);
                      },
                    )
                ],
              ),
              
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date Display
                     Text(
                      DateFormat('EEEE, MMMM d, y').format(startTime),
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 15),
                    
                    // Time Selection Row
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => pickTime(isStartTime: true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(5)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text("Start", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(DateFormat('h:mm a').format(startTime), style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => pickTime(isStartTime: false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(5)),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  const Text("End", style: TextStyle(color: Colors.white54, fontSize: 10)),
                                  Text(DateFormat('h:mm a').format(endTime), style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Title Input
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(labelText: "Title", labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent))),
                    ),
                    const SizedBox(height: 10),
                     
                    // Description Input
                    TextField(
                      controller: descController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3, minLines: 1,
                      decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.tealAccent))),
                    ),
                  ],
                ),
              ),
              
              // --- ACTIONS ---
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D56)),
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      
                      // 2. BUILD DOMAIN ENTITY
                      final CalendarTask task = CalendarTask(
                        // If Editing: Use existing ID (String). If New: null.
                        id: isEditing ? (existingMeeting.id as String) : null,
                        title: titleController.text,
                        description: descController.text,
                        startTime: startTime,
                        endTime: endTime,
                        isAllDay: false,
                        color: const Color(0xFF0F8644), // Default Green
                      );

                      // 3. DISPATCH EVENT TO BLOC
                      if (isEditing) {
                        bloc.add(UpdateTaskEvent(task));
                      } else {
                        bloc.add(CreateTaskEvent(task));
                      }
                      
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? "Update" : "Save", style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}