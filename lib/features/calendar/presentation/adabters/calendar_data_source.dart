// presentation/adapters/calendar_data_source.dart
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDataSourceImpl extends CalendarDataSource {
  CalendarDataSourceImpl(List<CalendarTask> events) {
    appointments = events.map(_toAppointment).toList();
  }

  Appointment _toAppointment(CalendarTask event) {
    return Appointment(
      id: event.id,
      subject: event.title,
      startTime: event.startTime,
      endTime: event.endTime,
    );
  }
}
