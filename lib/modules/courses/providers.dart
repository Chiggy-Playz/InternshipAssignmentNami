import 'package:nami_assignment/modules/courses/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Future<List<CourseModel>> courses(CoursesRef ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
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
