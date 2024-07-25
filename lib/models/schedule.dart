class Schedule {
  int hour;
  int minute;
  int durationArea1;
  int durationArea2;
  int durationArea3;

  Schedule(
      {required this.hour,
      required this.minute,
      required this.durationArea1,
      required this.durationArea2,
      required this.durationArea3});

  int get totalMinutes => hour * 60 + minute;

  int compareTo(Schedule other) {
    return totalMinutes.compareTo(other.totalMinutes);
  }
}
