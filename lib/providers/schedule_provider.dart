import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  final List<Schedule> _schedules = [];

  List<Schedule> get schedules => _schedules..sort((a, b) => a.compareTo(b));

  void addSchedule(Schedule schedule) {
    _schedules.add(schedule);
    _schedules.sort((a, b) => a.compareTo(b));
    notifyListeners();
  }
}
