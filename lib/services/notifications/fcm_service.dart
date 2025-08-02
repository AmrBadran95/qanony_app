import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/main.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/pages/qanony_appointments_tab.dart';
import 'package:qanony/presentation/screens/appointment_page_for_user.dart';
import 'package:qanony/presentation/screens/orders_lawyer_screen.dart';

class FCMHandler {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeFCM({
    required String userId,
    required String role,
  }) async {
    await _requestNotificationPermissionIfNeeded();
    await _messaging.requestPermission();

    final collectionMap = {'user': 'users', 'lawyer': 'lawyers'};
    final collection = collectionMap[role];
    if (collection == null) throw Exception("Invalid role: $role");

    final token = await _messaging.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .update({'fcmToken': token});
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(userId)
          .update({'fcmToken': newToken});
    });

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'qanony_channel',
      'Important Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await _localNotificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (payload) {},
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        print(message);
        final data = message.data;
        final title = data['title'] ?? message.notification?.title ?? "تنبيه";
        final body =
            data['body'] ?? message.notification?.body ?? "لديك إشعار جديد";

        showOverlayBanner(title, body, message.data);
        showLocalNotification(title, body);
      } catch (e) {
        print(e);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleNavigationFromPayload(Map<String, String>.from(message.data));
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      handleNavigationFromPayload(
        Map<String, String>.from(initialMessage.data),
      );
    }
  }

  void showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'qanony_channel',
      'Important Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  void handleNavigationFromPayload(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case "lawyer_order":
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                LawyerBaseScreen(body: OrdersLawyerScreen(), selectedIndex: 1),
          ),
        );
        break;
      case "lawyer_order_accepted":
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) => LawyerBaseScreen(
              body: QanonyAppointmentsTab(),
              selectedIndex: 2,
            ),
          ),
        );
        break;
      case "user_order":
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => AppointmentPageForUser()),
        );
        break;
      default:
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/",
          (route) => false,
        );
    }
  }

  Future<void> _requestNotificationPermissionIfNeeded() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.status;
        if (!status.isGranted) {
          final result = await Permission.notification.request();
          debugPrint('Notification permission granted: ${result.isGranted}');
        }
      }
    }
  }
}

void showOverlayBanner(String title, String body, data) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 10,
      right: 10,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.notifications, color: AppColor.light),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.title.copyWith(color: AppColor.light),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: AppText.bodyLarge.copyWith(color: AppColor.light),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3)).then((_) => overlayEntry.remove());
}
