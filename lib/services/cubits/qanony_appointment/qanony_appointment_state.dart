import 'package:qanony/data/models/order_model.dart';

abstract class QanonyAppointmentsState {}

class QanonyAppointmentsInitial extends QanonyAppointmentsState {}

class QanonyAppointmentsLoading extends QanonyAppointmentsState {}

class QanonyAppointmentsLoaded extends QanonyAppointmentsState {
  final List<OrderModel> appointments;

  QanonyAppointmentsLoaded(this.appointments);
}

class QanonyAppointmentsError extends QanonyAppointmentsState {
  final String message;

  QanonyAppointmentsError(this.message);
}
