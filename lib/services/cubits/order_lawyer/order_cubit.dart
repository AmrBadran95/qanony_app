import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/models/order_model.dart';
import 'package:qanony/services/firestore/order_firestore_service.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderFirestoreService _orderService = OrderFirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrderCubit() : super(OrderInitial());

  void loadMyOrders() {
    emit(OrderLoading());

    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      emit(OrderError("لم يتم تسجيل الدخول"));
      return;
    }

    final myId = currentUser.uid;
    _orderService
        .streamOrdersByLawyerId(myId)
        .listen(
          (orders) {
            emit(OrderLoaded(orders));
          },
          onError: (error) {
            emit(OrderError('فشل في تحميل الطلبات'));
          },
        );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _orderService.updateOrder(orderId, {'status': newStatus});
      loadMyOrders();
    } catch (e) {
      emit(OrderError('فشل في تحديث الحالة'));
    }
  }
}
