
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/payment_model.dart';
import '../../stripe/api_service.dart';
import '../../stripe/stripe_service.dart';


part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final ApiService apiService;
  final StripeService stripeService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  CheckoutCubit(this.apiService, this.stripeService) : super(CheckoutInitial());

  Future<void> startCheckout(int amount,String email,String planType) async {
    emit(CheckoutLoading());

    try {
      final paymentData = await apiService.createPaymentIntent(amount, email);
      print('paymentData = $paymentData');


      await stripeService.initPaymentSheet(
        paymentIntentClientSecret: paymentData['clientSecret'],
      );

      await stripeService.presentPaymentSheet();

      emit(CheckoutSuccess());
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      await _firestore.collection('lawyers').doc(uid).update({
        'subscriptionType': planType,
        'subscriptionStart': DateTime.now().toIso8601String(),
        'subscriptionEnd': DateTime.now().add(Duration(days: 30)).toIso8601String(),
      });
      final payments = await apiService.getPayments();

      emit(CheckoutLoadedWithData(payments));

    } catch (e, stackTrace) {
      print('Checkout error: $e');
      print(stackTrace);
      emit(CheckoutFailure(e.toString()));
    }

  }
}
