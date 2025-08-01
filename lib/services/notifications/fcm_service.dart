import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qanony/Core/styles/color.dart';
import 'package:qanony/core/styles/text.dart';
import 'package:qanony/main.dart';
import 'package:qanony/presentation/pages/lawyer_base_screen.dart';
import 'package:qanony/presentation/screens/appointment_page_for_user.dart';
import 'package:qanony/presentation/screens/orders_lawyer_screen.dart';

class FCMHandler {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initializeFCM({
    required String userId,
    required String role,
  }) async {
    await _messaging.requestPermission();

    final collectionMap = {
      'user': 'users',
      'lawyer': 'lawyers',
      'admin': 'admins',
    };
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notification = message.notification!;
        final title = notification.title ?? 'بدون عنوان';
        final body = notification.body ?? 'بدون محتوى';

        showOverlayBanner(title, body);
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

  void handleNavigationFromPayload(Map<String, dynamic> data) {
    final type = data['type'];

    switch (type) {
      case "lawyer_order":
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                LawyerBaseScreen(body: OrdersLawyerScreen(), selectedIndex: 2),
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
}

void showOverlayBanner(String title, String body) {
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

  Future.delayed(const Duration(seconds: 3)).then((_) {
    overlayEntry.remove();
  });
}
