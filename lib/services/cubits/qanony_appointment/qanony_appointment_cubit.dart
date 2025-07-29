import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/data/models/order_status_enum.dart';
import 'package:qanony/services/cubits/qanony_appointment/qanony_appointment_state.dart';
import 'package:qanony/services/firestore/order_firestore_service.dart';

class QanonyAppointmentsCubit extends Cubit<QanonyAppointmentsState> {
  final OrderFirestoreService _orderService;
  final String lawyerId;

  QanonyAppointmentsCubit(this._orderService, this.lawyerId)
    : super(QanonyAppointmentsInitial()) {
    fetchAppointments();
  }

  void fetchAppointments() {
    emit(QanonyAppointmentsLoading());

    _orderService.streamAllOrders().listen(
      (orders) {
        final filtered = orders.where((order) {
          final statusString = orderStatusToString(order.status);
          return order.lawyerId == lawyerId &&
              (statusString == 'accepted_by_lawyer' ||
                  statusString == 'payment_done');
        }).toList();

        emit(QanonyAppointmentsLoaded(filtered));
      },
      onError: (e) {
        emit(QanonyAppointmentsError(e.toString()));
      },
    );
  }
}
