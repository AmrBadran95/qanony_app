class PaymentData {
  final String? email;
  final int amount;
  final String time;

  PaymentData({
    required this.email,
    required this.amount,
    required this.time,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      email: json['email'],
      amount: json['amount'],
      time: json['time'],
    );
  }
}
