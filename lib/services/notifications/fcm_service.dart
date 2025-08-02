import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qanony/main.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/pages/qanony_appointments_tab.dart';
import 'package:qanony/presentation/screens/appointment_page_for_user.dart';
import 'package:qanony/presentation/screens/orders_lawyer_screen.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await FCMHandler.instance.setupFlutterNotifications();
  await FCMHandler.instance.showNotification(message);
}

class FCMHandler {
  FCMHandler._();
  static final FCMHandler instance = FCMHandler._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationInitialized = false;

  Future<void> initializeFCM(String userId, String role) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();

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

    await _requestNotificationPermissionIfNeeded();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationInitialized) return;

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null) {
          try {
            final data = jsonDecode(payload);
            handleNavigationFromPayload(data);
          } catch (e) {
            handleNavigationFromPayload({'type': payload});
          }
        }
      },
    );

    _isFlutterLocalNotificationInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleBackgroundMessage(message);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    handleNavigationFromPayload(Map<String, String>.from(message.data));
  }

  void handleNavigationFromPayload(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'lawyer_order':
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                LawyerBaseScreen(body: OrdersLawyerScreen(), selectedIndex: 1),
          ),
        );
        break;

      case 'lawyer_order_accepted':
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) => LawyerBaseScreen(
              body: QanonyAppointmentsTab(),
              selectedIndex: 2,
            ),
          ),
        );
        break;

      case 'user_order':
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => AppointmentPageForUser()),
        );
        break;

      default:
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/',
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
