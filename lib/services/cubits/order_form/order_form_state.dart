abstract class OrderFormState {}

class OrderFormInitial extends OrderFormState {}

class OrderFormLoading extends OrderFormState {}

class OrderFormSuccess extends OrderFormState {}

class OrderFormFailure extends OrderFormState {
  final String error;

  OrderFormFailure(this.error);
}
