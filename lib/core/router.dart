import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_assignment/modules/courses/providers.dart';
import 'package:nami_assignment/modules/login/models.dart';
import 'package:nami_assignment/modules/login/providers.dart';
import 'package:nami_assignment/pages/course_details.dart';
import 'package:nami_assignment/pages/courses.dart';
import 'package:nami_assignment/pages/face_detection.dart';
import 'package:nami_assignment/pages/login.dart';
import 'package:nami_assignment/pages/splash_screen.dart';
import 'package:nami_assignment/pages/verification.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
Future<GoRouter> router(RouterRef ref) async {
  final isAuth = ValueNotifier<AsyncValue<UserModel>>(const AsyncLoading());
  bool splashed = false;
  ref
    ..onDispose(isAuth.dispose)
    ..listen(
      authHandlerProvider.select(
        (value) => value.whenData(
          (value) => value,
        ),
      ),
      (s, next) {
        if (next.value == null) return;
        isAuth.value = AsyncValue.data(next.value!);
      },
    );

  return GoRouter(
    initialLocation: SplashScreenPage.routePath,
    redirect: (context, state) {
      if (!splashed) {
        splashed = true;
        return SplashScreenPage.routePath;
      }

      if (isAuth.value.isLoading) return LoginPage.routePath;

      final auth = isAuth.value.value;

      if (auth == null) return LoginPage.routePath;

      return null;
    },
    refreshListenable: isAuth,
    routes: [
      GoRoute(
        path: SplashScreenPage.routePath,
        name: SplashScreenPage.routeName,
        builder: (context, state) => const SplashScreenPage(),
      ),
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: CoursesPage.routePath,
        name: CoursesPage.routeName,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const CoursesPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
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
        pageBuilder: (context, state) {
          // Page should come from right to left

          return CustomTransitionPage(
            child: const FaceDetectionPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: const Offset(0, 0),
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
          path: VerificationPage.routePath,
          name: VerificationPage.routeName,
          pageBuilder: (context, state) {
            // Page should come from right to left
            return CustomTransitionPage(
              child: const VerificationPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: const Offset(0, 0),
                  ).animate(animation),
                  child: child,
                );
              },
            );
          })
    ],
  );
}
