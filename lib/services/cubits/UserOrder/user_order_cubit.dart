import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repos/order_repository.dart';

part 'user_order_state.dart';

class UserOrderCubit extends Cubit<UserOrderState> {
  final OrderRepository _repository;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  UserOrderCubit(this._repository) : super(UserOrderInitial());

  void streamUserOrders(String userId) {
    emit(UserOrderLoading());

    _ordersSubscription?.cancel();

    _ordersSubscription = _repository.streamOrdersByUserId(userId).listen(
          (orders) {
        emit(UserOrderLoaded(orders));
      },
      onError: (error) {
        emit(UserOrderError("حدث خطأ أثناء تحميل الطلبات: $error"));
      },
    );
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    return super.close();
  }
}
