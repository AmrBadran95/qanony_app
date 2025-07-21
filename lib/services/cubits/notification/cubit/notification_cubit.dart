import 'package:bloc/bloc.dart';
import 'package:qanony/data/models/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial()) {
    loadNotifications();
  }

  List<NotificationModel> allNotifications = [];

  void loadNotifications() {
    allNotifications = [
      NotificationModel(
        title: 'تم قبول قضيتك',
        body: 'سيتم تحويلك إلى محامٍ مختص خلال دقائق.',
        date: DateTime.now().subtract(Duration(hours: 1)),
      ),
      NotificationModel(
        title: 'موعد الجلسة',
        body: 'غدًا الساعة 10 صباحًا في محكمة شمال القاهرة.',
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];
    emit(NotificationLoaded(allNotifications));
  }

  void clearNotifications() {
    allNotifications.clear();
    emit(NotificationLoaded([]));
  }
}
