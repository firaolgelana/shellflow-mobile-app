import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/models/meeting_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  // Helper to add a meeting and notify the UI
  void addMeeting(Meeting meeting) {
    appointments!.add(meeting);
    notifyListeners(CalendarDataSourceAction.add, [meeting]);
  }

  @override
  DateTime getStartTime(int index) => _getMeetingData(index).from;

  @override
  DateTime getEndTime(int index) => _getMeetingData(index).to;

  @override
  String getSubject(int index) => _getMeetingData(index).eventName;

  @override
  Color getColor(int index) => _getMeetingData(index).background;

  @override
  bool isAllDay(int index) => _getMeetingData(index).isAllDay;

  @override
  Object getId(int index) => _getMeetingData(index).id;

  @override
  Object? convertAppointmentToObject(Object? customData, Appointment appointment) {
    final Meeting meeting = customData as Meeting;
    meeting.from = appointment.startTime;
    meeting.to = appointment.endTime;
    meeting.isAllDay = appointment.isAllDay;
    meeting.eventName = appointment.subject;
    return meeting;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    if (meeting is Meeting) return meeting;
    throw "Invalid Data";
  }
}