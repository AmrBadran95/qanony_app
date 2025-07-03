part of 'onboarding_cubit.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {
  final int pageIndex;

  OnboardingInitial({this.pageIndex = 0});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is OnboardingInitial && pageIndex == other.pageIndex;
  }

  @override
  int get hashCode => pageIndex.hashCode;
}
