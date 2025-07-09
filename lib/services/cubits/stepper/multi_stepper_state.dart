part of 'multi_stepper_cubit.dart';

@immutable
sealed class MultiStepperState {}

class MultiStepperInitial extends MultiStepperState {}

class MultiStepperStepChanged extends MultiStepperState {
  final int stepIndex;
  MultiStepperStepChanged(this.stepIndex);
}

class MultiStepperStepError extends MultiStepperState {
  final int stepIndex;
  MultiStepperStepError(this.stepIndex);
}

class MultiStepperSubmitted extends MultiStepperState {}
