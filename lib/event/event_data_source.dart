import 'dart:ui';

import 'package:event_manager/event/event_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventModel> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.startTime!;
  }

  @override
  DateTime getEndTime(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.endTime!;
  }

  @override
  String getSubject(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.subject;
  }

  @override
  String? getNotes(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.notes;
  }

  @override
  bool isAllDay(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.isAllDay;
  }

  @override
  String? getRecurrenceRule(int index) {
    EventModel event = appointments!.elementAt(index);
    return event.recurrenceRule;
  }

  @override
  Color getColor(int index) {
    EventModel item = appointments!.elementAt(index);
    return item.isAllDay ? const Color(0xFF42A5F5) : super.getColor(index);
  }
}
