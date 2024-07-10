import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/core/router.dart';
import 'package:nami_assignment/style/theme.dart';

class SmartAttendApp extends ConsumerWidget {
  const SmartAttendApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(routerProvider).when(
          loading: () => const SizedBox(),
          error: (error, stackTrace) {
            debugPrint('Error: $error');
            debugPrint(stackTrace.toString());
            return const Text("An error occurred. Please try again later.");
          },
          data: (router) {
            return MaterialApp.router(
              routerConfig: router,
              title: 'Smart Attend',
              theme: updateTextTheme(lightTheme),
            );
          },
        );
  }
}
