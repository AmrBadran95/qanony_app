import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/repos/payment_repo.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> createPayment({
    required String clientId,
    required String lawyerId,
    required int amount,
    required String paymentType,
  }) async {
    emit(PaymentLoading());
    try {
      final clientSecret = await PaymentRepo.createLawyerPayment(
        clientId: clientId,
        lawyerId: lawyerId,
        amount: amount,
        paymentType: paymentType,
      );

      if (clientSecret != null) {
        emit(PaymentSuccess(clientSecret));
      } else {
        emit(PaymentFailure("Client secret is null"));
      }
    } catch (e) {
      emit(PaymentFailure("Unexpected error: $e"));
    }
  }
}
