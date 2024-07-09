import 'package:nami_assignment/modules/courses/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Future<List<CourseModel>> courses(CoursesRef ref) async {
  // Simulate network delay
  await Future.delayed(Duration.zero);
  return [
    CourseModel(name: "MTL 100", location: "LH 121", time: "11:00 AM"),
    CourseModel(name: "PYL 100", location: "LH 121", time: "12:00 PM"),
    CourseModel(name: "CML 100", location: "LH 121", time: "01:00 PM"),
    CourseModel(
      name: "APL 100",
      location: "LH 121",
      time: "02:00 PM",
      attendanceMarked: true,
    ),
    CourseModel(name: "NEN 100", location: "LH 121", time: "03:00 PM"),
  ];
}

@riverpod
Future<List<CourseAttendance>> courseAttendance(CourseAttendanceRef ref) async {
  // Simulate network delay
  await Future.delayed(Duration.zero);

  final now = DateTime.now();

  return List.generate(
    7,
    (index) {
      // Generate random attendance for each day except weekends
      // Classes are held from Monday to Friday
      // So, we don't need to generate attendance for Saturday and Sunday

      final date = now.subtract(Duration(days: index));

      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        return null;
      }

      return CourseAttendance(
        date: date,
        isPresent: index != 4,
      );
    },
  ).whereType<CourseAttendance>().toList();
}
