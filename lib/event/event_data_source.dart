import 'dart:ui';

import 'package:flutter_event_manager/event/event_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
 //data source 
class EventDataSource extends CalendarDataSource{
  EventDataSource(List<EventModel> source){
    appointments =source;
  }
  @override 
  DateTime getStartTime(int index){
    EventModel item = appointments!.elementAt(index);
    return item.startTime;
  }
  @override 
  DateTime getEndTime(int index){
    EventModel item = appointments!.elementAt(index);
    return item.endTime;
  }
  @override
  String getSubject(int index){
    EventModel item = appointments!.elementAt(index);
    return item.subject;
  }
  @override
  String? getNotes(int index) {
    // TODO: implement getNotes
    EventModel item = appointments!.elementAt(index);
    return item.notes;
  }
  @override
  bool isAllDay(int index) {
    EventModel item =appointments!.elementAt(index);
    // TODO: implement isAllDay
    return item.isAllDay;
  }
  @override
  String? getRecurrenceRule(int index) {
    EventModel item =appointments!.elementAt(index);
    // TODO: implement getRecurrenceRule
    return item.recurrenceRule;
  }
  @override
  Color getColor(int index) {
    // TODO: implement getColor
    EventModel item = appointments!.elementAt(index);
    return item.isAllDay ? const Color(0xFF0F8644): super.getColor(index);
  }
}