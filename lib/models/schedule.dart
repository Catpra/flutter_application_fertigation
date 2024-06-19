class Schedule {
  int hour;
  int minute;
  int duration; // duration in seconds

  Schedule({required this.hour, required this.minute, required this.duration});

  int get totalMinutes => hour * 60 + minute;

  int compareTo(Schedule other) {
    return totalMinutes.compareTo(other.totalMinutes);
  }
}
