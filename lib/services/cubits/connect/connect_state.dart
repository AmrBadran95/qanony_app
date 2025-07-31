part of 'connect_cubit.dart';

@immutable
abstract class ConnectState {}

class ConnectInitial extends ConnectState {}

class ConnectLoading extends ConnectState {}

class ConnectUrlLoaded extends ConnectState {
  final String url;
  ConnectUrlLoaded(this.url);
}

class ConnectError extends ConnectState {
  final String message;
  ConnectError(this.message);
}
