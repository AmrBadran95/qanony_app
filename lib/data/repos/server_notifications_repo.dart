import 'package:dio/dio.dart';

class ServerNotificationsRepo {
  final Dio _dio = Dio();

  Future<void> sendNotification({
    required String fcmToken,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final payload = {
      "fcmToken": fcmToken,
      "title": title,
      "body": body,
      "data": data,
    };

    await _dio.post(
      'https://qanony-payment-production.up.railway.app/api/notifications/send',
      data: payload,
    );
  }
}
