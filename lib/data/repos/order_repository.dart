import '../../data/models/order_model.dart';
import '../../services/firestore/order_firestore_service.dart';

class OrderRepository {
  final OrderFirestoreService _orderService;

  OrderRepository({OrderFirestoreService? orderService})
    : _orderService = orderService ?? OrderFirestoreService();

  Stream<List<OrderModel>> streamOrdersByUserId(String userId) {
    return _orderService.streamOrdersByUserId(userId);
  }
}
