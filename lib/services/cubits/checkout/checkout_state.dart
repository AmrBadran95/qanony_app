
part of 'checkout_cubit.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}
class CheckoutLoadedWithData extends CheckoutState {
  final List<PaymentData> payments;
  CheckoutLoadedWithData(this.payments);
}


class CheckoutSuccess extends CheckoutState {}

class CheckoutFailure extends CheckoutState {
  final String error;
  CheckoutFailure(this.error);
}
