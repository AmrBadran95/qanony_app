part of 'user_order_cubit.dart';

@immutable
sealed class UserOrderState {}

final class UserOrderInitial extends UserOrderState {}
final class UserOrderLoading extends UserOrderState {}
final class UserOrderLoaded extends UserOrderState {
  final List<OrderModel> orders;

  UserOrderLoaded(this.orders);
}
final class UserOrderError extends UserOrderState {
  final String message;

  UserOrderError(this.message);
}