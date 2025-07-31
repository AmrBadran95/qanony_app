import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/repos/stripe_subscription_repo.dart';

part 'stripe_subscription_state.dart';

class StripeSubscriptionCubit extends Cubit<StripeSubscriptionState> {
  final StripeSubscriptionRepo subscriptionRepo;

  StripeSubscriptionCubit(this.subscriptionRepo)
    : super(StripeSubscriptionInitial());

  Future<void> subscribe({
    required String lawyerId,
    required String email,
    required String subscriptionType,
  }) async {
    emit(StripeSubscriptionLoading());
    try {
      final clientSecret = await subscriptionRepo.payFixedSubscription(
        lawyerId: lawyerId,
        email: email,
        subscriptionType: subscriptionType,
      );
      emit(StripeSubscriptionSuccess(clientSecret));
    } catch (e) {
      emit(StripeSubscriptionError(e.toString()));
    }
  }
}
