import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_assignment/core/extensions.dart';
import 'package:nami_assignment/modules/courses/providers.dart';
import 'package:nami_assignment/pages/course_details.dart';
import 'package:nami_assignment/style/icons.dart';
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

class _CoursesPageState extends ConsumerState<CoursesPage>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  double opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      );

      animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeOut,
        ),
      );

      setState(() {
        opacity = 1.0;
      });

      animationController!.forward();
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

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
        opacity: opacity,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: opacity,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Courses List",
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            if (animationController != null)
              AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                      (1 - animation!.value) *
                          (MediaQuery.of(context).size.width),
                      0,
                      0,
                    ),
                    child: child,
                  );
                },
                child: ref.watch(coursesProvider).when(
                      loading: () => const SizedBox(),
                      error: (error, stackTrace) => Text("Error: $error"),
                      data: (courses) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    course.name,
                                    style:
                                        context.textTheme.bodyLarge!.copyWith(
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
                              onTap: () {
                                context.pushNamed(
                                  CourseDetailsPage.routeName,
                                  pathParameters: {"name": course.name},
                                );
                              },
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 16.0,
                          ),
                        );
                      },
                    ),
              ),
            const Expanded(child: SizedBox()),
            if (animationController != null)
              AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.translationValues(
                      0,
                      (1 - animation!.value) *
                          (MediaQuery.of(context).size.height),
                      0,
                    ),
                    child: child,
                  );
                },
                child: Hero(
                  tag: "MarkAttendanceButton",
                  child: buttons.FilledButton(
                    child: Text(
                      "Mark Attendance",
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
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
