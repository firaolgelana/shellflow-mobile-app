import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Assuming this import exists in your project structure
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_utils.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  
  // 1. Define the DataSource as a state variable so we can access it later
  late MeetingDataSource _dataSource;
  
  CalendarView _currentView = CalendarView.month;
  String _monthName = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // 2. Initialize the data source here
    _dataSource = MeetingDataSource(_getDataSource());
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
            onPressed: () {}, 
            icon: const Icon(Icons.search, color: Colors.white)
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _calendarController.displayDate = DateTime.now();
                // Optional: Switch back to Day view on "Today" click?
                // _calendarController.view = CalendarView.day; 
                // _currentView = CalendarView.day;
              });
            },
            icon: const Icon(Icons.calendar_today_outlined, color: Colors.white)
          ),
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.check_circle_outline, color: Colors.white)
          ),
        ],
      ),
      body: SfCalendar(
        headerHeight: 0,
        firstDayOfWeek: 1,
        view: _currentView,
        controller: _calendarController,
        allowAppointmentResize: true,
        allowDragAndDrop: true,
        
        // 3. Use the state variable instance
        dataSource: _dataSource, 
        
        monthViewSettings: const MonthViewSettings(
          dayFormat: 'EEE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        backgroundColor: const Color(0xFF0F1316),
        cellBorderColor: Colors.white24,
        viewHeaderStyle: const ViewHeaderStyle(
          backgroundColor: Color(0xFF12171A),
          dayTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold),
          dateTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        headerStyle: const CalendarHeaderStyle(
          backgroundColor: Color(0xFF12171A),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 80,
          dayFormat: 'EEE',
          timeTextStyle: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
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
        onViewChanged: (ViewChangedDetails details) {
          final DateTime visibleDate =
              details.visibleDates[details.visibleDates.length ~/ 2];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _monthName = DateFormat('MMMM').format(visibleDate);
              });
            }
          });
        },
        todayHighlightColor: Colors.tealAccent,
        
        // 4. OnTap Implementation
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            // If in Month View, navigate to Day View
            if (_currentView == CalendarView.month) {
              setState(() {
                _currentView = CalendarView.day;
                _calendarController.view = CalendarView.day;
                if (details.date != null) {
                  _calendarController.displayDate = details.date;
                }
              });
            } 
            // If in Day/Week View, Open Add Dialog
            else {
               if (details.date != null) {
                 _showAddEventDialog(context, details.date!);
               }
            }
          }
        },
        selectionDecoration: BoxDecoration(
          color: Colors.transparent, 
          border: Border.all(
            color: const Color(0xFF8AB4F8), 
            width: 2, 
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004D56),
        onPressed: () => _showViewPicker(context),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting(
        id: 1, // Added ID
        eventName: 'Conference', 
        from: startTime, 
        to: endTime, 
        background: const Color(0xFF0F8644), 
        isAllDay: false
      ),
    );
    return meetings;
  }

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

  void _showAddEventDialog(BuildContext context, DateTime selectedDate) {
    final TextEditingController _titleController = TextEditingController();

    // Default event is 1 hour long
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
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Add Title",
                hintStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent),
                ),
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF004D56)),
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                // 1. Create the new meeting object
                final Meeting newMeeting = Meeting(
                  id: DateTime.now().millisecondsSinceEpoch, // Generate ID
                  eventName: _titleController.text,
                  from: startTime,
                  to: endTime,
                  background: const Color(0xFF0F8644),
                  isAllDay: false,
                );

                // 2. Add it to the data source
                _dataSource.addMeeting(newMeeting);

                // 3. Close the dialog
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// UPDATED MEETING DATA SOURCE
// -----------------------------------------------------------------------------
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  // 1. Method to Add Meeting dynamically
  void addMeeting(Meeting meeting) {
    appointments!.add(meeting);
    notifyListeners(CalendarDataSourceAction.add, [meeting]);
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }
  
  // 2. IMPORTANT: Return ID for drag/drop/resize tracking
  @override
  Object getId(int index) {
    return _getMeetingData(index).id;
  }

  // 3. IMPORTANT: Allow writing back data for Resize/Drag
  @override
  Object? convertAppointmentToObject(Object? customData, Appointment appointment) {
    final Meeting meeting = customData as Meeting;
    meeting.from = appointment.startTime;
    meeting.to = appointment.endTime;
    meeting.isAllDay = appointment.isAllDay;
    meeting.eventName = appointment.subject;
    // Don't change ID
    return meeting;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }
    return meetingData;
  }
}

// -----------------------------------------------------------------------------
// UPDATED MEETING MODEL (Includes ID)
// -----------------------------------------------------------------------------
class Meeting {
  Meeting({
    required this.id, // <--- Added ID field
    required this.eventName, 
    required this.from, 
    required this.to, 
    required this.background, 
    required this.isAllDay
  });

  Object id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}