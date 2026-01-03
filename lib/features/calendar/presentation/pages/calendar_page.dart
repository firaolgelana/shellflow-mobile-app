import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/adabters/meeting_data_source.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/models/meeting_model.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_utils.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_event_handler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  late MeetingDataSource _dataSource;
  
  CalendarView _currentView = CalendarView.month;
  String _monthName = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Load initial data from the Model helper
    _dataSource = MeetingDataSource(Meeting.getInitialData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1316),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () => CalendarUtils.pickDateAndJump(
            context: context, 
            controller: _calendarController
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_monthName, style: const TextStyle(color: Colors.white)),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
               setState(() => _calendarController.displayDate = DateTime.now());
            }, 
            icon: const Icon(Icons.today, color: Colors.white)
          ),
        ],
      ),
      body: SfCalendar(
        controller: _calendarController,
        dataSource: _dataSource,
        view: _currentView,
        headerHeight: 0,
        firstDayOfWeek: 1,
        allowAppointmentResize: true,
        allowDragAndDrop: true,
        backgroundColor: const Color(0xFF0F1316),
        cellBorderColor: Colors.white24,
        todayHighlightColor: Colors.tealAccent,
        
        // Styles
        viewHeaderStyle: const ViewHeaderStyle(
          backgroundColor: Color(0xFF12171A),
          dayTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dateTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        monthViewSettings: const MonthViewSettings(
          dayFormat: 'EEE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 80,
          dayFormat: 'EEE',
          timeTextStyle: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFF8AB4F8), width: 2),
          borderRadius: BorderRadius.circular(5),
        ),
        monthCellBuilder: (context, details) {
          final bool isToday = details.date.day == DateTime.now().day &&
              details.date.month == DateTime.now().month &&
              details.date.year == DateTime.now().year;
          return Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                details.date.day.toString(),
                style: TextStyle(
                  color: isToday ? Colors.tealAccent : Colors.white70,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
        // Logic
        onViewChanged: (ViewChangedDetails details) {
          final DateTime visibleDate = details.visibleDates[details.visibleDates.length ~/ 2];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if(mounted) setState(() => _monthName = DateFormat('MMMM').format(visibleDate));
          });
        },
        
// Inside _CalendarPageState build method:

        onTap: (CalendarTapDetails details) {
          // 1. CLICKED AN EXISTING APPOINTMENT (EDIT MODE)
          if (details.targetElement == CalendarElement.appointment) {
            final Meeting meeting = details.appointments![0];
            
            CalendarEventHandler.showEventDialog(
              context: context,
              dataSource: _dataSource,
              existingMeeting: meeting, // <--- Pass the existing meeting
              selectedDate: meeting.from,
            );
          } 
          // 2. CLICKED AN EMPTY CELL (ADD MODE)
          else if (details.targetElement == CalendarElement.calendarCell && details.date != null) {
            
            if (_currentView == CalendarView.month) {
               // Month view navigation logic...
               setState(() {
                _currentView = CalendarView.day;
                _calendarController.view = CalendarView.day;
                _calendarController.displayDate = details.date;
              });
            } else {
              // Open Dialog in Create Mode (existingMeeting is null by default)
              CalendarEventHandler.showEventDialog(
                context: context,
                dataSource: _dataSource,
                selectedDate: details.date!,
              );
            }
          }
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004D56),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () {
          // Open View Picker from Utils
          CalendarUtils.showViewPicker(
            context: context,
            onViewSelected: (view) {
              setState(() {
                _currentView = view;
                _calendarController.view = view;
              });
            },
          );
        },
      ),
    );
  }
}