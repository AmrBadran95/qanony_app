part of 'deep_link_cubit.dart';

abstract class DeepLinkState {}

class DeepLinkInitial extends DeepLinkState {}

class DeepLinkLoading extends DeepLinkState {}

class DeepLinkSuccess extends DeepLinkState {}

class DeepLinkError extends DeepLinkState {
  final String message;
  DeepLinkError(this.message);
}
