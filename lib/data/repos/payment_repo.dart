import 'package:dio/dio.dart';

final Dio _dio = Dio();

class PaymentRepo {
  static Future<String?> createLawyerPayment({
    required String clientId,
    required String lawyerId,
    required int amount,
    required String paymentType,
  }) async {
    try {
      final response = await _dio.post(
        'https://yourserver.com/api/payments/lawyer-payout',
        data: {
          "clientId": clientId,
          "lawyerId": lawyerId,
          "amount": amount,
          "paymentType": paymentType,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final clientSecret = response.data['clientSecret'];
      return clientSecret;
    } catch (e) {
      print("Error creating lawyer payment: $e");
      return null;
    }
  }
}
