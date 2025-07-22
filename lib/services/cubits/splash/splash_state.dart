part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class SplashFirstLaunch extends SplashState {}

final class SplashChooseRole extends SplashState {}

final class SplashLoggedInUser extends SplashState {}

final class SplashLoggedInLawyer extends SplashState {}

class SplashLoggedInLawyerPending extends SplashState {}

class SplashLoggedInLawyerAccepted extends SplashState {}

class SplashLoggedInLawyerRejected extends SplashState {}

final class SplashError extends SplashState {}
