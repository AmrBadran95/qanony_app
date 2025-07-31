import 'package:dio/dio.dart';

class StripeSubscriptionRepo {
  final Dio dio;

  StripeSubscriptionRepo(this.dio);

  Future<String> payFixedSubscription({
    required String lawyerId,
    required String email,
    required String subscriptionType,
  }) async {
    try {
      final response = await dio.post(
        'https://qanony-payment-production.up.railway.app/api/subscriptions',
        data: {
          'lawyerId': lawyerId,
          'email': email,
          'subscriptionType': subscriptionType,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['clientSecret'] != null) {
        return response.data['clientSecret'];
      } else {
        throw Exception("فشل الاشتراك أو لا يوجد clientSecret");
      }
    } catch (e) {
      rethrow;
    }
  }
}
