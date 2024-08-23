import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../screens/course_details.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EduEvent> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color != null
        ? colors[appointments![index].color]!
        : super.getColor(index);
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].reccurenceRule;
  }
}

class EduEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String courseId;
  final String? color;
  bool isAllDay;
  String? reccurenceRule;

  EduEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.courseId,
    this.color,
    required this.isAllDay,
    this.reccurenceRule,
  });

  EduEvent.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        startTime = map['startTime'].toDate(),
        endTime = map['endTime'].toDate(),
        courseId = map['location'],
        color = map['color'],
        isAllDay = map['isAllDay'],
        reccurenceRule = map['reccurenceRule'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime,
      'endTime': endTime,
      'courseId': courseId,
      'reccurenceRule': reccurenceRule,
      'color': color,
      'isAllDay': isAllDay,
    };
  }
}
