import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:nami_assignment/core/notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// It's a static singleton class, you can initiate it anywhere in your app
final service = FlutterBackgroundService();

Future<void> initializeBackgroundService() async {
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

void startBackgroundService() {
  service.startService();
}

void stopBackgroundService() {
  service.invoke("stop");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  WebSocketChannel? channel;

  while (channel == null) {
    try {
      final wsUrl = Uri.parse('ws://demo.chiggydoes.tech');
      channel = WebSocketChannel.connect(wsUrl);

      await channel.ready;
    } catch (error) {
      debugPrint(
          "Whoops! Hit a snag while connecting to websocket server: $error. Retrying in 5 seconds...");
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  service.on("send").listen(
    (data) {
      if (data == null) {
        throw Exception("Event is null");
      }

      if (!data.containsKey("message")) {
        throw Exception("Event does not contain message key");
      }

      // Send data to the server
      channel!.sink.add(data["message"]);
    },
  );

  channel.stream.listen(
    (event) async {
      // Handle incoming data from the server
      debugPrint("Received data from server: $event");
      // Show a notification

      LocalNotificationsHandler.showNotification(
        // Simple way to get a unique id for the notification
        UniqueKey().hashCode,
        "Yo you got a message",
        "$event",
      );
    },
  );

  service.on("stop").listen((event) {
    service.stopSelf();
    if (channel != null) {
      channel.sink.close();
    }
    debugPrint("Background process is now stopped");
  });
}
