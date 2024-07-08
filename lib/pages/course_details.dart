import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/courses/models.dart';
import 'package:nami_assignment/modules/courses/providers.dart';
import 'package:nami_assignment/style/icons.dart';
import 'package:nami_assignment/widgets/appbar.dart' as appbar;
import 'package:nami_assignment/widgets/buttons.dart' as buttons;
import 'package:nami_assignment/widgets/icon_with_text.dart';
import 'package:nami_assignment/widgets/menu_chip.dart';

class CourseDetailsPage extends ConsumerStatefulWidget {
  const CourseDetailsPage({
    super.key,
    required this.course,
  });

  final CourseModel course;

  static const String routePath = "/course_details/:name";
  static const String routeName = "CourseDetails";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CourseDetailsPageState();
}

class _CourseDetailsPageState extends ConsumerState<CourseDetailsPage> {
  CourseModel get course => widget.course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appbar.AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                course.name,
                style: context.textTheme.headlineSmall!.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconWithWidget(
                  icon: Icon(
                    SmartAttendIcons.locationPin,
                    color: context.colorScheme.primary,
                  ),
                  text: Text(
                    course.location,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 16),
                IconWithWidget(
                  icon: Icon(
                    SmartAttendIcons.clock,
                    color: context.colorScheme.primary,
                  ),
                  text: Text(
                    course.time,
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            buttons.FilledButton(
              onPressed: () {},
              child: Text(
                "Mark Attendance",
                style: context.textTheme.bodyLarge!.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    "Attendance History and statistics",
                    style: context.textTheme.titleSmall!.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ChipMenu(
                  menuEntries: [
                    ChipMenuEntry(child: const Text("Last 30 days")),
                    ChipMenuEntry(child: const Text("Last 60 days")),
                  ],
                ),
              ],
            ),
            ref.watch(courseAttendanceProvider).when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => ListTile(
                    title: Text(
                      "Error fetching attendance data",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                    tileColor: context.colorScheme.errorContainer,
                  ),
                  data: getDatatable,
                ),
            const Expanded(child: SizedBox()),
            Text(
              "Powered by Lucify",
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget getDatatable(List<CourseAttendance> attendance) {
    return Table(
      border: TableBorder.all(
        color: Colors.transparent,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: context.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          children: [
            TableCell(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Date",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Day",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Attendance",
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        ...List.generate(
          2 * attendance.length,
          (index) {
            if (index % 2 == 0) {
              return TableRow(
                  children: List.generate(
                3,
                (_) => const SizedBox(height: 8),
              ));
            }

            return getTableRow(attendance[index ~/ 2]);

            // Otherwise return a "spacer row"
          },
        )
      ],
    );
  }

  TableRow getTableRow(CourseAttendance attendance) {
    return TableRow(
      decoration: BoxDecoration(
        color: attendance.isPresent
            ? context.customColors.successContainer
            : context.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      children: [
        TableCell(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              attendance.date.toDdMmmYyyy(),
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              attendance.date.weekdayName,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              attendance.isPresent ? "Present" : "Absent",
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
