import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/models/order_model.dart';
import 'package:qanony/services/firestore/order_firestore_service.dart';

import 'order_form_state.dart';

class OrderFormCubit extends Cubit<OrderFormState> {
  final OrderFirestoreService orderService;

  OrderFormCubit({required this.orderService}) : super(OrderFormInitial());

  Future<void> submitOrder(OrderModel order) async {
    emit(OrderFormLoading());

    try {
      await orderService.createOrder(order);

      emit(OrderFormSuccess());
    } catch (e) {
      emit(OrderFormFailure(e.toString()));
    }
  }
}
