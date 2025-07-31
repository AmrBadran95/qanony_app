part of 'stripe_subscription_cubit.dart';

abstract class StripeSubscriptionState {}

class StripeSubscriptionInitial extends StripeSubscriptionState {}

class StripeSubscriptionLoading extends StripeSubscriptionState {}

class StripeSubscriptionSuccess extends StripeSubscriptionState {
  final String clientSecret;

  StripeSubscriptionSuccess(this.clientSecret);
}

class StripeSubscriptionError extends StripeSubscriptionState {
  final String message;

  StripeSubscriptionError(this.message);
}
