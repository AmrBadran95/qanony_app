part of 'decider_cubit.dart';

@immutable
sealed class DeciderState {}

final class DeciderInitial extends DeciderState {}
final class DeciderOnboarding extends DeciderState {}
final class DeciderChooseRole extends DeciderState {}
