import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/courses/providers.dart';
import 'package:nami_assignment/style/icons.dart';
import 'package:nami_assignment/style/theme.dart';
import 'package:nami_assignment/widgets/appbar.dart' as appbar;
import 'package:nami_assignment/widgets/buttons.dart' as buttons;

final courses = [];

class CoursesPage extends ConsumerStatefulWidget {
  const CoursesPage({super.key});

  static const String routePath = '/courses';
  static const String routeName = 'Courses';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CoursesPageState();
}

class _CoursesPageState extends ConsumerState<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar.AppBar(
        title: Text(
          "SmartAttend",
          style: TextStyle(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Courses List",
                style: context.textTheme.headlineSmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ref.watch(coursesProvider).when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Text("Error: $error"),
                  data: (courses) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        final titleTextWidget = Text(
                          course.name,
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        );
                        return ListTile(
                          title: Row(
                            children: [
                              Text(
                                course.name,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              if (course.attendanceMarked)
                                Icon(
                                  SmartAttendIcons.tickMark,
                                  color: context.customColors.success,
                                )
                            ],
                          ),
                          tileColor: course.attendanceMarked
                              ? context.customColors.successContainer
                              : null,
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16.0,
                      ),
                    );
                  },
                ),
            const Expanded(child: SizedBox()),
            buttons.FilledButton(
              child: Text(
                "Mark Attendance",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 32),
            Text(
              "Powered by Lucify",
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
