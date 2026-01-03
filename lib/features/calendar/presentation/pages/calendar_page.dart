import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Imports for your architecture
import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart'; // Bloc
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
  
  // We don't initialize with dummy data anymore. 
  // We start empty and wait for Bloc to load data.
  MeetingDataSource _dataSource = MeetingDataSource([]); 
  
  CalendarView _currentView = CalendarView.month;
  String _monthName = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Trigger initial load when page opens
    // You can use LoadTasksByRangeEvent if you prefer optimization
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
      // BLOC CONSUMER: Listens to State Changes
      body: BlocConsumer<CalendarBloc, CalendarState>(
        listener: (context, state) {
          if (state is CalendarError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          
          // 1. LOADING STATE
          if (state is CalendarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. LOADED STATE (Success)
          if (state is CalendarLoaded) {
            // Convert Domain Entities -> UI Models
            final List<Meeting> meetings = state.tasks
                .map((task) => Meeting.fromEntity(task))
                .toList();
            
            // Update DataSource
            _dataSource = MeetingDataSource(meetings);
          }

          // 3. RENDER CALENDAR (With updated DataSource)
          return SfCalendar(
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
            
            // LOGIC: Handle Swipe to Load New Data (Optional optimization)
            onViewChanged: (ViewChangedDetails details) {
              final DateTime visibleDate = details.visibleDates[details.visibleDates.length ~/ 2];
              
              // Update Month Name
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if(mounted) setState(() => _monthName = DateFormat('MMMM').format(visibleDate));
                
                // OPTIONAL: Fetch data for the new visible range
                // context.read<CalendarBloc>().add(
                //   LoadTasksByRangeEvent(details.visibleDates.first, details.visibleDates.last)
                // );
              });
            },
            
            // LOGIC: Handle Taps
            onTap: (CalendarTapDetails details) {
              // EDIT MODE
              if (details.targetElement == CalendarElement.appointment) {
                final Meeting meeting = details.appointments![0];
                
                CalendarEventHandler.showEventDialog(
                  context: context,
                  bloc: context.read<CalendarBloc>(), // <--- PASS BLOC
                  existingMeeting: meeting,
                  selectedDate: meeting.from,
                );
              } 
              // ADD MODE
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
                    bloc: context.read<CalendarBloc>(), // <--- PASS BLOC
                    selectedDate: details.date!,
                  );
                }
              }
            },
            
            // LOGIC: Handle Drag & Resize (Saves to DB)
            onAppointmentResizeEnd: (details) {
              if (details.appointment is Meeting) {
                final meeting = details.appointment as Meeting;
                // Syncfusion updates the object in memory, we just need to save to DB
                context.read<CalendarBloc>().add(UpdateTaskEvent(meeting.toEntity()));
              }
            },
            onDragEnd: (details) {
              if (details.appointment is Meeting) {
                final meeting = details.appointment as Meeting;
                context.read<CalendarBloc>().add(UpdateTaskEvent(meeting.toEntity()));
              }
            },
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