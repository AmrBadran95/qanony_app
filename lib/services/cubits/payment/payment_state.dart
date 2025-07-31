abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String clientSecret;
  final String orderId;

  PaymentSuccess(this.clientSecret, this.orderId);
}

class PaymentFailure extends PaymentState {
  final String error;

  PaymentFailure(this.error);
}
