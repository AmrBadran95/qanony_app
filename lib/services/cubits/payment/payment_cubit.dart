import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/repos/payment_repo.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> createPayment({
    required String orderId,
    required String lawyerId,
  }) async {
    emit(PaymentLoading());
    try {
      final clientSecret = await PaymentRepo.createLawyerPayment(
        orderId: orderId,
        lawyerId: lawyerId,
      );

      if (clientSecret != null) {
        emit(PaymentSuccess(clientSecret, orderId));
      } else {
        emit(PaymentFailure("Client secret is null"));
      }
    } catch (e) {
      emit(PaymentFailure("Unexpected error: $e"));
    }
  }
}
