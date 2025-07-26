import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qanony/data/models/order_model.dart';

class OrderFirestoreService {
  final _ordersCollection = FirebaseFirestore.instance.collection('orders');

  Stream<List<OrderModel>> streamAllOrders() {
    return _ordersCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList(),
    );
  }

  Stream<List<OrderModel>> streamOrdersByUserId(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<OrderModel>> streamOrdersByLawyerId(String lawyerId) {
    return _ordersCollection
        .where('lawyerId', isEqualTo: lawyerId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<OrderModel?> streamOrderById(String orderId) {
    return _ordersCollection.doc(orderId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return OrderModel.fromJson(snapshot.data()!);
      } else {
        return null;
      }
    });
  }

  Future<void> createOrder(OrderModel order) async {
    final docRef = _ordersCollection.doc();
    final orderWithId = order.copyWith(orderId: docRef.id);
    await docRef.set(orderWithId.toJson());
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    await _ordersCollection.doc(orderId).update(data);
  }

  Future<void> deleteOrder(String orderId) async {
    await _ordersCollection.doc(orderId).delete();
  }
}
