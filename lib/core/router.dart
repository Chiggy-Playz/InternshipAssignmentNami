import 'package:go_router/go_router.dart';
import 'package:nami_assignment/modules/courses/providers.dart';
import 'package:nami_assignment/modules/login/providers.dart';
import 'package:nami_assignment/pages/course_details.dart';
import 'package:nami_assignment/pages/courses.dart';
import 'package:nami_assignment/pages/face_detection.dart';
import 'package:nami_assignment/pages/login.dart';
import 'package:nami_assignment/pages/verification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
Future<GoRouter> router(RouterRef ref) async {
  final authHandler = await ref.watch(authHandlerProvider.future);

  return GoRouter(
    initialLocation: '/courses',
    redirect: (context, state) {
      if (authHandler == null) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: CoursesPage.routePath,
        name: CoursesPage.routeName,
        builder: (context, state) => const CoursesPage(),
      ),
      GoRoute(
        path: CourseDetailsPage.routePath,
        name: CourseDetailsPage.routeName,
        builder: (context, state) {
          // Provider can't return null as the user must need
          // the courses list in order to navigate to details
          final courses = ref.read(coursesProvider).value!;
          final course = courses
              .where((course) => course.name == state.pathParameters["name"])
              .first;

          return CourseDetailsPage(course: course);
        },
      ),
      GoRoute(
        path: FaceDetectionPage.routePath,
        name: FaceDetectionPage.routeName,
        builder: (context, state) => const FaceDetectionPage(),
      ),
      GoRoute(
        path: VerificationPage.routePath,
        name: VerificationPage.routeName,
        builder: (context, state) => const VerificationPage(),
      )
    ],
  );
}
