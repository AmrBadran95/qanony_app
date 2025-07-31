import 'package:dio/dio.dart';

class ConnectRepo {
  final Dio _dio = Dio();
  final String _baseUrl =
      'https://qanony-payment-production.up.railway.app/api/stripe-connect';

  Future<String> createConnectAccount({
    required String lawyerId,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/create-connect-account',
        data: {'lawyerId': lawyerId, 'email': email},
      );

      if (response.statusCode == 200 && response.data['url'] != null) {
        return response.data['url'] as String;
      } else {
        throw Exception('فشل إنشاء حساب Connect - لا يوجد رابط');
      }
    } catch (e) {
      rethrow;
    }
  }
}
