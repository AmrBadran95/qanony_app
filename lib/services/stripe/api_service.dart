import 'package:dio/dio.dart';
import '../../data/models/payment_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://1c796281ddce.ngrok-free.app';

  Future<Map<String, dynamic>> createPaymentIntent(int amount, String email) async {
    try {
      final response = await _dio.post(
        '$baseUrl/create-payment-intent',
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: {
          'amount': amount,
          'email': email,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<List<PaymentData>> getPayments() async {
    try {
      final response = await _dio.get('$baseUrl/payments');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => PaymentData.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch payments');
      }
    } catch (e) {
      throw Exception('Failed to fetch payments: $e');
    }
  }
}
