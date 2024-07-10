import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nami_assignment/app.dart';
import 'package:nami_assignment/core/background_service.dart';
import 'package:nami_assignment/core/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotificationsHandler.init();
  await initializeBackgroundService();

  runApp(
    const ProviderScope(
      child: SmartAttendApp(),
    ),
  );
}
