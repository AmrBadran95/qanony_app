part of 'server_notifications_cubit.dart';

@immutable
abstract class ServerNotificationsState {}

class ServerNotificationsInitial extends ServerNotificationsState {}

class ServerNotificationsLoading extends ServerNotificationsState {}

class ServerNotificationsSuccess extends ServerNotificationsState {}

class ServerNotificationsError extends ServerNotificationsState {
  final String message;
  ServerNotificationsError(this.message);
}
