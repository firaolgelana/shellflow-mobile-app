import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/adabters/meeting_data_source.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/models/meeting_model.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_utils.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/widgets/calendar_event_handler.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _calendarController = CalendarController();
  
  // Initialize with empty list so calendar can render immediately
  MeetingDataSource _dataSource = MeetingDataSource([]); 
  
  CalendarView _currentView = CalendarView.month;
  String _monthName = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Load data silently or normally on startup
    context.read<CalendarBloc>().add(LoadAllTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1316),
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
      
      // 1. BLOC CONSUMER
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          // 2. CHECK LOADING STATUS
          final bool isLoading = state is CalendarLoading;

          // 3. UPDATE DATA ONLY IF LOADED
          // If state is Loading, we intentionally KEEP the old _dataSource
          // so the user sees the old events while the new ones load.
          if (state is CalendarLoaded) {
            final List<Meeting> meetings = state.tasks
                .map((task) => Meeting.fromEntity(task))
                .toList();
            _dataSource = MeetingDataSource(meetings);
          }

          // 4. USE A COLUMN TO STACK LOADER + CALENDAR
          return Column(
            children: [
              // --- THE LINEAR LOADER ---
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Color(0xFF1A1F23),
                  color: Colors.tealAccent, // Your Theme Color
                  minHeight: 2, // Keep it thin and sleek
                )
              else 
                // Placeholder to prevent layout jump (optional)
                const SizedBox(height: 2), 

              // --- THE CALENDAR ---
              Expanded(
                child: SfCalendar(
                  controller: _calendarController,
                  dataSource: _dataSource, // Always uses current data
                  view: _currentView,
                  headerHeight: 0,
                  firstDayOfWeek: 1,
                  allowAppointmentResize: true,
                  allowDragAndDrop: true,
                  backgroundColor: const Color(0xFF0F1316),
                  cellBorderColor: Colors.white24,
                  todayHighlightColor: Colors.tealAccent,
                  
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
                  
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment) {
                      final Meeting meeting = details.appointments![0];
                      CalendarEventHandler.showEventDialog(
                        context: context,
                        bloc: context.read<CalendarBloc>(),
                        existingMeeting: meeting,
                        selectedDate: meeting.from,
                      );
                    } 
                    else if (details.targetElement == CalendarElement.calendarCell && details.date != null) {
                      if (_currentView == CalendarView.month) {
                         setState(() {
                          _currentView = CalendarView.day;
                          _calendarController.view = CalendarView.day;
                          _calendarController.displayDate = details.date;
                        });
                      } else {
                        CalendarEventHandler.showEventDialog(
                          context: context,
                          bloc: context.read<CalendarBloc>(),
                          selectedDate: details.date!,
                        );
                      }
                    }
                  },
                  
                  onAppointmentResizeEnd: (details) {
                    if (details.appointment is Meeting) {
                      final meeting = details.appointment as Meeting;
                      context.read<CalendarBloc>().add(UpdateTaskEvent(meeting.toEntity()));
                    }
                  },
                  onDragEnd: (details) {
                    if (details.appointment is Meeting) {
                      final meeting = details.appointment as Meeting;
                      context.read<CalendarBloc>().add(UpdateTaskEvent(meeting.toEntity()));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF004D56),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () {
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