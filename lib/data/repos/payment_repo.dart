import 'package:dio/dio.dart';

final Dio _dio = Dio();

class PaymentRepo {
  static Future<String?> createLawyerPayment({
    required String orderId,
    required String lawyerId,
  }) async {
    try {
      final response = await _dio.post(
        'https://qanony-payment-production.up.railway.app/api/payments/create-client-payment-intent',
        data: {"orderId": orderId, "lawyerId": lawyerId},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final clientSecret = response.data['result']['clientSecret'];
      return clientSecret;
    } catch (e) {
      return null;
    }
  }
}
