part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistered extends AuthState {
  final String uid;
  AuthRegistered(this.uid);
}

class AuthLoggedIn extends AuthState {
  final String uid;
  AuthLoggedIn(this.uid);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
