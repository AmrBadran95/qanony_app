import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../data/models/payment_model.dart';

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  Future<Map<String, dynamic>> createPaymentIntent(
    int amount,
    String email,
  ) async {
    final url = Uri.parse('$baseUrl/create-payment-intent');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': amount, 'email': email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create payment intent');
    }
  }

  Future<List<PaymentData>> getPayments() async {
    final url = Uri.parse('$baseUrl/payments');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PaymentData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch payments');
    }
  }
}
