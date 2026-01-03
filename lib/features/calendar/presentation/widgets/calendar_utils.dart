import 'package:flutter/material.dart';
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
  
}