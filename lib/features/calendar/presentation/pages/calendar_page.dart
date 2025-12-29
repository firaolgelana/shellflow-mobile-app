import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  
  // State variable to hold the visible month name
  String _monthName = DateFormat('MMMM').format(DateTime.now());
  CalendarView _currentView = CalendarView.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1316),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1316),
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.white),
        // Wrap the title in an InkWell to make it clickable
        title: InkWell(
          onTap: () => _selectDate(context), // Opens date picker
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_monthName, style: const TextStyle(color: Colors.white)),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white)),
          IconButton(
            onPressed: () {
              // Quick jump back to today
              setState(() {
                _calendarController.displayDate = DateTime.now();
              });
            }, 
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.white)
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.check_circle_outline, color: Colors.white)),
        ],
      ),
      body: SfCalendar(
        controller: _calendarController,
        view: _currentView,
        dataSource: _getDataSource(),
        backgroundColor: const Color(0xFF0F1316),
        cellBorderColor: Colors.white10,
        
        // This function triggers every time you scroll/swipe
        onViewChanged: (ViewChangedDetails details) {
          // Get the date in the middle of the visible dates to determine the month
          DateTime visibleDate = details.visibleDates[details.visibleDates.length ~/ 2];
          
          // Update the month name in the AppBar
          // Use 'MMMM yyyy' if you want "November 2025"
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _monthName = DateFormat('MMMM').format(visibleDate);
            });
          });
        },

        viewHeaderStyle: const ViewHeaderStyle(
          dayTextStyle: TextStyle(color: Colors.white, fontSize: 13),
          dateTextStyle: TextStyle(color: Colors.white, fontSize: 13),
        ),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          monthCellStyle: MonthCellStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 12),
            trailingDatesTextStyle: TextStyle(color: Colors.white24),
            leadingDatesTextStyle: TextStyle(color: Colors.white24),
            todayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        headerHeight: 0, // Hidden because we use our custom AppBar
        todayHighlightColor: Colors.blue,
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004D56),
        onPressed: () => _showViewPicker(context),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  // Logic for the Dropdown: Pick a date and jump the calendar to it
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _calendarController.displayDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      // Styling the picker to match your dark theme
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF004D56), // Selection color
              onPrimary: Colors.white,
              surface: Color(0xFF1A1F23),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _calendarController.displayDate = picked;
      });
    }
  }

  // (Keeping your existing _showViewPicker and _getDataSource logic here...)
  void _showViewPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F23),
      builder: (context) => Wrap(
        children: [
          _viewOption(Icons.calendar_view_day, "Daily", CalendarView.day),
          _viewOption(Icons.view_week, "Weekly", CalendarView.week),
          _viewOption(Icons.grid_view, "Monthly", CalendarView.month),
        ],
      ),
    );
  }

  Widget _viewOption(IconData icon, String title, CalendarView view) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() {
          _currentView = view;
          _calendarController.view = view;
        });
        Navigator.pop(context);
      },
    );
  }

  _DataSource _getDataSource() {
    return _DataSource(<Appointment>[
      Appointment(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        subject: 'System Design',
        color: Colors.blue,
      )
    ]);
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) { appointments = source; }
}