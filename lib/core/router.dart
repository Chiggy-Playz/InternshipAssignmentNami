import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:nami_assignment/modules/login/providers.dart';
import 'package:nami_assignment/pages/login.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
Future<GoRouter> router(RouterRef ref) async {
  final authHandler = await ref.read(authHandlerProvider.future);

  return GoRouter(
    initialLocation: kDebugMode ? '/login' : '/splash_screen',
    redirect: (context, state) {
      if (authHandler == null) {
        return '/login';
      }
      return '/home';
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
