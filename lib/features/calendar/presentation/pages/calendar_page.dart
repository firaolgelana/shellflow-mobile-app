import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:shell_flow_mobile_app/features/calendar/presentation/adabters/calendar_data_source.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_app_bar.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_view_picker.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();

  late CalendarDataSourceImpl _dataSource;
  Appointment? _draftAppointment;

  String _monthName = DateFormat('MMMM').format(DateTime.now());
  CalendarView _currentView = CalendarView.month;

  @override
  void initState() {
    super.initState();
    _dataSource = CalendarDataSourceImpl([]);
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1316),

      appBar: CalendarAppBar(
        monthName: _monthName,
        onMonthTap: () => _selectDate(context),
        onTodayTap: _jumpToToday,
      ),

      body: _buildCalendar(),

      floatingActionButton: _draftAppointment == null
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF004D56),
              onPressed: () => _showViewPicker(context),
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            )
          : FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _confirmDraft,
              child: const Icon(Icons.check, size: 30, color: Colors.white),
            ),
    );
  }

  // ================= CALENDAR =================

  Widget _buildCalendar() {
    return SfCalendar(
      controller: _calendarController,
      view: _currentView,
      dataSource: _dataSource,

      backgroundColor: const Color(0xFF0F1316),
      cellBorderColor: Colors.white10,
      headerHeight: 0,
      todayHighlightColor: Colors.blue,

      allowDragAndDrop: true,
      allowAppointmentResize: true,

      timeSlotViewSettings: const TimeSlotViewSettings(
        timeIntervalHeight: 80,
        timeTextStyle: TextStyle(color: Colors.white70, fontSize: 12),
      ),

      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
      ),

      onLongPress: _onLongPress,
      onTap: _onTap,
      onViewChanged: _onViewChanged,

      onAppointmentResizeEnd: _onResizeEnd,
      onDragEnd: _onDragEnd,
    );
  }

  // ================= INTERACTIONS =================

  void _onLongPress(CalendarLongPressDetails details) {
    if (_currentView != CalendarView.day) return;
    if (details.targetElement != CalendarElement.calendarCell) return;

    final DateTime start = details.date!;
    _createDraftAppointment(start);
  }

  void _onTap(CalendarTapDetails details) {
    if (details.date == null) return;

    if (_currentView == CalendarView.month &&
        details.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _currentView = CalendarView.day;
        _calendarController.view = CalendarView.day;
        _calendarController.displayDate = details.date;
      });
    }
  }

  // ================= DRAFT LOGIC =================

  void _createDraftAppointment(DateTime startTime) {
    final DateTime snappedStart = _snapTo30Minutes(startTime);

    final Appointment appointment = Appointment(
      startTime: snappedStart,
      endTime: snappedStart.add(const Duration(hours: 1)),
      subject: '(No title)',
      color: Colors.blue.withOpacity(0.4),
    );

    setState(() {
      if (_draftAppointment != null) {
        _dataSource.appointments!.remove(_draftAppointment);
        _dataSource.notifyListeners(
          CalendarDataSourceAction.remove,
          <Appointment>[_draftAppointment!],
        );
      }

      _draftAppointment = appointment;
      _dataSource.appointments!.add(appointment);
      _dataSource.notifyListeners(
        CalendarDataSourceAction.add,
        <Appointment>[appointment],
      );
    });
  }

  void _onResizeEnd(AppointmentResizeEndDetails details) {
    setState(() {
      _draftAppointment = details.appointment as Appointment;
    });
  }

  void _onDragEnd(AppointmentDragEndDetails details) {
    setState(() {
      _draftAppointment = details.appointment as Appointment;
    });
  }

  void _confirmDraft() {
    setState(() {
      _draftAppointment = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task saved (UI only)')),
    );
  }

  // ================= UTILS =================

  DateTime _snapTo30Minutes(DateTime time) {
    final int minutes = time.minute;
    final int snapped = (minutes / 30).round() * 30;

    return DateTime(
      time.year,
      time.month,
      time.day,
      time.hour,
      snapped,
    );
  }

  void _onViewChanged(ViewChangedDetails details) {
    final visibleDate =
        details.visibleDates[details.visibleDates.length ~/ 2];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _monthName = DateFormat('MMMM').format(visibleDate);
      });
    });
  }

  void _jumpToToday() {
    setState(() {
      _calendarController.displayDate = DateTime.now();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _calendarController.displayDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF004D56),
            surface: Color(0xFF1A1F23),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _calendarController.displayDate = picked;
      });
    }
  }

  void _showViewPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => CalendarViewPicker(
        onSelect: (view) {
          setState(() {
            _currentView = view;
            _calendarController.view = view;
          });
        },
      ),
    );
  }
}
