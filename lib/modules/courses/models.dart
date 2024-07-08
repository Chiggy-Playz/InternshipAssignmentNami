class CourseModel {
  final String name;
  final String location;
  final String time;
  final bool attendanceMarked;

  CourseModel({
    required this.name,
    required this.location,
    required this.time,
    this.attendanceMarked = false,
  });
}

class CourseAttendance {
  final DateTime date;
  final bool isPresent;

  CourseAttendance({
    required this.date,
    required this.isPresent,
  });
}
